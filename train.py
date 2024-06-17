# CuNNy corrector/trainer
# Copyright (c) 2024 funnyplanter
# SPDX-License-Identifier: 	LGPL-3.0-or-later
import os
import sys
import argparse
import torch
import torch.nn as nn
import torch.nn.functional as F
import itertools
import pickle
import tqdm
from torch.utils.tensorboard import SummaryWriter
from collections import OrderedDict
from multiprocessing import Pool
from torchvision import transforms
from torcheval.metrics.functional import peak_signal_noise_ratio as psnr
from PIL import Image

# epochs
E = 500
# batch size
B = 64
# learning rate
LR = 0.0001
# max learning rate with OneCycleLR
MAX_LR = 0.001
# weight decay
W = 0.001

def split(l, v):
    return [list(g) for k, g in itertools.groupby(l, lambda x: x != v) if k]

argvs = split(sys.argv[1:], '++')
gargv, argv = argvs if len(argvs) == 2 else ([], *argvs)

parser = argparse.ArgumentParser()
parser.add_argument('data', type=str)
parser.add_argument('-R', '--rgb', action='store_true')
gargs = parser.parse_args(gargv)

RGB = gargs.rgb

parser = argparse.ArgumentParser()
parser.add_argument('N', type=int)
parser.add_argument('D', type=int)
parser.add_argument('-s', '--suffix', type=str, default=None)
parser.add_argument('-e', '--epochs', type=int, default=E)
parser.add_argument('-b', '--batch', type=int, default=B)
parser.add_argument('-l', '--lr', type=float, default=LR)
parser.add_argument('-L', '--max-lr', type=float, default=MAX_LR)
parser.add_argument('-w', '--weight-decay', type=float, default=W)
parser.add_argument('-C', '--crelu', action='store_true')
parser.add_argument('-2', '--l2', action='store_true')
parser.add_argument('-q', '--quant', action='store_true')
parser.add_argument('-Q', '--quant-8', action='store_true')
allargs = [parser.parse_args(args) for args in split(argv, '+')]

hascuda = torch.cuda.is_available()
torch.multiprocessing.set_sharing_strategy('file_system')
dev = torch.device('cuda' if hascuda else 'cpu')
if hascuda:
    torch.backends.cuda.matmul.allow_tf32 = True
    torch.backends.cuda.matmul.allow_bf16_reduced_precision_reduction = True
    torch.backends.cudnn.allow_tf32 = True
    torch.backends.cudnn.benchmark = True

def load(dir, file, variants):
    fn = os.path.join(dir, file)
    if not os.path.exists(fn):
        fn = fn.replace('png', 'jpg')
    out = []
    with Image.open(fn) as img:
        for v in variants:
            out += [img.convert(v)]
    return out

def loadall(pool, dir, files, transform, variants):
    vs = ((dir, file, variants) for file in files)
    return [list(map(lambda x: transform(x).to(dev), imgs))
            for imgs in list(pool.starmap(load, vs))]

class Dataset(torch.utils.data.Dataset):
    def __init__(self, dirx, dirtrue, transform):
        self.files = os.listdir(dirtrue)
        with Pool() as pool:
            if RGB:
                self.x, xl = zip(*loadall(
                    pool, dirx, self.files, transform, ['RGB', 'L']))
            else:
                self.x = [x[0] for x in loadall(
                    pool, dirx, self.files, transform, ['L'])]
                xl = self.x
            self.y = [F.interpolate(
                x.unsqueeze(dim=0), scale_factor=2, mode='bilinear',
                align_corners=False).squeeze(dim=0) for x in xl]
            self.true = [x[0] for x in loadall(
                pool, dirtrue, self.files, transform, ['L'])]

    def __len__(self):
        return len(self.files)

    def __getitem__(self, idx):
        return self.x[idx], self.y[idx], self.true[idx], self.files[idx]

transform = transforms.Compose([transforms.ToTensor()])
dataset = Dataset(f'{gargs.data}/64', f'{gargs.data}/128', transform)

for args in allargs:
    # internal convolutions
    N  = args.N
    # feature layers/depth
    D = args.D
    E = args.epochs
    B = args.batch
    LR = args.lr
    MAX_LR = args.max_lr
    CRELU = args.crelu
    W = args.weight_decay
    QUANT_8 = args.quant_8
    QUANT = args.quant or QUANT_8

    QUANT_F = 127.
    QUANT_DF = 1. / QUANT_F
    use_quant = False

    dataloader = torch.utils.data.DataLoader(dataset, batch_size=B, shuffle=True)

    act_leak = 0.01
    def act(x):
        if QUANT:
            a = act_leak
            relu = lambda x: torch.clamp(x, 0., 1.) + a * F.relu(x - 1.)
        else:
            relu = F.relu
        if CRELU:
            # negated seems to train smoother
            return torch.cat((relu(x), -relu(-x)), dim=1)
        else:
            return relu(x)
    
    weight_leak = 0.05
    class QuantConv2d(nn.Module):
        def __init__(self, in_channels, out_channels, kernel_size,
                     bias=True):
            super(QuantConv2d, self).__init__()
            if not type(kernel_size) in [list, tuple]:
                kernel_size = (kernel_size, kernel_size)
            self.weight = nn.Parameter(torch.empty(
                (out_channels, in_channels, *kernel_size)))
            if bias:
                self.bias = nn.Parameter(torch.empty(1, out_channels, 1, 1))
            else:
                self.register_parameter('bias', None)

        def forward(self, x):
            w = self.weight
            a = weight_leak
            w = (torch.clamp(w, -1., 1.) +
                 a * (torch.minimum(w + 1., torch.tensor(0.)) +
                      torch.maximum(w - 1., torch.tensor(0.))))
            if use_quant:
                x = (x.clamp(-1., 1.) * QUANT_F).round()
                w = (self.weight.clamp(-1., 1.) * QUANT_F).round()
                return F.conv2d(x, w, padding='same') * QUANT_DF**2 + self.bias
            else:
                return F.conv2d(x, w, self.bias.view(-1), padding='same')

    class Net(nn.Module):
        def __init__(self):
            super(Net, self).__init__()
            M = 2 if CRELU else 1
            if RGB:
                self.fancyluma = nn.Conv2d(3, 1, 1, padding='same')
            self.cin = nn.Conv2d(1, D, 3, padding='same')
            self.conv = nn.ModuleList()
            for i in range(N):
                if QUANT_8:
                    c = QuantConv2d(M * D, D, 3)
                else:
                    c = nn.Conv2d(M * D, D, 3, padding='same')
                if CRELU:
                    nn.init.xavier_normal_(
                        c.weight, gain=nn.init.calculate_gain('linear'))
                else:
                    nn.init.kaiming_normal_(
                        c.weight, mode='fan_out', nonlinearity='relu')
                nn.init.zeros_(c.bias)
                self.conv.append(c)
            if QUANT_8:
                self.cout = QuantConv2d(M * D, 4, 3)
            else:
                self.cout = nn.Conv2d(M * D, 4, 3, padding='same')
            if CRELU:
                nn.init.xavier_normal_(
                   self.cin.weight, gain=nn.init.calculate_gain('linear'))
            else:
                nn.init.kaiming_normal_(
                   self.cin.weight, mode='fan_out', nonlinearity='relu')
            nn.init.xavier_normal_(
               self.cout.weight, gain=nn.init.calculate_gain('tanh'))
            nn.init.zeros_(self.cin.bias)
            nn.init.zeros_(self.cout.bias)

        def forward(self, x, y):
            if RGB:
                x = self.fancyluma(x)
            x = act(self.cin(x))
            for conv in self.conv:
                x = act(conv(x))
            x = F.tanh(self.cout(x))
            x = F.pixel_shuffle(x, 2)
            x = torch.add(x, y)
            return torch.clamp(x, 0., 1.)

    model = Net()
    if hascuda:
        model = model.to(dev, memory_format=torch.channels_last)
    loss_fn = nn.MSELoss() if args.l2 else nn.L1Loss()

    fn = ''
    suf = (
        ('RGB-' if RGB else '') +
        (args.suffix + '-' if args.suffix else '')
    )
    version = f'{N}x{D}{"C" if CRELU else ""}-{suf}'

    i = 0
    while os.path.exists((fn := f'models/{version}{i}.pickle')):
        i += 1

    def fwd(model, x, y, true, opt, train):
        opt.zero_grad(True)
        pred = model(x, y)
        loss = loss_fn(pred, true)
        if train:
            loss.backward()
        return pred, loss

    def run_epoch(model, dev, epoch, fwd_fn, opt, sched, writer, train):
        nloss = 0
        runloss = 0.
        for i, (x, y, true, files) in enumerate(dataloader):
            pred, loss = fwd_fn(model, x.to(dev), y.to(dev), true.to(dev), opt,
                                train)
            if train:
                opt.step()
                sched.step()
            runloss += loss
            nloss += 1
            lasty = y
        with torch.no_grad():
            avgl = runloss / nloss
            if writer and (epoch % 20 == 0 or epoch == E - 1):
                diff = true[0] - pred[0]
                norm = lambda x: torch.clamp(x / 0.2, 0., 1.)
                diffs = [torch.stack((
                    norm(-torch.min(diff[i], torch.tensor(0))),
                    norm(torch.max(diff[i], torch.tensor(0))),
                    torch.zeros_like(diff[i]))) for i in range(diff.shape[0])]
                imgs = (lasty, pred, true)
                writer.add_images(
                    'imgs',
                    torch.stack(
                        tuple(x[0, 0].expand(3, -1, -1)
                              for x in imgs if len(x[0]) > 0) + tuple(diffs)),
                    global_step=epoch)
            if writer:
                writer.add_scalar('L', avgl, epoch + 1)
                psnrv = psnr(pred, true)
                writer.add_scalar('psnr', psnrv, epoch + 1)
        return avgl

    def run(model, name=None, dev=dev, callback=None, lr=LR, max_lr=MAX_LR, *,
            epochs, compile, train):
        if train:
            model = model.train()
        else:
            model = model.eval()
        writer = SummaryWriter(name, flush_secs=1) if name else None
        fwd_fn = torch.compile(fwd, mode=('max-autotune' if hascuda else
                                          'default')) if compile else fwd
        opt = torch.optim.AdamW(
            model.parameters(), lr=lr, weight_decay=args.weight_decay)
        sched = torch.optim.lr_scheduler.OneCycleLR(
            opt, max_lr=max_lr, steps_per_epoch=len(dataloader),
            epochs=epochs) if train else None
        def impl():
            epoch = 0
            for i in (t := tqdm.trange(epochs)):
                if callback:
                    callback(i)
                loss = run_epoch(model, dev, epoch, fwd_fn, opt, sched, writer,
                                 train)
                t.set_description(f'L: {loss:.5f}')
                epoch += 1
        if train:
            impl()
        else:
            with torch.no_grad():
                impl()
        if writer:
            writer.flush()

    writer_name = fn.replace('models/', 'runs/')

    print(f'training {fn}')
    with torch.autocast('cuda' if hascuda else 'cpu', dtype=torch.bfloat16):
        run(model, name=writer_name, epochs=E, compile=True, train=True)

        if QUANT_8:
            weight_leak = 0.00001
            act_leak = 0.00001
            run(model, lr=LR / 10., max_lr=LR, epochs=E // 10, compile=True,
                train=True)
            weight_leak = 0.
            act_leak = 0.
            use_quant = True
            run(model, epochs=10, compile=False, train=False)

    sd = OrderedDict()

    sd['quant'] = QUANT
    sd['quant-8'] = QUANT_8
    for k, v in model.state_dict().items():
        sd[k] = v.cpu().numpy() if hasattr(v, 'numpy') else v
    sd['crelu'] = CRELU

    with open(fn, 'wb') as f:
        pickle.dump(sd, f, protocol=pickle.HIGHEST_PROTOCOL)
    with open('test/last.txt', 'w') as f:
        f.write(fn)
