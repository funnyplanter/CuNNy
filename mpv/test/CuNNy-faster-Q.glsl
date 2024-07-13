// CuNNy faster (dp4a)
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


//!DESC CuNNy-faster-in
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
	r0 += V4(1.191e-03, 1.232e-02, 1.665e-01, -2.864e-02) * s0_0_0;
	r1 += V4(7.288e-02, 9.002e-03, 2.594e-02, -2.394e-01) * s0_0_0;
	r0 += V4(5.314e-01, 1.513e-03, 1.276e-02, 3.169e-02) * s0_0_1;
	r1 += V4(-7.363e-01, -5.194e-02, -3.442e-02, 2.960e-01) * s0_0_1;
	r0 += V4(-1.038e-01, -1.795e-02, 1.016e-01, 4.622e-03) * s0_0_2;
	r1 += V4(-3.959e-01, 3.141e-02, 7.719e-03, 3.721e-01) * s0_0_2;
	r0 += V4(3.950e-02, -1.491e-02, 2.876e-01, 1.128e+00) * s0_1_0;
	r1 += V4(-1.072e-01, 2.460e-02, -2.544e-02, -9.772e-02) * s0_1_0;
	r0 += V4(-3.533e-01, -1.697e-03, -1.415e+00, -1.125e+00) * s0_1_1;
	r1 += V4(8.219e-01, 1.510e-01, -1.061e+00, -9.700e-01) * s0_1_1;
	r0 += V4(1.831e-01, -1.098e+00, 5.339e-02, -7.459e-03) * s0_1_2;
	r1 += V4(3.799e-01, 8.946e-01, 1.090e+00, 6.454e-01) * s0_1_2;
	r0 += V4(3.146e-02, 7.904e-03, 1.343e-01, 3.953e-03) * s0_2_0;
	r1 += V4(1.199e-02, -3.701e-02, -9.784e-03, 3.564e-01) * s0_2_0;
	r0 += V4(1.092e-01, 3.294e-04, 1.473e-01, -7.412e-03) * s0_2_1;
	r1 += V4(-6.543e-02, -8.372e-02, 1.742e-02, -1.057e-01) * s0_2_1;
	r0 += V4(-6.366e-02, 1.108e+00, 1.507e-01, 3.513e-03) * s0_2_2;
	r1 += V4(1.852e-02, -9.355e-01, -8.204e-03, -2.600e-01) * s0_2_2;
	r0 += V4(3.458e-03, 2.516e-05, -1.029e-02, -1.510e-04);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(1.208e-04, 2.486e-04, -6.313e-04, -5.036e-03);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-faster-conv1
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
	r0 = D(r0, s0_0_0, 0xF50EE010, 0x03FD1A05, 0xFE12F400, 0xFBF6EB09);
	r1 = D(r1, s0_0_0, 0x04F81008, 0x09FF81C1, 0x14FF9A03, 0x000FE20B);
	r0 = D(r0, s0_0_1, 0x1003F22B, 0x0EF50E15, 0xD20CFA13, 0x0DF505FE);
	r1 = D(r1, s0_0_1, 0x0B03FAF3, 0x0C2D81B6, 0x271DBBC6, 0x16084AFC);
	r0 = D(r0, s0_0_2, 0xF6001E34, 0x0C050CFD, 0x21101C0C, 0xFFF100F0);
	r1 = D(r1, s0_0_2, 0xFC0505F4, 0x817FEDE3, 0xB16605FD, 0xF00EFAFC);
	r0 = D(r0, s0_1_0, 0x16ECF9B6, 0x0BE912E2, 0x0FDB8139, 0xF710EBFA);
	r1 = D(r1, s0_1_0, 0xFE0419E1, 0x000B1FFB, 0x01EB13D1, 0x17D8AC03);
	r0 = D(r0, s0_1_1, 0xB90DF181, 0x02E001A8, 0x81817FBB, 0x00E92566);
	r1 = D(r1, s0_1_1, 0x26A50846, 0x12C30D3A, 0x2CE321E2, 0x01ED5104);
	r0 = D(r0, s0_1_2, 0x26FA01D4, 0x5CEBFBF1, 0xF2BF1CB9, 0xC8EAFFF0);
	r1 = D(r1, s0_1_2, 0x00F0F8DA, 0x2BD3043A, 0xADC4F9E5, 0x2BD01330);
	r0 = D(r0, s0_2_0, 0x15F40F34, 0x05F30403, 0xF70F0AF9, 0x010C0212);
	r1 = D(r1, s0_2_0, 0x0103FEFD, 0xF904062F, 0xF2121000, 0x1ED281E1);
	r0 = D(r0, s0_2_1, 0x24F7F556, 0x10FD065C, 0xA89DFA19, 0xFF10F790);
	r1 = D(r1, s0_2_1, 0x070604EA, 0x07F80007, 0x09D5FF4F, 0x81818105);
	r0 = D(r0, s0_2_2, 0xF92BEF00, 0x0E03000F, 0x27EB0C26, 0xF5010218);
	r1 = D(r1, s0_2_2, 0x09FD0727, 0xFBF70602, 0x24E21056, 0xC5460BE6);
	r0 = D(r0, s1_0_0, 0xD50B4208, 0x04FE1204, 0xFC20810A, 0x04EB2508);
	r1 = D(r1, s1_0_0, 0x07FB1706, 0xF505E8DA, 0x1DAFC600, 0x0BF73609);
	r0 = D(r0, s1_0_1, 0xA0486A14, 0xFEFA24FD, 0xE21E2FFE, 0xFC1237F5);
	r1 = D(r1, s1_0_1, 0x001023F3, 0x1281E1E5, 0xFA8189F0, 0x0B17D2ED);
	r0 = D(r0, s1_0_2, 0xC3320501, 0xFA04FA05, 0x0014D501, 0x0DFC0400);
	r1 = D(r1, s1_0_2, 0xFB0B0200, 0xE1812103, 0xE3E93EFC, 0x07F4170E);
	r0 = D(r0, s1_1_0, 0xBB6E1905, 0x08291CFC, 0x05C81017, 0xFFD7F225);
	r1 = D(r1, s1_1_0, 0x04F40505, 0x010920C1, 0x4CFF17FF, 0xFB2B8130);
	r0 = D(r0, s1_1_1, 0x822D12F2, 0xFFF40AEC, 0x1981FC06, 0xFF34F9FC);
	r1 = D(r1, s1_1_1, 0xFF5CFDFA, 0x46290581, 0x1FEB21D4, 0xF1EEBFEC);
	r0 = D(r0, s1_1_2, 0xAD39F8D5, 0xF218FDF0, 0x01F608D3, 0xFCFF02FC);
	r1 = D(r1, s1_1_2, 0xED0409FA, 0x15EF02F0, 0xF60E0FCC, 0xF2030C02);
	r0 = D(r0, s1_2_0, 0xC8060413, 0xFC060B10, 0x001B0349, 0xF4EAF70E);
	r1 = D(r1, s1_2_0, 0x05FFFD21, 0x0A0A08F7, 0x1F0B0523, 0xEA0CEA5D);
	r0 = D(r0, s1_2_1, 0xC019F70F, 0xFFF7FCFC, 0x30CB09BC, 0x0C1702FA);
	r1 = D(r1, s1_2_1, 0x070C033C, 0x0210FAD7, 0x0F1C062C, 0xCA8111CA);
	r0 = D(r0, s1_2_2, 0xC30B10F4, 0xFC05010A, 0x0DFDFD81, 0xFE0102FB);
	r1 = D(r1, s1_2_2, 0xFA04FF13, 0xF6020512, 0xEB1C05FA, 0x20EEFADF);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.315e-02, 1.386e-03, -1.393e-02, 5.792e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(1.516e-03, -1.650e-03, 2.847e-03, -1.886e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-faster-conv2
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
#define l0(x, y) (conv1_mul * texelFetch(conv1_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0), 0))
#define l1(x, y) (conv1_mul * texelFetch(conv1_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0), 0))
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
	r0 = D(r0, s0_0_0, 0xFF1F01F3, 0x0FEBEA13, 0x071CF9F1, 0x022905F5);
	r1 = D(r1, s0_0_0, 0xEF0FE708, 0xFF2601EB, 0x0AF8F2FE, 0x0BFFF7FB);
	r0 = D(r0, s0_0_1, 0x10F00B01, 0xE7B7F5F7, 0x06030CF8, 0x03B8F216);
	r1 = D(r1, s0_0_1, 0x0F13DE06, 0x1CD90A1A, 0xF907FFF8, 0xFB0B08EF);
	r0 = D(r0, s0_0_2, 0x09190401, 0x0DFCF709, 0x0505FC0D, 0x070B04F8);
	r1 = D(r1, s0_0_2, 0xFEFAFAFA, 0xF221FDF2, 0xFE0801F9, 0xFFFF0101);
	r0 = D(r0, s0_1_0, 0x033112FB, 0x19D81AE2, 0x18BF001C, 0xFA2F0D00);
	r1 = D(r1, s0_1_0, 0x0CE318FC, 0xF62301FA, 0x25FF11F0, 0x30E403F4);
	r0 = D(r0, s0_1_1, 0xBEA60A13, 0xA8BFE7F2, 0x9CE8DFF6, 0xD19F27D2);
	r1 = D(r1, s0_1_1, 0x81E838FC, 0xF2CA7FE8, 0xC9D3F113, 0xBBD91C19);
	r0 = D(r0, s0_1_2, 0x1CB405F3, 0x10F40205, 0x22E50402, 0x0CEBEE0E);
	r1 = D(r1, s0_1_2, 0xEE04F60B, 0xF0E2D1FB, 0xEB04E0FF, 0x02FE0002);
	r0 = D(r0, s0_2_0, 0xFD22F909, 0x0F0C04FB, 0x1A0B10DE, 0xFF0BF807);
	r1 = D(r1, s0_2_0, 0x18110205, 0x050CF50B, 0x1CF411FB, 0x1EFD0CF6);
	r0 = D(r0, s0_2_1, 0x15DE11D2, 0x06040107, 0x0FFAF801, 0x01FF06F9);
	r1 = D(r1, s0_2_1, 0x37E8F9F1, 0xF70816E9, 0xFDF229EA, 0x3FDEF4F1);
	r0 = D(r0, s0_2_2, 0x141FF113, 0x0AFE0AF3, 0x100802FF, 0x0A0A05FF);
	r1 = D(r1, s0_2_2, 0x23FCFBFC, 0xFB03010D, 0xF301FA04, 0x28EE01FD);
	r0 = D(r0, s1_0_0, 0xF00AFDF1, 0xEA0616F1, 0xF20DFAF1, 0xD30806EE);
	r1 = D(r1, s1_0_0, 0x0D06EDF4, 0xFB0DFEEE, 0x07FEFCF6, 0x080001FC);
	r0 = D(r0, s1_0_1, 0xE802FEE2, 0xF0FE0219, 0xE701FFF9, 0xCEFD0BFF);
	r1 = D(r1, s1_0_1, 0x0A0B01FF, 0xD2F111DE, 0xEE01020A, 0xE8FFFE02);
	r0 = D(r0, s1_0_2, 0xC60400F0, 0x010000F6, 0xF70401F3, 0xB702FDFA);
	r1 = D(r1, s1_0_2, 0xF207F706, 0xBD020606, 0xF604FE05, 0xF90505FD);
	r0 = D(r0, s1_1_0, 0xECE116EE, 0x05D4C80B, 0xA8DE1D11, 0x0DE8FBF2);
	r1 = D(r1, s1_1_0, 0xA9F40C0C, 0x10E514E9, 0xFDF00218, 0xF6EE1508);
	r0 = D(r0, s1_1_1, 0xA8B8097C, 0x08AA2C7F, 0x9ED01E7F, 0x03B4C66C);
	r1 = D(r1, s1_1_1, 0x9FF8022E, 0xFCBED445, 0xECFD163C, 0xE6E24839);
	r0 = D(r0, s1_1_2, 0xDD0506E6, 0x10FD0DEC, 0x0BFF05E7, 0x090410EE);
	r1 = D(r1, s1_1_2, 0xEB0105FD, 0x0206130A, 0x05FC0116, 0x00F914E3);
	r0 = D(r0, s1_2_0, 0x0200D2FD, 0xFC00F200, 0x0CFDFAFC, 0xFD01FEFE);
	r1 = D(r1, s1_2_0, 0x07FCF602, 0xFF05EEF9, 0x07F0EBF9, 0x03FDF803);
	r0 = D(r0, s1_2_1, 0x0EF38D0D, 0xFEF0FC00, 0x0EE81004, 0x00F5AE03);
	r1 = D(r1, s1_2_1, 0x08E90AFF, 0x0AF1C9F8, 0x12E015DE, 0x04EE0701);
	r0 = D(r0, s1_2_2, 0x04FC21EE, 0x00FD1AF3, 0x01FF14F5, 0x01FC1EF1);
	r1 = D(r1, s1_2_2, 0x0501F9EF, 0x04FB16F6, 0x06FC0800, 0x07F80FF5);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-8.021e-03, -7.512e-03, -8.425e-03, -5.799e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-8.569e-03, -4.463e-03, -2.760e-03, -9.666e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-faster-out-shuffle
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
	r0 += M4(2.780e-02, -4.807e-03, -1.108e-02, -4.857e-04, 3.063e-02, -3.704e-03, -4.229e-03, 1.356e-03, 7.523e-03, -1.822e-03, 1.733e-03, -1.081e-03, -1.949e-02, 4.351e-03, 8.280e-03, 6.672e-04) * s0_0_0;
	r0 += M4(2.231e-02, -3.201e-02, -1.052e-02, 3.632e-03, 4.476e-02, 7.202e-02, -2.484e-02, -1.367e-02, 6.596e-03, 5.401e-02, 3.067e-02, 3.059e-03, -2.496e-02, -5.544e-03, 6.126e-04, -1.007e-02) * s0_0_1;
	r0 += M4(5.595e-03, 8.946e-03, -8.392e-04, 1.617e-02, 4.710e-03, -2.021e-02, -3.369e-03, -1.725e-02, -1.453e-02, 3.992e-02, -5.044e-04, -4.811e-03, -2.789e-03, 4.747e-03, 3.040e-03, 1.680e-03) * s0_0_2;
	r0 += M4(6.189e-02, -7.994e-03, -4.199e-02, 3.929e-02, 6.910e-02, -1.022e-02, 6.468e-02, -1.533e-03, 3.392e-02, -6.596e-03, 4.876e-02, -1.629e-02, 6.421e-02, 3.773e-02, 9.178e-02, 1.398e-02) * s0_1_0;
	r0 += M4(1.470e-01, 1.333e-01, 1.866e-01, -6.993e-01, -5.706e-01, 9.594e-02, 2.037e-01, 2.867e-01, 1.908e-01, 1.818e-01, -6.777e-01, 3.254e-02, 2.447e-01, -7.433e-01, 1.393e-01, 1.372e-01) * s0_1_1;
	r0 += M4(2.267e-03, 4.020e-02, 8.877e-04, 7.587e-02, 3.046e-02, -8.861e-02, 1.188e-02, 3.113e-03, -1.144e-02, 4.113e-02, -1.539e-02, -4.368e-02, -1.443e-02, 5.871e-02, -9.112e-05, 2.128e-02) * s0_1_2;
	r0 += M4(-2.053e-03, -3.518e-03, -1.788e-02, -2.385e-03, -5.448e-03, 1.056e-02, -6.087e-03, 6.819e-03, 7.075e-05, -7.936e-04, 1.497e-02, -5.138e-03, -3.390e-02, 1.740e-02, 6.631e-02, 4.169e-03) * s0_2_0;
	r0 += M4(9.833e-04, -2.285e-02, 1.186e-02, 2.797e-02, 2.526e-02, 3.431e-03, -1.028e-01, -5.296e-02, -1.787e-02, 1.259e-03, 5.560e-02, 4.002e-02, 3.471e-04, -2.465e-02, 5.346e-02, -7.808e-02) * s0_2_1;
	r0 += M4(-2.319e-04, -1.483e-03, -6.912e-03, 1.218e-02, 6.514e-03, -7.860e-03, 8.880e-03, -3.600e-02, -7.263e-04, -5.068e-04, -3.868e-04, 8.104e-03, -4.928e-03, 1.412e-02, -3.333e-03, 1.115e-02) * s0_2_2;
	r0 += M4(-2.964e-02, -9.333e-03, -1.215e-03, -3.595e-03, -1.922e-02, 4.076e-03, -1.072e-03, -1.871e-04, 2.034e-02, 9.878e-03, -6.450e-03, -5.251e-03, -4.260e-02, -9.218e-03, 9.590e-03, 7.667e-03) * s1_0_0;
	r0 += M4(-1.107e-02, -2.120e-02, -2.781e-02, -1.196e-02, -7.560e-04, 2.413e-02, 4.426e-03, 6.112e-03, 2.264e-01, 1.249e-01, 2.421e-02, 3.546e-02, -1.570e-01, -1.753e-01, -5.029e-03, -1.488e-02) * s1_0_1;
	r0 += M4(-4.933e-04, 1.329e-02, 7.135e-03, 7.408e-03, 3.647e-04, 8.625e-07, 4.826e-07, -3.128e-04, 1.300e-04, 5.571e-02, -8.504e-03, -8.717e-03, 2.433e-03, -4.383e-02, 3.625e-03, 6.762e-03) * s1_0_2;
	r0 += M4(-5.699e-02, 5.713e-03, -7.360e-03, -8.345e-03, -2.437e-01, -2.476e-03, -1.544e-01, -5.081e-03, -5.823e-02, 1.904e-02, -5.067e-02, 9.511e-03, 8.569e-02, -1.849e-02, 2.953e-02, -2.130e-02) * s1_1_0;
	r0 += M4(-9.435e-02, -1.416e-01, 2.307e-01, 1.279e-01, 2.313e-02, 1.507e-01, 1.303e-02, 1.437e-01, -8.044e-03, -1.401e-01, 1.173e-01, -1.956e-01, 8.227e-02, 2.083e-01, -2.735e-02, 1.026e-01) * s1_1_1;
	r0 += M4(1.327e-02, 2.262e-02, -1.162e-02, 8.759e-02, 2.777e-04, -5.000e-03, 2.309e-03, 3.622e-03, -3.507e-02, -1.298e-02, -4.227e-02, -3.550e-02, -3.222e-03, -4.328e-02, 2.497e-04, -8.228e-02) * s1_1_2;
	r0 += M4(7.538e-03, -4.868e-04, -1.910e-02, -5.691e-03, 4.099e-02, -1.883e-02, -5.139e-02, -7.164e-03, -3.120e-04, -1.053e-03, -4.025e-03, 3.306e-03, -7.101e-03, 8.941e-04, 1.840e-02, 6.623e-03) * s1_2_0;
	r0 += M4(7.604e-03, 4.288e-03, -7.003e-02, -5.702e-02, -9.979e-03, 3.817e-02, -6.860e-03, 6.617e-02, 1.065e-02, 7.081e-03, -1.721e-02, -1.199e-02, -8.697e-03, -4.589e-03, 7.397e-02, 6.274e-02) * s1_2_1;
	r0 += M4(3.117e-03, 1.898e-02, -5.899e-03, -1.229e-02, 9.236e-04, 6.230e-03, 8.706e-04, -9.618e-04, -1.818e-03, -5.985e-03, -3.476e-03, -7.977e-03, -2.333e-03, -1.874e-02, 5.413e-03, 7.496e-03) * s1_2_2;
	r0 += V4(1.478e-08, 3.929e-09, -1.704e-10, -2.470e-09);
	r0 = r0;
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
