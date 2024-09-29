# converts the CuNNy model to an MagpieFX effect
import numpy as np
import argparse
from dataclasses import dataclass
from common import *

HEADER = """//!MAGPIE EFFECT
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

@dataclass
class Img:
    ref: int
    src: str

imgs = {}
def alloc_imgs(ins, n):
    global imgs
    out = []
    for name, img in imgs.items():
        if len(out) == n:
            break
        if img.ref == 0:
            out += [name]
            imgs[name].ref += 1
    fmt = 'R8G8B8A8_UNORM' if args.quant else 'R16G16B16A16_FLOAT'
    for i in range(len(out), n):
        name = f'T{len(imgs)}'
        src  = '//!TEXTURE\n'
        src += '//!WIDTH INPUT_WIDTH\n'
        src += '//!HEIGHT INPUT_HEIGHT\n'
        src += f'//!FORMAT {fmt}\n'
        src += f'Texture2D {name};\n\n'
        imgs[name] = Img(ref=1, src=src)
        out += [name]
    for inv in ins:
        if inv in imgs:
            imgs[inv].ref -= 1
    return out

n_pass = 0
def prelude(ps, ins, sz, stype, nouts=1, save=None):
    global n_pass
    n_pass += 1
    S(f'//!PASS {n_pass}')
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
        save = alloc_imgs(ins, len(save))
        S(f'//!OUT {", ".join(save)}')
    for i, inv in enumerate(ins):
        fn = f'O({inv}, x, y)'
        if inv == 'INPUT':
            if not args.rgb:
                fn = f'dot(float3(0.299, 0.587, 0.114), {fn}.rgb)'
            else:
                fn = f'{fn}.rgb'
        S(f'#define L{i}(x, y) {stype}({fn})')
    return save

def weight(ws, x, y, ich, och, d, iidx, oidx, l):
    w = [fmt(v) for v in ws[4*oidx:4*(1+oidx), 4*iidx:4*(1+iidx), y, x]
                                  .swapaxes(0, 1).ravel().tolist()]
    wstr = ', '.join(w)
    if ich >= 4:
        return f'mul({l}, M4({wstr}))'
    elif ich == 3:
        return f'mul({l}, M3x4({wstr}))'
    return f'V4({wstr}) * {l}'

def write(ps, k, actfn, ins):
    ws = m[k + 'weight']
    sz = ws.shape
    inv = ins[0]

    if args.quant_8 and ps != 'in':
        ws = ws.clip(-1., 1.)

    och = sz[0]
    ich = sz[1]
    d = sz[2]
    shuffle = ps == 'out-shuffle'
    nouts = och // 4
    stype = 'min16float' if ich == 1 else 'V3' if ich == 3 else 'V4'
    cent = d // 2
    nins = max(ich // 4, 1)

    texs = [f'{ps}_{oidx}' for oidx in range(nouts)]
    texs = prelude(ps, ins, sz, stype, nouts=nouts, save=texs)

    if inv == 'INPUT' and args.rgb:
        S(f'#define V3 min16float3')
        S(f'#define M3x4 min16float3x4')

    S(f'void Pass{n_pass}(uint2 blockStart, uint3 tid) {OPENBR}', t=1)
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
        for i, y, x in np.ndindex(vi, d, d):
            si = iidx + i
            s = f'L{si}({x - cent}.0, {y - cent}.0)'
            sbuf += [f's{i}_{y}_{x} = {s};']
            if len(sbuf) == 3:
                S(' '.join(sbuf))
                sbuf = []
        if sbuf:
            S(' '.join(sbuf))
        for i, y, x in np.ndindex(vi, d, d):
            si = iidx + i
            for o in range(nouts):
                l = f's{i}_{y}_{x}'
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
        RY = '0.299, 0.587, 0.114, -0.169, -0.331, 0.5, 0.5, -0.419, -0.081'
        YR = '1, -0.00093, 1.401687, 1, -0.3437, -0.71417, 1, 1.77216, 0.00099'
        if not args.rgb:
            S(f'static const float3x3 RY = {{{RY}}}, YR = {{{YR}}};')
        S('float2 opt = float2(GetOutputPt()), '
          'fpos = (float2(gxy) + 0.5) * opt;')
        if not args.rgb:
            S('float3 yuv;')
        for y, x in np.ndindex(2, 2):
            c = 'xyzw'[y*2 + x]
            src = f'INPUT.SampleLevel(SL, fpos + float2({x}.0, {y}.0) * opt, 0).rgb'
            if args.rgb:
                l = f'saturate({src} + float3(r0.{c}, r1.{c}, r2.{c}))'
            else:
                S(f'yuv = mul(RY, {src});')
                l = f'mul(YR, float3(saturate(yuv.r + r0.{c}), yuv.yz))'
            S(f'OUTPUT[gxy + int2({x}, {y})] = float4({l}, 1.0);')

    S(CLOSEBR, t=-1)

    return texs

GPL = """
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

def main(_m, _args, help):
    global m, args
    m = _m
    args = _args

    parser = argparse.ArgumentParser()
    if help:
        return parser.format_help()
    ex_args = parser.parse_args(args.extra)

    header = (f'// CuNNy {args.name.replace("-", " ")} - '
               'https://github.com/funnyplanter/CuNNy\n' + GPL + '\n')

    suf = args.name[args.name.rfind("NVL")+3:].replace('-', '')
    suf += '-' if suf != '' else ''
    header += HEADER.replace('__SORT__', f'CuNNy-{suf}{args.size:07}')

    texs = ['INPUT']
    relu = 'max(X, 0.0)'
    for name, k, n_conv in gen_iter(m):
        if name.startswith('cin'):
            texs = write('in', k, relu, texs)
        elif name.startswith('conv'):
            texs = write(f'conv{n_conv}', k, relu, texs)
        elif name.startswith('cout'):
            texs = write('out-shuffle', k, None, texs)

    header += ''.join(img.src for img in imgs.values())
    shader = [header] + get_shader()

    return f'CuNNy-{args.stem}.hlsl', ''.join(shader)
