// CuNNy 1x8 BOX
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


//!DESC CuNNy-1x8-BOX-in
//!HOOK LUMA
//!COMPUTE 16 8 8 8
//!BIND LUMA
//!SAVE in
//!WIDTH LUMA.w 2 *
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
	ivec2 opos = pos * ivec2(2, 1);
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
	V4 r0, r1;
	r0 = V4(0.0); r1 = V4(0.0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2];
	r0 += V4(1.342e+00, 1.974e-04, -8.276e-02, -3.833e-01) * s0_0_0;
	r1 += V4(1.472e-01, 1.649e-01, -1.028e-01, 7.639e-01) * s0_0_0;
	r0 += V4(-1.595e+01, -5.979e-01, 5.614e-02, 2.184e-02) * s0_0_1;
	r1 += V4(-8.516e-02, -2.646e-02, 1.008e-02, -2.783e-01) * s0_0_1;
	r0 += V4(9.812e-01, -1.489e-01, 7.526e-01, 4.834e-01) * s0_0_2;
	r1 += V4(2.051e-01, 6.795e-02, 1.285e-01, -2.375e-02) * s0_0_2;
	r0 += V4(-1.027e-02, -3.098e-01, 5.228e-02, 4.943e-02) * s0_1_0;
	r1 += V4(-4.385e-01, 4.365e-01, 3.202e-01, -1.509e-01) * s0_1_0;
	r0 += V4(-2.982e-02, 1.141e+00, -6.767e-01, 6.040e-01) * s0_1_1;
	r1 += V4(1.685e-01, -1.034e-01, -5.718e-01, -4.202e-01) * s0_1_1;
	r0 += V4(3.280e-01, -1.806e-02, -1.062e-01, -3.772e-01) * s0_1_2;
	r1 += V4(-1.543e-01, -1.255e-01, -4.322e-02, 1.140e-01) * s0_1_2;
	r0 += V4(-3.454e-03, -1.334e-02, 2.708e-02, 2.029e-01) * s0_2_0;
	r1 += V4(-6.044e-02, -7.460e-03, 1.817e-02, -1.403e-02) * s0_2_0;
	r0 += V4(3.457e-01, -1.227e-01, 2.170e-01, -3.896e-01) * s0_2_1;
	r1 += V4(1.958e-01, -2.744e-01, 1.812e-01, 9.619e-02) * s0_2_1;
	r0 += V4(-2.483e-02, 7.971e-02, -2.384e-01, -2.092e-01) * s0_2_2;
	r1 += V4(8.347e-02, -1.181e-02, 5.095e-02, -8.602e-02) * s0_2_2;
	r0 += V4(1.135e-01, 4.566e-03, -3.020e-04, -5.132e-05);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(2.527e-01, 1.635e-01, 3.213e-01, -1.367e-05);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-1x8-BOX-conv1
//!HOOK LUMA
//!COMPUTE 16 8 8 8
//!BIND in
//!BIND LUMA
//!SAVE conv1
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) in_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * in_pt)
#define l1(x, y) in_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * in_pt)
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[2][10][10];
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
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
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
	r0 = D(r0, s0_0_0, 0xDF16F9FD, 0x911AEEFB, 0x05E7E502, 0xF5020602);
	r1 = D(r1, s0_0_0, 0xFA12ECFB, 0xAC21E502, 0x0FEFE100, 0x00FFFC01);
	r0 = D(r0, s0_0_1, 0xD2070302, 0xCD07080D, 0x3F811203, 0xFC04F702);
	r1 = D(r1, s0_0_1, 0xF90AF2FE, 0xE70B0304, 0x29E51E05, 0x07FDFA02);
	r0 = D(r0, s0_0_2, 0xEB06FDFE, 0xF00CECFD, 0x10ECFEFA, 0x07F802FE);
	r1 = D(r1, s0_0_2, 0x080101FF, 0xF704F605, 0x1CEBF805, 0x05F80701);
	r0 = D(r0, s0_1_0, 0x0F1FFC05, 0xFD6BFD07, 0x08510C01, 0x0DF20301);
	r1 = D(r1, s0_1_0, 0xFD194D81, 0xA722F505, 0x5981AEFD, 0x070CF402);
	r0 = D(r0, s0_1_1, 0x8136EF03, 0x9F11F081, 0x0FCC34C5, 0xF03B810A);
	r1 = D(r1, s0_1_1, 0xF008F809, 0xB43CDB01, 0x21D981F8, 0x0019FE12);
	r0 = D(r0, s0_1_2, 0xD20D81FE, 0xD9150206, 0x0404F70A, 0x05F21B02);
	r1 = D(r1, s0_1_2, 0x00FE0501, 0xEA10F2FB, 0x19F40106, 0x06F50A05);
	r0 = D(r0, s0_2_0, 0xDBF1FFF8, 0xDE2EC807, 0x08FC060B, 0xF2FC0204);
	r1 = D(r1, s0_2_0, 0x01E7C981, 0xDF180681, 0x0CF2FC0C, 0xF7F60D0B);
	r0 = D(r0, s0_2_1, 0xD8661C02, 0xD209ED0B, 0x01F9F7FA, 0x0F032D34);
	r1 = D(r1, s0_2_1, 0xF5F7FA0B, 0xE31A440E, 0xF1D0561E, 0x02E72543);
	r0 = D(r0, s0_2_2, 0xCE0A1409, 0x00FE12FF, 0x0109FC01, 0x03FB1508);
	r1 = D(r1, s0_2_2, 0x04F70903, 0xFE0019FB, 0x0BF6E500, 0x03F6FA0B);
	r0 = D(r0, s1_0_0, 0xFE02E1FA, 0x263D9AEB, 0x024DEC25, 0x040306F9);
	r1 = D(r1, s1_0_0, 0xF9FEF5EA, 0x1826AE20, 0xF9F81DE8, 0x02F8FCFC);
	r0 = D(r0, s1_0_1, 0x030DD106, 0xF1D00C08, 0x03A1E5E0, 0xEAEC3DEE);
	r1 = D(r1, s1_0_1, 0x0F20D6E2, 0xDCF4E109, 0xF5023ADD, 0x090DF40E);
	r0 = D(r0, s1_0_2, 0xC8DCF43B, 0xD8C630FA, 0xBF0428EF, 0xF6F8DD0C);
	r1 = D(r1, s1_0_2, 0x0E10E6F9, 0xD70311F6, 0xE5E40410, 0x03FDF510);
	r0 = D(r0, s1_1_0, 0x06F11917, 0x0A103613, 0x0F31021F, 0xFA0E0C13);
	r1 = D(r1, s1_1_0, 0x9CFA22CE, 0x17B33DF9, 0xDACEF422, 0x06080713);
	r0 = D(r0, s1_1_1, 0x34231212, 0x4405F9CF, 0x7FEDE8E3, 0xCA12E9B2);
	r1 = D(r1, s1_1_1, 0x224A3AE0, 0xCE324987, 0xB554D525, 0x312407EB);
	r0 = D(r0, s1_1_2, 0x13F9F7BC, 0x2AE6E43F, 0xEEF5143D, 0x40F3042C);
	r1 = D(r1, s1_1_2, 0x0FF4FC00, 0xCFF80C0F, 0xE3E5E73C, 0x16CFF234);
	r0 = D(r0, s1_2_0, 0xFC06FBF3, 0xCBE80CFF, 0x10080308, 0xFDF8E1E0);
	r1 = D(r1, s1_2_0, 0x94FAF634, 0xF0FF0C02, 0x1C13F41B, 0x0804F6EE);
	r0 = D(r0, s1_2_1, 0xD4DB1BE2, 0x9C0D28D7, 0x10E1E802, 0xEC2A0409);
	r1 = D(r1, s1_2_1, 0x23D13325, 0xFF1010D8, 0x7FFBF2BC, 0x1B060000);
	r0 = D(r0, s1_2_2, 0x30123400, 0xA81F12E4, 0xEE0E0801, 0x3CDC0B1C);
	r1 = D(r1, s1_2_2, 0x05070102, 0xC81205E3, 0xF02203F2, 0xCF0605FD);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(4.314e-02, 1.063e-01, -1.075e-01, 5.033e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.318e-01, 1.137e-01, -1.082e-01, -1.038e-01);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-1x8-BOX-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv1
//!BIND LUMA
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 1
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv1_pt)
#define l1(x, y) conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv1_pt)
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[2][10][10];
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
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
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
	r0 = D(r0, s0_0_0, 0x06000204, 0x0100FEFC, 0x0100FF04, 0xFD00FF05);
	r0 = D(r0, s0_0_1, 0xFCFEFB04, 0xF4FF021B, 0x0601FDF8, 0x0B00FDF9);
	r0 = D(r0, s0_0_2, 0xFAFD0002, 0x0000FC01, 0xFF000000, 0x0601FFFE);
	r0 = D(r0, s0_1_0, 0xF5000A0F, 0x1200FC36, 0xF4FE04B0, 0x09FFF704);
	r0 = D(r0, s0_1_1, 0x361AC90F, 0xE3000BDA, 0x0BF9061F, 0xA8F815F1);
	r0 = D(r0, s0_1_2, 0xFCFF07F7, 0x031AE102, 0xF7FD0600, 0x08020B04);
	r0 = D(r0, s0_2_0, 0xFC00FDF8, 0x000002FA, 0xFD01020C, 0x0601FE01);
	r0 = D(r0, s0_2_1, 0xF9090FFD, 0xFEFCF6F7, 0x072DFE09, 0x0B0914FF);
	r0 = D(r0, s0_2_2, 0x02FB09F7, 0x03031805, 0x00FBFAF8, 0xFA1CDE0A);
	r0 = D(r0, s1_0_0, 0xFC0402FF, 0x01FFFF00, 0x02000000, 0x05FF0001);
	r0 = D(r0, s1_0_1, 0x10F40604, 0x100A04FE, 0xFD0CFE01, 0xFCFEF9FF);
	r0 = D(r0, s1_0_2, 0x0700FEFC, 0xFDF105FF, 0x01080001, 0xFA0EFE01);
	r0 = D(r0, s1_1_0, 0x05FC0101, 0x01FBF801, 0x090305FF, 0xFDFFFD01);
	r0 = D(r0, s1_1_1, 0xA017C70E, 0xCD1509F0, 0xE1D70E08, 0x21FA14F3);
	r0 = D(r0, s1_1_2, 0x07F90B10, 0xF70DDC2F, 0x0B0606F8, 0xED011B10);
	r0 = D(r0, s1_2_0, 0x03FF02FE, 0x02FE0001, 0xF504FFFF, 0xFA02FEFF);
	r0 = D(r0, s1_2_1, 0x070006FF, 0x0DFC00F8, 0xF104EF0F, 0xEB030AFB);
	r0 = D(r0, s1_2_2, 0xFE0215F7, 0xFD000AFC, 0x01000706, 0x07FDD314);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.469e-08, -2.967e-08, -2.978e-08, -2.984e-08);
	f0 = tanh(f0);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(f0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(f0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(f0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(f0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
