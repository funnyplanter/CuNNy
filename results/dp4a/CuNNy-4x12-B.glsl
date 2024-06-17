// CuNNy 4x12 BOX
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


//!DESC CuNNy-4x12-BOX-in
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
#define l0(x, y) F(LUMA_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(1, 1) + ivec2(0, 0)) + vec2(0.5)) * LUMA_pt).r)
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
	r0 += V4(-1.180e-02, 2.921e-02, -1.708e-02, -3.549e-02) * s0_0_0;
	r1 += V4(-3.333e-02, 3.755e-02, -7.966e-03, 4.193e-01) * s0_0_0;
	r2 += V4(-9.901e-03, 5.099e-03, 1.276e-02, 1.781e-01) * s0_0_0;
	r0 += V4(-6.404e-02, 3.232e-01, -6.895e-01, 2.656e-01) * s0_0_1;
	r1 += V4(2.812e-01, 8.849e-01, -1.357e-02, 9.602e-02) * s0_0_1;
	r2 += V4(-3.796e-02, -3.514e-02, -1.620e-02, -3.232e-01) * s0_0_1;
	r0 += V4(5.030e-02, -3.564e-01, -6.252e-03, -4.889e-03) * s0_0_2;
	r1 += V4(-6.496e-02, 1.997e-02, 2.193e-02, -9.322e-02) * s0_0_2;
	r2 += V4(4.069e-02, 6.738e-01, -6.296e-03, -1.228e-01) * s0_0_2;
	r0 += V4(-2.886e-02, 1.117e-03, 1.275e-02, 2.686e-01) * s0_1_0;
	r1 += V4(3.849e-02, -2.660e-02, 2.349e-02, 1.013e-01) * s0_1_0;
	r2 += V4(1.430e-02, 9.772e-03, 2.062e-03, 1.087e-02) * s0_1_0;
	r0 += V4(-6.032e-01, -6.045e-01, 6.971e-01, -4.214e+00) * s0_1_1;
	r1 += V4(2.097e-01, -9.004e-01, -6.009e-01, -3.998e-01) * s0_1_1;
	r2 += V4(-7.998e-01, 6.749e-03, 7.207e-01, -2.234e-01) * s0_1_1;
	r0 += V4(-1.467e-02, 6.074e-01, 1.234e-03, 2.822e-01) * s0_1_2;
	r1 += V4(2.541e-01, -1.975e-02, -1.701e-02, -1.334e-01) * s0_1_2;
	r2 += V4(8.105e-01, -6.858e-01, -7.025e-01, -4.971e-02) * s0_1_2;
	r0 += V4(3.923e-02, -2.393e-02, 2.260e-03, -2.054e-02) * s0_2_0;
	r1 += V4(-1.334e-02, -2.263e-02, 5.768e-01, -6.918e-02) * s0_2_0;
	r2 += V4(-8.656e-03, -9.668e-03, -1.791e-02, -1.674e-01) * s0_2_0;
	r0 += V4(6.660e-01, -2.099e-02, -3.813e-03, 2.486e-01) * s0_2_1;
	r1 += V4(2.046e-02, 3.414e-02, 2.150e-02, -1.246e-01) * s0_2_1;
	r2 += V4(-8.330e-03, 8.864e-03, 3.935e-02, 5.159e-01) * s0_2_1;
	r0 += V4(-3.362e-02, 4.429e-02, 5.309e-03, -1.706e-02) * s0_2_2;
	r1 += V4(-2.161e-02, -5.611e-03, -5.108e-03, 2.026e-01) * s0_2_2;
	r2 += V4(-8.218e-04, 2.162e-02, -2.705e-02, 1.801e-01) * s0_2_2;
	r0 += V4(1.971e-02, 1.283e-03, -2.700e-04, 2.812e-02);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-2.571e-01, 1.251e-02, 7.403e-05, -2.179e-03);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(1.095e-02, 2.144e-04, 1.733e-02, -4.165e-03);
	r2 = max(r2, V4(0.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-4x12-BOX-conv1
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
#define l0(x, y) in_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0)) + vec2(0.5)) * in_pt)
#define l1(x, y) in_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0)) + vec2(0.5)) * in_pt)
#define l2(x, y) in_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0)) + vec2(0.5)) * in_pt)
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
	r0 = D(r0, s0_0_0, 0x0605F1F9, 0x0AF90FF9, 0xFF000A01, 0xFEFA04F1);
	r1 = D(r1, s0_0_0, 0xEFFD04E2, 0x0108FCFB, 0x300D32E4, 0xE5F3E350);
	r2 = D(r2, s0_0_0, 0x0B0209FC, 0x0211180C, 0xE4060EF6, 0xFE04FC05);
	r0 = D(r0, s0_0_1, 0xF7FFFEF8, 0x1DF1F124, 0x0409070D, 0x0006F908);
	r1 = D(r1, s0_0_1, 0x29F1E157, 0x15FCFC1D, 0x7FBC1D36, 0x04FE0FE2);
	r2 = D(r2, s0_0_1, 0x04F3F8E4, 0xEFFC2702, 0x2602E825, 0x18FDFCE8);
	r0 = D(r0, s0_0_2, 0xFBFF000E, 0xFEFDFA37, 0x070109FE, 0xF00001F4);
	r1 = D(r1, s0_0_2, 0x04F4F929, 0x090100FB, 0x39F00522, 0x0C06001F);
	r2 = D(r2, s0_0_2, 0x010F00F8, 0xF9F2180B, 0x22FDC9F6, 0x0E0405E3);
	r0 = D(r0, s0_1_0, 0xED28ECF5, 0x171FE8BC, 0x04F606F8, 0xFDF200EC);
	r1 = D(r1, s0_1_0, 0xF7FE11EC, 0x1E0D1023, 0x17021D17, 0x0F81DA2E);
	r2 = D(r2, s0_1_0, 0x2A262226, 0x01FB18DD, 0xFCCF121D, 0x0C10E00D);
	r0 = D(r0, s0_1_1, 0x3CC908FE, 0x9CBF151A, 0x04160D0B, 0x1EFD097E);
	r1 = D(r1, s0_1_1, 0x16083A05, 0xF71F1D0A, 0x34220CE8, 0x42810BE8);
	r2 = D(r2, s0_1_1, 0x26D503CC, 0x0303F3E8, 0xC83E3E2C, 0x3C2228F9);
	r0 = D(r0, s0_1_2, 0x0111FE0C, 0x06091B02, 0x022E0EF5, 0x0B06FFF1);
	r1 = D(r1, s0_1_2, 0xF4070EF4, 0x1CE1FA07, 0x1DC6FBF5, 0x27F51CD9);
	r2 = D(r2, s0_1_2, 0x141106EF, 0xF7090840, 0x0D0EFBF2, 0x16E309FE);
	r0 = D(r0, s0_2_0, 0x112B2B08, 0x074B1CF1, 0x07140601, 0x1AD71E03);
	r1 = D(r1, s0_2_0, 0x001CFEF5, 0x00FB260A, 0x04EB03FC, 0xF5B1E003);
	r2 = D(r2, s0_2_0, 0x05DAFF05, 0x0B07CFED, 0x14AD0BD4, 0xFEE51905);
	r0 = D(r0, s0_2_1, 0x00EDE5FC, 0xF5BEE21F, 0x09F611FF, 0x072B09E2);
	r1 = D(r1, s0_2_1, 0x03F0F209, 0x22E320FF, 0x03290D09, 0xF10821F5);
	r2 = D(r2, s0_2_1, 0x031600FA, 0xDB8181FB, 0xF8F90507, 0x103E1DF5);
	r0 = D(r0, s0_2_2, 0xF9FFF9F9, 0x09EAFB0A, 0x09811002, 0x1333EEDF);
	r1 = D(r1, s0_2_2, 0x191229F8, 0x15040A02, 0x0206FD02, 0xF5113DF9);
	r2 = D(r2, s0_2_2, 0x072201F6, 0xEEFF1803, 0xF52B26F8, 0x0F1D1B0C);
	r0 = D(r0, s1_0_0, 0x05E8FD01, 0xFEF2F6F7, 0x020200FB, 0xF60A10FF);
	r1 = D(r1, s1_0_0, 0x04040804, 0x07F7F8FC, 0x040CEFFF, 0xEFFB10FC);
	r2 = D(r2, s1_0_0, 0xFA020904, 0x03FFF90B, 0xF40612F7, 0xFCFC06FD);
	r0 = D(r0, s1_0_1, 0x0726EF02, 0x18DB10F7, 0x0001F917, 0x02F9F6FC);
	r1 = D(r1, s1_0_1, 0xF9EB03EE, 0x14090B01, 0x050C27EC, 0xFEA523F2);
	r2 = D(r2, s1_0_1, 0xFD161DFC, 0xFAFB1600, 0xDD16E104, 0x13EFF000);
	r0 = D(r0, s1_0_2, 0x02F7F700, 0x28CEF2FE, 0xF7FD1804, 0x01071103);
	r1 = D(r1, s1_0_2, 0x10C10F04, 0xFE1D0701, 0xE4F50701, 0xF902DF08);
	r2 = D(r2, s1_0_2, 0xE60CF006, 0xE7EBFE01, 0xF63E5509, 0xF916F2FE);
	r0 = D(r0, s1_1_0, 0x0D02FA04, 0xF60FDE09, 0x00FF0B08, 0x020B17FD);
	r1 = D(r1, s1_1_0, 0xF8FF0806, 0xFE06E6FF, 0xF6FA0FF2, 0x1416DF05);
	r2 = D(r2, s1_1_0, 0xF712EEFA, 0xFD0603F7, 0xEF0B1F0B, 0x0101E9FB);
	r0 = D(r0, s1_1_1, 0xF7F21501, 0x1BF08121, 0x02F6F64A, 0xDB24140C);
	r1 = D(r1, s1_1_1, 0x31068113, 0xF50C0E12, 0xF505DFF6, 0xF4FB4F19);
	r2 = D(r2, s1_1_1, 0x0F106A09, 0x21810004, 0xDE2A84F2, 0xF31C7F12);
	r0 = D(r0, s1_1_2, 0xFDF70BFC, 0x3415C3F6, 0xF102E736, 0xFDE8DBF7);
	r1 = D(r1, s1_1_2, 0xF523ADEF, 0x0B01FEFB, 0xFE0100FD, 0xDB0E90F1);
	r2 = D(r2, s1_1_2, 0xFE01D5F7, 0x0B81F801, 0xDF1307F6, 0xFBF003FF);
	r0 = D(r0, s1_2_0, 0xF9FDFE00, 0x0C0FF9FC, 0x0402F9FD, 0x0AFE24FD);
	r1 = D(r1, s1_2_0, 0xFD04FEFB, 0x0B02E800, 0xF503040C, 0x01FAEAFC);
	r2 = D(r2, s1_2_0, 0x060B0100, 0xFC071CF7, 0xD70920FB, 0x06FFFA02);
	r0 = D(r0, s1_2_1, 0x26F3F000, 0x15E81201, 0xF9020A1A, 0xEE12D405);
	r1 = D(r1, s1_2_1, 0xFEF71EFE, 0x120535F7, 0x05FFF6FC, 0x210AFDFE);
	r2 = D(r2, s1_2_1, 0xFDFC20FE, 0x2702C007, 0xB915FB05, 0xF80B0CF6);
	r0 = D(r0, s1_2_2, 0xFF08F5FD, 0x30F414FA, 0x0101142D, 0x24F70700);
	r1 = D(r1, s1_2_2, 0x05FD040C, 0x140CFAFF, 0xFBF41302, 0x1519F402);
	r2 = D(r2, s1_2_2, 0x0A00F202, 0x1BF3FDFB, 0xD00ECE08, 0x080ADC01);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFB031B00, 0x1D1FD1CD, 0xFAFD0107, 0x0CFF0509);
	r1 = D(r1, s0_0_0, 0x10F5F3FD, 0xF60FF211, 0x0207F0DF, 0x271EC9FE);
	r2 = D(r2, s0_0_0, 0x0E13E2F6, 0xFEF6F810, 0xE0082524, 0xFFFC07DF);
	r0 = D(r0, s0_0_1, 0x05F10D0A, 0x08D9F30C, 0xFCF3E910, 0xF708E50C);
	r1 = D(r1, s0_0_1, 0x0ED2DFDD, 0x020FF3F4, 0x170F07E6, 0xE2032529);
	r2 = D(r2, s0_0_1, 0xF91F14EA, 0x1701090B, 0x05E7A5FF, 0xF81006E1);
	r0 = D(r0, s0_0_2, 0xFA010103, 0x08EE0E18, 0x03FC0506, 0x0204FE05);
	r1 = D(r1, s0_0_2, 0x26F1FD0E, 0xFE0907FC, 0xF20EFBF2, 0xFC000811);
	r2 = D(r2, s0_0_2, 0xF60B02FC, 0xFEFF0DF9, 0x1BF1F91B, 0xFB040701);
	r0 = D(r0, s0_1_0, 0xE37F0881, 0x1526014B, 0xFB16F0F2, 0x11E3F61C);
	r1 = D(r1, s0_1_0, 0xF7F80EF6, 0xEFDEF169, 0xF808D6D6, 0x3122B4EA);
	r2 = D(r2, s0_1_0, 0x08B00342, 0x16F1DAF3, 0xED2D7FD4, 0xE939E923);
	r0 = D(r0, s0_1_1, 0x110FE1FF, 0x203EDDB7, 0xF1F97A37, 0x05E4152F);
	r1 = D(r1, s0_1_1, 0xE708CB77, 0x03FE2000, 0xF5E01E1C, 0x051D7B03);
	r2 = D(r2, s0_1_1, 0xEDC7265F, 0xF6BF9C81, 0xCF2EFFE0, 0xFCFC260B);
	r0 = D(r0, s0_1_2, 0x06FF07FD, 0x040004FF, 0xF81F08E1, 0xFB03FFFD);
	r1 = D(r1, s0_1_2, 0xDFF8F806, 0xF9F00C19, 0xFFF3050B, 0x0DEDF605);
	r2 = D(r2, s0_1_2, 0xF7ED080B, 0x0407FE08, 0xEB12FFFD, 0xF4FA0E06);
	r0 = D(r0, s0_2_0, 0xFDF509D9, 0x13FAF302, 0xFF000004, 0xFE14F7D5);
	r1 = D(r1, s0_2_0, 0x10F5F3FE, 0xFDF6EDF5, 0x03FD09FD, 0x04F5E029);
	r2 = D(r2, s0_2_0, 0x0E06F3FF, 0x1A18DC04, 0x0EE314F3, 0x00FDF2F8);
	r0 = D(r0, s0_2_1, 0x12FF0E10, 0xF3F0D320, 0xFF0107F9, 0xF815A7F0);
	r1 = D(r1, s0_2_1, 0xF427E1EF, 0xFAF7FDF5, 0x0004F1F8, 0xFFDE240A);
	r2 = D(r2, s0_2_1, 0x0114F5F5, 0x2841CD0A, 0xD6F85200, 0xFCF82DFF);
	r0 = D(r0, s0_2_2, 0x00FF0607, 0x0111FBFA, 0xFFFF10F8, 0x12F90908);
	r1 = D(r1, s0_2_2, 0x091BF3E1, 0xFD07FFFC, 0xFE0100FF, 0xF81602DC);
	r2 = D(r2, s0_2_2, 0x0C0BF9FD, 0xFBFB10FE, 0x100105F7, 0xF20404F8);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.241e-03, 9.716e-03, -7.409e-01, -1.818e-03);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(6.973e-03, -7.064e-03, -3.082e-02, 6.487e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(1.535e-02, 2.630e-02, -3.589e-03, 6.821e-03);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-BOX-conv2
//!HOOK LUMA
//!COMPUTE 24 8 8 8
//!BIND conv1
//!BIND LUMA
//!SAVE conv2
//!WIDTH LUMA.w 3 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0)) + vec2(0.5)) * conv1_pt)
#define l1(x, y) conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0)) + vec2(0.5)) * conv1_pt)
#define l2(x, y) conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0)) + vec2(0.5)) * conv1_pt)
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
	r0 = D(r0, s0_0_0, 0xED4FDB08, 0xF7D016F1, 0x08AE0000, 0xFCF917ED);
	r1 = D(r1, s0_0_0, 0xEE7F050B, 0xF2C0FA05, 0x04250000, 0x05C0F800);
	r2 = D(r2, s0_0_0, 0xF1C9FAFE, 0xF07F0002, 0x0E350B05, 0x182C010E);
	r0 = D(r0, s0_0_1, 0x0F0F02ED, 0x01070ADA, 0x3838E909, 0x04ECDD04);
	r1 = D(r1, s0_0_1, 0xDF1C15F3, 0xFDEDF30F, 0x0018090D, 0x1EF0FAF9);
	r2 = D(r2, s0_0_1, 0xE53D0602, 0xFB2A0612, 0xD3E41305, 0xC3D8FF31);
	r0 = D(r0, s0_0_2, 0x1FFEE8F8, 0xF21C11F6, 0xF613FAF8, 0x0BF6E403);
	r1 = D(r1, s0_0_2, 0xFE0308F5, 0xFCFD0100, 0xFB0402F6, 0x0AF6FF02);
	r2 = D(r2, s0_0_2, 0xF925031E, 0x090212F8, 0x071E02EF, 0xFCF70001);
	r0 = D(r0, s0_1_0, 0x11380BE6, 0xFA7027FB, 0x007F0A01, 0x07C0FE12);
	r1 = D(r1, s0_1_0, 0x11BDFE0A, 0x07810A07, 0xF9D60401, 0xFB7F0A01);
	r2 = D(r2, s0_1_0, 0xF8F104F5, 0xF81E0EF8, 0xFB81020A, 0xEA810809);
	r0 = D(r0, s0_1_1, 0xFACEB148, 0xFEF12ABB, 0x0E030803, 0x2851E702);
	r1 = D(r1, s0_1_1, 0x0B07F4FC, 0x12CC1510, 0x1358FE25, 0xDE262781);
	r2 = D(r2, s0_1_1, 0xDA8108ED, 0x043B0216, 0xFA12C7E8, 0xFC21EF19);
	r0 = D(r0, s0_1_2, 0x222B1315, 0x0AEDFFE6, 0xFEFAF43A, 0xF51006F8);
	r1 = D(r1, s0_1_2, 0x010A02FA, 0x0A08FF01, 0xFDEC0DF0, 0x0D1407E1);
	r2 = D(r2, s0_1_2, 0x0F41E0FE, 0x00EA0615, 0x04F81203, 0xFF080BE8);
	r0 = D(r0, s0_2_0, 0x0EF5010D, 0xF4E508F7, 0x0029FC02, 0xFF51E201);
	r1 = D(r1, s0_2_0, 0xFB2C04F9, 0xFFD206FD, 0xFC470302, 0xFD64FCF8);
	r2 = D(r2, s0_2_0, 0xFABDFE03, 0xFCFF04FC, 0xFABB00F5, 0xF4FFFD0E);
	r0 = D(r0, s0_2_1, 0x0302D307, 0x05F91C14, 0x071C02FE, 0xF5ED0DEE);
	r1 = D(r1, s0_2_1, 0xFD0CFBF9, 0x0B0E0007, 0xFE03F80C, 0x05DDFDF3);
	r2 = D(r2, s0_2_1, 0x0501ED16, 0x0613FE01, 0x0B4FF8FE, 0xF5D80521);
	r0 = D(r0, s0_2_2, 0xFD0D1DF7, 0xFCE1FC0F, 0xFCFDF4E7, 0x0AD6F3FF);
	r1 = D(r1, s0_2_2, 0x04E6FE00, 0xFF04FEFC, 0x00EEFDFB, 0x0212F5FD);
	r2 = D(r2, s0_2_2, 0x0921FD10, 0xFF0D0003, 0xF20B0007, 0x07E6F91C);
	r0 = D(r0, s1_0_0, 0x2CFE1B18, 0xFE08E1E8, 0x000802FA, 0xF408FF03);
	r1 = D(r1, s1_0_0, 0x01001501, 0x02040204, 0x0000FAFD, 0xF708FF06);
	r2 = D(r2, s1_0_0, 0x08FEF70A, 0x0904F900, 0x0C0FF2EF, 0xFEFDF9EA);
	r0 = D(r0, s1_0_1, 0x4E141C18, 0xFF06E0ED, 0xFBF40103, 0x16030C0C);
	r1 = D(r1, s1_0_1, 0x110408FC, 0x03010F05, 0xFC03FFFB, 0x070AF3FC);
	r2 = D(r2, s1_0_1, 0x090CECFB, 0x070B2105, 0xF90AFF06, 0x000505FF);
	r0 = D(r0, s1_0_2, 0xFDFEF90B, 0xF806FDFA, 0x0709F202, 0x0FFB1C17);
	r1 = D(r1, s1_0_2, 0x030002F9, 0x01010A03, 0x0302FEFE, 0xF902FFFA);
	r2 = D(r2, s1_0_2, 0x03070212, 0xF709F7FD, 0x0103FAF8, 0x050807FD);
	r0 = D(r0, s1_1_0, 0xCF070DE4, 0x0504FAB4, 0x0313F308, 0x0A14EA0C);
	r1 = D(r1, s1_1_0, 0x01F2FC00, 0x110CFF07, 0xFAFF03FD, 0xFE1A02EE);
	r2 = D(r2, s1_1_0, 0xF6FE0BFB, 0xFBF1F505, 0xFF0CF1F4, 0xF6EE1BF9);
	r0 = D(r0, s1_1_1, 0x3FCC0206, 0x11E129C0, 0xE0FB160A, 0xBC0C1DFC);
	r1 = D(r1, s1_1_1, 0xFA17E5FB, 0x030CD70C, 0x00FEF204, 0x2AF022E8);
	r2 = D(r2, s1_1_1, 0x05FFFC08, 0xF2D1F8EC, 0xEFE8260B, 0xF805F7F1);
	r0 = D(r0, s1_1_2, 0xEC07D414, 0x0618F8F8, 0xEBF103FF, 0x03F4310C);
	r1 = D(r1, s1_1_2, 0x0AFE05FF, 0xF9070003, 0x04FE36FC, 0x25F7EB06);
	r2 = D(r2, s1_1_2, 0x02F0D114, 0x0617F904, 0xF61E13FE, 0x100713FF);
	r0 = D(r0, s1_2_0, 0x240304F4, 0x00DCFEC9, 0x0A0409F3, 0x07190F04);
	r1 = D(r1, s1_2_0, 0xE905080C, 0xFAFA0101, 0x03F502F9, 0xF9F509F0);
	r2 = D(r2, s1_2_0, 0x01020B09, 0x020204FC, 0xFF0A0DE9, 0x250207F8);
	r0 = D(r0, s1_2_1, 0x028C17D8, 0x0D00F3AC, 0x03EAF905, 0xEEA21021);
	r1 = D(r1, s1_2_1, 0x000C110A, 0xF2340BF7, 0xFB0C0009, 0x1C3416E2);
	r2 = D(r2, s1_2_1, 0x094810F6, 0xF6F102F5, 0x30DAF4EE, 0xF11003F4);
	r0 = D(r0, s1_2_2, 0x0222FDFC, 0xF6F7FDF8, 0x03FB0A03, 0xEDF90A0B);
	r1 = D(r1, s1_2_2, 0xFCF5FA02, 0x050F0BFE, 0x05F9080B, 0x01E206F5);
	r2 = D(r2, s1_2_2, 0x320B0B02, 0x010703FB, 0xFD020002, 0xF92206FB);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0CDC20EA, 0xED22E117, 0xFDF30301, 0x16E206EB);
	r1 = D(r1, s0_0_0, 0xFBEA0FFB, 0xFEFCF909, 0xF8000C02, 0xFBFB1306);
	r2 = D(r2, s0_0_0, 0xFEFC1503, 0xFA15FC0C, 0xF718E805, 0xF213E4FB);
	r0 = D(r0, s0_0_1, 0xE7D7F0D3, 0xF8211615, 0x090A0CEE, 0x0FFDB9F1);
	r1 = D(r1, s0_0_1, 0xFBF4FDF7, 0x0A040804, 0x01FFEB07, 0x04081EFC);
	r2 = D(r2, s0_0_1, 0xF1110D12, 0xE7FCFF10, 0x0902EE06, 0xF3ECD20F);
	r0 = D(r0, s0_0_2, 0x1DFAB7D3, 0xF3050112, 0xFD0EEE0E, 0x08FB0EDF);
	r1 = D(r1, s0_0_2, 0x09FC0602, 0xFFFFFC03, 0x00041500, 0x120B2DFA);
	r2 = D(r2, s0_0_2, 0x00F80411, 0x09FCED05, 0xF2000F0C, 0xF4F81407);
	r0 = D(r0, s0_1_0, 0x00C8D7E9, 0xF63B4D25, 0x00011E0A, 0xEEFBC71E);
	r1 = D(r1, s0_1_0, 0x1EF1F8FB, 0x07071405, 0xF5FB0801, 0x0BF529FA);
	r2 = D(r2, s0_1_0, 0x0C0A27F4, 0xF9F9F30C, 0xF30BD41D, 0xDCFCE1F0);
	r0 = D(r0, s0_1_1, 0x12E2D9F3, 0xDD341D1F, 0xF10E03D8, 0xF703D8FF);
	r1 = D(r1, s0_1_1, 0x3105F11E, 0x18F805FE, 0x130B1A23, 0xED093ADF);
	r2 = D(r2, s0_1_1, 0xEE14FCFA, 0x3908FF27, 0x2AFEB022, 0x21F40606);
	r0 = D(r0, s0_1_2, 0x25CD0ED8, 0xFC24080F, 0x1D16FFFB, 0xFED61DEA);
	r1 = D(r1, s0_1_2, 0xF2FE0F0C, 0x0405F904, 0xF7FC1D10, 0x21F80EE9);
	r2 = D(r2, s0_1_2, 0x1A161139, 0x060811F5, 0xDA05FA09, 0xDF0817F8);
	r0 = D(r0, s0_2_0, 0xF3E2B400, 0x1530FCFA, 0xFC06EEFF, 0x12E4FCF5);
	r1 = D(r1, s0_2_0, 0x0EF60AFF, 0x0001E6FF, 0x03FD16FD, 0x0E0C26FE);
	r2 = D(r2, s0_2_0, 0x00FA07F0, 0xFB03EFFC, 0x0716E9F5, 0xF207EC01);
	r0 = D(r0, s0_2_1, 0x09070AFD, 0xE229FC16, 0xE904FC09, 0x13D627C6);
	r1 = D(r1, s0_2_1, 0x0BF410EB, 0x030AF710, 0x090009F8, 0xFCE612EB);
	r2 = D(r2, s0_2_1, 0xD7FF0D07, 0xFC02FF04, 0x0A0EE601, 0x1015F3FD);
	r0 = D(r0, s0_2_2, 0x0CE3110A, 0x0116EC06, 0x10F80709, 0xE6F011F7);
	r1 = D(r1, s0_2_2, 0xFE02FCF5, 0xFF000A07, 0xF1F801F4, 0xFB02FAFC);
	r2 = D(r2, s0_2_2, 0xEEF407E6, 0x02FE0209, 0x031915F9, 0xD7F6FA0B);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-5.176e-03, -1.097e-02, -5.423e-03, 2.234e-03);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-5.021e-03, -2.445e-03, -4.418e-03, -1.691e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-7.523e-03, -4.677e-03, -1.699e-02, 3.145e-04);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-BOX-conv3
//!HOOK LUMA
//!COMPUTE 24 8 8 8
//!BIND conv2
//!BIND LUMA
//!SAVE conv3
//!WIDTH LUMA.w 3 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv2_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0)) + vec2(0.5)) * conv2_pt)
#define l1(x, y) conv2_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0)) + vec2(0.5)) * conv2_pt)
#define l2(x, y) conv2_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0)) + vec2(0.5)) * conv2_pt)
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
	r0 = D(r0, s0_0_0, 0xEF07F90B, 0xCAFAF906, 0xF8F7FF11, 0x0EE50DE8);
	r1 = D(r1, s0_0_0, 0xF5F9FF0B, 0xE304FD08, 0xF0130402, 0xFDF801F7);
	r2 = D(r2, s0_0_0, 0x04FDFDFF, 0xFFFEFC00, 0xF4060C03, 0x06020102);
	r0 = D(r0, s0_0_1, 0x000E0AF4, 0x1A25EBE2, 0xF0E31E1F, 0xD71FDB1A);
	r1 = D(r1, s0_0_1, 0x0F34E302, 0x15FFEEEE, 0x09F51602, 0xBA110018);
	r2 = D(r2, s0_0_1, 0xF8040002, 0xFF040B00, 0xFFF8F6F7, 0xF902FCFD);
	r0 = D(r0, s0_0_2, 0x000AF3F8, 0xD7FE04FB, 0x1A020F11, 0xDEF405CC);
	r1 = D(r1, s0_0_2, 0x190F0AF7, 0x00FB07EE, 0xFBF8F50C, 0xECE910F6);
	r2 = D(r2, s0_0_2, 0x05FFFC01, 0xFFF9FA00, 0x03F90202, 0x030206FF);
	r0 = D(r0, s0_1_0, 0x080F0EFC, 0xE3F70A0D, 0x0D1A1305, 0x33EDF9D6);
	r1 = D(r1, s0_1_0, 0x0E150311, 0x02F6E41C, 0x1025F2F3, 0xFB0303ED);
	r2 = D(r2, s0_1_0, 0x0B00FF06, 0x02FC0201, 0x001103F7, 0xFC0FF804);
	r0 = D(r0, s0_1_1, 0x1103F7FD, 0x2D31DDCD, 0x2016E81C, 0xC73DD727);
	r1 = D(r1, s0_1_1, 0x0F04AD1D, 0xD104CBF3, 0x19F812FB, 0x154F14F0);
	r2 = D(r2, s0_1_1, 0x142B0FFA, 0xF2F50EF2, 0xF1EE0127, 0x2512E0F0);
	r0 = D(r0, s0_1_2, 0x0113E8E7, 0xF1F0F4E9, 0x0312DBE3, 0xFA0113C9);
	r1 = D(r1, s0_1_2, 0x01F2A5F7, 0x15FD1E00, 0xF1EC213A, 0x15FF0BB0);
	r2 = D(r2, s0_1_2, 0x04FF03F8, 0x06FD0FF9, 0x04FFF510, 0xFE05F407);
	r0 = D(r0, s0_2_0, 0x0505F9FD, 0xFA05FF09, 0xF10AFFFD, 0xF2F0F4CB);
	r1 = D(r1, s0_2_0, 0xFA0FF6FC, 0x1E030702, 0x1613EAE9, 0xF1FE04F6);
	r2 = D(r2, s0_2_0, 0xFDF10003, 0xF6F40000, 0x0A03FDFA, 0x0613FEFD);
	r0 = D(r0, s0_2_1, 0xF510F8F8, 0x00080207, 0x02000104, 0xF83112F2);
	r1 = D(r1, s0_2_1, 0xFBF808F2, 0x010615F1, 0xE42F08F5, 0xF914FDEF);
	r2 = D(r2, s0_2_1, 0xFEF90201, 0xFBFC0107, 0x0205F20B, 0xF929F904);
	r0 = D(r0, s0_2_2, 0xF7020D05, 0xFF030402, 0xFBFE04F8, 0x110EE0E9);
	r1 = D(r1, s0_2_2, 0x02F416FF, 0x0605F305, 0x09FE09F5, 0xD50BFAF7);
	r2 = D(r2, s0_2_2, 0x00F70102, 0xFFFCFA0A, 0xFE02F2FD, 0x060208EA);
	r0 = D(r0, s1_0_0, 0xE9000601, 0xE6250200, 0xFD0BFC09, 0x2BEAE4F6);
	r1 = D(r1, s1_0_0, 0x0EE7FA13, 0xF3010BFC, 0xF1F40FF8, 0xFF12F307);
	r2 = D(r2, s1_0_0, 0x0207FE03, 0x07040F00, 0xFFFAFC05, 0x0AFFF5FD);
	r0 = D(r0, s1_0_1, 0xF1F2E211, 0xEAE8C3FE, 0x16D2D9FC, 0xA00208ED);
	r1 = D(r1, s1_0_1, 0xCEB5ECFB, 0x10EAF6E6, 0x0B34F20F, 0xE102F4F9);
	r2 = D(r2, s1_0_1, 0x010FF800, 0xFB14F400, 0x14F90AFC, 0xF6EF1100);
	r0 = D(r0, s1_0_2, 0x01DA1309, 0x16FD0B04, 0x0CF90AFB, 0x0F00E2E7);
	r1 = D(r1, s1_0_2, 0xC2F40902, 0x0BFDFA15, 0x06FC090A, 0x0FF8F803);
	r2 = D(r2, s1_0_2, 0x03010200, 0x0AFC0405, 0xF90DF8F4, 0x0101F8FD);
	r0 = D(r0, s1_1_0, 0x13DBF312, 0x0E20F404, 0xF8FDE802, 0x35A700F8);
	r1 = D(r1, s1_1_0, 0xEF2ACD0B, 0x9F4708F9, 0xE3D0F9EB, 0x0602FEFB);
	r2 = D(r2, s1_1_0, 0x081D0502, 0x14040C04, 0x08E4FCFD, 0xF109FCF5);
	r0 = D(r0, s1_1_1, 0xB7EF1D1E, 0xE803E504, 0x0BFFCE42, 0x810D0C8F);
	r1 = D(r1, s1_1_1, 0xE000FA30, 0x18E9CFDE, 0xA5282135, 0x0EC9EBEB);
	r2 = D(r2, s1_1_1, 0x3BE1C6FF, 0x44EB3D0A, 0xD523373B, 0xD22F430F);
	r0 = D(r0, s1_1_2, 0xD411F641, 0xF1F8ECE3, 0xECFE0807, 0xE233EDCF);
	r1 = D(r1, s1_1_2, 0x27E30411, 0x05F805FD, 0x09EDF81E, 0xDEFB1AFD);
	r2 = D(r2, s1_1_2, 0x0CF6000C, 0x0CF90B20, 0x01FE08DF, 0xFEFFFAF9);
	r0 = D(r0, s1_2_0, 0xFC09FAFF, 0x0806FF01, 0xF4FE0105, 0xED0F1BFA);
	r1 = D(r1, s1_2_0, 0xF4E70306, 0x0CFAFB00, 0x16F6FCF0, 0xFF0806FF);
	r2 = D(r2, s1_2_0, 0x04FE0102, 0xFE01FD03, 0x04FDFBFE, 0x08FFFA01);
	r0 = D(r0, s1_2_1, 0x0CF6F909, 0x05000500, 0x10FC0DFB, 0x32EF07CC);
	r1 = D(r1, s1_2_1, 0x130912F0, 0xDDE6E716, 0x01F1E02F, 0x010807EF);
	r2 = D(r2, s1_2_1, 0x0307F708, 0xFC0D0DF5, 0xFC010108, 0x15E8F303);
	r0 = D(r0, s1_2_2, 0xFE060114, 0x0D0200FB, 0xF605F802, 0xD7ECE619);
	r1 = D(r1, s1_2_2, 0xEC14F40B, 0x14F50FFC, 0x0D051310, 0x0B05FA0D);
	r2 = D(r2, s1_2_2, 0x05FF02FF, 0x010006F2, 0x03FB0001, 0xFD06F808);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xEF04FDFB, 0xEB0BF8DF, 0x0B07EB37, 0x261601DC);
	r1 = D(r1, s0_0_0, 0x0DEAFF19, 0x0622F8E4, 0x0B10FFFB, 0x010DFD04);
	r2 = D(r2, s0_0_0, 0xFF040101, 0xFF070200, 0x03F8FC0C, 0x0200FDF9);
	r0 = D(r0, s0_0_1, 0xF517F50B, 0x2B44F9FD, 0xDEEDDEF9, 0x2B32152F);
	r1 = D(r1, s0_0_1, 0xE50D16E8, 0x12F10FF2, 0xD0D20702, 0x1B14F22B);
	r2 = D(r2, s0_0_1, 0xFE000106, 0x0F01FA0D, 0xF3F407F5, 0x09090204);
	r0 = D(r0, s0_0_2, 0xF60B01FB, 0x090A0DFE, 0x0DFA06FC, 0xE1E31408);
	r1 = D(r1, s0_0_2, 0xEA0B28FD, 0xFB0CFD02, 0xF203EBFE, 0xFDE301FC);
	r2 = D(r2, s0_0_2, 0x02FB04FD, 0xFFFB02FD, 0x0C03FF05, 0x0500FE03);
	r0 = D(r0, s0_1_0, 0x12FE0014, 0xFDFDFA14, 0xF702020F, 0x37071B17);
	r1 = D(r1, s0_1_0, 0xFD16FB20, 0xEA12EEC6, 0x1716ECE6, 0xFAF40DFD);
	r2 = D(r2, s0_1_0, 0xEFFC08EF, 0xF9F7F912, 0x050CFF0B, 0xF30DF4FD);
	r0 = D(r0, s0_1_1, 0xD60219E5, 0x16292717, 0x091237FB, 0xC6FA27D3);
	r1 = D(r1, s0_1_1, 0x0FF9142F, 0x31354EEF, 0x001EFA2D, 0x0C13FBEE);
	r2 = D(r2, s0_1_1, 0x13F81608, 0x1908F4FB, 0x04020F04, 0x1817FC01);
	r0 = D(r0, s0_1_2, 0x0005180B, 0x0A002206, 0x0C030705, 0x11240E06);
	r1 = D(r1, s0_1_2, 0x09F1E3FE, 0xFB15FDFC, 0xB7D5DDF5, 0xFE142BFE);
	r2 = D(r2, s0_1_2, 0xFDFC07FF, 0x01020DFE, 0x06FCFEFA, 0x06FFEFF8);
	r0 = D(r0, s0_2_0, 0xFB03FD07, 0x0008FBFF, 0x01FC0704, 0xF3FCF106);
	r1 = D(r1, s0_2_0, 0x0AFD0BEE, 0x0A0BF816, 0xFD14FCCC, 0x01FE0408);
	r2 = D(r2, s0_2_0, 0x01FC0A06, 0xFBF80709, 0x0602FCFC, 0x0907F6FA);
	r0 = D(r0, s0_2_1, 0x050BE5F7, 0xFE0CF804, 0xFB01FAF2, 0x121B0FF5);
	r1 = D(r1, s0_2_1, 0xF2F7FBF6, 0x19F50A14, 0x0225E6EC, 0xFE0003E8);
	r2 = D(r2, s0_2_1, 0xFAF62603, 0xFBEFE30B, 0xF304FB06, 0x101BEBF5);
	r0 = D(r0, s0_2_2, 0xE8FDEAFE, 0x0204FAFD, 0x11050201, 0x1E30DA0E);
	r1 = D(r1, s0_2_2, 0x05F80203, 0xF902ED07, 0xE003FEF9, 0xFF12EAFD);
	r2 = D(r2, s0_2_2, 0xFFFE0A00, 0xFD0600FF, 0x07FB00FD, 0x03FD0704);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-4.892e-03, -5.832e-03, -1.337e-02, -1.045e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.038e-02, -1.065e-02, 2.326e-03, -3.699e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-3.306e-03, 1.937e-02, -2.528e-03, -9.180e-03);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-BOX-conv4
//!HOOK LUMA
//!COMPUTE 24 8 8 8
//!BIND conv3
//!BIND LUMA
//!SAVE conv4
//!WIDTH LUMA.w 3 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv3_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0)) + vec2(0.5)) * conv3_pt)
#define l1(x, y) conv3_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0)) + vec2(0.5)) * conv3_pt)
#define l2(x, y) conv3_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0)) + vec2(0.5)) * conv3_pt)
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
	r0 = D(r0, s0_0_0, 0x1CF2E6F5, 0x03F9FF08, 0xE3FD0EFE, 0xFC01FB08);
	r1 = D(r1, s0_0_0, 0xF9FF00FD, 0x04FEFF03, 0x011807F1, 0xFEFEFD01);
	r2 = D(r2, s0_0_0, 0x110101FE, 0xE8FEFD08, 0x0205FEFF, 0x0F0500F6);
	r0 = D(r0, s0_0_1, 0xFB00FD03, 0xE105FBF1, 0x101809E3, 0xEC0703EC);
	r1 = D(r1, s0_0_1, 0xF3FFF711, 0x00000005, 0xF3FCEF08, 0x0504FFFF);
	r2 = D(r2, s0_0_1, 0xFC0509F6, 0x310B02FD, 0xFC00FA1B, 0xFE0307FE);
	r0 = D(r0, s0_0_2, 0x0309EC14, 0xDE0B01F2, 0x11E90209, 0xEC080102);
	r1 = D(r1, s0_0_2, 0xF600FF03, 0xFFFE0100, 0xEC07F100, 0xFFFF01FF);
	r2 = D(r2, s0_0_2, 0xFDFF0001, 0xFD130CF9, 0x0B060500, 0xFEFEFC05);
	r0 = D(r0, s0_1_0, 0x08FA0A0E, 0xF40802DE, 0x08FF040F, 0xEBFDF9F8);
	r1 = D(r1, s0_1_0, 0xCF06052B, 0x260F0606, 0x0DFDEBFC, 0x0D040505);
	r2 = D(r2, s0_1_0, 0x04F7F803, 0xDA080FAE, 0xEB06F304, 0x0D080B04);
	r0 = D(r0, s0_1_1, 0xE505E813, 0x18FDFB4A, 0x03D7091B, 0x010DF6EE);
	r1 = D(r1, s0_1_1, 0x041B0E32, 0x5609F419, 0xF304EA10, 0x3F09FD21);
	r2 = D(r2, s0_1_1, 0x3A0D000C, 0x28120020, 0xFD23EAF9, 0xD91823C7);
	r0 = D(r0, s0_1_2, 0xFA070EFC, 0xF0E714C6, 0xFB1E03E3, 0xEAF21302);
	r1 = D(r1, s0_1_2, 0xEDF9000B, 0xF9FE01FA, 0xFDFAFC01, 0x0B000402);
	r2 = D(r2, s0_1_2, 0xFFFCFF01, 0xEE0B13FC, 0xDC07CD26, 0x0BFEEB05);
	r0 = D(r0, s0_2_0, 0x240AE2FC, 0xF6F6F20A, 0xFFFF0807, 0x02F806F6);
	r1 = D(r1, s0_2_0, 0x0BF7F216, 0xF404FFFF, 0xFD0007F4, 0xFE02FD00);
	r2 = D(r2, s0_2_0, 0x0100F610, 0xF10A121A, 0x05FD0413, 0xF80E03EA);
	r0 = D(r0, s0_2_1, 0xFE05F308, 0xF6E3ECD1, 0x0AF5FAF4, 0xEEE5EE09);
	r1 = D(r1, s0_2_1, 0xFA21031A, 0x00021304, 0x250FFFFB, 0xFB040AFA);
	r2 = D(r2, s0_2_1, 0xCF432913, 0x11C9FBD3, 0xEDBC1D2A, 0x10D84D1E);
	r0 = D(r0, s0_2_2, 0xE307FCF9, 0xEAF30E10, 0xFDF90BFC, 0x06F3F8F9);
	r1 = D(r1, s0_2_2, 0x02F6FE04, 0xF90104FE, 0x0FDBF911, 0xFC000300);
	r2 = D(r2, s0_2_2, 0xF4FBEEF9, 0xDD09F60D, 0xFFC1342A, 0x0B05EAF8);
	r0 = D(r0, s1_0_0, 0xF3E30FFE, 0xFFFE0306, 0x06F3F1FB, 0x15FC0506);
	r1 = D(r1, s1_0_0, 0xD31002F9, 0x0601FFFC, 0xF3FF05DB, 0x010101FD);
	r2 = D(r2, s1_0_0, 0xF9020001, 0x04FC08FD, 0x0A040603, 0xF9FF02FB);
	r0 = D(r0, s1_0_1, 0x03EF0BF9, 0x07F8FD0F, 0x11E8FED7, 0xEDF90200);
	r1 = D(r1, s1_0_1, 0xFD12F9FA, 0xFF060102, 0x00F40E02, 0xFF02FDFE);
	r2 = D(r2, s1_0_1, 0x0500F9FC, 0xD607F7EC, 0x26FB07FD, 0x07F7FB04);
	r0 = D(r0, s1_0_2, 0xE902000D, 0xEBED0500, 0x07F30813, 0xF206FB08);
	r1 = D(r1, s1_0_2, 0xFD2102F3, 0x0104FD00, 0x07F70A18, 0x01040201);
	r2 = D(r2, s1_0_2, 0xFEFC0802, 0x030E0206, 0xFE0EFD13, 0xFD020AFF);
	r0 = D(r0, s1_1_0, 0xF308F9E7, 0xFBF8000E, 0xE800FAFC, 0xE8F90201);
	r1 = D(r1, s1_1_0, 0x5CF3FB06, 0x0103FDF0, 0x0009FD04, 0x0600FFF5);
	r2 = D(r2, s1_1_0, 0x0A040801, 0xFEEEF7FA, 0x050302F6, 0x0CF8FEF2);
	r0 = D(r0, s1_1_1, 0x0BF7F3F2, 0xFE0020C4, 0x36060D1A, 0x44FD0716);
	r1 = D(r1, s1_1_1, 0x4DD5BF1C, 0x03F73822, 0x0A050AF9, 0xFBFC0C29);
	r2 = D(r2, s1_1_1, 0x0C02EDFF, 0xF5A10ADB, 0xBF0B18B8, 0xEF1E05FC);
	r0 = D(r0, s1_1_2, 0xFC04FFED, 0xF90BDE4F, 0xFB0E30F2, 0xEDEEFB15);
	r1 = D(r1, s1_1_2, 0xF8ECF90A, 0x0208F9FE, 0xF80705FD, 0x03061301);
	r2 = D(r2, s1_1_2, 0x00020B01, 0xEA291901, 0xFD271CE8, 0x06E8110D);
	r0 = D(r0, s1_2_0, 0x1AEB12E6, 0x00030705, 0xFC00FF09, 0xEB07FC0D);
	r1 = D(r1, s1_2_0, 0xD0FF04FF, 0xFEFEFE10, 0xE6F607FF, 0xFE00FF08);
	r2 = D(r2, s1_2_0, 0xF0FC01FB, 0xCFE7F0EA, 0x0505F90B, 0x1100FEEF);
	r0 = D(r0, s1_2_1, 0xEEFAE020, 0xDEF6EE46, 0x04FAFAF6, 0xE4FCFE0E);
	r1 = D(r1, s1_2_1, 0xD01421F2, 0x0DFF0105, 0xEC1302FF, 0x0C0100FF);
	r2 = D(r2, s1_2_1, 0x1008E71E, 0x0ADD0A05, 0x1DF4E46D, 0xEEF6F211);
	r0 = D(r0, s1_2_2, 0x202116FB, 0xE9001413, 0xF60202F8, 0x16FF0C07);
	r1 = D(r1, s1_2_2, 0x0BF8F609, 0x02FE03FD, 0x080504FE, 0x00FE02FD);
	r2 = D(r2, s1_2_2, 0x0FEA0DFE, 0xF1050AFE, 0x1BDDD30F, 0x080515FA);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xEDDEF3FB, 0x00FF01FE, 0x12FEF605, 0x00F606F1);
	r1 = D(r1, s0_0_0, 0xF8070CFE, 0x08020201, 0xC106DAFE, 0x0300FFFF);
	r2 = D(r2, s0_0_0, 0xFE0407FF, 0x051104FD, 0x07F808FF, 0x00020006);
	r0 = D(r0, s0_0_1, 0xDC17EA0C, 0x0FE106F5, 0x0F260BBB, 0x07F90203);
	r1 = D(r1, s0_0_1, 0xFF0E011A, 0x1FFDFB00, 0xCDF3EAFF, 0x0603FE01);
	r2 = D(r2, s0_0_1, 0xF508FEFF, 0x190ADA23, 0x0BF8ECF3, 0x0AF700EF);
	r0 = D(r0, s0_0_2, 0xF0EEE0EE, 0x071BFFF8, 0x0711E905, 0x1301FEF7);
	r1 = D(r1, s0_0_2, 0xEA1203FD, 0x03000202, 0xDAFCDF0B, 0x010100FF);
	r2 = D(r2, s0_0_2, 0xFF060204, 0x0FFB17E5, 0x0DD70511, 0x03FAF907);
	r0 = D(r0, s0_1_0, 0xF1FBF4F9, 0x08FD09FD, 0xFEEA0BFA, 0xFE09100D);
	r1 = D(r1, s0_1_0, 0x2CEFDDE7, 0x0FFEFF0A, 0xBB03E5F0, 0xFDFFF8FE);
	r2 = D(r2, s0_1_0, 0x01090403, 0xF6211401, 0xFC03FCFF, 0xFB03FE0A);
	r0 = D(r0, s0_1_1, 0xD80BC9F0, 0x0836CDF0, 0xDF18EE05, 0x2A1ED7BA);
	r1 = D(r1, s0_1_1, 0x34D5DC8E, 0xDE1ADA2E, 0xC7E8E1FA, 0x231E1BE7);
	r2 = D(r2, s0_1_1, 0x4FDED713, 0x113281BD, 0x0230F0C1, 0x21DF19BA);
	r0 = D(r0, s0_1_2, 0xE2F5D60F, 0x26CF0510, 0x01EA11E4, 0x050BEB1E);
	r1 = D(r1, s0_1_2, 0x0CF9F106, 0x020101FE, 0xB5FCE2E6, 0x0100FFF9);
	r2 = D(r2, s0_1_2, 0x1408FC09, 0xE70C1AF7, 0xFF31F8D5, 0x0905FC05);
	r0 = D(r0, s0_2_0, 0xC6FDEA05, 0xE91110FF, 0x02F90003, 0xFA0002FB);
	r1 = D(r1, s0_2_0, 0xF0F8130D, 0xFE05FAFF, 0xD2F5D6FD, 0xFD0103FF);
	r2 = D(r2, s0_2_0, 0xF604FFF9, 0x05F0FA2F, 0xFFEB02F4, 0xFC12F5F9);
	r0 = D(r0, s0_2_1, 0xC704D0F6, 0x1F01E300, 0x030EFF01, 0x0202FC11);
	r1 = D(r1, s0_2_1, 0xE5FE07F4, 0x0109FD04, 0xC80BC5EE, 0x0100FF00);
	r2 = D(r2, s0_2_1, 0xEE12F11C, 0x2E29E2D3, 0xFEE70C12, 0x010303EE);
	r0 = D(r0, s0_2_2, 0xC7E9D9F5, 0x080AF4F9, 0xFE0401FC, 0x09FA03FA);
	r1 = D(r1, s0_2_2, 0xFE010203, 0xFF01FFFF, 0xE5F4EB03, 0xFE0202FE);
	r2 = D(r2, s0_2_2, 0x0B08FEF5, 0xF60EFEF9, 0xE917D402, 0xF70305FB);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.065e-01, 3.767e-03, -4.631e-03, 1.679e-03);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-3.856e-04, 9.002e-03, -8.794e-02, -4.406e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(1.083e-02, 1.213e-02, -1.491e-03, -4.598e-03);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-BOX-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv4
//!BIND LUMA
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 1
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv4_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0)) + vec2(0.5)) * conv4_pt)
#define l1(x, y) conv4_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0)) + vec2(0.5)) * conv4_pt)
#define l2(x, y) conv4_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0)) + vec2(0.5)) * conv4_pt)
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[3][10][10];
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
	ivec4 r0;
	vec4 f0;
	r0 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x02020812, 0xFEFEF709, 0xFEFFFE0E, 0x000000F7);
	r0 = D(r0, s0_0_1, 0x0102F9EF, 0x05FD05ED, 0x00010015, 0xFDFF0306);
	r0 = D(r0, s0_0_2, 0xFE0001F3, 0xFE01FE00, 0x020000EF, 0xFF00FFF8);
	r0 = D(r0, s0_1_0, 0x04F1D6DB, 0x070213FE, 0x140A1321, 0xFAFD0DE4);
	r0 = D(r0, s0_1_1, 0x140E04FA, 0xC5F1172E, 0xEDFD002E, 0x2206DBD5);
	r0 = D(r0, s0_1_2, 0x02000021, 0x02FCFF30, 0x0201001A, 0xFD01020A);
	r0 = D(r0, s0_2_0, 0x08080205, 0x07FBFD17, 0xE30B01E7, 0x04FCFCF3);
	r0 = D(r0, s0_2_1, 0xFF050006, 0x04FDFF12, 0x0721FDF3, 0xF1CC06E7);
	r0 = D(r0, s0_2_2, 0x000000F5, 0xFF020008, 0x02000019, 0xFEFF0106);
	r0 = D(r0, s1_0_0, 0xFEEFFF03, 0x011000FF, 0x020601FE, 0xFF1F0000);
	r0 = D(r0, s1_0_1, 0xFC01FD01, 0x01EC0000, 0x02E4FFFE, 0x040000FD);
	r0 = D(r0, s1_0_2, 0x000A0101, 0xFF1EFE01, 0x000001FF, 0x000500FF);
	r0 = D(r0, s1_1_0, 0xF5F501F6, 0xFE180006, 0xF2E3FE07, 0x02FE00FF);
	r0 = D(r0, s1_1_1, 0xE9F040DB, 0xCD0903D2, 0xE6D6142A, 0xD40A0625);
	r0 = D(r0, s1_1_2, 0x03F1FF03, 0x06FC0DF8, 0x01F402FE, 0x05F50307);
	r0 = D(r0, s1_2_0, 0x01030000, 0x01F20001, 0x00D80102, 0xFFF900FE);
	r0 = D(r0, s1_2_1, 0x0006FBFC, 0x0006FFFC, 0xFFD31207, 0xFC110105);
	r0 = D(r0, s1_2_2, 0x001D0000, 0x02F5FC00, 0xFF1301FE, 0x00190AFF);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x030C01FB, 0x00FE02FF, 0xFCFCFD01, 0x00FF00FF);
	r0 = D(r0, s0_0_1, 0xF7FC0DFF, 0xFA10F11F, 0x0CFEFFF5, 0x01FD02FF);
	r0 = D(r0, s0_0_2, 0x0000FD00, 0x02FC0A01, 0x0001FE00, 0xFF0003FF);
	r0 = D(r0, s0_1_0, 0x0320F8FE, 0x000D0100, 0x0CD30204, 0xFEF8FFFD);
	r0 = D(r0, s0_1_1, 0xE60921EF, 0x301DE605, 0xBEFD2E0D, 0x24D4D622);
	r0 = D(r0, s0_1_2, 0x00000000, 0xFCFFFFFC, 0x02FEFBFF, 0x05020900);
	r0 = D(r0, s0_2_0, 0x00FFFF01, 0x00FF0300, 0xFF03F6FE, 0x01030400);
	r0 = D(r0, s0_2_1, 0xFDFEFC02, 0x00FE0202, 0xFE0302F9, 0x070303FE);
	r0 = D(r0, s0_2_2, 0x01000000, 0x00000101, 0xFE010000, 0x0101FEFD);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-2.635e-08, -2.986e-08, -2.988e-08, -2.728e-08);
	f0 = tanh(f0);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(f0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(f0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(f0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(f0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
