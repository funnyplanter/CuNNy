// CuNNy 3x8 BOX
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


//!DESC CuNNy-3x8-BOX-in
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
	r0 += V4(4.837e-02, -5.412e-02, 1.481e-03, -6.990e-02) * s0_0_0;
	r1 += V4(9.230e-03, -1.235e-02, 2.178e-02, -3.141e-03) * s0_0_0;
	r0 += V4(-9.211e-02, -7.096e-03, 7.215e-01, 1.021e-01) * s0_0_1;
	r1 += V4(-1.551e-02, 2.431e-02, -1.758e-01, -7.175e-03) * s0_0_1;
	r0 += V4(1.510e-01, 7.146e-02, 7.095e-03, -4.996e-02) * s0_0_2;
	r1 += V4(6.017e-03, -1.080e-02, 1.448e-01, 1.068e-02) * s0_0_2;
	r0 += V4(1.725e-02, 4.021e-01, 5.648e-05, 2.993e-01) * s0_1_0;
	r1 += V4(7.331e-01, 3.280e-02, 9.672e-03, -7.637e-01) * s0_1_0;
	r0 += V4(2.877e-01, 4.735e-02, -7.324e-01, -8.883e-02) * s0_1_1;
	r1 += V4(-7.324e-01, -9.596e-02, -3.166e-01, 2.501e-02) * s0_1_1;
	r0 += V4(-4.045e+00, -2.417e-01, 5.464e-03, -2.239e-02) * s0_1_2;
	r1 += V4(-4.148e-03, -5.848e-02, -1.840e-01, 2.517e-03) * s0_1_2;
	r0 += V4(1.615e-02, 3.276e-01, 7.910e-04, -2.646e-01) * s0_2_0;
	r1 += V4(-1.414e-02, -1.121e-02, -2.495e-02, 7.661e-01) * s0_2_0;
	r0 += V4(-5.156e-02, -5.260e-01, 8.706e-03, 3.477e-01) * s0_2_1;
	r1 += V4(2.485e-02, -5.961e-01, 5.517e-01, -1.461e-02) * s0_2_1;
	r0 += V4(1.246e-01, -2.653e-02, -1.067e-02, -3.998e-02) * s0_2_2;
	r1 += V4(-9.764e-03, 7.332e-01, -6.289e-03, -1.358e-02) * s0_2_2;
	r0 += V4(2.753e-02, -7.523e-04, 4.645e-04, 4.849e-02);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(1.873e-04, 2.753e-06, 1.290e-02, 4.263e-04);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-3x8-BOX-conv1
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
	r0 = D(r0, s0_0_0, 0xEEFF013E, 0xFD03F793, 0x0F04F9F5, 0xF700FBF0);
	r1 = D(r1, s0_0_0, 0xF5031C10, 0x05FFF102, 0xFF07F3F3, 0x06FE0602);
	r0 = D(r0, s0_0_1, 0x1A02E4F3, 0x28FB4519, 0x06FEF2FB, 0x0F0C00EF);
	r1 = D(r1, s0_0_1, 0x09040AED, 0xF4FDF913, 0x00FCEB10, 0xED07F812);
	r0 = D(r0, s0_0_2, 0xF207F4FD, 0xE001FEFB, 0xEEFBD411, 0xFF03FBFD);
	r1 = D(r1, s0_0_2, 0xFBFB030A, 0x01060102, 0x03FF03FB, 0xFA00F4FE);
	r0 = D(r0, s0_1_0, 0xFDF10C12, 0x0301F981, 0x07F11615, 0xFCEB02AE);
	r1 = D(r1, s0_1_0, 0x06EA14FE, 0xFB0602F7, 0x1000E91B, 0xF6013126);
	r0 = D(r0, s0_1_1, 0x03E1ED27, 0xDE8118B6, 0xF408FF23, 0x02100E07);
	r1 = D(r1, s0_1_1, 0xF5FBFD05, 0x061AF40E, 0x110C34F6, 0xD61CFA13);
	r0 = D(r0, s0_1_2, 0x14220603, 0x3CEEEE0D, 0xE2161CCB, 0x230DFDF3);
	r1 = D(r1, s0_1_2, 0xE71C15F2, 0x3205D709, 0x25EAEAFA, 0xFDFF00F9);
	r0 = D(r0, s0_2_0, 0xF7FC0120, 0xFE060401, 0xEFF602E1, 0xFA0D010D);
	r1 = D(r1, s0_2_0, 0x0CF80016, 0xF3FAFF23, 0xE702FD6F, 0xF4FAF441);
	r0 = D(r0, s0_2_1, 0xFD17FA0B, 0xF516F417, 0x19A1F8D9, 0x033400F7);
	r1 = D(r1, s0_2_1, 0x0B31FDFA, 0xF57FFB18, 0xE9ED09F4, 0x1E04F923);
	r0 = D(r0, s0_2_2, 0x011C0500, 0xF61407F6, 0x1225091B, 0xF3FE0200);
	r1 = D(r1, s0_2_2, 0x0D2E04F6, 0xE71F0006, 0xDEE6F715, 0x310C2AEB);
	r0 = D(r0, s1_0_0, 0xFFF11C04, 0x0507FD0A, 0x0A0C0502, 0x010F4F00);
	r1 = D(r1, s1_0_0, 0xFE130DF9, 0x0112F404, 0xFD242DFE, 0x031503F7);
	r0 = D(r0, s1_0_1, 0x263B3612, 0x120E81A0, 0xF90BE50C, 0x111FFE1A);
	r1 = D(r1, s1_0_1, 0x0F05C800, 0xF8FB1B0B, 0xE8EF2A0D, 0xED10090B);
	r0 = D(r0, s1_0_2, 0x3F00FC1E, 0x972104EA, 0xF7F00011, 0x23F70F38);
	r1 = D(r1, s1_0_2, 0xF0F8FD09, 0xF7F40F0A, 0xECFD14FF, 0x03050210);
	r0 = D(r0, s1_1_0, 0xFEE02AF8, 0x05000508, 0x0811FFF8, 0xFA100F09);
	r1 = D(r1, s1_1_0, 0x020402EB, 0x050A0C06, 0xFD1ABF0E, 0xFBF089EF);
	r0 = D(r0, s1_1_1, 0x36081220, 0x020BDF81, 0xDC199A0A, 0x08FBFAD9);
	r1 = D(r1, s1_1_1, 0xEC0FE7E3, 0x04F82426, 0xE9E147F1, 0xBD343DD2);
	r0 = D(r0, s1_1_2, 0x2C030448, 0x81130004, 0x1950037F, 0xD8130503);
	r1 = D(r1, s1_1_2, 0xD106157F, 0x10E60263, 0xCC31EED3, 0x81EE051B);
	r0 = D(r0, s1_2_0, 0xFEE609FB, 0x00F20802, 0xF4D306F2, 0x00FC0904);
	r1 = D(r1, s1_2_0, 0x01FF00F0, 0x032B03FE, 0xFFF20D13, 0x095900F4);
	r0 = D(r0, s1_2_1, 0x1D09F8F0, 0x0DFB04F0, 0x08DFF1F8, 0x08FA0402);
	r1 = D(r1, s1_2_1, 0xF8F90102, 0xEAF3FFF2, 0x07FD2430, 0xCFF9E503);
	r0 = D(r0, s1_2_2, 0xF400FCF1, 0x08080737, 0x202EF924, 0x0F080428);
	r1 = D(r1, s1_2_2, 0x070B061B, 0x03070619, 0x390D02F9, 0xD50909B0);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.044e-02, -1.331e-02, -7.058e-03, 2.799e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.484e-03, 2.947e-03, 4.474e-03, -8.079e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-3x8-BOX-conv2
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
#define l0(x, y) conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv1_pt)
#define l1(x, y) conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv1_pt)
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
	r0 = D(r0, s0_0_0, 0xFCEDF6F8, 0xF9E4ECF9, 0x01FD1D04, 0xFD001402);
	r1 = D(r1, s0_0_0, 0xFF041D0A, 0xFBF8FC06, 0xF8020905, 0xF2FA1407);
	r0 = D(r0, s0_0_1, 0x01B21E0B, 0x05D313FE, 0xFDF62210, 0x0310260B);
	r1 = D(r1, s0_0_1, 0x08FE2202, 0xFAFDFA00, 0xF9F5C8E9, 0xF0FBD3FA);
	r0 = D(r0, s0_0_2, 0x00D40104, 0x04D90808, 0xFCF9F902, 0xFB061907);
	r1 = D(r1, s0_0_2, 0x06FE05FA, 0xFBF2040A, 0x0604140B, 0xF311F608);
	r0 = D(r0, s0_1_0, 0xF5BD290D, 0x05D71A04, 0xF4FF11FF, 0xF90802F4);
	r1 = D(r1, s0_1_0, 0xD6F8E601, 0xF7001209, 0xFFFBFB10, 0xCAF80636);
	r0 = D(r0, s0_1_1, 0xD1A4ADF8, 0x0AE0E001, 0xAEEE9F0F, 0x2100F3F0);
	r1 = D(r1, s0_1_1, 0xFFE10508, 0xE0F70723, 0xE1F78152, 0x9FF0B151);
	r0 = D(r0, s0_1_2, 0x42C51419, 0xF3DECE25, 0x1CF90712, 0xEE0415F1);
	r1 = D(r1, s0_1_2, 0x3B00351D, 0xC0FE582F, 0xF602FA1C, 0xCCF7B504);
	r0 = D(r0, s0_2_0, 0x0EDB0609, 0xF5E71418, 0xFEFAFD05, 0x04FB10FF);
	r1 = D(r1, s0_2_0, 0x07020300, 0x00FD0DFC, 0x0EFF0EF6, 0xBAFF091F);
	r0 = D(r0, s0_2_1, 0xF4CD134A, 0xD4E6F11E, 0x1BF4F610, 0xFB0325F7);
	r1 = D(r1, s0_2_1, 0xF00624F9, 0x0607EFFD, 0x13FAE4FC, 0xC107EA02);
	r0 = D(r0, s0_2_2, 0xDBDF0821, 0x18EA0013, 0x0F01FDFC, 0xFE04FFFA);
	r1 = D(r1, s0_2_2, 0xD30E380A, 0x7F087F99, 0xF906FBFD, 0xDF04C60A);
	r0 = D(r0, s1_0_0, 0xD604FC22, 0xE804FC1E, 0xFA0DFC06, 0x11F504EF);
	r1 = D(r1, s1_0_0, 0xFDEB0BEA, 0xF4060902, 0xDC010605, 0x1B060B0D);
	r0 = D(r0, s1_0_1, 0xF1EDE93B, 0x1CF9D236, 0xF01226FD, 0xE21609FA);
	r1 = D(r1, s1_0_1, 0xAED423BF, 0x0701060D, 0xE6C1060D, 0xEAD323FC);
	r0 = D(r0, s1_0_2, 0xEB2EDE2A, 0xE708F622, 0xFBFFFEFC, 0xE2010DFC);
	r1 = D(r1, s1_0_2, 0x05E4F0EC, 0x01EC0C13, 0xECF9F5FA, 0x1EFC0412);
	r0 = D(r0, s1_1_0, 0x0C0FE449, 0x0406F22D, 0x110200FA, 0xF70009F7);
	r1 = D(r1, s1_1_0, 0xF1020C0B, 0x0107F706, 0x1B10E41C, 0x0607020C);
	r0 = D(r0, s1_1_1, 0xF9F7CA7E, 0x16E90C3C, 0xFB2B1B1B, 0xF6FF3540);
	r1 = D(r1, s1_1_1, 0x1BF62937, 0x1D0C1808, 0xB10A1B40, 0x10FE3C01);
	r0 = D(r0, s1_1_2, 0xC400D628, 0xEF14D322, 0xED030101, 0xFB0200FD);
	r1 = D(r1, s1_1_2, 0xF3DB0908, 0x5B35A70C, 0xD704FBEC, 0x160FEA25);
	r0 = D(r0, s1_2_0, 0x09FDEE24, 0xF309F91F, 0xFE00FFFF, 0x0AFCFF04);
	r1 = D(r1, s1_2_0, 0x1B030003, 0x08020001, 0x13FAF701, 0xFF201414);
	r0 = D(r0, s1_2_1, 0xF103C938, 0xEC0BE91C, 0x1402F007, 0xFA01FBF9);
	r1 = D(r1, s1_2_1, 0xEEFE0012, 0xF1080804, 0x27FB010D, 0xED172509);
	r0 = D(r0, s1_2_2, 0xE716D526, 0xF8FFE312, 0x02FD0605, 0x00FEFF03);
	r1 = D(r1, s1_2_2, 0xF90008EA, 0x0EDEDAD8, 0x0A0403FF, 0xFD091113);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(2.375e-02, 1.312e-02, 3.898e-02, -1.154e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(1.083e-03, -1.151e-02, 1.157e-02, 8.265e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-3x8-BOX-conv3
//!HOOK LUMA
//!COMPUTE 16 8 8 8
//!BIND conv2
//!BIND LUMA
//!SAVE conv3
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv2_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv2_pt)
#define l1(x, y) conv2_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv2_pt)
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
	r0 = D(r0, s0_0_0, 0x0418DF21, 0x0907DB17, 0x08000002, 0xD23F3DB8);
	r1 = D(r1, s0_0_0, 0xFB0D0008, 0xF70909FB, 0xFBF6FF1E, 0x02FF0DFB);
	r0 = D(r0, s0_0_1, 0x09F602CF, 0x100B17DC, 0xDC1062B7, 0x1FF0A46C);
	r1 = D(r1, s0_0_1, 0x08FAEB09, 0xF9100CEC, 0x0CDA964B, 0xFCF5FBFF);
	r0 = D(r0, s0_0_2, 0xFCFBF61E, 0xF9F9DE2F, 0x08D82FE2, 0xF8031AD8);
	r1 = D(r1, s0_0_2, 0xFFF709F9, 0x02F8FE01, 0x05FD12EA, 0xFE06FF02);
	r0 = D(r0, s0_1_0, 0x33EEA64A, 0x48F3F908, 0xF9FC19E2, 0x77171BEA);
	r1 = D(r1, s0_1_0, 0x1B2228CD, 0x05050EF0, 0x13FC0ABA, 0x030004FB);
	r0 = D(r0, s0_1_1, 0xD27F77B6, 0xC607FDF0, 0x18DF9762, 0xD62DAE00);
	r1 = D(r1, s0_1_1, 0x0D550303, 0xDD6BED09, 0xE96E7FC7, 0x4AE024E2);
	r0 = D(r0, s0_1_2, 0x12ECE000, 0x140CEDFA, 0xA016AD27, 0xFAF62200);
	r1 = D(r1, s0_1_2, 0x00F707FD, 0xF90701F6, 0x00E503FF, 0x07010102);
	r0 = D(r0, s0_2_0, 0x180B07EA, 0x0D030703, 0xF8FF1003, 0x19FDFC11);
	r1 = D(r1, s0_2_0, 0x08F8FA11, 0xFDF7FD00, 0xD700FE28, 0xFA05FD03);
	r0 = D(r0, s0_2_1, 0xF9DE0408, 0x03F2FBFC, 0xD90F1CD7, 0xFB03FAF9);
	r1 = D(r1, s0_2_1, 0xE2FFEEF6, 0xD9E403FB, 0xC6B5D0FE, 0x0305FE04);
	r0 = D(r0, s0_2_2, 0x1A0FFA05, 0x0202FF03, 0xF4F20A04, 0x0BF7FA05);
	r1 = D(r1, s0_2_2, 0x010402FE, 0xF5F80303, 0xC308FC10, 0x0403FB02);
	r0 = D(r0, s1_0_0, 0x0B02A8E8, 0x3006BEEE, 0x1AF7D109, 0xF81181C7);
	r1 = D(r1, s1_0_0, 0x1EFACC14, 0x0B04F9FB, 0x11FBCF12, 0x0AFEF301);
	r0 = D(r0, s1_0_1, 0xFD0510F5, 0x23FBF307, 0xF3DA815B, 0x0FF11A04);
	r1 = D(r1, s1_0_1, 0x20FC0500, 0x06010505, 0x1603C7F4, 0x0F01F9F5);
	r0 = D(r0, s1_0_2, 0xF803FCFC, 0xFCFF04EC, 0xFDF0F925, 0xEF0902F5);
	r1 = D(r1, s1_0_2, 0xF801FC02, 0x01FBFEFF, 0x0203090C, 0x09030100);
	r0 = D(r0, s1_1_0, 0xFEE79AEF, 0x08EDEBDD, 0xF301F109, 0xF1EBEA89);
	r1 = D(r1, s1_1_0, 0x1602E3E8, 0x180EEFED, 0xF5129112, 0xFFF8F508);
	r0 = D(r0, s1_1_1, 0x1B36EFCA, 0x3C5600DF, 0x0E24F301, 0x2C0A0925);
	r1 = D(r1, s1_1_1, 0x33D3021B, 0x251109E9, 0x050CF137, 0x221AF608);
	r0 = D(r0, s1_1_2, 0xFEEA01F6, 0x07E70105, 0x1853FE11, 0xF5FBFCF6);
	r1 = D(r1, s1_1_2, 0x03F503FD, 0x060701FC, 0xEDE4F719, 0x08F9FEFD);
	r0 = D(r0, s1_2_0, 0xFEF301EE, 0x09FFFCFA, 0xFF01FE10, 0x07F8FBED);
	r1 = D(r1, s1_2_0, 0xFDFBFE04, 0xFE020109, 0xFC030928, 0x0A040005);
	r0 = D(r0, s1_2_1, 0xFD10F5DA, 0xE9FD03F6, 0xFC03000C, 0xF3FC0AF3);
	r1 = D(r1, s1_2_1, 0x02060203, 0x1111040F, 0x0D01092E, 0x05FA00FD);
	r0 = D(r0, s1_2_2, 0xF2DB09FD, 0x030800FD, 0xECE6FE07, 0xF400F8FC);
	r1 = D(r1, s1_2_2, 0xFEF50001, 0xF70301FB, 0xFE29FFF7, 0x04010000);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-3.479e-02, -9.892e-03, -7.584e-03, -3.773e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-2.545e-02, -2.582e-02, -8.819e-03, 5.238e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-3x8-BOX-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv3
//!BIND LUMA
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 1
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv3_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv3_pt)
#define l1(x, y) conv3_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv3_pt)
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
	r0 = D(r0, s0_0_0, 0x0106FC07, 0x000200FF, 0x00FC00FE, 0x00FF0001);
	r0 = D(r0, s0_0_1, 0x04FF0409, 0x000409EF, 0x00FF02FE, 0x00FFFD08);
	r0 = D(r0, s0_0_2, 0xFF0000FF, 0xFFFF0301, 0x01000000, 0x020002FF);
	r0 = D(r0, s0_1_0, 0x08C0EE09, 0xFCED06FE, 0x0231F20E, 0xFE1B03FF);
	r0 = D(r0, s0_1_1, 0xC00C1D20, 0x38E3C7ED, 0xF4051A31, 0x1D0F0ABA);
	r0 = D(r0, s0_1_2, 0x00FDFDFE, 0x10021201, 0xFA00FDFC, 0x04020507);
	r0 = D(r0, s0_2_0, 0xFFFCFB01, 0xFFFAFF01, 0x0312F702, 0xFF06FF01);
	r0 = D(r0, s0_2_1, 0x0AFDFA00, 0x00FC09FE, 0xEAFDFA03, 0x1608E50A);
	r0 = D(r0, s0_2_2, 0xFE00FE00, 0xFE00FF00, 0xFC00FDFF, 0x05FF0001);
	r0 = D(r0, s1_0_0, 0xF00A07FE, 0xFAFE0001, 0xF90001FF, 0x00010000);
	r0 = D(r0, s1_0_1, 0x010715ED, 0xF41316F7, 0xFFFB0406, 0xF2FEFE01);
	r0 = D(r0, s1_0_2, 0x000203FF, 0x000007F5, 0x000101FF, 0xFF0104FF);
	r0 = D(r0, s1_1_0, 0x010E070B, 0xF9010501, 0xF2E50E0E, 0xEB0802FC);
	r0 = D(r0, s1_1_1, 0x0C1FCA12, 0x1A2CD018, 0x15F4FBBD, 0x28C010F9);
	r0 = D(r0, s1_1_2, 0x010004F9, 0x000201F7, 0x01FE0005, 0x0102FDED);
	r0 = D(r0, s1_2_0, 0x00FF0200, 0xFFFF0001, 0x0000FE05, 0xFF000203);
	r0 = D(r0, s1_2_1, 0x00FF02FE, 0x02FE03FF, 0xFF02F417, 0x0106F30A);
	r0 = D(r0, s1_2_2, 0x00000100, 0x000002FD, 0x0000FE04, 0x0002FA07);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-2.992e-08, -2.974e-08, -2.989e-08, -2.973e-08);
	f0 = tanh(f0);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(f0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(f0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(f0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(f0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
