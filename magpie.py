# converts the CuNNy model to an MagpieFX effect
# this code sucks, maybe tidy up one day™..
import sys
import numpy as np
import pickle
from collections import OrderedDict
from pathlib import Path

with open(sys.argv[1], 'rb') as f:
    m = pickle.load(f)

shader = ''
N = sum(1 for x in m.keys() if 'conv' in x and 'weight' in x)
D = next(m[x] for x in m if 'cin' in x and 'weight' in x).shape[0]
RGB = 'fancyluma.weight' in m
stem = Path(sys.argv[1]).stem
version = stem[:stem.rfind('-')]
usercas = 'RCAS' in stem
crelu = m['crelu']

# TODO: replace suffix system with something better
assert('NVL' in version)

# thanks vim
openbr = '{'
closebr = '}'

def S(txt, end='\n'):
    global shader
    shader += txt + end

def fmt(v):
    return f'{v:.3e}' # enough for fp16

def weight(ws, x, y, ich, och, d, iidx, oidx):
    s = f'\tr += '
    w = [fmt(v.item()) for v in ws[(4*oidx):(4*(1+oidx)), (4*iidx):(4*(1+iidx)),
                                   y, x].swapaxes(0, 1).flatten()]
    wflat = ", ".join(w)
    l = f's{iidx}_{y * d + x}'
    if len(w) > 4:
        s += f'mul({l}, M4({wflat}));\n'
    else:
        s += f'V4({wflat}) * {l};\n'
    return s

header = """//!MAGPIE EFFECT
//!VERSION 4
//!SORT_NAME __SORT__

//!TEXTURE
Texture2D INPUT;

//!TEXTURE
//!WIDTH INPUT_WIDTH * 2
//!HEIGHT INPUT_HEIGHT * 2
Texture2D OUTPUT;

//!SAMPLER
//!FILTER POINT
SamplerState SP;

//!SAMPLER
//!FILTER LINEAR
SamplerState SL;

//!COMMON
#define O(t, p) t.SampleLevel(SP, pos + p * pt, 0)
#define V4 min16float4
#define M4 min16float4x4

"""

imgs = {}
def allocimgs(ins, n):
    global header, imgs
    out = []
    for name, ref in imgs.items():
        if len(out) == n:
            break
        if ref == 0:
            out += [name]
            imgs[name] += 1
    for i in range(len(out), n):
        name = f't{len(imgs)}'
        header += f'//!TEXTURE\n'
        header += f'//!WIDTH INPUT_WIDTH\n'
        header += f'//!HEIGHT INPUT_HEIGHT\n'
        header += f'//!FORMAT R8G8B8A8_SNORM\n'
        header += f'Texture2D {name};\n'
        header += f'\n'
        imgs[name] = 1
        out += [name]
    for inv in ins:
        if inv in imgs:
            imgs[inv] -= 1
    return out

npass = 0
def prelude(ps, ins, stype, loadfn=False, save=None, multiout=False,
            signed=False):
    global header, npass
    npass += 1
    shuffle = ps == 'out-shuffle'
    save = None if shuffle else save
    S(f'//!PASS {npass}')
    S(f'//!DESC {ps}')
    S(f'//!BLOCK_SIZE {16 if shuffle else 8}')
    S(f'//!NUM_THREADS 64')
    S(f'//!IN ' + ', '.join((['INPUT'] if shuffle else []) + ins))
    if save:
        save = allocimgs(ins, len(save))
        S(f'//!OUT {", ".join(save)}')
    else:
        S(f'//!OUT OUTPUT')
    if loadfn:
        S('')
        for i, inv in enumerate(ins):
            fn = f'O({inv}, float2(x, y))'
            if inv == 'INPUT':
                if RGB:
                    lw = ', '.join([fmt(v.item())
                                    for v in m['fancyluma.weight'].flatten()])
                    lb = fmt(m['fancyluma.bias'].item())
                    fn = f'dot(float3({lw}), {fn}.rgb) + {lb}'
                else:
                    fn = f'dot(float3(0.299, 0.587, 0.114), {fn}.rgb)'
            S(f'#define l{i}(x, y) {stype}({fn})')
    S('')
    return save

def write(ps, k, actfn, ins):
    ws = m[k+'weight']
    sz = ws.shape
    crelup = crelu and ins != ['INPUT']
    if crelup:
        ws = ws.reshape(sz[0], -1, 4, sz[2], sz[3])
        half = ws.shape[1] // 2
        ws = np.dstack((ws[:, :half], ws[:, half:])).reshape(sz)
    och = sz[0]
    ich = sz[1]
    d = sz[2]
    texs = [f'{ps}_{oidx}' for oidx in range(och // 4)]
    shuffle = ps == 'out-shuffle'
    stype = 'V4' if not ins == ['INPUT'] else 'min16float'
    texs = prelude(ps, ins, stype, loadfn=True, save=texs, multiout=True,
                   signed=(ps == 'out'))
    global shader
    start = len(shader)
    S(f'void Pass{npass}(uint2 blockStart, uint3 tid) {openbr}')
    S(f'\tfloat2 pt = float2(GetInputPt());')
    if shuffle:
        S('\tuint2 gxy = (Rmp8x8(tid.x) << 1) + blockStart;')
    else:
        S('\tuint2 gxy = Rmp8x8(tid.x) + blockStart;')
    S(f'\tuint2 size = Get{"Output" if shuffle else "Input"}Size();')
    S('\tif (gxy.x >= size.x || gxy.y >= size.y) {')
    S('\t\treturn;')
    S('\t}')
    if shuffle:
        S('\tfloat2 pos = ((gxy >> 1) + 0.5) * pt;')
    else:
        S('\tfloat2 pos = (gxy + 0.5) * pt;')
    S('')
    cent = d // 2
    vs = []
    for iidx in range(0, max(ich // 4, 1), 2 if crelup else 1):
        if iidx > 0:
            S('')
        i = 0
        for y in range(d):
            for x in range(d):
                v = f's{iidx}_{i}'
                S(f'\t{stype} {v} = l{iidx // (2 if crelup else 1)}({x - cent}.0, {y - cent}.0);')
                vs += [v]
                i += 1
        if not crelup:
            continue
        i = 0
        for y in range(d):
            for x in range(d):
                v = f's{iidx + 1}_{i}'
                S(f'\t{stype} {v} = -max(-s{iidx}_{i}, 0.0);')
                vs += [v]
                i += 1
        i = 0
        for y in range(d):
            for x in range(d):
                S(f'\ts{iidx}_{i} = max(s{iidx}_{i}, 0.0);')
                i += 1
    S('')
    wfns = ''
    for oidx in range(och // 4):
        wfns += f'V4 f{oidx}({", ".join(f"{stype} {v}" for v in vs)}) {openbr}\n'
        wfns += f'\tV4 r = 0.0;\n'
        for iidx in range(max(ich // 4, 1)):
            for y in range(d):
                for x in range(d):
                    wfns += weight(ws, x, y, ich, och, d, iidx, oidx)
        bn = k + 'bias'
        if bn in m:
            b = [fmt(v.item()) for v in m[bn].ravel()[4*oidx:4*(oidx+1)]]
            wfns += f'\tr += V4({", ".join(b)});\n'
        wfns += f'\treturn {actfn.replace("X", f"r")};\n'
        wfns += closebr + '\n\n'
        call = f'f{oidx}({", ".join(vs)})'
        if shuffle:
            S(f'\tV4 r = {call};\n')
        else:
            S(f'\t{texs[oidx]}[gxy] = {call};')
    if shuffle:
        S('\tstatic const float3x3 rgb2yuv = {0.299, 0.587, 0.114, -0.169, -0.331, 0.5, 0.5, -0.419, -0.081};')
        S('\tstatic const float3x3 yuv2rgb = {1, -0.00093, 1.401687, 1, -0.3437, -0.71417, 1, 1.77216, 0.00099};')
        S('\tfloat2 opt = float2(GetOutputPt());\n')
        S('\tpos -= 0.5f * opt;')
        S('\tfloat3 yuv = mul(rgb2yuv, INPUT.SampleLevel(SL, pos, 0).rgb);')
        S('\tOUTPUT[gxy] = float4(mul(yuv2rgb, float3(saturate(yuv.r + r.x), yuv.yz)), 1);\n')
        S('\t++gxy.x;')
        S('\tpos.x += opt.x;')
        S('\tyuv = mul(rgb2yuv, INPUT.SampleLevel(SL, pos, 0).rgb);')
        S('\tOUTPUT[gxy] = float4(mul(yuv2rgb, float3(saturate(yuv.r + r.y), yuv.yz)), 1);\n')
        S('\t++gxy.y;')
        S('\tpos.y += opt.y;')
        S('\tyuv = mul(rgb2yuv, INPUT.SampleLevel(SL, pos, 0).rgb);')
        S('\tOUTPUT[gxy] = float4(mul(yuv2rgb, float3(saturate(yuv.r + r.w), yuv.yz)), 1);\n')
        S('\t--gxy.x;')
        S('\tpos.x -= opt.x;')
        S('\tyuv = mul(rgb2yuv, INPUT.SampleLevel(SL, pos, 0).rgb);')
        S('\tOUTPUT[gxy] = float4(mul(yuv2rgb, float3(saturate(yuv.r + r.z), yuv.yz)), 1);')
    S(f'{closebr}')
    if not shuffle:
        S('')
    shader = shader[:start] + wfns + shader[start:]
    return texs

S(f'// CuNNy {version.replace("-", " ")} - https://github.com/funnyplanter/CuNNy')
S(gpl, end='')
header = shader + header
shader = ''

texs = ['INPUT']
nconv = 1
relu = 'max(X, 0.0)' if not crelu else 'X'
for k_ in m:
    suf = 'weight'
    if not k_.endswith(suf):
        continue
    k_ = k_[:-len(suf)]
    k = k_
    pref = '_orig_mod.'
    if k.startswith(pref):
        k = k[len(pref):-1]
    if k.startswith('cin'):
        texs = write('in', k_, relu, texs)
    elif k.startswith('conv'):
        texs = write(f'conv{nconv}', k_, relu, texs)
        nconv += 1
    elif k.startswith('cout'):
        texs = write('out-shuffle', k_, 'tanh(X)', texs)

suf = version[version.rfind("NVL")+3:].replace('-', '')
suf += '-' if suf != '' else ''
shader = header \
    .replace('__SORT__', f'CuNNy-{suf}D{D:02}N{N:02}') + shader

fp = f'test/CuNNy-{stem}.hlsl'
with open(fp, 'w') as f:
    f.write(shader)
print(fp)
