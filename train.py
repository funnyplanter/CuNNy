# CuNNy corrector/trainer
# Copyright (c) 2024 funnyplanter
# SPDX-License-Identifier: 	LGPL-3.0-or-later
import os
import sys
import argparse
import torch
import itertools
import pickle
import tqdm
import numpy as np
from torch import nn
from torch.nn import functional as F
from torch.utils.tensorboard import SummaryWriter
from collections import OrderedDict
from multiprocessing import Pool
from torchvision.transforms import v2
from PIL import Image

# epochs
E = 500
# batch size
B = 64
# learning rate
LR = 0.00001
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
parser.add_argument('N', type=int, nargs='?')
parser.add_argument('D', type=int, nargs='?')
parser.add_argument('-c', '--custom', type=str)
parser.add_argument('-s', '--suffix', type=str)
parser.add_argument('-e', '--epochs', type=int, default=E)
parser.add_argument('-b', '--batch', type=int, default=B)
parser.add_argument('-l', '--lr', type=float, default=LR)
parser.add_argument('-L', '--max-lr', type=float, default=MAX_LR)
parser.add_argument('-w', '--weight-decay', type=float, default=W)
parser.add_argument('-2', '--l2', action='store_true')
parser.add_argument('-q', '--quant', action='store_true')
parser.add_argument('-Q', '--quant-8', action='store_true')
parser.add_argument('-t', '--test', type=str)
parser.add_argument('-r', '--resume', type=str)
all_args = [parser.parse_args(args) for args in split(argv, '+')]

has_cuda = torch.cuda.is_available()
torch.multiprocessing.set_sharing_strategy('file_system')
dev = torch.device('cuda' if has_cuda else 'cpu')
if has_cuda:
    torch.backends.cuda.matmul.allow_tf32 = True
    torch.backends.cuda.matmul.allow_bf16_reduced_precision_reduction = True
    torch.backends.cudnn.allow_tf32 = True
    torch.backends.cudnn.benchmark = True

is_win = sys.platform.startswith('win')

def load(dir, file, variants):
    fn = os.path.join(dir, file)
    if not os.path.exists(fn):
        fn = fn.replace('png', 'jpg')
    out = []
    with Image.open(fn) as img:
        for v in variants:
            if v == 'RGB' and len(img.getbands()) > 1:
                out += [img.copy()]
                continue
            out += [img.convert(v)]
    return out

def load_all(pool, dir, files, transform, variants):
    vs = ((dir, file, variants) for file in files)
    def starmap(fn, args):
        # TODO: fix multiprocessing
        if is_win:
            r = []
            for arg in args:
                r += [fn(*arg)]
            return r
        return list(pool.starmap(fn, args))
    return [list(map(lambda x: transform(x).to(dev), imgs))
            for imgs in tqdm.tqdm(starmap(load,
                tqdm.tqdm(vs, total=len(files), desc='loading images')),
                          desc='transforming images')]

RGB_YCBCR = torch.tensor([
    [0.2627, 0.678, 0.0593],
    [-0.1396, -0.3604, 0.5],
    [0.5, -0.4598, -0.0402]], device=dev)
def rgb_to_ycbcr(x):
    return torch.einsum('mkyx,nk->mnyx', x, RGB_YCBCR) if RGB else x

class Dataset(torch.utils.data.Dataset):
    def __init__(self, dir_x, dir_true, transform):
        self.files = os.listdir(dir_true)
        with Pool() as pool:
            fmt = 'RGB' if RGB else 'L'
            self.x = [x[0] for x in load_all(
                pool, dir_x, self.files, transform, [fmt])]
            self.y = [F.interpolate(
                x.unsqueeze(dim=0), scale_factor=2, mode='bilinear',
                align_corners=False).squeeze(dim=0) for x in tqdm.tqdm(
                    self.x, desc='scaling images')]
            self.true = [x[0] for x in load_all(
                pool, dir_true, self.files, transform, [fmt])]

    def __len__(self):
        return len(self.files)

    def __getitem__(self, idx):
        return self.x[idx], self.y[idx], self.true[idx], self.files[idx]

autocast_dtype = torch.float32 if is_win else torch.bfloat16

transform = v2.Compose([
    v2.PILToTensor(),
    v2.ConvertImageDtype(autocast_dtype)
])
dataset = Dataset(f'{gargs.data}/64', f'{gargs.data}/128', transform)

def model_size(layers):
    v = 0
    for i in range(len(layers) - 1):
        v += layers[i] * layers[i + 1]
    return v

for args in all_args:
    if not args.custom:
        NAME = f'{args.N}x{args.D}'
        LAYERS = [args.D] * (args.N + 1)
    else:
        custom = args.custom.split(' ')
        NAME = custom[0]
        LAYERS = []
        for s in custom[1:]:
            v = s.split('x')
            LAYERS += [int(v[-1])] * (1 if len(v) == 1 else int(v[0]))
        assert(len(LAYERS) >= 2)
    SIZE = model_size([3 if RGB else 1] + LAYERS + [4*(3 if RGB else 1)])
    E = args.epochs
    B = args.batch
    LR = args.lr
    MAX_LR = args.max_lr
    W = args.weight_decay
    QUANT_8 = args.quant_8
    QUANT = args.quant or QUANT_8

    QUANT_F = 127.
    QUANT_DF = 1. / QUANT_F
    use_quant = False

    filename = ''
    suf = '-' + args.suffix if args.suffix else ''
    name = NAME + suf
    version = name
    i = 0
    while os.path.exists('models/' + (filename := f'{version}-{i}.pickle')):
        i += 1
    writer_name = 'runs/' + filename

    sd = OrderedDict()
    sd['size'] = SIZE
    sd['layers'] = LAYERS
    sd['args'] = sys.argv
    sd['rgb'] = RGB
    sd['quant'] = QUANT
    sd['quant-8'] = QUANT_8
    sd['name'] = name

    dataloader = torch.utils.data.DataLoader(
        dataset, batch_size=B, shuffle=True, drop_last=True)

    act_leak = 0.01
    def act(x):
        if QUANT:
            a = act_leak
            relu = lambda x: torch.clamp(x, 0., 1.) + a * F.relu(x - 1.)
        else:
            relu = F.relu
        return relu(x)

    weight_leak = 0.9
    quant_a = 0.
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
                x = F.conv2d(x, w, padding='same') * QUANT_DF**2
                if self.bias is not None:
                    x = x + self.bias
                return x
            if quant_a != 0.:
                qx = (x.clamp(-1., 1.) * QUANT_F).round() * QUANT_DF
                x = quant_a*qx + (1. - quant_a)*x
            bias = self.bias.view(-1) if self.bias is not None else None
            return F.conv2d(x, w, bias, padding='same')

    class Net(nn.Module):
        def __init__(self):
            super(Net, self).__init__()
            ch = 3 if RGB else 1
            ich = LAYERS[0]
            def init_(conv):
                with torch.no_grad():
                    w = conv.weight.clone()
                    # attempt to reduce checkerboarding
                    for i in range(0, w.shape[0], 4):
                        w[i+1:i+4] = w[i:i+1].expand(3, -1, -1, -1)
                    conv.weight.copy_(w)
            self.cin = nn.Conv2d(ch, ich, 3, padding='same')
            nn.init.kaiming_normal_(
               self.cin.weight, mode='fan_out', nonlinearity='relu')
            nn.init.zeros_(self.cin.bias)
            init_(self.cin)
            self.conv = nn.ModuleList()
            for och in LAYERS[1:]:
                if QUANT_8:
                    c = QuantConv2d(ich, och, 3, bias=False)
                else:
                    c = nn.Conv2d(ich, och, 3, padding='same', bias=False)
                nn.init.kaiming_normal_(
                    c.weight, mode='fan_out', nonlinearity='relu')
                init_(c)
                self.conv.append(c)
                ich = och
            self.cout = nn.Conv2d(ich, 4*ch, 3, padding='same')
            nn.init.xavier_normal_(self.cout.weight)
            nn.init.zeros_(self.cout.bias)
            init_(self.cout)

        def forward(self, x, y):
            x = act(self.cin(x))
            for conv in self.conv:
                x = act(conv(x))
            x = self.cout(x)
            x = F.pixel_shuffle(x, 2)
            x = torch.add(x, y)
            return x

    model = Net()
    pretrained = args.test or args.resume
    if pretrained:
        with open(pretrained, 'rb') as f:
            m = pickle.load(f)
            to_del = []
            for k, v in m.items():
                if type(v) is not np.ndarray:
                    to_del += [k]
                    continue
                if args.resume:
                    m[k] += 0.05*np.random.randn(*m[k].shape)
                m[k] = torch.from_numpy(v)
            for k in to_del:
                del m[k]
        model.load_state_dict(m)
    if has_cuda:
        model = model.to(dev, memory_format=torch.channels_last)

    BaseLoss = nn.MSELoss if args.l2 else nn.L1Loss
    base_loss = BaseLoss(reduction='none')
    if RGB:
        def loss_fn(pred, true):
            l = lambda x, y: base_loss(x, y).mean(dim=(0, 2, 3))
            r, g, b = l(pred, true).unbind()
            return 0.2627*r + 0.678*g + 0.0593*b
    else:
        loss_fn = lambda x, y: base_loss(x, y).mean()

    def fwd(model, x, y, true, opt, train):
        opt.zero_grad(True)
        pred = model(x, y)
        loss = loss_fn(pred, true)
        if train:
            loss.backward()
        return pred, loss

    def run_epoch(model, dev, epoch, fwd_fn, opt, sched, writer, train):
        n_loss = 0
        run_loss = 0.
        for i, (x, y, true, files) in enumerate(dataloader):
            pred, loss = fwd_fn(model, x.to(dev), y.to(dev), true.to(dev), opt,
                                train)
            if train:
                opt.step()
                sched.step()
            run_loss += loss
            n_loss += 1
            last_y = y
        with torch.no_grad():
            avg_loss = run_loss / n_loss
            if writer and (epoch % 20 == 0 or epoch == E - 1):
                last_y_v = last_y[0]
                pred_v = pred[0]
                true_v = true[0]
                if RGB:
                    pred_v = rgb_to_ycbcr(pred_v.unsqueeze(0)).squeeze(0)
                    true_v = rgb_to_ycbcr(true_v.unsqueeze(0)).squeeze(0)
                    last_y_v = rgb_to_ycbcr(last_y_v.unsqueeze(0)).squeeze(0)
                diff = true_v - pred_v
                norm = lambda x: torch.clamp(x / 0.2, 0., 1.)
                diffs = tuple([torch.stack((
                    norm(-torch.min(diff[i], torch.tensor(0))),
                    norm(torch.max(diff[i], torch.tensor(0))),
                    torch.zeros_like(diff[i]))) for i in range(diff.shape[0])])
                imgs = (last_y_v[0], pred_v[0], true_v[0])
                writer.add_images(
                    'imgs',
                    torch.stack(
                        tuple(x.to(dtype=torch.float32).expand(3, -1, -1)
                            for x in imgs if len(x[0]) > 0) + diffs),
                    global_step=epoch)
            if not QUANT_8 and epoch % 50 == 0 and epoch != 0:
                sd['loss'] = avg_loss
                for k, v in model.state_dict().items():
                    sd[k] = v.cpu().numpy() if hasattr(v, 'numpy') else v
                ckpt = filename.replace('.pickle', f'-{epoch:04}.pickle')
                with open('ckpt/' + ckpt, 'wb') as f:
                    pickle.dump(sd, f, protocol=pickle.HIGHEST_PROTOCOL)
            if writer:
                writer.add_scalar('L', avg_loss, epoch + 1)
        return avg_loss

    loss = None
    def run(model, name=None, dev=dev, lr=LR, max_lr=MAX_LR, *, epochs, compile,
            train):
        if is_win:
            compile = False
        if train:
            model = model.train()
        else:
            model = model.eval()
        writer = SummaryWriter(name, flush_secs=1) if name else None
        fwd_fn = torch.compile(fwd, mode=('max-autotune' if has_cuda else
                                          'default')) if compile else fwd
        opt = torch.optim.AdamW(
            model.parameters(), lr=lr, betas=(0.75, 0.999),
            weight_decay=args.weight_decay)
        sched = torch.optim.lr_scheduler.OneCycleLR(
            opt, max_lr=max_lr, steps_per_epoch=len(dataloader),
            epochs=epochs) if train else None
        def impl():
            global loss
            for epoch in (t := tqdm.trange(epochs)):
                loss = run_epoch(
                    model, dev, epoch, fwd_fn, opt, sched, writer, train)
                t.set_description(f'L: {loss:.5f}')
        if train:
            impl()
        else:
            with torch.no_grad():
                impl()
        if writer:
            writer.flush()

    if args.test:
        print(f'testing {args.test}')
        with torch.autocast(dev.type, dtype=autocast_dtype):
            run(model, epochs=1, compile=False, train=False)
        continue

    if args.resume:
        print(f'resuming from {args.resume}')
    print(f'training models/{filename} ({SIZE})')
    with torch.autocast(dev.type, dtype=autocast_dtype):
        run(model, name=writer_name, epochs=E, compile=True, train=True)

        if QUANT_8:
            weight_leak = 0.00001
            act_leak = 0.00001
            quant_a = 0.2
            run(model, lr=LR / 10, max_lr=LR, epochs=E // 20, compile=True,
                train=True)
            weight_leak = 0.
            act_leak = 0.
            quant_a = 1.
            use_quant = True
            run(model, epochs=1, compile=False, train=False)
        elif QUANT:
            act_leak = 0.00001
            run(model, lr=LR / 10., max_lr=LR, epochs=E // 20, compile=True,
                train=True)
            act_leak = 0.
            run(model, epochs=1, compile=False, train=False)

    sd['loss'] = loss.item()
    with open(sys.argv[0]) as f:
        sd['src'] = f.read()
    for k, v in model.state_dict().items():
        sd[k] = v.cpu().numpy() if hasattr(v, 'numpy') else v

    with open('models/' + filename, 'wb') as f:
        pickle.dump(sd, f, protocol=pickle.HIGHEST_PROTOCOL)
    with open('test/last.txt', 'w') as f:
        f.write('models/' + filename)
