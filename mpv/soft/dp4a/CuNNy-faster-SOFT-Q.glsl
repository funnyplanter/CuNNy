// CuNNy faster SOFT (dp4a)
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


//!DESC CuNNy-faster-SOFT-in
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
	r0 += V4(-6.186e-02, 2.542e-02, -3.126e-02, 4.276e-01) * s0_0_0;
	r1 += V4(1.024e-01, 2.983e-01, 1.847e-02, 7.229e-03) * s0_0_0;
	r0 += V4(2.466e-01, -3.970e-02, -3.019e-01, -2.549e-01) * s0_0_1;
	r1 += V4(3.331e-01, -1.843e-01, 4.878e-03, -1.012e+00) * s0_0_1;
	r0 += V4(-1.487e-02, 1.207e-02, 1.938e-02, -1.742e-01) * s0_0_2;
	r1 += V4(2.189e-02, -1.410e-01, -1.995e-02, 3.394e-02) * s0_0_2;
	r0 += V4(-3.043e-02, -5.645e-02, -2.347e-01, 6.738e-01) * s0_1_0;
	r1 += V4(2.826e-01, -6.736e-01, -9.939e-01, -3.110e-03) * s0_1_0;
	r0 += V4(-1.997e-01, 7.020e-01, 1.021e+00, -6.116e-01) * s0_1_1;
	r1 += V4(-1.371e+00, 8.032e-01, 9.512e-01, 1.035e+00) * s0_1_1;
	r0 += V4(1.465e-01, -4.654e-03, -1.250e-01, -9.517e-02) * s0_1_2;
	r1 += V4(1.188e-01, -8.951e-02, 3.938e-02, -5.260e-02) * s0_1_2;
	r0 += V4(-3.857e-02, 3.157e-02, 2.097e-02, -1.312e-01) * s0_2_0;
	r1 += V4(2.049e-02, -3.059e-01, 4.589e-02, -8.052e-03) * s0_2_0;
	r0 += V4(9.864e-02, 9.063e-02, -3.894e-02, 3.186e-03) * s0_2_1;
	r1 += V4(3.989e-02, 3.252e-01, -3.164e-02, -2.699e-02) * s0_2_1;
	r0 += V4(-3.073e-02, -7.637e-01, -1.021e-01, 1.632e-01) * s0_2_2;
	r1 += V4(1.266e-01, -3.480e-02, -1.752e-02, 1.867e-02) * s0_2_2;
	r0 += V4(4.001e-03, 2.329e-06, 2.258e-04, 3.230e-03);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(1.177e-03, 2.971e-03, -1.022e-04, 6.960e-04);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-faster-SOFT-conv1
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
	r0 = D(r0, s0_0_0, 0x0D05D820, 0xF6D824DE, 0xFEC323C8, 0x00E7F5D4);
	r1 = D(r1, s0_0_0, 0xFBF3F5E8, 0xFBF5D4E0, 0x09130523, 0xF7E700F4);
	r0 = D(r0, s0_0_1, 0xF0360F7F, 0xF1DE0AFD, 0x04D223DA, 0x01FB29F3);
	r1 = D(r1, s0_0_1, 0xFA0543DE, 0xF511E6EE, 0xEC7F12D6, 0x0BDD10DB);
	r0 = D(r0, s0_0_2, 0x07EC0F12, 0x00EF01ED, 0xF9F90604, 0xF912EC14);
	r1 = D(r1, s0_0_2, 0xEC17F50F, 0xFD0A0126, 0x0F2F082C, 0x01E60BE4);
	r0 = D(r0, s0_1_0, 0xC6E7D1C6, 0xEA62E699, 0xEE3DF702, 0xFBF0F224);
	r1 = D(r1, s0_1_0, 0xF9DBEB3F, 0xFEEEEBF1, 0x00F3F1E0, 0xED254210);
	r0 = D(r0, s0_1_1, 0x207FD601, 0xFA34FB38, 0x009624F9, 0x08AD1D2A);
	r1 = D(r1, s0_1_1, 0xDE81C226, 0x30B7DEEC, 0xFDAAF337, 0xE7BDFE22);
	r0 = D(r0, s0_1_2, 0xE51EF320, 0xF6FAFE04, 0x035D001C, 0xC67FE7FB);
	r1 = D(r1, s0_1_2, 0xEC32F9F6, 0x1F52F46B, 0xFB04F436, 0xF3F6FC07);
	r0 = D(r0, s0_2_0, 0xE9D507A0, 0xF3F4031B, 0xFBD701B0, 0x0604FCFC);
	r1 = D(r1, s0_2_0, 0x0A1DF33F, 0x0029FBE5, 0xF8F503F5, 0x197FECE3);
	r0 = D(r0, s0_2_1, 0x19AE0BDB, 0x0DFA0114, 0x313803FD, 0x05EB08D5);
	r1 = D(r1, s0_2_1, 0x1A390098, 0x091AECDD, 0xEDCC02E6, 0xF81DFF33);
	r0 = D(r0, s0_2_2, 0x0BD709E2, 0x03FB02F6, 0xFF40F17F, 0xF202FE07);
	r1 = D(r1, s0_2_2, 0x0501FC0E, 0x11CD12D5, 0xF6DC06B4, 0x04EFFEE1);
	r0 = D(r0, s1_0_0, 0x090315EA, 0x0B0FF80B, 0x121B0019, 0x050BFB0E);
	r1 = D(r1, s1_0_0, 0x06010FFC, 0x01020CFD, 0xFCF804EC, 0x0B0C0301);
	r0 = D(r0, s1_0_1, 0xFEB645B7, 0x0B18140A, 0x0406011D, 0xFBFEFCFF);
	r1 = D(r1, s1_0_1, 0xEE01200D, 0xFEDE2A10, 0xD6D80D01, 0x040DF117);
	r0 = D(r0, s1_0_2, 0xFFE91B07, 0x0403090D, 0x07F901FF, 0xFF1213E4);
	r1 = D(r1, s1_0_2, 0x021507E1, 0xF8D617F7, 0xF3D104D9, 0x050FF718);
	r0 = D(r0, s1_1_0, 0xEC15E6DD, 0x05ED0BC1, 0x00F217BE, 0x030BF412);
	r1 = D(r1, s1_1_0, 0x02EB1A21, 0x09F51E14, 0x0508FB08, 0xFBDF38B9);
	r0 = D(r0, s1_1_1, 0xE081AE81, 0x1CE5D2D8, 0xD6A70860, 0x030AFA2F);
	r1 = D(r1, s1_1_1, 0xCDCC1766, 0xD4E8EB3E, 0x8117FF20, 0x024FFC1A);
	r0 = D(r0, s1_1_2, 0x1C1CEDFF, 0x0407FC04, 0xF7B6F9B3, 0xF4CC0CA1);
	r1 = D(r1, s1_1_2, 0x0CF418E5, 0xE5C3F0E5, 0x1F07F00D, 0xFC10FE0B);
	r0 = D(r0, s1_2_0, 0xD8100614, 0xE2020408, 0x07F21702, 0xF20200FE);
	r1 = D(r1, s1_2_0, 0xE3F8F1F1, 0x03F001CD, 0x0F08FD0A, 0xA5B619B3);
	r0 = D(r0, s1_2_1, 0xAE7F0038, 0x010DFAFA, 0xB80EFDDA, 0x0C100214);
	r1 = D(r1, s1_2_1, 0xC8C415EA, 0x2836F6E3, 0x0C08021F, 0x0E81F8EF);
	r0 = D(r0, s1_2_2, 0x1624FF1A, 0xFFFE0705, 0xEADBE8DC, 0xBF1F02FA);
	r1 = D(r1, s1_2_2, 0x050E00FE, 0x1B2BDD1F, 0x14030419, 0xFDF7190D);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-faster-SOFT-conv2
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
	r0 = D(r0, s0_0_0, 0xFFFE0000, 0xE5F504E8, 0xFEF503FE, 0xEFFE0201);
	r1 = D(r1, s0_0_0, 0x02FC00FC, 0xF3F10400, 0xFC01FE00, 0xF2FC0101);
	r0 = D(r0, s0_0_1, 0x02010003, 0x00F7FCF8, 0x13FCFAEA, 0x08EC03FE);
	r1 = D(r1, s0_0_1, 0x06FFFDF9, 0x0CFAF9F1, 0xFCF2010C, 0x04FB00F7);
	r0 = D(r0, s0_0_2, 0xFF0100FD, 0x01F8FEFF, 0xFC040302, 0x0012FAE0);
	r1 = D(r1, s0_0_2, 0xF9FC02FC, 0xFCF901FA, 0x0504FFF9, 0x0204FEF8);
	r0 = D(r0, s0_1_0, 0x01FC0201, 0x0C03FCFB, 0xEEF307FF, 0xE9FAFBF9);
	r1 = D(r1, s0_1_0, 0xF1F40802, 0xFBE006FD, 0xFAF9FFF9, 0xFC0302F4);
	r0 = D(r0, s0_1_1, 0x1AFBFBEE, 0x020522FC, 0x53E5EDD7, 0x42E908ED);
	r1 = D(r1, s0_1_1, 0x44EBECD1, 0x1B22EBE0, 0x25C005DA, 0x15C600F2);
	r0 = D(r0, s0_1_2, 0xFCF40101, 0x03FCFC00, 0xF1DBFEE8, 0x0A0FE3E3);
	r1 = D(r1, s0_1_2, 0xF7EE04F8, 0xFDF5F8FF, 0x0810F4E7, 0x050FF8DF);
	r0 = D(r0, s0_2_0, 0xF7FB0101, 0xFFFEFC00, 0x10FAFFF9, 0x0AFEFEFF);
	r1 = D(r1, s0_2_0, 0x05FAFDFE, 0xFF00FFF5, 0x00F60100, 0x0B00FCFA);
	r0 = D(r0, s0_2_1, 0x30F7F6F4, 0x0000FA01, 0x0EF118F1, 0xFDFD07F8);
	r1 = D(r1, s0_2_1, 0x0FE612FD, 0x09FA05F9, 0x0BFA09ED, 0x0BF61CEC);
	r0 = D(r0, s0_2_2, 0x04FF02E4, 0xFDFFFEFE, 0xF71045F3, 0xFFFD12FF);
	r1 = D(r1, s0_2_2, 0x01EA47E6, 0x01F804F9, 0x04F916E9, 0x040148EE);
	r0 = D(r0, s1_0_0, 0xFFFDFD05, 0x132AD415, 0x03010C08, 0xF80106FE);
	r1 = D(r1, s1_0_0, 0x05FEF408, 0x08F41012, 0xE5EC02F7, 0xFCFD0005);
	r0 = D(r0, s1_0_1, 0xFF0200FD, 0x06FF0701, 0xFB070DE9, 0x1AFD1903);
	r1 = D(r1, s1_0_1, 0xFEFBCFFD, 0x0F030BF3, 0x24E4EBFE, 0x0E0005F9);
	r0 = D(r0, s1_0_2, 0xFB0102FE, 0x04FFFFFC, 0xEC06FD00, 0xD50303FC);
	r1 = D(r1, s1_0_2, 0x06FE0006, 0xFE02FC00, 0xFE00FAFB, 0x0003FEFF);
	r0 = D(r0, s1_1_0, 0x01FB0000, 0x00DF02EB, 0x040C0304, 0xFE0806E1);
	r1 = D(r1, s1_1_0, 0x030C0502, 0x0408ECFF, 0x010AF5F2, 0xFB04F9FD);
	r0 = D(r0, s1_1_1, 0x000A09EF, 0xFAE606FD, 0x1E289399, 0x13FDD711);
	r1 = D(r1, s1_1_1, 0x1338FC9A, 0x1C170ADA, 0x344AD997, 0x3E1DF7D7);
	r0 = D(r0, s1_1_2, 0xFFFBF907, 0xFC0501FF, 0xF2F8ECF3, 0x0A0C05EA);
	r1 = D(r1, s1_1_2, 0x9703F5FF, 0xF903FC02, 0xE610FCE8, 0xE30800F1);
	r0 = D(r0, s1_2_0, 0x0106FE04, 0x0300FE01, 0x03FCFDF7, 0x000A01FD);
	r1 = D(r1, s1_2_0, 0x02FD0004, 0x0310FE04, 0x061C00F8, 0xFC0BFEE9);
	r0 = D(r0, s1_2_1, 0x0A37FC0B, 0x02FD0100, 0x050EFAEF, 0x0103FBF4);
	r1 = D(r1, s1_2_1, 0x0903F103, 0x01FBFFF8, 0x09F5F9F9, 0x0300E3FD);
	r0 = D(r0, s1_2_2, 0xFD05FFF9, 0x01010001, 0xFA01FEE7, 0xFFFA0301);
	r1 = D(r1, s1_2_2, 0x0A000007, 0x02000100, 0x0A040703, 0x02FC0202);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-faster-SOFT-out-shuffle
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
	r0 += M4(2.510e-01, -2.566e-02, 1.076e-01, 9.371e-03, -1.089e-07, 4.047e-07, -2.185e-07, -3.217e-07, -3.883e-03, -1.500e-03, 6.819e-04, -6.391e-04, 8.959e-03, -6.730e-03, -6.848e-03, -2.396e-03) * s0_0_0;
	r0 += M4(-3.139e-01, 3.573e-01, -7.421e-02, -2.367e-01, -1.290e-07, 8.812e-08, -8.623e-07, 5.537e-07, 1.067e-02, 8.927e-03, -6.301e-04, -4.654e-03, 3.959e-03, 4.633e-02, 7.129e-03, 3.835e-03) * s0_0_1;
	r0 += M4(-1.325e-02, -1.538e-01, -7.366e-03, 6.785e-04, 1.031e-07, -3.190e-07, 1.196e-06, -1.594e-07, 3.005e-03, 4.086e-03, 3.224e-03, -1.480e-02, 3.055e-04, 1.465e-03, -6.149e-04, -4.676e-03) * s0_0_2;
	r0 += M4(-8.878e-03, -9.821e-04, 1.096e-01, -3.794e-03, 3.351e-07, -2.068e-03, 1.239e-06, -1.966e-04, 6.028e-02, 3.110e-04, 1.110e-01, 3.410e-03, 1.037e-01, 2.405e-02, 1.284e-01, 6.533e-04) * s0_1_0;
	r0 += M4(1.207e-02, -1.241e-02, 1.945e-01, 3.271e-01, -1.295e-06, -9.311e-03, 1.318e-04, 1.581e-04, -4.893e-01, 9.114e-02, 1.602e-01, 5.961e-01, 2.548e-01, -6.932e-01, 2.209e-02, -4.812e-02) * s0_1_1;
	r0 += M4(-4.439e-03, 8.852e-03, 1.795e-02, -2.674e-03, 1.064e-06, 1.140e-02, -1.323e-04, 3.804e-05, 8.667e-03, -2.150e-01, -2.854e-02, -6.806e-02, 1.164e-02, 1.255e-01, 4.803e-03, 1.019e-02) * s0_1_2;
	r0 += M4(-2.768e-05, 1.131e-04, -3.375e-04, 2.552e-07, 4.732e-03, -3.805e-04, 1.789e-03, 1.529e-03, 1.551e-03, 6.016e-05, -3.849e-02, -6.007e-03, -3.805e-03, 2.920e-03, 3.716e-02, -2.673e-03) * s0_2_0;
	r0 += M4(1.358e-04, -1.404e-04, -6.103e-03, -4.832e-04, -3.505e-01, 2.370e-02, -1.042e-01, -1.921e-02, 6.589e-03, 4.104e-03, -9.547e-02, -8.447e-02, -3.214e-03, 2.240e-02, -9.908e-02, -3.365e-01) * s0_2_1;
	r0 += M4(-3.990e-06, -3.952e-06, 2.283e-03, -1.580e-03, 1.745e-02, -6.855e-01, 7.016e-02, 3.044e-01, 2.304e-03, -6.626e-04, 2.136e-02, -3.143e-02, 2.451e-03, -4.946e-03, -1.381e-02, 7.494e-03) * s0_2_2;
	r0 += M4(2.101e-02, 8.086e-06, -1.418e-02, -1.513e-03, 2.097e-03, 1.218e-03, -8.258e-03, -7.411e-04, -6.468e-02, 2.912e-03, -3.844e-03, -2.964e-03, 4.454e-02, 2.831e-03, 2.538e-03, 2.714e-03) * s1_0_0;
	r0 += M4(-4.562e-02, 5.503e-02, 2.661e-02, 1.529e-03, -6.190e-02, 2.581e-02, 1.711e-02, 1.976e-03, -1.064e-01, -2.280e-01, 2.075e-03, 1.422e-02, 2.725e-01, 1.950e-01, -1.562e-02, 4.893e-03) * s1_0_1;
	r0 += M4(5.021e-03, -1.778e-02, -3.090e-04, -1.526e-02, -1.413e-02, 6.117e-03, -9.800e-03, -1.895e-02, -7.460e-03, -3.119e-02, -5.146e-03, 9.612e-03, -4.132e-03, 7.254e-02, 2.927e-03, 6.278e-03) * s1_0_2;
	r0 += M4(3.689e-02, 1.056e-02, 4.516e-02, -1.052e-02, 8.769e-03, 1.687e-03, 7.560e-03, 6.384e-04, -7.053e-02, 5.967e-03, -9.399e-02, 1.409e-02, -4.725e-02, -2.427e-02, -1.140e-01, -1.150e-02) * s1_1_0;
	r0 += M4(2.391e-01, 2.252e-01, -8.145e-01, -1.859e-02, -3.330e-01, -1.535e-02, -3.662e-01, 1.404e-03, 5.684e-01, 6.219e-02, 7.237e-02, -4.071e-01, -1.978e-01, -1.825e-01, 5.882e-01, -1.812e-01) * s1_1_1;
	r0 += M4(-1.739e-02, -3.925e-02, 1.183e-02, -2.045e-01, 1.211e-02, 4.067e-01, 3.819e-02, 3.136e-01, -5.208e-03, 1.247e-01, 2.798e-02, 4.583e-02, 3.473e-03, 2.618e-02, -2.886e-02, 1.554e-01) * s1_1_2;
	r0 += M4(6.890e-04, -5.187e-04, 2.202e-02, 1.943e-03, -3.007e-03, -1.668e-03, 5.449e-03, 9.238e-05, -5.150e-03, 2.220e-03, -3.884e-03, 4.636e-03, -8.638e-04, 9.015e-05, -2.889e-02, -5.227e-03) * s1_2_0;
	r0 += M4(1.531e-03, 4.723e-03, 6.714e-02, 3.290e-02, 4.806e-03, 7.509e-03, -9.137e-02, 1.244e-02, -5.932e-03, -8.205e-03, 9.082e-02, 4.309e-02, 8.945e-04, -8.047e-03, -3.722e-02, -7.220e-03) * s1_2_1;
	r0 += M4(-1.170e-03, 7.123e-03, -1.159e-02, -1.777e-02, -2.442e-04, -1.921e-02, -2.884e-02, 7.229e-02, 1.425e-03, -1.869e-03, -2.775e-03, 2.045e-02, -9.966e-04, -2.167e-03, -3.166e-03, 8.534e-03) * s1_2_2;
	r0 += V4(1.471e-09, -2.972e-10, -1.438e-08, -1.472e-08);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
