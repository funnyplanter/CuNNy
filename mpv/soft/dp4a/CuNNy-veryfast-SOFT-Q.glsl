// CuNNy veryfast SOFT (dp4a)
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


//!DESC CuNNy-veryfast-SOFT-in
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
#define l0(x, y) F((LUMA_mul * texelFetch(LUMA_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(1, 1) + ivec2(0, 0), 0)).r)
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
	r0 += V4(-4.261e-02, -3.667e-02, -1.154e-02, -1.987e-01) * s0_0_0;
	r1 += V4(1.432e-02, -1.051e-02, 2.980e-03, 6.233e-02) * s0_0_0;
	r0 += V4(1.150e+00, 3.870e-02, -1.912e-02, -1.018e-01) * s0_0_1;
	r1 += V4(2.738e-02, 7.880e-02, -2.794e-02, 2.159e-01) * s0_0_1;
	r0 += V4(1.466e-02, 1.814e-02, 3.406e-02, 3.213e-01) * s0_0_2;
	r1 += V4(-4.349e-02, -5.303e-02, 2.717e-02, -8.656e-02) * s0_0_2;
	r0 += V4(-6.192e-03, 3.412e-01, 1.076e+00, 8.554e-01) * s0_1_0;
	r1 += V4(-3.558e-02, 5.132e-02, -1.138e-02, 3.005e-01) * s0_1_0;
	r0 += V4(-1.105e+00, 2.220e-01, -9.474e-01, -9.155e-01) * s0_1_1;
	r1 += V4(-1.059e+00, -1.333e-01, -1.073e+00, -1.152e+00) * s0_1_1;
	r0 += V4(-1.126e-02, 1.069e-02, -1.051e-01, 7.108e-03) * s0_1_2;
	r1 += V4(1.090e+00, 2.574e-01, -2.334e-02, 2.402e-01) * s0_1_2;
	r0 += V4(4.406e-02, 8.321e-02, -4.105e-02, 2.105e-01) * s0_2_0;
	r1 += V4(1.507e-02, -1.744e-02, 3.503e-05, -1.016e-01) * s0_2_0;
	r0 += V4(-4.078e-02, -7.062e-01, -6.218e-02, 4.684e-02) * s0_2_1;
	r1 += V4(-1.002e-02, -1.030e-01, 1.098e+00, 2.858e-01) * s0_2_1;
	r0 += V4(-5.676e-03, 1.173e-02, 7.469e-02, -2.327e-01) * s0_2_2;
	r1 += V4(-5.805e-03, -4.049e-02, 4.043e-03, 4.426e-02) * s0_2_2;
	r0 += V4(-1.137e-03, -3.262e-04, -2.050e-03, -2.276e-03);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-5.205e-04, 1.480e-02, 2.195e-05, -1.857e-03);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-veryfast-SOFT-conv1
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
#define l0(x, y) (in_mul * texelFetch(in_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0), 0))
#define l1(x, y) (in_mul * texelFetch(in_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0), 0))
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
			vec4 v0 = l0(x - 1, y - 1);
			vec4 v1 = l1(x - 1, y - 1);
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
	r0 = D(r0, s0_0_0, 0xFAFF1DFD, 0xFD11D207, 0xF90205FC, 0x08EE14F3);
	r1 = D(r1, s0_0_0, 0x1AE32A01, 0xF90000FF, 0x03FF0603, 0x14F60F11);
	r0 = D(r0, s0_0_1, 0x10DF7F0D, 0x17EEF8F7, 0xD81A0101, 0xFC07D601);
	r1 = D(r1, s0_0_1, 0x1D1AF108, 0x0107F200, 0x16F0EB04, 0xEFCCDAF7);
	r0 = D(r0, s0_0_2, 0xEA0134FC, 0x14E7E3F8, 0xE615090C, 0xFB0103FC);
	r1 = D(r1, s0_0_2, 0x1405EBF6, 0x02F811FF, 0xFFFC2202, 0x12F8E5F7);
	r0 = D(r0, s0_1_0, 0x00F9EFA1, 0x190AEF19, 0xE817E7F6, 0x08E703F0);
	r1 = D(r1, s0_1_0, 0x3CBF02E4, 0x03FE07FA, 0xF8FF0813, 0x37C6182E);
	r0 = D(r0, s0_1_1, 0xD7A04781, 0x51CBC20F, 0xEC1AFC0A, 0xF15F050E);
	r1 = D(r1, s0_1_1, 0x38E1C301, 0x19240108, 0xF9100131, 0x2E0DED29);
	r0 = D(r0, s0_1_2, 0xE321D1F5, 0xEAE0CEDE, 0x1426190C, 0xED28FD07);
	r1 = D(r1, s0_1_2, 0x38073D10, 0x01FA04F9, 0xF601F00D, 0x3AEA061A);
	r0 = D(r0, s0_2_0, 0xE124F4F6, 0x32DDF954, 0xF31DF30C, 0xF3060606);
	r1 = D(r1, s0_2_0, 0xF9F8F0D8, 0x0104FD1C, 0xF805FE0D, 0x0AEEEDDA);
	r0 = D(r0, s0_2_1, 0xD3200D3C, 0x16F6FE9D, 0xFD0412C2, 0x011AF410);
	r1 = D(r1, s0_2_1, 0x18CCFA81, 0x0506FECD, 0x001309F9, 0x0ED200B5);
	r0 = D(r0, s0_2_2, 0x0E26170B, 0xF91F0506, 0xF7EDE8FD, 0x02080BF9);
	r1 = D(r1, s0_2_2, 0xFDE204FC, 0x03F903FF, 0x0402FFF6, 0x01EFF302);
	r0 = D(r0, s1_0_0, 0x03FA35FE, 0xFDFED704, 0x0404EF02, 0x0FF12E00);
	r1 = D(r1, s1_0_0, 0x07F719EA, 0xFF010EFA, 0xF7FD1702, 0xEFF9DB0A);
	r0 = D(r0, s1_0_1, 0xDCBBF214, 0x18E9F6FD, 0x070F24E8, 0x03E6F1FD);
	r1 = D(r1, s1_0_1, 0xC434E411, 0xF607ED02, 0x05CBDE24, 0x0724F7F1);
	r0 = D(r0, s1_0_2, 0xE920F10D, 0x01F91001, 0x020BF2FD, 0x0DF2FB05);
	r1 = D(r1, s1_0_2, 0x1B05D8ED, 0x12FB02F8, 0x1122FD05, 0x21F4F7F1);
	r0 = D(r0, s1_1_0, 0x1EF64A81, 0xFDF70116, 0xE50F033A, 0x33EE01D3);
	r1 = D(r1, s1_1_0, 0x35F4CF81, 0x09FFED04, 0xFC03ECD8, 0x2AE5D79F);
	r0 = D(r0, s1_1_1, 0x2E89E7C5, 0x1838B1DF, 0xEB1CC219, 0xE639D715);
	r1 = D(r1, s1_1_1, 0xFC063A1E, 0xE4600511, 0xD701442C, 0xE40AEA11);
	r0 = D(r0, s1_1_2, 0xED1FFA03, 0x4AFE36E3, 0xF8E5F309, 0xF9FE19FA);
	r1 = D(r1, s1_1_2, 0x18C4E805, 0xFE00F9FD, 0xF616EF02, 0xF105F906);
	r0 = D(r0, s1_2_0, 0xDC16F53C, 0xEBFA0811, 0xEFF5ED21, 0x0501EA00);
	r1 = D(r1, s1_2_0, 0x20065FE1, 0xF9FD060D, 0xFFFDF5F9, 0x090258E7);
	r0 = D(r0, s1_2_1, 0xD503B50B, 0xDBFD21D2, 0xEDACE987, 0xEF0407FC);
	r1 = D(r1, s1_2_1, 0x34EDEB1B, 0x08F8FBF4, 0xF8050117, 0x33F425F5);
	r0 = D(r0, s1_2_2, 0x0FFD02FE, 0xEA0E1A07, 0x14E549EA, 0x0CFAFEFE);
	r1 = D(r1, s1_2_2, 0xF501F20D, 0x000116FF, 0x0DFFF7FB, 0xFDFDF50A);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-veryfast-SOFT-conv2
//!HOOK LUMA
//!COMPUTE 8 8 8 8
//!BIND conv1
//!BIND LUMA
//!SAVE conv2
//!WIDTH LUMA.w
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) (conv1_mul * texelFetch(conv1_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0), 0))
#define l1(x, y) (conv1_mul * texelFetch(conv1_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0), 0))
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[2][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(1, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1);
			vec4 v1 = l1(x - 1, y - 1);
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
	r0 = D(r0, s0_0_0, 0xFBFEF503, 0xFC04FB04, 0x0C03F405, 0xF405F505);
	r0 = D(r0, s0_0_1, 0x18FC1100, 0xED01FE0E, 0x1EECDAE5, 0xFAEAEA0B);
	r0 = D(r0, s0_0_2, 0xFDF9EDEC, 0xF901FE02, 0x0B0C07F4, 0xF60D0803);
	r0 = D(r0, s0_1_0, 0xF907FA01, 0x15CFFFE3, 0x0FFCFDD8, 0x06F705F8);
	r0 = D(r0, s0_1_1, 0x14F2CFD5, 0x02F7D6D3, 0xE2FBF002, 0x0BD2CEC3);
	r0 = D(r0, s0_1_2, 0xEF0DFEF6, 0x030D0DED, 0xFE0301FE, 0x02160ADC);
	r0 = D(r0, s0_2_0, 0xF8FFFAFF, 0xE30EF0F2, 0x040504FC, 0xF506F9E9);
	r0 = D(r0, s0_2_1, 0x2806F3F3, 0x0603F6FA, 0x00FC0100, 0x1602F5F9);
	r0 = D(r0, s0_2_2, 0x0807FCF7, 0x0609FDFC, 0x02FF00FE, 0x0409F9F8);
	r0 = D(r0, s1_0_0, 0x02000304, 0xFA02FDFD, 0xF6012302, 0xFE020703);
	r0 = D(r0, s1_0_1, 0xFB03EFFF, 0x02FDF6FF, 0xF7F714EC, 0x04F9F3FC);
	r0 = D(r0, s1_0_2, 0x00FB0DFF, 0xFDFF04FF, 0x01FDE600, 0xFEFDFDFD);
	r0 = D(r0, s1_1_0, 0x02F30C03, 0xDE300814, 0xFA23F106, 0xF520FE1C);
	r0 = D(r0, s1_1_1, 0x0AFC62FB, 0xDEF93DF3, 0x2C2826CB, 0xD4096FCF);
	r0 = D(r0, s1_1_2, 0xF80718F9, 0xFCFFF300, 0xFC05F4FB, 0xF702EE03);
	r0 = D(r0, s1_2_0, 0x01090A05, 0x02120B01, 0xFBF7F6FE, 0xFA090302);
	r0 = D(r0, s1_2_1, 0x10FBFBF4, 0x2E1A10D4, 0xF9010006, 0x2C1508E2);
	r0 = D(r0, s1_2_2, 0xFF01FBFC, 0xFA01F5FD, 0xFF0101FF, 0x0702F6FA);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
}

//!DESC CuNNy-veryfast-SOFT-out-shuffle
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
#define l0(x, y) V4((conv2_mul * texelFetch(conv2_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(1, 1) + ivec2(0, 0), 0)))
shared V4 G[1][10][10];
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
	V4 s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2;
	V4 r0;
	r0 = V4(0.0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2];
	r0 += M4(1.255e-01, 5.798e-02, -1.163e-02, -8.770e-03, 3.371e-03, 2.788e-03, 1.468e-02, 4.457e-03, 2.673e-04, 8.711e-04, 3.817e-04, -1.424e-07, 8.862e-02, -1.069e-02, -1.059e-02, -1.579e-02) * s0_0_0;
	r0 += M4(1.861e-01, 1.508e-01, 1.333e-03, -4.843e-03, 4.479e-02, 2.555e-02, 1.787e-01, 3.182e-02, -1.453e-03, 6.543e-03, -4.353e-04, -8.008e-07, -1.167e-01, 1.298e-01, -4.762e-02, 2.935e-03) * s0_0_1;
	r0 += M4(-6.974e-03, 4.382e-02, -7.400e-04, -3.396e-03, -2.124e-01, -3.001e-01, 1.984e-02, 2.780e-01, 1.173e-03, -7.187e-03, -1.022e-03, -6.778e-04, -1.048e-02, 7.156e-02, -2.708e-03, -3.875e-02) * s0_0_2;
	r0 += M4(-1.577e-01, 1.250e-02, -8.648e-02, -4.689e-02, -6.336e-03, -3.293e-03, 1.110e-03, 2.097e-03, 2.277e-03, -1.022e-02, -1.019e-03, -3.308e-03, 1.170e-01, -1.107e-02, 1.322e-01, 2.385e-03) * s0_1_0;
	r0 += M4(-8.021e-02, -6.038e-01, 4.326e-01, -1.053e-01, 2.173e-01, -4.296e-02, 1.675e-01, 2.452e-02, -5.569e-01, -1.812e-01, -9.005e-02, 6.056e-02, -6.368e-02, 5.282e-01, -8.165e-01, 1.111e-01) * s0_1_1;
	r0 += M4(-1.173e-02, 1.275e-01, 4.014e-03, 2.144e-01, 1.665e-01, -1.548e-01, -7.352e-02, -7.022e-01, 3.799e-01, -6.418e-02, -2.039e-02, -2.607e-01, -7.982e-02, 1.027e-01, -2.271e-02, 6.812e-02) * s0_1_2;
	r0 += M4(2.949e-03, 2.134e-03, -8.520e-02, 8.288e-03, -6.587e-04, 1.055e-04, -1.581e-02, -6.011e-03, -1.238e-02, 9.397e-03, 3.083e-03, 2.538e-03, 1.998e-04, -1.396e-03, 6.518e-02, 4.520e-03) * s0_2_0;
	r0 += M4(-9.190e-03, 1.922e-02, -6.755e-02, -1.704e-01, 5.656e-03, 9.584e-03, 1.098e-02, -2.932e-02, -1.432e-02, -3.629e-02, 1.106e-01, 1.470e-01, -4.086e-03, -2.335e-02, 1.047e-01, 1.373e-01) * s0_2_1;
	r0 += M4(7.299e-03, 6.259e-03, -6.744e-03, 6.162e-03, 2.891e-03, -2.629e-03, 4.639e-02, 3.400e-02, 8.160e-03, 6.618e-02, 1.782e-01, 2.162e-01, -1.123e-02, -1.263e-02, -3.014e-02, 3.908e-02) * s0_2_2;
	r0 += V4(-2.727e-11, -1.608e-10, -1.877e-11, -2.711e-10);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
