import os
import sys
import json
import numpy as np
import torch
import piqa
from subprocess import run
from math import inf
from PIL import Image
torch._dynamo.config.cache_size_limit = 64

assert(len(sys.argv) == 3)

def hxfile(fn):
    return run(['md5sum', fn], capture_output=True) \
            .stdout.split()[0].decode('ascii')

CACHE = 'cache.json'
FILE = sys.argv[1]
DIR = sys.argv[2]

assert(os.path.isfile(FILE))
assert(os.path.isdir(DIR))

cache = None
src_hx = hxfile(sys.argv[0])
if os.path.isfile(CACHE):
    with open(CACHE, 'r') as f:
        cache = json.load(f)
        if cache['src'] != src_hx:
            cache = None
if not cache:
    cache = {'src': src_hx}

gt = cache.setdefault('gt', {})
sr = gt.setdefault(hxfile(FILE), {})

def load(s):
    with Image.open(s) as img:
        img = img.convert('L')
        return torch.from_numpy(np.array(img)).unsqueeze(0).unsqueeze(0) / 255.

f_mae = torch.nn.L1Loss()
f_psnr = piqa.psnr.PSNR()
f_ssim = piqa.ssim.SSIM(n_channels=1)
f_ms_ssim = piqa.ssim.MS_SSIM(n_channels=1)
f_lpips_alex = piqa.lpips.LPIPS('alex')
f_lpips_vgg = piqa.lpips.LPIPS('vgg')

stats = []
def eval(a, f):
    base = os.path.splitext(f)[0]
    fn = DIR + '/' + f
    hx = hxfile(fn)
    if hx in sr:
        return (base, sr[hx])
    b = load(fn)
    a3 = a.expand(-1, 3, -1, -1)
    b3 = b.expand(-1, 3, -1, -1)
    m = []
    m += [mae := f_mae(a, b).item()]
    m += [psnr := f_psnr(a, b).item()]
    m += [ssim := f_ssim(a, b).item()]
    m += [ms_ssim := f_ms_ssim(a, b).item()]
    with torch.autocast('cpu', dtype=torch.bfloat16):
        m += [lpips_alex := f_lpips_alex(a3, b3).item()]
        m += [lpips_vgg := f_lpips_vgg(a3, b3).item()]
    v = tuple(m)
    sr[hx] = v
    return (base, v)

with torch.no_grad():
    a = load(sys.argv[1])
    fs = os.listdir(DIR + '/')
    for i, f in enumerate(fs):
        stats += [eval(a, f)]
        print(f'[{i + 1}/{len(fs)}] {f}', file=sys.stderr)

M = [
    ['MAE',         -1, -inf, +inf],
    ['PSNR',        +1, -inf, +inf],
    ['SSIM',        +1, -inf, +inf],
    ['MS-SSIM',     +1, -inf, +inf],
    ['LPIPS-Alex',  -1, -inf, +inf],
    ['LPIPS-VGG',   -1, -inf, +inf]
]

for (f, vs) in stats:
    for i, ((name, sign, maxv, minv), v) in enumerate(zip(M, vs)):
        M[i][2] = max(maxv, v)
        M[i][3] = min(minv, v)

S = []
max_mean = -inf
for (f, vs) in stats:
    st = []
    norm = []
    mean = 0.
    for i, ((name, sign, maxv, minv), v) in enumerate(zip(M, vs)):
        vrange = (maxv - minv)
        nv = maxv - v if sign == -1 else v - minv
        nv /= maxv - minv
        bold = '**' if nv == 1.0 else ''
        st += [(bold + f'{v:.5f}' + bold)]
        norm += [(bold + f'{nv:.3f}' + bold)]
        mean += nv
    mean /= len(M)
    max_mean = max(mean, max_mean)
    S += [(mean, f'| {f}\t | ' + ' | '.join(st) + ' | ' +  ' | '.join(norm))]
S = sorted(S, reverse=True)

print(f'Comparing `{sys.argv[1]}`')
print('')

print('| Name | ' + ' | '.join(f'{v[0]} ({"+" if v[1] == 1 else "-"})' for v in M)
      + ' | ' + ' | '.join(f'{v[0]} (N)' for v in M) + ' | Mean |')
print('| - | ' + ' | '.join(f'-' for v in M) + ' | ' + ' | '.join(f'-' for v in M) + ' | - |')
print('\n'.join(v + f' | {"**" if k == max_mean else ""}{(k / max_mean):.3f}{"**" if k == max_mean else ""} |' for k, v in S))

with open(CACHE, 'w') as f:
    json.dump(cache, f)
