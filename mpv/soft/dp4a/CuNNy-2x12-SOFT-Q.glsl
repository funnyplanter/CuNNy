// CuNNy 2x12 SOFT (dp4a)
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


//!DESC CuNNy-2x12-SOFT-in
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
	r0 += V4(1.399e-02, -8.613e-01, 4.510e-02, -6.198e-02) * s0_0_0;
	r1 += V4(3.144e-03, 3.465e-03, -1.064e-02, -3.830e-01) * s0_0_0;
	r2 += V4(1.107e-01, -1.557e-02, 5.595e-02, -4.578e-01) * s0_0_0;
	r0 += V4(6.443e-01, 8.875e-01, -8.281e-02, -2.051e-01) * s0_0_1;
	r1 += V4(-1.004e+00, 1.209e-02, 3.660e-02, 1.245e-01) * s0_0_1;
	r2 += V4(3.588e-01, 5.996e-01, -1.519e-01, 6.267e-01) * s0_0_1;
	r0 += V4(-6.438e-01, -9.581e-03, -3.701e-01, -2.779e-03) * s0_0_2;
	r1 += V4(-1.427e-02, -9.016e-03, -3.210e-02, 1.661e-02) * s0_0_2;
	r2 += V4(2.842e-02, 4.016e-01, 1.525e-01, -7.983e-02) * s0_0_2;
	r0 += V4(-3.874e-01, -9.402e-02, -4.577e-02, -1.556e-01) * s0_1_0;
	r1 += V4(-3.956e-03, 4.769e-02, 1.407e-02, -2.487e-01) * s0_1_0;
	r2 += V4(2.265e-01, -1.547e-02, -3.945e-04, 6.262e-01) * s0_1_0;
	r0 += V4(-3.448e-01, 7.295e-02, 8.072e-01, 8.032e-01) * s0_1_1;
	r1 += V4(1.008e+00, 1.200e-01, 8.973e-01, 6.333e-01) * s0_1_1;
	r2 += V4(-1.332e+00, -5.254e-01, -7.528e-01, -2.037e-01) * s0_1_1;
	r0 += V4(7.315e-01, 5.366e-03, -2.933e-01, -1.430e-01) * s0_1_2;
	r1 += V4(8.885e-03, 9.111e-02, -9.074e-01, -1.773e-02) * s0_1_2;
	r2 += V4(2.101e-01, -4.435e-01, 9.942e-02, -5.028e-01) * s0_1_2;
	r0 += V4(4.129e-01, -1.551e-02, -2.574e-01, 5.755e-03) * s0_2_0;
	r1 += V4(1.012e-03, -1.300e-02, -4.951e-03, -6.018e-02) * s0_2_0;
	r2 += V4(1.625e-02, 2.482e-02, -5.238e-02, -1.716e-01) * s0_2_0;
	r0 += V4(-3.211e-01, 1.562e-02, 1.657e-01, -9.189e-02) * s0_2_1;
	r1 += V4(-5.826e-04, -6.887e-01, 2.155e-02, 3.070e-01) * s0_2_1;
	r2 += V4(1.294e-01, -2.412e-02, 4.100e-01, -4.229e-01) * s0_2_1;
	r0 += V4(-9.839e-02, 2.218e-03, 3.019e-02, 1.475e-02) * s0_2_2;
	r1 += V4(-9.086e-04, 2.603e-01, -1.723e-02, -3.740e-01) * s0_2_2;
	r2 += V4(-2.375e-02, -3.243e-03, 2.389e-01, 5.905e-01) * s0_2_2;
	r0 += V4(-4.804e-03, -1.492e-04, -1.916e-03, 1.624e-03);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-8.291e-05, -5.733e-04, 2.415e-06, 1.064e-03);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(-2.745e-03, -1.936e-04, -3.452e-03, -4.412e-03);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-2x12-SOFT-conv1
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
	r0 = D(r0, s0_0_0, 0x0B03010A, 0x0E02FE01, 0x090E1CDE, 0xE8F1F2F3);
	r1 = D(r1, s0_0_0, 0x0BFFFFFF, 0xE6F50405, 0xFEEEFB1D, 0x12F4F203);
	r2 = D(r2, s0_0_0, 0xF506FE03, 0x01FE06FF, 0xF1FEFE00, 0xD70E0712);
	r0 = D(r0, s0_0_1, 0xD803FE00, 0xB60200F8, 0x0F3B16EA, 0xD6E2F9EE);
	r1 = D(r1, s0_0_1, 0xDF1504F3, 0xB8F9F100, 0x900AFD1F, 0x0DEC0005);
	r2 = D(r2, s0_0_1, 0x160A0802, 0x1D000AF2, 0x970308F9, 0x0E59FD20);
	r0 = D(r0, s0_0_2, 0xFD00FFFB, 0x01F8000C, 0xF72FF4E8, 0x18E4FCFB);
	r1 = D(r1, s0_0_2, 0x010605F8, 0xF1050607, 0xEEFFEF17, 0x0FFDFAFE);
	r2 = D(r2, s0_0_2, 0x18FC0B09, 0xC4FA17F5, 0x1D0A0AFF, 0xC5F0FF11);
	r0 = D(r0, s0_1_0, 0x7F00EDF0, 0x34FCFBEE, 0xC9C7EDFF, 0x21EEF1E1);
	r1 = D(r1, s0_1_0, 0xFF0A01F7, 0x0908FD00, 0x4321F306, 0x13FFF0FB);
	r2 = D(r2, s0_1_0, 0xEB060AFC, 0x00FE10F5, 0x1E0BF60F, 0xE71407FB);
	r0 = D(r0, s0_1_1, 0x901AF8FF, 0x81261BEE, 0xD3E5FA1C, 0xA3D716D9);
	r1 = D(r1, s0_1_1, 0x7EFCF7EC, 0x7F07F3E5, 0x7F0BFFCA, 0x54C8DFF8);
	r2 = D(r2, s0_1_1, 0x811A1B00, 0xE1113AF4, 0x810D18FE, 0x5139E7D3);
	r0 = D(r0, s0_1_2, 0xF3F7F6FC, 0x7FECF713, 0x01EA8122, 0x22D7C1DF);
	r1 = D(r1, s0_1_2, 0x00FCF309, 0xFB090B08, 0xDDF4F71A, 0xD000DDF4);
	r2 = D(r2, s0_1_2, 0x7F1D06F8, 0x4C173001, 0x23FAD0EB, 0x175B8121);
	r0 = D(r0, s0_2_0, 0x21FCE7FA, 0x17EFFCF6, 0x09F50816, 0x14D1F1FA);
	r1 = D(r1, s0_2_0, 0xE3070CF9, 0x02F602FB, 0xEFECF4FA, 0xFAFC00FC);
	r2 = D(r2, s0_2_0, 0xEFFE070B, 0x0CF209F5, 0x0B0CF609, 0xE70BFB18);
	r0 = D(r0, s0_2_1, 0xF403810B, 0xDE0CEADC, 0x3E02E50E, 0x2CC9FCD3);
	r1 = D(r1, s0_2_1, 0x96051611, 0xF80600FE, 0x0704DFF8, 0x99F73C0C);
	r2 = D(r2, s0_2_1, 0xE1FBFF07, 0xE6021AE3, 0x741BCD12, 0x0614C7F9);
	r0 = D(r0, s0_2_2, 0x0A00FC04, 0x12F20703, 0x0BDBA809, 0x09DBF2E7);
	r1 = D(r1, s0_2_2, 0x2010F003, 0xF605F102, 0xEDEA8113, 0x060C12FA);
	r2 = D(r2, s0_2_2, 0x2214E407, 0x00ED0BF7, 0x1B0BEA06, 0x1EEA0221);
	r0 = D(r0, s1_0_0, 0xFC0DA902, 0xFFCD8503, 0xD78DFFDE, 0x1CF7C901);
	r1 = D(r1, s1_0_0, 0x050308F8, 0x04260B0F, 0x0B062710, 0x181CFDF4);
	r2 = D(r2, s1_0_0, 0x00FD0601, 0xF0F5EB0E, 0x07F7C607, 0xF71A560D);
	r0 = D(r0, s1_0_1, 0x0606E200, 0x1B0729FE, 0x2990E411, 0x093F0B0C);
	r1 = D(r1, s1_0_1, 0x10053A01, 0x15108114, 0x0006811F, 0x0A263605);
	r2 = D(r2, s1_0_1, 0xEEEF0AFE, 0xCD001D02, 0x0130E711, 0x0D8CDDF0);
	r0 = D(r0, s1_0_2, 0x03061902, 0x0D01050A, 0x35E3FFCE, 0x0A210C12);
	r1 = D(r1, s1_0_2, 0xFBFC11FD, 0xEEFC1601, 0xF3F9FBFA, 0x0803EC06);
	r2 = D(r2, s1_0_2, 0xECFB4EFD, 0xCF07E117, 0xF7043EFB, 0x50EECAEB);
	r0 = D(r0, s1_1_0, 0x090524EF, 0xFCEFFBFB, 0x224200D3, 0x1805ECEE);
	r1 = D(r1, s1_1_0, 0xF2ED0601, 0x05E6E805, 0x10810A1D, 0x0AD5F90D);
	r2 = D(r2, s1_1_0, 0xF6F8F4F4, 0xE315EAFE, 0x0EFFFA1A, 0x101DE2FA);
	r0 = D(r0, s1_1_1, 0xF1F4F40B, 0x23E7F6CA, 0xC27C3181, 0x13FE1AFF);
	r1 = D(r1, s1_1_1, 0xE5D3D0E2, 0xF8DEFD1D, 0x24E7BC81, 0x08F8C908);
	r2 = D(r2, s1_1_1, 0x0036FF35, 0xC90C1708, 0x2CD440D7, 0x0A810586);
	r0 = D(r0, s1_1_2, 0xFF01FDFD, 0x1BFAE70F, 0xF40942E4, 0x260A182E);
	r1 = D(r1, s1_1_2, 0x0100DDFC, 0xFA01EC06, 0xE417D51E, 0xFAFFF40B);
	r2 = D(r2, s1_1_2, 0x22E0F5C9, 0xE20C18F6, 0x11EC14F8, 0xF8D2F181);
	r0 = D(r0, s1_2_0, 0x0208F4DE, 0xFEF8F909, 0x0CE50611, 0x1E15FAF6);
	r1 = D(r1, s1_2_0, 0xF90C0AF2, 0xFF01FEFF, 0x02FAF2E9, 0x050608E4);
	r2 = D(r2, s1_2_0, 0x020B0602, 0x030F11FB, 0xFF0DEC10, 0xFCFCF516);
	r0 = D(r0, s1_2_1, 0xFC0D04F9, 0x061406DC, 0x07E9EBD6, 0x2318FCF7);
	r1 = D(r1, s1_2_1, 0xEA2C0281, 0x08FD05D3, 0x08E40E81, 0xF1140D26);
	r2 = D(r2, s1_2_1, 0xF705FD1A, 0xEC1E0921, 0x04EDF1D2, 0xFBF205F4);
	r0 = D(r0, s1_2_2, 0x01FE03FB, 0x0AFCFE14, 0x0006FB1C, 0x0FFBF003);
	r1 = D(r1, s1_2_2, 0x05F613F9, 0xF6090403, 0x091F0810, 0x03F909D9);
	r2 = D(r2, s1_2_2, 0x03E602A9, 0xE9130232, 0xFEF7F0F5, 0x080000FA);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFF0204EC, 0xFFDAF904, 0xE7EEE711, 0x08F30007);
	r1 = D(r1, s0_0_0, 0xFB0801F5, 0xFF19F10C, 0xF4B5F7F3, 0x03F112F2);
	r2 = D(r2, s0_0_0, 0xFE080502, 0xFE05F7F3, 0xFCD3E20C, 0x1719E612);
	r0 = D(r0, s0_0_1, 0xFEFCF81B, 0xF0F5FF40, 0x08BCAC7F, 0x0C03EF25);
	r1 = D(r1, s0_0_1, 0xF802FD17, 0x08F1F508, 0x1F45F824, 0x081306EA);
	r2 = D(r2, s0_0_1, 0x07F706ED, 0xE5EB0CE4, 0xEACFEF62, 0xFFE12BFB);
	r0 = D(r0, s0_0_2, 0xFEFE0104, 0x0818FBE7, 0xE1EB036C, 0x14E9F7E2);
	r1 = D(r1, s0_0_2, 0xFBFBFCFC, 0xF9020201, 0x09270CF0, 0x0BFF02E8);
	r2 = D(r2, s0_0_2, 0x00F809DE, 0xE9F7FB09, 0x05E806E7, 0x0212F818);
	r0 = D(r0, s0_1_0, 0xED21F8FC, 0xE4EB2C16, 0x1E1A180B, 0x15082505);
	r1 = D(r1, s0_1_0, 0x0207E9F0, 0x0809E7F2, 0xEB30D7EF, 0x0C0AF7F8);
	r2 = D(r2, s0_1_0, 0x02F9F70D, 0xF5EC1010, 0xF9FDF011, 0x19180FED);
	r0 = D(r0, s0_1_1, 0x020EF450, 0xF9FCD64C, 0x3512CD0B, 0x1A4BED0A);
	r1 = D(r1, s0_1_1, 0xE1BCF881, 0xDA18CC81, 0xFD471981, 0x05E2F9C4);
	r2 = D(r2, s0_1_1, 0xF7F5D241, 0xE2E43AC2, 0xE726166B, 0x29EC819F);
	r0 = D(r0, s0_1_2, 0x01F80201, 0x131D0581, 0x19E208C8, 0x080402F1);
	r1 = D(r1, s0_1_2, 0x03F9F1FD, 0x0302FDEE, 0x0E02F7FE, 0x0004072B);
	r2 = D(r2, s0_1_2, 0xE9FE10BB, 0x02D509C0, 0xF40DFCDC, 0xD40E0305);
	r0 = D(r0, s0_2_0, 0x07FF00D3, 0xF50B1AED, 0x021C04E7, 0x13F819F1);
	r1 = D(r1, s0_2_0, 0x04F81D12, 0x00FDF80D, 0x08FADA17, 0x08F71B03);
	r2 = D(r2, s0_2_0, 0x02F6F10B, 0xF0FD210B, 0x06FB08EA, 0x0FFEB312);
	r0 = D(r0, s0_2_1, 0x0600FA0A, 0x0A03EC14, 0x09FC03DB, 0x0AF508D7);
	r1 = D(r1, s0_2_1, 0x0F063634, 0xFF06F30D, 0x0C070230, 0x03001E3E);
	r2 = D(r2, s0_2_1, 0x040E0C06, 0xF4FDFD1C, 0x00FC26B6, 0x11076704);
	r0 = D(r0, s0_2_2, 0x030103F6, 0x0AFFE8F3, 0x0C0D35DE, 0x0B02F0F3);
	r1 = D(r1, s0_2_2, 0xFD050400, 0xFBFBFF0C, 0x0CF4FB1F, 0xFA060801);
	r2 = D(r2, s0_2_2, 0xFCFEFDF3, 0xFA0B14ED, 0x0103FCDB, 0x0505FC0F);
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

//!DESC CuNNy-2x12-SOFT-conv2
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
	r0 = D(r0, s0_0_0, 0xFFFE0000, 0x0004FFFA, 0x06FB0100, 0xEF042C15);
	r1 = D(r1, s0_0_0, 0xFDFB000A, 0x02FFFE08, 0x01FAFB06, 0xEDFFF4FE);
	r2 = D(r2, s0_0_0, 0xFE00FF00, 0xF6FB0306, 0xFBFFFBFE, 0xFCF8EE03);
	r0 = D(r0, s0_0_1, 0x04FEF5FA, 0x12EAF1F7, 0xF9F0F60B, 0xED12F2FF);
	r1 = D(r1, s0_0_1, 0x07FF0105, 0xF40CF707, 0xFEFDFF08, 0x0F0CFBEC);
	r2 = D(r2, s0_0_1, 0xFDF6F706, 0x08E3E900, 0x03030CFA, 0x000401F1);
	r0 = D(r0, s0_0_2, 0xEF05FF10, 0x010200FD, 0xF0FBFEF6, 0xDD0308FF);
	r1 = D(r1, s0_0_2, 0x020001FA, 0x0603FEF4, 0x0400FF07, 0x070401F6);
	r2 = D(r2, s0_0_2, 0xFB020004, 0xE5020700, 0x01FF05E3, 0x0601FE06);
	r0 = D(r0, s0_1_0, 0xFA000B01, 0x0F0AF707, 0xE3040104, 0xF4C203F1);
	r1 = D(r1, s0_1_0, 0xEC0315FB, 0xF708F304, 0xF80AD4FC, 0x1FDF28FC);
	r2 = D(r2, s0_1_0, 0xF5040201, 0xF70810FB, 0x00FC03FA, 0xFA031201);
	r0 = D(r0, s0_1_1, 0x06FA03DF, 0xEBF0E81C, 0xCF0FD937, 0xE4CB0F0C);
	r1 = D(r1, s0_1_1, 0x10F4E560, 0xD7DAF546, 0xF4FF284A, 0xDFC4DF1B);
	r2 = D(r2, s0_1_1, 0x02041BE7, 0xC508B917, 0xF5F7190C, 0x03F1EB18);
	r0 = D(r0, s0_1_2, 0xD6040830, 0xF80B0581, 0xFD0FFDFF, 0xEF09F812);
	r1 = D(r1, s0_1_2, 0xF90406E2, 0xEFF3F809, 0x03FF0103, 0xFB0301FD);
	r2 = D(r2, s0_1_2, 0x10FEFDF5, 0x0A10FFE8, 0xFF01FA29, 0xFD04FFFB);
	r0 = D(r0, s0_2_0, 0x09020E06, 0xFCF9FA00, 0xEBE6F30E, 0xF3F50901);
	r1 = D(r1, s0_2_0, 0x09030203, 0xE4EFFD04, 0x08FAFEFF, 0xF307FA04);
	r2 = D(r2, s0_2_0, 0x0FE80CF8, 0x0AFA0804, 0x01FD03FF, 0x02FFFF02);
	r0 = D(r0, s0_2_1, 0xE4F7CCCB, 0x08D8FBFD, 0x0FED10FA, 0xF9E9030B);
	r1 = D(r1, s0_2_1, 0xF8F6FB02, 0x04EFF7FC, 0x01F6F703, 0x000000FD);
	r2 = D(r2, s0_2_1, 0xF9D7D907, 0xFAEEF902, 0xFEF6FE00, 0xFAFB03FB);
	r0 = D(r0, s0_2_2, 0x0FF7F925, 0xFEFF02D6, 0xFAF9F304, 0x00FDFEF2);
	r1 = D(r1, s0_2_2, 0x07020001, 0x0300F8F8, 0xFF000204, 0x0802FE00);
	r2 = D(r2, s0_2_2, 0xFEFC0805, 0x0606040B, 0x06FFFEF8, 0x020202FA);
	r0 = D(r0, s1_0_0, 0x04F90101, 0x08FFFAF9, 0xFDFF0511, 0x0EC508EF);
	r1 = D(r1, s1_0_0, 0xFDFF000D, 0xFF010406, 0xFCFFFF06, 0xFB03FD15);
	r2 = D(r2, s1_0_0, 0x02FFFFFF, 0x07F9FE06, 0x0301FD03, 0xFBFEFD12);
	r0 = D(r0, s1_0_1, 0xF8070301, 0xF701FF38, 0xFEFA001F, 0x1F06FEF5);
	r1 = D(r1, s1_0_1, 0x01F900F5, 0x05FB0300, 0x05FC002A, 0x0FFB064C);
	r2 = D(r2, s1_0_1, 0xFFFFFD08, 0xEDF1F934, 0xFEF00206, 0x0DFD0444);
	r0 = D(r0, s1_0_2, 0x1300FBF2, 0xF9020101, 0xF80200FD, 0x0502FD02);
	r1 = D(r1, s1_0_2, 0x0000FF01, 0xF7FBFF07, 0x0500FE00, 0xF8030008);
	r2 = D(r2, s1_0_2, 0x07FD0200, 0x120208EE, 0xFC010007, 0x0002FE06);
	r0 = D(r0, s1_1_0, 0x0FF4FDF7, 0xFB24F50B, 0xFBEC0808, 0xF3290412);
	r1 = D(r1, s1_1_0, 0x13DBFDFC, 0xEBFF0C16, 0x0AFFFA02, 0x01D903FE);
	r2 = D(r2, s1_1_0, 0x00F80109, 0x13EBFFFD, 0x03F7FF02, 0x0FEDF3FA);
	r0 = D(r0, s1_1_1, 0xC80B0822, 0xC6810304, 0x09C3E7FA, 0xC7E60035);
	r1 = D(r1, s1_1_1, 0xFBEDF8F6, 0x0CEDF2EE, 0x38E0FCD4, 0xCEDCEF1D);
	r2 = D(r2, s1_1_1, 0x11F4FFF1, 0x21C9DED9, 0x0EF7E9F2, 0xECF0CA14);
	r0 = D(r0, s1_1_2, 0x33E9FCE6, 0x1BE506EB, 0x14EB1200, 0xFCEC0C01);
	r1 = D(r1, s1_1_2, 0x09FA08FC, 0xF9F1060A, 0x00F4FF0B, 0x0CED12FA);
	r2 = D(r2, s1_1_2, 0xF6FCFE03, 0x1CEB15FE, 0x08EA1204, 0x09F109FF);
	r0 = D(r0, s1_2_0, 0x09EF09FB, 0x0518ECFA, 0xF20E060E, 0xFA07EB01);
	r1 = D(r1, s1_2_0, 0xFFEF0700, 0x00091001, 0x04FF07FB, 0x070705FA);
	r2 = D(r2, s1_2_0, 0xF8FE0405, 0xFFF60905, 0x02FE0400, 0xFAFB0807);
	r0 = D(r0, s1_2_1, 0xE0FF0E19, 0x18112DE0, 0x0EF53EF9, 0x120E0CEA);
	r1 = D(r1, s1_2_1, 0xF9EDFE0A, 0x1A0152EE, 0xF0F7FD13, 0x140129F0);
	r2 = D(r2, s1_2_1, 0xD4E8322C, 0xF3E41F0F, 0xFDF71507, 0x02F91100);
	r0 = D(r0, s1_2_2, 0x0CB9FDF7, 0xF90AE60B, 0xE3C8F225, 0x0F0704F4);
	r1 = D(r1, s1_2_2, 0x03FF04FD, 0x120605FC, 0x09010CFA, 0x07010AFE);
	r2 = D(r2, s1_2_2, 0x0DFC10FB, 0x08F010FF, 0x090012FE, 0x04FF01FD);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0100020A, 0xFE07E808, 0x04F7FF02, 0xD8DB041A);
	r1 = D(r1, s0_0_0, 0x00F4F802, 0x01F908F9, 0x01FBFE00, 0x01110306);
	r2 = D(r2, s0_0_0, 0xFEFB0002, 0x05FE020D, 0x02070105, 0x02020206);
	r0 = D(r0, s0_0_1, 0xF802FEFD, 0x01EAF5F4, 0xFEF7FD0B, 0x050A0FF4);
	r1 = D(r1, s0_0_1, 0xFFF2FE03, 0x010D0A03, 0x00F8FEFE, 0x0110F708);
	r2 = D(r2, s0_0_1, 0x01F2F609, 0xF9EDDE12, 0xFE06FB06, 0x01F7F701);
	r0 = D(r0, s0_0_2, 0xF9EFFE01, 0x0109F906, 0x020102FF, 0xFCE8FEF5);
	r1 = D(r1, s0_0_2, 0x000203FC, 0xFE01FEFF, 0xFEFBFDFF, 0xFAFBFE01);
	r2 = D(r2, s0_0_2, 0xFEF8FE04, 0x040902F3, 0xFFFEF6FA, 0xFCF8FD03);
	r0 = D(r0, s0_1_0, 0x00FF0EF9, 0xEEFAF508, 0xEFF1F1F5, 0x8118DEBB);
	r1 = D(r1, s0_1_0, 0xEE03E8EF, 0xE8E9F1EC, 0xF400FA07, 0xEEEBD3E9);
	r2 = D(r2, s0_1_0, 0x010604FA, 0xE9F7FBF5, 0xFCFDFEFE, 0xF7F7EFFD);
	r0 = D(r0, s0_1_1, 0xF0F4C9F6, 0xDF12D53F, 0xD6C11313, 0xDAE6F80C);
	r1 = D(r1, s0_1_1, 0xF4F6051C, 0xD195EEF4, 0xE5F7F826, 0xDDDD0824);
	r2 = D(r2, s0_1_1, 0x02190AFA, 0xE0D20C57, 0xEEE90646, 0xFAF1F914);
	r0 = D(r0, s0_1_2, 0xE1EAF205, 0x0BEFFAF0, 0x05FFFAFE, 0x07FD000D);
	r1 = D(r1, s0_1_2, 0x00FBFEFA, 0x05070009, 0xFEF700FF, 0xFEF0FBFB);
	r2 = D(r2, s0_1_2, 0xFDFEFC04, 0xFBE4F2F2, 0xFFE8F804, 0xFCF201FE);
	r0 = D(r0, s0_2_0, 0x05F502EA, 0xEF02FEF3, 0xE0040B09, 0x05041AFD);
	r1 = D(r1, s0_2_0, 0xF1F8EA04, 0xE90E0F0A, 0xFA01F6F9, 0xF4030FFF);
	r2 = D(r2, s0_2_0, 0xFB03F5E9, 0xE3FEF1FE, 0xFB02F7FF, 0xF400FEF9);
	r0 = D(r0, s0_2_1, 0xEDF610F9, 0xEB03E906, 0xE2F5E0D8, 0x06FFF9F8);
	r1 = D(r1, s0_2_1, 0xF9FF0E08, 0xDBF5F205, 0xF1FEFB04, 0xF8FEFF01);
	r2 = D(r2, s0_2_1, 0xEBF5F00D, 0xE401FF14, 0xF901F607, 0xEF0102FD);
	r0 = D(r0, s0_2_2, 0xB481F207, 0x060EFA02, 0xFE0EFF13, 0xFE04FEFD);
	r1 = D(r1, s0_2_2, 0xFFF8FEFE, 0x0008FE0C, 0x01FB01FB, 0x00FFFC00);
	r2 = D(r2, s0_2_2, 0xF6F501F1, 0x03FD00FD, 0x00FA02FD, 0x0002FD00);
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

//!DESC CuNNy-2x12-SOFT-out-shuffle
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
#define l0(x, y) V4((conv2_mul * texelFetch(conv2_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0), 0)))
#define l1(x, y) V4((conv2_mul * texelFetch(conv2_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0), 0)))
#define l2(x, y) V4((conv2_mul * texelFetch(conv2_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0), 0)))
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
	r0 += M4(4.249e-01, -3.457e-01, 7.591e-02, -1.341e-01, 1.134e-02, -4.834e-03, -6.176e-03, -2.530e-04, -8.778e-02, 1.381e-02, -2.979e-04, 5.270e-04, 5.636e-04, -3.071e-04, -6.583e-04, -3.970e-04) * s0_0_0;
	r0 += M4(-2.662e-03, 2.157e-02, -5.385e-04, 1.591e-02, 6.461e-02, 5.461e-02, -9.771e-03, -9.916e-03, 8.772e-02, -7.791e-02, 2.913e-04, 2.959e-02, 4.093e-03, 8.392e-03, 1.747e-03, 4.878e-04) * s0_0_1;
	r0 += M4(-3.848e-06, -4.384e-06, 4.099e-07, -6.047e-06, -3.164e-03, 2.138e-02, 1.293e-03, -4.130e-03, -1.016e-03, 1.246e-02, -2.369e-04, -4.543e-03, -3.947e-05, -2.621e-03, 2.396e-05, -8.012e-05) * s0_0_2;
	r0 += M4(1.246e-02, -4.553e-02, 2.425e-01, -1.907e-01, 3.525e-02, -5.991e-03, 2.490e-02, -1.336e-02, 1.292e-01, 8.481e-03, -6.671e-02, 2.906e-02, -4.638e-04, 1.900e-03, 1.423e-02, -6.533e-03) * s0_1_0;
	r0 += M4(-3.462e-03, -1.148e-02, 1.663e-03, 1.890e-03, 9.805e-02, 1.723e-01, 1.937e-01, 2.608e-01, 1.248e-01, 1.714e-01, 5.971e-03, -5.566e-01, -7.629e-02, -1.304e-01, -1.516e-02, -3.602e-03) * s0_1_1;
	r0 += M4(4.661e-06, -2.822e-05, -6.296e-07, 3.450e-06, -8.437e-03, 9.301e-03, -1.314e-02, 2.877e-02, 9.105e-03, 6.973e-02, -1.560e-04, 3.828e-02, -9.424e-03, 4.507e-02, 5.978e-03, -9.546e-03) * s0_1_2;
	r0 += M4(-6.098e-04, -4.599e-05, 1.205e-02, -1.023e-02, -2.526e-03, 3.622e-03, 8.231e-03, 2.374e-03, -1.785e-03, -2.773e-03, 2.912e-02, -7.355e-04, 5.620e-03, 9.968e-04, 3.455e-02, 3.115e-03) * s0_2_0;
	r0 += M4(-3.546e-05, -4.312e-04, -6.319e-05, -2.592e-03, -1.796e-02, -2.253e-02, -3.143e-02, -2.316e-02, 6.567e-03, 2.983e-04, 5.040e-02, 1.299e-02, -2.144e-02, 1.245e-02, -4.187e-01, 2.167e-02) * s0_2_1;
	r0 += M4(-5.920e-07, 2.248e-07, -1.374e-07, -5.938e-07, 9.086e-04, -3.072e-03, -1.539e-03, 4.156e-03, 1.299e-03, -7.871e-04, 4.377e-04, 3.998e-02, 1.323e-02, -7.030e-02, -1.234e-02, -7.450e-02) * s0_2_2;
	r0 += M4(2.481e-02, 1.660e-03, -2.832e-04, -2.047e-03, 2.554e-02, 5.075e-03, -5.785e-03, -6.690e-04, -3.446e-02, -6.909e-04, -1.838e-03, 1.554e-03, 6.578e-03, 7.055e-04, -3.060e-04, 3.240e-05) * s1_0_0;
	r0 += M4(-4.244e-02, 1.219e-01, -4.918e-03, 1.674e-03, 8.569e-02, 1.189e-01, -1.377e-03, 1.437e-03, -6.777e-02, -1.724e-01, -2.668e-02, 7.020e-03, 5.608e-02, 1.250e-02, -3.215e-03, 3.796e-03) * s1_0_1;
	r0 += M4(-1.082e-03, 5.718e-03, 2.147e-03, -1.112e-02, -9.906e-04, 2.704e-02, 2.456e-04, -7.119e-04, 9.025e-04, 3.168e-02, -1.690e-04, 7.354e-03, 6.277e-03, 2.999e-02, -3.101e-03, 9.560e-04) * s1_0_2;
	r0 += M4(6.648e-02, 4.312e-03, 5.718e-02, 2.617e-03, -1.753e-01, -1.251e-03, -3.009e-02, -5.551e-03, -9.351e-02, -4.959e-03, -7.695e-02, 7.611e-04, -9.992e-03, -3.980e-03, 9.832e-04, 4.663e-03) * s1_1_0;
	r0 += M4(-4.010e-01, -2.975e-02, -3.799e-01, 3.364e-01, 1.406e-02, -3.897e-01, 3.442e-01, 2.920e-01, 2.132e-01, 2.634e-02, 1.631e-01, -4.756e-01, -6.426e-01, -1.333e-02, 2.172e-01, 4.797e-02) * s1_1_1;
	r0 += M4(4.236e-04, 1.509e-01, 3.787e-03, 1.165e-01, -2.784e-03, 9.932e-02, -1.619e-03, 9.244e-02, 1.189e-03, 1.031e-01, 2.305e-03, 1.337e-01, 9.335e-03, -2.074e-01, -2.405e-02, 8.515e-02) * s1_1_2;
	r0 += M4(-3.805e-04, -1.806e-03, 7.601e-03, 3.036e-03, 2.002e-03, 2.594e-03, -5.504e-02, 1.433e-03, 5.855e-04, 1.177e-03, -1.248e-02, -4.754e-03, 1.528e-03, -1.541e-03, 6.347e-03, -2.104e-03) * s1_2_0;
	r0 += M4(1.309e-03, 6.058e-05, -1.001e-01, -7.154e-02, -3.519e-03, 4.345e-03, -8.674e-02, -1.305e-01, 1.125e-03, -1.404e-03, 6.427e-02, 9.282e-02, 9.884e-03, 3.839e-03, 4.545e-04, 7.587e-02) * s1_2_1;
	r0 += M4(1.088e-03, -2.846e-03, -5.854e-03, 1.935e-02, 1.838e-03, 1.435e-02, -4.744e-03, 7.629e-03, 7.239e-05, 8.069e-04, -9.010e-05, 4.534e-02, -1.518e-04, -9.850e-03, 6.338e-03, -4.554e-03) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 += M4(9.171e-02, 1.642e-02, -9.102e-03, 5.379e-04, 1.775e-02, 6.663e-04, 1.678e-02, 1.738e-03, 2.972e-02, -9.126e-03, 4.898e-03, -7.337e-04, 6.405e-04, -2.220e-03, 2.865e-03, -8.054e-04) * s0_0_0;
	r0 += M4(2.374e-01, 2.488e-01, 6.940e-03, 4.773e-03, -1.492e-01, -5.192e-02, -3.106e-03, -5.454e-03, 5.211e-02, 5.310e-02, 1.811e-02, -1.628e-02, -3.235e-02, 6.131e-02, 1.821e-02, -6.660e-03) * s0_0_1;
	r0 += M4(-7.334e-03, 4.469e-02, 1.575e-03, -4.722e-03, -4.113e-04, -4.259e-02, -5.982e-04, 2.925e-03, -4.922e-04, -1.287e-02, 1.674e-05, -3.481e-04, -8.257e-03, -5.065e-02, 1.732e-03, -3.609e-03) * s0_0_2;
	r0 += M4(-1.411e-02, -5.164e-03, -9.227e-02, 1.208e-02, -1.164e-02, -5.501e-03, 5.257e-03, -4.676e-03, 3.047e-01, 1.672e-02, 2.768e-01, -3.095e-03, 1.004e-02, 1.037e-03, 3.971e-02, -8.777e-03) * s0_1_0;
	r0 += M4(7.288e-03, -1.042e-02, -2.433e-01, -3.641e-01, 7.553e-02, 5.586e-01, -2.627e-01, 2.050e-01, -1.441e-01, -2.268e-01, -9.550e-02, 1.557e-01, 3.564e-01, -2.725e-01, -3.482e-01, 1.332e-01) * s0_1_1;
	r0 += M4(1.286e-03, 1.689e-02, 3.874e-04, 1.676e-02, 3.601e-03, -3.588e-02, 1.211e-02, -1.018e-01, 2.605e-04, -7.088e-02, -8.821e-04, -8.037e-02, -1.077e-02, 1.284e-01, 2.640e-02, -1.526e-01) * s0_1_2;
	r0 += M4(9.674e-04, -3.692e-04, -2.082e-04, -1.211e-03, 2.792e-03, 1.520e-03, 2.494e-03, -1.048e-03, -2.547e-03, -4.282e-03, 3.184e-02, 6.918e-03, -5.338e-03, 7.582e-04, 1.888e-02, -4.045e-03) * s0_2_0;
	r0 += M4(1.709e-04, 1.016e-03, 3.579e-04, 3.842e-03, -4.962e-03, -8.560e-03, -1.517e-02, 7.340e-02, -1.869e-04, -1.293e-02, -4.600e-02, -1.850e-01, -3.618e-03, 1.018e-02, 2.329e-01, 1.202e-01) * s0_2_1;
	r0 += M4(-1.519e-04, -2.562e-04, -2.240e-05, -9.021e-04, 4.172e-04, -1.682e-03, 2.635e-04, -3.317e-02, -6.340e-04, 6.472e-04, 1.322e-04, -3.302e-02, -1.102e-03, 8.252e-04, 1.285e-03, 3.800e-02) * s0_2_2;
	r0 += V4(-1.415e-09, 4.971e-09, -5.230e-12, 5.916e-11);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
