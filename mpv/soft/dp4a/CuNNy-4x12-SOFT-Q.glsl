// CuNNy 4x12 SOFT (dp4a)
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


//!DESC CuNNy-4x12-SOFT-in
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
	r0 += V4(2.322e-02, -1.334e-02, -3.813e-01, 7.910e-03) * s0_0_0;
	r1 += V4(5.275e-01, 4.515e-03, -1.155e-02, -1.005e-02) * s0_0_0;
	r2 += V4(6.457e-03, -2.327e-01, 1.199e-02, 8.356e-03) * s0_0_0;
	r0 += V4(-2.629e-02, 9.310e-03, 2.420e-01, 2.029e-02) * s0_0_1;
	r1 += V4(-5.410e-01, -2.006e-02, -2.862e-02, 1.862e-02) * s0_0_1;
	r2 += V4(9.178e-01, 4.564e-01, 9.718e-01, 5.527e-01) * s0_0_1;
	r0 += V4(-5.596e-03, -2.557e-03, 9.555e-02, -3.055e-02) * s0_0_2;
	r1 += V4(3.034e-02, 4.269e-03, 6.556e-02, -3.897e-02) * s0_0_2;
	r2 += V4(-9.238e-01, -1.487e-02, 2.676e-02, -1.692e-02) * s0_0_2;
	r0 += V4(-2.434e-02, -8.784e-01, 1.569e-01, -2.853e-02) * s0_1_0;
	r1 += V4(-5.235e-01, -3.186e-02, 2.751e-02, -1.664e-02) * s0_1_0;
	r2 += V4(-1.066e-02, -8.471e-02, -1.319e-02, -2.474e-03) * s0_1_0;
	r0 += V4(5.137e-01, 8.809e-01, -2.154e-01, 6.148e-01) * s0_1_1;
	r1 += V4(2.204e-01, -9.160e-01, -1.003e+00, -1.794e-01) * s0_1_1;
	r2 += V4(4.694e-02, -2.050e-02, -9.473e-01, -5.840e-01) * s0_1_1;
	r0 += V4(-7.205e-03, 2.723e-03, 6.471e-02, -2.853e-01) * s0_1_2;
	r1 += V4(2.836e-01, -2.596e-02, 4.541e-01, -3.645e-02) * s0_1_2;
	r2 += V4(-3.672e-02, -5.897e-02, -4.198e-02, -5.657e-02) * s0_1_2;
	r0 += V4(-3.135e-02, -9.858e-03, 1.565e-01, 4.558e-03) * s0_2_0;
	r1 += V4(1.898e-02, 2.736e-02, 4.620e-03, 2.843e-02) * s0_2_0;
	r2 += V4(4.234e-03, -4.465e-03, 2.688e-03, 4.187e-02) * s0_2_0;
	r0 += V4(-4.582e-01, 9.960e-03, -1.802e-01, -1.242e-01) * s0_2_1;
	r1 += V4(3.098e-01, 9.331e-01, 1.831e-01, 5.111e-01) * s0_2_1;
	r2 += V4(-1.963e-03, 5.862e-02, -2.674e-02, -2.304e-02) * s0_2_1;
	r0 += V4(-6.111e-02, -5.471e-05, 1.940e-02, -7.496e-02) * s0_2_2;
	r1 += V4(-3.271e-01, 2.240e-02, 1.412e-01, -3.351e-01) * s0_2_2;
	r2 += V4(-3.684e-03, -4.067e-02, 1.415e-02, -1.691e-02) * s0_2_2;
	r0 += V4(-2.169e-03, -2.010e-07, -2.248e-02, 8.771e-03);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-5.858e-03, -4.679e-06, -1.530e-02, -3.276e-03);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(-1.539e-04, -7.213e-03, -1.678e-04, -1.016e-03);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-4x12-SOFT-conv1
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
			vec4 v0 = l0(x - 1, y - 1);
			vec4 v1 = l1(x - 1, y - 1);
			vec4 v2 = l2(x - 1, y - 1);
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
	r0 = D(r0, s0_0_0, 0xD60501D3, 0xCD05EC8C, 0xE401F7DC, 0x03130CF5);
	r1 = D(r1, s0_0_0, 0xB1000ABE, 0xEBFB00D3, 0x01F3FFA3, 0x10FAFCFA);
	r2 = D(r2, s0_0_0, 0x29F9DB1F, 0x3E0A1AEE, 0x1002FE1F, 0xFD150319);
	r0 = D(r0, s0_0_1, 0xD207F0FA, 0xF40C090E, 0x16FFE403, 0xE2091381);
	r1 = D(r1, s0_0_1, 0xFF05EEB8, 0xD50D012F, 0xEEF820BB, 0x0CFF06F8);
	r2 = D(r2, s0_0_1, 0xFFF5437F, 0xF5062BDF, 0x0AE3BBB4, 0x03DCFA7F);
	r0 = D(r0, s0_0_2, 0xED07110A, 0xF4021711, 0x0D14C410, 0x171EE981);
	r1 = D(r1, s0_0_2, 0xEC002DE9, 0x31F0FBE9, 0xE602F05F, 0xFEFC100C);
	r2 = D(r2, s0_0_2, 0x2EFE1EDC, 0xE8230B25, 0xE728CC30, 0xCD3B191D);
	r0 = D(r0, s0_1_0, 0xF102030F, 0x4C04EC7F, 0xC0170BC5, 0x9BFC00D2);
	r1 = D(r1, s0_1_0, 0x000906B2, 0xE10C09E5, 0x39000DD9, 0xA80B08BD);
	r2 = D(r2, s0_1_0, 0xCF091EE6, 0xF5F3DC2D, 0x5D17F857, 0x3600F2C1);
	r0 = D(r0, s0_1_1, 0x7F100DF3, 0xD0E281D5, 0xA012F821, 0x6205C443);
	r1 = D(r1, s0_1_1, 0x6FF2FCC6, 0xEA1B02E9, 0x7EB6D80F, 0x76000F09);
	r2 = D(r2, s0_1_1, 0xFB1781A6, 0xB9F2EEDD, 0xB4121EAE, 0x0D35811B);
	r0 = D(r0, s0_1_2, 0xF7041CD8, 0x08EC119E, 0x58C7E145, 0xCCE8811D);
	r1 = D(r1, s0_1_2, 0x10E8B643, 0x1BF94C46, 0xEFF910B0, 0x13F71C15);
	r2 = D(r2, s0_1_2, 0x0DDCB07F, 0x1ADC2612, 0x0D2DFBE0, 0xC4A65134);
	r0 = D(r0, s0_2_0, 0x05FA0003, 0xE815FB06, 0x18FA050D, 0x321CFEF7);
	r1 = D(r1, s0_2_0, 0xE002040A, 0x0FEFFE04, 0xE1010CFF, 0xF4050604);
	r2 = D(r2, s0_2_0, 0x2FE0F123, 0x0EF70309, 0x0A0DF903, 0x21F20DE7);
	r0 = D(r0, s0_2_1, 0x0E0805F4, 0x2633B608, 0x1EDB18D2, 0x0A1B170A);
	r1 = D(r1, s0_2_1, 0x16221404, 0x25FC02EE, 0xB8FFE028, 0xCDF8EC10);
	r2 = D(r2, s0_2_1, 0xD214EFC5, 0x1915EEFE, 0xD222EA0C, 0x181BF723);
	r0 = D(r0, s0_2_2, 0x04FC0801, 0xFD11D2EC, 0xFBF5130B, 0x16F7FBE0);
	r1 = D(r1, s0_2_2, 0xF320FEFE, 0xE4EC0205, 0xF2E50109, 0xFD070707);
	r2 = D(r2, s0_2_2, 0xD5142123, 0xE90907F0, 0xF70D0B00, 0x10F4F6D8);
	r0 = D(r0, s1_0_0, 0xFC1C0900, 0xDE33E702, 0x1E10EE0C, 0xFB08FE09);
	r1 = D(r1, s1_0_0, 0x00380A0B, 0x0B13F1FC, 0x0FFF0005, 0x0CFC0200);
	r2 = D(r2, s1_0_0, 0x51D7CC03, 0xD1E5E603, 0xAFC6EBFF, 0x7F81AB14);
	r0 = D(r0, s1_0_1, 0x000E2004, 0xF2F6100D, 0x81108104, 0x18200204);
	r1 = D(r1, s1_0_1, 0x210CF31B, 0xE61935FB, 0x1B20E926, 0x06FEFBFF);
	r2 = D(r2, s1_0_1, 0x18133E32, 0x0BF6E5FB, 0xE20E81EC, 0x81038113);
	r0 = D(r0, s1_0_2, 0x00090FFE, 0xF70C17F9, 0x0A15D0DD, 0xFAF20113);
	r1 = D(r1, s1_0_2, 0x1D04260F, 0xFCF1ED03, 0xFA030E13, 0x00010605);
	r2 = D(r2, s1_0_2, 0x2106BD1A, 0xF5FDFEF8, 0xED02F6FD, 0xE5FF2110);
	r0 = D(r0, s1_1_0, 0x0C14FD01, 0x5A01B7F7, 0xD9261F15, 0xD836E205);
	r1 = D(r1, s1_1_0, 0xC4051F08, 0xFB1806FC, 0x00E60306, 0xFC37F101);
	r2 = D(r2, s1_1_0, 0xC9073EFB, 0xF3D7F306, 0x4F97EAF2, 0xF40CE80A);
	r0 = D(r0, s1_1_1, 0x06A70804, 0xFB1E1C0D, 0x070EEA2B, 0xB6238124);
	r1 = D(r1, s1_1_1, 0x06819BEA, 0x04BB1D09, 0x2BC7DFEC, 0xF5A92002);
	r2 = D(r2, s1_1_1, 0x291F06D9, 0xFB002016, 0xFB222242, 0x0AD61913);
	r0 = D(r0, s1_1_2, 0x03FF08FF, 0x01F32E04, 0x0FF9EEEC, 0x011BF50A);
	r1 = D(r1, s1_1_2, 0x0C020CEF, 0x0018F11E, 0x0EF9DD15, 0xFEF8F907);
	r2 = D(r2, s1_1_2, 0xF2F4E139, 0x1AFBF603, 0xF9ED0908, 0x3129F524);
	r0 = D(r0, s1_2_0, 0xFEFE0201, 0x0F09F6F4, 0x12010202, 0x09D80210);
	r1 = D(r1, s1_2_0, 0xF211FD0D, 0x09FF04FE, 0x0815F704, 0x0B1600FA);
	r2 = D(r2, s1_2_0, 0x11F7EB2A, 0x230CEEE7, 0xE4F20B12, 0x17D003F9);
	r0 = D(r0, s1_2_1, 0xFAF30601, 0x1F03FEF5, 0xF6F7002A, 0x16F2091D);
	r1 = D(r1, s1_2_1, 0x05FE02EF, 0x03F9FF20, 0x0321F81B, 0x0B1DF2F1);
	r2 = D(r2, s1_2_1, 0xBFEE2B78, 0x2011F6F9, 0x1315EE0D, 0x16F50903);
	r0 = D(r0, s1_2_2, 0xFDFF01FF, 0x090504F6, 0xE8F310FE, 0xEAFE110B);
	r1 = D(r1, s1_2_2, 0x09FEFD00, 0xF8040502, 0xFA07F206, 0xFF0AF908);
	r2 = D(r2, s1_2_2, 0x1413EF04, 0xF106030B, 0x100C03E8, 0xD40D1200);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xF108FA05, 0xFE04FAFE, 0x39DF0CF0, 0xF601F604);
	r1 = D(r1, s0_0_0, 0xE80A03FC, 0xFD010209, 0xF7FA04F8, 0x020003FF);
	r2 = D(r2, s0_0_0, 0x18DB08F8, 0xF607FEFE, 0x22EFFEFF, 0x9E3B18F4);
	r0 = D(r0, s0_0_1, 0xEC0FF805, 0xF702F708, 0xF911EC07, 0x0106FDFC);
	r1 = D(r1, s0_0_1, 0xE211FCFE, 0xF206F506, 0xE00F2200, 0x00FD0BFF);
	r2 = D(r2, s0_0_1, 0xCC38F3F8, 0xF5F4060F, 0x0DF806FE, 0x76C62BD7);
	r0 = D(r0, s0_0_2, 0x0206FD00, 0xF90DF0FF, 0x1EED0001, 0x06FDF5FF);
	r1 = D(r1, s0_0_2, 0x0400FB04, 0x000110FF, 0xF509FEFE, 0x07FCFD01);
	r2 = D(r2, s0_0_2, 0x40CD1F05, 0x21EBEE03, 0x13E90101, 0xE31FC510);
	r0 = D(r0, s0_1_0, 0x1E03051E, 0x711F49F9, 0x0F3802D4, 0x03F6EDE1);
	r1 = D(r1, s0_1_0, 0x2D19DA2D, 0x0D16F206, 0x4517F503, 0xF30CFBFA);
	r2 = D(r2, s0_1_0, 0xE10132EE, 0x31F8BAB2, 0x11C820DC, 0x5E0EECD4);
	r0 = D(r0, s0_1_1, 0xF0210113, 0xFAF705FE, 0xC8053CB7, 0x7F81F004);
	r1 = D(r1, s0_1_1, 0x81E3E8E2, 0xD108010D, 0x24E20215, 0x07FBF2F4);
	r2 = D(r2, s0_1_1, 0xC8B8CA18, 0x0C2B17D4, 0x09481800, 0x8181BD81);
	r0 = D(r0, s0_1_2, 0xEF060908, 0xDC0B1207, 0x2FBA09EE, 0x7FE6F902);
	r1 = D(r1, s0_1_2, 0x09EF03FD, 0x17F001EF, 0x9918050B, 0xFAFE05FD);
	r2 = D(r2, s0_1_2, 0x211AD1EE, 0xE0FD2C02, 0xEA160F08, 0x10E94409);
	r0 = D(r0, s0_2_0, 0xFF00F903, 0xB6E03B07, 0x4B08E530, 0x230C0881);
	r1 = D(r1, s0_2_0, 0x42EFF6B8, 0x22FFF91A, 0x2003BFCC, 0x3021F02A);
	r2 = D(r2, s0_2_0, 0x7F9103EB, 0xFFDE5449, 0xD0FB0C04, 0x7FE3F5DD);
	r0 = D(r0, s0_2_1, 0x0FF2FC0F, 0x9881DC02, 0xBF3BAB81, 0xCF0834E4);
	r1 = D(r1, s0_2_1, 0x54E71BD5, 0xF812010A, 0xF8D30F2C, 0xE82DFFEF);
	r2 = D(r2, s0_2_1, 0x4481000D, 0xD70BEB24, 0x160AE033, 0xB781FB81);
	r0 = D(r0, s0_2_2, 0x1FFAF704, 0x3DF1CC04, 0xE9D454DD, 0xF00AE412);
	r1 = D(r1, s0_2_2, 0xC6EB2BED, 0xC3FA2BFB, 0x36100C0E, 0xEB050AFC);
	r2 = D(r2, s0_2_2, 0xA11610F8, 0xE00BE704, 0x230AE205, 0xC2FAE717);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-SOFT-conv2
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
	ivec2 opos = pos * ivec2(3, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1);
			vec4 v1 = l1(x - 1, y - 1);
			vec4 v2 = l2(x - 1, y - 1);
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
	r0 = D(r0, s0_0_0, 0x0203F904, 0x030506FC, 0x0B02FD06, 0xF508FCEA);
	r1 = D(r1, s0_0_0, 0x02E8EAF0, 0x0929120B, 0x02EEFA25, 0x1BF7FC06);
	r2 = D(r2, s0_0_0, 0x10070300, 0x050EF50C, 0x0C0711FD, 0x31A79EE5);
	r0 = D(r0, s0_0_1, 0x09000000, 0xF9FF0A05, 0xFA060308, 0xC0190700);
	r1 = D(r1, s0_0_1, 0x1BC700FC, 0x190124DA, 0x09F1F1FE, 0x10EA021C);
	r2 = D(r2, s0_0_1, 0x2AC630F8, 0x1A091DF8, 0x0D0BC933, 0x05812A14);
	r0 = D(r0, s0_0_2, 0x0C030BFD, 0x01FD0303, 0x02FC07F5, 0x05F412FE);
	r1 = D(r1, s0_0_2, 0x03EE0301, 0x14F8E1D3, 0x09100108, 0xFDE7F6F1);
	r2 = D(r2, s0_0_2, 0x16FA03F7, 0x0400FD06, 0x0DFAF2FA, 0x100823C7);
	r0 = D(r0, s0_1_0, 0xFEFE0BFE, 0xFFFE00F7, 0x13D5105A, 0xC20005C7);
	r1 = D(r1, s0_1_0, 0x1EE5EB1A, 0x2ACBF2EA, 0x01040744, 0x0901F50B);
	r2 = D(r2, s0_1_0, 0x1812EDD6, 0xFA0CF8C3, 0x0402F7E6, 0x0D25AAE2);
	r0 = D(r0, s0_1_1, 0xCC07F4B0, 0xD8F80BE1, 0xD2F32FD1, 0xE007DD44);
	r1 = D(r1, s0_1_1, 0xC7DCDBEC, 0x81FA28B6, 0xA3FF0E90, 0x8106EBC1);
	r2 = D(r2, s0_1_1, 0x2714E3CF, 0x28F5EDF8, 0xE5F6F3B6, 0xBF502B25);
	r0 = D(r0, s0_1_2, 0x0512DA26, 0x060AFFFD, 0xFEFE06EF, 0x12F3E2F8);
	r1 = D(r1, s0_1_2, 0xF7FB0FEA, 0x23F309CE, 0x0C04FC0C, 0x08EBE9FB);
	r2 = D(r2, s0_1_2, 0x0E0D21F7, 0xFD0AED0E, 0x020402EC, 0xF30D1FCF);
	r0 = D(r0, s0_2_0, 0x0001FC03, 0x02030508, 0x10F1F3FD, 0x0003F9FB);
	r1 = D(r1, s0_2_0, 0x0BF900F0, 0x05060500, 0x00050808, 0x0EF8F3FB);
	r2 = D(r2, s0_2_0, 0x0A070C05, 0xFAF202E2, 0xFEFE0402, 0x0A1927F1);
	r0 = D(r0, s0_2_1, 0x02000DF7, 0x0AF4003D, 0x06EF09F3, 0x0DF7D4E8);
	r1 = D(r1, s0_2_1, 0x03FEFB09, 0x09020111, 0x02FEFF12, 0x13C9F407);
	r2 = D(r2, s0_2_1, 0x06050106, 0x03F0FCDF, 0xFE060305, 0xD4F8EAF7);
	r0 = D(r0, s0_2_2, 0x08041013, 0x0B090B05, 0x030102F7, 0x0AD6E7F0);
	r1 = D(r1, s0_2_2, 0x0AF2EDF4, 0x080E06F2, 0x06F7F50A, 0x0CB9C1DA);
	r2 = D(r2, s0_2_2, 0x05FFFD02, 0x0301FA08, 0x03060302, 0xC2182AFB);
	r0 = D(r0, s1_0_0, 0xFDFF00FD, 0x03FE04FF, 0xEF0701FD, 0x090B0E10);
	r1 = D(r1, s1_0_0, 0xDBF6080B, 0xE414FEED, 0xFE03E1F6, 0xEFFD05F6);
	r2 = D(r2, s1_0_0, 0xF903FCF9, 0x091402F8, 0x0A010501, 0x181E03F8);
	r0 = D(r0, s1_0_1, 0x030101FE, 0xFAFE0304, 0xE402F0F4, 0xE4F909F2);
	r1 = D(r1, s1_0_1, 0x211215F6, 0x042FD516, 0x2801F1FD, 0x1402FEF4);
	r2 = D(r2, s1_0_1, 0xCB101601, 0x15FE15EC, 0x4D0FF0E4, 0x0D030DF9);
	r0 = D(r0, s1_0_2, 0x0A000108, 0x03FEFDF8, 0x08050408, 0x06000A07);
	r1 = D(r1, s1_0_2, 0xEDFC18FE, 0x0A27FE2F, 0x04FAF7F9, 0x1505010D);
	r2 = D(r2, s1_0_2, 0xEC0B0802, 0xDAFA0809, 0x120AFFFC, 0xF62D4C03);
	r0 = D(r0, s1_1_0, 0xFC030803, 0xF3020805, 0x0D18E3E3, 0xF3EC2803);
	r1 = D(r1, s1_1_0, 0xF1221403, 0x07182C10, 0xFEFBE6FD, 0xFA202A09);
	r2 = D(r2, s1_1_0, 0xF8FAEB2D, 0x03040A03, 0x00FD0BF5, 0xF30D1F02);
	r0 = D(r0, s1_1_1, 0xF404230F, 0x91EB0115, 0xDF1611EF, 0xEEE83AE2);
	r1 = D(r1, s1_1_1, 0x110AF8D9, 0xE5F7F9BD, 0xC72ECB15, 0xD8DD27F5);
	r2 = D(r2, s1_1_1, 0x1A27C622, 0xC410F147, 0xFE00F3CA, 0xE1E907F1);
	r0 = D(r0, s1_1_2, 0x27E7EB21, 0xEEFEFE04, 0xFC0EFDFF, 0xFC04FB0E);
	r1 = D(r1, s1_1_2, 0xEE0D1412, 0xEC18F32B, 0x16FFF1F6, 0xE40BFC35);
	r2 = D(r2, s1_1_2, 0xED021612, 0x17F3EA12, 0xF708FF08, 0xE72229EA);
	r0 = D(r0, s1_2_0, 0x03FDFB02, 0x0302EF0F, 0x03000405, 0x0500F90C);
	r1 = D(r1, s1_2_0, 0xFAF5110B, 0x08FAF106, 0xFF0D0700, 0x00F1EA08);
	r2 = D(r2, s1_2_0, 0xF4010A02, 0x0B170119, 0xFF02FE04, 0xFAFF1AEE);
	r0 = D(r0, s1_2_1, 0x00F2FC09, 0x0A00F82C, 0xFF070D07, 0x0204FA0E);
	r1 = D(r1, s1_2_1, 0xFCED0C0B, 0xFF13012A, 0x0510FE09, 0xF900F431);
	r2 = D(r2, s1_2_1, 0x0AEDFFFD, 0xE714FA1C, 0x01FCFC0D, 0xF6F5EDD0);
	r0 = D(r0, s1_2_2, 0x08F8F50C, 0x05000113, 0xFE06FC06, 0xF90C0C1A);
	r1 = D(r1, s1_2_2, 0xFD0E0C0A, 0x020BF31D, 0x0DF5FAF5, 0xF6171609);
	r2 = D(r2, s1_2_2, 0xFFFD0808, 0x0001F3FC, 0x00FEFD03, 0xF7F9F911);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFF0003FE, 0xFFFF0003, 0x0102F9FD, 0x05FB0416);
	r1 = D(r1, s0_0_0, 0x0A0CEAF3, 0xF9000719, 0x0209F803, 0xFD06F3EE);
	r2 = D(r2, s0_0_0, 0xFD0DF6EE, 0x0301FE0A, 0x07FEFE10, 0xD6FCC9BE);
	r0 = D(r0, s0_0_1, 0x05010FFD, 0x03F707FD, 0x010AFD09, 0x040FF107);
	r1 = D(r1, s0_0_1, 0x0613E505, 0xFE07132B, 0x05FA0513, 0xFD0707F3);
	r2 = D(r2, s0_0_1, 0x01E81E01, 0x06FA1C10, 0xF2FC0C02, 0xDBCFF215);
	r0 = D(r0, s0_0_2, 0x03F00A04, 0x02FE0606, 0x00FEFF03, 0x0618F103);
	r1 = D(r1, s0_0_2, 0x0015EDE9, 0xFCEC0911, 0xFFF3FC06, 0x0714FFFD);
	r2 = D(r2, s0_0_2, 0xF50DFAF1, 0x090B050D, 0x010006FC, 0x04F9B7CB);
	r0 = D(r0, s0_1_0, 0x04FBFD04, 0x01010003, 0xF109FE02, 0x081DDC00);
	r1 = D(r1, s0_1_0, 0x0514E0E6, 0xFD01FD13, 0x10FA0607, 0x0218E8E9);
	r2 = D(r2, s0_1_0, 0xFBF203FA, 0xFA000D23, 0x090FFBFD, 0x81F2A9BE);
	r0 = D(r0, s0_1_1, 0x0CFC0800, 0x0EFA0D09, 0xF6000E05, 0xEA09BDEB);
	r1 = D(r1, s0_1_1, 0x0540EDF7, 0x0A121FE9, 0x2BE10319, 0x171FECE2);
	r2 = D(r2, s0_1_1, 0xEB25DF15, 0x2532211B, 0xFB0A1FFE, 0xEA0DFD06);
	r0 = D(r0, s0_1_2, 0x02F7070B, 0x0406FD07, 0x0504FF05, 0xF90D000A);
	r1 = D(r1, s0_1_2, 0x042ADCF2, 0x08E70705, 0x0DE10617, 0x0806F2F1);
	r2 = D(r2, s0_1_2, 0xFB2208F5, 0xF9F01200, 0xFF0E00FB, 0xFE45D9E9);
	r0 = D(r0, s0_2_0, 0x02FC0B03, 0xFFED0706, 0xF2040A01, 0xFD1EF3FC);
	r1 = D(r1, s0_2_0, 0xF20AF2F0, 0x03EE3405, 0x0BFA0503, 0xFE0B11FB);
	r2 = D(r2, s0_2_0, 0xFEFFF8F8, 0x0809000B, 0x04000203, 0xEFD3FEFA);
	r0 = D(r0, s0_2_1, 0x08F20709, 0x01D6FA18, 0x030B0504, 0xFD02FA07);
	r1 = D(r1, s0_2_1, 0x061A00F4, 0x0D05040C, 0x1CF5F005, 0x061BCEFC);
	r2 = D(r2, s0_2_1, 0x08110DF8, 0x10F10908, 0x0509FB04, 0xEA0553FF);
	r0 = D(r0, s0_2_2, 0x05FA0302, 0x03FC00FF, 0x01FE0501, 0x0B01F300);
	r1 = D(r1, s0_2_2, 0x0919F103, 0x09CC0B18, 0x0AF3F00F, 0xFF28E5E4);
	r2 = D(r2, s0_2_2, 0x01090603, 0x00DB070E, 0x04020300, 0xF41A21DF);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-SOFT-conv3
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
#define l0(x, y) (conv2_mul * texelFetch(conv2_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0), 0))
#define l1(x, y) (conv2_mul * texelFetch(conv2_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0), 0))
#define l2(x, y) (conv2_mul * texelFetch(conv2_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0), 0))
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
			vec4 v0 = l0(x - 1, y - 1);
			vec4 v1 = l1(x - 1, y - 1);
			vec4 v2 = l2(x - 1, y - 1);
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
	r0 = D(r0, s0_0_0, 0x00FEFB00, 0xFF06020E, 0xFA020906, 0xFBFE0008);
	r1 = D(r1, s0_0_0, 0x03000D06, 0xFF020B06, 0xFB050909, 0x0201040B);
	r2 = D(r2, s0_0_0, 0x0300FCF3, 0x0205F91C, 0xFBFD040A, 0x08FEFDF1);
	r0 = D(r0, s0_0_1, 0x031A1F04, 0xFF0B1406, 0xFDF5D1F4, 0xF6010206);
	r1 = D(r1, s0_0_1, 0xF5F40F03, 0xFE00420C, 0x0902E7DB, 0x0B030A00);
	r2 = D(r2, s0_0_1, 0x050604E4, 0x03F2EFFE, 0x01F80013, 0xFC060BFF);
	r0 = D(r0, s0_0_2, 0xF700F6FA, 0xF5FE0802, 0xFE06FF00, 0xF5F90202);
	r1 = D(r1, s0_0_2, 0xF4E70CFA, 0x0B020B02, 0xF9E9D4ED, 0x03070302);
	r2 = D(r2, s0_0_2, 0x0BFDFEFB, 0x00FAFFFC, 0xF6F8F3FC, 0x0B000404);
	r0 = D(r0, s0_1_0, 0x0405F4FE, 0xF9080112, 0xF7010904, 0xFDF8F7F8);
	r1 = D(r1, s0_1_0, 0x030805F0, 0x04010602, 0x07040702, 0x01FB09F8);
	r2 = D(r2, s0_1_0, 0x050B0F15, 0xF908F844, 0xECFA0203, 0x02FB100A);
	r0 = D(r0, s0_1_1, 0x020FFDFE, 0x04FDEDFA, 0x09F6E420, 0x18E606E9);
	r1 = D(r1, s0_1_1, 0x302430D4, 0x18EBCEDE, 0x1C05EE21, 0xF9F4EAC5);
	r2 = D(r2, s0_1_1, 0xFDF9E712, 0xF206FAF9, 0xF0D4E9E7, 0x420AEA1B);
	r0 = D(r0, s0_1_2, 0x0E48F802, 0x012D1CFB, 0xFE360305, 0xFAFEFA00);
	r1 = D(r1, s0_1_2, 0x170F1BFF, 0xF6E6FEFF, 0xDFB402E7, 0x1F1617FC);
	r2 = D(r2, s0_1_2, 0xF6FDFD06, 0xFD04F802, 0xF80DF700, 0x04EEFFFF);
	r0 = D(r0, s0_2_0, 0x0105FEFF, 0xFAFBFF02, 0xFCFC02FE, 0xFC0306ED);
	r1 = D(r1, s0_2_0, 0xF70B0705, 0xFFFEFD03, 0xFE030008, 0x01FC02F0);
	r2 = D(r2, s0_2_0, 0x01F4FAE1, 0x05FAFC07, 0xFAFBFEF5, 0x03FCFE10);
	r0 = D(r0, s0_2_1, 0x020B04F1, 0x0B130111, 0xFCFEFFF3, 0x0705FEF4);
	r1 = D(r1, s0_2_1, 0xEFEF0402, 0x03FD02FF, 0x0D050C01, 0xF7FB02C8);
	r2 = D(r2, s0_2_1, 0x1700FFE4, 0xFA030204, 0xFB03FEF7, 0x0E04F9FD);
	r0 = D(r0, s0_2_2, 0x0509FC05, 0xE4FD09FF, 0x00110002, 0x040B0000);
	r1 = D(r1, s0_2_2, 0xFAF70602, 0x08FBFDF7, 0x060EFBFF, 0x0DFC03EF);
	r2 = D(r2, s0_2_2, 0x120705FA, 0x03FDFD02, 0x0DFDFFFE, 0x0E03FDFD);
	r0 = D(r0, s1_0_0, 0xFCFEFF00, 0xF0FCF6FF, 0xF9FEF608, 0xFF03FE06);
	r1 = D(r1, s1_0_0, 0xF301FCFF, 0xF8FD0304, 0xFF01F4FB, 0xFC00FE01);
	r2 = D(r2, s1_0_0, 0xFDFEFE00, 0xFB01F901, 0xFB030705, 0x0109FB00);
	r0 = D(r0, s1_0_1, 0xF1F6F7FF, 0xF4FDF701, 0x10FDF7F6, 0xFD020409);
	r1 = D(r1, s1_0_1, 0xEF080313, 0xFCFDFC0F, 0x3108F6EB, 0x010406FA);
	r2 = D(r2, s1_0_1, 0x08F6F5ED, 0x0404F0FA, 0xF2070405, 0xF302F80E);
	r0 = D(r0, s1_0_2, 0x07080403, 0xF0060300, 0xF9FEF904, 0xFB02FF04);
	r1 = D(r1, s1_0_2, 0xF7FFF704, 0xFC0002FE, 0xE21C0FF4, 0xFE04FC08);
	r2 = D(r2, s1_0_2, 0xF8FD05F4, 0xFF0605FD, 0x0B0C0CFB, 0x04F8F102);
	r0 = D(r0, s1_1_0, 0xFFFB04F2, 0xF501F408, 0xFBFEF804, 0x09FB01FE);
	r1 = D(r1, s1_1_0, 0x13EAE8E8, 0xFF03EF09, 0xFBFE0704, 0x0C0206FB);
	r2 = D(r2, s1_1_0, 0xE9F4F008, 0xFCFAF902, 0xF00D0710, 0xE809ED15);
	r0 = D(r0, s1_1_1, 0xE3D2DD1B, 0xF0D705ED, 0xE7F1FA09, 0xFEF302FB);
	r1 = D(r1, s1_1_1, 0x15B3D1D8, 0x15E809F7, 0x0DDF0EDC, 0x24F7DEE4);
	r2 = D(r2, s1_1_1, 0xEBCEEE15, 0xFDF5FC09, 0x08620D09, 0x0DCBF8D9);
	r0 = D(r0, s1_1_2, 0x0E13F9E2, 0xDFF2F9F0, 0x0F02ED0E, 0xFB01F50F);
	r1 = D(r1, s1_1_2, 0xF4F703F3, 0xFBFEEA0C, 0x02EED720, 0xF3FDFB00);
	r2 = D(r2, s1_1_2, 0xF6F3F808, 0x0601FCFB, 0x0A021BEE, 0xEBE1FC12);
	r0 = D(r0, s1_2_0, 0xFE03F7FD, 0xF40AFC05, 0x0502FB07, 0xFA02F8FD);
	r1 = D(r1, s1_2_0, 0xDBF8F2FE, 0x0503F9FE, 0xFDFEF007, 0xF20C0F06);
	r2 = D(r2, s1_2_0, 0x0E0FFBF6, 0x07FF0101, 0x0DFF0CFC, 0x05FCF909);
	r0 = D(r0, s1_2_1, 0x01FBF600, 0xF3F1FFEA, 0x0600F5FE, 0x0909F817);
	r1 = D(r1, s1_2_1, 0xE9E80609, 0x030200F5, 0x01FEF2FF, 0xDE06F6E1);
	r2 = D(r2, s1_2_1, 0x0911EEED, 0xFB04F1FD, 0x0C0006ED, 0xF4EEF1F3);
	r0 = D(r0, s1_2_2, 0xF70004FB, 0xE6E4E204, 0x0101FBFD, 0x07FDF7E7);
	r1 = D(r1, s1_2_2, 0xFEE9F802, 0x090C03FA, 0x04FDFBFA, 0x090205FD);
	r2 = D(r2, s1_2_2, 0xFA04FAEE, 0x030302FC, 0xFB031001, 0x1004FA01);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x03FF0101, 0x0C03FF01, 0x09FEFF01, 0x08FEFFFB);
	r1 = D(r1, s0_0_0, 0x110400FF, 0x0B0400FC, 0x0701FEF3, 0x080103FD);
	r2 = D(r2, s0_0_0, 0x04FFFE01, 0x0A00FBFF, 0x05010708, 0x0AFB0004);
	r0 = D(r0, s0_0_1, 0x0904FB0E, 0xFE04FF02, 0x08FBF703, 0x0A0102F9);
	r1 = D(r1, s0_0_1, 0x0DFCF005, 0x14FDF5FC, 0x09F2EF03, 0x0500FB06);
	r2 = D(r2, s0_0_1, 0xFA030407, 0xFEFBF8FF, 0x03FB050B, 0x06FF0200);
	r0 = D(r0, s0_0_2, 0xF9FBFB03, 0x04FF0200, 0x040002FC, 0xFFFDFFF8);
	r1 = D(r1, s0_0_2, 0x0CFA0903, 0x0B01F5FA, 0xFE050FFA, 0x08FDFE06);
	r2 = D(r2, s0_0_2, 0xF9090106, 0xFCFD0103, 0x00FF0503, 0x0903FE00);
	r0 = D(r0, s0_1_0, 0xFA000508, 0x01040105, 0x0DF907FB, 0x00FBF3FF);
	r1 = D(r1, s0_1_0, 0x060C0803, 0x07FDFE00, 0x0BFC0BF7, 0x0B0100FE);
	r2 = D(r2, s0_1_0, 0x110F0809, 0x0415FD0A, 0x07F60500, 0x10E602F7);
	r0 = D(r0, s0_1_1, 0x0CFBE0EF, 0x07F8DF05, 0x0A10F920, 0x02EED61A);
	r1 = D(r1, s0_1_1, 0x05F6DCDC, 0x00F0FBFE, 0x160E084F, 0xFEF10B0F);
	r2 = D(r2, s0_1_1, 0x0C0FD9EC, 0xFBE200F9, 0x01EBF8FF, 0xFA10D5F0);
	r0 = D(r0, s0_1_2, 0xDE02F2FE, 0xF8FF020E, 0xFFFEF2FA, 0xFBFCF30A);
	r1 = D(r1, s0_1_2, 0xF404F2F0, 0xFDF3FBF2, 0x10CD140A, 0x09090414);
	r2 = D(r2, s0_1_2, 0x140AEE02, 0xFE000307, 0xFAFFF917, 0x04F501EE);
	r0 = D(r0, s0_2_0, 0xFF020103, 0x08FD01F5, 0x08F90602, 0x0018FC06);
	r1 = D(r1, s0_2_0, 0x00090000, 0xFFF400FE, 0x0903FD05, 0xFA030201);
	r2 = D(r2, s0_2_0, 0xF8F4F906, 0x04F1F9F5, 0xFFF50E05, 0x0DE70400);
	r0 = D(r0, s0_2_1, 0x050201FC, 0xF721FC0C, 0x030AF6FD, 0x0536F9EC);
	r1 = D(r1, s0_2_1, 0x06FB0D01, 0xFF0D0206, 0x071BFE06, 0x0295FC28);
	r2 = D(r2, s0_2_1, 0xE44F07E1, 0x0101F9FA, 0xFD12080F, 0xFB160DF4);
	r0 = D(r0, s0_2_2, 0xDFF8FAF8, 0xFBFF05FC, 0x06F5FAF9, 0xFD1CF201);
	r1 = D(r1, s0_2_2, 0x0006F6F2, 0xFBF30706, 0x0402FAFF, 0xFDFA1511);
	r2 = D(r2, s0_2_2, 0xD8120CF1, 0xFEFEFE03, 0xF2FC0A04, 0x06F50403);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-SOFT-conv4
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
#define l0(x, y) (conv3_mul * texelFetch(conv3_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0), 0))
#define l1(x, y) (conv3_mul * texelFetch(conv3_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0), 0))
#define l2(x, y) (conv3_mul * texelFetch(conv3_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0), 0))
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
			vec4 v0 = l0(x - 1, y - 1);
			vec4 v1 = l1(x - 1, y - 1);
			vec4 v2 = l2(x - 1, y - 1);
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
	r0 = D(r0, s0_0_0, 0xF9FCFA02, 0xFE040004, 0xFF04FCFF, 0x000101FF);
	r1 = D(r1, s0_0_0, 0xFF0304FF, 0x020004FC, 0xFFFBF704, 0x06FCF800);
	r2 = D(r2, s0_0_0, 0x0301F205, 0x01FB04FD, 0x1603E815, 0x2707E41A);
	r0 = D(r0, s0_0_1, 0x00FB1FFB, 0xE4150407, 0x0000FD01, 0xFF000200);
	r1 = D(r1, s0_0_1, 0x49FE0408, 0xDBFDFA04, 0x0102FA04, 0x0D1F14BB);
	r2 = D(r2, s0_0_1, 0xFE06FFFD, 0x060300FE, 0xB20408F4, 0xF0090CFF);
	r0 = D(r0, s0_0_2, 0xFD02F3FF, 0xFD0C0EF3, 0xFE0100FF, 0x0000FF00);
	r1 = D(r1, s0_0_2, 0x05FF0305, 0x04000203, 0xF3041204, 0xC9EDEA22);
	r2 = D(r2, s0_0_2, 0xFCFBFF02, 0xFF0000FF, 0x0300FF00, 0x05000001);
	r0 = D(r0, s0_1_0, 0xFA112000, 0x05DDDE0C, 0x3A021900, 0xFF000100);
	r1 = D(r1, s0_1_0, 0x03FD07FE, 0xFDC007F5, 0x0203FC03, 0x0011FFFC);
	r2 = D(r2, s0_1_0, 0xF90406FE, 0xFF13D023, 0x06F90717, 0x0CF1FE31);
	r0 = D(r0, s0_1_1, 0xD51942E3, 0xFE2A1122, 0x1201F405, 0x36090208);
	r1 = D(r1, s0_1_1, 0xF70FFC36, 0x051C0334, 0x030956DD, 0x06220006);
	r2 = D(r2, s0_1_1, 0xE2EC21F9, 0xF3000B00, 0x0CF70412, 0x0B0500F8);
	r0 = D(r0, s0_1_2, 0x0BFEE810, 0x030716F5, 0x05000100, 0x06FFFF02);
	r1 = D(r1, s0_1_2, 0x0407FEF6, 0xFF0203F9, 0xB7F9F517, 0x09FBF804);
	r2 = D(r2, s0_1_2, 0x07FEE00A, 0xFF01FF00, 0x00FD0104, 0x01FF0101);
	r0 = D(r0, s0_2_0, 0xFA2307EA, 0xF9040F04, 0xFDE0F60F, 0x010900F9);
	r1 = D(r1, s0_2_0, 0x0106FEFB, 0x02F9FBFE, 0x03FEFB00, 0x02FEFD03);
	r2 = D(r2, s0_2_0, 0x01FBF806, 0x07C4061A, 0xFFFFFF05, 0xFE05FF02);
	r0 = D(r0, s0_2_1, 0x07DB080A, 0xE91402FE, 0xFBF4060B, 0x0AB1F444);
	r1 = D(r1, s0_2_1, 0x01FFFC06, 0xFF02FE07, 0x0736F3EB, 0xFF0200FE);
	r2 = D(r2, s0_2_1, 0xF80C07E5, 0x03030104, 0x01020101, 0x00040001);
	r0 = D(r0, s0_2_2, 0xFBF50106, 0xFB1404F3, 0x01FFFF01, 0xFD030504);
	r1 = D(r1, s0_2_2, 0x03010103, 0x05010201, 0x02EDFC1C, 0xFB040100);
	r2 = D(r2, s0_2_2, 0x03FB04FC, 0x00FFFE01, 0x01FF0101, 0x00FF0101);
	r0 = D(r0, s1_0_0, 0xED0506FE, 0xEFFC0401, 0x02FEFEFF, 0xFF020100);
	r1 = D(r1, s1_0_0, 0x01FF02F9, 0xFDFE00FC, 0x04FE0001, 0xF9FFFE07);
	r2 = D(r2, s1_0_0, 0x08FD02FC, 0xF600FE02, 0xEFEB0710, 0xE5F809F1);
	r0 = D(r0, s1_0_1, 0xBF03F513, 0xC702FEFC, 0x07FD0103, 0xFD00FF03);
	r1 = D(r1, s1_0_1, 0xF4050100, 0x04FEFF06, 0xFC010401, 0x14E20FE2);
	r2 = D(r2, s1_0_1, 0xE804FEFF, 0xFC00FE05, 0xF0FC00E0, 0xF0FB07D1);
	r0 = D(r0, s1_0_2, 0x0B080706, 0xEA05F907, 0x01FFFEFE, 0xFF010000);
	r1 = D(r1, s1_0_2, 0xF50200F7, 0xFB0101FC, 0xEB0201FD, 0xEDECB116);
	r2 = D(r2, s1_0_2, 0xFCFD0608, 0x00010200, 0x00FF020A, 0xFE000106);
	r0 = D(r0, s1_1_0, 0x0ADDEB15, 0xF20EFD06, 0xACFBFBEE, 0xFC000002);
	r1 = D(r1, s1_1_0, 0x0601F800, 0xFEFFFF0A, 0xF702FF0A, 0x0204F804);
	r2 = D(r2, s1_1_0, 0x09E60600, 0xC2E1FA09, 0x02E90800, 0xF8F0E215);
	r0 = D(r0, s1_1_1, 0xBC09A5E1, 0xE6140B2E, 0xF9F9FF09, 0xCDFE05DB);
	r1 = D(r1, s1_1_1, 0xFAF205E8, 0x04F5F9FF, 0x27EBFAF9, 0x07EBF605);
	r2 = D(r2, s1_1_1, 0xDC09D82E, 0xF5030900, 0x00F9310F, 0xFBFA0537);
	r0 = D(r0, s1_1_2, 0x06FAFF09, 0xC206F70B, 0xFD030002, 0xF4FEFD04);
	r1 = D(r1, s1_1_2, 0xFCF9F813, 0xFBFBF905, 0xE4FFE819, 0x16F70900);
	r2 = D(r2, s1_1_2, 0x1EFA1021, 0x01FEFF01, 0xFEFF0602, 0x00FF0208);
	r0 = D(r0, s1_2_0, 0x07F107F2, 0xE2FCF704, 0xDB0AED12, 0x01FD03FD);
	r1 = D(r1, s1_2_0, 0xFFFC0002, 0xFF01FF04, 0x000602FE, 0x03FD01FF);
	r2 = D(r2, s1_2_0, 0x04FE04FB, 0x03E01A03, 0x000000FE, 0x00010300);
	r0 = D(r0, s1_2_1, 0xF4FED701, 0xC40CDF20, 0x02030DFA, 0xF2A5D116);
	r1 = D(r1, s1_2_1, 0x020101FE, 0xFEFDFCF4, 0x0ADB11FE, 0x01F90302);
	r2 = D(r2, s1_2_1, 0x0EFA4FAE, 0x01010903, 0x0001FD01, 0xFF03FAFD);
	r0 = D(r0, s1_2_2, 0xFF02E7F4, 0xDB070316, 0x00010301, 0x01031E04);
	r1 = D(r1, s1_2_2, 0x01FF0102, 0x02F10303, 0x02F5F4E3, 0xFC01FDFC);
	r2 = D(r2, s1_2_2, 0xFBF9D6EA, 0x00FF0302, 0x01FF01FE, 0x010000FF);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFB01FD0D, 0x01DE0104, 0x040100FE, 0x000000FE);
	r1 = D(r1, s0_0_0, 0xFE02FFFE, 0xFF000001, 0x00FE0105, 0xFEFB02FF);
	r2 = D(r2, s0_0_0, 0x04FA0308, 0x06FE04FB, 0xF5010312, 0xF2040323);
	r0 = D(r0, s0_0_1, 0x15F111EB, 0x0BBCFB04, 0x01000201, 0x00FFFE00);
	r1 = D(r1, s0_0_1, 0x09FF0812, 0xFF02FEFE, 0xFD00FE03, 0x03F5FB1E);
	r2 = D(r2, s0_0_1, 0x030B0400, 0x040101FF, 0xFE03FC46, 0xFEFF1144);
	r0 = D(r0, s0_0_2, 0xF90908FD, 0x0AEBF305, 0x0000FD03, 0x00020201);
	r1 = D(r1, s0_0_2, 0x02FE0300, 0xF9FE0002, 0xFFFD02FF, 0x31CDFD36);
	r2 = D(r2, s0_0_2, 0x04FA0206, 0xFF0003FF, 0x05FF04FC, 0x02FF03FD);
	r0 = D(r0, s0_1_0, 0xF6F7FCEF, 0x06BBF809, 0x05FB0113, 0xFF0200FD);
	r1 = D(r1, s0_1_0, 0x00FFFE04, 0xFD01FB01, 0x010101F9, 0xFB010002);
	r2 = D(r2, s0_1_0, 0x000CF8FC, 0xDE0BFF23, 0x010000FC, 0xF0FD05FB);
	r0 = D(r0, s0_1_1, 0x5A04E421, 0x248F0219, 0x0AF907FC, 0xF9FF0824);
	r1 = D(r1, s0_1_1, 0xE6F8F80E, 0x12F40602, 0x08EEECF6, 0xF3FF04FC);
	r2 = D(r2, s0_1_1, 0x24D2F806, 0x0BF83107, 0x0CFE03F6, 0x4E03EBF5);
	r0 = D(r0, s0_1_2, 0xEEE101FB, 0x0ED4BBF9, 0xFD0001FA, 0x0AFC09F7);
	r1 = D(r1, s0_1_2, 0x1904F7FF, 0x02040002, 0x20E3E233, 0x00FAE7FA);
	r2 = D(r2, s0_1_2, 0xF6F80D06, 0x02FFFF00, 0xFFFF19FF, 0x03FF1702);
	r0 = D(r0, s0_2_0, 0xDEE80403, 0x0AF0F2FC, 0x0F050006, 0x00FDFE04);
	r1 = D(r1, s0_2_0, 0xFCFE0102, 0x0000FF02, 0xFEFC0102, 0x03010200);
	r2 = D(r2, s0_2_0, 0xFBF60A00, 0x11FB04FB, 0xFF0001FF, 0x05010000);
	r0 = D(r0, s0_2_1, 0x19FCFEEC, 0x05BF02F7, 0xFBFC5906, 0x0B06FEE2);
	r1 = D(r1, s0_2_1, 0x0103FBFE, 0xF503FC00, 0xF5E90A06, 0x01F80002);
	r2 = D(r2, s0_2_1, 0x06DB0105, 0xF70228FD, 0x00FF00FE, 0x00FF0500);
	r0 = D(r0, s0_2_2, 0xF9EC040C, 0x000801F7, 0xFF000200, 0xF8FD5B06);
	r1 = D(r1, s0_2_2, 0x01FEFCFC, 0x01FDF4FD, 0xFFE5E6FE, 0x03FE0304);
	r2 = D(r2, s0_2_2, 0xE8FEFD03, 0x0000FE00, 0x00FFFEFF, 0x00FFFF00);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-SOFT-out-shuffle
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
#define l0(x, y) V4((conv4_mul * texelFetch(conv4_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0), 0)))
#define l1(x, y) V4((conv4_mul * texelFetch(conv4_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0), 0)))
#define l2(x, y) V4((conv4_mul * texelFetch(conv4_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0), 0)))
shared V4 G[3][10][10];
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
			G[2][ay][ax] = l2(x - 1, y - 1);
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
	r0 += M4(8.381e-03, -5.337e-04, -9.637e-03, 2.370e-04, -3.788e-02, -7.526e-03, -2.010e-02, 2.584e-03, -5.980e-06, -6.376e-06, 2.881e-04, -4.844e-06, 5.442e-02, -2.618e-03, 5.506e-02, -3.089e-03) * s0_0_0;
	r0 += M4(-1.519e-01, 3.500e-03, 1.139e-02, -4.555e-03, -7.608e-02, -9.172e-02, -8.467e-02, -7.249e-02, 2.588e-01, -1.100e-02, 1.444e-01, -8.324e-05, 4.199e-02, -9.560e-01, 7.323e-03, 1.141e-01) * s0_0_1;
	r0 += M4(-2.762e-03, -2.367e-02, 2.233e-03, -2.144e-03, 4.594e-04, -2.394e-02, 5.215e-03, -1.114e-02, -6.538e-03, 5.193e-01, -5.215e-02, 8.818e-02, 8.528e-04, 2.690e-02, -3.972e-06, 5.147e-03) * s0_0_2;
	r0 += M4(4.089e-02, 2.765e-03, 5.188e-02, 3.472e-03, -1.266e-02, -2.785e-02, -2.285e-02, -3.300e-02, -7.237e-07, -5.050e-06, -2.955e-04, 2.069e-05, -3.212e-03, 3.406e-03, 3.792e-02, -2.581e-03) * s0_1_0;
	r0 += M4(-1.351e-01, 2.158e-01, -5.752e-01, 9.589e-02, 2.222e-01, 1.703e-01, 1.753e-01, 1.255e-01, 8.627e-04, -1.064e-03, 7.367e-02, -1.149e-03, -3.564e-03, -3.291e-03, 1.948e-03, -1.282e-02) * s0_1_1;
	r0 += M4(2.775e-03, -5.529e-02, -1.788e-04, -2.666e-02, -2.559e-02, 2.714e-03, -4.446e-02, -8.291e-03, 3.263e-03, -6.336e-03, 1.997e-01, 2.229e-01, 3.700e-04, -2.392e-03, -8.699e-04, 2.948e-02) * s0_1_2;
	r0 += M4(-2.865e-04, -2.977e-05, 1.682e-02, 8.777e-04, -6.114e-04, -5.408e-04, -1.016e-02, -7.532e-03, -1.440e-07, 9.155e-07, 2.887e-06, 5.509e-08, -2.590e-05, 8.857e-06, 2.010e-04, 1.499e-04) * s0_2_0;
	r0 += M4(-3.860e-04, -4.749e-03, 3.747e-02, 4.636e-02, -1.657e-03, -1.134e-02, 1.239e-02, 9.712e-03, 7.930e-07, -5.469e-06, -9.479e-06, -3.160e-07, 2.889e-05, -1.613e-05, -2.628e-05, 4.986e-04) * s0_2_1;
	r0 += M4(1.210e-03, -1.006e-03, -3.222e-04, -3.006e-02, 7.282e-04, -1.978e-03, -4.794e-04, -6.402e-03, -4.035e-06, 1.094e-05, -1.851e-04, -3.224e-04, 1.356e-06, -1.393e-08, 3.265e-05, -3.021e-04) * s0_2_2;
	r0 += M4(1.373e-03, -8.676e-04, 1.236e-04, 2.623e-04, 6.814e-02, 1.823e-02, 4.164e-04, 3.275e-04, 1.607e-01, 1.338e-02, -7.112e-03, -2.358e-03, -4.494e-03, -3.196e-04, -4.995e-04, -2.058e-04) * s1_0_0;
	r0 += M4(-1.103e-02, -2.700e-04, -5.051e-04, -2.087e-04, -3.135e-03, 5.636e-02, 1.259e-03, 1.324e-03, 2.192e-03, 5.323e-02, -2.679e-04, -3.847e-03, -6.637e-05, 1.071e-04, 5.012e-05, -1.936e-04) * s1_0_1;
	r0 += M4(-1.252e-03, -1.260e-03, -1.463e-04, -4.087e-04, 9.170e-04, -6.782e-04, 3.729e-04, 1.390e-03, -2.714e-04, 8.577e-04, -1.332e-04, -6.069e-04, -2.919e-05, -1.657e-05, -6.048e-06, 2.733e-06) * s1_0_2;
	r0 += M4(-1.386e-01, -2.206e-03, -1.812e-01, 1.075e-02, -9.003e-02, -1.747e-02, -2.738e-02, -4.402e-03, -8.890e-02, -2.316e-01, 6.133e-01, -1.119e-01, -5.315e-02, -4.190e-02, 6.775e-03, -2.593e-03) * s1_1_0;
	r0 += M4(2.000e-01, 4.070e-01, 2.753e-02, -1.822e-01, -1.475e-01, 2.111e-01, -4.948e-02, 5.193e-01, 1.139e-02, 4.071e-02, 5.158e-03, 1.075e-01, -3.948e-03, -1.809e-02, 1.605e-04, 4.589e-03) * s1_1_1;
	r0 += M4(7.022e-03, 4.761e-02, 6.135e-04, 3.339e-02, -5.708e-03, -3.821e-02, -9.693e-04, -3.210e-02, 5.091e-04, 7.779e-05, 1.067e-05, -8.435e-04, 3.538e-04, -9.539e-04, 1.884e-04, 1.050e-03) * s1_1_2;
	r0 += M4(-3.169e-03, 4.554e-03, 7.057e-02, -5.446e-04, -3.407e-03, -5.521e-04, 2.238e-02, 2.842e-03, 4.899e-03, -6.446e-04, -2.873e-02, -6.271e-02, 5.456e-01, -1.123e-02, -2.007e-01, -1.630e-01) * s1_2_0;
	r0 += M4(7.789e-04, 9.922e-04, 1.265e-01, 2.307e-01, 2.212e-04, -2.183e-03, -7.679e-02, -1.063e-03, -4.404e-04, 6.865e-03, 7.764e-03, 1.062e-02, 5.370e-04, 9.055e-02, -3.345e-03, 8.346e-03) * s1_2_1;
	r0 += M4(-8.093e-05, 1.862e-03, 1.757e-03, 2.693e-02, 5.219e-05, -1.210e-03, -1.251e-03, -1.923e-02, -1.688e-05, 1.096e-03, 2.278e-04, 2.987e-03, 4.484e-04, 4.695e-03, 1.452e-05, 3.523e-03) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 += M4(6.456e-02, 4.681e-04, 3.202e-04, -1.882e-05, -6.875e-06, -5.255e-05, 1.545e-04, 5.690e-06, 1.725e-03, 4.132e-05, 6.705e-06, -4.449e-06, -2.599e-03, -5.443e-05, -8.268e-05, 3.088e-06) * s0_0_0;
	r0 += M4(5.872e-02, 1.685e-01, 3.258e-03, 2.991e-03, 1.007e-01, -3.312e-03, -8.997e-03, 2.455e-03, -4.427e-03, -2.153e-04, -4.509e-05, 1.085e-04, 1.187e-02, 4.558e-04, 5.171e-04, -9.367e-06) * s0_0_1;
	r0 += M4(5.592e-03, 1.178e-02, -4.755e-04, 1.953e-04, 3.009e-02, 1.256e-01, -2.144e-03, 5.952e-04, 2.382e-03, -2.709e-05, 3.857e-05, -1.039e-04, -1.050e-03, 9.102e-04, 9.290e-05, 3.574e-04) * s0_0_2;
	r0 += M4(1.351e-02, 7.860e-03, 1.081e-01, -2.916e-03, -6.245e-05, 2.346e-05, -7.056e-04, 1.589e-05, 1.186e-02, -2.904e-04, 2.542e-03, -1.232e-03, -4.194e-03, 3.500e-04, -3.853e-03, 5.538e-04) * s0_1_0;
	r0 += M4(-2.272e-02, -2.793e-02, 1.567e-01, 4.697e-01, 2.549e-02, 1.413e-02, 1.131e-01, 4.555e-03, 4.007e-01, 1.808e-01, -8.867e-05, -5.964e-03, -6.432e-01, -9.839e-02, 2.160e-02, -7.575e-03) * s0_1_1;
	r0 += M4(-1.781e-03, 5.410e-03, 8.707e-03, 2.142e-02, -9.048e-03, 1.859e-02, 7.006e-02, -8.383e-01, 2.393e-02, 2.344e-01, 2.089e-03, 3.004e-03, -3.117e-02, -3.487e-01, -5.075e-03, -1.443e-02) * s0_1_2;
	r0 += M4(-2.369e-03, 2.750e-03, -6.362e-04, -5.306e-03, 6.061e-05, 1.398e-04, 4.214e-04, -3.922e-05, -6.393e-03, -1.922e-03, 4.114e-02, -4.092e-03, 3.135e-03, 1.042e-03, -2.162e-02, 2.755e-03) * s0_2_0;
	r0 += M4(5.106e-04, -9.120e-04, -1.826e-02, -2.388e-02, 2.637e-04, -1.808e-04, 8.345e-03, 6.624e-04, 2.386e-05, -1.386e-02, -6.949e-01, 9.170e-03, -4.652e-04, -3.560e-03, -5.589e-02, -2.736e-03) * s0_2_1;
	r0 += M4(-2.040e-04, -2.362e-03, -6.317e-04, -4.799e-03, -3.691e-05, -7.701e-05, -1.225e-02, -4.401e-03, -3.349e-03, -3.404e-03, 3.524e-02, -2.163e-02, 1.077e-03, 3.603e-03, -3.162e-02, -1.067e-01) * s0_2_2;
	r0 += V4(4.275e-11, 3.228e-10, 1.508e-08, 5.893e-11);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
