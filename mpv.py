# converts the CuNNy model to an mpv usershader
import numpy as np
import argparse
from common import *

def weight(ws, x, y, ich, och, d, iidx, oidx, l):
    w = [fmt(v) for v in ws[4*oidx:4*(1+oidx), 4*iidx:4*(1+iidx), y, x]
                            .swapaxes(0, 1).ravel().tolist()]
    if ich >= 4:
        mtype = 'M4'
    elif ich == 3:
        mtype = 'M3x4'
    else:
        mtype = 'V4'
    return f'{mtype}({", ".join(w)}) * {l}'

def rectdim(n):
    for i in range(min(int(n ** 0.5), 2), 0, -1):
        d, m = divmod(n, i)
        if m == 0:
            return d, i

def swizzle(n, i):
    w, h = rectdim(n)
    return i % w, i // w

def prelude(ps, ins, sz, nouts=1, loadfn=False, save=None, header=None,
            half=True, exts=[], compute=(8, 8), realsz=None):
    S(f'')
    S(f'//!DESC CuNNy-{args.name} : {ps} ({sz[1]}x{sz[0]})')
    S(f'//!HOOK {basetex}')
    shuffle = ps == 'out-shuffle'
    w, h = (2, 2) if shuffle else rectdim(nouts)
    if not realsz:
        realsz = compute
    S(f'//!COMPUTE {realsz[0] * w} {realsz[1] * h} {compute[0]} {compute[1]}')
    if shuffle:
        if ins[1][0] != basetex:
            S(f'//!BIND {basetex}')
        save = False
    for inv in ins:
        S(f'//!BIND {inv[0]}')
        if save:
            if inv[0] != basetex:
                S(f'//!BIND {basetex}')
            S(f'//!SAVE {save}')
    ins = [ins[0]] if shuffle else ins
    S(f'//!WIDTH {basetex}.w' + (f' {w} *' if w > 1 else ''))
    S(f'//!HEIGHT {basetex}.h' + (f' {h} *' if h > 1 else ''))
    S(f'//!COMPONENTS {1 if shuffle else 4}')
    S(f'//!WHEN OUTPUT.w {basetex}.w / 1.3 > OUTPUT.h {basetex}.h / 1.3 > *')
    if half and exts == []:
        S(f'#extension GL_EXT_shader_explicit_arithmetic_types_float16 : enable')
        S(f'#ifdef GL_EXT_shader_explicit_arithmetic_types_float16')
        S(f'#\tdefine V4 f16vec4')
        S(f'#\tdefine M4 f16mat4')
        S(f'#\tdefine F float16_t')
        if ps == 'in':
            S(f'#\tdefine M3x4 f16mat3x4')
            S(f'#\tdefine V3 f16vec3')
        S(f'#else')
        S(f'#\tdefine V4 vec4')
        S(f'#\tdefine M4 mat4')
        S(f'#\tdefine F float')
        if ps == 'in':
            S(f'#\tdefine M3x4 mat3x4')
            S(f'#\tdefine V3 vec3')
        S(f'#endif')
    else:
        for ext in exts:
            S(f'#extension {ext} : require')
        if half:
            S(f'#define V4 f16vec4')
            S(f'#define M4 f16mat4')
            S(f'#define F float16_t')
    if header:
        S(header)
    if loadfn:
        assert(len(ins) == 1)
        inv = ins[0]
        for i in range(inv[1]):
            iw, ih = rectdim(inv[1])
            x, y = swizzle(inv[1], i)
            v = (f'({inv[0]}_mul * texelFetch('
                 f'{inv[0]}_raw, clamp(pos + ivec2(x, y), ivec2(0), sz)'
                 f' * ivec2({iw}, {ih}) + ivec2({x}, {y}), 0))')
            if half:
                if ps == 'in':
                    elm = 'rgb' if args.rgb else 'r'
                    f = f'{"V3" if args.rgb else "F"}({v}.{elm})'
                else:
                    f = f'V4({v})'
            else:
                f = f'{v}.r' if half else f'{v}'
            S(f'#define l{i}(x, y) {f}')

def write_dp4a(ps, k, actfn, ins, ws, sz):
    shuffle = ps == 'out-shuffle'
    assert(len(ins) == (2 if shuffle else 1))
    inv = ins[0]
    assert(inv[0] != basetex)

    och = sz[0]
    ich = sz[1]
    d = sz[2]
    cent = d // 2
    nins = ich // 4
    nouts = och // 4
    iw, ih = rectdim(inv[1])
    gather = iw % 2 == 0 and ih % 2 == 0

    stype = 'F' if ps == 'in' else 'V4'
    assert(stype == 'V4')

    tsz = (8, 8)
    ssz = (tsz[0] + d - 1, tsz[1] + d - 1)

    tex = f'{ps}'
    prelude(ps, ins, sz, nouts, loadfn=not gather, save=tex, half=False,
            compute=tsz, exts = [
        'GL_EXT_spirv_intrinsics'
    ])

    # perhaps not the best way to quantize, but seems to work well enough
    qf_norm = 1.
    dqf_norm = 1. / qf_norm
    qf = 127. * qf_norm
    dqf = 1. / qf
    quant = lambda x: (x * qf).round().clip(-127., 127.)

    wsorig = ws.copy()
    ws = quant(ws)

    # *AccSat isn't supported natively on most desktop GPUs so do the addition
    # manually
    S('spirv_instruction (extensions = [\"SPV_KHR_integer_dot_product\"], '
      'capabilities = [6019, 6018], id = 4450)\n'
      'int dp4(int a, int b, spirv_literal int fmt);')

    dp4s = [f'dp4(s, {w}, 0)' for w in 'abcd']
    S(f'#define D(r, s, a, b, c, d) r + ivec4({", ".join(dp4s)})')

    S(f'shared int G[{nins}][{ssz[1]}][{ssz[0]}];')

    S(f'void hook() {OPENBR}', t=1)
    S(f'ivec2 xy = ivec2(gl_LocalInvocationID.xy);')
    S(f'ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2({tsz[0]}, {tsz[1]}) + xy;')
    w, h = (2, 2) if shuffle else rectdim(nouts)
    S(f'ivec2 opos = pos * ivec2({w}, {h});')
    S(f'ivec2 sz = ivec2({basetex}_size) - ivec2(1);')

    S(f'for (int y = 0; y < {ssz[1]}; y += {tsz[1]}) {OPENBR}', t=1)
    S(f'int ay = xy.y + y;')
    S(f'if (ay >= {ssz[1]}) break;')
    S(f'for (int x = 0; x < {ssz[0]}; x += {tsz[0]}) {OPENBR}', t=1)
    S(f'int ax = xy.x + x;')
    S(f'if (ax >= {ssz[0]}) break;')
    cent = d // 2
    mul_qfnorm = '' if qf_norm == 1. else f' * {fmt(qf_norm, 7)}'
    if gather:
        S('vec2 p;')
        S(f'vec4 {", ".join(f"{e}" for e in "rgba")};')
        i = 0
        for y in range(0, ih, 2):
            for x in range(0, iw, 2):
                S(f'p = vec2(clamp(pos + ivec2(x - {cent}, y - {cent}), '
                    'ivec2(0), sz) '
                  f'* ivec2({iw}, {ih}) + ivec2({x + 1}, {y + 1})) '
                  f'* {inv[0]}_pt;')
                for j, e in enumerate('rgba'):
                    S(f'{e} = {inv[0]}_gather(p, {j});')
                for j, c in enumerate('wzxy'):
                    S(f'vec4 v{i+j} = vec4(r.{c}, g.{c}, b.{c}, a.{c})'
                      f'{mul_qfnorm};')
                i += 4
    else:
        for i in range(0, nins):
            S(f'vec4 v{i} = l{i}(x - {cent}, y - {cent}){mul_qfnorm};')
    for i in range(0, nins):
        S(f'G[{i}][ay][ax] = int(packSnorm4x8(v{i}));')
    S(CLOSEBR, t=-1)
    S(CLOSEBR, t=-1)
    S('barrier();')

    I = min(2, nins)
    O = min(8, nouts)
    S(f'int {", ".join(f"s{i}_{y}_{x}" for i, y, x in np.ndindex(I, d, d))};')

    S(f'ivec4 {", ".join(f"r{i}" for i in range(O))};')
    S(f'vec4 {", ".join(f"f{i}" for i in range(O))};')

    for oidx in range(0, nouts, O):
        vo = min(O, nouts - oidx)
        S(f'{" ".join(f"r{i} = ivec4(0);" for i in range(vo))}')

        for iidx in range(0, max(ich // 4, 1), I):
            vi = min(I, nins - iidx)

            sbuf = []
            for i, y, x in np.ndindex(vi, d, d):
                s = f'G[{iidx+i}][xy.y+{y}][xy.x+{x}]'
                sbuf += [f's{i}_{y}_{x} = {s};']
                if len(sbuf) == 2:
                    S(' '.join(sbuf))
                    sbuf = []
            if sbuf:
                S(' '.join(sbuf))
            for i, y, x in np.ndindex(vi, d, d):
                l = f's{i}_{y}_{x}'
                si = iidx + i
                for o in range(vo):
                    so = oidx + o
                    w = [ws[4*so+j, 4*si:4*(si+1), y, x] \
                            .astype(np.int8).view(np.uint32).item()
                         for j in range(4)]
                    w = ', '.join(f'0x{v:08X}' for v in w)
                    S(f'r{o} = D(r{o}, {l}, {w});')

        for o in range(vo):
            so = oidx + o
            S(f'f{o} = vec4(r{o}) * {fmt(dqf_norm / (127.**2), 7)};')
            bn = k + 'bias'
            if bn in m:
                b = [fmt(v.item()) for v in m[bn].ravel()[4*so:4*(so+1)]]
                S(f'f{o} += vec4({", ".join(b)});')
            if actfn:
                S(f'f{o} = {actfn.replace("T", "vec4").replace("X", f"f{o}")};')
            if shuffle:
                break
            nw, nh = rectdim(nouts)
            if nw % 2 == 0 and nh % 2 == 0:
                sqidx = so // 4
                sq = so % 4
                sqy = sq // 2
                sqx = sq % 2 + 2 * sqidx
                S(f'imageStore(out_image, opos + ivec2({sqx}, {sqy}), f{o});')
            else:
                x, y = swizzle(nouts, so)
                S(f'imageStore(out_image, opos + ivec2({x}, {y}), f{o});')

    if shuffle:
        base = ins[1][0]
        S(f'vec2 opt = 0.5 * {basetex}_pt;')
        S(f'vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;')
        for y, x in np.ndindex(2, 2):
            c = 'xyzw'[y * 2 + x]
            S(f'imageStore(out_image, opos + ivec2({x}, {y}), '
              f'vec4(f0.{c} + {base}_tex(fpos + vec2({x}.0, {y}.0) * opt).r,'
                     ' 0.0, 0.0, 1.0));')

    S(CLOSEBR, t=-1)

    return [(tex, nouts)]

def write(ps, k, actfn, ins):
    shuffle = ps == 'out-shuffle'
    assert(len(ins) == (2 if shuffle else 1))
    inv = ins[0]
    ws = m[k+'weight']
    sz = ws.shape
    och = sz[0]
    ich = sz[1]
    d = sz[2]

    if args.quant_8 and ps != 'in' and not shuffle:
        ws = ws.clip(-1., 1.)

    # if there's too little math dp4a seems to decrease performance
    DP4A_PERF_THRES = 32
    if (not ex_args.fp16 and args.quant_8 and ich >= 4 and ich*och >= DP4A_PERF_THRES
        and not shuffle):
        return write_dp4a(ps, k, actfn, ins, ws, sz)

    tex = f'{ps}'
    nouts = och // 4
    iw, ih = rectdim(inv[1])
    gather = iw % 2 == 0 and ih % 2 == 0
    tsz = (8, 8)
    ssz = (tsz[0] + d - 1, tsz[1] + d - 1)

    prelude(ps, ins, sz, nouts, loadfn=not gather, save=tex, compute=tsz)
    stype = 'V4'
    if ps == 'in':
        stype = 'V3' if args.rgb else 'F'
    nins = max(ich // 4, 1)

    S(f'shared {stype} G[{nins}][{ssz[1]}][{ssz[0]}];')

    S(f'void hook() {OPENBR}', t=1)
    S(f'ivec2 xy = ivec2(gl_LocalInvocationID.xy);')
    S(f'ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2({tsz[0]}, {tsz[1]}) + xy;')
    w, h = (2, 2) if shuffle else rectdim(nouts)
    S(f'ivec2 opos = pos * ivec2({w}, {h});')
    S(f'ivec2 sz = ivec2({basetex}_size) - ivec2(1);')

    S(f'for (int y = 0; y < {ssz[1]}; y += {tsz[1]}) {OPENBR}', t=1)
    S(f'int ay = xy.y + y;')
    S(f'if (ay >= {ssz[1]}) break;')
    S(f'for (int x = 0; x < {ssz[0]}; x += {tsz[0]}) {OPENBR}', t=1)
    S(f'int ax = xy.x + x;')
    S(f'if (ax >= {ssz[0]}) break;')
    cent = d // 2
    if gather:
        S('vec2 p;')
        i = 0
        for y in range(0, ih, 2):
            for x in range(0, iw, 2):
                S(f'p = vec2(clamp(pos + ivec2(x - {cent}, y - {cent}), '
                                  'ivec2(0), sz)'
                  f' * ivec2({iw}, {ih}) + ivec2({x + 1}, {y + 1}))'
                  f' * {inv[0]}_pt;')
                for j, c in enumerate('rgba'):
                    S(f'{stype} s{c}{i} = {stype}({inv[0]}_gather(p, {j}));')
                for j, c in enumerate('wzxy'):
                    S(f'G[{i * 4 + j}][ay][ax] = '
                      f'{stype}(sr{i}.{c}, sg{i}.{c}, sb{i}.{c}, sa{i}.{c});')
                i += 1
    else:
        for iidx in range(0, nins):
            S(f'G[{iidx}][ay][ax] = l{iidx}(x - {cent}, y - {cent});')
    S(CLOSEBR, t=-1)
    S(CLOSEBR, t=-1)
    S(f'barrier();')

    I = min(2, nins)
    O = min(8, nouts)

    S(f'{stype} {", ".join(f"s{i}_{y}_{x}" for i, y, x in np.ndindex(I, d, d))};')

    S(f'V4 {", ".join(f"r{i}" for i in range(O))};')
    for oidx in range(0, nouts, O):
        vo = min(O, nouts - oidx)

        S(f'{" ".join(f"r{i} = V4(0.0);" for i in range(vo))}')

        for iidx in range(0, max(ich // 4, 1), I):
            vi = min(I, nins - iidx)

            sbuf = []
            for i, y, x in np.ndindex(vi, d, d):
                si = iidx + i
                s = f'G[{si}][xy.y+{y}][xy.x+{x}]'
                sbuf += [f's{i}_{y}_{x} = {s};']
                if len(sbuf) == 2:
                    S(' '.join(sbuf))
                    sbuf = []
            if sbuf:
                S(' '.join(sbuf))
            for i, y, x in np.ndindex(vi, d, d):
                si = iidx + i
                l = f's{i}_{y}_{x}'
                for o in range(vo):
                    so = oidx + o
                    wstr = weight(ws, x, y, ich, och, d, si, so, l)
                    S(f'r{o} += {wstr};')

        for o in range(vo):
            bn = k + 'bias'
            so = oidx + o
            if bn in m and not np.all(m[bn] < 1e-5):
                b = [fmt(v.item()) for v in m[bn].ravel()[4*so:4*(so+1)]]
                S(f'r{o} += V4({", ".join(b)});')
            if actfn:
                S(f'r{o} = {actfn.replace("T", "V4").replace("X", f"r{o}")};')
            if shuffle:
                break
            nw, nh = rectdim(nouts)
            if nw % 2 == 0 and nh % 2 == 0:
                sqidx = so // 4
                sq = so % 4
                sqy = sq // 2
                sqx = sq % 2 + 2 * sqidx
                S(f'imageStore(out_image, opos + ivec2({sqx}, {sqy}), vec4(r{o}));')
            else:
                x, y = swizzle(nouts, so)
                S(f'imageStore(out_image, opos + ivec2({x}, {y}), vec4(r{o}));')

        if shuffle:
            base = ins[1][0]
            S(f'vec2 opt = 0.5 * {basetex}_pt;')
            S(f'vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;')
            for y, x in np.ndindex(2, 2):
                c = 'xyzw'[y * 2 + x]
                elm = 'rgb' if args.rgb else 'r'
                add = f'vec3(r0.{c}, r1.{c}, r2.{c})' if args.rgb else f'r0.{c}'
                pad = ('0.0, 0.0, ' if not args.rgb else '') + '1.0'
                S(f'imageStore(out_image, opos + ivec2({x}, {y}), '
                  f'vec4({add} + {base}_tex(fpos + vec2({x}.0, {y}.0) * opt).{elm},'
                       f' {pad}));')

    S(CLOSEBR, t=-1)

    return [(tex, nouts)]

LGPL = """
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 3.0 of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""

def main(_m, _args, help):
    global m, args, ex_args, basetex
    m = _m
    args = _args

    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--fp16', action='store_true')
    if help:
        return parser.format_help()
    ex_args = parser.parse_args(args.extra)

    S(f'// CuNNy {args.name.replace("-", " ")}{" (dp4a)" if args.quant_8 and not ex_args.fp16 else ""}'
       ' - https://github.com/funnyplanter/CuNNy')
    S(f'// Copyright (c) 2024 funnyplanter')
    S(LGPL, end='')
    S('/* ------------------------------------------------------------------- */')

    basetex = 'MAIN' if args.rgb else 'LUMA'
    texs = [(basetex, 1)]
    relu = 'clamp(X, T(0.0), T(1.0))' if args.quant else 'max(X, T(0.0))'

    for name, k, n_conv in gen_iter(m):
        if name.startswith('cin'):
            texs = write('in', k, relu, texs)
        elif name.startswith('conv'):
            texs = write(f'conv{n_conv}', k, relu, texs)
            n_conv += 1
        elif name.startswith('cout'):
            texs = write('out-shuffle', k, None, texs + [(basetex, 1)])

    return f'CuNNy-{args.stem}.glsl', ''.join(get_shader())
