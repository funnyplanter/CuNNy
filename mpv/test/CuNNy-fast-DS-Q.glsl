// CuNNy fast DS (dp4a)
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


//!DESC CuNNy-fast-DS-in
//!HOOK LUMA
//!COMPUTE 24 8 8 8
//!BIND LUMA
//!SAVE in
//!WIDTH LUMA.w 3 *
//!HEIGHT LUMA.h
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
	ivec2 opos = pos * ivec2(3, 1);
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
	V4 r0, r1, r2;
	r0 = V4(0.0); r1 = V4(0.0); r2 = V4(0.0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2];
	r0 += V4(1.383e-01, -2.817e-02, 5.354e-02, -2.555e-01) * s0_0_0;
	r1 += V4(-2.582e-02, -3.095e-03, 3.846e-02, -3.491e-01) * s0_0_0;
	r2 += V4(-1.683e+01, 2.431e-02, 8.166e-01, 4.347e-01) * s0_0_0;
	r0 += V4(3.018e-01, -4.568e-03, 1.027e+00, 4.313e-01) * s0_0_1;
	r1 += V4(1.210e-01, 2.641e-02, -1.290e-01, 4.220e-01) * s0_0_1;
	r2 += V4(2.510e-01, 3.625e-02, 4.140e-02, 1.305e-01) * s0_0_1;
	r0 += V4(1.506e-01, 8.533e-03, 1.707e-04, -6.027e-02) * s0_0_2;
	r1 += V4(-8.276e-02, -3.115e-02, -1.996e-02, -9.243e-02) * s0_0_2;
	r2 += V4(-6.490e-02, -6.370e-02, 7.962e-03, -2.673e-02) * s0_0_2;
	r0 += V4(2.329e-01, 2.030e-02, -9.202e-02, -6.412e-01) * s0_1_0;
	r1 += V4(3.307e-02, 2.978e-02, -1.125e-01, -2.535e-01) * s0_1_0;
	r2 += V4(2.550e-01, -1.051e+00, -8.011e-01, -3.076e-01) * s0_1_0;
	r0 += V4(-1.104e+00, -4.697e-01, -9.199e-01, 3.680e-01) * s0_1_1;
	r1 += V4(6.750e-01, 9.824e-01, 7.411e-01, 7.250e-01) * s0_1_1;
	r2 += V4(2.099e-01, 9.239e-01, -6.937e-02, -8.121e-01) * s0_1_1;
	r0 += V4(-7.429e-02, -5.147e-01, -3.533e-02, 1.856e-01) * s0_1_2;
	r1 += V4(-7.190e-01, -1.009e+00, -2.250e-01, -3.564e-01) * s0_1_2;
	r2 += V4(-4.985e-02, 1.232e-01, 5.003e-03, 7.005e-02) * s0_1_2;
	r0 += V4(1.743e-01, 7.004e-03, 2.408e-02, -6.560e-02) * s0_2_0;
	r1 += V4(1.862e-02, -1.400e-02, 4.703e-02, -2.137e-03) * s0_2_0;
	r2 += V4(-3.061e-01, -1.176e-02, -1.340e-02, 1.779e-01) * s0_2_0;
	r0 += V4(-1.339e-01, 9.931e-01, -8.911e-02, 1.685e-01) * s0_2_1;
	r1 += V4(1.894e-01, 1.010e-02, -1.704e-01, -4.370e-02) * s0_2_1;
	r2 += V4(4.480e-02, 7.249e-02, 1.541e-02, 2.833e-01) * s0_2_1;
	r0 += V4(7.723e-02, -7.037e-03, 3.407e-02, -1.053e-01) * s0_2_2;
	r1 += V4(-1.987e-01, -1.982e-03, -6.338e-02, -5.350e-02) * s0_2_2;
	r2 += V4(-3.683e-02, -6.322e-02, -5.748e-03, 5.087e-02) * s0_2_2;
	r0 += V4(-1.971e-02, -3.071e-04, 7.575e-03, 1.426e-02);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(1.629e-02, -1.664e-03, 4.121e-03, -3.160e-03);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(-2.402e-03, 2.083e-05, -1.173e-02, 7.237e-03);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-fast-DS-conv1
//!HOOK LUMA
//!COMPUTE 24 8 8 8
//!BIND in
//!BIND LUMA
//!SAVE conv1
//!WIDTH LUMA.w 3 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) (in_mul * texelFetch(in_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0), 0))
#define l1(x, y) (in_mul * texelFetch(in_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0), 0))
#define l2(x, y) (in_mul * texelFetch(in_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0), 0))
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[3][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(3, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			vec4 v2 = l2(x - 1, y - 1) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2;
	vec4 f0, f1, f2;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x18DCF908, 0x050F33F5, 0x0BE809FA, 0x1E1A3C81);
	r1 = D(r1, s0_0_0, 0x0906FBD6, 0x01AEBCF2, 0x070FF31A, 0xF0FF1108);
	r2 = D(r2, s0_0_0, 0x09EEFD08, 0x07C341ED, 0xF2160308, 0xF132ED1E);
	r0 = D(r0, s0_0_1, 0xF90BF707, 0xE2E03EDE, 0x130508FE, 0xF3C59BBB);
	r1 = D(r1, s0_0_1, 0xD74043AA, 0x27D5817F, 0x43BA9DF9, 0x120A09EF);
	r2 = D(r2, s0_0_1, 0x1EDFF9E4, 0xF516FBDA, 0xF1171CE5, 0xD3BF07CA);
	r0 = D(r0, s0_0_2, 0x0D0705F2, 0xE10F1E04, 0x0AFADFFF, 0x3FD005E2);
	r1 = D(r1, s0_0_2, 0xDC281BF6, 0x31E6EE09, 0x15EBE125, 0x11011608);
	r2 = D(r2, s0_0_2, 0x0AFE0101, 0x03F9FD0B, 0x23F3E405, 0xE800D6F4);
	r0 = D(r0, s0_1_0, 0xF52E19FB, 0xE902EC18, 0x1A05DAF7, 0x7F05EDBE);
	r1 = D(r1, s0_1_0, 0xA9669732, 0xF1F60BF1, 0xE40DD7D0, 0xFBCC16F1);
	r2 = D(r2, s0_1_0, 0xFAEFF3FC, 0x15D88E63, 0xF0F2F216, 0xFE00F3E7);
	r0 = D(r0, s0_1_1, 0xD6E9E818, 0x1988EF0D, 0xFDF2FF03, 0x397F2A00);
	r1 = D(r1, s0_1_1, 0x0C818136, 0xDA21378A, 0xFC81097F, 0x130802A9);
	r2 = D(r2, s0_1_1, 0xE83DF0FE, 0x04604FDF, 0x0AB318D6, 0xE8BFE103);
	r0 = D(r0, s0_1_2, 0xF6E604E8, 0x03EFF8FA, 0xCF30EC02, 0x0CF3EC0C);
	r1 = D(r1, s0_1_2, 0xC081D133, 0xCD23E820, 0x023AF9DD, 0xD3EF02F2);
	r2 = D(r2, s0_1_2, 0xFC0B1700, 0xF5120605, 0x15F000F9, 0x26DDF6D9);
	r0 = D(r0, s0_2_0, 0xDF0B08FC, 0x2315FF05, 0xFD12FFFC, 0xFDF90536);
	r1 = D(r1, s0_2_0, 0xF8C30115, 0x21D7F2F8, 0xEDE00D11, 0x0AEBFE20);
	r2 = D(r2, s0_2_0, 0x08150103, 0x61CDF2FE, 0xFDF00008, 0xCB4D0802);
	r0 = D(r0, s0_2_1, 0xE62E01FD, 0x25C2FF11, 0x0BBE11FB, 0xAD81FA1B);
	r1 = D(r1, s0_2_1, 0x3D6AFB04, 0x05F8ED2C, 0x170F1619, 0xE02EF9E8);
	r2 = D(r2, s0_2_1, 0x0359080C, 0x2F9AEB2A, 0xF718FB0E, 0x1D81F424);
	r0 = D(r0, s0_2_2, 0xF3F80402, 0x0FFE0504, 0x0A0FFAF5, 0xA5251C0C);
	r1 = D(r1, s0_2_2, 0x0DB60C34, 0xCE0FF7F4, 0xFE550C0E, 0xF0D2FE1A);
	r2 = D(r2, s0_2_2, 0xDC2709F4, 0xF61EF602, 0xF1EFFA00, 0x36E601EF);
	r0 = D(r0, s1_0_0, 0x0BE9DB2C, 0x03E321EC, 0xF6090FF0, 0x187FD944);
	r1 = D(r1, s1_0_0, 0x330FCE1B, 0xFCC6817F, 0xEA1BB129, 0x161B20E5);
	r2 = D(r2, s1_0_0, 0xFCF3E81B, 0xFC344AB6, 0x04001CE1, 0x10160718);
	r0 = D(r0, s1_0_1, 0x1816EDDE, 0xEDECEEE4, 0xF11328F6, 0xB209F70A);
	r1 = D(r1, s1_0_1, 0x02F444B1, 0xEE28C32B, 0xEABD0832, 0xFE03D521);
	r2 = D(r2, s1_0_1, 0xF81FF2FA, 0x05FD33BC, 0x0B11E706, 0xFBCA7FA0);
	r0 = D(r0, s1_0_2, 0xFE1EF007, 0xFCE70AE0, 0xE4DA23FE, 0x3BED0BEB);
	r1 = D(r1, s1_0_2, 0x2B151AC5, 0xF73B22DA, 0xE4E9051C, 0x0017D313);
	r2 = D(r2, s1_0_2, 0xFD0EE41B, 0xFD090BF5, 0xF706F818, 0x33161CD7);
	r0 = D(r0, s1_1_0, 0x1C045FDA, 0x0CEBA847, 0xFCE3C24C, 0x04EFF4AC);
	r1 = D(r1, s1_1_0, 0xBC04DDE4, 0x3D4BFD93, 0xDADED0DA, 0xFB1A08BA);
	r2 = D(r2, s1_1_0, 0x000DDCEF, 0x340207D0, 0x0BF030E3, 0xF1FF3981);
	r0 = D(r0, s1_1_1, 0xF3C2BE52, 0xA75E42E4, 0x5F59D523, 0xDD1A5881);
	r1 = D(r1, s1_1_1, 0x027F819D, 0x6BE115D7, 0x7F7F8156, 0xFFE07881);
	r2 = D(r2, s1_1_1, 0xC7EA54DB, 0xB4AE0A11, 0xE8CE33DE, 0xEE0E08D3);
	r0 = D(r0, s1_1_2, 0xFD3103EF, 0x06F5FC15, 0xC8BD0038, 0xEAB93BA5);
	r1 = D(r1, s1_1_2, 0xC7C0F550, 0x3E81CE51, 0xDEC86EA2, 0x040305F4);
	r2 = D(r2, s1_1_2, 0x031907E0, 0x15E219D1, 0x423C0CBA, 0xF41CC45B);
	r0 = D(r0, s1_2_0, 0x2BF0F311, 0x0B0FE413, 0xFF070FFB, 0x2029F314);
	r1 = D(r1, s1_2_0, 0x1B1FE036, 0xF1EF42C2, 0xB717330E, 0xF504DA20);
	r2 = D(r2, s1_2_0, 0xF90C12F8, 0x3AEAB829, 0x08FEEC1A, 0x041D2ECF);
	r0 = D(r0, s1_2_1, 0x05FEE6E0, 0xFBF9F916, 0x1B0F10E2, 0x13E5A07F);
	r1 = D(r1, s1_2_1, 0x34D7CB70, 0xCDEFEEFD, 0xF9FE20BB, 0x0EF00412);
	r2 = D(r2, s1_2_1, 0x00DC050E, 0xD525F435, 0xFBFF09F6, 0x28EFF237);
	r0 = D(r0, s1_2_2, 0xFB07F904, 0x00F8FB07, 0x06E60211, 0x13CF31FD);
	r1 = D(r1, s1_2_2, 0x09E008F5, 0xFB5B05D7, 0x00FF1EF4, 0x2AEFF00D);
	r2 = D(r2, s1_2_2, 0x30F0EA02, 0xEB04FE2A, 0x07070304, 0x06EDF0FF);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0903EDEB, 0xFC050008, 0x0101F007, 0xA9E4A1ED);
	r1 = D(r1, s0_0_0, 0x090B21F8, 0x33DEFC0E, 0x0A0013FC, 0x13FA0100);
	r2 = D(r2, s0_0_0, 0x020201F3, 0xD71FECE6, 0xF608080C, 0x02FCC53D);
	r0 = D(r0, s0_0_1, 0x0C1F1225, 0xD90E381E, 0xEE2EDAE9, 0x238181FB);
	r1 = D(r1, s0_0_1, 0xCE1971AD, 0x1447A7E0, 0x2FC89B05, 0x15F6EBC3);
	r2 = D(r2, s0_0_1, 0xFF15FCF9, 0x1F5317F3, 0xF7EA0606, 0x59810EFB);
	r0 = D(r0, s0_0_2, 0x15E40BEB, 0xF6343AEB, 0x24E3EA33, 0x817FB4DF);
	r1 = D(r1, s0_0_2, 0xC9016333, 0x68D996FB, 0xFD3B8165, 0x26EB060F);
	r2 = D(r2, s0_0_2, 0xF23AE30E, 0x10EF05ED, 0x07EAF1F4, 0xF67CFFD5);
	r0 = D(r0, s0_1_0, 0xFBFD0DD5, 0xDE10F70E, 0x0CFFF50C, 0x120AD025);
	r1 = D(r1, s0_1_0, 0x110025D6, 0x27E8E7ED, 0x0D0F3F1E, 0x08FBFD0E);
	r2 = D(r2, s0_1_0, 0xFCFEFE0B, 0xD6219E7F, 0xE60905FA, 0xFEE01B7F);
	r0 = D(r0, s0_1_1, 0xCAC3E121, 0x38D300F1, 0xE1FBE432, 0xBFB44181);
	r1 = D(r1, s0_1_1, 0xF3A9BB41, 0x20ED2E20, 0x4ADFFCFD, 0xEB4140D0);
	r2 = D(r2, s0_1_1, 0x16203DFE, 0x14E4870B, 0x12071505, 0x17EA65AF);
	r0 = D(r0, s0_1_2, 0x1522010A, 0x1458CAE1, 0x0CB68105, 0xD7C9EF81);
	r1 = D(r1, s0_1_2, 0x7F8DD339, 0xD01D1977, 0x08DBCD81, 0xF1F52A3A);
	r2 = D(r2, s0_1_2, 0x02A5FB12, 0xFBB94044, 0xEA7F2239, 0x1B7FD0AB);
	r0 = D(r0, s0_2_0, 0xEB0926B1, 0xFAF8ECEC, 0x0E01FE00, 0xFF06CB0A);
	r1 = D(r1, s0_2_0, 0xF9F61701, 0x25FD00EB, 0x07001014, 0x050BF036);
	r2 = D(r2, s0_2_0, 0x1101F717, 0xE1078E15, 0xEF05FE0B, 0x1AF221ED);
	r0 = D(r0, s0_2_1, 0x04F72E22, 0xFBFCE7FF, 0xE500EAD5, 0xCA120781);
	r1 = D(r1, s0_2_1, 0xDD6FD481, 0x4D260A24, 0xCC7FEAE2, 0x05F12281);
	r2 = D(r2, s0_2_1, 0xEB05E604, 0x389F89A8, 0xFF15FEE7, 0xE6C2E0CB);
	r0 = D(r0, s0_2_2, 0x07F209FC, 0xFE36F981, 0x02250D81, 0x125F7181);
	r1 = D(r1, s0_2_2, 0x0281CB64, 0x0DE10C4E, 0xF8A83A81, 0x812DEBE1);
	r2 = D(r2, s0_2_2, 0x08DC1B81, 0x2681214B, 0x1DC31AF3, 0x0F7FE081);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-4.102e-03, -1.285e-02, -2.440e-02, -4.462e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-3.507e-04, -9.863e-03, -6.671e-03, 8.637e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-2.084e-02, -4.808e-04, 4.887e-03, -2.331e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-fast-DS-conv2
//!HOOK LUMA
//!COMPUTE 16 8 8 8
//!BIND conv1
//!BIND LUMA
//!SAVE conv2
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) (conv1_mul * texelFetch(conv1_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0), 0))
#define l1(x, y) (conv1_mul * texelFetch(conv1_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0), 0))
#define l2(x, y) (conv1_mul * texelFetch(conv1_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0), 0))
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[3][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			vec4 v2 = l2(x - 1, y - 1) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1;
	vec4 f0, f1;
	r0 = ivec4(0); r1 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x011108FB, 0x1C05F9FA, 0x0C1A0DFD, 0x0F090EFE);
	r1 = D(r1, s0_0_0, 0xE209EF08, 0xFD0A03F8, 0x020608FD, 0xFEFC0104);
	r0 = D(r0, s0_0_1, 0xF6190301, 0xDDDFF10B, 0x0E1502FD, 0x08FF0204);
	r1 = D(r1, s0_0_1, 0x1E1110EB, 0xEA1900FB, 0xE80A00FD, 0xF2F401FF);
	r0 = D(r0, s0_0_2, 0xF801FFFA, 0x0403FCF7, 0x03F805F5, 0xFFF703EB);
	r1 = D(r1, s0_0_2, 0x01E6F526, 0x0206F900, 0xFEFCFC00, 0x00FE0004);
	r0 = D(r0, s0_1_0, 0x087418F9, 0x3245E6FA, 0xE5711FFA, 0xFC3620FD);
	r1 = D(r1, s0_1_0, 0xF0FFE6FB, 0x155D09FA, 0x155205F7, 0x110FF2FB);
	r0 = D(r0, s0_1_1, 0x12ECED07, 0xC410E32B, 0x09D9F90A, 0xDEF7DB15);
	r1 = D(r1, s0_1_1, 0x03CA1FCB, 0x16F82322, 0x19FFF832, 0x06110312);
	r0 = D(r0, s0_1_2, 0x2300030E, 0xEEF71DE8, 0xDE0DF627, 0xF50D0AF7);
	r1 = D(r1, s0_1_2, 0xE50BE33D, 0xF2F804E0, 0x100406C2, 0x030305F8);
	r0 = D(r0, s0_2_0, 0xE8010B03, 0x06E6F905, 0xF4FC1200, 0xFEFA0DFE);
	r1 = D(r1, s0_2_0, 0xE320B6F0, 0xF9E00D05, 0x01EA1905, 0x16E40504);
	r0 = D(r0, s0_2_1, 0x060475FE, 0xEF18060A, 0x031A75F5, 0xE0137CF3);
	r1 = D(r1, s0_2_1, 0x35D7182B, 0xBEF81710, 0xA80258F6, 0xAA032C05);
	r0 = D(r0, s0_2_2, 0xD907020C, 0xE402F60D, 0xE20223F6, 0xE90315F5);
	r1 = D(r1, s0_2_2, 0xE818F01F, 0xF809E406, 0xDA06020A, 0xF5020501);
	r0 = D(r0, s1_0_0, 0x0303FEFC, 0x0008F9F6, 0x01FDFEFA, 0xE0FBFEFA);
	r1 = D(r1, s1_0_0, 0x1D000F03, 0x010501FA, 0xFD04FDF7, 0xF701FFFA);
	r0 = D(r0, s1_0_1, 0x08FDEDED, 0x23F0F8F7, 0xE1F902EC, 0x0BFC09E8);
	r1 = D(r1, s1_0_1, 0xF80506E4, 0x0AFAF8F4, 0x10FDF0F5, 0x04FFF8FC);
	r0 = D(r0, s1_0_2, 0xFCFFFDFD, 0xF001F201, 0x040408F9, 0xF90403FC);
	r1 = D(r1, s1_0_2, 0xEDF7F8E5, 0xFBFEFE00, 0xF901FD00, 0xFF00FF01);
	r0 = D(r0, s1_1_0, 0xFBD607E8, 0xF9CB0FEB, 0x08D20DE9, 0x12CD04ED);
	r1 = D(r1, s1_1_0, 0x150BE2DB, 0xD3E1FBDF, 0xD9C91EEA, 0xE0E319F0);
	r0 = D(r0, s1_1_1, 0xBCC62DE5, 0xF6D5AEDB, 0x06D6E5DF, 0x0FD3E6DD);
	r1 = D(r1, s1_1_1, 0x01D80FC2, 0xF8D61CDA, 0xF4BF19D4, 0x0DD701E7);
	r0 = D(r0, s1_1_2, 0x0AE300F1, 0xF7020A02, 0x0CDBF2FA, 0x0EDEF902);
	r1 = D(r1, s1_1_2, 0xE6E881FB, 0x00F007F4, 0x04EC05F8, 0x04F30400);
	r0 = D(r0, s1_2_0, 0x08F3EDDE, 0xFBFFEAF3, 0x05F3E2EB, 0x07EFE5EC);
	r1 = D(r1, s1_2_0, 0xEFF206D3, 0x10E9FDC2, 0x18EFD0C4, 0x0FF4E4E0);
	r0 = D(r0, s1_2_1, 0x11F5EFB1, 0xF8F4FFFB, 0x05EC07E2, 0x0DEB09E9);
	r1 = D(r1, s1_2_1, 0xFCC8DA81, 0x0CEFDEC3, 0x12F3F0C8, 0x09EFF5EB);
	r0 = D(r0, s1_2_2, 0x03F3F8FF, 0xFC020503, 0x01F4FF0A, 0xFFF5FC09);
	r1 = D(r1, s1_2_2, 0xDCEEF813, 0xFDECF3F1, 0xFEECF904, 0xFEF7FF03);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x01FFF8FA, 0x16FE06EB, 0xFF05F9F4, 0x051DFD05);
	r1 = D(r1, s0_0_0, 0xF90AF5E8, 0x0501FBFB, 0x0504FC09, 0x0307050D);
	r0 = D(r0, s0_0_1, 0x05FBF425, 0x12FAE7FF, 0xFC11ED24, 0xF00BED18);
	r1 = D(r1, s0_0_1, 0x1EFAE9E9, 0x0100ED10, 0x0303F21B, 0x0401F408);
	r0 = D(r0, s0_0_2, 0xF805F2FF, 0x0AF60302, 0xF703F3FB, 0x040BF1F5);
	r1 = D(r1, s0_0_2, 0x1C00FD1D, 0xFD06F4FA, 0x0007F4FC, 0x0005F8FB);
	r0 = D(r0, s0_1_0, 0x0EFA0214, 0x08DC09FF, 0x05E80108, 0xE7F504EC);
	r1 = D(r1, s0_1_0, 0x19F3F714, 0x1527042E, 0x04280505, 0xDE3CFBFC);
	r0 = D(r0, s0_1_1, 0xD154A936, 0x402ECF10, 0xDA28C204, 0x1641A81D);
	r1 = D(r1, s0_1_1, 0x1E00CEBC, 0xF533987F, 0xED47884F, 0x0A1DC531);
	r0 = D(r0, s0_1_2, 0xFA04F20A, 0xE50109F5, 0x2305F109, 0x0301F712);
	r1 = D(r1, s0_1_2, 0x38EA001F, 0xF202FA10, 0x0602F307, 0xFB02F805);
	r0 = D(r0, s0_2_0, 0xEAFCFB09, 0xD90301F3, 0xFC07F90B, 0x040EF90C);
	r1 = D(r1, s0_2_0, 0x2AD80511, 0xD7F304F5, 0xE8F3FDFF, 0xFC0E05F7);
	r0 = D(r0, s0_2_1, 0xFDE207FB, 0x24080412, 0x08EE010E, 0xFFFB030E);
	r1 = D(r1, s0_2_1, 0x095BF0C6, 0x1928F8F1, 0x2D0D06FD, 0x0C08FE0A);
	r0 = D(r0, s0_2_2, 0x0AFC0605, 0x06FC06F7, 0xE6010003, 0xE303F903);
	r1 = D(r1, s0_2_2, 0x0611020C, 0x02FEFF15, 0xE702020E, 0xEC00FF04);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(8.590e-04, -8.508e-03, 1.182e-03, 1.352e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.064e-02, 6.639e-04, 1.258e-03, 8.762e-04);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-fast-DS-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv2
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
#define l0(x, y) V4((conv2_mul * texelFetch(conv2_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0), 0)))
#define l1(x, y) V4((conv2_mul * texelFetch(conv2_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0), 0)))
shared V4 G[2][10][10];
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
			G[1][ay][ax] = l1(x - 1, y - 1);
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
	r0 += M4(-5.797e-02, -6.617e-03, -1.698e-03, 4.846e-03, 2.167e-02, -6.067e-04, 1.847e-03, -3.624e-03, 1.018e-02, 4.245e-03, -2.758e-03, -2.724e-03, 1.861e-02, -2.166e-03, 4.598e-04, 2.495e-03) * s0_0_0;
	r0 += M4(2.484e-02, 2.067e-02, 2.463e-03, 1.877e-02, 2.456e-02, 2.116e-02, 4.836e-03, -1.639e-02, 6.115e-02, 5.847e-02, 2.041e-03, -7.052e-03, 3.650e-02, 4.089e-02, -7.321e-03, 4.073e-03) * s0_0_1;
	r0 += M4(4.508e-03, -1.074e-02, -1.953e-04, 2.580e-03, 4.082e-04, -7.495e-03, -4.277e-03, 1.517e-02, -9.460e-04, 2.240e-02, 4.105e-05, -5.905e-06, 2.170e-03, 8.191e-03, 1.099e-04, -2.301e-03) * s0_0_2;
	r0 += M4(-4.115e-02, -8.008e-03, -1.470e-01, -1.364e-02, 3.233e-02, -3.121e-03, 3.724e-02, -1.536e-03, -2.667e-02, 1.548e-02, 1.909e-02, 6.368e-03, 3.184e-02, -7.048e-03, 5.162e-02, -6.291e-04) * s0_1_0;
	r0 += M4(1.333e-01, 2.725e-01, 6.275e-02, -5.605e-01, -4.292e-01, 1.937e-01, -1.678e-01, 1.850e-01, 1.330e-01, -6.895e-01, 1.714e-01, 1.543e-01, -5.171e-01, 2.728e-01, 1.165e-01, 1.401e-01) * s0_1_1;
	r0 += M4(-2.650e-03, 4.284e-02, -4.332e-03, 3.344e-02, -4.026e-03, 8.417e-02, 3.140e-03, 1.876e-02, -9.213e-03, 7.482e-02, 3.823e-03, 5.504e-02, 2.209e-02, -3.802e-02, -1.713e-03, 3.231e-02) * s0_1_2;
	r0 += M4(-3.747e-03, 2.026e-03, -1.003e-02, 1.465e-02, 8.488e-03, -1.500e-03, 1.398e-02, -3.338e-03, -3.990e-03, -3.730e-03, 1.553e-02, -4.645e-03, 9.238e-03, 2.271e-03, -2.424e-02, -7.837e-03) * s0_2_0;
	r0 += M4(2.933e-03, -8.268e-03, 4.788e-02, 4.747e-02, -1.592e-03, -2.846e-03, -1.411e-01, 4.255e-02, 1.261e-02, 1.759e-02, 3.724e-02, -4.887e-03, -1.519e-02, -1.291e-02, -1.401e-01, -6.567e-02) * s0_2_1;
	r0 += M4(5.729e-04, -3.594e-03, -4.596e-03, 1.560e-02, 1.447e-02, -1.261e-02, 1.155e-02, 3.214e-03, 3.325e-03, 9.100e-03, -1.123e-03, 1.630e-02, 3.423e-03, -3.735e-03, 5.915e-03, -4.309e-02) * s0_2_2;
	r0 += M4(1.450e-02, -1.232e-03, -4.995e-03, 6.336e-03, 1.681e-02, 2.772e-03, 3.206e-03, 1.185e-03, 9.455e-03, -3.258e-04, 9.157e-04, -2.695e-03, -1.830e-03, 4.666e-04, -9.549e-04, 6.189e-05) * s1_0_0;
	r0 += M4(1.246e-01, -1.733e-01, 4.192e-02, -3.496e-03, -2.485e-01, -1.649e-01, -2.239e-02, -1.269e-02, 4.326e-02, 5.627e-02, 1.951e-02, 1.667e-03, 1.625e-01, 1.022e-02, 8.391e-03, -4.385e-03) * s1_0_1;
	r0 += M4(-8.796e-03, 5.725e-02, 7.937e-05, 2.618e-02, 4.502e-03, -4.998e-02, 3.218e-03, -9.140e-04, -7.469e-03, 8.350e-02, -3.698e-03, 2.186e-04, -3.239e-03, -1.081e-01, 5.723e-03, -4.745e-03) * s1_0_2;
	r0 += M4(-5.996e-02, 3.754e-02, 1.207e-02, 1.509e-03, -4.442e-03, -3.892e-04, 3.992e-02, 1.395e-02, 4.194e-02, 3.173e-03, 4.283e-02, -6.953e-03, 2.635e-04, -6.651e-04, 2.372e-03, -1.227e-04) * s1_1_0;
	r0 += M4(1.247e-01, -1.499e-01, 1.919e-01, -3.473e-01, 2.886e-02, 1.428e-02, 1.899e-01, 1.519e-01, 9.936e-02, 9.892e-02, -7.320e-01, 3.821e-02, 2.173e-01, 1.911e-02, 3.252e-01, 6.180e-02) * s1_1_1;
	r0 += M4(-4.468e-03, 1.995e-02, -1.245e-02, 3.990e-02, -6.671e-03, 1.779e-03, -4.970e-05, 7.251e-02, 1.057e-02, 6.769e-02, 1.542e-02, 3.190e-02, -2.169e-02, -2.456e-01, -2.445e-02, -3.703e-01) * s1_1_2;
	r0 += M4(1.119e-03, -6.115e-04, -3.537e-02, 1.910e-02, -2.126e-06, 5.663e-04, -9.961e-04, 2.232e-03, -2.939e-03, -1.791e-03, 1.411e-02, -4.984e-03, 1.907e-03, 7.763e-04, 1.304e-03, 2.420e-04) * s1_2_0;
	r0 += M4(-6.969e-03, 2.758e-03, 2.032e-02, 3.235e-02, -1.249e-04, -1.049e-03, 4.942e-03, 8.257e-04, -6.471e-03, 7.350e-03, 4.419e-02, 3.504e-02, 1.088e-02, -8.071e-03, 3.349e-02, -1.749e-02) * s1_2_1;
	r0 += M4(-3.123e-04, -1.417e-03, 3.972e-03, 6.219e-03, 5.769e-04, 1.380e-03, 1.179e-03, 2.460e-06, -4.023e-03, -7.051e-05, 3.477e-03, 9.865e-03, -3.775e-03, -1.172e-03, -1.412e-02, 2.402e-03) * s1_2_2;
	r0 += V4(7.454e-09, -1.247e-10, 7.640e-11, 7.747e-09);
	r0 = r0;
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
