import numpy as np
import os
import shutil
import bisect
import argparse
from PIL import Image
from tqdm.contrib.concurrent import process_map

parser = argparse.ArgumentParser()
parser.add_argument('in_', type=str)
parser.add_argument('out', type=str)
parser.add_argument('-s', '--split', type=float, default=0.75)
parser.add_argument('-l', '--live', type=float, default=0.66)
parser.add_argument('-t', '--threshold', type=float)
args = parser.parse_args()

assert(not os.path.isdir(args.out))
os.mkdir(args.out)

files = os.listdir(args.in_)

def proc(file):
    with Image.open(args.in_ + '/' + file) as img:
        px = np.array(img.convert('L'))
    fft = np.fft.rfft2(px)
    psd = np.abs(fft)**2
    psd_sum = np.sum(psd)
    norm = psd / psd_sum if psd_sum > 1e-7 else 0.
    entropy = -np.sum(norm * np.log(norm + 1e-9))
    return (file, entropy)

out = list(process_map(proc, files, chunksize=32))
out = sorted(out, key=lambda x: x[1])

if args.threshold is not None:
    split = bisect.bisect_left(out, args.threshold, key=lambda x: x[1])
else:
    split = int(args.split * len(out))
live = int(args.live * split)
cull = split - live

print(f'boundary: {out[split][1]:.3f}')
print(f'culling {cull} ({cull/len(out):.1%}) images')

bottom = out[:split]
p = np.maximum(np.array([x[1] for x in bottom]), 0.)
p /= p.sum()
bottom_np = np.empty(len(bottom), dtype=object)
bottom_np[:] = bottom # hack to make array of tuples
keep = np.random.choice(bottom_np, live, p=p, replace=False)
out = list(keep) + out[split:]

def write(v):
    shutil.copy(args.in_ + '/' + v[0], args.out)
process_map(write, out, chunksize=8)
