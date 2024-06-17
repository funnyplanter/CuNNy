// CuNNy 4x16 TEST
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


//!DESC CuNNy-4x16-TEST-in
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
#define l0(x, y) F(LUMA_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(1, 1) + ivec2(0, 0)) + vec2(0.5)) * LUMA_pt).r)
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
	r0 += V4(-1.208e-01, 1.467e-02, -2.845e-02, 5.861e-03) * s0_0_0;
	r1 += V4(-1.949e-02, 1.275e-02, 2.551e-02, -2.215e-02) * s0_0_0;
	r2 += V4(-1.396e-02, 1.195e-01, -4.297e-03, -4.305e-02) * s0_0_0;
	r3 += V4(-2.458e-05, 4.555e-05, -3.820e-02, 1.138e-02) * s0_0_0;
	r0 += V4(-2.557e-01, 2.566e-03, 3.752e-02, 1.722e-02) * s0_0_1;
	r1 += V4(2.029e-04, -5.986e-01, 2.802e-01, -1.387e-01) * s0_0_1;
	r2 += V4(-4.893e-01, -6.045e-02, 4.368e-01, 1.241e-01) * s0_0_1;
	r3 += V4(-2.570e-02, 3.307e-01, 1.937e-01, -7.819e-03) * s0_0_1;
	r0 += V4(1.418e-02, -1.603e-02, -1.181e-02, -1.034e-03) * s0_0_2;
	r1 += V4(2.059e-02, -6.917e-02, -1.064e+01, 1.392e-01) * s0_0_2;
	r2 += V4(5.076e-01, -4.504e-02, 6.686e-02, -3.766e-02) * s0_0_2;
	r3 += V4(1.604e-02, -3.252e-01, -1.302e-02, -9.938e-03) * s0_0_2;
	r0 += V4(2.075e-01, -1.800e-01, -3.159e-03, -1.556e-02) * s0_1_0;
	r1 += V4(-3.049e-01, -1.622e-02, 2.882e-03, -1.744e-01) * s0_1_0;
	r2 += V4(8.456e-03, -1.716e-01, -1.867e-04, 1.164e-01) * s0_1_0;
	r3 += V4(-1.193e-02, 2.779e-04, 2.035e-01, 4.463e-01) * s0_1_0;
	r0 += V4(-9.821e-02, 4.894e-01, -5.954e-03, -1.692e-01) * s0_1_1;
	r1 += V4(1.001e-01, 6.074e-01, -1.574e-01, -4.146e-02) * s0_1_1;
	r2 += V4(-3.147e-02, -4.424e-01, -4.365e-01, -2.900e-01) * s0_1_1;
	r3 += V4(2.933e-01, 1.200e-01, -3.026e+00, -4.031e-01) * s0_1_1;
	r0 += V4(-3.895e-02, -3.747e-02, 3.213e-01, 8.696e-03) * s0_1_2;
	r1 += V4(-2.363e-02, 7.446e-02, 1.753e-01, 2.386e-01) * s0_1_2;
	r2 += V4(2.557e-02, 4.181e-02, -5.993e-02, 1.145e-01) * s0_1_2;
	r3 += V4(-3.161e-02, -1.155e-01, 2.349e-01, -2.530e-02) * s0_1_2;
	r0 += V4(3.551e-02, -8.742e-03, 5.602e-02, 1.887e-02) * s0_2_0;
	r1 += V4(-1.737e-01, 8.883e-04, -2.580e-03, 6.665e-02) * s0_2_0;
	r2 += V4(2.842e-03, 7.788e-02, -2.002e-03, 1.855e-01) * s0_2_0;
	r3 += V4(2.346e-02, -1.125e-02, 6.845e-03, 4.355e-02) * s0_2_0;
	r0 += V4(2.900e-01, -2.744e-01, 3.717e-02, 8.335e-03) * s0_2_1;
	r1 += V4(3.975e-01, -8.111e-03, -1.873e-02, -6.815e-02) * s0_2_1;
	r2 += V4(-8.452e-03, 2.721e-01, 9.605e-03, -3.545e-01) * s0_2_1;
	r3 += V4(-2.664e-01, 2.631e-02, 1.972e-01, -9.203e-02) * s0_2_1;
	r0 += V4(-3.393e-02, 5.724e-03, -2.411e-03, -2.128e-02) * s0_2_2;
	r1 += V4(-2.767e-03, -1.761e-03, 3.375e-02, -1.146e-02) * s0_2_2;
	r2 += V4(2.449e-03, 2.091e-01, -8.537e-03, 1.792e-01) * s0_2_2;
	r3 += V4(1.534e-02, -1.912e-02, -6.793e-02, 2.880e-02) * s0_2_2;
	r0 += V4(-1.259e-03, 5.298e-03, -3.001e-03, 8.765e-02);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(1.022e-02, 9.502e-03, 2.365e-02, 1.421e-02);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(6.390e-03, -5.864e-04, 5.861e-04, -6.859e-04);
	r2 = max(r2, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r2));
	r3 += V4(8.634e-03, 2.046e-03, 1.205e-02, 1.838e-02);
	r3 = max(r3, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r3));
}

//!DESC CuNNy-4x16-TEST-conv1
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
	r0 = D(r0, s0_0_0, 0x0121F701, 0xEDF00B09, 0xF5F70104, 0xE10F06FB);
	r1 = D(r1, s0_0_0, 0xFDE3F603, 0xFD0101FC, 0xF5F5F0FB, 0xF1FC02FB);
	r2 = D(r2, s0_0_0, 0x16FF0308, 0xFDFC07FD, 0xECD411FF, 0x03FA0807);
	r3 = D(r3, s0_0_0, 0xD5DE1904, 0x001100FB, 0x30CA0DFB, 0x020DB8F5);
	r0 = D(r0, s0_0_1, 0x0104F40F, 0x1CE9EEFA, 0xFFEF44EC, 0xF90D3AFD);
	r1 = D(r1, s0_0_1, 0xFBF404EF, 0x0523F803, 0xF9F32FEC, 0x220EF3FC);
	r2 = D(r2, s0_0_1, 0xEB0DEE0B, 0x060F1502, 0xFEE713F2, 0xF7DFFFFB);
	r3 = D(r3, s0_0_1, 0x26062306, 0xEE000905, 0xD6090C40, 0x0309E9DE);
	r0 = D(r0, s0_0_2, 0xFA06F208, 0x0607FC0E, 0x1402FD0C, 0x140607F7);
	r1 = D(r1, s0_0_2, 0xFF1219FF, 0x0407F7FF, 0x18091217, 0xF9020AEC);
	r2 = D(r2, s0_0_2, 0xFD031606, 0xFBE5350D, 0x090D0EFD, 0xFCF30D04);
	r3 = D(r3, s0_0_2, 0x0E0BC0FA, 0x04E4FAFE, 0x17FEFAE4, 0xEA05F017);
	r0 = D(r0, s0_1_0, 0xE3E8040E, 0x22FCE510, 0x03020612, 0xFD0F0700);
	r1 = D(r1, s0_1_0, 0x0E11D9FE, 0xF44008FF, 0x04BFF4FD, 0xEF180A09);
	r2 = D(r2, s0_1_0, 0x17F9EAF6, 0x031AE5FA, 0xF9E0F6FE, 0xF7E901FA);
	r3 = D(r3, s0_1_0, 0x01FBF004, 0x01F91BFE, 0xBE22F7F2, 0xF2F7DFFE);
	r0 = D(r0, s0_1_1, 0x4EEC06FD, 0xE0FFF431, 0xFB032138, 0x06F6D113);
	r1 = D(r1, s0_1_1, 0x0EFD3BF5, 0x7E093DFF, 0x3620F013, 0x09EE14E9);
	r2 = D(r2, s0_1_1, 0xFC0A1717, 0x24E91518, 0x2DED41F0, 0x33FF812D);
	r3 = D(r3, s0_1_1, 0x0513F346, 0x151AD6FD, 0x4B132E20, 0x2A09D9F0);
	r0 = D(r0, s0_1_2, 0xE20DEE04, 0x03F2190A, 0xFDF416DE, 0xF5EBEFF9);
	r1 = D(r1, s0_1_2, 0xFC0AFEF5, 0x0CFEE90E, 0xD52D2CFA, 0xEDF4C6EB);
	r2 = D(r2, s0_1_2, 0xFEF71A10, 0xC010EEE3, 0xFD24FDEE, 0x0004D817);
	r3 = D(r3, s0_1_2, 0xED0A34BB, 0xF8F2FB04, 0xE102EDE5, 0xF005FDEE);
	r0 = D(r0, s0_2_0, 0x06F80800, 0x11100BFD, 0x24FAF634, 0x1CED2018);
	r1 = D(r1, s0_2_0, 0xFAFBFA0A, 0x0D130BFF, 0xED0803FB, 0x031E0CFC);
	r2 = D(r2, s0_2_0, 0xE4FF08FE, 0x11050AFE, 0xF41709FC, 0x01240D04);
	r3 = D(r3, s0_2_0, 0x0FEA02FB, 0xF7250101, 0x0200010A, 0x04F20811);
	r0 = D(r0, s0_2_1, 0xE906F6FA, 0xCF29DD14, 0xF1040111, 0xF70DF2FF);
	r1 = D(r1, s0_2_1, 0x0107F9FE, 0xE70802FD, 0xFDFF1502, 0x0CE2F21F);
	r2 = D(r2, s0_2_1, 0x0DFCFEEF, 0xF60BF60A, 0xF70EF2FF, 0xDA10FDF7);
	r3 = D(r3, s0_2_1, 0xFA09ECF9, 0x0AE00F06, 0x0002FD0C, 0xFDF5D8F5);
	r0 = D(r0, s0_2_2, 0x07F3F701, 0x12FD1914, 0xF323F915, 0x04F50308);
	r1 = D(r1, s0_2_2, 0xFBFEFB05, 0xFDF80404, 0xFDFD1400, 0xF3FCFCED);
	r2 = D(r2, s0_2_2, 0x06FEDBED, 0x06E60C0C, 0xFE0206E9, 0x0614F218);
	r3 = D(r3, s0_2_2, 0xFF061405, 0x02010302, 0xFEF705FF, 0x0BFD0505);
	r0 = D(r0, s1_0_0, 0x0FFDF8FE, 0xE0F60417, 0xFC0E08E8, 0xFFF2FE24);
	r1 = D(r1, s1_0_0, 0xFDF50900, 0x020202FB, 0x20F70700, 0xFEEAFD09);
	r2 = D(r2, s1_0_0, 0xE20501FD, 0xF30500FC, 0xE9100003, 0x0106FC00);
	r3 = D(r3, s1_0_0, 0x0FD60BF2, 0xFCF7FF08, 0xE208E011, 0x11031418);
	r0 = D(r0, s1_0_1, 0x08FCFC22, 0xF703F00B, 0xE6EE20E1, 0x14F70701);
	r1 = D(r1, s1_0_1, 0xF2F80030, 0xFE040121, 0xFD030FD3, 0x1507FF00);
	r2 = D(r2, s1_0_1, 0x0015F92E, 0xE3060A0C, 0xFD110720, 0xFBFC0600);
	r3 = D(r3, s1_0_1, 0x0C38FEE4, 0xFFFDFEE3, 0xF6110DD2, 0xD525E817);
	r0 = D(r0, s1_0_2, 0xFF04FEDF, 0x010305FB, 0xFEDFE325, 0xF8F30913);
	r1 = D(r1, s1_0_2, 0x0AFF0202, 0xEF00FEEB, 0xFAFFEABA, 0xEB03170D);
	r2 = D(r2, s1_0_2, 0x0AF4F7F4, 0xF611EA25, 0x02FCFEF9, 0x0003FA08);
	r3 = D(r3, s1_0_2, 0xFEE2F414, 0xFB01050B, 0x0DF30110, 0xFCDF1209);
	r0 = D(r0, s1_1_0, 0xE604FA00, 0x122EE9FB, 0x03F3F218, 0xFBF80ECA);
	r1 = D(r1, s1_1_0, 0x162BD80E, 0xF603FBF9, 0x2B0511FC, 0xE81601E8);
	r2 = D(r2, s1_1_0, 0x11E7EBF1, 0x11F8040B, 0xFB25F902, 0x070DE8F8);
	r3 = D(r3, s1_1_0, 0x030F060A, 0xDAFB1DFC, 0x1549CAFE, 0x03811505);
	r0 = D(r0, s1_1_1, 0x030A041A, 0x0D03EB02, 0x0A43E3E3, 0xFCFEE802);
	r1 = D(r1, s1_1_1, 0x09032C03, 0x21EA170D, 0x230B16FA, 0xCDDD071C);
	r2 = D(r2, s1_1_1, 0x00172A09, 0xD4350B22, 0xEB03E5D5, 0x11FCF435);
	r3 = D(r3, s1_1_1, 0xE51381FD, 0x17F0E0E0, 0xDFD2202B, 0x1CF881FB);
	r0 = D(r0, s1_1_2, 0xEFFD16D6, 0xFD0CFFDE, 0xF50304DE, 0x04022311);
	r1 = D(r1, s1_1_2, 0xFCFDF901, 0xFE0D00DD, 0x2EF5F0FF, 0x270312C6);
	r2 = D(r2, s1_1_2, 0x07ECEB36, 0xE603EBF1, 0xFD0F12FF, 0x0E03E3FD);
	r3 = D(r3, s1_1_2, 0x32F6FBFC, 0xFC00FF02, 0xE7F4FEF8, 0xEA0000FB);
	r0 = D(r0, s1_2_0, 0xF702F104, 0x24E92203, 0xE9050E03, 0xEEED810C);
	r1 = D(r1, s1_2_0, 0x0E81FCFD, 0x001AFC07, 0xF60202F9, 0x1702F10F);
	r2 = D(r2, s1_2_0, 0x07233013, 0xF18109FE, 0xF17FFEFB, 0xF4170305);
	r3 = D(r3, s1_2_0, 0xFB0109FC, 0xF31EF201, 0xDE1A0BFB, 0xF10E2901);
	r0 = D(r0, s1_2_1, 0xF4DC33F1, 0x0E38DE17, 0x1B05E10B, 0x0D36B91B);
	r1 = D(r1, s1_2_1, 0x0201FCFF, 0x0A26F503, 0xD9D00EF2, 0x16051E19);
	r2 = D(r2, s1_2_1, 0xFBB41BD0, 0xD618DAF7, 0xF03A1B0F, 0xF4F47FFD);
	r3 = D(r3, s1_2_1, 0xEE81F6FB, 0x050F160B, 0x232ACE01, 0x170C9507);
	r0 = D(r0, s1_2_2, 0xFB051604, 0xFDEF0428, 0x14F18112, 0xFDF4260C);
	r1 = D(r1, s1_2_2, 0x03010002, 0xF6031603, 0xE81F09D9, 0xFF0000F7);
	r2 = D(r2, s1_2_2, 0x042CCEDB, 0xF4092B03, 0xEBFAF909, 0xF5FAE5F8);
	r3 = D(r3, s1_2_2, 0xEC262FF8, 0x02F90704, 0x03071706, 0x16E40D1B);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xF80C1001, 0x1F040606, 0x1A02E5F7, 0x170CF306);
	r1 = D(r1, s0_0_0, 0x12FB03F6, 0xF604F9FF, 0x0BF9FFEE, 0xF60E0303);
	r2 = D(r2, s0_0_0, 0x0FF519F1, 0x10F1FBFF, 0x27FE0802, 0x06030D02);
	r3 = D(r3, s0_0_0, 0xDFEE01EF, 0x0703FA08, 0xDEEFC23D, 0xF8F7E8E6);
	r0 = D(r0, s0_0_1, 0x04F4F7FF, 0x2B06E802, 0x13D2E2FE, 0x12FDF301);
	r1 = D(r1, s0_0_1, 0x0E06EE05, 0xF4FA05F8, 0x1FFD09FD, 0xDB05F208);
	r2 = D(r2, s0_0_1, 0xE50CF5E1, 0x14F2FDFF, 0x0E0B0000, 0xFFFBFA00);
	r3 = D(r3, s0_0_1, 0xEBEB81DC, 0xFB09020A, 0xD91A260C, 0x2D1E8120);
	r0 = D(r0, s0_0_2, 0xF8070AFE, 0x0601FE08, 0x141CF401, 0x0300F905);
	r1 = D(r1, s0_0_2, 0xF8FFFFFE, 0xFF04FF02, 0xCF15F5F4, 0xF6F81C09);
	r2 = D(r2, s0_0_2, 0x460D06F3, 0x0E08F202, 0x1FF5F304, 0x090600FE);
	r3 = D(r3, s0_0_2, 0x10F181CF, 0x0AF50402, 0xFBFB1305, 0xFDEDF407);
	r0 = D(r0, s0_1_0, 0xFB4608F3, 0x4AED280A, 0xF024CC15, 0x41D3FBE9);
	r1 = D(r1, s0_1_0, 0xEA1EF206, 0x081AFD03, 0xF701EBDF, 0x0009240B);
	r2 = D(r2, s0_1_0, 0xD50AFE20, 0xF0D5E7FF, 0x17E5F8F5, 0xF9FE0403);
	r3 = D(r3, s0_1_0, 0x0DF4FCFD, 0x16E7F6F7, 0xDC2DFBA9, 0x27FCE00C);
	r0 = D(r0, s0_1_1, 0x222CFD1B, 0xF913D703, 0xE7E4DC18, 0xBB09EA01);
	r1 = D(r1, s0_1_1, 0x1AF10BED, 0x07C404FA, 0x0FE618EC, 0xC21E232A);
	r2 = D(r2, s0_1_1, 0x33E30523, 0x23A7F6E1, 0x1A301C1B, 0x28FEFCFC);
	r3 = D(r3, s0_1_1, 0x0025E518, 0xF2160D06, 0xEE81F731, 0xDB5F0601);
	r0 = D(r0, s0_1_2, 0xFAF80809, 0xF007F8F4, 0xFA1BE4F0, 0x0AE3F003);
	r1 = D(r1, s0_1_2, 0x0603FFF0, 0x0803000B, 0xC811F2F7, 0x0BE61A03);
	r2 = D(r2, s0_1_2, 0x0FF30BEE, 0x13FFDC21, 0x0BF203F2, 0xF911FF01);
	r3 = D(r3, s0_1_2, 0xE613E00B, 0x0409FE10, 0xF3F9FEFA, 0x06FFE500);
	r0 = D(r0, s0_2_0, 0x0C120322, 0x13BA05D5, 0xE2E4EB37, 0xFE22F3CF);
	r1 = D(r1, s0_2_0, 0x0018077F, 0x05FCFDCE, 0xEE2002FB, 0xFAF0EDD4);
	r2 = D(r2, s0_2_0, 0x091EFF55, 0x080FFD17, 0x00F6FF0E, 0xFDE8F4FB);
	r3 = D(r3, s0_2_0, 0x11040834, 0x00EFF981, 0x21ECFEDB, 0x1DB8F2C1);
	r0 = D(r0, s0_2_1, 0xFADCF921, 0x04F3CFFD, 0xE7D1DA25, 0x1548EC17);
	r1 = D(r1, s0_2_1, 0xF7DEFAEC, 0x0C38FE1E, 0x1AF90F3C, 0x1ACF009C);
	r2 = D(r2, s0_2_1, 0xE6BC1C12, 0x12E6F981, 0xF6DDFBF0, 0x0981FC0A);
	r3 = D(r3, s0_2_1, 0x0F1D082E, 0x0016FBFD, 0xF908F8E0, 0x0EDFFCFA);
	r0 = D(r0, s0_2_2, 0xFB0B0702, 0x1BF2FD1C, 0xF506F327, 0x02EC0311);
	r1 = D(r1, s0_2_2, 0xFD0C0201, 0x05F2FF08, 0x09D813FC, 0xEC2811E8);
	r2 = D(r2, s0_2_2, 0xF7FE05EE, 0xFA12FE22, 0x040F0DEB, 0x001BFBFD);
	r3 = D(r3, s0_2_2, 0x0FD9FDF0, 0xFFFEFF03, 0x06110805, 0x1DBEEF0D);
	r0 = D(r0, s1_0_0, 0x0404FAE9, 0x0B1503F4, 0xFA1607E9, 0xF90AFD13);
	r1 = D(r1, s1_0_0, 0x07FF1603, 0x060DFBF7, 0xFB10FF1A, 0xF407FCFC);
	r2 = D(r2, s1_0_0, 0x141221E3, 0xF50B1435, 0xFA140413, 0xFF0A0110);
	r3 = D(r3, s1_0_0, 0x0E112FDE, 0x0403F1F5, 0xF792CB29, 0x121C1FF0);
	r0 = D(r0, s1_0_1, 0xF4EB0614, 0x0100F0EF, 0xF3EA39DE, 0x0D02FC05);
	r1 = D(r1, s1_0_1, 0xFB0303EC, 0xFDFE07F8, 0x23090613, 0xF811E2FF);
	r2 = D(r2, s1_0_1, 0x0C121E17, 0xFAEA2002, 0x012AFE3A, 0x0F0006EC);
	r3 = D(r3, s1_0_1, 0xEEFE300E, 0xFDECF409, 0x250D0ECD, 0x180DEF15);
	r0 = D(r0, s1_0_2, 0xF5020216, 0x060BFD11, 0x20E30C2D, 0x051100E9);
	r1 = D(r1, s1_0_2, 0x0B03FEFE, 0xFB0F0110, 0xD816050C, 0xFE10F9EB);
	r2 = D(r2, s1_0_2, 0xE4F60E09, 0xFAFF0CE9, 0xE512FBD6, 0x02FAFF05);
	r3 = D(r3, s1_0_2, 0xEB271D18, 0xFE06FFFD, 0xFE04FF16, 0xFE0A08D1);
	r0 = D(r0, s1_1_0, 0xFD1107FC, 0xFD0A21F5, 0x01020CFA, 0x10D0071F);
	r1 = D(r1, s1_1_0, 0x050CD3E7, 0x0013FAFC, 0xFB17BCF8, 0x1606012B);
	r2 = D(r2, s1_1_0, 0xF615FBEC, 0x1130ECF8, 0xF412F12F, 0x060EED0B);
	r3 = D(r3, s1_1_0, 0x011DB406, 0xE8E32B32, 0x08F636D1, 0xE909D814);
	r0 = D(r0, s1_1_1, 0x4229F5F4, 0xE8E7EE1E, 0xF900ABDE, 0x3F05E30F);
	r1 = D(r1, s1_1_1, 0xB2FC0B1B, 0x30250626, 0x1931FDFE, 0x29F903ED);
	r2 = D(r2, s1_1_1, 0x0D0AEACB, 0xEE812422, 0x057FF2EE, 0x062CFDBA);
	r3 = D(r3, s1_1_1, 0xF3F581FB, 0x7F0EF6F0, 0xC9C6010D, 0xF2F830F7);
	r0 = D(r0, s1_1_2, 0x1706FDF6, 0x11FB03FC, 0xE3AA0A13, 0xF3EB02E2);
	r1 = D(r1, s1_1_2, 0xFB091408, 0x1D0900E9, 0x940A11F9, 0x4614EEFF);
	r2 = D(r2, s1_1_2, 0xCC0FFB22, 0x2D0EE2E9, 0x120D0C05, 0xDBF3FB17);
	r3 = D(r3, s1_1_2, 0xD54106FE, 0x01F8EAF4, 0x03FD1417, 0x15D80717);
	r0 = D(r0, s1_2_0, 0xF71518E9, 0xE80F12F8, 0x08011608, 0xE40E0AF0);
	r1 = D(r1, s1_2_0, 0xFDFFF903, 0xF20BFFFC, 0x06FFD704, 0x0323F013);
	r2 = D(r2, s1_2_0, 0x01FEDFF1, 0xF00FECF7, 0xFC0F19E5, 0xFC19F504);
	r3 = D(r3, s1_2_0, 0x03FF0CF2, 0x010A2D08, 0x09E0ED10, 0xF1E122EB);
	r0 = D(r0, s1_2_1, 0x0C07121A, 0x14AE0C30, 0x02DE03F6, 0xFA0F0411);
	r1 = D(r1, s1_2_1, 0xFD17020A, 0xEC091301, 0xF81635F5, 0xFBC22308);
	r2 = D(r2, s1_2_1, 0xC7D901F3, 0xF2F81F0D, 0xF9311B19, 0xEF060D00);
	r3 = D(r3, s1_2_1, 0x1A04FB19, 0xF0FEF2EF, 0x1C1FEBEB, 0x05FFEA39);
	r0 = D(r0, s1_2_2, 0xF80A0702, 0xF7F4F3F8, 0xF30C0B21, 0x1519F8EC);
	r1 = D(r1, s1_2_2, 0x0004FF07, 0xF10AF9FD, 0x1A17FDD5, 0x270F17E7);
	r2 = D(r2, s1_2_2, 0x0521EA38, 0xF9FDEBEB, 0xF41618F8, 0x12090C1A);
	r3 = D(r3, s1_2_2, 0x171CF1EF, 0x01FF00FA, 0xFB07F606, 0xF6F10BF4);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-8.590e-03, 7.695e-03, -2.822e-03, 1.546e-03);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-7.620e-03, -9.190e-02, -7.466e-03, -3.208e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(3.930e-03, 8.524e-03, -1.709e-02, 3.671e-04);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(8.483e-03, -6.379e-03, 6.630e-03, 1.558e-02);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-TEST-conv2
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
	r0 = D(r0, s0_0_0, 0xF6140108, 0x01FE00FC, 0x07EFFD00, 0xF30209FE);
	r1 = D(r1, s0_0_0, 0x21AEFE19, 0xF40B02F8, 0x071B0BF4, 0x0805FB05);
	r2 = D(r2, s0_0_0, 0x04FBFEFE, 0x03FC0604, 0xEBF80108, 0xFEFE01FE);
	r3 = D(r3, s0_0_0, 0x06FBFD00, 0x0412050D, 0xF4FE0601, 0xD01E15F3);
	r0 = D(r0, s0_0_1, 0x0B0E0BF0, 0xFCF7140E, 0x08FEFB07, 0x11FFF502);
	r1 = D(r1, s0_0_1, 0x2104E2E9, 0xFDF2130D, 0xFB27DE0A, 0x20E6F0DF);
	r2 = D(r2, s0_0_1, 0xEF0DFF01, 0x0405F012, 0xE410F1EA, 0x2003EC0D);
	r3 = D(r3, s0_0_1, 0xE4FF02EB, 0xE317E4E9, 0x080805FE, 0x0616FBF0);
	r0 = D(r0, s0_0_2, 0x07F3F212, 0xEE021A00, 0xF103EFFF, 0xF0FB08F5);
	r1 = D(r1, s0_0_2, 0x13FAEDED, 0x0F00FDF8, 0xD7FFFAFC, 0x3108FF04);
	r2 = D(r2, s0_0_2, 0x06FD0D0A, 0x0AFDF2F9, 0xE013031A, 0xE603030E);
	r3 = D(r3, s0_0_2, 0xF8FE170D, 0xF00BF909, 0x04FB0509, 0xDD061F13);
	r0 = D(r0, s0_1_0, 0xFC0D051A, 0xF70003E3, 0x01F8050D, 0x010CFDFC);
	r1 = D(r1, s0_1_0, 0x2AEFF7BA, 0x0507FD05, 0x0705FAEF, 0x02030EEF);
	r2 = D(r2, s0_1_0, 0x00FDFBFF, 0xFFFD0100, 0x0607FD19, 0x030401FA);
	r3 = D(r3, s0_1_0, 0x0EFD0603, 0x02F1080E, 0x0209F90C, 0xE91B0439);
	r0 = D(r0, s0_1_1, 0x1FCFAE9B, 0xE4FCFE39, 0x1204F7E9, 0x0AF0F40D);
	r1 = D(r1, s0_1_1, 0x11E50E18, 0x14F8F433, 0x0A060C0A, 0xFDDE0620);
	r2 = D(r2, s0_1_1, 0x0A01EE04, 0x07FCF4FF, 0x102BCA04, 0x13FF060F);
	r3 = D(r3, s0_1_1, 0xECFA0133, 0xFDEED00D, 0x090F0427, 0xF422FAE3);
	r0 = D(r0, s0_1_2, 0x3FFFE31F, 0x09042A09, 0xFBFEF705, 0xEBFB0AEF);
	r1 = D(r1, s0_1_2, 0x02F30515, 0x0A06FE0A, 0xFDFC050E, 0xE704060C);
	r2 = D(r2, s0_1_2, 0x1BFFE804, 0xF4FEF9FF, 0xD628D2E9, 0xEFFDF609);
	r3 = D(r3, s0_1_2, 0xFA0C191A, 0x01FD0C05, 0xFCFA1205, 0xB40DFFF4);
	r0 = D(r0, s0_2_0, 0xF90E0518, 0x050104EC, 0x0513FE0C, 0x04FBFDF3);
	r1 = D(r1, s0_2_0, 0x00B101D8, 0x050005F4, 0x05020407, 0x0A020002);
	r2 = D(r2, s0_2_0, 0xFFFF0303, 0x00FD03FD, 0x0A0FF903, 0x03EF06F0);
	r3 = D(r3, s0_2_0, 0xFFF907F2, 0xFD01050F, 0xFFFF00F7, 0x0A12F2F5);
	r0 = D(r0, s0_2_1, 0xFA02E118, 0xFEF2FC14, 0x1B110226, 0x010709EC);
	r1 = D(r1, s0_2_1, 0xF7E5F30B, 0xFEF90402, 0xF8FEFAF8, 0x00F60A08);
	r2 = D(r2, s0_2_1, 0x07F005FF, 0x00FF00FD, 0xF5FD020C, 0xF20DF004);
	r3 = D(r3, s0_2_1, 0x0604F7FE, 0x1BF7070A, 0x070B04FF, 0xE33C09F5);
	r0 = D(r0, s0_2_2, 0xF0000604, 0x01FD12FC, 0x0A03040A, 0x000000ED);
	r1 = D(r1, s0_2_2, 0x03F60707, 0xFE03FF01, 0x0015F7F2, 0x0304F80A);
	r2 = D(r2, s0_2_2, 0xF9FD0908, 0xFBFD0101, 0xF51FD812, 0xFF040506);
	r3 = D(r3, s0_2_2, 0x00F40F0B, 0x15EF0AF9, 0x0EFE01F4, 0x00060AFE);
	r0 = D(r0, s1_0_0, 0xEE0C08F9, 0x14EFF100, 0xF5050203, 0x010308FD);
	r1 = D(r1, s1_0_0, 0x01FD1EFE, 0x00ECFB08, 0xE0061CF9, 0x03F90FF0);
	r2 = D(r2, s1_0_0, 0xFE010002, 0x01062601, 0xF8120A02, 0x09020BFA);
	r3 = D(r3, s1_0_0, 0x0D0AF200, 0xDE1B08E5, 0x14F30502, 0x0F04FAF0);
	r0 = D(r0, s1_0_1, 0x01EF16F4, 0x0EFFEAF5, 0xF309F711, 0xE8F7F10F);
	r1 = D(r1, s1_0_1, 0xC9FD00F7, 0xEDFF2110, 0x110F02EE, 0xE5042DFA);
	r2 = D(r2, s1_0_1, 0x10F0FD07, 0x0504461D, 0x0C04050F, 0xEF05E308);
	r3 = D(r3, s1_0_1, 0x0403E5EF, 0x04FEFBDD, 0xFE0FE506, 0x13F3E721);
	r0 = D(r0, s1_0_2, 0xEFF80EF7, 0x0007FA04, 0x08FCFB02, 0xFF0206FF);
	r1 = D(r1, s1_0_2, 0x161407FF, 0x0304FD00, 0xEBF20301, 0x03F90C10);
	r2 = D(r2, s1_0_2, 0xFC09FA13, 0xFC002304, 0xF3FFF104, 0xF9FF01FD);
	r3 = D(r3, s1_0_2, 0x0EFDE2F5, 0x19F6FCEB, 0xFAFCFE01, 0xDBFD03FE);
	r0 = D(r0, s1_1_0, 0xFD46FEF1, 0x32EA03FC, 0x04F90303, 0x0C001002);
	r1 = D(r1, s1_1_0, 0x28490708, 0x0D080E08, 0xEAFF060A, 0xFD01E6FE);
	r2 = D(r2, s1_1_0, 0xFDFDFC00, 0x00011401, 0xFD2D0AF1, 0x40ED1308);
	r3 = D(r3, s1_1_0, 0xF3EF0E07, 0xE030FFFD, 0x11E81002, 0x37E7EF1A);
	r0 = D(r0, s1_1_1, 0xFB0F043A, 0x03DAEAD5, 0x0802100C, 0xFC03D801);
	r1 = D(r1, s1_1_1, 0xDEDACFD5, 0xF904D9FA, 0xE6400A0E, 0x0119D9F1);
	r2 = D(r2, s1_1_1, 0x111EE9FD, 0x07F11209, 0xFC0B11E9, 0x1614EDFD);
	r3 = D(r3, s1_1_1, 0x13B1421B, 0xF8DD0C38, 0x0FFF0CD0, 0x19E81012);
	r0 = D(r0, s1_1_2, 0x080AE029, 0xFBF600E9, 0xFAFBF6F4, 0xFBFC181B);
	r1 = D(r1, s1_1_2, 0xF6F4120D, 0x000AFE0C, 0x03FFD903, 0x031208FD);
	r2 = D(r2, s1_1_2, 0xFEF42948, 0x040618FE, 0x0314F581, 0xF7FC09EC);
	r3 = D(r3, s1_1_2, 0xFEF8FC9D, 0xFDEA0D09, 0x08F30506, 0xF914F00F);
	r0 = D(r0, s1_2_0, 0xF408EF0A, 0xF6081707, 0x18F10803, 0x02FBFD02);
	r1 = D(r1, s1_2_0, 0xDFD7F105, 0xFEFA0501, 0x02000508, 0x00070208);
	r2 = D(r2, s1_2_0, 0x00FB01FF, 0x01030401, 0xF4160C05, 0xF5FB0F00);
	r3 = D(r3, s1_2_0, 0xFC20F7FC, 0x1825FCFF, 0x00F4FCFD, 0xFE0B1B03);
	r0 = D(r0, s1_2_1, 0xF5F6F5FE, 0x032B10FD, 0x010D03E9, 0x091F03FD);
	r1 = D(r1, s1_2_1, 0x161F0D34, 0x0209FDFE, 0x0302F5FE, 0x080FF507);
	r2 = D(r2, s1_2_1, 0xFCE9F3FE, 0xFDFB00FC, 0xDD16FCE9, 0x020BFA1F);
	r3 = D(r3, s1_2_1, 0x0F0906F1, 0x11DAF2F6, 0x050F06FC, 0x08421913);
	r0 = D(r0, s1_2_2, 0x02F70CEF, 0x090D17A0, 0xFEF7FBFC, 0xFDFDFF0A);
	r1 = D(r1, s1_2_2, 0xFD0EF3F1, 0x010401FB, 0x03F4FDED, 0x01FFF9FA);
	r2 = D(r2, s1_2_2, 0x0B0B0705, 0x020005FE, 0x0110EB03, 0xFFFF01FD);
	r3 = D(r3, s1_2_2, 0xFC06FFEE, 0xFFF4FAFA, 0x0002F606, 0xFF08F6F7);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x07FC0001, 0xEE000703, 0x15F40B04, 0xF20F0BFD);
	r1 = D(r1, s0_0_0, 0xE7F90508, 0x03040EFB, 0x1E0B0B05, 0xD4102414);
	r2 = D(r2, s0_0_0, 0x0400FD02, 0xFFEEF201, 0x0803CFF4, 0x0002180C);
	r3 = D(r3, s0_0_0, 0x040B0909, 0x1011121C, 0xE205EEFA, 0xF60900FA);
	r0 = D(r0, s0_0_1, 0x23022001, 0xE5F6E306, 0x35FAFC04, 0x14F30001);
	r1 = D(r1, s0_0_1, 0x19FAF31F, 0x060905F5, 0x2064C8EA, 0x81123604);
	r2 = D(r2, s0_0_1, 0xFD0D0BFA, 0x11250CFB, 0x0F28F5FC, 0x521D1304);
	r3 = D(r3, s0_0_1, 0xD602F00C, 0x1924020C, 0xF301F609, 0x23130DDF);
	r0 = D(r0, s0_0_2, 0xFF02F6FA, 0xEFFE06FC, 0x06F90206, 0xF0030108);
	r1 = D(r1, s0_0_2, 0xF200F4EB, 0xFE0205FF, 0xF32EFDFE, 0x020103FA);
	r2 = D(r2, s0_0_2, 0x23FDFDF6, 0xF6F7FEF8, 0x0F06FFF9, 0xFD0AFAF8);
	r3 = D(r3, s0_0_2, 0xF6FF050D, 0xF10B000A, 0x04030008, 0xFB15F6F5);
	r0 = D(r0, s0_1_0, 0xECF6340B, 0xFB0FFF0C, 0x0AFB1402, 0xF1F11303);
	r1 = D(r1, s0_1_0, 0x04F8BF20, 0xF7F201FB, 0x0DE41404, 0xF9FCF51D);
	r2 = D(r2, s0_1_0, 0x01FBFA03, 0x00F906FF, 0x08E281F9, 0xEDEBDA0D);
	r3 = D(r3, s0_1_0, 0x02F9E0FA, 0x02FFF607, 0xF809DB07, 0xFAF107DD);
	r0 = D(r0, s0_1_1, 0xA910DFF9, 0x81131515, 0x09F70AF6, 0x272E0DF2);
	r1 = D(r1, s0_1_1, 0xF71E1B03, 0x0C1000FB, 0xE923DFF2, 0x000CD318);
	r2 = D(r2, s0_1_1, 0xF2FAEF0E, 0x04FB0B03, 0x3212BBDF, 0x01E0E0F3);
	r3 = D(r3, s0_1_1, 0x81FA090B, 0x05C5EF2C, 0x19510D0A, 0x0CCDC7DC);
	r0 = D(r0, s0_1_2, 0x0BF61A05, 0x1800F8FE, 0xFCEFFE00, 0xF113FD0A);
	r1 = D(r1, s0_1_2, 0xF602EE14, 0xFD01F7F9, 0x170410FD, 0x04FBF804);
	r2 = D(r2, s0_1_2, 0x08FF0B09, 0xF6F5FD05, 0x03DB099E, 0xF9F5FD03);
	r3 = D(r3, s0_1_2, 0xE8FAF81C, 0xF8ECF516, 0x03110106, 0xFF1119E7);
	r0 = D(r0, s0_2_0, 0x0D16EDEE, 0x08F70008, 0xF6F9FC00, 0x00011302);
	r1 = D(r1, s0_2_0, 0x1C15140D, 0x04FCFB01, 0x040BFEF6, 0xFE00F9FE);
	r2 = D(r2, s0_2_0, 0xFF00FB01, 0xFFFD0100, 0xFCF6B5FA, 0x06070D04);
	r3 = D(r3, s0_2_0, 0xFFF11B03, 0xEDFD250A, 0xFFF5F108, 0xFA06E400);
	r0 = D(r0, s0_2_1, 0xFB2002FD, 0xE6F61600, 0xF2F5F3FB, 0xFBF41100);
	r1 = D(r1, s0_2_1, 0xE7F406FA, 0xFEF300FE, 0xFB0403F9, 0xFDFD0700);
	r2 = D(r2, s0_2_1, 0x02FDF50C, 0x03030301, 0x1BEE81EE, 0x020A13F1);
	r3 = D(r3, s0_2_1, 0xF9FDF0FF, 0xF9FC1007, 0xFFF6FC00, 0xE2EFFFDE);
	r0 = D(r0, s0_2_2, 0x00F9F1FB, 0x04E80623, 0x0001010B, 0x060903FC);
	r1 = D(r1, s0_2_2, 0xFEF51A15, 0x01FB02FF, 0x0503F9FD, 0x03030304);
	r2 = D(r2, s0_2_2, 0xFAE9F6FE, 0xFE0100FF, 0x0B0DFEE6, 0x000C0D00);
	r3 = D(r3, s0_2_2, 0xFC070710, 0x02FE0819, 0x05020104, 0x08FAFEE1);
	r0 = D(r0, s1_0_0, 0xF0FD0100, 0xF801010E, 0xFDFEFE07, 0xFD07050C);
	r1 = D(r1, s1_0_0, 0x05F8DAA6, 0xF4FF0B15, 0xF602080F, 0xF407F8E6);
	r2 = D(r2, s1_0_0, 0xFF000006, 0x0205FFFA, 0x110DFC17, 0xFD070206);
	r3 = D(r3, s1_0_0, 0xFE09020E, 0xECFFFDF1, 0x08FCFF03, 0x08093510);
	r0 = D(r0, s1_0_1, 0xD9FA0104, 0x08040707, 0x0202FC07, 0xFC02FA0F);
	r1 = D(r1, s1_0_1, 0x0504DEC6, 0x09FC080F, 0x1A020C0F, 0xE9FFCDE5);
	r2 = D(r2, s1_0_1, 0xFD020414, 0x060CC1F3, 0xEE0FFA01, 0xF306DF0F);
	r3 = D(r3, s1_0_1, 0x130B1D10, 0xE4F90F03, 0xF5FFFC01, 0xF3040C4A);
	r0 = D(r0, s1_0_2, 0x0700E7FC, 0xFD0206F6, 0xFA021003, 0x0D041F00);
	r1 = D(r1, s1_0_2, 0x070B1BEF, 0xFEFEF603, 0x21080DF2, 0xE900D910);
	r2 = D(r2, s1_0_2, 0x0900FC0C, 0x020AFD09, 0xE112F006, 0xF90D0601);
	r3 = D(r3, s1_0_2, 0x070C0903, 0x020714ED, 0x030300FD, 0xF9020207);
	r0 = D(r0, s1_1_0, 0xF311FAE8, 0x0F081615, 0xE4040121, 0xF90104FE);
	r1 = D(r1, s1_1_0, 0x0B0D10B0, 0xFC04FC0B, 0x15070CFF, 0x120A1E15);
	r2 = D(r2, s1_1_0, 0x07020404, 0x0005FF02, 0xD70ADA16, 0xF9050117);
	r3 = D(r3, s1_1_0, 0xF606FA0A, 0x0B0F01CB, 0x0AFDED0E, 0x02E5E223);
	r0 = D(r0, s1_1_1, 0x1F0F35DF, 0x3B04A0F2, 0xF6FB111F, 0x09002FF6);
	r1 = D(r1, s1_1_1, 0xE41B46DA, 0x0DF53816, 0xF5F80B0A, 0x250E1F10);
	r2 = D(r2, s1_1_1, 0x08000415, 0x0D01F801, 0xE32ED827, 0xE616493A);
	r3 = D(r3, s1_1_1, 0xEC0B810F, 0xFE0BEADE, 0x07FE18F8, 0x10F62621);
	r0 = D(r0, s1_1_2, 0xEA16110F, 0x090FB90B, 0xFD0209FE, 0x02FC08FD);
	r1 = D(r1, s1_1_2, 0x191F05CC, 0xFBFC110D, 0xE4DCEC15, 0xEF0F26FF);
	r2 = D(r2, s1_1_2, 0x1601090B, 0x080B03FE, 0xD81D4025, 0x121526FF);
	r3 = D(r3, s1_1_2, 0xF20DC205, 0xFA08EED8, 0xFA06E2FE, 0x01014F22);
	r0 = D(r0, s1_2_0, 0x1605F7CD, 0x03061411, 0xF8000125, 0x17FD0803);
	r1 = D(r1, s1_2_0, 0x450D2BA1, 0xFBFA060A, 0x10FCF9FF, 0xF4010603);
	r2 = D(r2, s1_2_0, 0x01000307, 0xFC0501FE, 0xED10F304, 0x16020CEF);
	r3 = D(r3, s1_2_0, 0xEB0B140F, 0xF606F9E7, 0xFFF807FB, 0xEDEFDF15);
	r0 = D(r0, s1_2_1, 0x14C0B402, 0xE42DC5FC, 0x0F082618, 0x05061BFD);
	r1 = D(r1, s1_2_1, 0xD827F503, 0x0E031013, 0xF4FA0510, 0x0D0AFD0E);
	r2 = D(r2, s1_2_1, 0x08000F05, 0xFF0802FF, 0xFA272217, 0xFA1CD4FE);
	r3 = D(r3, s1_2_1, 0xFCE9FD1A, 0xE303DFF1, 0xE3FF14F2, 0xCD08E601);
	r0 = D(r0, s1_2_2, 0x0207EA03, 0x08270EF1, 0xFDF3ED04, 0x0FFEF50C);
	r1 = D(r1, s1_2_2, 0xF2F3E3B7, 0xFC0201FC, 0x01E623F8, 0xF8F7F901);
	r2 = D(r2, s1_2_2, 0xF2090E08, 0x0305FEFF, 0xDF3D0F22, 0x090BF004);
	r3 = D(r3, s1_2_2, 0xF707F7FB, 0xFA01F9E0, 0x03FBFAF7, 0x00F9E32B);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(1.443e-02, -1.375e-02, 9.082e-04, -1.551e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-3.972e-03, -3.414e-03, 6.150e-03, 1.047e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-5.691e-03, -5.488e-01, 2.115e-02, -6.487e-03);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-5.855e-03, 6.851e-03, 5.109e-04, -6.569e-03);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-TEST-conv3
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
	r0 = D(r0, s0_0_0, 0xF8041401, 0x28F0F3F5, 0x1302FD04, 0x120E1BFA);
	r1 = D(r1, s0_0_0, 0x05FE2704, 0x0DFA15F9, 0x0801100B, 0xFFFEFC02);
	r2 = D(r2, s0_0_0, 0x03040201, 0xFFEC090B, 0x21221D06, 0xF2FDCA03);
	r3 = D(r3, s0_0_0, 0x1AFEF8EB, 0x0700C000, 0xF9F80BF6, 0x26F0B5EE);
	r0 = D(r0, s0_0_1, 0x070FEDF7, 0x0E1C8117, 0x0308F8FF, 0x040420F1);
	r1 = D(r1, s0_0_1, 0xDF11B705, 0x19040EAA, 0xFDFF1309, 0xFCFD0407);
	r2 = D(r2, s0_0_1, 0x00F8FDF1, 0x07F0F509, 0x4E0B81D8, 0xF7EBA800);
	r3 = D(r3, s0_0_1, 0x260A2508, 0xF9DDA31E, 0x01F010EF, 0x17ECE00A);
	r0 = D(r0, s0_0_2, 0xFDE6E6EF, 0x0EE0F5F8, 0x03FFE9FD, 0x1E000BF0);
	r1 = D(r1, s0_0_2, 0xE9ECC7F1, 0x0FF0E7FC, 0x04DE0016, 0xFBFDFF02);
	r2 = D(r2, s0_0_2, 0x000700F9, 0xFAF30C08, 0x2FCCDEE3, 0xF3F908FE);
	r3 = D(r3, s0_0_2, 0x07FCECF8, 0x08D1C51F, 0xF30D02FD, 0x14000312);
	r0 = D(r0, s0_1_0, 0x12020B06, 0xF502C9EF, 0xF906F7F6, 0xDBF9261D);
	r1 = D(r1, s0_1_0, 0xF3DFE90A, 0xE40F03EF, 0x030D39E9, 0xFB00FE00);
	r2 = D(r2, s0_1_0, 0x07FD03FF, 0x12EE1B08, 0x1D0514FF, 0xE70CEEFE);
	r3 = D(r3, s0_1_0, 0xD8F6F400, 0x2F17C707, 0x14000AF5, 0xFDF8C2FB);
	r0 = D(r0, s0_1_1, 0x1709DF02, 0x1DF0C40B, 0x250AEF02, 0x0604BF13);
	r1 = D(r1, s0_1_1, 0xC4D1CF0D, 0x27252AD8, 0xC8D84098, 0x0EF00400);
	r2 = D(r2, s0_1_1, 0xF5160502, 0x26B7EE16, 0xED23DA13, 0xFA10C111);
	r3 = D(r3, s0_1_1, 0x1603F2F9, 0x2121EE34, 0xEF0AE624, 0x1A19E3F3);
	r0 = D(r0, s0_1_2, 0x14D6E310, 0x32D30914, 0x13EACA08, 0xF3F507F6);
	r1 = D(r1, s0_1_2, 0x0EF6B20B, 0x0207E9FB, 0xF723040A, 0xFBFC0201);
	r2 = D(r2, s0_1_2, 0x05060100, 0x1CEA0516, 0xCCEEC8EC, 0x20C8FB24);
	r3 = D(r3, s0_1_2, 0x08FCD723, 0x12EDB810, 0x11D0ED14, 0xF3200BD6);
	r0 = D(r0, s0_2_0, 0x09000903, 0xFBFDE400, 0xF4FAFF03, 0x0C00FB03);
	r1 = D(r1, s0_2_0, 0x0416F400, 0x07F708FE, 0xFBFF11FD, 0x040000FE);
	r2 = D(r2, s0_2_0, 0x0000FF01, 0xFB00F404, 0x13F10607, 0x0AFD0CFC);
	r3 = D(r3, s0_2_0, 0x0AFEF2FD, 0x13FA12FD, 0xE702E7FC, 0xF700F6F9);
	r0 = D(r0, s0_2_1, 0x02FE09FE, 0x0C1618FC, 0x28080F07, 0xF1FDA40E);
	r1 = D(r1, s0_2_1, 0x3BFBFBFF, 0x05F70CFC, 0xDB042100, 0xF7050100);
	r2 = D(r2, s0_2_1, 0xFDF90201, 0x0FF90A0B, 0xEDF32007, 0x14090407);
	r3 = D(r3, s0_2_1, 0x0D070600, 0x180A0101, 0x190AFF0A, 0x05EE04FA);
	r0 = D(r0, s0_2_2, 0x1500DD05, 0xFDF70803, 0x1CF3E903, 0xEEFEF5FC);
	r1 = D(r1, s0_2_2, 0xE0F60B07, 0x02FD04FC, 0xF9F809FC, 0x04000200);
	r2 = D(r2, s0_2_2, 0xFD000100, 0x0E03FC01, 0xF60E0201, 0x0A04FE01);
	r3 = D(r3, s0_2_2, 0xFB030301, 0x00FB0705, 0xF417D609, 0xFE0408FF);
	r0 = D(r0, s1_0_0, 0xFD01FF05, 0xFC00F503, 0x0203F7FA, 0x0503F9FC);
	r1 = D(r1, s1_0_0, 0xF8010304, 0x0401FBF8, 0x08FEFBF3, 0x0202FF01);
	r2 = D(r2, s1_0_0, 0xFFFEFFFF, 0x00010AF6, 0x2B1CDE05, 0xFD000AF6);
	r3 = D(r3, s1_0_0, 0xF401FA0D, 0xFFFCF503, 0xFD000501, 0x0104E704);
	r0 = D(r0, s1_0_1, 0x0902F701, 0x09F6FFFF, 0x05FFFDFD, 0x0B00F3F9);
	r1 = D(r1, s1_0_1, 0xFD04F81B, 0x0BFDF2F1, 0x0C0306F5, 0xFF00FFFF);
	r2 = D(r2, s1_0_1, 0x0100FF03, 0xF7FE04D6, 0x1BEEB8C6, 0xF2FE0E00);
	r3 = D(r3, s1_0_1, 0x0F01F9FB, 0x0BF601DB, 0xF4FF080A, 0x04FD0304);
	r0 = D(r0, s1_0_2, 0x00F8F8F4, 0x070302E9, 0x00FFFD02, 0xFE07F026);
	r1 = D(r1, s1_0_2, 0x0AFE00FD, 0x0709F80D, 0x02FEF4FA, 0x0100FCFE);
	r2 = D(r2, s1_0_2, 0xFF0004FC, 0xFEFC05D1, 0x0901F916, 0xFFFE08D1);
	r3 = D(r3, s1_0_2, 0x10FFF30C, 0x0B06DF0A, 0x02040BF8, 0xFB09FD1B);
	r0 = D(r0, s1_1_0, 0xF807F309, 0x0702FFF5, 0x0004FA02, 0xFBFCF915);
	r1 = D(r1, s1_1_0, 0xF3EFF70C, 0xF3FCFC04, 0xF5F80019, 0x04020202);
	r2 = D(r2, s1_1_0, 0xFDFDFBFC, 0xFB0212F1, 0x0AF00B0E, 0x051002E0);
	r3 = D(r3, s1_1_0, 0x130C0B09, 0x1223DEFA, 0xFBFC03F3, 0x10130606);
	r0 = D(r0, s1_1_1, 0x23F5F7EB, 0xDBCFD91E, 0xFE07DA0E, 0xF110F1D5);
	r1 = D(r1, s1_1_1, 0x00EFE303, 0x0E01C5E1, 0x260D03DB, 0x03072C00);
	r2 = D(r2, s1_1_1, 0x04FEDBF6, 0xE7F91AC1, 0xEFD50494, 0x12F30B02);
	r3 = D(r3, s1_1_1, 0xD1E6E01A, 0x2003EBF8, 0x1A0EFFEF, 0xEDF1F72B);
	r0 = D(r0, s1_1_2, 0xF401F40B, 0x1BFBFA06, 0xF6F628FC, 0xF8ED0701);
	r1 = D(r1, s1_1_2, 0x1FE71518, 0x00F83005, 0xF9F6F8F1, 0x0204F0FD);
	r2 = D(r2, s1_1_2, 0xFCFE1508, 0xFF06D9D6, 0x20C92FDB, 0x0D07D7E1);
	r3 = D(r3, s1_1_2, 0x02E4232B, 0xDFFE340B, 0x09F6DD11, 0xD6031323);
	r0 = D(r0, s1_2_0, 0xFD03F606, 0x1A081208, 0x030600EF, 0x04FD18FE);
	r1 = D(r1, s1_2_0, 0x03FB0E12, 0x0AFFFA01, 0x0EF80CF6, 0xFF03FA00);
	r2 = D(r2, s1_2_0, 0x02030301, 0x070FFED3, 0xF8CEECCA, 0xF801F5FA);
	r3 = D(r3, s1_2_0, 0x06EF100F, 0xFDD7DB03, 0x0810FDF0, 0x01E71400);
	r0 = D(r0, s1_2_1, 0xFFF7F1FB, 0xDCFD0522, 0x04DCF6F4, 0x1DCC44ED);
	r1 = D(r1, s1_2_1, 0x2CD0120E, 0x22D9DFFD, 0x3E1C82D7, 0xFF0AEFFC);
	r2 = D(r2, s1_2_1, 0x04F91403, 0xFC0BEDC4, 0xF8C7EFAF, 0x2AECFFE7);
	r3 = D(r3, s1_2_1, 0xF5F9F211, 0x0EC3E003, 0xEADDD8FD, 0xE4FBFF16);
	r0 = D(r0, s1_2_2, 0x02FC1BFB, 0xDBF02917, 0xF4032F03, 0x0CFB0AF2);
	r1 = D(r1, s1_2_2, 0x1ADA07F8, 0x02FD09FC, 0x2803D503, 0x0004F600);
	r2 = D(r2, s1_2_2, 0x02FC0302, 0xECFF00DB, 0x2FFB1315, 0xF2E421D8);
	r3 = D(r3, s1_2_2, 0xF2031405, 0x06FB0AF3, 0xFD02FEE0, 0x1000ED00);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFFFFFA05, 0x060CF9EA, 0x04EA0AFA, 0xF2FA0EF4);
	r1 = D(r1, s0_0_0, 0xF80B0F02, 0x06FD0DF5, 0x0CFB1E03, 0x0002F704);
	r2 = D(r2, s0_0_0, 0x01FF08FE, 0x0C14F20C, 0xE2AE2F35, 0x011B0FFF);
	r3 = D(r3, s0_0_0, 0xF6FA02EA, 0x04FA34E8, 0x040C080A, 0x0910F8EB);
	r0 = D(r0, s0_0_1, 0xF3F1FF0D, 0x11CD3E0A, 0x000210F4, 0x06180E09);
	r1 = D(r1, s0_0_1, 0x00F5EDE7, 0x0BF917F5, 0xFAFA2505, 0x02FEF704);
	r2 = D(r2, s0_0_1, 0x02FDFFF7, 0x09FA0A08, 0x1F09220C, 0x10E5161D);
	r3 = D(r3, s0_0_1, 0xF72DF6F9, 0x38F720FC, 0x08000B00, 0x25FB20F5);
	r0 = D(r0, s0_0_2, 0x0702EB00, 0x0FD615F8, 0x0AEFF505, 0x00FEFFF8);
	r1 = D(r1, s0_0_2, 0x08114403, 0x11000301, 0x16010006, 0xFF01FB00);
	r2 = D(r2, s0_0_2, 0xFF000DFF, 0x03060DFC, 0x121939FE, 0xFC041AFB);
	r3 = D(r3, s0_0_2, 0x090D0C04, 0x1AF82306, 0xFCF903FA, 0xFA07E6FE);
	r0 = D(r0, s0_1_0, 0xF904E3F7, 0x07B82B1F, 0xFD022206, 0xFC11F916);
	r1 = D(r1, s0_1_0, 0x1BFDAEF4, 0x07081DFD, 0x0E1D09E0, 0x05FE16D4);
	r2 = D(r2, s0_1_0, 0xFE013E28, 0x1525FEF0, 0xF8410CCF, 0x0BE81713);
	r3 = D(r3, s0_1_0, 0xF7EE1B08, 0xF5F240EC, 0x041CF2FE, 0x02FA5213);
	r0 = D(r0, s0_1_1, 0xFAEB0022, 0x24E6D203, 0x02EAF900, 0xFAFC31FC);
	r1 = D(r1, s0_1_1, 0x39F851CE, 0xEB0325DE, 0xEC3104DB, 0x0201FD11);
	r2 = D(r2, s0_1_1, 0xFEFE5BE9, 0x2BF71B03, 0x251C0AAF, 0x02D9780F);
	r3 = D(r3, s0_1_1, 0xE3EEF0C8, 0x12ECE7F2, 0x05E5FC0B, 0xEF029EE4);
	r0 = D(r0, s0_1_2, 0x15F04103, 0xF2020FFE, 0x10EC16FA, 0x0A081EFE);
	r1 = D(r1, s0_1_2, 0x33F042F5, 0x1E030400, 0x14E10F00, 0xF5010F02);
	r2 = D(r2, s0_1_2, 0x07FF33FE, 0x051BF607, 0x23060C01, 0x100FE8FD);
	r3 = D(r3, s0_1_2, 0x29F9F5F8, 0x17E723F8, 0xF227E004, 0x080616FD);
	r0 = D(r0, s0_2_0, 0xFD052800, 0xE8F7ECEB, 0xFBF932FA, 0x030A51DE);
	r1 = D(r1, s0_2_0, 0x15F54DEF, 0xED021FFA, 0x0BF22E0D, 0x05020C08);
	r2 = D(r2, s0_2_0, 0xFBFF3EF9, 0x180E3C0A, 0x0B0B1607, 0xFAFFE3F6);
	r3 = D(r3, s0_2_0, 0xFF02E8F1, 0x0E0143FB, 0x09FE2507, 0x08F581EE);
	r0 = D(r0, s0_2_1, 0x05FEEF0F, 0x22EB8B0E, 0x06FC1AFB, 0xF2EC4BF4);
	r1 = D(r1, s0_2_1, 0xF00C81E0, 0xEC077FFB, 0x0F083120, 0x07FF7F08);
	r2 = D(r2, s0_2_1, 0xF5047FFB, 0x25F4900B, 0x06EFC2FA, 0x062481FF);
	r3 = D(r3, s0_2_1, 0x1C0059FD, 0x23084FF5, 0x0E037FED, 0xE60E7FF8);
	r0 = D(r0, s0_2_2, 0x01F64E04, 0xFA0B51FD, 0x0907A3F5, 0x0E00DE07);
	r1 = D(r1, s0_2_2, 0x07F5D602, 0xFF04CC05, 0xDCFEBA0C, 0x02FF0F00);
	r2 = D(r2, s0_2_2, 0xFD0036FE, 0x150B1C00, 0xDCDFF405, 0x11F44401);
	r3 = D(r3, s0_2_2, 0x08F9F109, 0x0C0B290C, 0x2EFD61F9, 0x0C05FA06);
	r0 = D(r0, s1_0_0, 0x0201FC01, 0xECE3FB0A, 0x01F2FA02, 0xFC0A02FF);
	r1 = D(r1, s1_0_0, 0xEE1006F5, 0x00FAF90F, 0xF5F6FE01, 0xFD000301);
	r2 = D(r2, s1_0_0, 0x00FE0000, 0xFBE4FF0B, 0xF8E8F0FA, 0x0300010C);
	r3 = D(r3, s1_0_0, 0xFAEA12FD, 0x08E801FF, 0xFBFF0003, 0xEFF2040C);
	r0 = D(r0, s1_0_1, 0x0C0205F7, 0xD31102ED, 0xFB08F9FF, 0x0D0AFBF2);
	r1 = D(r1, s1_0_1, 0x01FFF306, 0x0101FBFF, 0x01F3F912, 0x00FBFF03);
	r2 = D(r2, s1_0_1, 0x03030401, 0xF9F2EB15, 0x0C10C8E1, 0x03E80520);
	r3 = D(r3, s1_0_1, 0xA42C11F4, 0xF1FC07EE, 0xFCEC06FF, 0xA402F221);
	r0 = D(r0, s1_0_2, 0xFB090604, 0x01FE0B1C, 0x08F5F90E, 0xFFE8F201);
	r1 = D(r1, s1_0_2, 0x14E51D18, 0xF5EFF413, 0xF1F1FDEC, 0x00000102);
	r2 = D(r2, s1_0_2, 0x00070100, 0xFB0CFDF9, 0xFAF2F724, 0xF815FEEC);
	r3 = D(r3, s1_0_2, 0xF307FAF9, 0x01DFE222, 0x030FF909, 0xF2E70312);
	r0 = D(r0, s1_1_0, 0xFC020101, 0x0F1CF105, 0x0813020F, 0xF102FC08);
	r1 = D(r1, s1_1_0, 0xD6E0FA06, 0x01180D05, 0xF2F136FF, 0x00020200);
	r2 = D(r2, s1_1_0, 0x02FCFE01, 0x03DDF20B, 0xF2EA14F4, 0x071FE8EA);
	r3 = D(r3, s1_1_0, 0x191901F8, 0x0416FD04, 0x10EA06EB, 0x10FE07FE);
	r0 = D(r0, s1_1_1, 0x0B20DFE8, 0xD1A50F9A, 0x07E0F7F9, 0x1BEE011A);
	r1 = D(r1, s1_1_1, 0xA12905A0, 0x10F20841, 0x33092728, 0xFA2803EC);
	r2 = D(r2, s1_1_1, 0x01ED0904, 0x03BCE0FD, 0x01350381, 0xFBAEEECE);
	r3 = D(r3, s1_1_1, 0xE3D92606, 0x11BC1BC0, 0x0C37BE81, 0xE7C42E24);
	r0 = D(r0, s1_1_2, 0xFBEAF715, 0x24D0E745, 0xEC0CF7D7, 0xEB1012D7);
	r1 = D(r1, s1_1_2, 0xBB192181, 0xF4FE1908, 0x0E0015E9, 0x05F802FE);
	r2 = D(r2, s1_1_2, 0xFF08FDFF, 0x14DDE128, 0xFB2E38CC, 0x07E5EE2F);
	r3 = D(r3, s1_1_2, 0xF4E01C0F, 0xF5FA1007, 0xF1F9F5CD, 0xE21808ED);
	r0 = D(r0, s1_2_0, 0xFD06F909, 0x03F5F8FE, 0x050FFB02, 0xEFEF04F3);
	r1 = D(r1, s1_2_0, 0xFEF112F3, 0x0600FC00, 0xF2F6EA0C, 0x01040002);
	r2 = D(r2, s1_2_0, 0xFF00FFFD, 0x0E0CF7FE, 0xFB1300FB, 0xF5EFFC16);
	r3 = D(r3, s1_2_0, 0xECFAFD0E, 0xF406FA25, 0x000FFC07, 0xE901FC14);
	r0 = D(r0, s1_2_1, 0x0313F6EC, 0xCDCF1538, 0xF5D7190E, 0x10EF06E0);
	r1 = D(r1, s1_2_1, 0x1DD82AF2, 0x0EF9FBFD, 0xF34FD824, 0x01000200);
	r2 = D(r2, s1_2_1, 0x00FF0301, 0x02EDDD19, 0x19FAD024, 0x09FC21DD);
	r3 = D(r3, s1_2_1, 0xDC060805, 0xFB010302, 0xF1CC25E6, 0xEA060A00);
	r0 = D(r0, s1_2_2, 0x03DA0608, 0xF42202E3, 0x08FCFBB9, 0xE9070A05);
	r1 = D(r1, s1_2_2, 0xF409EC42, 0xFAFBFD0E, 0xF9EBF30D, 0x0000FA01);
	r2 = D(r2, s1_2_2, 0x02FF03FF, 0x07EAF117, 0xD9E0FF19, 0x0803FC10);
	r3 = D(r3, s1_2_2, 0xF30E000F, 0xFBFFFF2C, 0x061AFA14, 0xFBFEFB18);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-4.067e-03, 2.985e-03, 1.321e-03, -1.197e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.441e-02, -1.127e-02, -1.898e-02, -1.680e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-2.157e-03, 2.197e-02, -2.360e-02, -3.252e-03);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-1.979e-03, -1.285e-02, -4.830e-03, -4.036e-03);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-TEST-conv4
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
	r0 = D(r0, s0_0_0, 0x02000103, 0x00FD00FC, 0xF30A00FF, 0xF4090101);
	r1 = D(r1, s0_0_0, 0x000B00F7, 0x0AEEFCFA, 0x11F007F7, 0xFF09E1ED);
	r2 = D(r2, s0_0_0, 0xFCFCFBF7, 0xF608FF09, 0xFFFDF0E4, 0x00030105);
	r3 = D(r3, s0_0_0, 0xFE090008, 0x0CC6071B, 0xD70E020C, 0x04100709);
	r0 = D(r0, s0_0_1, 0x0E0501FC, 0xFE1801FA, 0x080E010F, 0x10FF0015);
	r1 = D(r1, s0_0_1, 0x07EFFA0E, 0x26F5F5EF, 0x1DE0E2F4, 0x17DE16D7);
	r2 = D(r2, s0_0_1, 0xFFF00307, 0x01181A04, 0x13D8DBED, 0x0103FEFE);
	r3 = D(r3, s0_0_1, 0x00FAFC0A, 0x2A1F1196, 0x391C0904, 0x08ED08FA);
	r0 = D(r0, s0_0_2, 0x04000100, 0xFBFD05FF, 0xF9F50BFD, 0xEB001301);
	r1 = D(r1, s0_0_2, 0xFE030006, 0x04F205FE, 0x07F600FE, 0x02F8E703);
	r2 = D(r2, s0_0_2, 0xFF02F705, 0xF9FCF603, 0x0F010600, 0x05FF0200);
	r3 = D(r3, s0_0_2, 0xFDFE0003, 0x1DF5EBF0, 0xEE0213F2, 0xFC0702F9);
	r0 = D(r0, s0_1_0, 0x06E1FA45, 0x02FE01FF, 0xF4E40504, 0xFFDE0A04);
	r1 = D(r1, s0_1_0, 0x03DFE9E8, 0xFA1FF9DD, 0xFBF5E9FC, 0xF6D71004);
	r2 = D(r2, s0_1_0, 0xFE120221, 0xFB36171C, 0xFABEF112, 0x0102FC18);
	r3 = D(r3, s0_1_0, 0x00E2FE00, 0x0508F803, 0xFD0AFE0B, 0x0138F442);
	r0 = D(r0, s0_1_1, 0xF1080EE9, 0xFC23030D, 0x1C35D72E, 0x0235F020);
	r1 = D(r1, s0_1_1, 0x2EF91AB3, 0xE3E80B03, 0x190E17F2, 0xF6F0CBFF);
	r2 = D(r2, s0_1_1, 0xF41B10E7, 0xCE232EE8, 0x1217FFE8, 0x0A0C0EFB);
	r3 = D(r3, s0_1_1, 0x121810E9, 0x0394A816, 0x1717EC16, 0xF5E30021);
	r0 = D(r0, s0_1_2, 0x00FEF802, 0x0A0806F6, 0xEE020C01, 0xEBF6EEFC);
	r1 = D(r1, s0_1_2, 0x0EEAE8FD, 0xF10610FF, 0xF4FFF5FF, 0xFAFD0FF7);
	r2 = D(r2, s0_1_2, 0xF4F7FF01, 0x0BF8E60D, 0xF9F5F5F5, 0x01FD0001);
	r3 = D(r3, s0_1_2, 0x08FAF006, 0xF1E2DFEE, 0xC2FA08F8, 0xFB0603FB);
	r0 = D(r0, s0_2_0, 0x0202FA04, 0xFF0000FF, 0xFD0413FD, 0x000802FC);
	r1 = D(r1, s0_2_0, 0xFDE30108, 0x00F20707, 0xFAFA0803, 0x0101EB01);
	r2 = D(r2, s0_2_0, 0xF9EAF1F6, 0x06FE0214, 0xFF0713FF, 0xFFFEFF01);
	r3 = D(r3, s0_2_0, 0x05F0F8F1, 0xFEF7D3F3, 0xFD0D0EF6, 0x00000804);
	r0 = D(r0, s0_2_1, 0x02010D00, 0x00FFFEFE, 0x08071D15, 0xFAEF0900);
	r1 = D(r1, s0_2_1, 0x0AF9DAF6, 0x07070CF5, 0xF8FAEC00, 0xFA040A02);
	r2 = D(r2, s0_2_1, 0xF6112403, 0xEC011B05, 0xFBFDDCFA, 0xFEFF0105);
	r3 = D(r3, s0_2_1, 0x07FFE2F0, 0x060010F9, 0x17181FFA, 0xF8FD03FA);
	r0 = D(r0, s0_2_2, 0x03FF0200, 0x0102FEFF, 0xECF9F3FD, 0x04040602);
	r1 = D(r1, s0_2_2, 0x0300FDFA, 0x0703FAFD, 0xFAFB0AFE, 0xFF01F802);
	r2 = D(r2, s0_2_2, 0xF7FD05F9, 0x01FA0403, 0xF4F60504, 0xFEFF02FF);
	r3 = D(r3, s0_2_2, 0xFFF60FF8, 0x010017FE, 0xF2FB0300, 0x0203FAFC);
	r0 = D(r0, s1_0_0, 0x0002FEFC, 0x000001FF, 0x02030009, 0xFBFC0206);
	r1 = D(r1, s1_0_0, 0x020109F7, 0x01FF0702, 0x01F805F0, 0x01DDE00C);
	r2 = D(r2, s1_0_0, 0xFEFF0007, 0x00F50DF9, 0x10ED080A, 0x00000100);
	r3 = D(r3, s1_0_0, 0xFD000202, 0xFEF9F8EF, 0xFCE914F8, 0xFFFEFDFE);
	r0 = D(r0, s1_0_1, 0x03FCFE04, 0x01FF00FC, 0xFBF40BE4, 0x06F9F2F0);
	r1 = D(r1, s1_0_1, 0xFBFC001C, 0x12F5F212, 0x02E0E516, 0x25E5100A);
	r2 = D(r2, s1_0_1, 0x03020BF7, 0x04EDF400, 0x0AD80F03, 0x06FE0005);
	r3 = D(r3, s1_0_1, 0xFCFF0106, 0x0DC212E4, 0x09BBD419, 0xFDFF00FE);
	r0 = D(r0, s1_0_2, 0x0300FF02, 0xFCFDFFFF, 0x00EB02FF, 0x01B6EDF6);
	r1 = D(r1, s1_0_2, 0xFEFE0F0E, 0x050100FE, 0x07F70104, 0xEEDAEC07);
	r2 = D(r2, s1_0_2, 0x03F70109, 0xF907F7FA, 0xF7D5070B, 0x03FFFF01);
	r3 = D(r3, s1_0_2, 0xFEF80505, 0x0DF90CD8, 0x1AD305FA, 0x08FC0101);
	r0 = D(r0, s1_1_0, 0x0DFFEC2C, 0x0000FC00, 0xF9FB0EF3, 0xF70413FD);
	r1 = D(r1, s1_1_0, 0xF7EADD00, 0xF503F4FC, 0x1804E002, 0xE3003020);
	r2 = D(r2, s1_1_0, 0x00FEF4D7, 0x000614F2, 0xF5051FF6, 0x01FF0205);
	r3 = D(r3, s1_1_0, 0xFE050305, 0xF9EA0133, 0xE3F61FFA, 0x0AEE0F06);
	r0 = D(r0, s1_1_1, 0x42F00901, 0x01FF06FF, 0x1EEE9A24, 0x26F8BFF9);
	r1 = D(r1, s1_1_1, 0xD4F20009, 0xC7F719F5, 0x43F388DD, 0xD6F0EFF5);
	r2 = D(r2, s1_1_1, 0x16A3D822, 0x2FC2ABE4, 0xFDEC95CE, 0xE6FFFB0E);
	r3 = D(r3, s1_1_1, 0xF8FDFFEB, 0xBC838117, 0xA2D19CD8, 0xCCFFE7EA);
	r0 = D(r0, s1_1_2, 0xFB02FF01, 0x5D00EFFA, 0x018ED2DC, 0x03D0E5FD);
	r1 = D(r1, s1_1_2, 0xE5E3F000, 0xF301FAFD, 0xFF0301FC, 0x10020AFB);
	r2 = D(r2, s1_1_2, 0xFCF500F5, 0xE7F10104, 0x1CF8E1F1, 0xFF00FE00);
	r3 = D(r3, s1_1_2, 0xF808F600, 0x02A6F32C, 0x18BDEEF1, 0x17FD01F9);
	r0 = D(r0, s1_2_0, 0x0D00FCFF, 0x01FF0000, 0xFA020E0D, 0xFD01FC09);
	r1 = D(r1, s1_2_0, 0x03061011, 0x060000ED, 0xF1FE040F, 0x0500F7F6);
	r2 = D(r2, s1_2_0, 0xFF071F12, 0xF6FB04F8, 0xF8030321, 0xFF000202);
	r3 = D(r3, s1_2_0, 0x06F9FCFC, 0xF90810E8, 0x0B06FAFA, 0xFCFC07FE);
	r0 = D(r0, s1_2_1, 0x1DFFF701, 0xFF000201, 0x10FBF8EC, 0x03FC10F5);
	r1 = D(r1, s1_2_1, 0x2BF8C4E6, 0x1006E9F9, 0xEBFB0AFF, 0x0E07F504);
	r2 = D(r2, s1_2_1, 0x06B59D0D, 0x0FE8D6EE, 0xE7F2090C, 0xFDFF0201);
	r3 = D(r3, s1_2_1, 0x3BB8B33F, 0x09F51601, 0x06F80BFD, 0xF9FFFFF9);
	r0 = D(r0, s1_2_2, 0xFD010102, 0x07000201, 0xFAE8FAFF, 0xF6FEFC05);
	r1 = D(r1, s1_2_2, 0x0A0DE9F9, 0x0CFFFCFF, 0x010206FD, 0x0100FA02);
	r2 = D(r2, s1_2_2, 0x01DFF0FD, 0xE807FBFC, 0xF0F22405, 0x010001FE);
	r3 = D(r3, s1_2_2, 0xFFD5E7F9, 0x0AFD1CFF, 0x05010CFF, 0x0F000101);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x05FF0004, 0x02FFFF00, 0xFDF3F5FD, 0xF3F402FD);
	r1 = D(r1, s0_0_0, 0x0AEB1DF5, 0x0A01FA04, 0x15000606, 0xF0F817EE);
	r2 = D(r2, s0_0_0, 0xF5090DFC, 0xED1B21FE, 0xFCF517F6, 0xFEFF0100);
	r3 = D(r3, s0_0_0, 0xFEFB0AFE, 0xED26CE01, 0x06F0BF08, 0x05FFFD00);
	r0 = D(r0, s0_0_1, 0xFA00FFFE, 0xFD0203FB, 0x000903FB, 0x180A190D);
	r1 = D(r1, s0_0_1, 0x19F8E3FD, 0x0BFDF5FF, 0xFA05DA0F, 0x1CE8EDFF);
	r2 = D(r2, s0_0_1, 0x01F90DFF, 0xFFCDD2F4, 0x04F8E5F6, 0x02FFFEFD);
	r3 = D(r3, s0_0_1, 0x04FDF9FB, 0xCFFF0AD6, 0x031637E9, 0xFBFF0709);
	r0 = D(r0, s0_0_2, 0x0001FFFC, 0x02010104, 0xFAFB0905, 0xEAFC0600);
	r1 = D(r1, s0_0_2, 0xF9F6FFE7, 0x0BFEFC04, 0x01FE0000, 0xECF5FC06);
	r2 = D(r2, s0_0_2, 0xF7FFFBF9, 0xFC030501, 0xF0010002, 0x02FF0002);
	r3 = D(r3, s0_0_2, 0xFDFF02FD, 0x0B05F0EE, 0xFFFCF7FD, 0x01FD01F8);
	r0 = D(r0, s0_1_0, 0xF801060A, 0xFE020001, 0x0DD9FA04, 0x0AE50701);
	r1 = D(r1, s0_1_0, 0xFD14FEF6, 0xF00A0307, 0xDD18F5EB, 0xF7020918);
	r2 = D(r2, s0_1_0, 0xF7141EF7, 0xE812E60D, 0xF930E806, 0xFD04FE01);
	r3 = D(r3, s0_1_0, 0x04F3F703, 0x1FF10F04, 0x03CE1B0B, 0x030502FD);
	r0 = D(r0, s0_1_1, 0x24F8F2EA, 0x0905FF02, 0xF71A36D0, 0xD61007D4);
	r1 = D(r1, s0_1_1, 0xF220E027, 0x1F071854, 0x020616CC, 0x0C0BF62B);
	r2 = D(r2, s0_1_1, 0x0EEDD318, 0x34BBF0C1, 0xF72B05CA, 0x0B010150);
	r3 = D(r3, s0_1_1, 0xE0F4070C, 0x131307D7, 0xE2261DE4, 0xD401FC52);
	r0 = D(r0, s0_1_2, 0xFF000204, 0x0405FFDF, 0xE7FAE11D, 0x1DF3FC1F);
	r1 = D(r1, s0_1_2, 0xFDFE151D, 0x0A06FC22, 0xFF0E020E, 0x150A0EF8);
	r2 = D(r2, s0_1_2, 0xFFFB0BFF, 0xEAFB210F, 0x171313ED, 0x03FF0009);
	r3 = D(r3, s0_1_2, 0xFAF80C16, 0x30ECD214, 0x06F1C509, 0x06FDF8E9);
	r0 = D(r0, s0_2_0, 0xFDFFFBFF, 0x0000FFFF, 0xFFF20B06, 0xFFFEFD05);
	r1 = D(r1, s0_2_0, 0x010EFB00, 0x01F201F3, 0x00E7040E, 0xFDFBFBFD);
	r2 = D(r2, s0_2_0, 0xFAF8DD06, 0xF504FEFF, 0xFFF7FA03, 0xFF00FF01);
	r3 = D(r3, s0_2_0, 0x00110107, 0xF71203F6, 0x03F501F3, 0xFF0B0008);
	r0 = D(r0, s0_2_1, 0x02FF04EB, 0xFE01FFFD, 0xE714E0EC, 0x04FFF7FC);
	r1 = D(r1, s0_2_1, 0xF5110DEA, 0xFBF2FCEB, 0x05E6FD1C, 0xF90EFB09);
	r2 = D(r2, s0_2_1, 0x2BEF38E0, 0x21E419E4, 0x02D7191D, 0x0402010C);
	r3 = D(r3, s0_2_1, 0x19DF0ED2, 0xF0FAD8FA, 0xFC1FEBEC, 0x02FFFB17);
	r0 = D(r0, s0_2_2, 0xFD010205, 0x040000F4, 0x0AFD100C, 0xF2040D00);
	r1 = D(r1, s0_2_2, 0x010B0607, 0xFE000DED, 0x05F0FB01, 0xFAFB11FF);
	r2 = D(r2, s0_2_2, 0x05FBFA17, 0xF20BE50E, 0x0AE4F606, 0x01FFFE04);
	r3 = D(r3, s0_2_2, 0x0ADDEB05, 0xED291702, 0x05F31809, 0xFEFE06F0);
	r0 = D(r0, s1_0_0, 0xFFF7FF00, 0x00010101, 0x050F04F9, 0x080408F3);
	r1 = D(r1, s1_0_0, 0xFC07FB0B, 0xFD0F0102, 0xF723000A, 0x190BFAEF);
	r2 = D(r2, s1_0_0, 0x09FA02FA, 0xFFD1F703, 0x011DFD05, 0x0003FFFF);
	r3 = D(r3, s1_0_0, 0xFF03FC00, 0xFB0D0904, 0xFEF702FD, 0x03FEF9FE);
	r0 = D(r0, s1_0_1, 0xFFFFFFFF, 0x0106FE00, 0xF4D1F516, 0xF3030616);
	r1 = D(r1, s1_0_1, 0x1304FBF8, 0xFF220201, 0x061E0CF6, 0xD71BFE18);
	r2 = D(r2, s1_0_1, 0xF4F5FE0C, 0xE8070207, 0x022B01F5, 0xFF0CFFFF);
	r3 = D(r3, s1_0_1, 0x07FEFDFA, 0xFFFCF4FD, 0x18C4FFEE, 0xFDEFFF04);
	r0 = D(r0, s1_0_2, 0x03FF0202, 0x010B00FE, 0xF2FB05FB, 0xF6E50606);
	r1 = D(r1, s1_0_2, 0x05FAF4FB, 0xF8050402, 0x01FB0506, 0x20020806);
	r2 = D(r2, s1_0_2, 0x0AFEFFFB, 0x19FE0600, 0x0C04FADF, 0xFF000000);
	r3 = D(r3, s1_0_2, 0x02FDFEFD, 0xDD05162E, 0x05F70602, 0xFFFF00FC);
	r0 = D(r0, s1_1_0, 0x01150C05, 0xFE020002, 0xFDE9FBFC, 0xF8FBF810);
	r1 = D(r1, s1_1_0, 0x011F03F0, 0x040E07FB, 0xF6EA20F9, 0x01140B0F);
	r2 = D(r2, s1_1_0, 0xF9F30210, 0xFB000910, 0xE2FF1118, 0xFF010201);
	r3 = D(r3, s1_1_0, 0x050802F8, 0x2A0D14C9, 0xE9BA0422, 0xF1F80409);
	r0 = D(r0, s1_1_1, 0xEF040501, 0xF9060304, 0x1FF71DFB, 0xE5DB21FE);
	r1 = D(r1, s1_1_1, 0xD8250D19, 0x02002DEF, 0xF6EE361B, 0x2FF61DD7);
	r2 = D(r2, s1_1_1, 0xE2FD01E7, 0xAAD4251D, 0x94FE3322, 0x00FE1606);
	r3 = D(r3, s1_1_1, 0xFE18FC01, 0xEB1662C1, 0xF90B37C7, 0x1A00F3F5);
	r0 = D(r0, s1_1_2, 0x0400FF01, 0x08060B03, 0x14F4080A, 0x270202FD);
	r1 = D(r1, s1_1_2, 0x3BFBF803, 0xFBFCF9ED, 0xFA0005F8, 0x01FA0D00);
	r2 = D(r2, s1_1_2, 0x17FC100F, 0xFE01FC00, 0xF808231C, 0x0301FE00);
	r3 = D(r3, s1_1_2, 0x0CFF0410, 0xEEF50CE1, 0x05F90B0B, 0x0BFD0108);
	r0 = D(r0, s1_2_0, 0xFEF90FF9, 0x010000FF, 0xF3FA0716, 0xF8FF0801);
	r1 = D(r1, s1_2_0, 0x13FF050B, 0xFBF8FAFE, 0x1207FF00, 0xFDFC0703);
	r2 = D(r2, s1_2_0, 0x15FCFBF1, 0xFFFB06E8, 0x37060FDC, 0x030000FF);
	r3 = D(r3, s1_2_0, 0xE7130920, 0xE5040B0B, 0xF3F70A25, 0x0A010100);
	r0 = D(r0, s1_2_1, 0x13FB0709, 0x04FFFCFF, 0xE2FB1AFC, 0x0F030400);
	r1 = D(r1, s1_2_1, 0x02EA1704, 0x06F7F50E, 0xEE07F8F6, 0x19FDFC05);
	r2 = D(r2, s1_2_1, 0x03F5151C, 0x07F82708, 0x000A02DA, 0xFF0004FE);
	r3 = D(r3, s1_2_1, 0x04200EE4, 0x19FE09FB, 0xF50002EB, 0xEFFBFEFE);
	r0 = D(r0, s1_2_2, 0xFB01FEFC, 0xFAFEFFFF, 0x00FC08F8, 0xEFFA0AFC);
	r1 = D(r1, s1_2_2, 0x10FF12FF, 0x06FE0603, 0x07000405, 0xF801FE01);
	r2 = D(r2, s1_2_2, 0xFCFAFFF6, 0xF10701FD, 0xDA0705F8, 0x020002FF);
	r3 = D(r3, s1_2_2, 0xF9040809, 0xF1F7FA03, 0xF30300FB, 0xFBFEFF01);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(2.298e-05, -1.895e-03, -1.163e-02, -1.039e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.182e-02, -2.352e-03, -4.695e-03, -1.131e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-1.371e-02, -8.677e-03, -7.191e-03, -5.232e-04);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-6.713e-03, -9.408e-03, -5.015e-03, -3.356e-03);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-TEST-out-shuffle
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
	r0 += M4(7.837e-04, -1.517e-03, -2.148e-03, 1.991e-04, 1.126e-03, -4.656e-04, 9.835e-03, 3.294e-03, 3.236e-02, -1.539e-02, 3.181e-03, -2.065e-03, -2.120e-02, 7.856e-03, 2.057e-02, 4.355e-03) * s0_0_0;
	r0 += M4(-1.804e-01, 1.030e-03, 3.950e-03, -5.873e-03, -1.706e-02, 2.031e-02, -2.327e-03, -1.077e-03, 3.060e-02, -8.375e-02, -1.756e-02, 3.894e-02, -2.892e-03, 2.691e-02, -7.344e-03, -1.952e-02) * s0_0_1;
	r0 += M4(1.569e-02, -1.990e-01, 8.644e-04, 3.120e-04, -1.745e-03, -2.645e-03, -1.702e-03, -7.950e-04, 1.036e-02, -1.193e-02, -2.792e-03, -1.513e-03, -2.906e-03, -3.137e-03, 1.226e-03, -3.995e-04) * s0_0_2;
	r0 += M4(1.200e-02, 1.350e-03, 3.157e-03, -1.107e-03, -3.245e-01, -2.882e-01, -1.553e-01, -2.300e-01, -3.694e-02, -1.291e-02, 9.986e-02, 5.538e-03, 1.842e-01, -8.491e-04, -1.057e-01, -4.786e-03) * s0_1_0;
	r0 += M4(-5.339e-02, -3.165e-02, -3.447e-01, 3.058e-02, -7.223e-03, 6.055e-02, -4.732e-02, 6.029e-02, 4.212e-02, 7.462e-02, 2.924e-01, -5.215e-01, 1.866e-01, -4.313e-01, -1.337e-02, 1.256e-01) * s0_1_1;
	r0 += M4(-1.693e-02, -3.689e-02, 3.093e-02, -3.228e-01, 6.234e-03, 2.061e-03, 2.691e-03, -4.290e-03, 3.725e-03, -7.144e-03, -1.421e-03, 1.305e-02, -1.053e-02, 1.443e-02, 9.921e-03, -9.186e-03) * s0_1_2;
	r0 += M4(-5.395e-03, -1.393e-03, -1.902e-04, 1.336e-03, 3.153e-02, 3.253e-02, -8.891e-02, -3.240e-02, 2.197e-02, 1.865e-03, -1.021e-02, -5.059e-03, -4.183e-02, 1.160e-02, 5.977e-02, -1.218e-02) * s0_2_0;
	r0 += M4(-2.591e-03, -4.367e-03, 4.480e-02, -1.938e-02, -1.142e-02, 1.298e-03, 2.548e-03, -5.346e-02, -7.492e-03, -2.923e-02, 2.747e-03, 2.179e-02, 1.334e-02, -1.283e-03, -1.155e-01, 1.091e-01) * s0_2_1;
	r0 += M4(1.981e-03, -6.425e-03, -1.284e-02, 3.699e-02, -1.647e-04, -1.025e-03, -3.745e-04, -1.470e-03, 1.200e-03, 1.494e-03, -3.192e-03, 1.169e-02, 4.590e-04, 1.199e-03, 9.929e-03, -1.179e-02) * s0_2_2;
	r0 += M4(-1.443e-02, -3.765e-03, -2.052e-03, 2.318e-03, -1.666e-02, 9.850e-03, -9.094e-03, -2.944e-03, 3.597e-03, 1.413e-03, -2.595e-03, 3.062e-04, -6.899e-03, 2.103e-03, 1.076e-03, -1.720e-03) * s1_0_0;
	r0 += M4(-5.579e-02, -1.110e-01, 4.743e-03, 3.909e-02, -4.627e-02, -5.553e-02, 3.062e-02, 1.618e-02, 7.690e-02, 1.515e-02, -6.367e-03, -1.102e-02, -9.616e-03, -5.404e-03, 3.858e-03, 3.618e-03) * s1_0_1;
	r0 += M4(6.028e-03, 5.564e-03, 3.892e-03, -8.850e-03, -2.948e-03, -5.691e-03, -2.986e-03, -7.393e-04, -6.228e-03, 5.799e-02, -1.929e-04, 6.656e-03, -1.105e-03, 6.260e-03, 2.822e-03, -2.349e-03) * s1_0_2;
	r0 += M4(2.159e-02, 1.478e-02, -2.195e-02, -6.294e-03, 3.796e-02, -2.860e-02, 4.357e-03, 1.800e-02, 3.094e-02, -1.948e-02, 3.288e-03, 2.075e-03, -3.722e-02, 2.094e-02, -8.511e-03, -1.840e-03) * s1_1_0;
	r0 += M4(-1.743e-01, -1.504e-01, 2.977e-01, 1.909e-01, 2.262e-01, 2.485e-01, -1.675e-01, -1.898e-01, -4.702e-01, -2.597e-02, 2.412e-01, 8.131e-02, 2.961e-01, 9.430e-03, -8.085e-02, -5.902e-02) * s1_1_1;
	r0 += M4(1.559e-02, -1.885e-02, -2.451e-02, 6.317e-02, -2.050e-02, 4.084e-03, 1.878e-02, -2.096e-03, 6.819e-02, -2.530e-01, -3.048e-02, 9.765e-02, -7.751e-02, 1.205e-01, 1.132e-02, -3.789e-02) * s1_1_2;
	r0 += M4(1.651e-03, 1.856e-03, -5.878e-03, 8.556e-04, -4.145e-03, 1.169e-02, 1.169e-02, -1.722e-03, -1.714e-02, 9.495e-03, -3.864e-03, 7.339e-03, -7.532e-03, 1.625e-02, 1.304e-02, -1.667e-02) * s1_2_0;
	r0 += M4(2.039e-03, 9.956e-03, -4.665e-03, -8.726e-03, -3.359e-02, -7.120e-02, 1.009e-01, 1.696e-02, 5.684e-02, 1.531e-02, 3.748e-02, -5.147e-02, 7.727e-02, 4.092e-02, -2.300e-01, 1.895e-02) * s1_2_1;
	r0 += M4(4.869e-04, 2.098e-03, -4.897e-04, -3.921e-03, 1.043e-02, -8.219e-03, -2.732e-02, 3.434e-02, 1.048e-02, 1.266e-02, -2.142e-02, 3.249e-02, -1.581e-02, 2.437e-02, 2.948e-02, -1.073e-01) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 += M4(4.908e-03, -7.645e-03, -1.809e-02, 1.559e-02, 1.285e-02, -1.089e-03, 4.156e-03, 1.002e-04, 2.626e-02, 1.116e-02, -1.493e-02, -6.730e-03, 5.873e-02, -1.410e-02, 9.989e-03, 3.382e-03) * s0_0_0;
	r0 += M4(-3.692e-01, 3.123e-01, 4.270e-02, -1.095e-02, -1.694e-01, 1.184e-01, 4.970e-03, 2.874e-02, 1.838e-02, 1.786e-02, -5.039e-03, -1.815e-02, 9.118e-02, 1.034e-01, -6.019e-02, -2.749e-02) * s0_0_1;
	r0 += M4(-2.937e-02, 9.746e-02, -1.441e-02, -3.196e-02, -8.128e-03, 2.988e-02, -1.663e-03, -6.918e-03, 9.870e-03, 1.087e-02, -4.352e-03, -3.702e-03, 4.866e-03, 1.044e-02, 6.180e-03, 1.391e-03) * s0_0_2;
	r0 += M4(-4.617e-03, 4.532e-03, -1.357e-02, 9.194e-03, 2.718e-02, -3.663e-03, 2.577e-02, -7.216e-03, -8.308e-02, 2.705e-02, 7.055e-02, 1.672e-02, 7.824e-02, 4.531e-03, 1.177e-01, -1.318e-02) * s0_1_0;
	r0 += M4(5.187e-02, -4.996e-02, 1.801e-02, 2.373e-02, -2.065e-01, 2.339e-01, -4.536e-01, 3.291e-01, -1.682e-01, -3.545e-01, 2.881e-01, 2.901e-01, 2.027e-01, 3.915e-01, 3.666e-01, 5.566e-01) * s0_1_1;
	r0 += M4(1.956e-04, -8.014e-03, -1.064e-02, 3.316e-02, -1.638e-02, -1.656e-03, -2.006e-02, 7.934e-02, -2.500e-02, 9.022e-03, -7.496e-03, 5.685e-02, -1.408e-02, -1.314e-02, -1.227e-02, 1.441e-02) * s0_1_2;
	r0 += M4(8.308e-04, -4.006e-04, -2.528e-03, -2.198e-03, 2.213e-03, -1.515e-03, 1.228e-02, -1.724e-04, -1.007e-03, -4.319e-03, 6.005e-03, -4.222e-03, 3.040e-03, 2.561e-03, 2.234e-02, -6.301e-03) * s0_2_0;
	r0 += M4(-2.808e-03, -9.179e-04, -6.231e-03, 4.999e-03, -3.058e-03, -5.519e-03, -2.486e-02, 3.455e-02, 6.097e-03, 1.429e-02, -6.959e-02, 1.378e-02, -1.633e-02, -3.723e-02, -9.215e-03, 2.391e-02) * s0_2_1;
	r0 += M4(-5.810e-03, 1.095e-02, 2.318e-03, -1.078e-02, 9.978e-03, -2.220e-03, 3.633e-03, -1.344e-02, 7.397e-04, 1.128e-04, 1.494e-02, -4.358e-02, 2.454e-03, 7.265e-03, 4.828e-03, -9.766e-04) * s0_2_2;
	r0 += M4(2.558e-02, -2.252e-02, 2.473e-03, 3.892e-02, -2.038e-02, -1.550e-02, 8.200e-03, 7.291e-03, -1.216e-02, 4.988e-03, -4.004e-03, 3.042e-03, -2.747e-02, 5.447e-03, -7.362e-03, -9.808e-04) * s1_0_0;
	r0 += M4(2.124e-01, 2.409e-01, -1.989e-01, -3.341e-01, 4.333e-03, -2.361e-02, 1.656e-03, 8.525e-03, 4.088e-02, -3.382e-02, -6.112e-04, -7.912e-03, 7.980e-02, -5.702e-02, -3.847e-03, 7.872e-03) * s1_0_1;
	r0 += M4(-1.964e-02, -1.457e-02, 7.356e-04, 2.674e-02, -1.876e-02, -4.239e-04, 1.075e-02, 8.922e-03, -2.868e-03, 1.588e-02, 3.120e-03, 5.499e-03, -5.359e-02, 1.140e-01, 2.365e-02, 2.556e-03) * s1_0_2;
	r0 += M4(4.507e-03, -3.667e-03, 4.093e-04, -2.960e-03, 1.441e-01, 1.574e-02, -1.395e-01, -1.860e-02, -2.148e-02, 2.314e-02, -3.380e-02, 9.930e-03, -4.342e-02, 1.093e-03, -4.553e-02, 4.858e-03) * s1_1_0;
	r0 += M4(-2.632e-02, -1.744e-02, 2.711e-02, 3.760e-02, 2.972e-01, 3.341e-01, -3.148e-01, -3.077e-01, 4.131e-01, -3.999e-01, 2.657e-01, -2.135e-01, 1.862e-01, -1.383e-01, 2.839e-01, -2.627e-01) * s1_1_1;
	r0 += M4(7.390e-03, -1.672e-03, 1.862e-03, 6.571e-03, 1.758e-02, 1.343e-01, -2.612e-02, -1.299e-01, -2.131e-02, 2.535e-02, -1.353e-02, 1.339e-02, -8.381e-02, 3.895e-02, -1.664e-01, 1.475e-01) * s1_1_2;
	r0 += M4(-5.999e-04, 1.226e-04, -1.089e-03, 5.112e-04, -1.254e-02, -1.007e-02, 1.048e-02, 7.604e-03, -4.550e-03, -1.615e-03, -5.447e-03, 2.783e-03, 1.365e-03, -1.419e-03, -1.666e-02, 3.819e-03) * s1_2_0;
	r0 += M4(5.559e-04, 1.112e-03, 2.665e-04, -1.114e-03, -8.701e-03, -1.043e-02, 2.814e-02, -1.383e-03, -2.865e-04, -4.512e-03, 1.298e-01, -1.179e-01, -3.058e-02, 7.017e-03, 3.416e-03, -5.741e-03) * s1_2_1;
	r0 += M4(4.854e-05, -1.262e-03, -7.695e-04, 1.392e-04, -2.978e-03, -1.043e-02, 9.177e-03, 2.240e-02, 3.296e-04, 1.192e-02, -7.367e-03, 2.201e-02, 4.985e-03, -1.151e-02, 1.072e-02, -7.528e-03) * s1_2_2;
	r0 += V4(8.449e-09, 8.705e-09, -5.576e-09, 9.306e-09);
	r0 = tanh(r0);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
