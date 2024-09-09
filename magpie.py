# converts the CuNNy model to an MagpieFX effect
# this code sucks, maybe tidy up one day™..
import sys
import numpy as np
import pickle
import argparse
from collections import OrderedDict
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument('model', type=str)
args = parser.parse_args()

with open(args.model, 'rb') as f:
    m = pickle.load(f)

N = sum(1 for x in m.keys() if 'conv' in x and 'weight' in x)
D = next(m[x] for x in m if 'cin' in x and 'weight' in x).shape[0]
RGB = m.get('rgb', False)
CRELU = m.get('crelu', False)
QUANT = m.get('quant', False)
QUANT_8 = m.get('quant-8', False)
SIZE = m.get('size', 0)
stem = Path(args.model).stem
name = stem[:stem.rfind('-')]

# thanks vim
OPENBR = '{'
CLOSEBR = '}'
ndr = lambda *d: np.ndindex(*d)

shader = []
shader_buf = ''
indent_lvl = 0
def flush():
    global shader, shader_buf
    shader += [shader_buf]
    shader_buf = ''
    
def S(txt, end='\n', t=0):
    global shader, shader_buf, indent_lvl
    if t < 0:
        indent_lvl += t
    tabs = indent_lvl * '\t'
    shader_buf += tabs + ('\n' + tabs).join(txt.split('\n')) + end
    if t > 0:
        indent_lvl += t
    if len(shader_buf) > 1024:
        flush()

def fmt(v, n=3):
    return f'{v:.{n}e}' # enough for fp16

def weight(ws, x, y, ich, och, d, iidx, oidx, l):
    w = [fmt(v.item()) for v in ws[(4*oidx):(4*(1+oidx)), (4*iidx):(4*(1+iidx)),
                                   y, x].swapaxes(0, 1).ravel()]
    wstr = ', '.join(w)
    return f'mul({l}, M4({wstr}))' if ich >= 4 else f'mul({l}, M3x4({wstr}))' \
            if ich == 3 else f'V4({wstr}) * {l}'

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
#define O(t, x, y) t.SampleLevel(SP, pos + float2(x, y) * pt, 0)
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
        name = f'T{len(imgs)}'
        header += '//!TEXTURE\n'
        header += '//!WIDTH INPUT_WIDTH\n'
        header += '//!HEIGHT INPUT_HEIGHT\n'
        fmt = 'R8G8B8A8_SNORM' if CRELU else 'R8G8B8A8_UNORM'
        fmt = fmt if QUANT else 'R16G16B16A16_FLOAT'
        header += f'//!FORMAT {fmt}\n'
        header += f'Texture2D {name};\n'
        header += '\n'
        imgs[name] = 1
        out += [name]
    for inv in ins:
        if inv in imgs:
            imgs[inv] -= 1
    return out

npass = 0
def prelude(ps, ins, sz, stype, nouts=1, loadfn=False, save=None,
            multiout=False, signed=False):
    global header, npass
    npass += 1
    S(f'//!PASS {npass}')
    S(f'//!DESC {ps} ({sz[1]}x{sz[0]})')
    shuffle = ps == 'out-shuffle'
    S(f'//!BLOCK_SIZE {16 if shuffle else 8}')
    S(f'//!NUM_THREADS 64')
    addins = ins
    if shuffle:
        addins = ['INPUT'] + addins
    S(f'//!IN ' + ', '.join(addins))
    if shuffle:
        S(f'//!OUT OUTPUT')
    else:
        save = allocimgs(ins, len(save))
        S(f'//!OUT {", ".join(save)}')
    if loadfn:
        for i, inv in enumerate(ins):
            fn = f'O({inv}, x, y)'
            if inv == 'INPUT':
                if not RGB:
                    fn = f'dot(float3(0.299, 0.587, 0.114), {fn}.rgb)'
                else:
                    fn = f'{fn}.rgb'
            S(f'#define L{i}(x, y) {stype}({fn})')
    return save

def write(ps, k, actfn, ins):
    ws = m[k+'weight']
    sz = ws.shape
    inv = ins[0]
    crelup = CRELU and inv != 'INPUT'

    if QUANT_8 and ps != 'in':
        ws = ws.clip(-1., 1.)

    if crelup:
        ws = ws.reshape(sz[0], -1, 4, sz[2], sz[3])
        half = ws.shape[1] // 2
        ws = np.dstack((ws[:, :half], ws[:, half:])).reshape(sz)

    och = sz[0]
    ich = sz[1]
    d = sz[2]
    shuffle = ps == 'out-shuffle'
    nouts = och // 4
    stype = 'min16float' if ich == 1 else 'V3' if ich == 3 else 'V4'
    cent = d // 2
    cm = 2 if crelup else 1
    nins = max(ich // 4 // cm, 1)

    texs = [f'{ps}_{oidx}' for oidx in range(nouts)]
    texs = prelude(ps, ins, sz, stype, nouts=nouts, loadfn=True, save=texs,
                   multiout=True, signed=(ps == 'out'))

    if inv == 'INPUT' and RGB:
        S(f'#define V3 min16float3')
        S(f'#define M3x4 min16float3x4')

    S(f'void Pass{npass}(uint2 blockStart, uint3 tid) {OPENBR}', t=1)
    S(f'float2 pt = float2(GetInputPt());')
    if shuffle:
        S('uint2 gxy = (Rmp8x8(tid.x) << 1) + blockStart;')
    else:
        S('uint2 gxy = Rmp8x8(tid.x) + blockStart;')
    S(f'uint2 sz = Get{"Output" if shuffle else "Input"}Size();')
    S('if (gxy.x >= sz.x || gxy.y >= sz.y)')
    S('\treturn;')
    if shuffle:
        S('float2 pos = ((gxy >> 1) + 0.5) * pt;')
    else:
        S('float2 pos = (gxy + 0.5) * pt;')

    I = min(nins if d == 1 else 2, nins)
    S(f'{stype} {", ".join(f"s{i}_{y}_{x}" for i, y, x in np.ndindex(I, d, d))};')
    S(f'V4 {", ".join(f"r{o} = 0.0" for o in range(nouts))};')

    for iidx in range(0, max(ich // 4, 1), I):
        vi = min(I, nins - iidx)

        sbuf = []
        for i, y, x, j in ndr(vi // cm, d, d, cm):
            si = iidx + cm*i + j
            s = f'L{si // cm}({x - cent}.0, {y - cent}.0)'
            sbuf += [f's{cm*i + j}_{y}_{x} = {s};']
            if len(sbuf) == 3:
                S(' '.join(sbuf))
                sbuf = []
        if sbuf:
            S(' '.join(sbuf))
        for i, y, x, j in ndr(vi // cm, d, d, cm):
            si = iidx + cm*i + j
            for o in range(nouts):
                l = f's{cm*i + j}_{y}_{x}'
                wstr = weight(ws, x, y, ich, och, d, si, o, l)
                S(f'r{o} += {wstr};')

    for o in range(nouts):
        bn = k + 'bias'
        if bn in m and not np.all(m[bn] < 1e-5):
            b = [fmt(v.item()) for v in m[bn].ravel()[4*o:4*(o+1)]]
            S(f'r{o} += V4({", ".join(b)});')
        if actfn:
            S(f'r{o} = {actfn.replace("T", "V4").replace("X", f"r{o}")};')
        if shuffle:
            continue
        S(f'{texs[o]}[gxy] = r{o};')

    if shuffle:
        if not RGB:
            S('static const float3x3 RY = {0.299, 0.587, 0.114, -0.169, -0.331, 0.5, 0.5, -0.419, -0.081},'
              ' YR = {1, -0.00093, 1.401687, 1, -0.3437, -0.71417, 1, 1.77216, 0.00099};')
        S('float2 opt = float2(GetOutputPt());')
        S('float2 fpos = (float2(gxy) + 0.5) * opt;')
        if not RGB:
            S('float3 yuv;')
        for y, x in ndr(2, 2):
            c = 'xyzw'[y*2 + x]
            src = f'INPUT.SampleLevel(SL, fpos + float2({x}.0, {y}.0) * opt, 0).rgb'
            if RGB:
                l = f'saturate({src} + float3(r0.{c}, r1.{c}, r2.{c}))'
            else:
                S(f'yuv = mul(RY, {src});')
                l = f'mul(YR, float3(saturate(yuv.r + r0.{c}), yuv.yz))'
            S(f'OUTPUT[gxy + int2({x}, {y})] = float4({l}, 1.0);')

    S(CLOSEBR, t=-1)

    return texs

gpl = """
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// 
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""

header = (f'// CuNNy {name.replace("-", " ")} - '
           'https://github.com/funnyplanter/CuNNy\n' + gpl + '\n') + header

texs = ['INPUT']
nconv = 1
relu = 'max(X, 0.0)' if not CRELU else 'X'
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
        texs = write('out-shuffle', k_, None, texs)

suf = name[name.rfind("NVL")+3:].replace('-', '')
suf += '-' if suf != '' else ''
shader = [header \
    .replace('__SORT__', f'CuNNy-{suf}{SIZE:07}')] + shader

flush()

fp = f'test/CuNNy-{stem}.hlsl'
with open(fp, 'w') as f:
    f.write(''.join(shader))
print(fp)
