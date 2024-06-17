import os
import sys
import argparse
from random import choices, randint, random, uniform, shuffle
from subprocess import run
from multiprocessing import Pool

parser = argparse.ArgumentParser()
parser.add_argument('in_', type=str)
parser.add_argument('out', type=str)
parser.add_argument('-d', '--distort', action='store_true')
parser.add_argument('-y', '--luma', action='store_true')
parser.add_argument('-s', '--sharpen', action='store_true')
parser.add_argument('-b', '--box-only', action='store_true')
parser.add_argument('-r', '--raw-hr', action='store_true')
parser.add_argument('-p', '--pure', action='store_true')
args = parser.parse_args()

def c(*v):
    v, w = zip(*v) if isinstance(v[0], tuple) else (v, None)
    return choices(v, weights=w)[0]

def mkdir(dir):
    assert(not os.path.isdir(dir))
    os.mkdir(dir)

def m(*v):
    l = list(v)
    shuffle(l)
    return sum(l, [])

mkdir(args.out)
with open(args.out + '/cmd.txt', 'w') as f:
    f.write(" ".join(sys.argv))

hr = f'{args.out}/128'
mkdir(hr)
lr = f'{args.out}/64'
mkdir(lr)

def resize(file):
    s = ['magick', f'{args.in_}/{file}']
    if args.luma:
        s += ['-colorspace', 'Gray']
    s += ['-rotate', f'{randint(0, 3) * 90}']
    s += c(['-flop'], [])
    if not args.raw_hr:
        s += ['-modulate', f'100,100,{randint(0, 100)}']
        s += [c('-level', '+level'), f'{randint(0, 25)}%']
    s += [f'{hr}/{file}']
    shr = s
    run(s)
    s = ['magick', f'{hr}/{file}']
    if not args.pure:
        blur = uniform(0.1, 1.5 if args.sharpen else 0.5)
        s += c((['-gaussian-blur', f'3x{blur:.1f}'], 1),
               (['-sharpen', f'3x{uniform(0.1, 1.0):.1f}'], 1),
               ([], 8))
    filter = 'Box' if args.box_only else c(('Box', 5), ('CatRom', 5))
    s += ['-filter', filter, '-resize', '50%']
    if args.distort:
        if random() < 0.5:
            s += ['-format', 'jpg', '-quality', f'{randint(85, 95)}']
            file = file.replace('.png', '.jpg')
    s += [f'{lr}/{file}']
    slr = s
    run(s)
    return shr, slr

files = os.listdir(sys.argv[1])
hrs = ''
lrs = ''
with Pool() as pool:
    for hr, lr in pool.map(resize, files):
        hrs += ' '.join(hr) + '\n'
        lrs += ' '.join(lr) + '\n'

with open(args.out + '/hr.txt', 'w') as f:
    f.write(hrs)
with open(args.out + '/lr.txt', 'w') as f:
    f.write(lrs)
