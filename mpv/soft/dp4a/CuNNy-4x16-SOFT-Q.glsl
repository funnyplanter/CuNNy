// CuNNy 4x16 SOFT (dp4a)
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


//!DESC CuNNy-4x16-SOFT-in
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
	r0 += V4(2.654e-02, 3.835e-02, 1.188e-02, 2.228e-02) * s0_0_0;
	r1 += V4(-1.453e-02, -5.067e-02, 7.598e-03, 5.118e-03) * s0_0_0;
	r2 += V4(6.696e-02, 2.687e-02, 2.144e-03, -7.696e-03) * s0_0_0;
	r3 += V4(1.071e-03, 5.112e-03, 2.531e-04, -2.942e-02) * s0_0_0;
	r0 += V4(-4.418e-01, 7.103e-02, -1.092e-01, -5.347e-02) * s0_0_1;
	r1 += V4(6.013e-01, -5.944e-01, 1.265e-01, 7.840e-01) * s0_0_1;
	r2 += V4(7.124e-02, -4.348e-02, -6.166e-02, 8.081e-02) * s0_0_1;
	r3 += V4(4.932e-01, -1.583e-02, 7.581e-03, 5.969e-03) * s0_0_1;
	r0 += V4(4.120e-01, 1.271e-02, 3.320e-03, 1.533e-03) * s0_0_2;
	r1 += V4(3.381e-02, 6.566e-01, 6.571e-01, 2.425e-02) * s0_0_2;
	r2 += V4(-6.065e-02, 1.160e-02, 9.210e-02, -7.349e-02) * s0_0_2;
	r3 += V4(1.055e-02, 4.034e-03, -2.136e-03, 3.339e-01) * s0_0_2;
	r0 += V4(3.760e-01, -1.781e-02, -1.582e-01, -9.618e-02) * s0_1_0;
	r1 += V4(-2.779e-02, 7.359e-03, -4.329e-02, -8.507e-03) * s0_1_0;
	r2 += V4(-1.760e-02, 1.331e-02, 5.205e-02, 3.130e-03) * s0_1_0;
	r3 += V4(-4.970e-01, -2.882e-02, -5.579e-02, -1.592e-02) * s0_1_0;
	r0 += V4(9.735e-02, -2.711e-02, 4.424e-01, -5.954e-01) * s0_1_1;
	r1 += V4(-5.628e-01, -1.473e-01, -5.045e-02, -7.637e-01) * s0_1_1;
	r2 += V4(3.824e-01, -4.722e-02, 3.389e-01, 8.054e-01) * s0_1_1;
	r3 += V4(-1.008e-02, -7.480e-01, 5.429e-02, 4.472e-03) * s0_1_1;
	r0 += V4(-4.663e-01, 3.766e-02, -7.644e-03, -1.042e-01) * s0_1_2;
	r1 += V4(-3.302e-02, 1.321e-01, -6.490e-01, -4.503e-02) * s0_1_2;
	r2 += V4(-4.290e-01, 2.713e-02, -6.628e-01, -7.983e-01) * s0_1_2;
	r3 += V4(2.717e-03, -3.013e-02, -1.349e-02, -4.220e-01) * s0_1_2;
	r0 += V4(-4.204e-01, 1.003e-01, -7.213e-02, 5.886e-02) * s0_2_0;
	r1 += V4(1.188e-02, -1.846e-03, 3.172e-02, 4.740e-03) * s0_2_0;
	r2 += V4(-2.103e-03, 6.709e-01, -2.548e-02, -3.087e-03) * s0_2_0;
	r3 += V4(1.819e-03, 2.448e-02, -7.201e-01, -7.634e-03) * s0_2_0;
	r0 += V4(3.521e-01, -1.127e+01, -6.172e-02, 7.051e-01) * s0_2_1;
	r1 += V4(-2.649e-03, -2.423e-02, -3.870e-02, -1.803e-02) * s0_2_1;
	r2 += V4(-1.761e-02, 4.535e-02, 7.395e-02, 5.056e-02) * s0_2_1;
	r3 += V4(-1.076e-03, 7.630e-01, 7.166e-01, 6.411e-02) * s0_2_1;
	r0 += V4(5.987e-02, 2.239e-02, 8.580e-03, 6.222e-02) * s0_2_2;
	r1 += V4(-6.063e-03, 2.392e-02, -3.964e-02, 1.658e-02) * s0_2_2;
	r2 += V4(3.516e-03, -4.245e-02, 9.279e-02, -5.660e-02) * s0_2_2;
	r3 += V4(-4.877e-04, 2.786e-02, 1.555e-02, -3.797e-02) * s0_2_2;
	r0 += V4(-1.151e-03, 1.030e-02, 1.464e-03, 1.445e-02);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(1.254e-02, 4.626e-03, 2.368e-03, 6.124e-04);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(-9.805e-03, -6.425e-01, -2.442e-03, 3.242e-03);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r2));
	r3 += V4(-1.197e-03, -9.069e-04, 1.111e-04, -1.430e-02);
	r3 = clamp(r3, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r3));
}

//!DESC CuNNy-4x16-SOFT-conv1
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
			vec4 v0 = vec4(r.w, g.w, b.w, a.w);
			vec4 v1 = vec4(r.z, g.z, b.z, a.z);
			vec4 v2 = vec4(r.x, g.x, b.x, a.x);
			vec4 v3 = vec4(r.y, g.y, b.y, a.y);
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
	r0 = D(r0, s0_0_0, 0xFDE70108, 0xFE0DD305, 0xEF25E703, 0xE5141C04);
	r1 = D(r1, s0_0_0, 0xF601E207, 0xFBF181FA, 0xFACB1006, 0x050AFFFD);
	r2 = D(r2, s0_0_0, 0xF8EF1DFB, 0x0BD2140B, 0xFA00F80D, 0xE8D7E4F9);
	r3 = D(r3, s0_0_0, 0xC8006705, 0xF8001301, 0xE1044F05, 0xFFECE510);
	r0 = D(r0, s0_0_1, 0x1EEE9D0E, 0x2F0D7F29, 0x02CAA9E9, 0x7FC981FB);
	r1 = D(r1, s0_0_1, 0x11060E05, 0x10FD8117, 0xE01EA220, 0xEEF1F000);
	r2 = D(r2, s0_0_1, 0x4CDD81F0, 0xDE0CD12A, 0x38E2D312, 0xE2284107);
	r3 = D(r3, s0_0_1, 0xF5074311, 0x1CFCFCFF, 0x9CFF30F1, 0x03058101);
	r0 = D(r0, s0_0_2, 0xFB19F8FD, 0xEFE6ECFD, 0xF327CF01, 0xF108FAFF);
	r1 = D(r1, s0_0_2, 0xF6F6FB03, 0x3017EA0F, 0xFB130215, 0x0D060500);
	r2 = D(r2, s0_0_2, 0xF728BD07, 0x0627280E, 0xF80EFF07, 0xF50916F7);
	r3 = D(r3, s0_0_2, 0x0701B905, 0xF100B200, 0x72F2B6E5, 0xF71E3B13);
	r0 = D(r0, s0_1_0, 0x12E2F9F1, 0x150FF9F7, 0xE0F5E123, 0xF3EC06FF);
	r1 = D(r1, s0_1_0, 0x06260D0A, 0x28FEC10D, 0x10130A02, 0xFEF5F3FC);
	r2 = D(r2, s0_1_0, 0xF1B9F4F4, 0xF0219715, 0xDCE71508, 0xCD54F8EA);
	r3 = D(r3, s0_1_0, 0xFC171111, 0x0DEBEAFE, 0x0DF12717, 0x091D6510);
	r0 = D(r0, s0_1_1, 0xE161F6DA, 0xD3E2D2F7, 0x27185A38, 0xFC2D0413);
	r1 = D(r1, s0_1_1, 0xF9E20708, 0xC2014716, 0x06FEBEF5, 0xE70A15FC);
	r2 = D(r2, s0_1_1, 0x1B1A1D0E, 0xB1E30E1C, 0x2B62DBF8, 0x22CB0021);
	r3 = D(r3, s0_1_1, 0x18D1F406, 0xFC9AFFFF, 0xD0D2231A, 0xDEEDA81C);
	r0 = D(r0, s0_1_2, 0x1AD70112, 0xEE154729, 0x08FDCA14, 0xF5FDFF07);
	r1 = D(r1, s0_1_2, 0x07F4F800, 0x000E2520, 0xFFEA0E06, 0x0903ED05);
	r2 = D(r2, s0_1_2, 0xFA28FCF2, 0xF503EAEA, 0xFBCBFBF4, 0xEBEBFEFB);
	r3 = D(r3, s0_1_2, 0x1918C1F7, 0xF47F2E04, 0x0D2EDDF7, 0x26048113);
	r0 = D(r0, s0_2_0, 0xFC0EF6F5, 0x2E34E80C, 0x160B00F3, 0xF5F9FE01);
	r1 = D(r1, s0_2_0, 0x0801F5FD, 0xECD5B91A, 0xE2E8FCF8, 0xF604FF00);
	r2 = D(r2, s0_2_0, 0xE2010816, 0x7FEEE3FD, 0x031909FE, 0x02D10307);
	r3 = D(r3, s0_2_0, 0xECCAD8FE, 0xF70902FE, 0x08E8F3FC, 0xE502E3FB);
	r0 = D(r0, s0_2_1, 0x0AEA00E7, 0xE4E21E00, 0xF4D80425, 0x0D09FE04);
	r1 = D(r1, s0_2_1, 0xF9050204, 0x071D0C2E, 0xFE24E1F7, 0xFF0207FD);
	r2 = D(r2, s0_2_1, 0x0504F70A, 0x81F000FF, 0x1ADEFE09, 0xFB1AF913);
	r3 = D(r3, s0_2_1, 0xF03515EC, 0xFDFAFEFB, 0xEF2FF019, 0x481BFDDF);
	r0 = D(r0, s0_2_2, 0xF2012305, 0x0CE3EE13, 0x02F6071B, 0xF603FCFB);
	r1 = D(r1, s0_2_2, 0x04FFFF01, 0xFD1B0013, 0xFC09FDFE, 0x08F3F2FF);
	r2 = D(r2, s0_2_2, 0x090AF8F6, 0x5C1F3613, 0xFC0008FE, 0xCD170FFF);
	r3 = D(r3, s0_2_2, 0x04F81BE4, 0x04FEFA03, 0x1802130B, 0xDAD44B0A);
	r0 = D(r0, s1_0_0, 0x190307E4, 0xC3FEF547, 0xE4F50104, 0xE6F10023);
	r1 = D(r1, s1_0_0, 0x070901F7, 0x15F811FF, 0xFB1005EE, 0xF80EFC05);
	r2 = D(r2, s1_0_0, 0xEC1EFE0B, 0x35FA11BA, 0x1802FFE9, 0x26F707D1);
	r3 = D(r3, s1_0_0, 0xFCE00302, 0x0AFFFEF2, 0x03C1F6FC, 0x06F301FE);
	r0 = D(r0, s1_0_1, 0x1617FDE3, 0x3B32F7DC, 0xCC0C0230, 0x1B0A06E9);
	r1 = D(r1, s1_0_1, 0xFE05FBFB, 0xE7C71156, 0x09A2F91C, 0xFC05FFFA);
	r2 = D(r2, s1_0_1, 0xDA0CF508, 0xCCE5E66C, 0x05E7F620, 0x40F209CB);
	r3 = D(r3, s1_0_1, 0x16000307, 0x10F4FEEE, 0x274502FE, 0x1BED0BEE);
	r0 = D(r0, s1_0_2, 0xF203FFF8, 0xDCF802EB, 0xCA050726, 0xF0020304);
	r1 = D(r1, s1_0_2, 0x0502FEF6, 0x1801040C, 0x6C0101CD, 0x010001FE);
	r2 = D(r2, s1_0_2, 0x00F604E4, 0x32FD02E0, 0x1CFB01F9, 0x25FF08EC);
	r3 = D(r3, s1_0_2, 0x1615F6F0, 0x0605FE07, 0x9AE813F7, 0x150BFEFF);
	r0 = D(r0, s1_1_0, 0x04072707, 0xF8CAEEFF, 0x0DCCDDF8, 0xEA8FF713);
	r1 = D(r1, s1_1_0, 0x01E60702, 0xAE9D394D, 0xE23AF70E, 0xFC0503FF);
	r2 = D(r2, s1_1_0, 0x10CB152E, 0xDF1ADEB3, 0xFCFB1809, 0xF30DD4F1);
	r3 = D(r3, s1_1_0, 0xEA26C61C, 0xF603FC0B, 0x405517E5, 0x0EEFFE13);
	r0 = D(r0, s1_1_1, 0x100D1CEF, 0x1413360C, 0x8106AC2A, 0x8103F2B1);
	r1 = D(r1, s1_1_1, 0xF7FAFD15, 0x9DE21E15, 0xEB120050, 0xFE1404F6);
	r2 = D(r2, s1_1_1, 0xD934030F, 0x37CEFC04, 0xC824F81C, 0x1919EC1A);
	r3 = D(r3, s1_1_1, 0x361B28B2, 0x0FED1DFF, 0xE3C1B52C, 0x0A02FBEB);
	r0 = D(r0, s1_1_2, 0xEDFEFE14, 0x3B00FDFA, 0xE5E3F308, 0xEBFDFE0E);
	r1 = D(r1, s1_1_2, 0x03020200, 0x3906F9B8, 0x060802D5, 0xF80002F7);
	r2 = D(r2, s1_1_2, 0xE7EA0EFE, 0xFDFB0ED0, 0x0605FFEF, 0x0507FCE5);
	r3 = D(r3, s1_1_2, 0xE903F713, 0xE2FBFA0F, 0xCEF3F82E, 0x1E0FEAF1);
	r0 = D(r0, s1_2_0, 0x16E229F9, 0x172AD70D, 0x1E193ACE, 0xF3000603);
	r1 = D(r1, s1_2_0, 0xF713C0ED, 0xE848D1FC, 0xEEFF1309, 0x1A0A03F1);
	r2 = D(r2, s1_2_0, 0x21F41103, 0x9D1525F2, 0xF0F41618, 0xA5D0D005);
	r3 = D(r3, s1_2_0, 0x0AD225DC, 0x01FE05FE, 0x44F704A6, 0xD7941711);
	r0 = D(r0, s1_2_1, 0xD9F5F935, 0x81D3F6FD, 0x521821FD, 0x0E030EF6);
	r1 = D(r1, s1_2_1, 0x0102070C, 0xE14B81E6, 0xFD250A10, 0x212A0476);
	r2 = D(r2, s1_2_1, 0x0DED0AC1, 0x03D41559, 0xFE04F105, 0x4218EC01);
	r3 = D(r3, s1_2_1, 0x3F1108FD, 0xE30B3D1A, 0x33D20F31, 0x81E91F9E);
	r0 = D(r0, s1_2_2, 0x07FB061B, 0x1DFC11EB, 0xF50505AB, 0xF1020306);
	r1 = D(r1, s1_2_2, 0xFDFF02FE, 0x140113D0, 0xFD0803E8, 0xF7FEFFDB);
	r2 = D(r2, s1_2_2, 0x0F00EE0E, 0xD9FDFD03, 0xF60006F6, 0x10FF0601);
	r3 = D(r3, s1_2_2, 0xC1FBE836, 0x1C07EEF1, 0xDFFBC513, 0x81031110);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x11EE0BF7, 0x0BE0DE17, 0xEA2F3403, 0xF9190221);
	r1 = D(r1, s0_0_0, 0xF600E704, 0xC0273032, 0xE081C1D7, 0x03FAFF06);
	r2 = D(r2, s0_0_0, 0xDE1D20F9, 0x1BF6FC1D, 0xE517F613, 0xF0090A1C);
	r3 = D(r3, s0_0_0, 0x1DEF45D3, 0x0108F607, 0xC8C0FCED, 0xF8DEB411);
	r0 = D(r0, s0_0_1, 0x14F602E0, 0x09FE4ADF, 0x00F1CF42, 0xE605020C);
	r1 = D(r1, s0_0_1, 0xFB062A10, 0xF812A7E0, 0x29E31AEB, 0x01FB0005);
	r2 = D(r2, s0_0_1, 0xECFAE02C, 0xFFDF2A19, 0xFCE5BD04, 0x08174008);
	r3 = D(r3, s0_0_1, 0x12FE18D5, 0x02F7E2E3, 0x997F81EC, 0x07FD27F1);
	r0 = D(r0, s0_0_2, 0x040679F0, 0x0CECFF09, 0xFC0D6905, 0x040101FA);
	r1 = D(r1, s0_0_2, 0x00FC0104, 0x02E3D523, 0x07ED50F6, 0xFF010AFF);
	r2 = D(r2, s0_0_2, 0xEB09E405, 0xF4E36712, 0x01083AFC, 0x05F81C0B);
	r3 = D(r3, s0_0_2, 0x020D94E6, 0x0BFE23F5, 0xF1373BE0, 0xF2FC6127);
	r0 = D(r0, s0_1_0, 0xFCB02417, 0xB47FFE32, 0xF2E1E919, 0x04E9FCEC);
	r1 = D(r1, s0_1_0, 0x7FFEF4EB, 0x817FE2CF, 0x9F5B17F1, 0xEF040703);
	r2 = D(r2, s0_1_0, 0xDEE8E03C, 0xE008CBDC, 0xEED5EBF2, 0x19C1F214);
	r3 = D(r3, s0_1_0, 0x5C1E06E6, 0xFE2A06FE, 0xF61133E9, 0x371868A8);
	r0 = D(r0, s0_1_1, 0x1B0FB7CF, 0x81A8F1BA, 0xDBFB150E, 0x09F9F205);
	r1 = D(r1, s0_1_1, 0xF700F3FA, 0x2AD1452E, 0x0E0CFCCF, 0x080D07F0);
	r2 = D(r2, s0_1_1, 0x150700DE, 0xE4FA001F, 0xCF301433, 0xFB1B0FEA);
	r3 = D(r3, s0_1_1, 0xBBEAFDDB, 0x81B001B6, 0x81250681, 0x06E317ED);
	r0 = D(r0, s0_1_2, 0x07FDE3F2, 0x09EADBE7, 0xF6DDDF21, 0x06FA01FA);
	r1 = D(r1, s0_1_2, 0x01FD0AFF, 0xF3FD4305, 0xFAEAB927, 0xFC010500);
	r2 = D(r2, s0_1_2, 0x03E41033, 0xF3FCE818, 0xFA09F008, 0x00F11504);
	r3 = D(r3, s0_1_2, 0xE9FFDC15, 0xF9040A08, 0xE6079C42, 0xFFDCD4EF);
	r0 = D(r0, s0_2_0, 0xDC03EE17, 0x0A0405ED, 0x2E1016D1, 0xFCFD0008);
	r1 = D(r1, s0_2_0, 0xE90B1308, 0xDBEDF531, 0x040A1209, 0x03FFFE0D);
	r2 = D(r2, s0_2_0, 0x15F41613, 0x280B02D3, 0x0AE6F00D, 0x0710DA0E);
	r3 = D(r3, s0_2_0, 0xF0F5FED7, 0xF710FBF8, 0x37CC0FC7, 0x81C7CFBD);
	r0 = D(r0, s0_2_1, 0xF8050BFD, 0x0A38CAA3, 0x180FE1C9, 0x05F9FC04);
	r1 = D(r1, s0_2_1, 0x0306F7FE, 0x09E5F1DC, 0xDFEEAB3E, 0xF70AF1F8);
	r2 = D(r2, s0_2_1, 0x02FB0CEF, 0x26EA0A08, 0x05F7060B, 0x05FE1DDB);
	r3 = D(r3, s0_2_1, 0xD92BE0F6, 0xEFFB03F4, 0x46F9EED2, 0xC323B77F);
	r0 = D(r0, s0_2_2, 0x08FEE4F7, 0x01FC000D, 0xFD0AB307, 0xFBFD090C);
	r1 = D(r1, s0_2_2, 0xFEFDF106, 0x05F9F704, 0xEE0C061E, 0x04FBF402);
	r2 = D(r2, s0_2_2, 0xFFFD1101, 0x1E078BDD, 0x010213F6, 0x06FAFDFB);
	r3 = D(r3, s0_2_2, 0xEDF8D647, 0x0B03EEE3, 0x26FD21A9, 0x0AF5181E);
	r0 = D(r0, s1_0_0, 0xFE0B0802, 0xF80700FF, 0xF8FC060E, 0x0F0528FC);
	r1 = D(r1, s1_0_0, 0x03FD06FE, 0x120BCFFC, 0xE814C3FB, 0xFA03FBFE);
	r2 = D(r2, s1_0_0, 0xE105FFF5, 0xC2F61B09, 0xD1FD0FFD, 0xE91BE203);
	r3 = D(r3, s1_0_0, 0x2311E4FC, 0x00030900, 0x33062AFE, 0xF6FCFE0B);
	r0 = D(r0, s1_0_1, 0xF8EB06F7, 0xFF8181EE, 0x031B2A27, 0x0011F002);
	r1 = D(r1, s1_0_1, 0xF981F2FD, 0xF3CFAABE, 0x16E781ED, 0xFF070C01);
	r2 = D(r2, s1_0_1, 0x2F1E0209, 0xF31926EE, 0x00F83EF7, 0xEDEE4106);
	r3 = D(r3, s1_0_1, 0xF7DC32F0, 0xFF09DD01, 0xDC3C1CF9, 0xF7E81607);
	r0 = D(r0, s1_0_2, 0xF302030B, 0x142DE1F8, 0x01F80121, 0xFCED1308);
	r1 = D(r1, s1_0_2, 0xFF0807FD, 0x04A7F809, 0xEFF414F8, 0x01FAF3FC);
	r2 = D(r2, s1_0_2, 0x0723EC12, 0x07090E02, 0x11DC07FC, 0x0D0D0EE9);
	r3 = D(r3, s1_0_2, 0xDA07E7EC, 0xFA0513FF, 0x24ED817F, 0xF25922EB);
	r0 = D(r0, s1_1_0, 0x0A02E4FB, 0x4CEFE4F7, 0x7FE719FD, 0x6F0315FA);
	r1 = D(r1, s1_1_0, 0x01FD0501, 0xA2EDC204, 0xCA00F9F9, 0x0001FDFA);
	r2 = D(r2, s1_1_0, 0x2E190206, 0xC5100019, 0x19FF2407, 0xF30120EA);
	r3 = D(r3, s1_1_0, 0x020131F7, 0x1AFFF702, 0xCEFB0508, 0xFD000501);
	r0 = D(r0, s1_1_1, 0xFE190D07, 0xDF4B2138, 0xF90C81DE, 0xF0FDF6D9);
	r1 = D(r1, s1_1_1, 0x1019F308, 0x311A0E81, 0x1FF5D4F2, 0x0BED110A);
	r2 = D(r2, s1_1_1, 0xFFE905E8, 0x3DE0BBF8, 0xE600D80C, 0xFAE409C7);
	r3 = D(r3, s1_1_1, 0x0D1AD237, 0xE80B2502, 0x50EFF8D8, 0xEDCEDA09);
	r0 = D(r0, s1_1_2, 0xF503DDD1, 0xFF0D3494, 0x2AF3084F, 0x04F7101E);
	r1 = D(r1, s1_1_2, 0xFCFBFF0B, 0x0A16ED81, 0x0607E7DF, 0xFD0CFAF8);
	r2 = D(r2, s1_1_2, 0x19FAFFDA, 0x0BEBEB11, 0x10FF05EC, 0x021D0AF7);
	r3 = D(r3, s1_1_2, 0x00FBDCBC, 0x1616EA21, 0xE8D708FE, 0xFA8128DB);
	r0 = D(r0, s1_2_0, 0x2F00F8FD, 0x4900CEF2, 0xCF00EA12, 0xF2000CFF);
	r1 = D(r1, s1_2_0, 0xF700FAFD, 0xF8031A1D, 0xDA051E00, 0xF7FF0903);
	r2 = D(r2, s1_2_0, 0x01FC1CFE, 0xEC0381DE, 0x3BFDF003, 0x2FFFFFF6);
	r3 = D(r3, s1_2_0, 0xC3030FFC, 0x12FF0802, 0x0502FC0A, 0x7F07F4E8);
	r0 = D(r0, s1_2_1, 0x0706F8DC, 0x09F01A81, 0x04F61DEA, 0x0900F40E);
	r1 = D(r1, s1_2_1, 0x03FE0601, 0xF5F307D1, 0x000AFF1E, 0x0D0405FC);
	r2 = D(r2, s1_2_1, 0xFBFDFF00, 0x59187F08, 0x01FCF8FE, 0xEE00077F);
	r3 = D(r3, s1_2_1, 0xEB0D0BCE, 0xF0000107, 0x14F61BFB, 0x7F0B814C);
	r0 = D(r0, s1_2_2, 0xF6000E07, 0xF9F1FB39, 0xFAF0EE11, 0x000209FC);
	r1 = D(r1, s1_2_2, 0x0100FD01, 0xEE000CFF, 0xEB09FA0E, 0xFE04F304);
	r2 = D(r2, s1_2_2, 0x09FFFB01, 0xB81E84AF, 0x08FC04FF, 0x02073605);
	r3 = D(r3, s1_2_2, 0xEC0BFF0F, 0xFCFDFEDD, 0x0D04EE13, 0xD9E70681);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 = clamp(f3, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-SOFT-conv2
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
			vec4 v0 = vec4(r.w, g.w, b.w, a.w);
			vec4 v1 = vec4(r.z, g.z, b.z, a.z);
			vec4 v2 = vec4(r.x, g.x, b.x, a.x);
			vec4 v3 = vec4(r.y, g.y, b.y, a.y);
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
	r0 = D(r0, s0_0_0, 0x081007FF, 0x02FCF700, 0x130719EF, 0xC41104EF);
	r1 = D(r1, s0_0_0, 0x0600FDFC, 0x00000000, 0xFF1202FB, 0xB4291AE6);
	r2 = D(r2, s0_0_0, 0xFE05F605, 0x02000400, 0xFD060202, 0xFB06F7F4);
	r3 = D(r3, s0_0_0, 0xFD040100, 0x03FE0CEC, 0xF4060A03, 0x121FF40D);
	r0 = D(r0, s0_0_1, 0xEE29F01C, 0x0607F9FA, 0x0809F4E0, 0xFB1105F9);
	r1 = D(r1, s0_0_1, 0x0E05FCF6, 0x01F90201, 0xF0201604, 0xC3260FD7);
	r2 = D(r2, s0_0_1, 0x0418EDF6, 0xFC0B0DFE, 0xFFFF04F8, 0x1AEBFCE8);
	r3 = D(r3, s0_0_1, 0xF8000700, 0xF6061AFD, 0x0B11F5EE, 0xE0EEDBBE);
	r0 = D(r0, s0_0_2, 0x08F302E5, 0xFAF5F8FB, 0x0BFEEFFA, 0x0108020C);
	r1 = D(r1, s0_0_2, 0xF2FCF801, 0x000002FD, 0xF4090EFF, 0xD80722EE);
	r2 = D(r2, s0_0_2, 0xF7F1E8FA, 0xFC010608, 0xFB020200, 0x0823F809);
	r3 = D(r3, s0_0_2, 0xFD040602, 0xFA0106FE, 0xEB200A02, 0x16EB10EF);
	r0 = D(r0, s0_1_0, 0x150B0FF8, 0x0907D706, 0x090615ED, 0xCB0EE206);
	r1 = D(r1, s0_1_0, 0xEE02F9F6, 0x070DFEFF, 0x10121408, 0xC01C0FE6);
	r2 = D(r2, s0_1_0, 0x0EFDF105, 0xFD0006FE, 0x00060C00, 0xDC0EA8F6);
	r3 = D(r3, s0_1_0, 0xFE05F9FF, 0xF2252F2D, 0xE51724FB, 0x162FB90F);
	r0 = D(r0, s0_1_1, 0x25E6DFDE, 0x2405B1C9, 0xF1F3D3F2, 0x81F4F7E0);
	r1 = D(r1, s0_1_1, 0x31E4F2C9, 0xF90608FD, 0xF6121E0E, 0x3EB912ED);
	r2 = D(r2, s0_1_1, 0xE9FBCF0C, 0xF4F601EE, 0xF7030902, 0x2D11E3D5);
	r3 = D(r3, s0_1_1, 0xEE04DFF0, 0x2DF0DD0E, 0xBA1B0B30, 0xCD30521F);
	r0 = D(r0, s0_1_2, 0xE917EA13, 0x0DFDF4FE, 0xF10BF3F6, 0x21FDF3FD);
	r1 = D(r1, s0_1_2, 0xDF0300FA, 0x000701FE, 0x0307040B, 0xC43B37BB);
	r2 = D(r2, s0_1_2, 0x0609ED0A, 0x0D00FD0B, 0xF5030C08, 0x0E1C0615);
	r3 = D(r3, s0_1_2, 0x020A0106, 0x1002EFF3, 0xD9190D24, 0xF506F8EA);
	r0 = D(r0, s0_2_0, 0x0C0AF705, 0x0BF2FE03, 0x19F115F9, 0x08F8F6FB);
	r1 = D(r1, s0_2_0, 0xE10DE6FF, 0xFD020EFD, 0xF31216FC, 0xCB3118C4);
	r2 = D(r2, s0_2_0, 0xFFF4F009, 0xFCFF0102, 0xF8050BFE, 0xDD042BFE);
	r3 = D(r3, s0_2_0, 0xFE0601FD, 0xF50619DB, 0xEB0CFEF5, 0xCD1203E8);
	r0 = D(r0, s0_2_1, 0xFE0506DB, 0x34F0F8FB, 0xE90007F8, 0x170301B7);
	r1 = D(r1, s0_2_1, 0xE3EDF71C, 0xCC050800, 0x81250DED, 0x2E1C1715);
	r2 = D(r2, s0_2_1, 0x2CF7F1FB, 0xF7FEFB00, 0x4A05F90B, 0x2210EADF);
	r3 = D(r3, s0_2_1, 0xF907FC0B, 0x0A0101E5, 0xABFA02F6, 0x81E9D8DB);
	r0 = D(r0, s0_2_2, 0x010BFFFF, 0x04F9F8F7, 0xFCF003FD, 0x07F9FBE2);
	r1 = D(r1, s0_2_2, 0xEC090DF2, 0xFA060402, 0xE9091D2C, 0xB9591CFA);
	r2 = D(r2, s0_2_2, 0xF9F6F807, 0x06030108, 0xF90D0704, 0xFA0FF9F6);
	r3 = D(r3, s0_2_2, 0xF4060508, 0xFB11FCF7, 0xEF01FE0F, 0xF4170DF0);
	r0 = D(r0, s1_0_0, 0xFAFDFE06, 0x0FFEFD04, 0xFDF8D8F9, 0xF0E10CEE);
	r1 = D(r1, s1_0_0, 0x15060407, 0xFA020205, 0xEF090202, 0xD5DD04F0);
	r2 = D(r2, s1_0_0, 0xF4FDF100, 0x01FFFEFE, 0xFC03FF00, 0xFD1D06F4);
	r3 = D(r3, s1_0_0, 0xFE030302, 0xE807E4F4, 0xEE09FDFB, 0xD2FFEDF4);
	r0 = D(r0, s1_0_1, 0x0DF21402, 0x120608FD, 0x1AFB0EE5, 0x2EEF38F7);
	r1 = D(r1, s1_0_1, 0xEE07FAF8, 0x00FE000B, 0x230CFC0E, 0x11ED20FC);
	r2 = D(r2, s1_0_1, 0x160E060A, 0x1C0004FC, 0x00FEFDFE, 0xECF3F5EE);
	r3 = D(r3, s1_0_1, 0xFEFEFD03, 0xFFFFEBD3, 0xBF02F31F, 0x8BFEFFB8);
	r0 = D(r0, s1_0_2, 0x25F21FFC, 0xF1FDFE06, 0xF904F009, 0xFCF41DEA);
	r1 = D(r1, s1_0_2, 0xDCF5E807, 0xFF0100FE, 0xF80A00F8, 0x1CEFF9EE);
	r2 = D(r2, s1_0_2, 0x0F090410, 0xF306FFE4, 0xFC00FD00, 0xE4FF06E2);
	r3 = D(r3, s1_0_2, 0xEB02FFF8, 0x0D050209, 0x0B0BF5F2, 0x14ED0B02);
	r0 = D(r0, s1_1_0, 0x00FDEC04, 0xFBF711FB, 0xFBE8F005, 0x0ADF15E0);
	r1 = D(r1, s1_1_0, 0x28F9FE09, 0xEF02FC00, 0xDA0FFFFF, 0xE90A3BEB);
	r2 = D(r2, s1_1_0, 0x08FB12F8, 0x020002FF, 0xFC05FD02, 0xF5141AF3);
	r3 = D(r3, s1_1_0, 0xFD00FF08, 0xE902EBF8, 0x04FD0C02, 0xF40DF40E);
	r0 = D(r0, s1_1_1, 0xFA08E0F4, 0x04FBD231, 0x1FDE090D, 0x0CE9EE1D);
	r1 = D(r1, s1_1_1, 0x8BE99BDB, 0x7B0A051A, 0x16FCFC0B, 0xA1438127);
	r2 = D(r2, s1_1_1, 0xEA18101D, 0xF908FEEF, 0xD9F4070B, 0x1703972A);
	r3 = D(r3, s1_1_1, 0x1108FF02, 0x0CEDC381, 0xF426039B, 0xFA159281);
	r0 = D(r0, s1_1_2, 0xF802EBE9, 0xED10E335, 0xF918F432, 0xF0F4E31D);
	r1 = D(r1, s1_1_2, 0xE8FB0EB0, 0xFC000400, 0xF80BE9EF, 0x0FFBBDD8);
	r2 = D(r2, s1_1_2, 0xFA14F4FB, 0x0010FC07, 0xF00503F7, 0xD0E5D7DB);
	r3 = D(r3, s1_1_2, 0xEA03F667, 0xF60007F6, 0xFC0413BB, 0xF3091F0D);
	r0 = D(r0, s1_2_0, 0xFF0005F9, 0x0A10060E, 0x09F0FEF5, 0x0FF80AEE);
	r1 = D(r1, s1_2_0, 0xFBFBD7F9, 0xFB0D06FB, 0xD20B0200, 0xD13CFE00);
	r2 = D(r2, s1_2_0, 0x0507F90D, 0xFEFD00FF, 0xFBFE0401, 0xF01A120E);
	r3 = D(r3, s1_2_0, 0xFDFC0200, 0x0206CAF3, 0xFFF800F9, 0xF51905F6);
	r0 = D(r0, s1_2_1, 0xF718EAF6, 0x01ED01F2, 0xF30616E5, 0x02DDF7E8);
	r1 = D(r1, s1_2_1, 0x0FAAEAF6, 0xF7FDFB08, 0x8158F3F0, 0xE823BFF2);
	r2 = D(r2, s1_2_1, 0x0DEB0309, 0x03000106, 0x0207FFFF, 0xFD81F3F2);
	r3 = D(r3, s1_2_1, 0x03FF0702, 0xFD07EB17, 0x06070211, 0x07F9E7F9);
	r0 = D(r0, s1_2_2, 0xFCFFF9F4, 0xFFFBF9F5, 0xFC09F4FD, 0x02E9FE0A);
	r1 = D(r1, s1_2_2, 0xFBD61AF8, 0x04F8FF00, 0x04001E81, 0x05C421D0);
	r2 = D(r2, s1_2_2, 0x0003FD03, 0xFEFBFA08, 0xFEFE00FD, 0xFCE3EA07);
	r3 = D(r3, s1_2_2, 0xFFFDFC0F, 0xFA08010C, 0xFB07FC0E, 0xF8FB00F3);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0606F1EA, 0x0204FFFA, 0x0DF9F8F7, 0x0C21FD1C);
	r1 = D(r1, s0_0_0, 0xFC04030C, 0x00000300, 0x00020502, 0x20410111);
	r2 = D(r2, s0_0_0, 0x150DF6F7, 0x0301FB04, 0x0002FF02, 0x0A18F1F1);
	r3 = D(r3, s0_0_0, 0x01030101, 0xF90CFA00, 0x03050205, 0x17E10F04);
	r0 = D(r0, s0_0_1, 0xFAFC12ED, 0xFCFC05F3, 0xF910FBF6, 0xCA0A0524);
	r1 = D(r1, s0_0_1, 0x26F509EF, 0xFDFD0102, 0x0811F208, 0xE0354516);
	r2 = D(r2, s0_0_1, 0xF207F0FF, 0x0DFE0100, 0x0106FC01, 0x0E050FE2);
	r3 = D(r3, s0_0_1, 0x0306FCFF, 0x06080C00, 0xFC0AFB05, 0x2E4503F0);
	r0 = D(r0, s0_0_2, 0xDD03FA0C, 0x11070303, 0x15ED11F3, 0x0B02FDF7);
	r1 = D(r1, s0_0_2, 0x21061204, 0xFBFF01FD, 0xFE1107FD, 0xDA30080D);
	r2 = D(r2, s0_0_2, 0x0E1AE70E, 0x0502F607, 0xFA040102, 0x23E1FDF7);
	r3 = D(r3, s0_0_2, 0xFC01000B, 0xF40102FE, 0x03060001, 0x06E7F001);
	r0 = D(r0, s0_1_0, 0x07FA01FA, 0xF214FDED, 0x011304EF, 0xFCFACFF1);
	r1 = D(r1, s0_1_0, 0x0D12170D, 0xFF06FA03, 0xF5FA1F04, 0xE913F001);
	r2 = D(r2, s0_1_0, 0xEA0603FA, 0x0103FE07, 0x06FB0408, 0xF62AE8E7);
	r3 = D(r3, s0_1_0, 0x06FB000B, 0xEDDB06E5, 0x0403FE10, 0xFEC22422);
	r0 = D(r0, s0_1_1, 0x11C61ED5, 0x22EB0BF7, 0xE3142609, 0x2288332C);
	r1 = D(r1, s0_1_1, 0x08E3EA08, 0x0606FBF8, 0xFCEF1307, 0xD2B94C1A);
	r2 = D(r2, s0_1_1, 0x01F5160B, 0xFE06FB0C, 0xFCF9F707, 0x08E2F004);
	r3 = D(r3, s0_1_1, 0xF718E6FE, 0x27E9021A, 0xF13CF029, 0x1B0BE625);
	r0 = D(r0, s0_1_2, 0x0A06F9EE, 0xF6FA00EE, 0x03171904, 0x11EC0105);
	r1 = D(r1, s0_1_2, 0x20161CED, 0x02FAF905, 0x1B0900ED, 0xE5242BF3);
	r2 = D(r2, s0_1_2, 0xF917EBE9, 0xFA11FE0C, 0x0106FE08, 0x1FDD24E8);
	r3 = D(r3, s0_1_2, 0xFBFDF703, 0x05EAF902, 0x0C0A0A0C, 0xFE1DFCF3);
	r0 = D(r0, s0_2_0, 0xFE08FEF7, 0xFB0EFEFE, 0xF5FDF5FA, 0x0802F802);
	r1 = D(r1, s0_2_0, 0x00130E0F, 0xFE0103FE, 0x171701FF, 0x142215EF);
	r2 = D(r2, s0_2_0, 0xFE060012, 0x04000102, 0x02050306, 0xF81CF2EF);
	r3 = D(r3, s0_2_0, 0x0203FE02, 0xFDFAFEF1, 0xFE04FD06, 0x270A1320);
	r0 = D(r0, s0_2_1, 0x1305F3F5, 0xFE0A0DF0, 0x07F00D15, 0x10F90F04);
	r1 = D(r1, s0_2_1, 0xFB300FF1, 0x02FF02EF, 0xE105F012, 0xEE26FABE);
	r2 = D(r2, s0_2_1, 0xF0FE06F7, 0x04FF050A, 0xFB190207, 0xF62C04AF);
	r3 = D(r3, s0_2_1, 0xF7000102, 0xFF090601, 0x000E080C, 0x163CF3F6);
	r0 = D(r0, s0_2_2, 0x08FE0701, 0x08060201, 0xFE020802, 0x19111001);
	r1 = D(r1, s0_2_2, 0x0DE90348, 0xFE010303, 0xE1040AFE, 0xDE140817);
	r2 = D(r2, s0_2_2, 0xFDFCFB0B, 0xFEFF0100, 0x05040106, 0x1E081BEB);
	r3 = D(r3, s0_2_2, 0x04090307, 0xFB0AFD08, 0x0C1203FA, 0x11F7F114);
	r0 = D(r0, s1_0_0, 0xF51702F2, 0xF1FA0B03, 0xF5130EF4, 0x31D4BB15);
	r1 = D(r1, s1_0_0, 0xCBF81504, 0xF906FDFD, 0x0FF7E709, 0xE918BF0E);
	r2 = D(r2, s1_0_0, 0xF7FE0D0E, 0xFA050AFF, 0x06040601, 0x083433FC);
	r3 = D(r3, s1_0_0, 0x06FFFEFE, 0xE1FD04FB, 0x0A010503, 0x27310810);
	r0 = D(r0, s1_0_1, 0xF004EE05, 0xEDF504FD, 0xDDD60724, 0xF0CCED10);
	r1 = D(r1, s1_0_1, 0x001B1004, 0xFD0402FF, 0xFAF7F902, 0x81F6CD06);
	r2 = D(r2, s1_0_1, 0xF7DCF604, 0xF9F90901, 0xFF01FD01, 0xE2122301);
	r3 = D(r3, s1_0_1, 0x02FAFAF9, 0x05F3F702, 0x0B25F5F8, 0xF6D1D633);
	r0 = D(r0, s1_0_2, 0x00DEFED9, 0xFE0207FA, 0xFEC004FA, 0xFA0207FF);
	r1 = D(r1, s1_0_2, 0xFEFC040F, 0x0202FD02, 0xFB0802FA, 0x2A06F231);
	r2 = D(r2, s1_0_2, 0xF6E30EE7, 0xFBFEFFFE, 0x0506FCFE, 0xE7EA0A0B);
	r3 = D(r3, s1_0_2, 0xF905FA01, 0x0513FC0D, 0x0F08F807, 0x1C130000);
	r0 = D(r0, s1_1_0, 0x130F2BF2, 0xE1FB1102, 0xF1F901EE, 0xCE09DC12);
	r1 = D(r1, s1_1_0, 0x10C82500, 0xFF02EF03, 0xD6F6F505, 0x01D1F8FB);
	r2 = D(r2, s1_1_0, 0xD1FBE4EC, 0x09F9FF03, 0x0B01F105, 0x03D5ED11);
	r3 = D(r3, s1_1_0, 0x06FCF3FE, 0xFBF8520E, 0x02F8D0FC, 0x0F200F2B);
	r0 = D(r0, s1_1_1, 0xE20832DE, 0xFB0511E3, 0xEDC6E1F2, 0xED0311EA);
	r1 = D(r1, s1_1_1, 0x28CA2219, 0x08FE0106, 0xD6030BD9, 0x531F47DD);
	r2 = D(r2, s1_1_1, 0x00150AE2, 0x1AF34A07, 0xFAF708FF, 0x2ABF1BE2);
	r3 = D(r3, s1_1_1, 0x14E0D4FE, 0xFFF71504, 0x33178102, 0x44E381DE);
	r0 = D(r0, s1_1_2, 0xE5220EA0, 0xFD0C0703, 0xFAC70817, 0x08FC02E8);
	r1 = D(r1, s1_1_2, 0xFEBDFA38, 0xFE0004FE, 0x07F501EF, 0xFDE5FB1D);
	r2 = D(r2, s1_1_2, 0xEDF4EBD0, 0x03F9FDFA, 0x03FBFD08, 0x1716040C);
	r3 = D(r3, s1_1_2, 0x01F80413, 0xF8F80313, 0xF7FE0ACE, 0xF10B060B);
	r0 = D(r0, s1_2_0, 0xFB0215FC, 0xEBFB1C01, 0x10081D00, 0xFF0B271E);
	r1 = D(r1, s1_2_0, 0xFCD1DE13, 0x00010202, 0x0CFE8104, 0x03DFDE17);
	r2 = D(r2, s1_2_0, 0xE7FB05EB, 0x000002FA, 0xFEFFF7FB, 0xD512E1D9);
	r3 = D(r3, s1_2_0, 0x0CFFFCFB, 0x0101F6FB, 0x0C04FBF8, 0x04EEFD1A);
	r0 = D(r0, s1_2_1, 0x0805FF09, 0xF00315F0, 0x02BC0C0F, 0xF8EA090C);
	r1 = D(r1, s1_2_1, 0xE2F5D150, 0xFCF4EEEA, 0x0903D00A, 0xDDF50118);
	r2 = D(r2, s1_2_1, 0xD80704F3, 0xFC020004, 0x010501F7, 0x020103D5);
	r3 = D(r3, s1_2_1, 0x04F7E90B, 0x0A05F6FC, 0x1504F618, 0xEE07FCED);
	r0 = D(r0, s1_2_2, 0x070AFCFB, 0xF9FC07FC, 0xF3FC0103, 0xF2E80600);
	r1 = D(r1, s1_2_2, 0xF5BAE820, 0x0305FA01, 0xEE07070F, 0x0104E93B);
	r2 = D(r2, s1_2_2, 0xF40908E6, 0xF80300FD, 0x03FDFE05, 0x0BF9040C);
	r3 = D(r3, s1_2_2, 0x05F6FC02, 0x04FCFF03, 0x0405FE08, 0x020EF413);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 = clamp(f3, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-SOFT-conv3
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
			vec4 v0 = vec4(r.w, g.w, b.w, a.w);
			vec4 v1 = vec4(r.z, g.z, b.z, a.z);
			vec4 v2 = vec4(r.x, g.x, b.x, a.x);
			vec4 v3 = vec4(r.y, g.y, b.y, a.y);
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
	r0 = D(r0, s0_0_0, 0x01FFFBE7, 0xF704F80C, 0xF902FDF7, 0x021A01FF);
	r1 = D(r1, s0_0_0, 0x0700FB0B, 0x0006FB0E, 0x070000F1, 0x060EF2FA);
	r2 = D(r2, s0_0_0, 0x01F00102, 0x05FB05FD, 0x0803F4E6, 0x040A020B);
	r3 = D(r3, s0_0_0, 0x04FD01F5, 0xEC00FD1F, 0x000BE7F1, 0x07FB00F0);
	r0 = D(r0, s0_0_1, 0xFE09FD34, 0x0A0F030B, 0xF9FE00F7, 0xEF1116D5);
	r1 = D(r1, s0_0_1, 0xFF07FF12, 0x0801030A, 0x01F701F4, 0x1704F90C);
	r2 = D(r2, s0_0_1, 0xCFE1FECE, 0x0406FE04, 0x07FDFFF5, 0x020E15FD);
	r3 = D(r3, s0_0_1, 0xEB0009FB, 0xF400022A, 0xF0FD12EB, 0xF31005E5);
	r0 = D(r0, s0_0_2, 0x81818181, 0xEF0014E0, 0x0203F5F7, 0xB3F7FD1C);
	r1 = D(r1, s0_0_2, 0x04F70303, 0x01020006, 0x040101FA, 0x0806FAFA);
	r2 = D(r2, s0_0_2, 0x08FDFD09, 0xFF04FCFF, 0xFE01FA0F, 0xFBFC0A05);
	r3 = D(r3, s0_0_2, 0xF4FDFCFC, 0xFDFC0107, 0x050107FF, 0x09FCF616);
	r0 = D(r0, s0_1_0, 0x09F4FCFB, 0x0700FD0B, 0xFE0AF7FF, 0x0BFA19D7);
	r1 = D(r1, s0_1_0, 0xFDEE1211, 0xFBF904F8, 0xF7FEFBF8, 0x080808DD);
	r2 = D(r2, s0_1_0, 0x0DFC1108, 0xE9EF1E06, 0xF009F1FD, 0x0A000EF6);
	r3 = D(r3, s0_1_0, 0x0AF90814, 0xE8E40F14, 0xDAF5F103, 0x0C03FE07);
	r0 = D(r0, s0_1_1, 0x05240EFD, 0xF51118F3, 0x030FF0F5, 0xAE0EF900);
	r1 = D(r1, s0_1_1, 0x110020EE, 0xFEEF26F3, 0x35112BEC, 0x00FBF6F6);
	r2 = D(r2, s0_1_1, 0x2E0BEB45, 0xFD040602, 0xFA1FDB90, 0xEE38F83E);
	r3 = D(r3, s0_1_1, 0x05142307, 0x09EB0713, 0x511833FD, 0xCB13DD2C);
	r0 = D(r0, s0_1_2, 0x1400111C, 0x31FA0E0A, 0xF9FAF5FD, 0x811C0B81);
	r1 = D(r1, s0_1_2, 0x0B020111, 0xE5F9FA0B, 0x060AF102, 0xF602FE04);
	r2 = D(r2, s0_1_2, 0x1E02F7EB, 0xFFFFFD02, 0x0A0003F0, 0xF8FE0ADE);
	r3 = D(r3, s0_1_2, 0xF100FF06, 0xEBFA0415, 0x001DF20E, 0x0BF30DF4);
	r0 = D(r0, s0_2_0, 0x030402FF, 0x060C06FF, 0xFF09F804, 0xDF0A1A06);
	r1 = D(r1, s0_2_0, 0xFF1413E8, 0xF500FFFB, 0x09020CED, 0x06F40CE5);
	r2 = D(r2, s0_2_0, 0x0AF90BFF, 0x01FC0407, 0x0CE20124, 0x07FE07F9);
	r3 = D(r3, s0_2_0, 0x01F3FAE9, 0xF3EA0EF9, 0x05090402, 0x0AF5020A);
	r0 = D(r0, s0_2_1, 0xF8F5FEFC, 0xFB070DED, 0xFF09EFE3, 0x16D0F2ED);
	r1 = D(r1, s0_2_1, 0xFCF01510, 0xFB01FCFE, 0xF9DB05D8, 0xF8EA02D3);
	r2 = D(r2, s0_2_1, 0xF9030501, 0xFE0CFA02, 0x0F03F310, 0xF9FF00FD);
	r3 = D(r3, s0_2_1, 0xED000810, 0xFCE20A01, 0x06EE0DF1, 0x0806F716);
	r0 = D(r0, s0_2_2, 0x03F704FF, 0xF2E606FC, 0x0CF9FCF2, 0x16B314EC);
	r1 = D(r1, s0_2_2, 0xF80EFB05, 0xFA01FE05, 0x010CF9F5, 0xFF0A00F8);
	r2 = D(r2, s0_2_2, 0xFBF503FA, 0x01FFFEFD, 0x09FAF608, 0xFDF00302);
	r3 = D(r3, s0_2_2, 0xF1FF05FA, 0xF1FA040F, 0xFA0703FB, 0x0EFCFC15);
	r0 = D(r0, s1_0_0, 0xF2FF01FA, 0x090DED0A, 0x0F010707, 0xE21CFD0F);
	r1 = D(r1, s1_0_0, 0xDEEA02FA, 0x08F9FAFC, 0xF8F40AFF, 0x0B030B05);
	r2 = D(r2, s1_0_0, 0xFB09FA0C, 0xFE09FEFC, 0x08FD020C, 0xFA09F700);
	r3 = D(r3, s1_0_0, 0xF7FF0804, 0x0F0301F9, 0xFAFA08F1, 0xFA020400);
	r0 = D(r0, s1_0_1, 0x13FA093D, 0xF7F9D3DE, 0x0F222B04, 0xD2DCE5DE);
	r1 = D(r1, s1_0_1, 0xD901D9FB, 0xFEEEE3F6, 0x06DE1910, 0xFFF5F1F1);
	r2 = D(r2, s1_0_1, 0xF416C42E, 0xFEF9F5FC, 0x14DA8117, 0xF1D2F0EF);
	r3 = D(r3, s1_0_1, 0xFAF9F5F1, 0x0805D0EC, 0xECEEB913, 0xEFFEDC23);
	r0 = D(r0, s1_0_2, 0x81818181, 0xF8C02226, 0x0B07F7FC, 0xB6F2812C);
	r1 = D(r1, s1_0_2, 0xE0F905FD, 0x05FA0C01, 0xFFF80C0E, 0x07FD000E);
	r2 = D(r2, s1_0_2, 0xFA0BDEF5, 0xFE0001FD, 0x0308EDFE, 0xFDEEFFFB);
	r3 = D(r3, s1_0_2, 0xFBF908E6, 0x0804FEF1, 0xF5EF1107, 0x0906E9F8);
	r0 = D(r0, s1_1_0, 0xF2020301, 0x07F80005, 0x0A030905, 0xEF04020E);
	r1 = D(r1, s1_1_0, 0xDB090E07, 0xFCFFFFFE, 0x03040D12, 0x06FD0803);
	r2 = D(r2, s1_1_0, 0xF906000E, 0x08FEFB0F, 0x08FE051B, 0xE908FBF7);
	r3 = D(r3, s1_1_0, 0xF30AFCF7, 0x0709FAED, 0x000AFD11, 0xFA01FE04);
	r0 = D(r0, s1_1_1, 0xF5090910, 0xF8FFFE0B, 0x1505E6EB, 0xE544DD1A);
	r1 = D(r1, s1_1_1, 0xFBD72C13, 0xF9FEED16, 0xF6FE22DD, 0xEEEC1F02);
	r2 = D(r2, s1_1_1, 0xF1131301, 0x04FC0601, 0x0A01F5DA, 0xF904FD1A);
	r3 = D(r3, s1_1_1, 0xDA052516, 0x08F703F1, 0xF90AFCE0, 0xE5080109);
	r0 = D(r0, s1_1_2, 0xE3FF0817, 0xDDF00900, 0x0D09F401, 0x263DC5C1);
	r1 = D(r1, s1_1_2, 0xD8F605FB, 0xFBFC0700, 0xF30BFD1D, 0xF9FF0915);
	r2 = D(r2, s1_1_2, 0xFF0506FB, 0x0000FFFE, 0x090102F4, 0xEDF802E3);
	r3 = D(r3, s1_1_2, 0xFD0408EC, 0xFF0003F0, 0xEC000819, 0x1402FDFC);
	r0 = D(r0, s1_2_0, 0xF3FE01FD, 0xF503FC07, 0x09FB09FE, 0xE50C0EF8);
	r1 = D(r1, s1_2_0, 0xE102FEF8, 0xFFFD02FD, 0xFDFC010F, 0x14F70104);
	r2 = D(r2, s1_2_0, 0xFA0401FE, 0x030100FB, 0xFF01FEFF, 0xF00700FA);
	r3 = D(r3, s1_2_0, 0xF80103FA, 0x0800FEEF, 0xFD03FD09, 0x0B0100FF);
	r0 = D(r0, s1_2_1, 0xF6FFFE03, 0xED0804FC, 0x16030501, 0xD111091A);
	r1 = D(r1, s1_2_1, 0xDB0AFCFB, 0x0C0300F3, 0xF3F7091A, 0x0EF7090F);
	r2 = D(r2, s1_2_1, 0xF1FF0108, 0x060302FE, 0x17F902EE, 0xF701FD09);
	r3 = D(r3, s1_2_1, 0xEDFCFD05, 0x02FD00F1, 0xE302FF12, 0x1DFCFDF9);
	r0 = D(r0, s1_2_2, 0xF9F20209, 0xF0F30109, 0x0E000100, 0x9D20ED33);
	r1 = D(r1, s1_2_2, 0xED07FE04, 0x01FF0000, 0xFC000002, 0x03FD0005);
	r2 = D(r2, s1_2_2, 0xFC000004, 0x040102FE, 0xFFF7FB06, 0xFC0302FF);
	r3 = D(r3, s1_2_2, 0xFB0301FA, 0x0CFFFDEF, 0xFCFD0200, 0x13F7FCF8);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0AF815FB, 0xF7FBEAF0, 0xFB05F508, 0x180204F2);
	r1 = D(r1, s0_0_0, 0x02FC06FF, 0x070EFF02, 0xF0F912FF, 0xF603030B);
	r2 = D(r2, s0_0_0, 0x1307FA04, 0xF3FB0F08, 0x00090402, 0x1F0CFDFC);
	r3 = D(r3, s0_0_0, 0x0BEB0901, 0x09F1FC07, 0x07080AFB, 0x0EF301FE);
	r0 = D(r0, s0_0_1, 0xF80D99F2, 0xFE25F7FE, 0xFFD50900, 0x10F90FF8);
	r1 = D(r1, s0_0_1, 0x032A0A02, 0xEE2FF90A, 0x05000B01, 0xF015F806);
	r2 = D(r2, s0_0_1, 0xF5C014FE, 0x05FDFE02, 0x0B15FA08, 0x132002F5);
	r3 = D(r3, s0_0_1, 0x09F708F7, 0x0D1AF305, 0x24E40DE8, 0x279B1BFA);
	r0 = D(r0, s0_0_2, 0x81818181, 0xFBD809F7, 0x1100FF06, 0x190CFCED);
	r1 = D(r1, s0_0_2, 0xF11300FC, 0xF5090005, 0xF6050103, 0xF1070108);
	r2 = D(r2, s0_0_2, 0x1813FFFB, 0x00010002, 0x1108FFFC, 0xFAFE01F9);
	r3 = D(r3, s0_0_2, 0xF7030302, 0x04FF0406, 0xFC080500, 0x1C03FDFF);
	r0 = D(r0, s0_1_0, 0x0E04030B, 0xFDF30301, 0xFC0DE206, 0xFEED0DF8);
	r1 = D(r1, s0_1_0, 0x0EFD0EEF, 0xFF0409FA, 0xE501F5F2, 0xEDF80FFE);
	r2 = D(r2, s0_1_0, 0x0EFF0DFA, 0x1F074BF6, 0xE712DB10, 0x17F30BF7);
	r3 = D(r3, s0_1_0, 0x19EC1E01, 0x23F00AFB, 0xFDF0EF05, 0x0E00000E);
	r0 = D(r0, s0_1_1, 0x18FD1102, 0xF91035EF, 0xF61CF3F9, 0xF00D03DE);
	r1 = D(r1, s0_1_1, 0x13CBEBF6, 0x21F7FDF4, 0x14CEE1EA, 0x0FE9E8FF);
	r2 = D(r2, s0_1_1, 0xFF00D409, 0xF4F200FE, 0xA99CCEF2, 0xEAF50DE4);
	r3 = D(r3, s0_1_1, 0xE0E4FDF7, 0xF6EDF3FE, 0x0DDDF8D5, 0xF0F4B52A);
	r0 = D(r0, s0_1_2, 0x15F7F5F1, 0xF5D2E9E6, 0x080DFE06, 0x2FC88100);
	r1 = D(r1, s0_1_2, 0x0307FEFD, 0xF301FB0D, 0xEBFEF707, 0xE3FC000C);
	r2 = D(r2, s0_1_2, 0xF708F902, 0x04FF0102, 0x0EF6FFFE, 0x14EB02E8);
	r3 = D(r3, s0_1_2, 0x02FAFB02, 0xF7F3FF0A, 0xFA00F504, 0x10FD0706);
	r0 = D(r0, s0_2_0, 0x00FC0CFD, 0xF900FEF7, 0xFA03F107, 0x03F8F4EC);
	r1 = D(r1, s0_2_0, 0x04000FEB, 0x02020206, 0xF8FA08FB, 0xEEFA0A07);
	r2 = D(r2, s0_2_0, 0xFFFF07FA, 0xFC0204FE, 0x0706E5FE, 0x08FB06F7);
	r3 = D(r3, s0_2_0, 0x06FE03FF, 0x02FC0702, 0x06FA03F0, 0x0501FD00);
	r0 = D(r0, s0_2_1, 0x0BFE02FF, 0x04FC02F9, 0xF60DEE05, 0xF7F6F720);
	r1 = D(r1, s0_2_1, 0x04F800F1, 0xF40509FF, 0x12F70D0C, 0xF7FA100C);
	r2 = D(r2, s0_2_1, 0x16F8F9FD, 0x01040303, 0xED00FE00, 0x1AFB050B);
	r3 = D(r3, s0_2_1, 0x11011700, 0x10FA1506, 0x1CF60AFE, 0x08FC0203);
	r0 = D(r0, s0_2_2, 0x0A02FA00, 0xF3FAFE03, 0xFA010004, 0x0ED8D348);
	r1 = D(r1, s0_2_2, 0xFE00FDFE, 0x03000305, 0xFB010605, 0xF2000807);
	r2 = D(r2, s0_2_2, 0x0AFDFEFF, 0xFD010001, 0x140200FB, 0x0FFB0207);
	r3 = D(r3, s0_2_2, 0x05FE02FE, 0x07FC0508, 0x00FB06FB, 0x1202FDFE);
	r0 = D(r0, s1_0_0, 0xF50CF7DE, 0x03F6F915, 0xFF040500, 0x03CEFAEE);
	r1 = D(r1, s1_0_0, 0x03E5FE09, 0xFF000008, 0xFEFE04F2, 0xFF050504);
	r2 = D(r2, s1_0_0, 0x09000117, 0xF60400FC, 0x0D0A00F8, 0x02FFFA01);
	r3 = D(r3, s1_0_0, 0xFE05FFF8, 0x00F9FC09, 0x0200F9E9, 0xFF0804FC);
	r0 = D(r0, s1_0_1, 0xF9DE0434, 0x06CCD702, 0xFD020DF4, 0x12F0F821);
	r1 = D(r1, s1_0_1, 0x04F7FDFE, 0xF6FF060B, 0x10050D05, 0xF807F0FE);
	r2 = D(r2, s1_0_1, 0x161003D8, 0x01000000, 0x270902FE, 0x051104F8);
	r3 = D(r3, s1_0_1, 0x02000607, 0xFCFC02FB, 0x1B08C808, 0xF70A1115);
	r0 = D(r0, s1_0_2, 0x81818181, 0xFC050DFA, 0x03060B09, 0x13FAF5EB);
	r1 = D(r1, s1_0_2, 0x04E4F200, 0x0801FCFC, 0xFBFE03FE, 0xFC040502);
	r2 = D(r2, s1_0_2, 0x11F6D402, 0x00030301, 0xFEFFF906, 0x0AFB06FF);
	r3 = D(r3, s1_0_2, 0xFE000403, 0x08060301, 0x0405F8F9, 0x0804DA05);
	r0 = D(r0, s1_1_0, 0x0101F902, 0xFEECFCF9, 0xFE05091D, 0xFDCD00F3);
	r1 = D(r1, s1_1_0, 0xFA0400DA, 0xFE0300F5, 0xFE010105, 0x0711F7D1);
	r2 = D(r2, s1_1_0, 0x0CFE01EA, 0xF9FA21F7, 0x0F1A099B, 0x0FFCF7D2);
	r3 = D(r3, s1_1_0, 0xFEFEF4E1, 0x040AFCEF, 0x031EF09C, 0x04000118);
	r0 = D(r0, s1_1_1, 0xEC050EFC, 0xF2F7FACE, 0x021DD9E9, 0xE424FAB4);
	r1 = D(r1, s1_1_1, 0x02EC1916, 0xEAFD2C41, 0x09E10614, 0x0B150922);
	r2 = D(r2, s1_1_1, 0x06250DF9, 0xFF07FEFB, 0x3A2B0402, 0xFBFE13E0);
	r3 = D(r3, s1_1_1, 0xD8012917, 0xFEFF122F, 0x29F8D726, 0x0C1AFA0C);
	r0 = D(r0, s1_1_2, 0x1EDB1AFA, 0xF31E0E07, 0x03083209, 0x26B0E7CB);
	r1 = D(r1, s1_1_2, 0x01F1DBF9, 0xF902E1FF, 0xF9EE0AFC, 0xF404F6FF);
	r2 = D(r2, s1_1_2, 0x25FEAAFB, 0xFE040403, 0x110FFF0B, 0x2601E701);
	r3 = D(r3, s1_1_2, 0x1203EC01, 0xF4FEED03, 0x160C05FA, 0x18008C0B);
	r0 = D(r0, s1_2_0, 0xFD03FAFD, 0xFEFBFE02, 0x05030405, 0x06DC09F3);
	r1 = D(r1, s1_2_0, 0x04E9FCF1, 0x00000708, 0x00F9FA04, 0xFB08F9FC);
	r2 = D(r2, s1_2_0, 0x0009FFFA, 0x020202FC, 0xFC06030C, 0xFC01FEFD);
	r3 = D(r3, s1_2_0, 0x0905F9FA, 0x010200FB, 0xFE0AF606, 0xFFFD05FB);
	r0 = D(r0, s1_2_1, 0x05FA0000, 0xFE09FDF0, 0x0C080C00, 0xFDF90E91);
	r1 = D(r1, s1_2_1, 0x03FD0EFC, 0x05050008, 0x020303FF, 0xF70CF5FE);
	r2 = D(r2, s1_2_1, 0x0EF305F5, 0xFF0305FD, 0x190B0D01, 0xFAF8FDFE);
	r3 = D(r3, s1_2_1, 0xF8F8FB03, 0xF501F5FC, 0x010BEC00, 0xFF040206);
	r0 = D(r0, s1_2_2, 0xF9FD1502, 0xF8FD0506, 0x05051807, 0x22A521DE);
	r1 = D(r1, s1_2_2, 0x11E6ECF8, 0x00FFFCFD, 0x02FEFB00, 0xF4020200);
	r2 = D(r2, s1_2_2, 0x0AEB09FF, 0xFF020301, 0xFE06FE03, 0x03020009);
	r3 = D(r3, s1_2_2, 0x0F00F2FE, 0xF5FAF900, 0xFFF7FAFE, 0x0303E103);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 = clamp(f3, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-SOFT-conv4
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
			vec4 v0 = vec4(r.w, g.w, b.w, a.w);
			vec4 v1 = vec4(r.z, g.z, b.z, a.z);
			vec4 v2 = vec4(r.x, g.x, b.x, a.x);
			vec4 v3 = vec4(r.y, g.y, b.y, a.y);
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
	r0 = D(r0, s0_0_0, 0xF0ED01FF, 0x0B0301F1, 0xF9FD000A, 0x03F9FEFE);
	r1 = D(r1, s0_0_0, 0xE7F90ED9, 0xFCF8F705, 0xFC070DD5, 0xF3FBFD06);
	r2 = D(r2, s0_0_0, 0xF20A0F01, 0xFDFFFF01, 0xF70416E4, 0x18FCF40A);
	r3 = D(r3, s0_0_0, 0xFCFAFDFA, 0xFA000400, 0xF5010AFF, 0xF2FF0AFE);
	r0 = D(r0, s0_0_1, 0xDFE702FC, 0xE80BF3F2, 0x01F908FD, 0x0306FE0A);
	r1 = D(r1, s0_0_1, 0xF2D90F02, 0xFAF90002, 0xFEB607ED, 0x09EF03EF);
	r2 = D(r2, s0_0_1, 0xEDF10909, 0x01FBF90B, 0xF7110608, 0x0C0002FE);
	r3 = D(r3, s0_0_1, 0xF5F70007, 0xE5FD020C, 0x04FE0301, 0xD9F00AFF);
	r0 = D(r0, s0_0_2, 0x01FA04FF, 0xFD010200, 0x0705FBF7, 0xFEFF02FD);
	r1 = D(r1, s0_0_2, 0xF7FDFEF6, 0xFEF90002, 0xF7E802F2, 0xFCFDFEFA);
	r2 = D(r2, s0_0_2, 0xF8FD06F8, 0x050003FF, 0xF8FD05F1, 0x0C03050C);
	r3 = D(r3, s0_0_2, 0x02F902FA, 0x07FD02FC, 0x0202FFFC, 0x0CFEFB00);
	r0 = D(r0, s0_1_0, 0xFDE1F921, 0xE1FF081C, 0x0AF5EF20, 0xF5E5EE33);
	r1 = D(r1, s0_1_0, 0x8104ED36, 0x04FB020B, 0xEDFD0D1D, 0xFC09F320);
	r2 = D(r2, s0_1_0, 0xC7F4BF20, 0x0201FF06, 0xEAF0CF54, 0x41DBE420);
	r3 = D(r3, s0_1_0, 0x16FFD71D, 0xE90002D6, 0xD0FDF61C, 0xC5A31CE7);
	r0 = D(r0, s0_1_1, 0xE9120113, 0xFFF40C3C, 0xD7D40F23, 0x07FC001D);
	r1 = D(r1, s0_1_1, 0xD817014F, 0x0CB8F50A, 0xE2B2EC4C, 0x17EBEB3A);
	r2 = D(r2, s0_1_1, 0xFFB50533, 0xF5E11E30, 0xE7A50139, 0x27C91509);
	r3 = D(r3, s0_1_1, 0xFCDB060D, 0xD2051D35, 0x170800FD, 0x81B023FF);
	r0 = D(r0, s0_1_2, 0x0DFD0304, 0x0701FD08, 0xFC09FFF9, 0x01FBFE07);
	r1 = D(r1, s0_1_2, 0xFF03FA05, 0x091201FF, 0xDDE9F7ED, 0xFEDFFFDC);
	r2 = D(r2, s0_1_2, 0x03FF04FB, 0x08F2FBF3, 0xF6F00D18, 0x0CFE03F8);
	r3 = D(r3, s0_1_2, 0xFFEE02FE, 0x08F20000, 0xF400FFFC, 0x1E18FEFD);
	r0 = D(r0, s0_2_0, 0xDC0009A7, 0x0F00E3F7, 0xF60104F0, 0x1F01FDF2);
	r1 = D(r1, s0_2_0, 0x2400090D, 0x06FDFBDD, 0x1502E913, 0x0E02FD05);
	r2 = D(r2, s0_2_0, 0xFCFB0B09, 0xFFFA07C6, 0x0304FF1B, 0x07EE2404);
	r3 = D(r3, s0_2_0, 0xEA0CF94D, 0xFCFEFECC, 0x04FC01C0, 0xF5F6C6E4);
	r0 = D(r0, s0_2_1, 0x160001EF, 0x2101FDFC, 0xF9FD0CD5, 0xF6E60BE6);
	r1 = D(r1, s0_2_1, 0x1801FBD8, 0xE61312D4, 0xFD110BFB, 0x0502F637);
	r2 = D(r2, s0_2_1, 0xF4F8F316, 0x0FECCE64, 0x0FE2E308, 0x14F3030D);
	r3 = D(r3, s0_2_1, 0x0AFBF71A, 0x10FE0B05, 0x0C00FE17, 0x06EF3BFE);
	r0 = D(r0, s0_2_2, 0xF9030103, 0x0F02FE03, 0xF2F9FB00, 0x020104FF);
	r1 = D(r1, s0_2_2, 0x00000005, 0x0201F905, 0x0D09FD0A, 0x02F902FE);
	r2 = D(r2, s0_2_2, 0xFCFC0300, 0xFBFD05EE, 0x02FBF4F0, 0x06F80CF7);
	r3 = D(r3, s0_2_2, 0xFB02FFF8, 0xF6FCFDE7, 0xFB0002FE, 0xFB03FF06);
	r0 = D(r0, s1_0_0, 0xF5F5EB07, 0x01F90A00, 0xFEFC0803, 0x010504FE);
	r1 = D(r1, s1_0_0, 0x06FA020B, 0x01FB03FF, 0xF902FD12, 0xF9020004);
	r2 = D(r2, s1_0_0, 0x0C01F610, 0x00030005, 0x0803F60B, 0xF8F3FA12);
	r3 = D(r3, s1_0_0, 0xF9000107, 0x0100FE02, 0x02050901, 0xF209FF0D);
	r0 = D(r0, s1_0_1, 0x10FB0B17, 0x0505EFD8, 0x0C0EED03, 0x0709FDFF);
	r1 = D(r1, s1_0_1, 0x2CF0E838, 0xFEFCFE03, 0x06D9F021, 0xF6FBFF07);
	r2 = D(r2, s1_0_1, 0xE7F6E4FC, 0x0402F500, 0xF5FEE60C, 0x0303FB31);
	r3 = D(r3, s1_0_1, 0xFBF80105, 0x04FDF405, 0x0505F302, 0xF504FAFD);
	r0 = D(r0, s1_0_2, 0xFC08FAFA, 0xFCFD0504, 0xEEF50307, 0xFD05FE02);
	r1 = D(r1, s1_0_2, 0x0E06F60F, 0x04040104, 0x1FE4FB27, 0x0C01FF03);
	r2 = D(r2, s1_0_2, 0xFBFB0905, 0xFD0307FB, 0xE109EE0F, 0xEA09F71A);
	r3 = D(r3, s1_0_2, 0x0B01FE00, 0xFBFBFF05, 0x00FB0103, 0xEFF5F304);
	r0 = D(r0, s1_1_0, 0x1001F00E, 0x02F40A00, 0x04FEF2FC, 0xF2FA0B12);
	r1 = D(r1, s1_1_0, 0xFF010407, 0x02FFFAF8, 0x010A000B, 0xF40A0403);
	r2 = D(r2, s1_1_0, 0xE307F707, 0x00080601, 0xE400090F, 0xFE000311);
	r3 = D(r3, s1_1_0, 0x0400FC09, 0x01FDFD03, 0xF8E93B1A, 0x09D4F40C);
	r0 = D(r0, s1_1_1, 0xCA5909F2, 0x0BFC181F, 0xC93159FC, 0xD50A44EE);
	r1 = D(r1, s1_1_1, 0xF5E0070A, 0x045A13E6, 0xFD1F04F7, 0xFEF4D4FB);
	r2 = D(r2, s1_1_1, 0x11F33CE0, 0xE2E5E9F4, 0xDFF2271E, 0xF507D232);
	r3 = D(r3, s1_1_1, 0xDE3104B5, 0xF903EFFB, 0x00EAF5E9, 0xCD2C1A11);
	r0 = D(r0, s1_1_2, 0x0201F604, 0x08F80EFF, 0x0FDD01FC, 0xFD03F006);
	r1 = D(r1, s1_1_2, 0x03F700FD, 0xE9FAFDF2, 0xED0C00FA, 0xF812E80E);
	r2 = D(r2, s1_1_2, 0xFB0F0809, 0xFD0D1D23, 0x03082516, 0xFC01F622);
	r3 = D(r3, s1_1_2, 0x0104FE0A, 0x07F61C1C, 0xFFFEFF0A, 0xFCE2F0FF);
	r0 = D(r0, s1_2_0, 0xFC070500, 0xFFFFFF00, 0x030202FF, 0x15F2F6FF);
	r1 = D(r1, s1_2_0, 0xFEF9FE02, 0x0005FE00, 0xE6FD0508, 0xF8050401);
	r2 = D(r2, s1_2_0, 0x02FDFE07, 0xFA0905FE, 0x0CF7FF0D, 0xFA04FE0C);
	r3 = D(r3, s1_2_0, 0xF0F90003, 0x00FFFF00, 0xF90602FB, 0x1AE5F711);
	r0 = D(r0, s1_2_1, 0xFE0109FD, 0x05FDFC00, 0xFB04FDFD, 0xEA0EFD0B);
	r1 = D(r1, s1_2_1, 0x0101F903, 0xEEFD0104, 0xE8ED011D, 0xFBF70105);
	r2 = D(r2, s1_2_1, 0x0102F8FA, 0x0FF8FDFF, 0x1BF9E9FC, 0xFBFF0918);
	r3 = D(r3, s1_2_1, 0x06EBF413, 0x03FAFD04, 0x04FD0408, 0xD8151EFF);
	r0 = D(r0, s1_2_2, 0xFC040504, 0xFFFFFB02, 0x01FA0600, 0x01F90FF8);
	r1 = D(r1, s1_2_2, 0x0001FF02, 0x0602FE05, 0xFFF4FA1F, 0x00FC0302);
	r2 = D(r2, s1_2_2, 0xFBFF02FF, 0xF404FD02, 0xF1F8F805, 0x0203FD0E);
	r3 = D(r3, s1_2_2, 0x00FE0000, 0x00FEF5FF, 0x03FD0002, 0x12E7F3FF);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x030C05F1, 0xF30100FD, 0xF90700F7, 0x0004FB03);
	r1 = D(r1, s0_0_0, 0x08FFFA02, 0xFF07FFFB, 0x0808FE08, 0xFC0201FE);
	r2 = D(r2, s0_0_0, 0x04FC0302, 0x0001FE02, 0x1400000D, 0x0901FB19);
	r3 = D(r3, s0_0_0, 0xFD06FD04, 0x010100FE, 0xFA0000FE, 0x050603FB);
	r0 = D(r0, s0_0_1, 0xF11001FE, 0x0EC8F0FC, 0x0CF6FB05, 0x05F5FB05);
	r1 = D(r1, s0_0_1, 0xF6FFEB0E, 0x0302FFFF, 0xE80CFDFF, 0xFD1705F6);
	r2 = D(r2, s0_0_1, 0x17E8FDF9, 0x0CFD0400, 0x09FFF20B, 0x00DBFD1A);
	r3 = D(r3, s0_0_1, 0x030207F8, 0x0AFF0202, 0x0001F5FD, 0x0B050008);
	r0 = D(r0, s0_0_2, 0x02FDFDFE, 0x020003FF, 0xFEFEFF07, 0x0002F7FF);
	r1 = D(r1, s0_0_2, 0x0100F703, 0xFA08FA09, 0xFA190906, 0xF8090200);
	r2 = D(r2, s0_0_2, 0xFE100604, 0xFEFF0104, 0x0805FA06, 0xF5F41101);
	r3 = D(r3, s0_0_2, 0x000CFA05, 0xFE0109FF, 0x0000FD00, 0x05F6F605);
	r0 = D(r0, s0_1_0, 0x0107FEED, 0x1AFDFEFB, 0x0C0900F4, 0xF1FFFEF4);
	r1 = D(r1, s0_1_0, 0x0200FFF8, 0x020901FC, 0x0AF7FCFC, 0xF600FCFF);
	r2 = D(r2, s0_1_0, 0xCDF4FDF4, 0xFEFDFDF8, 0xF900FEE6, 0xF7FD01F1);
	r3 = D(r3, s0_1_0, 0xE0FD00F1, 0x0300FEFF, 0xED05FCE9, 0x0E12FEF7);
	r0 = D(r0, s0_1_1, 0x0AA0F6FB, 0x2603FCEE, 0xCDE10803, 0x02BE0AA6);
	r1 = D(r1, s0_1_1, 0xEB81FAE4, 0x14E705F1, 0xFBB2F3CB, 0x3AA311C2);
	r2 = D(r2, s0_1_1, 0x28D624D2, 0x1481FEFC, 0xD9ABFD81, 0xD536FDC3);
	r3 = D(r3, s0_1_1, 0x28E70EFF, 0xE0E4FCFD, 0x08C8ADE5, 0xE4A0F6C4);
	r0 = D(r0, s0_1_2, 0x03FA12FF, 0x0AFDDDFD, 0x09F3D2FE, 0x07F71BFD);
	r1 = D(r1, s0_1_2, 0x0500FAF9, 0xFDF3F7FD, 0x13F1E6FB, 0xDE0D2208);
	r2 = D(r2, s0_1_2, 0xF0050B09, 0xE50A4306, 0x070202F2, 0xF2ED1FFE);
	r3 = D(r3, s0_1_2, 0xFC0118FB, 0xFA023004, 0xFBFD0403, 0x09E0DF0F);
	r0 = D(r0, s0_2_0, 0x02FFFFFC, 0xFAFFFE08, 0xF803FF00, 0xFBFD01EF);
	r1 = D(r1, s0_2_0, 0x00000201, 0xFE05FEF5, 0x0A0602F3, 0x030002FB);
	r2 = D(r2, s0_2_0, 0x050401F7, 0xFC000301, 0x0E06FB00, 0xFF0402F5);
	r3 = D(r3, s0_2_0, 0x07F901F9, 0xFF000101, 0xF701FDF3, 0x111402E4);
	r0 = D(r0, s0_2_1, 0x04FEF9AE, 0xEDFF0303, 0x0707F5F2, 0x0626EAFC);
	r1 = D(r1, s0_2_1, 0x07FDFDFC, 0x02FFF905, 0x0A05F9C8, 0xF8010008);
	r2 = D(r2, s0_2_1, 0x020EFC07, 0x0F180BDA, 0x181402DB, 0x18EDF0F8);
	r3 = D(r3, s0_2_1, 0x05F8FFE1, 0x030104F7, 0x0302EDF0, 0xFDE7E8B6);
	r0 = D(r0, s0_2_2, 0x0200F8FF, 0xFE0007FE, 0xFD06FA11, 0x0608DDF7);
	r1 = D(r1, s0_2_2, 0xFDFF0000, 0x03EFF313, 0x0105F1F7, 0xFE040103);
	r2 = D(r2, s0_2_2, 0xFF09FF06, 0xF10EEE0A, 0x0C16E804, 0xF203F902);
	r3 = D(r3, s0_2_2, 0x020AF604, 0xFD010706, 0xFDFF0000, 0x08F2EDF4);
	r0 = D(r0, s1_0_0, 0x10E412F9, 0xFAFDF102, 0x08050103, 0x02010105);
	r1 = D(r1, s1_0_0, 0xFEFC0308, 0x0DFF0902, 0xFD000BF4, 0x0304FD01);
	r2 = D(r2, s1_0_0, 0xFD08EEF3, 0x00FCF900, 0xFEFBF102, 0xFBF2FA08);
	r3 = D(r3, s1_0_0, 0x03020007, 0xFFFEFE01, 0x0005FB08, 0x09FF0302);
	r0 = D(r0, s1_0_1, 0x0910E9F2, 0xF6F60017, 0xFB07F9FB, 0x02FFFFFE);
	r1 = D(r1, s1_0_1, 0x0A05001B, 0x02FFFDFB, 0x100016F4, 0x0DEC100F);
	r2 = D(r2, s1_0_1, 0xF90D0F05, 0x030202FF, 0xF104F60E, 0xF6FCE9FB);
	r3 = D(r3, s1_0_1, 0x060400F5, 0xFC0301FC, 0xFFFB0609, 0xEF07E702);
	r0 = D(r0, s1_0_2, 0x02040305, 0xFDFDFC02, 0xFDF704FB, 0xFE010607);
	r1 = D(r1, s1_0_2, 0x02F6FF03, 0x00FFF905, 0xFE0FE0E6, 0xFD07F0F7);
	r2 = D(r2, s1_0_2, 0xFF02F9FD, 0xFCFDFD05, 0xFA020B05, 0xFF110DF0);
	r3 = D(r3, s1_0_2, 0x0001FA06, 0xFDF900F8, 0x00FEFF00, 0xFC071301);
	r0 = D(r0, s1_1_0, 0x250CED0A, 0xF3F6F6FD, 0x07FDFB0C, 0x100810FF);
	r1 = D(r1, s1_1_0, 0xF8FBFC00, 0x01FBFF0F, 0xF208F302, 0x020506FF);
	r2 = D(r2, s1_1_0, 0xE91913F4, 0x0307F6F5, 0x050413ED, 0xEF170509);
	r3 = D(r3, s1_1_0, 0xF30FFA04, 0x0006FD03, 0x0B2BFA1E, 0x0A170406);
	r0 = D(r0, s1_1_1, 0xF6B30411, 0xC4E1F3F6, 0xF0CA1DD6, 0x00EBE213);
	r1 = D(r1, s1_1_1, 0xFAFDE5F6, 0xFAF7EF06, 0xF7F7E52B, 0xE4FEE615);
	r2 = D(r2, s1_1_1, 0xFFE5C208, 0xEDC1FF09, 0x81D8E0FD, 0xF5BADCED);
	r3 = D(r3, s1_1_1, 0xFDE0134D, 0xDDF504E5, 0x0311040C, 0x13E5DC0C);
	r0 = D(r0, s1_1_2, 0x010103FE, 0x01F8F8FB, 0x0206E91E, 0x020508F5);
	r1 = D(r1, s1_1_2, 0xFE05FE05, 0x02FF0E14, 0x05EF121C, 0x03F4170C);
	r2 = D(r2, s1_1_2, 0xFAF709F3, 0xFBF1F1BC, 0xFDD8D9F6, 0xFEFE01FF);
	r3 = D(r3, s1_1_2, 0x040206F6, 0x00F1EDFF, 0x0101FEFC, 0xFCF80115);
	r0 = D(r0, s1_2_0, 0x040202FF, 0xFA0305FF, 0x0405FC05, 0x13F8EA04);
	r1 = D(r1, s1_2_0, 0x000200FE, 0x0CFC0203, 0xFC0204FA, 0x05010101);
	r2 = D(r2, s1_2_0, 0x090DF8FD, 0xFF0205FC, 0xF50CEB04, 0x0E0200FD);
	r3 = D(r3, s1_2_0, 0x0A0605FD, 0x0201FFFE, 0x0509FD0A, 0x0919D10E);
	r0 = D(r0, s1_2_1, 0xFF08FB02, 0x0209FCFF, 0xF6080106, 0xC5E62A01);
	r1 = D(r1, s1_2_1, 0xFEFD06FF, 0xEAEE15F8, 0xD3F3F3FC, 0xE9F80004);
	r2 = D(r2, s1_2_1, 0xE3F5F80D, 0xDCF9E211, 0xD506F20C, 0xEAF81FF3);
	r3 = D(r3, s1_2_1, 0xEE01E808, 0xFB00FBFA, 0x03F5FE00, 0xE1D51309);
	r0 = D(r0, s1_2_2, 0x00FEFC00, 0xFF040000, 0x0102FE06, 0xFF04FA0B);
	r1 = D(r1, s1_2_2, 0x0100FFFF, 0x06FAE502, 0xDCF6DEFD, 0xF9FD0203);
	r2 = D(r2, s1_2_2, 0xFB050DFC, 0xF7F81AF8, 0xD90E1401, 0xF401FF01);
	r3 = D(r3, s1_2_2, 0xF7FE0305, 0xFCF804FF, 0x00000000, 0xFF12E01B);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 = clamp(f3, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-SOFT-out-shuffle
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
	r0 += M4(3.838e-03, -8.749e-04, -3.373e-04, -4.668e-05, -8.889e-08, 2.230e-04, -1.076e-06, 5.979e-07, -1.140e-03, 1.033e-02, 1.859e-03, -1.661e-03, 8.868e-03, -1.026e-03, -1.621e-03, 1.091e-04) * s0_0_0;
	r0 += M4(-1.658e-02, 1.836e-02, -3.499e-03, -1.255e-03, -1.189e-05, -5.387e-04, 2.178e-06, -2.361e-06, -5.147e-04, 1.692e-02, 3.657e-04, 2.363e-04, 1.343e-01, 1.008e-01, -1.198e-03, 3.245e-04) * s0_0_1;
	r0 += M4(-3.922e-03, 1.019e-02, -5.831e-04, -2.411e-03, 7.987e-06, -1.544e-07, -1.099e-06, -4.632e-08, -7.969e-07, 3.470e-04, 5.605e-05, 5.584e-07, 1.309e-03, 3.459e-02, -6.640e-05, -5.265e-04) * s0_0_2;
	r0 += M4(-2.462e-02, -3.983e-03, 1.120e-02, -2.511e-03, 4.622e-02, 2.821e-03, -3.490e-03, 5.825e-04, -4.811e-02, 7.531e-03, -5.797e-02, -1.750e-02, 1.381e-03, -1.327e-03, -2.603e-02, 1.052e-03) * s0_1_0;
	r0 += M4(3.623e-01, 3.593e-02, -9.592e-04, 5.289e-03, 2.771e-01, 2.432e-01, 6.990e-04, -1.023e-03, 8.421e-02, -5.317e-01, -3.925e-03, 1.026e-02, 2.305e-02, -1.332e-02, 4.048e-01, -3.238e-02) * s0_1_1;
	r0 += M4(-3.306e-03, 1.328e-01, 3.259e-03, 1.392e-01, 9.607e-03, 8.639e-02, 1.762e-03, 4.058e-04, 3.296e-03, 3.243e-02, 1.439e-03, 1.277e-03, 2.403e-03, 6.723e-02, -4.212e-03, 5.391e-02) * s0_1_2;
	r0 += M4(-7.866e-04, -5.049e-04, 1.132e-02, -2.000e-03, 9.258e-04, -8.090e-04, -3.958e-02, -5.834e-03, 7.432e-04, 1.604e-03, -2.681e-02, -2.129e-03, 1.058e-05, -8.047e-05, -1.501e-03, -6.636e-04) * s0_2_0;
	r0 += M4(-1.467e-03, 2.339e-03, 1.384e-01, 1.352e-01, 4.930e-04, 4.917e-04, -2.941e-01, -2.646e-01, -7.793e-03, 6.234e-03, -9.431e-02, -1.313e-01, 1.616e-03, -1.549e-03, -1.837e-02, -6.077e-03) * s0_2_1;
	r0 += M4(-3.712e-05, -4.442e-04, -1.372e-03, 3.920e-02, -1.451e-03, 3.191e-04, -1.193e-02, -7.623e-02, -2.757e-04, 1.332e-05, 9.473e-04, -6.995e-03, -3.421e-04, -3.171e-03, -4.104e-03, -9.369e-03) * s0_2_2;
	r0 += M4(9.191e-05, -2.715e-04, 2.894e-05, -2.443e-05, -4.338e-02, -3.485e-03, -1.797e-03, 7.535e-04, 1.823e-03, -1.240e-02, 4.838e-03, -8.582e-04, 1.390e-02, -6.703e-03, 1.299e-03, 6.944e-04) * s1_0_0;
	r0 += M4(1.941e-05, 3.307e-04, -1.891e-05, 2.066e-05, -9.406e-02, -1.243e-01, -8.246e-03, 2.317e-03, -3.401e-03, -6.492e-03, 5.356e-03, 6.582e-03, 6.929e-03, -4.768e-03, -1.499e-04, 6.466e-04) * s1_0_1;
	r0 += M4(-7.421e-06, 3.735e-05, -1.040e-05, 3.585e-06, 4.670e-04, -1.247e-02, -3.899e-04, 2.350e-03, -1.296e-02, -1.682e-02, -3.286e-03, -2.190e-03, -5.137e-05, 4.047e-04, -1.768e-04, -8.980e-05) * s1_0_2;
	r0 += M4(-3.978e-02, -6.556e-03, 5.694e-03, -1.408e-03, -1.109e-01, -1.532e-02, -1.214e-01, 9.258e-03, 2.627e-01, 3.094e-02, -1.744e-01, -2.614e-02, 1.351e-01, -2.215e-03, 1.333e-01, 6.000e-03) * s1_1_0;
	r0 += M4(-2.770e-01, -2.538e-01, -3.875e-03, 7.160e-04, -2.645e-03, 5.016e-02, 5.892e-02, -4.073e-01, 1.164e-01, 3.669e-01, -1.211e-01, -3.530e-01, -3.645e-02, 3.525e-01, 9.372e-04, -4.219e-02) * s1_1_1;
	r0 += M4(-6.754e-03, -6.418e-02, -1.135e-03, 7.699e-04, 1.981e-04, 1.556e-05, 1.739e-03, 2.519e-02, 7.858e-03, 2.127e-02, -5.464e-03, 3.179e-04, -2.875e-03, -3.576e-02, -9.635e-04, -3.271e-03) * s1_1_2;
	r0 += M4(-1.739e-03, 4.855e-04, 3.788e-02, 3.795e-03, 5.080e-04, -8.459e-04, -1.204e-03, 6.718e-03, -2.762e-04, 1.287e-03, 1.930e-02, -9.254e-03, -1.444e-04, -3.416e-05, 3.967e-02, -8.793e-04) * s1_2_0;
	r0 += M4(7.578e-04, -8.171e-04, 2.761e-01, 2.646e-01, 2.605e-04, 3.028e-04, -8.813e-04, 1.788e-02, 4.265e-04, -2.141e-03, 2.008e-02, 2.594e-02, 1.472e-03, -1.267e-03, 1.265e-01, 1.244e-01) * s1_2_1;
	r0 += M4(3.322e-04, -1.353e-03, 8.941e-03, 6.285e-02, -2.012e-08, -3.186e-06, -1.491e-06, -1.540e-04, 1.171e-04, 1.519e-04, 1.039e-03, 1.157e-02, 1.348e-03, -5.735e-04, 5.405e-03, 2.014e-02) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 += M4(1.842e-03, 8.646e-05, 3.634e-05, 3.280e-05, 2.447e-02, 4.585e-03, -3.135e-03, -8.027e-04, 1.071e-02, -1.075e-03, 2.523e-05, 6.265e-04, -7.523e-04, -9.243e-05, 4.544e-04, -6.683e-04) * s0_0_0;
	r0 += M4(8.257e-03, 2.248e-03, 7.538e-04, 5.368e-04, 8.619e-02, 1.265e-01, 9.650e-04, -1.400e-03, 2.453e-02, 2.032e-02, -3.224e-04, -2.503e-04, 1.912e-02, 9.186e-03, 2.009e-02, 1.971e-02) * s0_0_1;
	r0 += M4(4.912e-03, 4.894e-03, 7.703e-04, 3.203e-04, 2.939e-03, 1.749e-02, 1.358e-03, -4.665e-04, 6.577e-04, 9.816e-03, -3.575e-05, 6.347e-04, -4.906e-05, 1.043e-02, 7.227e-04, 5.619e-03) * s0_0_2;
	r0 += M4(2.935e-02, 1.468e-03, -1.215e-03, 3.430e-04, 1.109e-02, 2.961e-03, 1.042e-02, -6.700e-03, -1.455e-01, -1.327e-02, 1.395e-01, 4.210e-03, -2.290e-02, 6.778e-03, -5.940e-03, 7.396e-03) * s0_1_0;
	r0 += M4(-5.375e-01, 8.101e-02, -2.491e-02, 6.545e-03, -6.140e-03, 6.752e-02, -7.224e-02, 5.254e-01, -1.753e-01, -4.090e-01, 1.655e-01, 3.661e-01, -1.519e-01, -1.489e-01, -1.441e-01, -1.038e-01) * s0_1_1;
	r0 += M4(1.033e-02, -1.995e-02, -3.677e-03, -2.937e-02, -2.757e-04, 1.873e-03, -4.108e-03, -3.461e-02, -2.379e-03, -1.502e-02, 3.771e-03, 9.904e-03, 2.292e-02, -1.249e-02, 2.703e-02, -1.006e-02) * s0_1_2;
	r0 += M4(-9.690e-04, -3.616e-04, -5.490e-03, 8.432e-04, 2.639e-04, -5.505e-04, 2.535e-03, -1.365e-03, 1.476e-03, -6.348e-04, -1.226e-02, -3.867e-03, 4.019e-03, 4.193e-04, -1.366e-02, -2.057e-04) * s0_2_0;
	r0 += M4(-1.696e-03, -4.675e-03, -1.527e-01, -9.103e-02, -2.204e-03, 4.212e-03, -1.615e-02, -1.557e-02, 3.359e-03, 2.993e-03, -1.486e-02, -2.422e-02, 1.387e-03, 1.338e-02, -3.633e-02, -3.308e-02) * s0_2_1;
	r0 += M4(7.762e-04, -4.000e-03, -4.484e-03, -3.940e-02, -2.672e-04, -1.204e-04, -3.654e-04, -1.393e-03, -2.030e-04, 2.155e-03, -8.438e-03, -1.789e-02, 9.445e-04, 1.793e-03, 4.078e-03, -1.011e-02) * s0_2_2;
	r0 += M4(-1.752e-02, 4.511e-04, 4.005e-03, -3.361e-04, 3.868e-02, -8.142e-03, 4.950e-03, 6.943e-04, -5.527e-04, 8.047e-04, -4.338e-04, -2.232e-05, -1.700e-02, 1.616e-03, -1.678e-02, 6.361e-04) * s1_0_0;
	r0 += M4(-1.228e-01, -1.033e-01, 5.048e-04, -5.854e-03, 1.257e-02, -1.284e-02, 1.213e-03, -3.674e-05, -3.207e-02, 7.716e-03, -3.921e-03, 1.066e-03, 1.794e-01, -1.381e-01, 7.197e-03, -1.074e-02) * s1_0_1;
	r0 += M4(-3.590e-03, -4.063e-02, -7.872e-05, 2.748e-04, 1.036e-04, -1.716e-04, 1.139e-04, 6.681e-05, -7.468e-03, 1.806e-02, -1.219e-03, -9.252e-04, -4.236e-04, 1.613e-02, 9.041e-04, 3.693e-04) * s1_0_2;
	r0 += M4(-2.452e-04, 2.803e-04, 1.869e-02, 2.075e-03, 2.647e-01, 7.828e-03, 2.455e-01, 5.842e-03, 1.013e-03, -6.137e-04, 1.221e-03, -4.431e-05, -1.436e-02, 6.476e-03, -1.158e-02, 1.271e-02) * s1_1_0;
	r0 += M4(3.119e-02, -5.919e-03, -4.580e-01, 3.699e-02, -1.123e-02, -3.057e-01, -1.274e-02, -2.938e-01, -2.725e-01, -6.562e-03, -2.559e-01, -1.024e-02, 1.072e-01, -1.304e-01, 3.662e-01, -3.697e-01) * s1_1_1;
	r0 += M4(-1.309e-02, -1.058e-01, 2.819e-03, -8.716e-02, -1.027e-04, 2.078e-04, -4.197e-04, -7.353e-04, 7.438e-03, 2.928e-01, 8.563e-03, 2.854e-01, 1.104e-03, 1.274e-02, -1.397e-03, 2.430e-02) * s1_1_2;
	r0 += M4(2.505e-06, 5.821e-05, 2.721e-06, 6.458e-05, 1.504e-03, -2.236e-04, 4.994e-02, -7.897e-03, -2.293e-05, 1.222e-06, 1.795e-06, 1.855e-04, -1.116e-02, -1.271e-03, -2.247e-02, -1.480e-03) * s1_2_0;
	r0 += M4(3.267e-04, 2.044e-04, 1.465e-02, -7.401e-04, -1.317e-03, 1.335e-03, 1.210e-02, -2.064e-02, -1.979e-03, -1.535e-03, -4.305e-02, 9.863e-03, 5.490e-03, -6.542e-03, 1.670e-02, 1.317e-03) * s1_2_1;
	r0 += M4(-6.292e-04, 6.963e-04, 3.805e-03, -3.546e-03, 2.919e-05, 1.801e-06, 1.597e-05, 1.165e-04, -1.637e-04, 1.190e-03, -8.133e-03, 3.039e-02, 1.752e-04, 3.927e-04, 8.290e-04, 8.303e-03) * s1_2_2;
	r0 += V4(-2.609e-09, 1.479e-08, -1.486e-08, 1.782e-09);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
