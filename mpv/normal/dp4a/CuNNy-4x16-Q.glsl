// CuNNy 4x16 (dp4a)
// Copyright (c) 2024 funnyplanter

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
/* ------------------------------------------------------------------- */


//!DESC CuNNy-4x16-in
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND LUMA
//!SAVE in
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : enable
#ifdef GL_EXT_shader_explicit_arithmetic_types_float16
#	define V4 f16vec4
#	define M4 f16mat4
#	define F float16_t
#else
#	define V4 vec4
#	define M4 mat4
#	define F float
#endif
#define l0(x, y) F((LUMA_mul * texelFetch(LUMA_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(1, 1) + ivec2(0, 0), 0)).r)
shared F G[1][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 2);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			G[0][ay][ax] = l0(x - 1, y - 1);
		}
	}
	barrier();
	F s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2;
	V4 r0, r1, r2, r3;
	r0 = V4(0.0); r1 = V4(0.0); r2 = V4(0.0); r3 = V4(0.0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2];
	r0 += V4(-1.350e-02, -6.844e-02, 4.352e-02, -4.184e-02) * s0_0_0;
	r1 += V4(7.871e-01, 3.158e-01, -1.476e-03, -2.338e-02) * s0_0_0;
	r2 += V4(3.408e-03, 5.126e-03, -1.252e-02, 3.320e-02) * s0_0_0;
	r3 += V4(-2.187e-02, 1.086e-01, 2.240e-02, 9.114e-03) * s0_0_0;
	r0 += V4(1.594e-02, -7.892e-01, -1.184e-01, -6.485e-02) * s0_0_1;
	r1 += V4(5.235e-02, 1.047e-01, -6.534e-03, 1.003e-03) * s0_0_1;
	r2 += V4(-9.753e-03, -1.092e-01, 1.343e-01, -5.063e-02) * s0_0_1;
	r3 += V4(7.810e-02, -8.242e-02, 3.959e-02, -1.314e-02) * s0_0_1;
	r0 += V4(-1.527e-02, -4.092e-02, -2.470e-01, -4.855e-01) * s0_0_2;
	r1 += V4(-4.101e-03, 3.461e-02, 5.601e-03, 3.599e-02) * s0_0_2;
	r2 += V4(6.835e-03, 7.386e-02, 1.262e-01, 2.962e-02) * s0_0_2;
	r3 += V4(-7.754e-02, -1.537e-02, -7.251e-02, 5.825e-03) * s0_0_2;
	r0 += V4(1.266e-02, 4.010e-02, 6.271e-02, -9.755e-03) * s0_1_0;
	r1 += V4(-7.935e-01, 1.025e-01, -8.457e-01, -2.965e-02) * s0_1_0;
	r2 += V4(-7.654e-03, -2.936e-02, 6.378e-02, -5.862e-02) * s0_1_0;
	r3 += V4(-2.186e-03, 9.786e-02, 1.225e-01, 3.423e-02) * s0_1_0;
	r0 += V4(1.221e+00, 8.345e-01, 6.144e-01, 3.728e-01) * s0_1_1;
	r1 += V4(-3.604e-02, -5.769e-01, -1.560e-04, 7.346e-01) * s0_1_1;
	r2 += V4(-8.276e-01, -6.340e-01, -1.097e+00, -6.895e-01) * s0_1_1;
	r3 += V4(-3.216e-01, -3.951e-01, -4.149e-01, -2.961e-02) * s0_1_1;
	r0 += V4(1.731e-02, 3.034e-02, -3.818e-01, -1.146e-01) * s0_1_2;
	r1 += V4(-1.703e-04, -3.872e-02, -5.100e-03, -4.211e-01) * s0_1_2;
	r2 += V4(8.348e-01, 7.050e-01, 4.387e-01, 7.168e-01) * s0_1_2;
	r3 += V4(4.872e-01, 2.584e-01, 6.803e-02, -9.220e-03) * s0_1_2;
	r0 += V4(-1.732e-02, 1.188e-02, -7.744e-02, 2.301e-02) * s0_2_0;
	r1 += V4(2.258e-03, -1.283e-02, 8.486e-01, 2.735e-02) * s0_2_0;
	r2 += V4(4.664e-03, -3.058e-03, -9.358e-03, 2.885e-02) * s0_2_0;
	r3 += V4(2.868e-02, -2.065e-01, 1.165e-01, 8.041e-01) * s0_2_0;
	r0 += V4(1.929e-02, -1.093e-02, 8.951e-02, -3.429e-02) * s0_2_1;
	r1 += V4(-1.095e-02, -1.198e-02, 4.116e-03, -1.950e-01) * s0_2_1;
	r2 += V4(-2.471e-02, -1.010e-01, 1.460e-01, -9.302e-02) * s0_2_1;
	r3 += V4(-5.913e-03, 4.878e-01, 1.233e-01, -7.920e-01) * s0_2_1;
	r0 += V4(-1.619e-02, -7.599e-03, 1.443e-02, -1.995e-02) * s0_2_2;
	r1 += V4(2.757e-03, 4.312e-02, 1.414e-03, -1.265e-01) * s0_2_2;
	r2 += V4(1.849e-02, 9.348e-02, 1.693e-02, 7.446e-02) * s0_2_2;
	r3 += V4(-1.238e-01, -2.529e-01, -3.186e-02, -1.078e-02) * s0_2_2;
	r0 += V4(-1.199e+00, 1.145e-02, 3.481e-03, 1.391e-03);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(3.645e-03, -1.629e-02, 5.507e-04, 1.394e-02);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(1.020e-03, 1.607e-02, -7.814e-03, -1.999e-02);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r2));
	r3 += V4(7.504e-03, 2.831e-03, 4.050e-02, 3.469e-03);
	r3 = clamp(r3, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r3));
}

//!DESC CuNNy-4x16-conv1
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND in
//!BIND LUMA
//!SAVE conv1
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 2);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * in_pt;
			r = in_gather(p, 0);
			g = in_gather(p, 1);
			b = in_gather(p, 2);
			a = in_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x36E1FDB6, 0xF0000A5D, 0x28F108D9, 0xCDFA0326);
	r1 = D(r1, s0_0_0, 0xF90DFAF5, 0xFC08089B, 0x0003FFF0, 0xFDFE0101);
	r2 = D(r2, s0_0_0, 0x64E3FB81, 0x0F0A0592, 0xFA03FF01, 0x0203FF20);
	r3 = D(r3, s0_0_0, 0xF7010C03, 0xFF0F09B5, 0xE1F5FA07, 0x02FF02E7);
	r0 = D(r0, s0_0_1, 0x0E08F67F, 0xC60C0181, 0xDF0D01D1, 0x2900FFD8);
	r1 = D(r1, s0_0_1, 0xF70C01FA, 0xEC21F2F8, 0x0CFAFA7F, 0x0202FFEE);
	r2 = D(r2, s0_0_1, 0x533CBFF4, 0xFBFBFB07, 0x0E19F890, 0xF3F5FA4D);
	r3 = D(r3, s0_0_1, 0xF2F7FF81, 0xFE2EE818, 0xFEE61622, 0x010101B2);
	r0 = D(r0, s0_0_2, 0x04F603C1, 0x15FA0C0A, 0xEF16F197, 0xE9F60E35);
	r1 = D(r1, s0_0_2, 0xFC0AFC14, 0x0CFCFFC3, 0xF8FD08E5, 0x0601FECC);
	r2 = D(r2, s0_0_2, 0x1BFE05AC, 0xF6FC057F, 0x0E05F5C7, 0xF7030C1E);
	r3 = D(r3, s0_0_2, 0xEF0404F9, 0xFD02FDC5, 0xF4000BD5, 0x0CFAFE1E);
	r0 = D(r0, s0_1_0, 0xA0B030FF, 0x3F2DF50C, 0xF403F124, 0x2626E681);
	r1 = D(r1, s0_1_0, 0x1E18FDC3, 0xB0F213BB, 0x1F1D3E25, 0xD5F60788);
	r2 = D(r2, s0_1_0, 0x81D944A5, 0xEEF2FF81, 0x35FD180A, 0xF00CF3EE);
	r3 = D(r3, s0_1_0, 0x02EA012A, 0x00110E3E, 0xEDE22358, 0xE605FE05);
	r0 = D(r0, s0_1_1, 0xEDC081B3, 0xC9A95B7F, 0xAAF20667, 0x7F81DC4B);
	r1 = D(r1, s0_1_1, 0xE01D0F81, 0x1B49EB6D, 0xFAD2BC81, 0xE5061108);
	r2 = D(r2, s0_1_1, 0xB300BAF2, 0x01FEFD38, 0xEFF3017F, 0xFD25DDFB);
	r3 = D(r3, s0_1_1, 0xF22EF324, 0x30E30CC9, 0x2116E6BC, 0xEE0A0881);
	r0 = D(r0, s0_1_2, 0x05E002C4, 0x51D1B6B7, 0x0C0C01F9, 0xF1F535C7);
	r1 = D(r1, s0_1_2, 0x1407E37F, 0xE715F23F, 0x1207081D, 0xFE04FDA9);
	r2 = D(r2, s0_1_2, 0xDF11E4F5, 0x04090D81, 0xE911ED81, 0xEBF42DC8);
	r3 = D(r3, s0_1_2, 0x03060418, 0x10ECE65D, 0xF414F658, 0x0FF3FD30);
	r0 = D(r0, s0_2_0, 0xDAFBF5CE, 0xC117E7ED, 0xFAF1EBFD, 0x55F126BB);
	r1 = D(r1, s0_2_0, 0xC325D024, 0x81DD140E, 0x07F9E8FC, 0xBFF6C3DC);
	r2 = D(r2, s0_2_0, 0xCFF70760, 0x10E2E281, 0x0008F814, 0x1664EAB0);
	r3 = D(r3, s0_2_0, 0xDF0BF8C7, 0x81120781, 0x0B02D2C9, 0x04FDEABF);
	r0 = D(r0, s0_2_1, 0x0A03B681, 0x18F1172C, 0xE3142A3B, 0x5E0AEB1A);
	r1 = D(r1, s0_2_1, 0x2FF97F08, 0xC2D144BB, 0xF90DE004, 0xEE060CDD);
	r2 = D(r2, s0_2_1, 0xF0DCE01B, 0x1EF3DC81, 0xD2E40846, 0x17FE4D7F);
	r3 = D(r3, s0_2_1, 0x07FD27D1, 0x988493CB, 0x20CCDFFD, 0x1F027F7F);
	r0 = D(r0, s0_2_2, 0x28EF2569, 0x25FE09F9, 0xE9010181, 0x26F62223);
	r1 = D(r1, s0_2_2, 0xF30EF204, 0x1601DA23, 0x10F10CE6, 0x010405E1);
	r2 = D(r2, s0_2_2, 0x0DFA097F, 0xF9F615BD, 0xF1030D03, 0x0CEC2191);
	r3 = D(r3, s0_2_2, 0xFB08F1F7, 0xF412D981, 0x01F5EECD, 0xFFEDEB17);
	r0 = D(r0, s1_0_0, 0x02F822F9, 0x3D0A0904, 0xF6010AFD, 0xEF040AFC);
	r1 = D(r1, s1_0_0, 0x04000300, 0x190CEF08, 0x00FF0603, 0xED04FC02);
	r2 = D(r2, s1_0_0, 0xDBFC0903, 0xF105FB03, 0x0E0106FE, 0x0E0703FB);
	r3 = D(r3, s1_0_0, 0x18E8F108, 0xF103F2FC, 0x36080906, 0x08FB01FD);
	r0 = D(r0, s1_0_1, 0x1DBC37DB, 0x26F9F4F2, 0xEE0501FB, 0x1018F60F);
	r1 = D(r1, s1_0_1, 0x040D0108, 0xE321EEF7, 0x3BAF00FF, 0x03F30408);
	r2 = D(r2, s1_0_1, 0x028C20C9, 0xFC07E90B, 0x0CE5FCFF, 0xE8270403);
	r3 = D(r3, s1_0_1, 0xF10BFFFC, 0x26F3F600, 0x1916D81B, 0x0209FF05);
	r0 = D(r0, s1_0_2, 0x288105EB, 0xFD19F432, 0xE2810708, 0x2181E11B);
	r1 = D(r1, s1_0_2, 0xF202FA04, 0xF4D11413, 0x044EF9FD, 0xF8FEFEFF);
	r2 = D(r2, s1_0_2, 0xEFD2FADE, 0x12271227, 0xF80E0405, 0x07EC0A09);
	r3 = D(r3, s1_0_2, 0x03161008, 0x0D181D08, 0x02F905FE, 0x04FE06FA);
	r0 = D(r0, s1_1_0, 0xF30A1303, 0x09FEFCF5, 0x27030904, 0xFAF3EEF9);
	r1 = D(r1, s1_1_0, 0x4607F6FF, 0xE206DE11, 0x18FFFF01, 0xF6FE05F9);
	r2 = D(r2, s1_1_0, 0xFA0B0309, 0xEAF6F1FD, 0x0DFEED02, 0xF307F4FF);
	r3 = D(r3, s1_1_0, 0x19FC81FC, 0xC9061A07, 0xE30B28F2, 0x0CFEFFFF);
	r0 = D(r0, s1_1_1, 0x35E9D2E1, 0xFB05F2F8, 0xCF21090E, 0xD3051B0E);
	r1 = D(r1, s1_1_1, 0xE62BFD09, 0x0328DA14, 0xFD09E817, 0x09471013);
	r2 = D(r2, s1_1_1, 0x0F043F04, 0x1219FC0A, 0x35F7FCEF, 0xDDF904FB);
	r3 = D(r3, s1_1_1, 0xF681C381, 0x68BAA8EA, 0x198124DF, 0xE21E06FE);
	r0 = D(r0, s1_1_2, 0xFF3E090E, 0xF3122FDB, 0x04F416DC, 0x12BD38EA);
	r1 = D(r1, s1_1_2, 0xEDF414D6, 0xF8CCE610, 0xF507FB7F, 0xF6F81EF6);
	r2 = D(r2, s1_1_2, 0x022B0BDD, 0x000EE819, 0xE2F72006, 0x0FD4EB23);
	r3 = D(r3, s1_1_2, 0x02E0F217, 0xFA7F14BD, 0xF60D00C6, 0x1511FFFF);
	r0 = D(r0, s1_2_0, 0x100203FD, 0xEDFAED00, 0x1D08EFFA, 0xF0FB3F15);
	r1 = D(r1, s1_2_0, 0x1BFF20FA, 0x29033407, 0xF9FF0000, 0x0D010603);
	r2 = D(r2, s1_2_0, 0x1D080409, 0xEBFF0E0B, 0xFE06F906, 0xF702FC00);
	r3 = D(r3, s1_2_0, 0xFD062708, 0xD7FEEEF5, 0x0D0AF3FD, 0xF2FEF9FF);
	r0 = D(r0, s1_2_1, 0xE809E320, 0xF604F716, 0xF8FBF607, 0x311E33CA);
	r1 = D(r1, s1_2_1, 0xEFFBF30A, 0xFFF44430, 0xFD031001, 0xFB030204);
	r2 = D(r2, s1_2_1, 0xE4FCEE15, 0x0508120E, 0xEC040713, 0x1AFF3520);
	r3 = D(r3, s1_2_1, 0xFD07FCF1, 0x110BE727, 0xF2DA2C2D, 0xFA00F3F7);
	r0 = D(r0, s1_2_2, 0x0708F31E, 0x16F7EEFF, 0x020A8181, 0xEDF1B981);
	r1 = D(r1, s1_2_2, 0xFBFDF3F3, 0xFC011981, 0x0504F1F8, 0x0213F839);
	r2 = D(r2, s1_2_2, 0x0610F636, 0x08FDF5D5, 0x1209ED41, 0x14DC7F81);
	r3 = D(r3, s1_2_2, 0xF0F7F505, 0xFAFE1D15, 0x0C1B07E5, 0x09F01981);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x50051481, 0xB5FEE87F, 0x27F9F0FE, 0x1BF2D114);
	r1 = D(r1, s0_0_0, 0xE5FF0E24, 0x4429DFB7, 0xFD100512, 0x0BFB0FFD);
	r2 = D(r2, s0_0_0, 0x62191985, 0xFD000FF9, 0x010F0EF1, 0x1C00F4E0);
	r3 = D(r3, s0_0_0, 0x37FAEFE1, 0x10021AF4, 0x00EB1FD5, 0x11FCF0FE);
	r0 = D(r0, s0_0_1, 0x65191581, 0x02E6BA6C, 0x2DF80ABE, 0xE6EF2E17);
	r1 = D(r1, s0_0_1, 0xF9FD17EA, 0x7FF4BCB2, 0xF2052AEA, 0x06FE08FC);
	r2 = D(r2, s0_0_1, 0x3E1A1F84, 0xF2E30343, 0x040105E4, 0x22F311C8);
	r3 = D(r3, s0_0_1, 0xECF4F540, 0xFFF6F0F2, 0x1D08F9E7, 0xF4FDFD11);
	r0 = D(r0, s0_0_2, 0xF2F7F614, 0x0F20E9E3, 0xF70805FC, 0xE20B081D);
	r1 = D(r1, s0_0_2, 0xF4081AE9, 0xD5EFE838, 0xF80EEB09, 0x09FCF903);
	r2 = D(r2, s0_0_2, 0xE3F4052A, 0xE0E40448, 0xF3020801, 0xF2FE14F8);
	r3 = D(r3, s0_0_2, 0x0303F413, 0x0FF4FB01, 0xF8F8DF31, 0x0E06F3FF);
	r0 = D(r0, s0_1_0, 0xDEF8BF7C, 0xFF14F326, 0x3ADED981, 0x3BD21381);
	r1 = D(r1, s0_1_0, 0x0812BF48, 0xAE0A7AF1, 0x1802D81C, 0x11F1F57F);
	r2 = D(r2, s0_1_0, 0xFEE1EE3C, 0x3C111EB0, 0x2F0AD0FA, 0xD1FF1D59);
	r3 = D(r3, s0_1_0, 0x7F81CC81, 0xD605B67F, 0x357FE281, 0xEFF12CF8);
	r0 = D(r0, s0_1_1, 0x2AE3EB0C, 0x12F7080E, 0x237F1481, 0xAE4438F6);
	r1 = D(r1, s0_1_1, 0x1703B53E, 0x81D0487F, 0xBBD10E7D, 0xAAE7DC7F);
	r2 = D(r2, s0_1_1, 0xFC0D0A18, 0x1FF7ECD3, 0xE1FFB976, 0x24FA02BC);
	r3 = D(r3, s0_1_1, 0xE403F616, 0x0AC7F17F, 0xED1215F8, 0xF3FA0902);
	r0 = D(r0, s0_1_2, 0x14F1E91A, 0x090B7D81, 0x3EF60DBE, 0xE5DBB37B);
	r1 = D(r1, s0_1_2, 0x100213DF, 0x0C271AC5, 0x280DF8E6, 0x0B0512DF);
	r2 = D(r2, s0_1_2, 0x17FEE2EE, 0xDFC5F17F, 0xFEEFD43A, 0x08FBE408);
	r3 = D(r3, s0_1_2, 0xF1F6FD0B, 0xCA1837FF, 0x030C43A6, 0x07110AE2);
	r0 = D(r0, s0_2_0, 0xF502E618, 0x120006DC, 0x05DCDE45, 0xF2E91AD5);
	r1 = D(r1, s0_2_0, 0x2117F9D9, 0x5F1EE0C0, 0x09FB00FA, 0xF4F8FE1E);
	r2 = D(r2, s0_2_0, 0xDFFDD753, 0x0A0D1EC9, 0xF2FF1DFC, 0xFD0415F8);
	r3 = D(r3, s0_2_0, 0x38F81C87, 0xF3F45781, 0x321CEEBD, 0x050EF9E5);
	r0 = D(r0, s0_2_1, 0xF8F90FFE, 0x0302ECF8, 0x1DFC07E6, 0xDFE4F61C);
	r1 = D(r1, s0_2_1, 0x0C03F8EB, 0x6300B1E6, 0x040417D9, 0xF50524EF);
	r2 = D(r2, s0_2_1, 0xE3E4EF3A, 0xE9FEFD03, 0x0CF4FEE7, 0x7F210B81);
	r3 = D(r3, s0_2_1, 0xFC01FBFC, 0x5703E681, 0xEDDF2A1C, 0x19093AD5);
	r0 = D(r0, s0_2_2, 0xF2082ADD, 0x23F32CA6, 0xEB040910, 0xFBFEF634);
	r1 = D(r1, s0_2_2, 0x06FB1AE3, 0x11F5DC21, 0x0E00F7FF, 0x09FA02F6);
	r2 = D(r2, s0_2_2, 0x200419D0, 0xD7011B17, 0xDEFC1F03, 0x1309DA0D);
	r3 = D(r3, s0_2_2, 0xFA020C06, 0x2BEBDEFB, 0x28FAEAF4, 0xF703DF2A);
	r0 = D(r0, s1_0_0, 0xF200FD4E, 0x0AF42AE1, 0x16F416F2, 0xEEEC10E8);
	r1 = D(r1, s1_0_0, 0x09FFEDFF, 0xFC36CB26, 0xF9020903, 0x0603FCEF);
	r2 = D(r2, s1_0_0, 0x04080BEE, 0xF70EEAFD, 0x0A0808F7, 0x0FFE2108);
	r3 = D(r3, s1_0_0, 0x8120DB08, 0xFB1003FC, 0xF7D11614, 0xFE0D0707);
	r0 = D(r0, s1_0_1, 0x46010DE8, 0xDBF65AD6, 0xFA18160F, 0xCF33D1EF);
	r1 = D(r1, s1_0_1, 0x13F2021C, 0xC2CCE707, 0x04E60704, 0xFD16FCFA);
	r2 = D(r2, s1_0_1, 0x2108F40A, 0x07EC1FE7, 0xE80DFE0D, 0xDBDC1A0E);
	r3 = D(r3, s1_0_1, 0x1DE30FED, 0x7FFB3300, 0xE90BE5F0, 0xF3F2FDEE);
	r0 = D(r0, s1_0_2, 0xF412080B, 0xAB17D912, 0x81FFC913, 0x81CD21E0);
	r1 = D(r1, s1_0_2, 0xEAFB03FF, 0x140BDD21, 0xEEE30912, 0x1205F4FC);
	r2 = D(r2, s1_0_2, 0xEDE40AFF, 0x26E935E6, 0x2906F314, 0x1BFE0623);
	r3 = D(r3, s1_0_2, 0x09F215ED, 0xCA0B15F2, 0x02F719FB, 0x150103FA);
	r0 = D(r0, s1_1_0, 0xFFF7F8C7, 0x000206F4, 0x0AED27ED, 0xFF16B654);
	r1 = D(r1, s1_1_0, 0xFCE8E9D9, 0xFB1DE434, 0xFE0FFEF3, 0x0EE80C0F);
	r2 = D(r2, s1_1_0, 0x05090ED5, 0xFC1AE04E, 0x06040212, 0xFAE50E25);
	r3 = D(r3, s1_1_0, 0xC157F903, 0xF41204F1, 0xF621EE09, 0x02EFF70C);
	r0 = D(r0, s1_1_1, 0x1C0F14EF, 0x0CDDFA05, 0x10F0DA17, 0xED2AD511);
	r1 = D(r1, s1_1_1, 0x07F514FA, 0xE6D90CE3, 0x0E10F4F2, 0x18E6FB09);
	r2 = D(r2, s1_1_1, 0x0EF1FBF9, 0x320DFBD6, 0x0CC4DDCD, 0x8111F5FA);
	r3 = D(r3, s1_1_1, 0x0DF506FF, 0xCAF306F7, 0x150E20EC, 0x0B182FE8);
	r0 = D(r0, s1_1_2, 0x17ED12E7, 0x14FEC71F, 0x0C06F80E, 0x12ED56FA);
	r1 = D(r1, s1_1_2, 0x32FC14FB, 0x2A073A07, 0x151008F8, 0x1DF60503);
	r2 = D(r2, s1_1_2, 0x36040524, 0x09080307, 0x4A22FDE9, 0x9A20CA28);
	r3 = D(r3, s1_1_2, 0x17FC2907, 0x051222E2, 0x26F71423, 0xDA0DFA0A);
	r0 = D(r0, s1_2_0, 0x00F2F911, 0x0905F300, 0x05F218EC, 0xFBF2FBEE);
	r1 = D(r1, s1_2_0, 0xF61F01DB, 0xF81921AF, 0x02FDF409, 0x05F6FFF6);
	r2 = D(r2, s1_2_0, 0x01FB20FF, 0xFE0402F9, 0x05EB02F8, 0x0DFAFB06);
	r3 = D(r3, s1_2_0, 0xFC0C0E2C, 0xFF0C0E31, 0x00081306, 0x000C051A);
	r0 = D(r0, s1_2_1, 0x07F002E8, 0xFBF31B13, 0x02060BFB, 0xFF071C05);
	r1 = D(r1, s1_2_1, 0xFEFF0C17, 0xEDF315FD, 0x0501F907, 0x0B120CFC);
	r2 = D(r2, s1_2_1, 0x08EF13F5, 0xF806EF14, 0x01F21008, 0xE9F8F1A0);
	r3 = D(r3, s1_2_1, 0xF9F90920, 0xECF00C04, 0x0911FAF3, 0xFFF015F2);
	r0 = D(r0, s1_2_2, 0xFCEE0402, 0xF81CF4FB, 0x00120CE6, 0x06F118EC);
	r1 = D(r1, s1_2_2, 0xFFF70203, 0xFB01FDFA, 0xFBFE02F5, 0x060905FD);
	r2 = D(r2, s1_2_2, 0xFEEB2CF3, 0x02F200FA, 0x030C0407, 0xF541E103);
	r3 = D(r3, s1_2_2, 0x03F70BF5, 0xF9000716, 0xFD090FF9, 0xF9F7F50A);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(1.031e-02, 1.105e-03, 2.448e-02, 1.183e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(2.085e-02, -1.219e-02, -1.137e-04, 1.114e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(4.773e-02, -2.119e-03, 1.825e-02, -1.478e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-1.941e-02, -6.276e-03, 4.388e-03, -7.764e-03);
	f3 = clamp(f3, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-conv2
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv1
//!BIND LUMA
//!SAVE conv2
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 2);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv1_pt;
			r = conv1_gather(p, 0);
			g = conv1_gather(p, 1);
			b = conv1_gather(p, 2);
			a = conv1_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFEF909FB, 0xD5C713D2, 0x141E0016, 0x01FA0E2B);
	r1 = D(r1, s0_0_0, 0x270E0F0A, 0xD6F00D26, 0x0CEB0414, 0xF5FD07BF);
	r2 = D(r2, s0_0_0, 0xF2FC01DE, 0x030402FB, 0x0B120305, 0xF000FFF6);
	r3 = D(r3, s0_0_0, 0x060303FC, 0x0F1C13F8, 0x06F4FF04, 0x041A02F7);
	r0 = D(r0, s0_0_1, 0xEDEE100C, 0x8FBAE3E7, 0x0D121AD4, 0xF4D417C6);
	r1 = D(r1, s0_0_1, 0x1D20FCFB, 0x091FFCFE, 0x02040406, 0xE8910781);
	r2 = D(r2, s0_0_1, 0xF8FBF2F0, 0xFEFCFDFD, 0x00FE06E7, 0x08EB0109);
	r3 = D(r3, s0_0_1, 0x000F0003, 0x1939FF58, 0xE60AEEF4, 0x012BFB15);
	r0 = D(r0, s0_0_2, 0xF8F30AE5, 0xCFD910EE, 0xF80DF9F6, 0xF4CD0BCA);
	r1 = D(r1, s0_0_2, 0x081901FD, 0x0B090704, 0xFFF80114, 0xE9561690);
	r2 = D(r2, s0_0_2, 0xEEEBFBCA, 0x0206FE01, 0x02EC0CEE, 0x03E607EC);
	r3 = D(r3, s0_0_2, 0x01FFFE06, 0x0211FFFF, 0xF800F703, 0x0A240200);
	r0 = D(r0, s0_1_0, 0x0405091D, 0xF7C4381C, 0x060AD8E5, 0x0EF933F7);
	r1 = D(r1, s0_1_0, 0x3B1F1812, 0xD7ED09F7, 0xC31CF9EA, 0x0CDA103B);
	r2 = D(r2, s0_1_0, 0xF003F4D3, 0x0EFB0B0E, 0xE31CEEF0, 0xEA1AF8FB);
	r3 = D(r3, s0_1_0, 0x0EF6030F, 0x2BE42713, 0x0BF7FCEF, 0xFFFEF0FB);
	r0 = D(r0, s0_1_1, 0xF3DA1700, 0x03093BED, 0x063D2154, 0x3EF54718);
	r1 = D(r1, s0_1_1, 0x417F05DD, 0x0F1E1718, 0x11060F11, 0xF6FAF508);
	r2 = D(r2, s0_1_1, 0x04F2F8F5, 0xF607F302, 0xFCFDEF2C, 0x0C0408F3);
	r3 = D(r3, s0_1_1, 0xF4EFFD0A, 0xF0C7FBEA, 0xBFEDCA14, 0x01FEE3E5);
	r0 = D(r0, s0_1_2, 0x34C32221, 0xE581F111, 0x0313F94B, 0x15F4FA16);
	r1 = D(r1, s0_1_2, 0x0F32FBDE, 0x17F62810, 0x07F90417, 0xE4DBECD7);
	r2 = D(r2, s0_1_2, 0xFA0EE2D0, 0x02010001, 0xFCFE0909, 0xFC17F30C);
	r3 = D(r3, s0_1_2, 0xFE05FFF8, 0xE6F403E5, 0xFCF5FBF7, 0x0637FDF2);
	r0 = D(r0, s0_2_0, 0xFE01F315, 0xE0181EBC, 0x0C00F502, 0xE60608E5);
	r1 = D(r1, s0_2_0, 0x0B07FAEB, 0x00201AFC, 0xFA1A0224, 0x08F603EF);
	r2 = D(r2, s0_2_0, 0xF4060DBA, 0x0300FE05, 0xFBF8F11D, 0x0800F219);
	r3 = D(r3, s0_2_0, 0x07FBFEFA, 0x26FF04EB, 0x0001F0F4, 0x05F3E718);
	r0 = D(r0, s0_2_1, 0xE5ED001E, 0xE421E7EA, 0x00E2E7BC, 0xECFE0303);
	r1 = D(r1, s0_2_1, 0x232F1BCE, 0x111C2000, 0xF60CF908, 0x04FCEDEB);
	r2 = D(r2, s0_2_1, 0xE0EEDFF0, 0x00F4F915, 0x06FDE50E, 0xE4FDF548);
	r3 = D(r3, s0_2_1, 0x02EBF5F5, 0xF5D1DED5, 0x02FAE1FD, 0x11EACFD4);
	r0 = D(r0, s0_2_2, 0x081C0C29, 0xF8C4EEA8, 0xF720F409, 0xFEF001FC);
	r1 = D(r1, s0_2_2, 0x06170315, 0x0CEC11F9, 0x00010304, 0xF6EDDCD7);
	r2 = D(r2, s0_2_2, 0xEC19E995, 0x0203FA06, 0xFD05FE05, 0xE9E6FDE8);
	r3 = D(r3, s0_2_2, 0x0303FFFA, 0xF8F7F6E6, 0x0002FFF4, 0xFF3211F7);
	r0 = D(r0, s1_0_0, 0xF5020600, 0xE6F913F2, 0x19FCEBF2, 0x08F604F4);
	r1 = D(r1, s1_0_0, 0x01FD01E6, 0xF8000203, 0x04FDFAFE, 0x0CF205EA);
	r2 = D(r2, s1_0_0, 0x0004FE04, 0xFDFF01FC, 0x07FAFB01, 0xFEFD13FD);
	r3 = D(r3, s1_0_0, 0x0001FC02, 0xFEF3F8FD, 0xFAF9FAFE, 0x020408F9);
	r0 = D(r0, s1_0_1, 0xF41218F9, 0xBDF71B03, 0x1101EFD2, 0xCA0D03C5);
	r1 = D(r1, s1_0_1, 0xFEF300F7, 0x04F7FDF0, 0xF4FCF313, 0x01E62681);
	r2 = D(r2, s1_0_1, 0xFD030A25, 0xFA0105FC, 0x1BF9F7E8, 0xF1050811);
	r3 = D(r3, s1_0_1, 0x0501FB01, 0x00F810F9, 0xF20F07FB, 0x1AF9FEDC);
	r0 = D(r0, s1_0_2, 0xFBF90815, 0xAF181BDC, 0xEFF8F6EF, 0xB1F004D1);
	r1 = D(r1, s1_0_2, 0xF003F40D, 0x0BF5EB01, 0xFAFDFC05, 0xF600D194);
	r2 = D(r2, s1_0_2, 0x050C000E, 0x10FCFCFC, 0xF4FA00F1, 0xFB0302F9);
	r3 = D(r3, s1_0_2, 0x02FFF809, 0xF605F70D, 0x05060500, 0x070A04F0);
	r0 = D(r0, s1_1_0, 0x0DE5EF18, 0xEFE51006, 0xF701FCF9, 0x0101F9F8);
	r1 = D(r1, s1_1_0, 0xF90B0105, 0x23DC180C, 0xFDDE1FEB, 0xECFE09FE);
	r2 = D(r2, s1_1_0, 0xFB0CF9FC, 0xFD01FB05, 0xF2F9F0FD, 0xFBFCFF13);
	r3 = D(r3, s1_1_0, 0x010D02FA, 0xEEF609E6, 0x000CF708, 0x000810F8);
	r0 = D(r0, s1_1_1, 0x272820D3, 0x29F83628, 0xB5F110EA, 0x0481E524);
	r1 = D(r1, s1_1_1, 0xB01CF717, 0x0C20E60C, 0xC01DE81A, 0x022A3A30);
	r2 = D(r2, s1_1_1, 0xD82FE01D, 0xF511FE29, 0xF2C422D5, 0x12FBFC2F);
	r3 = D(r3, s1_1_1, 0x45F70CFF, 0x0AE21C21, 0x16F21425, 0x14E61E1C);
	r0 = D(r0, s1_1_2, 0xE88113C9, 0x392127D7, 0x240B0EE7, 0xC0810395);
	r1 = D(r1, s1_1_2, 0x06070122, 0x1FDEC20D, 0xF3F90FFB, 0xFFD10AF8);
	r2 = D(r2, s1_1_2, 0x1F110126, 0x3CFEFD03, 0xE6F814DB, 0x091BFF15);
	r3 = D(r3, s1_1_2, 0x07FBF8FE, 0xE0170907, 0x04220C03, 0x040E19D8);
	r0 = D(r0, s1_2_0, 0x02E60201, 0x0CE31103, 0xFEEE14FB, 0x04FF0D04);
	r1 = D(r1, s1_2_0, 0x0A11F8FB, 0x10DD09F3, 0x02DEFDFC, 0x0BF60D14);
	r2 = D(r2, s1_2_0, 0xFF11E80F, 0x07FE0002, 0xF4F7FDF8, 0x03F4E5FB);
	r3 = D(r3, s1_2_0, 0x00080405, 0xFB0A050C, 0x040401FD, 0x130A050E);
	r0 = D(r0, s1_2_1, 0x10F818EF, 0x0400E51E, 0x0FF221EA, 0xF4090AE9);
	r1 = D(r1, s1_2_1, 0xF8ED02F6, 0xFF00EC09, 0x0DFC0200, 0xFD330A04);
	r2 = D(r2, s1_2_1, 0x0EF2E61E, 0x16FC0802, 0x031A0CFA, 0x1BA7EBF9);
	r3 = D(r3, s1_2_1, 0xF92F0C03, 0xF5FA1521, 0xF82A0D01, 0xFC2202F9);
	r0 = D(r0, s1_2_2, 0x10090BF6, 0xFC2EF516, 0xFBEA13D9, 0x1CF514EB);
	r1 = D(r1, s1_2_2, 0x010A00F5, 0x0CD1F4F5, 0xFD0401FD, 0xF316F708);
	r2 = D(r2, s1_2_2, 0xF411F7F8, 0x16EA01F5, 0xFC1A0902, 0x18001CFC);
	r3 = D(r3, s1_2_2, 0x07FB03EE, 0x19170E02, 0xE914FCFE, 0xEC360CF1);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x1714F805, 0xE10A2A22, 0x0004F60A, 0xEC12F500);
	r1 = D(r1, s0_0_0, 0x1EF1FCFD, 0xF616F1F0, 0x08FAF902, 0x0D0BF228);
	r2 = D(r2, s0_0_0, 0xFCEBFE00, 0x02050202, 0xF3120402, 0xF6EF0211);
	r3 = D(r3, s0_0_0, 0x0201FAFE, 0x16F0F812, 0xF805FBFC, 0x080DFB05);
	r0 = D(r0, s0_0_1, 0xF4EFE4F7, 0xEB5828E8, 0xFE040D16, 0x54D64011);
	r1 = D(r1, s0_0_1, 0xD504090A, 0xE602FFF9, 0x130E0107, 0xB4381625);
	r2 = D(r2, s0_0_1, 0xEFF00CF3, 0xFC030503, 0x03F3F011, 0xFA1510F1);
	r3 = D(r3, s0_0_1, 0x08F9FF04, 0xD4D1EF20, 0xE90CFE06, 0xE705EF02);
	r0 = D(r0, s0_0_2, 0x01F30218, 0x2E28E4D9, 0xD5040812, 0x2C19DD1E);
	r1 = D(r1, s0_0_2, 0x230BFCF4, 0x1B08F20E, 0xF2FDFE01, 0x0312E833);
	r2 = D(r2, s0_0_2, 0x10030102, 0x060300FB, 0x1EFDFD09, 0x0D110403);
	r3 = D(r3, s0_0_2, 0xFB02FFF8, 0xFD00072E, 0xEBFC05F0, 0xE7FCFF07);
	r0 = D(r0, s0_1_0, 0x0518E4FA, 0x121A0710, 0x061D13F7, 0xFCDEF60B);
	r1 = D(r1, s0_1_0, 0xF3E1FC05, 0xF630CCF1, 0xFB2F1001, 0x26F3C706);
	r2 = D(r2, s0_1_0, 0xFE0511FF, 0x08F5FA02, 0x10F1370A, 0x1816260F);
	r3 = D(r3, s0_1_0, 0x05F0E706, 0xFFDE050E, 0xFBF80004, 0xF8F1E700);
	r0 = D(r0, s0_1_1, 0x11B5B9FC, 0x36A5B808, 0xF527FE0F, 0x28D8203B);
	r1 = D(r1, s0_1_1, 0xE8AFF7FD, 0xE2C607EC, 0x1113FE0C, 0xEEEA12CD);
	r2 = D(r2, s0_1_1, 0x37ECEBEA, 0x04F0F0F4, 0x0C5F0D0B, 0x3A15DFE4);
	r3 = D(r3, s0_1_1, 0xFEFF19F9, 0xFB131312, 0xF43DF2D9, 0xDFF313FC);
	r0 = D(r0, s0_1_2, 0x2F17FDF8, 0xF2F214F5, 0x01F50006, 0x170CF520);
	r1 = D(r1, s0_1_2, 0x07050407, 0x1307080A, 0x0102030D, 0x19FA271E);
	r2 = D(r2, s0_1_2, 0x08E5021E, 0x0BF507FB, 0x090701F2, 0x0E12FC09);
	r3 = D(r3, s0_1_2, 0x0405FE02, 0x0C09070F, 0xEBFCFCE3, 0xD90704ED);
	r0 = D(r0, s0_2_0, 0x17FEF000, 0xD4EE12EA, 0x1402E008, 0x07FD170A);
	r1 = D(r1, s0_2_0, 0x02FE0B08, 0xFBF6FAF1, 0xF500FFE5, 0xED04F6F5);
	r2 = D(r2, s0_2_0, 0x02E7060E, 0x06FEFB00, 0xFFFD1104, 0x19D9F416);
	r3 = D(r3, s0_2_0, 0x08F9EC06, 0x080A0306, 0xFBFF0DFC, 0x0701DDFB);
	r0 = D(r0, s0_2_1, 0x11DC0805, 0xF1F50F00, 0x1717DA07, 0x1008FD1A);
	r1 = D(r1, s0_2_1, 0x0F0AEA0D, 0xFF0AFCF0, 0x10F1F60C, 0xFC19F8F9);
	r2 = D(r2, s0_2_1, 0xFE2B0BD8, 0x0E030AFE, 0x11F0EE18, 0xE2DE0CC5);
	r3 = D(r3, s0_2_1, 0x0C0FF90F, 0x131EF1FD, 0x0A070213, 0xFA2DD3E4);
	r0 = D(r0, s0_2_2, 0x10F3FAE7, 0x45F51223, 0xF305FE14, 0xFFF71321);
	r1 = D(r1, s0_2_2, 0x050605FF, 0x0104FAFF, 0xFFFF0202, 0x0E15F526);
	r2 = D(r2, s0_2_2, 0xE9FFF642, 0x06F4FE00, 0xFCF901F4, 0xC4CA042F);
	r3 = D(r3, s0_2_2, 0x04FEFE04, 0x1104FC1D, 0xF809F9F4, 0x10C7EEEA);
	r0 = D(r0, s1_0_0, 0xFEFC15F8, 0xFC0101EA, 0x0B0DF301, 0xF308000A);
	r1 = D(r1, s1_0_0, 0xD80A15FF, 0x210E211C, 0x1108DE1F, 0x0C030BED);
	r2 = D(r2, s1_0_0, 0xF7D707FA, 0xF9FD05F8, 0xE9F6EBFE, 0xF2F611E2);
	r3 = D(r3, s1_0_0, 0x02FF05FE, 0xE506F335, 0x0D0517FE, 0x0705181B);
	r0 = D(r0, s1_0_1, 0x230C09FC, 0xF9E32719, 0xB907F81C, 0x81E2AC46);
	r1 = D(r1, s1_0_1, 0xAEFE23FC, 0xA8EE2001, 0xE80ADB28, 0x8112E91E);
	r2 = D(r2, s1_0_1, 0xE3EDFC16, 0x07000CEC, 0x0302CB08, 0x2406011D);
	r3 = D(r3, s1_0_1, 0x02030BE9, 0x11E5F70C, 0x2DFB2CDE, 0x22FC13FB);
	r0 = D(r0, s1_0_2, 0xE5CB34F5, 0xF70D18C5, 0x0C020013, 0x13201F30);
	r1 = D(r1, s1_0_2, 0xE2121417, 0xA51AE6F3, 0xFD03FAF7, 0x0A2AF428);
	r2 = D(r2, s1_0_2, 0xE6D708F0, 0xFEFB07F6, 0x0515F516, 0xF4FA13AB);
	r3 = D(r3, s1_0_2, 0x03FA0504, 0xF9F8F912, 0xF51512ED, 0x0C130AF3);
	r0 = D(r0, s1_1_0, 0xF70FFD18, 0xD1DA21D6, 0x24050FFE, 0xFAF9FB33);
	r1 = D(r1, s1_1_0, 0xD0120809, 0xC2281AF4, 0xFE0DEF01, 0xF2EC082F);
	r2 = D(r2, s1_1_0, 0xF9DE01F3, 0x00000004, 0x03FAF6E5, 0xCDF1E103);
	r3 = D(r3, s1_1_0, 0xF804050D, 0xF30C1136, 0x070900FC, 0x0D172007);
	r0 = D(r0, s1_1_1, 0x0B1A100C, 0x04C40F33, 0x5F1501E5, 0x97191B49);
	r1 = D(r1, s1_1_1, 0xF32009BE, 0xFED80615, 0xEF150445, 0xF2DF1118);
	r2 = D(r2, s1_1_1, 0x14C3041A, 0x3CFF18F6, 0x2718FB3B, 0x40F90C1B);
	r3 = D(r3, s1_1_1, 0x0F041700, 0xF7DC2FF3, 0x051028E7, 0x24FC3EF5);
	r0 = D(r0, s1_1_2, 0x810BFB54, 0x3015FC81, 0x2BBD1881, 0xB338E376);
	r1 = D(r1, s1_1_2, 0xEBF40026, 0xE227FBB1, 0xF113ED17, 0x0BCA00F4);
	r2 = D(r2, s1_1_2, 0xF5DD0B15, 0x12EF0EEC, 0x17250611, 0xFCBA07F5);
	r3 = D(r3, s1_1_2, 0x04020BF5, 0x19DF1AFC, 0x130316C1, 0x040226DF);
	r0 = D(r0, s1_2_0, 0xFC04041C, 0xF11A039A, 0xFCF8FE17, 0xE9FDFA1C);
	r1 = D(r1, s1_2_0, 0xFDFBFD0D, 0xE90910EA, 0xFF0D0100, 0xFBF505E4);
	r2 = D(r2, s1_2_0, 0xEFF30F18, 0x01FA0204, 0x1009FEEF, 0xEC0EF625);
	r3 = D(r3, s1_2_0, 0xF7FE050F, 0xFE00071D, 0x0AF9FCED, 0xE3061100);
	r0 = D(r0, s1_2_1, 0xFD0D0119, 0xE7F00A4E, 0x1CE708E6, 0x2FEEF5E5);
	r1 = D(r1, s1_2_1, 0x0B090710, 0xFFFBFAFB, 0x01030156, 0x15E61203);
	r2 = D(r2, s1_2_1, 0xCFD8FB29, 0x0AF1FE0C, 0x110E013D, 0xE523E0FF);
	r3 = D(r3, s1_2_1, 0x02F50012, 0xF1F514C7, 0x11F705D1, 0x08F01414);
	r0 = D(r0, s1_2_2, 0xFE0D07F5, 0x0219FB7F, 0x15FBFAD3, 0x1BE4FB14);
	r1 = D(r1, s1_2_2, 0xFA0800E7, 0xF5ECFF22, 0x0106FD21, 0x0CD9FCEC);
	r2 = D(r2, s1_2_2, 0x07B8FF50, 0x06FE05ED, 0x000FF50D, 0xF6050B3B);
	r3 = D(r3, s1_2_2, 0x04FCFEEB, 0x17E5FE15, 0xFF0BFE9C, 0x28EC02E5);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.054e-02, -2.496e-02, -2.269e-02, -7.062e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-3.614e-02, -2.545e-02, -8.451e-03, -1.708e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(1.415e-02, 5.123e-03, -2.754e-02, -1.667e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(1.709e-03, -2.167e-02, 1.306e-02, -1.436e-02);
	f3 = clamp(f3, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-conv3
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv2
//!BIND LUMA
//!SAVE conv3
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 2);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv2_pt;
			r = conv2_gather(p, 0);
			g = conv2_gather(p, 1);
			b = conv2_gather(p, 2);
			a = conv2_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xEF0A0F18, 0xFEF9F603, 0x00F60001, 0x0E1DFB21);
	r1 = D(r1, s0_0_0, 0x03020F08, 0x02F50904, 0xF9EE0301, 0xF9070100);
	r2 = D(r2, s0_0_0, 0x0CFC0B0B, 0x0B180814, 0xFBF905F9, 0x02F70818);
	r3 = D(r3, s0_0_0, 0x04050511, 0x0507F50D, 0xF8FB08FD, 0x020B020F);
	r0 = D(r0, s0_0_1, 0xD2180A0B, 0xF1100210, 0xFBDC0AED, 0x04E30231);
	r1 = D(r1, s0_0_1, 0xF605080E, 0xF20B0D11, 0xFEF5FDED, 0xEB24010D);
	r2 = D(r2, s0_0_1, 0x03110CFE, 0x05200C12, 0x02EDFD11, 0xFF0AFCFC);
	r3 = D(r3, s0_0_1, 0x0FEE010D, 0xF5F21CEA, 0xFC000FF6, 0xE1F80506);
	r0 = D(r0, s0_0_2, 0xF225FEF2, 0x060400FD, 0x08F9FE02, 0xFA061812);
	r1 = D(r1, s0_0_2, 0xFC1901FC, 0xF716FCFE, 0x00000305, 0x0B0FFE04);
	r2 = D(r2, s0_0_2, 0x08FFFF08, 0x07FDFEF6, 0x02000108, 0xFF06FA0C);
	r3 = D(r3, s0_0_2, 0x05FF0900, 0xEEF0042E, 0x0101FEFA, 0xF01DF30F);
	r0 = D(r0, s0_1_0, 0xEF0D0F0E, 0xF602FB12, 0x0D00FA36, 0x0516121B);
	r1 = D(r1, s0_1_0, 0xF70B0F00, 0x0A0610FB, 0xFAFFF71B, 0xD3160BE6);
	r2 = D(r2, s0_1_0, 0x0CEB043F, 0xDAF21BFB, 0x02F60103, 0x03FC01EB);
	r3 = D(r3, s0_1_0, 0xF10B0ACA, 0x07D8E7D8, 0xF5EE0EDF, 0xE70D07E0);
	r0 = D(r0, s0_1_1, 0xF4DA0801, 0xE816E0EE, 0x0804FDDE, 0xF0201110);
	r1 = D(r1, s0_1_1, 0x14D91F29, 0x09E40216, 0xF2F11119, 0xFBC81119);
	r2 = D(r2, s0_1_1, 0x23F6111C, 0x222829F3, 0xF2FFFE0D, 0x06F90407);
	r3 = D(r3, s0_1_1, 0xE9020E03, 0xDC151726, 0x81DE0EDB, 0x04F701F3);
	r0 = D(r0, s0_1_2, 0xD512F7F5, 0x0302E811, 0x04F5FF14, 0x040F1305);
	r1 = D(r1, s0_1_2, 0xEDFE25E0, 0x00D613EF, 0x03FB03FD, 0xFD0B0AF7);
	r2 = D(r2, s0_1_2, 0xF8ED0C17, 0xFDFF070D, 0x0C01FE00, 0xF9080018);
	r3 = D(r3, s0_1_2, 0x14060DFB, 0xF3EB0120, 0xF4FB0409, 0x110E1A0E);
	r0 = D(r0, s0_2_0, 0xFFEE0A14, 0x16F6FE12, 0x1209FAF7, 0xF8FF19FE);
	r1 = D(r1, s0_2_0, 0xFE04081E, 0xF1F803F9, 0xEFF7FCEA, 0xF4FE0615);
	r2 = D(r2, s0_2_0, 0x0AF90600, 0xDFFE0701, 0x0001FCF6, 0x0004011E);
	r3 = D(r3, s0_2_0, 0xEBFC0B06, 0xEEFDF4B7, 0x01000103, 0xF20C0312);
	r0 = D(r0, s0_2_1, 0xEF0A1824, 0x02090012, 0x05FEFFFF, 0x1CE41107);
	r1 = D(r1, s0_2_1, 0x301F1538, 0x04ED1431, 0xED00FDFF, 0xE10311FC);
	r2 = D(r2, s0_2_1, 0x180605E8, 0xECF30E04, 0xF6FCFDF6, 0x05F708F0);
	r3 = D(r3, s0_2_1, 0xEA090503, 0xB6E50A37, 0xFEFE0808, 0x11090418);
	r0 = D(r0, s0_2_2, 0x000C02EE, 0xFA0AF8F9, 0x09040607, 0xECF80AFB);
	r1 = D(r1, s0_2_2, 0x1124FDF5, 0x0DF517ED, 0x04020002, 0x01FB05F6);
	r2 = D(r2, s0_2_2, 0x07F50405, 0xEA13F700, 0x05FDFD00, 0xFF010001);
	r3 = D(r3, s0_2_2, 0x020201F5, 0xF005F2F8, 0xF0010904, 0x0A0202E4);
	r0 = D(r0, s1_0_0, 0x0DFCFC06, 0xEA0807F5, 0xFCFF02FD, 0xEEF1080D);
	r1 = D(r1, s1_0_0, 0x06F507FF, 0x06F00109, 0xF9FBFF01, 0x05FD0307);
	r2 = D(r2, s1_0_0, 0x02FBFBF7, 0x0AF8F60D, 0x01FFFF00, 0xFFFF02FF);
	r3 = D(r3, s1_0_0, 0x09FE02FF, 0x0502060A, 0x09FB0401, 0xE80102FA);
	r0 = D(r0, s1_0_1, 0x0FF1FEF3, 0xF7FB020E, 0xFFF5F913, 0xE5CFEDDD);
	r1 = D(r1, s1_0_1, 0x06030803, 0x030102FB, 0xF102FB07, 0x13F8FFF6);
	r2 = D(r2, s1_0_1, 0x1505FCF7, 0x0E01FFE5, 0xF50404FE, 0x02F3030B);
	r3 = D(r3, s1_0_1, 0xF8E6F4DF, 0xD1F0E9E3, 0x08FB05FA, 0x00F9FE15);
	r0 = D(r0, s1_0_2, 0x06FD1712, 0xF70015F6, 0xF0EF0DFE, 0xF7EEECEF);
	r1 = D(r1, s1_0_2, 0x0AF9100C, 0x17FF1209, 0x03F9FC0A, 0x0701F6FD);
	r2 = D(r2, s1_0_2, 0x091002FB, 0x1310FE04, 0x02FDFFFA, 0x06030302);
	r3 = D(r3, s1_0_2, 0xFFECFBF3, 0x0B20FFFD, 0x08F50C03, 0x0E05EDF5);
	r0 = D(r0, s1_1_0, 0x2C03F4FE, 0xEF0104FC, 0xE7FDFEFF, 0x0BF7F6F9);
	r1 = D(r1, s1_1_0, 0x09FEFF07, 0x0EFEF808, 0xF4F60304, 0xF005F90A);
	r2 = D(r2, s1_1_0, 0x080BFCFE, 0xEC08F712, 0xFE00FBFE, 0xE5F7000E);
	r3 = D(r3, s1_1_0, 0x0904F508, 0x1FF31EEA, 0xEFFEFC05, 0x070104FC);
	r0 = D(r0, s1_1_1, 0x0C001681, 0xB629EA4D, 0xCAED0449, 0x1EF5CEDD);
	r1 = D(r1, s1_1_1, 0xE8F217F8, 0x17D916B2, 0xF2F802FF, 0xEDF2F0C4);
	r2 = D(r2, s1_1_1, 0x08F6DDF9, 0xFEEEE0C5, 0x0BF80407, 0x02A300CF);
	r3 = D(r3, s1_1_1, 0x1705F8C9, 0xBA3EA8C6, 0xF717D4E6, 0xE30CF0FF);
	r0 = D(r0, s1_1_2, 0x14FD2A14, 0xE9EA0811, 0xFEF71303, 0x1A32D7D2);
	r1 = D(r1, s1_1_2, 0xDE10C401, 0xEB23EDE7, 0xF90904F1, 0xFBEE04FF);
	r2 = D(r2, s1_1_2, 0x121217F7, 0x03112C02, 0xF42B03FB, 0x06ED0EF7);
	r3 = D(r3, s1_1_2, 0x03F607F2, 0x27110C10, 0x0D052601, 0xE40DD6D6);
	r0 = D(r0, s1_2_0, 0x00FF0218, 0xFF01FE0A, 0x0D020A07, 0xE5FE050A);
	r1 = D(r1, s1_2_0, 0x17030307, 0xFAFA0B03, 0xF8FD06FC, 0xEC05F501);
	r2 = D(r2, s1_2_0, 0x08FEF50F, 0xE501080D, 0xFFFD03F9, 0x01FBFF01);
	r3 = D(r3, s1_2_0, 0xF6010903, 0x1202F8EF, 0xFF02F903, 0xFD04FAFC);
	r0 = D(r0, s1_2_1, 0x12F9150E, 0xF80A00E8, 0x14FD06FF, 0xE8EB0E20);
	r1 = D(r1, s1_2_1, 0x3FE617FB, 0xEFF1FF26, 0xEA03F812, 0xE4FDFB0D);
	r2 = D(r2, s1_2_1, 0x19F5DEDB, 0xE2D62834, 0x0004FF03, 0xF6FFF60B);
	r3 = D(r3, s1_2_1, 0xFCF5FF12, 0xD11C0EF8, 0xE90804FA, 0x0001F2F4);
	r0 = D(r0, s1_2_2, 0x1DEC1B04, 0x0015FDF5, 0xF000FF05, 0x130AEA0B);
	r1 = D(r1, s1_2_2, 0x1BDAFAE3, 0x0FECEFF5, 0xEAF6F504, 0xFF080DFC);
	r2 = D(r2, s1_2_2, 0xFFFD05FB, 0xF8E90D1B, 0xFBFF00FF, 0xFF030F03);
	r3 = D(r3, s1_2_2, 0x03F9F009, 0xE504E9F2, 0xF2030AFE, 0xFBFFF9EB);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFD000002, 0xEE0B10FA, 0xFA0DFAFB, 0xF901EFFB);
	r1 = D(r1, s0_0_0, 0x0AF5F400, 0x0AFAEA16, 0x18F2F7F4, 0xFC0702F6);
	r2 = D(r2, s0_0_0, 0x0BF20904, 0x170B05F5, 0x06FD0104, 0xF900EF0C);
	r3 = D(r3, s0_0_0, 0x0804E9F5, 0x14E3E1D5, 0x0405FFFE, 0xFD02FDF9);
	r0 = D(r0, s0_0_1, 0xFBFF0610, 0xEAEE03F8, 0x0311E613, 0x19F7ECE2);
	r1 = D(r1, s0_0_1, 0x100003FE, 0x0CF60E09, 0x0BFDF2F6, 0x02FB20F2);
	r2 = D(r2, s0_0_1, 0x0EF71A03, 0x21FD22E4, 0x0E00FBEF, 0xFD090103);
	r3 = D(r3, s0_0_1, 0x0031EF06, 0xEA090107, 0x0B050405, 0x0518F7EF);
	r0 = D(r0, s0_0_2, 0x0800E3EB, 0xFC0401F4, 0x01FDFDF9, 0x0D0CEC00);
	r1 = D(r1, s0_0_2, 0x0106FFEB, 0xFB0CF402, 0x00FFF60D, 0x0CF909F9);
	r2 = D(r2, s0_0_2, 0x0D0011EF, 0xF9FCF80B, 0xFC030407, 0x030CFAFA);
	r3 = D(r3, s0_0_2, 0x0019F006, 0x240F04B7, 0x05EFF7F8, 0x0F0B12DA);
	r0 = D(r0, s0_1_0, 0x0DF1E714, 0xFF090DF7, 0x08FBEFF4, 0x0202E40F);
	r1 = D(r1, s0_1_0, 0x10F0FBFC, 0x0E0CE015, 0xFF011204, 0x080B04EF);
	r2 = D(r2, s0_1_0, 0xF8F2F30C, 0xFC1C0402, 0xFEF80507, 0x04F22507);
	r3 = D(r3, s0_1_0, 0x0810F402, 0x27E0FFC5, 0x0A02FFEB, 0xFD090DE6);
	r0 = D(r0, s0_1_1, 0x2B21BCEC, 0x1807FF0E, 0xFF1F040B, 0x0314D7E4);
	r1 = D(r1, s0_1_1, 0x3ED90EA8, 0x1003E3DB, 0xF0EB7FEE, 0x14CF20D6);
	r2 = D(r2, s0_1_1, 0x1731BE00, 0xE6FBB409, 0x0422E6F8, 0x10DBC716);
	r3 = D(r3, s0_1_1, 0xFDCE0DF7, 0xFFF6D508, 0x29EAFE08, 0x12FD42DF);
	r0 = D(r0, s0_1_2, 0x0430E711, 0x09F505F4, 0x0302F7FB, 0x21F8F3ED);
	r1 = D(r1, s0_1_2, 0x2509C22C, 0x0A02F021, 0xFCFEFF06, 0xFDE3EB04);
	r2 = D(r2, s0_1_2, 0x0B070206, 0x041617FC, 0xFEF20CFB, 0xFF09FFF9);
	r3 = D(r3, s0_1_2, 0xFC020BFC, 0x0CFC04E3, 0x0AF20204, 0xF00AD0F0);
	r0 = D(r0, s0_2_0, 0x03F60F00, 0xFC020B01, 0x0401FBFF, 0x141003EA);
	r1 = D(r1, s0_2_0, 0x0105FF00, 0x100004F4, 0xFA0103FD, 0x04FE05F6);
	r2 = D(r2, s0_2_0, 0x09F30006, 0x170704D5, 0x00FE08FF, 0x03F609F3);
	r3 = D(r3, s0_2_0, 0x0505FAF6, 0x0B06FBFA, 0xFFFE0207, 0xFD02F5FE);
	r0 = D(r0, s0_2_1, 0x031DF106, 0xF6FB0104, 0x09FA04F6, 0x181311E4);
	r1 = D(r1, s0_2_1, 0xF33CFBE9, 0x08090504, 0xFF0EF6FE, 0x00F1F6FA);
	r2 = D(r2, s0_2_1, 0x0206F707, 0x1222F010, 0x05090101, 0x07F10005);
	r3 = D(r3, s0_2_1, 0x050D05FA, 0x02032AE6, 0xFDF6F608, 0xFDEF14DD);
	r0 = D(r0, s0_2_2, 0xF1040F14, 0xFCFA01FD, 0xFDFBFA04, 0x070D0508);
	r1 = D(r1, s0_2_2, 0xF11D0EF3, 0x02F6030C, 0xFD07FFFD, 0x000903F6);
	r2 = D(r2, s0_2_2, 0x030C0800, 0xF712EF0A, 0x020DFF02, 0x0508FEFF);
	r3 = D(r3, s0_2_2, 0xF70DF90E, 0x05EEF4F0, 0xFDF907FB, 0x0607FBDA);
	r0 = D(r0, s1_0_0, 0xF609FBFA, 0xF9FF1006, 0x1CFC05F8, 0x02061EEE);
	r1 = D(r1, s1_0_0, 0x0CFDFD01, 0xF6FE0001, 0xF2FA0607, 0xFCF2FB09);
	r2 = D(r2, s1_0_0, 0xFDF20802, 0x0105F8FF, 0xF8020000, 0xE9030F04);
	r3 = D(r3, s1_0_0, 0x0E01FF04, 0xDD0D16E7, 0xECF70309, 0xF8F5100B);
	r0 = D(r0, s1_0_1, 0xF4D6F11C, 0xFBFEEBE9, 0x1D0DF9ED, 0xF6EB1C1B);
	r1 = D(r1, s1_0_1, 0xE8FA0015, 0xF6ED0F20, 0xF0011217, 0xFE03F3DE);
	r2 = D(r2, s1_0_1, 0x0D06EDF6, 0x1001FEF3, 0xE1F6101D, 0x17FFF50C);
	r3 = D(r3, s1_0_1, 0x20F30E2A, 0x28F6F029, 0x1CFFECEF, 0x150501F6);
	r0 = D(r0, s1_0_2, 0x04E90FF4, 0xF8FB1201, 0x08FB0F0D, 0x21DD1510);
	r1 = D(r1, s1_0_2, 0x0FF6F70A, 0x0EEBF4EE, 0x07FEFB0A, 0x0906F6F1);
	r2 = D(r2, s1_0_2, 0x0402FFEF, 0x060EF3F8, 0xFDFDFE0B, 0x00FC02FD);
	r3 = D(r3, s1_0_2, 0x11F606FD, 0xF6FDFBD7, 0x02F90BEE, 0x0301E7F3);
	r0 = D(r0, s1_1_0, 0xF915F2EE, 0x0B0B0905, 0x03F80902, 0xF104F50A);
	r1 = D(r1, s1_1_0, 0x0E0202FA, 0xF1F702FE, 0xED1B0600, 0x0C0EF9EB);
	r2 = D(r2, s1_1_0, 0xFCF606E8, 0xEC0DFAF9, 0xFDFFFFFF, 0xFFE706E5);
	r3 = D(r3, s1_1_0, 0xFEFF040C, 0xF1E53019, 0x06FF0E00, 0x05EFF708);
	r0 = D(r0, s1_1_1, 0xF1BF1457, 0x110814DA, 0x00FC02E0, 0xFA24CD07);
	r1 = D(r1, s1_1_1, 0xDCD22100, 0x03050608, 0xF4E5131D, 0x01151809);
	r2 = D(r2, s1_1_1, 0xFA1D0CCA, 0xDD0D0D0F, 0xF31BFE4F, 0x05FBFC54);
	r3 = D(r3, s1_1_1, 0xF128D804, 0x281AD3FF, 0x031B1D01, 0x0D070FD9);
	r0 = D(r0, s1_1_2, 0x04EEFADC, 0x020607DE, 0x08FE0814, 0x1502FDEA);
	r1 = D(r1, s1_1_2, 0x0BE90AEC, 0x12F7000B, 0xFC05030A, 0x0505FC06);
	r2 = D(r2, s1_1_2, 0x0203FFFF, 0xF7FDF907, 0xFA040908, 0x03FCFFFA);
	r3 = D(r3, s1_1_2, 0x08FE020B, 0x06E924FD, 0x0CF503EC, 0x0B0C0707);
	r0 = D(r0, s1_2_0, 0x0BFB0804, 0x0F0302F5, 0x00000AFE, 0x08FC0A01);
	r1 = D(r1, s1_2_0, 0x020A02FB, 0x03FA0A08, 0xF9000106, 0x010CF9FE);
	r2 = D(r2, s1_2_0, 0x02FA0501, 0xFAF00309, 0xFAFDFD0B, 0x05FAFB03);
	r3 = D(r3, s1_2_0, 0x07F904FF, 0xFB030310, 0x00020605, 0x040DF5F3);
	r0 = D(r0, s1_2_1, 0x00F1F30B, 0x0901F10F, 0x050205F2, 0x11ED1200);
	r1 = D(r1, s1_2_1, 0x0FDDEF0C, 0xFFFE0FFB, 0x02050BF7, 0xFBFAFD1A);
	r2 = D(r2, s1_2_1, 0xF5F2F70D, 0xF8DE2005, 0xFA010C01, 0x00FAFE0A);
	r3 = D(r3, s1_2_1, 0x030807EA, 0x0DED04F2, 0x03030206, 0x0009FE01);
	r0 = D(r0, s1_2_2, 0xFDFDECFA, 0x04060501, 0x06FC0210, 0x05EF06F4);
	r1 = D(r1, s1_2_2, 0x07F5F0DE, 0x01F90016, 0x00FC02F4, 0x01FC04F8);
	r2 = D(r2, s1_2_2, 0x03F7060D, 0xF4F6F3F8, 0xFFFF0500, 0x03FBFD02);
	r3 = D(r3, s1_2_2, 0xFFF1FE05, 0x02F9F817, 0x02FDFC09, 0x00EFF901);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(2.352e-03, 4.143e-03, 1.224e-02, -1.088e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(9.783e-03, -1.041e-02, -2.976e-03, -1.594e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-2.975e-03, -1.205e-02, -2.532e-03, -5.185e-04);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-1.015e-02, -3.273e-02, 8.897e-04, -1.652e-02);
	f3 = clamp(f3, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-conv4
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv3
//!BIND LUMA
//!SAVE conv4
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 2);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv3_pt;
			r = conv3_gather(p, 0);
			g = conv3_gather(p, 1);
			b = conv3_gather(p, 2);
			a = conv3_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFA0FF8FB, 0x1D0301DF, 0xFD00FFFF, 0x1205FDEE);
	r1 = D(r1, s0_0_0, 0x0DF5F207, 0x010301F9, 0x06F703FC, 0xF1F6EEFE);
	r2 = D(r2, s0_0_0, 0x0105FD02, 0x05020101, 0x020001FF, 0x0404EF0A);
	r3 = D(r3, s0_0_0, 0x0203FF0A, 0x070000FF, 0x08000200, 0x08FD02FA);
	r0 = D(r0, s0_0_1, 0xF9FEF3FB, 0xFFFD09FA, 0x02FB06F8, 0xF0CF03FE);
	r1 = D(r1, s0_0_1, 0xE2D8F801, 0xFFF70702, 0x05FA19F2, 0x0EFDFF0E);
	r2 = D(r2, s0_0_1, 0xF2FCF907, 0xF505FFFD, 0x000003FD, 0xF108F5F9);
	r3 = D(r3, s0_0_1, 0x01FA0C05, 0xEE03FD07, 0xFD0408F3, 0x02020DEE);
	r0 = D(r0, s0_0_2, 0x020004F9, 0xFFFE0004, 0x0203F610, 0x0803F50D);
	r1 = D(r1, s0_0_2, 0xF9FCFB03, 0x02FDFFFE, 0x06FD00FF, 0xF604FDF0);
	r2 = D(r2, s0_0_2, 0xFC02F6FE, 0x0004FFFE, 0x00FF0201, 0xFA00F9FF);
	r3 = D(r3, s0_0_2, 0xFCFEFB03, 0xFC03FAFA, 0x05FF0004, 0xFFFEFA05);
	r0 = D(r0, s0_1_0, 0x15C6F1F7, 0xAEA6BFBD, 0x0DFB05FA, 0xF7FEFC05);
	r1 = D(r1, s0_1_0, 0xF3F00304, 0xEA08F60D, 0xFDFCFBF8, 0xFCF30AFE);
	r2 = D(r2, s0_1_0, 0x09FFFDFD, 0x11F902FE, 0x01F904FF, 0x0EE606F6);
	r3 = D(r3, s0_1_0, 0x0CECFF03, 0x14FAFBF3, 0x18F901FF, 0x19F302E8);
	r0 = D(r0, s0_1_1, 0x09D81500, 0xF5E6FCF1, 0xEC0DF404, 0xC4B5F8C7);
	r1 = D(r1, s0_1_1, 0xF3EE0705, 0xFFDB08DF, 0xE7F2E9FB, 0xFDFAFAFF);
	r2 = D(r2, s0_1_1, 0xF0A217DE, 0x1AF0FBF4, 0x11F5E803, 0xF6E80502);
	r3 = D(r3, s0_1_1, 0xD0CAFC31, 0x0CB817E0, 0xE2F6F0EF, 0xB2C7FDF2);
	r0 = D(r0, s0_1_2, 0x0C05F2FD, 0x0701F702, 0xFDF6F209, 0x1BFCE61B);
	r1 = D(r1, s0_1_2, 0x00FC09F9, 0x07FAFCF2, 0xFFF805FA, 0x01F3040D);
	r2 = D(r2, s0_1_2, 0x0A07EE05, 0x0EF30DDA, 0xFF05F402, 0x05FD0001);
	r3 = D(r3, s0_1_2, 0xFC02090C, 0x0902F500, 0xD4F211D6, 0xFF0201FA);
	r0 = D(r0, s0_2_0, 0xAA818181, 0x81818181, 0x030000FE, 0x050400F8);
	r1 = D(r1, s0_2_0, 0x0305FEFF, 0x0803FFFE, 0x0005FD00, 0xFC0B08F4);
	r2 = D(r2, s0_2_0, 0xF10203FA, 0x04010101, 0xF906FCFD, 0xFFFC0004);
	r3 = D(r3, s0_2_0, 0x0AEB05FF, 0x09F709FF, 0x0001FF02, 0x07F90003);
	r0 = D(r0, s0_2_1, 0xA4D303EB, 0xFACECEF5, 0xFB05FAF8, 0xFEF8FFF9);
	r1 = D(r1, s0_2_1, 0x0606F900, 0xFDF8F9F0, 0x04FDFE06, 0xFAF404FC);
	r2 = D(r2, s0_2_1, 0xF4FEF8F8, 0xE604FCF2, 0xD213FCFC, 0xFDFC020A);
	r3 = D(r3, s0_2_1, 0x0AF6FE06, 0xD40DF2F8, 0x00F902F5, 0x01FA03F3);
	r0 = D(r0, s0_2_2, 0x13000007, 0x00FF0502, 0x00F70401, 0x0B0BFC0D);
	r1 = D(r1, s0_2_2, 0xFDFFFFFF, 0x00FF00FC, 0xFCFF03FD, 0x07FEEBFD);
	r2 = D(r2, s0_2_2, 0x0101FCFE, 0xF9FD05F3, 0xFE01FEF9, 0xFC000002);
	r3 = D(r3, s0_2_2, 0x04F90305, 0x02FC02FB, 0x09FD06F6, 0x01FA04FB);
	r0 = D(r0, s1_0_0, 0x0C0B06DD, 0x0A0F16FE, 0xFEFDFFFD, 0xFDFBE4DA);
	r1 = D(r1, s1_0_0, 0x1401EFFF, 0xFF05FDF2, 0x04FFFCEC, 0xF8F50905);
	r2 = D(r2, s1_0_0, 0x01FEF5FB, 0x04FF09FA, 0xFFFFFC01, 0xFDF906EE);
	r3 = D(r3, s1_0_0, 0x07F901F8, 0x03FE06F6, 0x00FD0AF5, 0x01FC07E3);
	r0 = D(r0, s1_0_1, 0xFDECF704, 0xF70001FF, 0xF40304F5, 0x07161EE4);
	r1 = D(r1, s1_0_1, 0x2C01F606, 0xF71604F7, 0xEE1DFAEA, 0x04F2F202);
	r2 = D(r2, s1_0_1, 0x0BF6FDFC, 0xFFFB05D3, 0xF7FCFC01, 0x0DEEE405);
	r3 = D(r3, s1_0_1, 0xFD0903DA, 0x09F909DE, 0xFFFFE6C0, 0xFF0C0CBE);
	r0 = D(r0, s1_0_2, 0x0606FCFD, 0x0203FE01, 0x0B05EE04, 0xEB01F501);
	r1 = D(r1, s1_0_2, 0x0F080309, 0x0306F906, 0x060106FE, 0x0602FDFE);
	r2 = D(r2, s1_0_2, 0xFD000101, 0x06FAF301, 0xFFFF0000, 0x06FFFB02);
	r3 = D(r3, s1_0_2, 0x00FDF502, 0xFFFEFB04, 0x06FF04F9, 0x0102F805);
	r0 = D(r0, s1_1_0, 0xE4D88106, 0x5BBCCB07, 0x06F90BFF, 0xDAFDFCF3);
	r1 = D(r1, s1_1_0, 0xF404F7FF, 0xEF0CF104, 0x0A010808, 0x07F7FD08);
	r2 = D(r2, s1_1_0, 0x07FDF5E1, 0xFD0001FF, 0x06FD04E6, 0x2AEDF101);
	r3 = D(r3, s1_1_0, 0x13F2FE0A, 0x0AF916DB, 0x0003FD00, 0x06F822FD);
	r0 = D(r0, s1_1_1, 0x180216FF, 0x1208F505, 0xDA0DE0E7, 0x410A060E);
	r1 = D(r1, s1_1_1, 0xEAF70EFC, 0x4A1A0304, 0x1DF21704, 0x040303F9);
	r2 = D(r2, s1_1_1, 0x2D0F0DFF, 0x0EF1D2B7, 0x1EEE11EC, 0x27F5F1F2);
	r3 = D(r3, s1_1_1, 0x1215D7FA, 0x1901D4C8, 0x18E612EB, 0x2CFBDDFA);
	r0 = D(r0, s1_1_2, 0x0102F602, 0x03FC0203, 0x1BFF0108, 0xE0F3F1FE);
	r1 = D(r1, s1_1_2, 0x06010DFA, 0xF801FB08, 0x16FE00FF, 0xFCFCF8FC);
	r2 = D(r2, s1_1_2, 0xF9F8F907, 0x1E0426F5, 0xFEF9FBFF, 0x080C0008);
	r3 = D(r3, s1_1_2, 0xFB0FFF05, 0x0DFC0606, 0x1C0B0CFF, 0x04040D03);
	r0 = D(r0, s1_2_0, 0x81818181, 0x81818181, 0xFEFE04FF, 0xF7030404);
	r1 = D(r1, s1_2_0, 0xFFFC0804, 0x0001F900, 0xEE000203, 0xFDECF209);
	r2 = D(r2, s1_2_0, 0x02FE1103, 0x00FEF8FC, 0x08FBFBFE, 0x07F9F8FB);
	r3 = D(r3, s1_2_0, 0x0BF6EBFD, 0xFBFDFBFE, 0xFE00FBFE, 0x00FFF5FD);
	r0 = D(r0, s1_2_1, 0x27F1F706, 0x2DC0ED0D, 0x0B0002FF, 0x05030F01);
	r1 = D(r1, s1_2_1, 0xF9020301, 0xF5000502, 0xED01F7FF, 0x03F2FDF0);
	r2 = D(r2, s1_2_1, 0x04040A03, 0xF7FD1303, 0x1806F6FD, 0x0A04FEFD);
	r3 = D(r3, s1_2_1, 0xFCF9F7FC, 0x0200100A, 0xFCFD06FF, 0xF6000D04);
	r0 = D(r0, s1_2_2, 0x0E03FA03, 0x15091103, 0xF4000F00, 0x00FDFE01);
	r1 = D(r1, s1_2_2, 0xF9FF0302, 0xFDFF0201, 0xFA01FC00, 0x05FD09F8);
	r2 = D(r2, s1_2_2, 0xFE01FE02, 0xFE000204, 0xFD0503FF, 0x0103FD03);
	r3 = D(r3, s1_2_2, 0xFEFEFFFF, 0xFE0206FF, 0x01FC0B02, 0x02FD0701);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFB140EFD, 0xFFD318ED, 0x02FD0205, 0x07F40304);
	r1 = D(r1, s0_0_0, 0x09DEF607, 0xFB0204FA, 0x07F1FD06, 0x00ED06F9);
	r2 = D(r2, s0_0_0, 0x0305FC02, 0xFF01FD00, 0x02FFFF02, 0xFDFFFD05);
	r3 = D(r3, s0_0_0, 0x0105F209, 0x0105FE04, 0x00FEFF00, 0x01000007);
	r0 = D(r0, s0_0_1, 0xEF0B01FC, 0x0001FF05, 0x04FE01E8, 0x1903FFE2);
	r1 = D(r1, s0_0_1, 0x0CDCE0CE, 0xF7FD11FA, 0x06E607EA, 0x0BE901F4);
	r2 = D(r2, s0_0_1, 0x060EF2FF, 0x020800FD, 0xFDFD04FC, 0xF421F4EE);
	r3 = D(r3, s0_0_1, 0x010A03F9, 0x0809F501, 0x060903FD, 0x070B02EB);
	r0 = D(r0, s0_0_2, 0x18000703, 0x04030300, 0x0A00F700, 0x06FC0DF9);
	r1 = D(r1, s0_0_2, 0xF1FC0AEE, 0xFF0002FE, 0x00F9F204, 0x06FB00F6);
	r2 = D(r2, s0_0_2, 0x07FD02F9, 0x0207F806, 0x01030200, 0xFD0405F9);
	r3 = D(r3, s0_0_2, 0xFF02FE04, 0x020500FC, 0x0702FD04, 0x06FC0108);
	r0 = D(r0, s0_1_0, 0x259A1DFE, 0x1AE4C418, 0x0402FE01, 0x12E50603);
	r1 = D(r1, s0_1_0, 0x000308F9, 0x00E802FE, 0x02010501, 0xFEFA09F5);
	r2 = D(r2, s0_1_0, 0x03F5FC07, 0x01FEFFFA, 0x020FFF00, 0xF731F910);
	r3 = D(r3, s0_1_0, 0x040EE508, 0x03FBFF0C, 0xFF03FEF8, 0x020AFF08);
	r0 = D(r0, s0_1_1, 0x1A0DEBAA, 0x0127F4E4, 0x13EB07F2, 0x0EFEFACB);
	r1 = D(r1, s0_1_1, 0x05070D07, 0xDB0CECDE, 0x0903051D, 0x04E8F403);
	r2 = D(r2, s0_1_1, 0x1015F5DB, 0x05180C0A, 0x0F29F4EE, 0x1A03FDE5);
	r3 = D(r3, s0_1_1, 0x10E0FEE5, 0xF9150EB4, 0x04140E1A, 0x0CEAF0DE);
	r0 = D(r0, s0_1_2, 0x0EFFF20E, 0xF40101FD, 0x3607F6EC, 0x1B00FEF3);
	r1 = D(r1, s0_1_2, 0x0F020B13, 0x12FFF6FF, 0xF5FC0A09, 0xF6F904F1);
	r2 = D(r2, s0_1_2, 0x2B0FF1F4, 0x3CEEFED4, 0xFD0302F9, 0xF40404F0);
	r3 = D(r3, s0_1_2, 0x12FDF6EF, 0x31FFF1F9, 0x40E8DCDA, 0x1C00F5EF);
	r0 = D(r0, s0_2_0, 0x81818181, 0x81818181, 0x02FF0402, 0x0AFF0603);
	r1 = D(r1, s0_2_0, 0x00FFFDFE, 0x03FFFC03, 0x03FD02FD, 0xFFF8F8F1);
	r2 = D(r2, s0_2_0, 0x03FBFC02, 0xFE010003, 0xFAFD0403, 0xF70102FD);
	r3 = D(r3, s0_2_0, 0xFD0DF10B, 0xFE09FF01, 0xFEFC0203, 0xFF000104);
	r0 = D(r0, s0_2_1, 0x2CEFBF0B, 0x3D07BEDB, 0x08F900FD, 0x02FE06EF);
	r1 = D(r1, s0_2_1, 0xFDFC0200, 0x07FFF90A, 0xFD0101F0, 0x0808F8F2);
	r2 = D(r2, s0_2_1, 0x07EDF600, 0x01FE0707, 0xECEAFEFB, 0xEEF2F9F7);
	r3 = D(r3, s0_2_1, 0x07FBE80D, 0x07E7FC10, 0xFF050606, 0x01FC0904);
	r0 = D(r0, s0_2_2, 0x0E010E0C, 0x0E0105FE, 0x0CFFFDF7, 0x0AFDFBFC);
	r1 = D(r1, s0_2_2, 0xF5FB01F8, 0x0600FC08, 0xFE0005FB, 0x0BFDE8E5);
	r2 = D(r2, s0_2_2, 0x1404F7FC, 0xF9F606FC, 0x0AFDFAFA, 0xFC020201);
	r3 = D(r3, s0_2_2, 0x0403F809, 0xFDFF01F8, 0xFBFC06FD, 0x05030401);
	r0 = D(r0, s1_0_0, 0x160C05D6, 0xEAF91101, 0x09FE00FE, 0xF10AFE04);
	r1 = D(r1, s1_0_0, 0x0C21F401, 0xFEFAFD02, 0xF406FCFE, 0x04F7F905);
	r2 = D(r2, s1_0_0, 0xFC09FE04, 0xFD0000FE, 0xFAFC02FE, 0x080705FF);
	r3 = D(r3, s1_0_0, 0x04050003, 0xFC04FEFF, 0x01FF02FD, 0x0304FFFF);
	r0 = D(r0, s1_0_1, 0xFB0F070D, 0xF4FF0C00, 0x07070104, 0x1F1C10F2);
	r1 = D(r1, s1_0_1, 0x1426D630, 0xFAF70CFE, 0x0EFCF80C, 0x00F8F9F5);
	r2 = D(r2, s1_0_1, 0x000C08FB, 0x0D06F8FC, 0xFEFD0004, 0x091C14F1);
	r3 = D(r3, s1_0_1, 0xEC0C0CF9, 0xFE08FFFE, 0xEE0CF400, 0xE50915FD);
	r0 = D(r0, s1_0_2, 0xF6FFF8FE, 0xFBFBFA02, 0xFB0504F5, 0xF8FE1BFB);
	r1 = D(r1, s1_0_2, 0xFB0DF309, 0xFC010C04, 0x0703EFFF, 0xFBEE00F4);
	r2 = D(r2, s1_0_2, 0xFE05FE01, 0x00030B01, 0x04020000, 0xFE04F908);
	r3 = D(r3, s1_0_2, 0xFF06E606, 0x0005FE02, 0xF9FF0BFB, 0xFA00E900);
	r0 = D(r0, s1_1_0, 0x091F0BE3, 0x0F44F22B, 0x02F8FBFC, 0x07FE18F9);
	r1 = D(r1, s1_1_0, 0xC1E3F504, 0xFF0B0C04, 0x12FAF700, 0x01F307F2);
	r2 = D(r2, s1_1_0, 0xD10CF709, 0xFE0200FE, 0x01F5F6FF, 0xF1E7DA01);
	r3 = D(r3, s1_1_0, 0xEC0CEC03, 0xE004ECFE, 0xF607F9F9, 0xE0FFE4FC);
	r0 = D(r0, s1_1_1, 0x16F2033F, 0x0B1FF723, 0x0E261B07, 0xC51ADE26);
	r1 = D(r1, s1_1_1, 0xE1EC1718, 0x0D26F01A, 0xDE10FF2B, 0xF8F000F5);
	r2 = D(r2, s1_1_1, 0x0C1EE249, 0xDD34190F, 0xF0130BF0, 0xF717F538);
	r3 = D(r3, s1_1_1, 0x2927041E, 0x08383138, 0x1D372717, 0x244F1A27);
	r0 = D(r0, s1_1_2, 0xF800F5F9, 0x05F8F6FE, 0xCE0818FB, 0x120607EB);
	r1 = D(r1, s1_1_2, 0x01F309FC, 0xFE090402, 0xF102FAFF, 0x0FF30204);
	r2 = D(r2, s1_1_2, 0xFE060A0C, 0x07F8E914, 0xFFFDF204, 0xF902FD04);
	r3 = D(r3, s1_1_2, 0x020EFE18, 0xFE03E10F, 0xF910C70B, 0x0108F00C);
	r0 = D(r0, s1_2_0, 0x81011681, 0x81818381, 0x010003FE, 0x07FF1002);
	r1 = D(r1, s1_2_0, 0x17020600, 0x01F80F05, 0xF8050401, 0xF9FCFBFE);
	r2 = D(r2, s1_2_0, 0x0A010105, 0x05FFFC06, 0x02050611, 0x0D0903F8);
	r3 = D(r3, s1_2_0, 0x00FBFB07, 0x05FBFA0A, 0x0AFDFF09, 0x02FDFE04);
	r0 = D(r0, s1_2_1, 0xE01AF420, 0xE0552017, 0x06FC0DFA, 0x030107FC);
	r1 = D(r1, s1_2_1, 0x0A0804FA, 0xF8FB0A09, 0x0F0501F8, 0xEAEBFA07);
	r2 = D(r2, s1_2_1, 0xF501F2FF, 0x12090F01, 0x0E06031A, 0xFB0CFEFF);
	r3 = D(r3, s1_2_1, 0xF50DFF13, 0x060D03F1, 0xFE0A05F6, 0xF80500F4);
	r0 = D(r0, s1_2_2, 0xF3FE0BFE, 0xFA00E001, 0x03FEFFFC, 0x0D06FAF5);
	r1 = D(r1, s1_2_2, 0x030901F9, 0x02FFFEFD, 0x02FE0003, 0x02FAF7F5);
	r2 = D(r2, s1_2_2, 0x0302FC02, 0xF801F6F0, 0x00010110, 0xFA030503);
	r3 = D(r3, s1_2_2, 0xFD030000, 0x01020600, 0xFC02FBEE, 0x0002FFF7);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.954e-02, -1.690e-02, -8.613e-04, -3.830e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(1.358e-04, -8.606e-03, 9.093e-04, -1.423e-01);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-6.364e-03, -9.486e-04, -2.254e-03, -7.648e-03);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-7.155e-03, -4.072e-03, -1.570e-03, -4.813e-03);
	f3 = clamp(f3, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv4
//!BIND LUMA
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 1
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : enable
#ifdef GL_EXT_shader_explicit_arithmetic_types_float16
#	define V4 f16vec4
#	define M4 f16mat4
#	define F float16_t
#else
#	define V4 vec4
#	define M4 mat4
#	define F float
#endif
shared V4 G[4][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 2);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec2 p;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv4_pt;
			V4 sr0 = V4(conv4_gather(p, 0));
			V4 sg0 = V4(conv4_gather(p, 1));
			V4 sb0 = V4(conv4_gather(p, 2));
			V4 sa0 = V4(conv4_gather(p, 3));
			G[0][ay][ax] = V4(sr0.w, sg0.w, sb0.w, sa0.w);
			G[1][ay][ax] = V4(sr0.z, sg0.z, sb0.z, sa0.z);
			G[2][ay][ax] = V4(sr0.x, sg0.x, sb0.x, sa0.x);
			G[3][ay][ax] = V4(sr0.y, sg0.y, sb0.y, sa0.y);
		}
	}
	barrier();
	V4 s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	V4 r0;
	r0 = V4(0.0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 += M4(7.909e-03, -7.175e-03, -6.471e-03, -5.549e-03, -6.126e-03, 1.290e-02, -9.909e-03, 1.298e-02, 3.870e-02, -6.273e-03, 6.957e-05, -1.447e-03, -1.699e-03, -2.883e-03, -1.634e-03, 1.646e-04) * s0_0_0;
	r0 += M4(-4.014e-01, 1.483e-01, -4.096e-02, 8.957e-02, 4.174e-01, -2.437e-01, 2.663e-01, -1.756e-01, 2.732e-03, -2.899e-02, 7.549e-04, -5.048e-04, 9.137e-03, 4.759e-03, -8.929e-03, -2.206e-03) * s0_0_1;
	r0 += M4(4.797e-01, -1.085e+00, 5.254e-01, -5.559e-01, -1.112e-01, 1.615e-02, 2.916e-03, 5.093e-02, -3.519e-04, -1.465e-04, -9.343e-04, -1.190e-03, 4.696e-03, -1.113e-03, -6.485e-04, -1.532e-05) * s0_0_2;
	r0 += M4(7.927e-03, -1.471e-03, 2.610e-02, -9.697e-03, 1.671e-03, 4.874e-04, 2.149e-03, 4.828e-03, 1.665e-01, 4.990e-03, 1.730e-01, -7.930e-04, -1.885e-02, -1.532e-02, -2.818e-02, -1.952e-03) * s0_1_0;
	r0 += M4(1.360e-01, 7.003e-02, -5.249e-01, 5.096e-02, -6.622e-02, 2.023e-03, 1.161e-01, -3.552e-02, -2.978e-03, -1.958e-01, -2.696e-03, -1.873e-01, -2.358e-01, 2.070e-01, -2.129e-02, 4.467e-02) * s0_1_1;
	r0 += M4(6.930e-02, 1.661e-01, 4.804e-02, -3.410e-01, -3.212e-01, -3.183e-01, 2.783e-01, 3.682e-01, 6.240e-04, 5.334e-03, 1.302e-03, 3.351e-03, 9.289e-03, -1.119e-02, 7.667e-03, 4.214e-04) * s0_1_2;
	r0 += M4(-1.195e-03, 4.686e-04, 1.034e-02, 7.143e-04, 3.071e-04, -2.325e-07, -8.392e-04, 4.653e-04, 8.172e-05, 7.224e-04, 3.474e-02, 2.461e-03, -1.236e-02, -5.716e-04, -8.334e-03, -8.874e-03) * s0_2_0;
	r0 += M4(-9.210e-03, -1.031e-03, 6.338e-02, 4.747e-02, 8.626e-03, 4.032e-04, 8.800e-03, -1.765e-03, -4.829e-04, 1.433e-03, -1.354e-04, -2.774e-02, 2.126e-02, -7.492e-03, -7.303e-02, 1.085e-01) * s0_2_1;
	r0 += M4(-5.100e-04, -5.237e-03, -2.788e-02, -4.143e-03, 8.650e-03, 1.635e-02, 5.197e-02, 5.965e-02, -3.229e-04, -1.783e-03, -3.925e-04, 7.024e-04, -8.024e-05, 7.768e-03, 2.709e-03, 2.423e-03) * s0_2_2;
	r0 += M4(-4.093e-05, 8.961e-09, -5.012e-08, -1.030e-05, 2.106e-02, 2.346e-03, 1.547e-03, -2.223e-04, 3.764e-05, 6.824e-04, 3.304e-06, 2.092e-04, -1.019e-01, -1.001e-01, -9.360e-02, -9.615e-02) * s1_0_0;
	r0 += M4(1.590e-04, -2.909e-04, 2.578e-06, 4.738e-05, 5.969e-02, 5.545e-02, 1.067e-02, 3.660e-03, -1.443e-03, -1.929e-03, -7.589e-05, -3.387e-04, -4.653e-02, -5.061e-02, -4.828e-02, -4.389e-02) * s1_0_1;
	r0 += M4(-3.557e-04, -2.575e-04, -2.462e-06, -4.567e-05, 2.522e-03, 1.778e-02, 1.452e-03, 8.249e-03, 4.071e-04, 1.391e-04, 9.610e-06, 1.191e-04, -9.285e-02, -9.472e-02, -9.011e-02, -9.198e-02) * s1_0_2;
	r0 += M4(4.497e-03, -3.112e-03, -5.361e-03, -1.348e-03, 8.276e-02, 1.614e-02, 7.986e-02, 2.335e-03, 4.686e-02, -2.702e-03, -2.277e-03, 2.518e-03, 4.455e-02, 4.468e-02, 3.750e-02, 3.726e-02) * s1_1_0;
	r0 += M4(5.568e-03, 4.469e-03, -2.643e-02, -1.202e-02, -2.104e-01, -1.910e-02, -8.550e-03, 1.228e-01, 1.772e-01, 1.903e-01, 6.081e-03, -3.449e-03, 3.138e-02, 3.475e-02, 2.861e-02, 3.059e-02) * s1_1_1;
	r0 += M4(-9.043e-03, -1.040e-02, -7.666e-03, -2.098e-02, 1.564e-03, -7.007e-02, 3.230e-03, -3.943e-02, 3.130e-04, 3.577e-02, -1.606e-03, 2.549e-03, 3.384e-02, 3.441e-02, 2.992e-02, 2.983e-02) * s1_1_2;
	r0 += M4(1.337e-02, -1.084e-02, 9.510e-03, -3.926e-03, 4.955e-03, 1.257e-03, 2.694e-03, 7.946e-03, 1.797e-03, 4.363e-04, -5.116e-02, -2.019e-04, -1.571e-01, -1.552e-01, -1.560e-01, -1.492e-01) * s1_2_0;
	r0 += M4(-2.765e-01, -2.673e-02, 2.423e-01, 1.198e-01, -3.637e-03, -3.077e-03, -7.935e-02, -7.540e-02, -1.746e-03, -9.474e-03, -1.668e-01, -1.978e-01, 8.011e-02, 8.161e-02, 7.064e-02, 7.740e-02) * s1_2_1;
	r0 += M4(-9.029e-03, -1.332e-01, -1.292e-02, 9.880e-02, -4.859e-04, -1.534e-03, -1.018e-04, -2.704e-02, -3.372e-05, 7.781e-03, 3.288e-03, -1.926e-02, -5.354e-02, -5.089e-02, -5.800e-02, -5.741e-02) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 += M4(1.207e-02, 2.240e-03, 3.519e-03, -6.306e-04, 3.081e-03, 1.206e-03, -2.664e-05, 1.679e-03, -3.554e-02, -1.503e-03, 5.838e-03, -1.102e-03, -2.058e-02, -2.920e-03, -2.600e-03, -7.877e-04) * s0_0_0;
	r0 += M4(-5.280e-02, -2.119e-02, 2.220e-03, -3.165e-03, -6.767e-03, 3.016e-02, 3.158e-03, 4.676e-03, -1.796e-01, -1.843e-01, -5.385e-03, -1.591e-03, -3.686e-02, -3.919e-02, 3.495e-03, -3.988e-04) * s0_0_1;
	r0 += M4(-6.106e-03, -2.159e-02, -2.010e-03, -3.814e-03, 8.618e-04, 3.988e-05, 2.700e-04, 1.346e-03, -2.754e-03, -3.723e-02, -5.237e-04, 3.760e-04, -6.114e-03, -7.418e-03, -2.120e-03, 6.472e-04) * s0_0_2;
	r0 += M4(6.909e-02, 6.826e-04, 8.186e-02, 2.303e-03, 1.323e-01, -4.738e-02, -4.150e-01, 6.283e-03, -4.082e-03, -8.339e-04, 4.334e-02, -3.504e-03, -2.562e-02, -2.109e-03, -3.785e-02, -8.150e-04) * s0_1_0;
	r0 += M4(-1.765e-02, 1.857e-01, -3.173e-01, 1.763e-01, -4.932e-03, 5.992e-02, -1.111e-02, 6.737e-02, 6.315e-03, 5.783e-03, 1.772e-01, 1.968e-01, 2.153e-01, 5.755e-03, -1.906e-03, -1.038e-01) * s0_1_1;
	r0 += M4(-5.675e-03, -3.479e-02, 8.182e-04, -6.763e-02, 3.168e-04, -2.273e-03, 4.245e-04, -4.832e-03, -1.825e-03, -4.745e-03, -4.969e-03, 1.856e-02, -6.061e-04, 7.390e-02, -7.567e-04, 4.545e-02) * s0_1_2;
	r0 += M4(2.267e-03, -1.103e-05, 1.814e-02, 4.047e-04, -3.332e-03, -7.139e-04, -3.226e-03, 6.669e-03, 1.136e-05, 1.324e-05, -2.422e-07, 5.531e-04, -4.068e-03, -1.580e-05, 4.166e-03, -1.753e-03) * s0_2_0;
	r0 += M4(2.093e-03, 1.647e-03, 6.128e-02, 3.308e-02, 4.571e-04, 3.388e-03, 2.067e-03, 1.311e-02, -5.461e-05, -2.335e-05, -8.260e-04, -1.153e-03, 2.681e-04, 2.445e-03, 3.466e-02, 4.178e-02) * s0_2_1;
	r0 += M4(-1.266e-04, -3.055e-03, -3.380e-03, 1.597e-03, -3.796e-05, -4.297e-05, 1.538e-05, -1.080e-04, 4.492e-05, 9.924e-06, 1.191e-04, -5.793e-07, -3.008e-04, 4.528e-04, 5.574e-04, 1.297e-02) * s0_2_2;
	r0 += M4(-1.454e-03, 7.041e-03, 1.715e-02, 6.181e-03, -1.626e-02, -1.756e-04, -8.940e-04, 2.833e-03, -1.396e-03, 1.825e-03, -3.061e-03, -6.974e-04, 4.047e-03, -2.614e-03, -1.091e-02, -3.777e-03) * s1_0_0;
	r0 += M4(4.720e-02, 9.352e-03, 4.733e-02, 3.379e-02, -2.309e-03, -5.556e-02, -4.078e-03, 2.634e-04, -2.447e-03, 8.089e-03, -1.414e-03, 8.981e-05, 2.045e-02, 4.883e-02, -2.838e-02, -2.294e-02) * s1_0_1;
	r0 += M4(2.435e-02, 5.312e-02, 9.033e-03, 3.393e-02, 1.675e-03, -4.030e-03, 7.295e-05, 1.792e-04, -2.396e-04, -7.912e-04, -4.054e-06, -5.469e-04, -1.456e-02, -1.796e-02, -4.774e-03, -2.240e-02) * s1_0_2;
	r0 += M4(-3.285e-02, 3.661e-03, -4.358e-02, 8.817e-04, 1.302e-02, 4.784e-04, 2.095e-02, 1.001e-03, -3.252e-01, 3.198e-02, 1.386e-01, -5.037e-03, 3.863e-03, 6.657e-03, 4.188e-03, -7.560e-04) * s1_1_0;
	r0 += M4(-9.937e-02, -1.312e-01, -6.181e-02, -1.121e-01, 5.076e-02, 1.509e-01, 1.870e-01, -5.359e-01, 1.022e-02, 1.179e-01, 1.162e-03, 1.048e-01, 2.017e-01, -4.150e-01, 1.733e-01, 1.978e-01) * s1_1_1;
	r0 += M4(2.400e-02, 2.213e-02, 4.140e-02, 4.504e-02, 9.329e-04, 5.353e-03, -7.645e-03, 4.185e-02, -6.549e-04, 1.527e-03, -3.544e-04, 1.341e-03, -1.538e-02, 4.089e-02, -2.472e-02, -2.565e-03) * s1_1_2;
	r0 += M4(4.707e-04, 9.569e-07, -1.098e-02, 9.441e-04, 7.092e-04, -2.323e-04, -3.413e-03, -1.782e-03, -2.430e-03, 6.645e-04, -8.819e-03, -9.879e-03, 4.197e-04, -1.984e-04, -7.573e-03, 3.810e-03) * s1_2_0;
	r0 += M4(-3.672e-04, 4.964e-04, -3.386e-02, -3.583e-02, 2.878e-04, -3.380e-03, 1.727e-02, 2.158e-02, 1.546e-03, -7.499e-05, 5.161e-03, 3.373e-02, 4.622e-04, 2.255e-03, -5.629e-03, -3.871e-02) * s1_2_1;
	r0 += M4(2.435e-04, 3.091e-03, 1.016e-02, 4.949e-03, 1.771e-04, -5.252e-04, -3.581e-04, 7.901e-03, 5.294e-05, 7.115e-04, -1.633e-04, 1.591e-03, 6.017e-04, 2.655e-03, -3.651e-03, 1.128e-03) * s1_2_2;
	r0 += V4(1.545e-08, 1.141e-10, 6.059e-11, -5.820e-09);
	r0 = r0;
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
