// CuNNy 3x12 SOFT (dp4a)
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


//!DESC CuNNy-3x12-SOFT-in
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
	r0 += V4(4.017e-03, 2.163e-02, -1.002e-02, -8.245e-02) * s0_0_0;
	r1 += V4(1.533e-02, -1.412e-02, -2.095e-02, -1.456e-02) * s0_0_0;
	r2 += V4(1.090e+00, 3.718e-01, 2.530e-02, -5.853e-02) * s0_0_0;
	r0 += V4(-3.021e-02, -7.030e-01, 1.833e-02, 8.436e-01) * s0_0_1;
	r1 += V4(-3.648e-03, -2.184e-02, -4.637e-01, -2.332e-02) * s0_0_1;
	r2 += V4(-1.048e+00, -3.455e-01, -5.261e-02, 4.802e-02) * s0_0_1;
	r0 += V4(2.722e-02, -1.899e-01, -5.562e-03, 2.338e-01) * s0_0_2;
	r1 += V4(-8.591e-02, 1.116e-02, -1.985e-01, -3.813e-03) * s0_0_2;
	r2 += V4(-4.699e-02, -2.802e-02, -1.862e-03, 1.403e-02) * s0_0_2;
	r0 += V4(-1.972e-02, 7.442e-02, 1.767e-02, -9.474e-02) * s0_1_0;
	r1 += V4(-2.740e-02, -9.590e-01, 7.886e-02, -6.213e-02) * s0_1_0;
	r2 += V4(8.192e-02, 3.845e-01, -2.209e-02, 4.713e-02) * s0_1_0;
	r0 += V4(-1.035e+00, 7.204e-01, 9.750e-01, -7.910e-01) * s0_1_1;
	r1 += V4(9.423e-01, -2.806e-02, 6.709e-01, 2.061e-01) * s0_1_1;
	r2 += V4(-8.376e-02, -3.271e-01, 5.770e-01, -8.823e-01) * s0_1_1;
	r0 += V4(1.048e+00, 7.322e-02, 2.703e-02, -1.008e-01) * s0_1_2;
	r1 += V4(-6.815e-01, 5.902e-05, 4.419e-02, -3.081e-02) * s0_1_2;
	r2 += V4(2.090e-03, -8.177e-02, -5.619e-01, 2.484e-01) * s0_1_2;
	r0 += V4(1.493e-02, -9.497e-02, -8.468e-03, 1.728e-01) * s0_2_0;
	r1 += V4(1.188e-02, 9.664e-01, -8.566e-02, 7.456e-02) * s0_2_0;
	r2 += V4(6.395e-03, -9.458e-02, -9.220e-04, 5.109e-02) * s0_2_0;
	r0 += V4(-2.741e-02, 4.229e-02, -9.902e-01, -9.435e-02) * s0_2_1;
	r1 += V4(-1.014e-01, 6.398e-02, -4.228e-02, -1.213e-01) * s0_2_1;
	r2 += V4(-1.364e-02, -4.071e-02, 1.941e-02, 4.013e-01) * s0_2_1;
	r0 += V4(1.677e-02, 5.994e-02, -2.648e-02, -8.944e-02) * s0_2_2;
	r1 += V4(-6.971e-02, -1.948e-02, -9.674e-03, -1.702e-02) * s0_2_2;
	r2 += V4(7.142e-03, 1.108e-01, -2.878e-02, -8.178e-03) * s0_2_2;
	r0 += V4(2.815e-03, 5.054e-03, 6.748e-05, -5.780e-03);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(5.381e-03, 1.745e-03, -3.588e-03, 2.850e-02);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(6.194e-07, -5.462e-03, -3.649e-03, 3.135e-04);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-3x12-SOFT-conv1
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
	r0 = D(r0, s0_0_0, 0xCBFBEDE5, 0x15CDB20E, 0x04D8F11B, 0x03F10002);
	r1 = D(r1, s0_0_0, 0x0724FD14, 0x0002FE05, 0x010BFF07, 0xFFE2F906);
	r2 = D(r2, s0_0_0, 0xFC2D0211, 0xE3811990, 0x05811620, 0xFF1F1AF7);
	r0 = D(r0, s0_0_1, 0xD6ED08AD, 0xFD42CFD0, 0x00DAEF02, 0xFE060000);
	r1 = D(r1, s0_0_1, 0x0781F426, 0xFCF20ADF, 0x05F2FE02, 0x04D7F4ED);
	r2 = D(r2, s0_0_1, 0x0A36E042, 0xFD332313, 0x0581ED17, 0x02E100F9);
	r0 = D(r0, s0_0_2, 0xFD1B0404, 0xF6DC08DD, 0x012A1104, 0x01FCFE00);
	r1 = D(r1, s0_0_2, 0x022B1BFE, 0x09F5F4F9, 0xFE080A05, 0xFEEFFBFE);
	r2 = D(r2, s0_0_2, 0x08E8F206, 0x0ECD9CEA, 0x02251D09, 0x02EDFC00);
	r0 = D(r0, s0_1_0, 0xD717ADEA, 0x0E0F1CB4, 0x36F4DD81, 0x0CE5EFFB);
	r1 = D(r1, s0_1_0, 0x1402EF01, 0xFC070600, 0xF807FF02, 0x0CF10322);
	r2 = D(r2, s0_1_0, 0xEC33D622, 0x3AF8D8F9, 0x4CF40193, 0xF2E51734);
	r0 = D(r0, s0_1_1, 0xD9FAC746, 0xCD3B1270, 0x13812B00, 0x03810A0B);
	r1 = D(r1, s0_1_1, 0x7681E681, 0xEC0221CA, 0x0F09F2F1, 0x0EFFF7BA);
	r2 = D(r2, s0_1_1, 0xD82B0F1A, 0x81061CEF, 0xEFEABC81, 0x182CCDF6);
	r0 = D(r0, s0_1_2, 0x4002BD08, 0x49C7AC1B, 0xE837E804, 0x041104FD);
	r1 = D(r1, s0_1_2, 0xBA8A4225, 0x2AE9C60D, 0xF6E61901, 0xFA02FF07);
	r2 = D(r2, s0_1_2, 0xB9BA38DC, 0x3408C506, 0xD6163801, 0x0DFE1304);
	r0 = D(r0, s0_2_0, 0xE4031605, 0xD80434C2, 0x10FA26FE, 0x04F5F403);
	r1 = D(r1, s0_2_0, 0x0BFBE50C, 0xF5FCFF02, 0x110B0AF4, 0x11011713);
	r2 = D(r2, s0_2_0, 0xD401EFEB, 0x13F61AFB, 0x09001C1F, 0xF7FC002C);
	r0 = D(r0, s0_2_1, 0x3B01A712, 0xDC0FC8B7, 0x2901C720, 0xB9FC79F2);
	r1 = D(r1, s0_2_1, 0x7FFFE9E7, 0xF30625FE, 0x5B018105, 0x1AFDFD1B);
	r2 = D(r2, s0_2_1, 0xF10414B9, 0xB2F4530C, 0xE10D4F2C, 0x0C06E8FA);
	r0 = D(r0, s0_2_2, 0xF7FF2900, 0xF4F14FEB, 0xE4072102, 0xFF08F805);
	r1 = D(r1, s0_2_2, 0x14F5B9DC, 0x1401F700, 0x15F709FA, 0x1207E5FB);
	r2 = D(r2, s0_2_2, 0x1EF5D8CF, 0x2E14D91A, 0x2B05E010, 0x01FE0FFF);
	r0 = D(r0, s1_0_0, 0xFB24F4F5, 0x2752FB21, 0x2B18FC15, 0x05FEFE09);
	r1 = D(r1, s1_0_0, 0x4103FEE7, 0x02FE0100, 0x0E020009, 0x3706FAED);
	r2 = D(r2, s1_0_0, 0xC50B0A26, 0xE6DF043A, 0x7FF0FBE7, 0xF3E20DF1);
	r0 = D(r0, s1_0_1, 0x53DD224B, 0x1A2F16FB, 0xE9120515, 0x0E020AF9);
	r1 = D(r1, s1_0_1, 0xA7FB1ADA, 0xD801FDF7, 0xE3FE05F3, 0xD20C0A05);
	r2 = D(r2, s1_0_1, 0x0015ECDC, 0x81E219E3, 0xA820FFF3, 0xE800E633);
	r0 = D(r0, s1_0_2, 0x0EF68105, 0x371617E0, 0xCDED81FD, 0x0F01FA00);
	r1 = D(r1, s1_0_2, 0x28F914F8, 0x3504030A, 0x03F804FA, 0x5A08F6FA);
	r2 = D(r2, s1_0_2, 0xFE201AFC, 0x657401F5, 0x94CFFD11, 0x09FFDD04);
	r0 = D(r0, s1_1_0, 0xDAD50432, 0x01F6FC10, 0x1711F918, 0x020EFE13);
	r1 = D(r1, s1_1_0, 0xB9F00315, 0xF7FD0102, 0xF8F7FD15, 0xDEEFFDFD);
	r2 = D(r2, s1_1_0, 0x05090EEA, 0xE4FFF908, 0xCE1B0011, 0xC7D614B5);
	r0 = D(r0, s1_1_1, 0x81BCF3E0, 0xDA2DC8B4, 0x33EDF0B5, 0xB3FD15E9);
	r1 = D(r1, s1_1_1, 0x2224EA33, 0x290DFD52, 0x7D09E108, 0x470CF350);
	r2 = D(r2, s1_1_1, 0xAFCEFD81, 0x06F9B813, 0x2F19D33D, 0x62420AD0);
	r0 = D(r0, s1_1_2, 0xFBF62803, 0x81F4000F, 0xCB1AFD17, 0xF7FFF9FD);
	r1 = D(r1, s1_1_2, 0x5ACD81E8, 0xBF0AF10A, 0xDBEC8102, 0xEF0119F4);
	r2 = D(r2, s1_1_2, 0x4D111400, 0xEB0EC2D3, 0x14D481FF, 0xE8FEEC00);
	r0 = D(r0, s1_2_0, 0x3CC70614, 0x10E700B3, 0x1300FED4, 0xFE08FC05);
	r1 = D(r1, s1_2_0, 0xF8690112, 0x040C0002, 0xF20BFF00, 0xDC100209);
	r2 = D(r2, s1_2_0, 0x16F7050B, 0x1621FEE6, 0x0CC201EA, 0x251802E1);
	r0 = D(r0, s1_2_1, 0x0C3505DC, 0xEC0AF31C, 0x0A5705F1, 0x39100309);
	r1 = D(r1, s1_2_1, 0xDC1FE3E8, 0xF5F102FA, 0xE10EF5F7, 0xE90406E7);
	r2 = D(r2, s1_2_1, 0xFFE0F106, 0x2A1210F5, 0x02DF00F1, 0xD3F3FB12);
	r0 = D(r0, s1_2_2, 0xD9EB0EFF, 0x2B12E20C, 0x04D40305, 0xF0040102);
	r1 = D(r1, s1_2_2, 0xEF4039FC, 0x0D0100F2, 0xFFF40AFE, 0xE1130800);
	r2 = D(r2, s1_2_2, 0x0438DBFE, 0xF61902F2, 0x16E00FFD, 0xF0F9090C);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x31FA18F9, 0xE62610FB, 0xD207FB00, 0xFC040000);
	r1 = D(r1, s0_0_0, 0xE4F40305, 0x0312FA02, 0xFCF403FF, 0x10C40102);
	r2 = D(r2, s0_0_0, 0x0AB0FD08, 0x113F12FC, 0x1171E90B, 0x10130002);
	r0 = D(r0, s0_0_1, 0x352734ED, 0xF4125AE0, 0xCD40D00F, 0xF6080201);
	r1 = D(r1, s0_0_1, 0x0812EB02, 0xFBC7F700, 0x071409FE, 0xF5E70FFB);
	r2 = D(r2, s0_0_1, 0x0CD00601, 0xF61FEA17, 0x36DF150A, 0xF0D8F4FC);
	r0 = D(r0, s0_0_2, 0xE0150FFE, 0x49443EE4, 0xEE0BFF04, 0x00FF0901);
	r1 = D(r1, s0_0_2, 0x08F4E607, 0x02FE0503, 0xFFFFFF02, 0x0A0508FF);
	r2 = D(r2, s0_0_2, 0x0DDEEE06, 0x0B202804, 0xF7F90008, 0xFCF707FD);
	r0 = D(r0, s0_1_0, 0x12E419EF, 0x32F6ED0C, 0xED7A3FF4, 0xF8F70200);
	r1 = D(r1, s0_1_0, 0x0047EB01, 0xFA090600, 0x02F9F601, 0x09000300);
	r2 = D(r2, s0_1_0, 0xF2350003, 0x38FC43DF, 0x7F812DFA, 0xDFB8F004);
	r0 = D(r0, s0_1_1, 0xF6D4E7E2, 0xBBE63A9C, 0x5E3200F6, 0x0A080AF9);
	r1 = D(r1, s0_1_1, 0x810AF908, 0xF8D1F5F9, 0x222418F0, 0xC4CB2321);
	r2 = D(r2, s0_1_1, 0xB67F07F7, 0xA71BA3FE, 0x8156D2CF, 0x1D16A606);
	r0 = D(r0, s0_1_2, 0xEEEAF70F, 0x08BFD8A3, 0xF5E903E5, 0xFE07EDFF);
	r1 = D(r1, s0_1_2, 0x8135D029, 0x04EB4929, 0xF40AE808, 0xFC0F1CE8);
	r2 = D(r2, s0_1_2, 0x380FFB03, 0xF835DE09, 0xE91BF506, 0xF80105EF);
	r0 = D(r0, s0_2_0, 0xE31516F2, 0x277FFC01, 0xFC2901F3, 0xFCF00200);
	r1 = D(r1, s0_2_0, 0x19D0EF17, 0x0104FB04, 0x07060304, 0xFDECF909);
	r2 = D(r2, s0_2_0, 0x162EF40A, 0xF31CD904, 0x1313D0FF, 0x00E6F50E);
	r0 = D(r0, s0_2_1, 0xD915E31B, 0x2D45B510, 0x12E249AA, 0xFF010EF2);
	r1 = D(r1, s0_2_1, 0xB6CFF30E, 0xF8F8EB08, 0xEFE0F3F4, 0xEBEDF5EB);
	r2 = D(r2, s0_2_1, 0x133CF807, 0x00E818E0, 0xE3A21081, 0xF3EAD781);
	r0 = D(r0, s0_2_2, 0x0E0606F5, 0x2105E41D, 0x0E015B81, 0xF7FCFE05);
	r1 = D(r1, s0_2_2, 0xF1054A89, 0xFE0E2204, 0x0A09F8FF, 0x0D022FEE);
	r2 = D(r2, s0_2_2, 0x19FBD681, 0xE2FCED15, 0xE4F93202, 0x00F40913);
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

//!DESC CuNNy-3x12-SOFT-conv2
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
	r0 = D(r0, s0_0_0, 0xF9FE00FD, 0xF5020701, 0x0AFAFAFE, 0xFD020DFC);
	r1 = D(r1, s0_0_0, 0xEDF60806, 0xFDF707FE, 0x0A0CF315, 0xFE04F8F6);
	r2 = D(r2, s0_0_0, 0xF7FA0504, 0x0504FEFB, 0x01FA0701, 0x03FB07FC);
	r0 = D(r0, s0_0_1, 0x03060A01, 0xDFD70502, 0x03FE00FC, 0xC6181BFB);
	r1 = D(r1, s0_0_1, 0xC0FE1CEB, 0xE7060209, 0x09E613F3, 0xE0ED1EFF);
	r2 = D(r2, s0_0_1, 0x43DBE3FA, 0xEEFDF806, 0xDC0E0FFD, 0xDE11FC01);
	r0 = D(r0, s0_0_2, 0xFE020204, 0x0900F4F6, 0xFA0006F4, 0xEB070DF2);
	r1 = D(r1, s0_0_2, 0x13F803FF, 0x0502F60C, 0xF4EE0D01, 0x0DFA0AF6);
	r2 = D(r2, s0_0_2, 0xB10E2BB5, 0x0600FEEE, 0xFB00FBF8, 0x23030414);
	r0 = D(r0, s0_1_0, 0xFC000406, 0xFCFAFB11, 0xF2D304D9, 0xFB0511F4);
	r1 = D(r1, s0_1_0, 0xF6000A09, 0xED09F10A, 0x0BF6C504, 0x03070CEF);
	r2 = D(r2, s0_1_0, 0x06FC140D, 0x020403FB, 0xFA110405, 0x01F5F9EA);
	r0 = D(r0, s0_1_1, 0x69E107FB, 0xFDF9EF3C, 0x11F110F3, 0x0B291C10);
	r1 = D(r1, s0_1_1, 0xECEDD942, 0x2506E90B, 0xEDAFDC0A, 0x030706E9);
	r2 = D(r2, s0_1_1, 0xF2ED0427, 0xF6EEF8FF, 0x5810DD09, 0xFF220116);
	r0 = D(r0, s0_1_2, 0xFDFCF90B, 0x0B060406, 0xFE0A02FB, 0xF02208F2);
	r1 = D(r1, s0_1_2, 0x08FC0B18, 0xE50FBF27, 0x04FB0816, 0x03FFFFEE);
	r2 = D(r2, s0_1_2, 0x0213EE5C, 0xD4C3000B, 0xF70DF228, 0xEBF3FE05);
	r0 = D(r0, s0_2_0, 0x03FAF90E, 0x000201F9, 0x01FCFDE9, 0xFD060DF1);
	r1 = D(r1, s0_2_0, 0xFC01050B, 0xFD00EB1B, 0x0804F618, 0xFF02FEF1);
	r2 = D(r2, s0_2_0, 0x03010108, 0x0109FA0E, 0x0B030711, 0xF90400F5);
	r0 = D(r0, s0_2_1, 0xDEE2CFF4, 0x03010205, 0x03F3FBF0, 0xFE10F8D5);
	r1 = D(r1, s0_2_1, 0x03010F0D, 0xF0FECCFC, 0xFE191DEF, 0xFC01F205);
	r2 = D(r2, s0_2_1, 0x01001306, 0x040413F5, 0xF3FEEBFC, 0x060AEE1C);
	r0 = D(r0, s0_2_2, 0xFD020C0F, 0x00030800, 0xFF0003F7, 0xF90808F6);
	r1 = D(r1, s0_2_2, 0x01030F04, 0xFEFDDB0F, 0xFA182D14, 0xFF0405F5);
	r2 = D(r2, s0_2_2, 0xFFFD08F4, 0xFAEBD7FE, 0xFCFE0814, 0xFCFBE12B);
	r0 = D(r0, s1_0_0, 0x0107F8FA, 0x0B06EBED, 0xFD0109F4, 0x0BFC0906);
	r1 = D(r1, s1_0_0, 0x04FBF905, 0x0A00F401, 0x0CFAFA00, 0xFA0208FA);
	r2 = D(r2, s1_0_0, 0x010AF3FB, 0x02F407FE, 0x08F20409, 0x00010302);
	r0 = D(r0, s1_0_1, 0x00F501FE, 0x1F2605FA, 0x04FFF9FB, 0x1D0EFC0D);
	r1 = D(r1, s1_0_1, 0x11BC0524, 0x0E180DF6, 0x0FFAFFF0, 0x0E39FBF3);
	r2 = D(r2, s1_0_1, 0x2BF9AA04, 0xFA13EEFD, 0x0801FE06, 0x0105F6EF);
	r0 = D(r0, s1_0_2, 0x0002FF02, 0x02F3F9FA, 0x04FD0003, 0x0EF60214);
	r1 = D(r1, s1_0_2, 0xFF04FCF6, 0x020205FB, 0x0914FEF9, 0x0204FE01);
	r2 = D(r2, s1_0_2, 0x08D20010, 0x08E30402, 0x09FCFFFF, 0xFBE70A07);
	r0 = D(r0, s1_1_0, 0x020BF701, 0xFB0116F7, 0x0CFE3AF4, 0x1BF60E07);
	r1 = D(r1, s1_1_0, 0x0DF1D70B, 0x04130EF5, 0x0FFDFFFD, 0x05F3FC05);
	r2 = D(r2, s1_1_0, 0xF4090004, 0xF7F7F5F5, 0x0A10EF06, 0x0AFC0603);
	r0 = D(r0, s1_1_1, 0x0181000B, 0xE80F23F9, 0x0701F9F3, 0x31CCD52B);
	r1 = D(r1, s1_1_1, 0x060F1E0F, 0x0ED0DD12, 0xAC271816, 0x05FFF7FB);
	r2 = D(r2, s1_1_1, 0xDD0F8115, 0xE5F48100, 0x0BE1EDF7, 0x03F7E701);
	r0 = D(r0, s1_1_2, 0xF8FB03F4, 0xF7FEFD04, 0xFFFE0101, 0x0DF2081A);
	r1 = D(r1, s1_1_2, 0x09F506FF, 0x0CF902F8, 0xD7FDFEF8, 0xF8050401);
	r2 = D(r2, s1_1_2, 0x17F7F81E, 0x31F80615, 0x04F809F7, 0x020208F2);
	r0 = D(r0, s1_2_0, 0x02FCCB0B, 0x02FF0001, 0x05000909, 0x0EFAF611);
	r1 = D(r1, s1_2_0, 0x00020002, 0x05F90800, 0xEFF7F0FF, 0xFF00FB00);
	r2 = D(r2, s1_2_0, 0xFC0209FD, 0xFA020000, 0x0301F601, 0xFC04FB01);
	r0 = D(r0, s1_2_1, 0xFA04010E, 0x040101FF, 0xFB070A03, 0xFA08F31B);
	r1 = D(r1, s1_2_1, 0x0C02FDFE, 0xF300FCF6, 0xB49ADEFF, 0xFF0103FF);
	r2 = D(r2, s1_2_1, 0x05FEFBF9, 0xFB01EDEE, 0xF306F9F2, 0x03010101);
	r0 = D(r0, s1_2_2, 0x0AF8FF07, 0xFB0300FA, 0xFD04FF06, 0x0702FE16);
	r1 = D(r1, s1_2_2, 0x01FF0002, 0x10FAFDFC, 0xF6F60717, 0xFF0001FD);
	r2 = D(r2, s1_2_2, 0x0500010E, 0x1CFAF8FB, 0x0BFFFB00, 0x000013F6);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0201FE04, 0x0009E706, 0x060505F0, 0xF7070600);
	r1 = D(r1, s0_0_0, 0xFBFBFF01, 0x0208F10D, 0xFC0B0800, 0x06FAFAEA);
	r2 = D(r2, s0_0_0, 0x07FF0FFC, 0x00010701, 0xF900F401, 0xFD010004);
	r0 = D(r0, s0_0_1, 0x0301F501, 0xF5041400, 0x0CFB00F9, 0xE414FC01);
	r1 = D(r1, s0_0_1, 0xF81B16FA, 0xF905F91A, 0xF60B030E, 0x11F508FD);
	r2 = D(r2, s0_0_1, 0x0223FC14, 0x03F50203, 0xF407FF02, 0xF1FDFFF8);
	r0 = D(r0, s0_0_2, 0xFE02FD05, 0xF217F817, 0x000203FD, 0xF40803FB);
	r1 = D(r1, s0_0_2, 0xF4100615, 0xF0FFE70E, 0xE1160305, 0xFC06F8F6);
	r2 = D(r2, s0_0_2, 0xF6090DF5, 0x0701F70B, 0xFA02F902, 0x11F90D04);
	r0 = D(r0, s0_1_0, 0xFE000208, 0x050CF9FF, 0xFA120201, 0xF618FD03);
	r1 = D(r1, s0_1_0, 0xFE0EF405, 0x020BDA19, 0xF90CE51E, 0xFEF308FD);
	r2 = D(r2, s0_1_0, 0x07FC080C, 0x05FA0DFD, 0xF8F6FBDF, 0xFD09E308);
	r0 = D(r0, s0_1_1, 0x01020D05, 0x01D332FE, 0xBDF1EDFE, 0xBBFC020A);
	r1 = D(r1, s0_1_1, 0xDA0F1EF1, 0xF3E30028, 0x07DCE504, 0xEB09FEF3);
	r2 = D(r2, s0_1_1, 0x0D23F31B, 0x0CC7F807, 0xC0FCEFF8, 0xEFD32AE2);
	r0 = D(r0, s0_1_2, 0xFF0A010C, 0x02ECE806, 0x07FD09FB, 0xFAF41BF5);
	r1 = D(r1, s0_1_2, 0x0E0AF306, 0xFE08D907, 0xFFE0FB05, 0x150003F3);
	r2 = D(r2, s0_1_2, 0x0E0930C4, 0x1DE40304, 0xF7FFF902, 0x31FF210F);
	r0 = D(r0, s0_2_0, 0xFE0B0503, 0xFE060207, 0xFD06EBED, 0xFD11FBFE);
	r1 = D(r1, s0_2_0, 0xFAFBF605, 0xF6F7D40A, 0x05E20118, 0x0001F7FA);
	r2 = D(r2, s0_2_0, 0x03FEFA08, 0x03F900FA, 0xFFFF0602, 0xFD04E7FA);
	r0 = D(r0, s0_2_1, 0x020ADC03, 0xFFF90903, 0x0DF920EA, 0x020914F9);
	r1 = D(r1, s0_2_1, 0x0812140A, 0xE90AE617, 0x18810220, 0x09F504FB);
	r2 = D(r2, s0_2_1, 0xFB0B0A0C, 0x09E50A0B, 0x04FAEA1E, 0xF9F9120B);
	r0 = D(r0, s0_2_2, 0xF412FAFE, 0xFDFFF901, 0x07FE02FD, 0xF80106F3);
	r1 = D(r1, s0_2_2, 0xFBFE1408, 0xE207F40A, 0xFEC5E6FE, 0xFDF804FF);
	r2 = D(r2, s0_2_2, 0xF3FDE1FE, 0x18F71CF6, 0xFE01F7FD, 0x08F30900);
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

//!DESC CuNNy-3x12-SOFT-conv3
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
	r0 = D(r0, s0_0_0, 0x0000FF01, 0xFEFE0103, 0xFF01FFFB, 0x0001FF03);
	r1 = D(r1, s0_0_0, 0x0CFE01EE, 0x00000100, 0xFD00FD09, 0xFD0001FC);
	r2 = D(r2, s0_0_0, 0x81818181, 0xF2FFF903, 0x8119E6E2, 0xFB020401);
	r0 = D(r0, s0_0_1, 0x03000002, 0xF7FCFFEC, 0xF9040DF4, 0x000101FE);
	r1 = D(r1, s0_0_1, 0x04D7F8F4, 0xFEFEFD00, 0xF90F06DB, 0xFFF800FB);
	r2 = D(r2, s0_0_1, 0x8181F381, 0xFB0103ED, 0xF9380CFC, 0x06FD01F1);
	r0 = D(r0, s0_0_2, 0xFEFDFE03, 0xFFF8FE0A, 0x00F7FFFA, 0x01FB0004);
	r1 = D(r1, s0_0_2, 0xF3120605, 0x03FB0302, 0x01030106, 0xFFFE0107);
	r2 = D(r2, s0_0_2, 0xED05F906, 0xFDFD04FE, 0xF4E5040A, 0xF4E2FDF6);
	r0 = D(r0, s0_1_0, 0x02FE0404, 0xF706FF04, 0x01FE0103, 0xFC000307);
	r1 = D(r1, s0_1_0, 0x05F21108, 0x000000FD, 0xF1FAF813, 0xF805FFF7);
	r2 = D(r2, s0_1_0, 0x0514BAEC, 0x08FA00FF, 0xDCFCB32D, 0x06FF0804);
	r0 = D(r0, s0_1_1, 0xDF1F142C, 0x100E174E, 0xFEFE2E00, 0xF70E142C);
	r1 = D(r1, s0_1_1, 0x813F1343, 0x04F7FD0E, 0xBC3D2E48, 0xEFF8E9CE);
	r2 = D(r2, s0_1_1, 0xBD182AFC, 0xEF21421B, 0xD4D50D04, 0xD9F9021B);
	r0 = D(r0, s0_1_2, 0x07FAF9FE, 0xF511FB09, 0x0209FB04, 0xFE2BFEF7);
	r1 = D(r1, s0_1_2, 0x080A1113, 0xF50700E1, 0x02180108, 0xFF0CFD14);
	r2 = D(r2, s0_1_2, 0x0306FD03, 0xEB0D10FD, 0xEF0513FA, 0xF53BFE2C);
	r0 = D(r0, s0_2_0, 0xFCFEF2FF, 0xFDFFF700, 0xFF00FF01, 0xFFFEF802);
	r1 = D(r1, s0_2_0, 0xF80000FF, 0x000006FF, 0xFB06E60A, 0xFC020600);
	r2 = D(r2, s0_2_0, 0xF5FF1AFF, 0xFC02F906, 0xDE12ED0E, 0xFFFEFE00);
	r0 = D(r0, s0_2_1, 0x06F334F9, 0xFAF3FC06, 0x02FF0900, 0x04F42BFD);
	r1 = D(r1, s0_2_1, 0x05F40107, 0xF5060500, 0xF9EA23F7, 0xBE093509);
	r2 = D(r2, s0_2_1, 0xFAFFFB08, 0xEFF32606, 0xE5190514, 0xFA01FF01);
	r0 = D(r0, s0_2_2, 0x0116E702, 0xFF040903, 0x0001FCFF, 0x0215E201);
	r1 = D(r1, s0_2_2, 0xECF40E03, 0xCE09380A, 0xFF05F5FE, 0xF5120E05);
	r2 = D(r2, s0_2_2, 0xFDFF0601, 0x0BF904FF, 0x00080D12, 0xF8E6F5F9);
	r0 = D(r0, s1_0_0, 0xFDFC0200, 0x0203FEFF, 0x01000303, 0xFFFF02FF);
	r1 = D(r1, s1_0_0, 0x0504F2FB, 0x00000000, 0x0606FDFF, 0xFEFFFEFF);
	r2 = D(r2, s1_0_0, 0x81818181, 0x08F50C05, 0x1628068B, 0x0102FEFD);
	r0 = D(r0, s1_0_1, 0xFEFA0101, 0x04FEFFFE, 0x0112DFFB, 0xFFFC0101);
	r1 = D(r1, s1_0_1, 0xFFF9F6FC, 0xFEFD0301, 0xFE09F6FE, 0x01FE0400);
	r2 = D(r2, s1_0_1, 0x00F48105, 0x01DEE100, 0xF6FDE7B3, 0x06F9F4FB);
	r0 = D(r0, s1_0_2, 0xFF000901, 0xFE040203, 0xFC0807F8, 0xFCFF0403);
	r1 = D(r1, s1_0_2, 0xFBFCFCF8, 0x0004FEFE, 0xFEFE01F9, 0x01FF0103);
	r2 = D(r2, s1_0_2, 0xF0F91B18, 0x00010104, 0x0108F6D8, 0xF90C08F7);
	r0 = D(r0, s1_1_0, 0x0403FF02, 0xFD02FD0A, 0x01020102, 0xFE000101);
	r1 = D(r1, s1_1_0, 0xEAFBEF09, 0x010000FF, 0xF7EDFB0E, 0x08FFFB00);
	r2 = D(r2, s1_1_0, 0xD51D81FA, 0x050AE20F, 0x1E22BEBA, 0xFE05F7FD);
	r0 = D(r0, s1_1_1, 0x0D38D8F4, 0xF602F8CB, 0x30F416DC, 0x0A23D800);
	r1 = D(r1, s1_1_1, 0x08F60CC0, 0xFFF80404, 0xF115D9C3, 0x08F51301);
	r2 = D(r2, s1_1_1, 0xFB15FCBA, 0xED1AEBC9, 0xF50440ED, 0x07050F06);
	r0 = D(r0, s1_1_2, 0xFA0807F1, 0x02F405F3, 0x14F7FEFA, 0xF80F0EF1);
	r1 = D(r1, s1_1_2, 0xE4FEF9FE, 0x06DBDA06, 0xFAF7FAFA, 0x03F4E407);
	r2 = D(r2, s1_1_2, 0xFDFE11F8, 0xF7FA11EC, 0xFAFBFAF6, 0xF1E9F09C);
	r0 = D(r0, s1_2_0, 0x00F50604, 0xFCFA0400, 0x03FFFEFF, 0x01F802FF);
	r1 = D(r1, s1_2_0, 0xFC01FEF8, 0x0205FC00, 0x0806F505, 0x0E06EBF8);
	r2 = D(r2, s1_2_0, 0xFAF70705, 0x01FF030A, 0x28F03984, 0xFC03FF05);
	r0 = D(r0, s1_2_1, 0xDFDE0FDA, 0xFCFE07DD, 0xED000101, 0xEAF10A00);
	r1 = D(r1, s1_2_1, 0xEC07FFEA, 0x240EDE04, 0xDF0AFCEF, 0x1C27DDBD);
	r2 = D(r2, s1_2_1, 0x0FF4050D, 0xEAF20CE8, 0x3DF7F4BE, 0x0104F9FC);
	r0 = D(r0, s1_2_2, 0x2700FCF6, 0x0004FDF5, 0x0004FFFE, 0x1AF4FFF8);
	r1 = D(r1, s1_2_2, 0xFF0406FF, 0xD21B0AC0, 0xFDFCFC00, 0xE303FFF9);
	r2 = D(r2, s1_2_2, 0x0CFAFCFF, 0xFC03FCFF, 0x0AE9EDFB, 0xF00BF5CF);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xF9FE0600, 0x0303FDFF, 0xEF050502, 0xFEFFFDFF);
	r1 = D(r1, s0_0_0, 0x05F7F00B, 0x00010000, 0x03FAF901, 0x0104FC02);
	r2 = D(r2, s0_0_0, 0x81818181, 0x08F902FC, 0xFE2BFBF5, 0x00FE0001);
	r0 = D(r0, s0_0_1, 0xFBF503FF, 0x0510FE01, 0x12213D04, 0xFFFD00FD);
	r1 = D(r1, s0_0_1, 0x031E0F0D, 0xFB00FE00, 0x03250F07, 0xFD040B01);
	r2 = D(r2, s0_0_1, 0xDD81A2EB, 0x01FAF702, 0x0513FC03, 0xFB07FC08);
	r0 = D(r0, s0_0_2, 0xFEF6FF00, 0xFE020000, 0xFFFBFA02, 0xFDF10100);
	r1 = D(r1, s0_0_2, 0x030B0201, 0x000200FF, 0xFE040203, 0xFE0500FE);
	r2 = D(r2, s0_0_2, 0xF9F80502, 0xFF0701FF, 0xFEF0F2FC, 0x02230500);
	r0 = D(r0, s0_1_0, 0xDE0612FC, 0x0C08F9F7, 0xF4FD09FA, 0xF9050FFD);
	r1 = D(r1, s0_1_0, 0x34FEDFDB, 0x03FB01FE, 0xE50007E3, 0x06F60902);
	r2 = D(r2, s0_1_0, 0x1CFB12FB, 0xD2FFF6F1, 0xADB440C0, 0xFDFE04FB);
	r0 = D(r0, s0_1_1, 0x354F47F1, 0x08095804, 0x04F903CE, 0x2721F3F4);
	r1 = D(r1, s0_1_1, 0xE8CC3509, 0xF7EF20FB, 0x10AE08EA, 0xFD070D05);
	r2 = D(r2, s0_1_1, 0xEC0D09FD, 0x0DEF141A, 0xFDED0AE8, 0x3EFEE5E9);
	r0 = D(r0, s0_1_2, 0x00FDF204, 0xFDF80400, 0xFEFB0004, 0x000BF901);
	r1 = D(r1, s0_1_2, 0xFFF20203, 0x0617F904, 0x02FEFF04, 0xFE020EFE);
	r2 = D(r2, s0_1_2, 0x01F7FE03, 0x0200030B, 0x081003F2, 0x04C0FAFD);
	r0 = D(r0, s0_2_0, 0xF7FDFFF2, 0x0200FFF2, 0xFEFFFF00, 0xFDFCFDEE);
	r1 = D(r1, s0_2_0, 0x0806F70D, 0x0101FC04, 0x03F605EB, 0x14FFE8FA);
	r2 = D(r2, s0_2_0, 0xEDFDF9D9, 0x0CFBFAF4, 0xF7F01AF4, 0x03FF00FE);
	r0 = D(r0, s0_2_1, 0xFBFF0BC2, 0xF9F90A06, 0xFF020001, 0xF3FB03BD);
	r1 = D(r1, s0_2_1, 0x02F80513, 0x1CFFD4FA, 0xFD0AFDFB, 0xEBFE2E24);
	r2 = D(r2, s0_2_1, 0x03FCFEFF, 0x00FE00EF, 0xEFEA24D1, 0x01060201);
	r0 = D(r0, s0_2_2, 0xFDFB0304, 0x02FF02FB, 0x00000101, 0x00FC02FC);
	r1 = D(r1, s0_2_2, 0x00FF04FA, 0x04F3090E, 0x00000302, 0x01F701F9);
	r2 = D(r2, s0_2_2, 0xFF010401, 0x0201FFFA, 0xFCF3FEF1, 0xFF0AFC02);
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

//!DESC CuNNy-3x12-SOFT-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv3
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
#define l0(x, y) V4((conv3_mul * texelFetch(conv3_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0), 0)))
#define l1(x, y) V4((conv3_mul * texelFetch(conv3_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0), 0)))
#define l2(x, y) V4((conv3_mul * texelFetch(conv3_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0), 0)))
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
	r0 += M4(5.536e-02, -4.016e-03, 2.585e-03, -5.604e-04, 5.359e-02, -1.904e-03, -4.353e-03, -8.628e-04, -1.334e-05, 1.528e-03, 9.130e-04, 3.965e-04, -1.274e-01, -9.920e-03, -1.558e-03, 1.109e-03) * s0_0_0;
	r0 += M4(1.429e-01, 2.105e-02, -2.658e-03, 1.064e-03, 1.624e-01, 1.890e-01, 5.589e-04, -8.300e-03, -1.184e-03, -6.996e-03, -5.439e-04, -2.965e-04, 3.534e-03, 1.316e-01, 4.101e-03, 1.396e-02) * s0_0_1;
	r0 += M4(-2.898e-04, 7.801e-03, -5.162e-04, -4.971e-03, -6.050e-03, 1.224e-03, 1.609e-03, -1.689e-03, 2.287e-04, 2.282e-03, -2.525e-05, 1.315e-04, 1.248e-04, 1.197e-03, 1.381e-04, 1.832e-03) * s0_0_2;
	r0 += M4(1.166e-01, 2.748e-03, 6.888e-02, 1.613e-03, 1.431e-01, -1.061e-02, 1.703e-01, -8.430e-03, -3.956e-02, 1.436e-02, -7.332e-04, 3.803e-03, -2.992e-01, 8.243e-03, -4.720e-01, -1.308e-02) * s0_1_0;
	r0 += M4(-1.267e-02, -2.034e-01, -1.401e-01, -8.315e-01, 1.610e-03, 1.890e-02, -1.588e-02, 4.589e-01, -3.740e-01, -4.455e-01, 1.833e-03, -1.304e-02, -4.794e-03, 2.627e-01, 5.121e-03, 3.089e-01) * s0_1_1;
	r0 += M4(8.917e-04, -9.259e-03, -3.589e-03, -2.651e-02, -3.803e-03, 1.419e-02, -9.648e-03, -2.613e-02, 7.094e-03, -1.163e-02, -1.082e-03, 7.805e-03, -1.929e-04, -4.041e-03, 1.102e-04, -2.750e-03) * s0_1_2;
	r0 += M4(1.589e-03, 6.034e-04, -2.218e-02, -2.793e-03, -1.781e-03, 4.077e-04, -1.943e-04, -6.053e-03, -4.239e-03, -1.245e-03, 1.460e-01, 1.470e-02, -4.503e-04, -1.908e-03, 3.483e-02, 1.103e-02) * s0_2_0;
	r0 += M4(8.837e-04, -5.246e-04, -3.600e-03, -3.899e-02, -1.353e-03, -5.442e-03, 1.784e-02, -1.268e-02, 2.917e-04, 3.233e-03, 2.026e-01, 2.789e-01, 4.183e-04, 6.724e-03, -1.669e-02, 6.788e-02) * s0_2_1;
	r0 += M4(2.707e-04, -1.812e-03, 4.570e-04, -4.994e-03, -3.174e-04, 4.956e-04, -6.908e-04, 5.812e-03, 2.928e-03, -4.311e-03, 1.661e-02, 7.037e-02, 6.701e-05, 2.791e-03, -2.448e-04, 8.622e-04) * s0_2_2;
	r0 += M4(2.473e-03, 1.688e-04, 6.076e-04, 2.107e-04, 6.776e-01, -3.207e-01, -3.948e-01, -1.762e-02, -1.305e-02, 1.658e-03, 3.043e-03, 1.161e-03, 4.288e-02, 1.121e-03, 3.547e-02, 3.312e-04) * s1_0_0;
	r0 += M4(1.611e-03, 3.590e-02, 1.813e-02, 1.043e-02, -1.250e-02, 4.802e-03, 7.519e-03, -7.370e-02, 4.907e-02, 3.992e-02, -6.265e-03, -2.309e-03, -1.767e-01, 6.163e-01, -2.640e-01, -2.668e-03) * s1_0_1;
	r0 += M4(4.046e-03, -3.551e-02, 1.189e-03, 2.776e-04, 6.009e-05, -4.936e-04, -1.673e-04, -7.570e-04, 4.939e-04, 3.102e-02, -6.439e-04, 4.612e-04, 1.237e-02, -8.277e-02, -8.561e-03, -1.073e-01) * s1_0_2;
	r0 += M4(1.381e-02, 6.220e-03, 7.448e-03, 5.965e-03, -6.904e-03, 1.199e-03, 1.292e-02, -1.011e-01, -5.317e-02, -4.654e-03, -3.493e-02, -4.372e-04, 3.622e-04, -4.991e-04, 3.478e-02, 1.374e-03) * s1_1_0;
	r0 += M4(-4.287e-01, -1.516e-01, -2.309e-01, 3.710e-02, -2.734e-03, -4.113e-03, -4.476e-03, -3.980e-02, 1.792e-01, -5.059e-01, 4.834e-01, 2.061e-02, 1.111e-02, 1.884e-03, 6.519e-02, 1.851e-01) * s1_1_1;
	r0 += M4(5.946e-03, -7.980e-02, 8.023e-03, -5.669e-02, -1.352e-04, -1.234e-03, 2.979e-05, -8.102e-04, 3.982e-04, 9.377e-02, -1.470e-03, 1.101e-01, 1.587e-03, 2.382e-03, 1.412e-02, 2.295e-02) * s1_1_2;
	r0 += M4(9.474e-04, 2.385e-04, 5.123e-03, 2.388e-03, -2.845e-05, -3.780e-06, 3.829e-04, -4.331e-04, 4.010e-03, 9.158e-04, -5.717e-02, -4.495e-03, -1.511e-09, 3.279e-07, -7.790e-05, 1.333e-06) * s1_2_0;
	r0 += M4(3.589e-03, 7.103e-03, -1.091e-01, -3.753e-02, -1.133e-06, -7.744e-05, 2.463e-04, 1.461e-04, -6.165e-03, 2.632e-03, -1.947e-02, -1.538e-01, 2.204e-05, 8.564e-06, -7.625e-04, 9.649e-05) * s1_2_1;
	r0 += M4(7.097e-04, -4.438e-03, 6.621e-04, -3.779e-02, -5.328e-08, 1.141e-06, -7.899e-08, 3.284e-05, -1.033e-03, -1.219e-03, -8.548e-03, 5.265e-03, 6.527e-07, 5.636e-05, -1.795e-04, -3.353e-04) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 += M4(9.892e-03, 3.307e-03, 4.081e-03, -2.847e-03, -1.413e-02, -1.166e-03, 9.904e-04, -8.748e-04, -7.642e-03, 2.281e-04, -1.446e-02, -8.679e-03, 4.054e-02, -3.649e-02, -1.417e-02, -4.728e-03) * s0_0_0;
	r0 += M4(-1.361e-01, 1.022e-02, 2.567e-02, 3.283e-02, -7.628e-02, -6.897e-02, -3.096e-03, -1.908e-03, -3.357e-02, 3.973e-03, 3.743e-03, 6.577e-03, -1.645e-03, 3.705e-02, -5.532e-03, 4.438e-04) * s0_0_1;
	r0 += M4(5.677e-03, -2.132e-02, 4.381e-03, 3.103e-02, 1.940e-04, 3.724e-03, -1.168e-04, -2.697e-03, -3.001e-02, -7.031e-02, 2.111e-02, 6.155e-03, -3.733e-04, -2.736e-03, -1.413e-05, -1.431e-03) * s0_0_2;
	r0 += M4(-1.418e-02, 9.716e-03, -1.018e-03, 1.490e-02, -4.433e-02, 2.718e-03, -7.056e-02, -3.833e-03, -1.591e-03, -2.485e-04, -1.607e-02, -3.088e-03, -4.830e-01, 2.328e-01, 3.691e-01, 1.952e-02) * s0_1_0;
	r0 += M4(1.057e+00, 4.298e-02, -6.448e-01, -1.343e-01, 2.542e-01, 2.214e-01, 2.370e-01, -2.799e-01, 2.331e-02, -2.824e-02, -5.553e-02, -1.174e-02, 2.186e-02, -1.685e-01, -1.702e-02, 1.440e-01) * s0_1_1;
	r0 += M4(-1.265e-02, 3.654e-01, -3.506e-02, -1.267e-01, 1.053e-03, 1.061e-01, 5.046e-03, 1.213e-01, 1.606e-01, 1.877e-01, -1.028e-01, -1.076e-01, -7.882e-04, -2.580e-03, -4.474e-04, -1.439e-03) * s0_1_2;
	r0 += M4(-1.542e-02, -4.031e-04, -6.525e-03, -2.250e-03, -3.230e-03, 1.566e-04, 3.961e-02, 4.338e-03, 7.764e-04, 5.295e-04, -7.335e-03, 8.814e-05, 2.546e-02, -2.311e-04, -4.908e-02, 5.959e-02) * s0_2_0;
	r0 += M4(-1.965e-02, -1.732e-02, 2.570e-01, -2.352e-02, -3.292e-03, -2.902e-03, 8.418e-02, 9.922e-02, -6.708e-02, -1.138e-03, -3.354e-02, -2.647e-02, 2.370e-03, 6.271e-03, 4.345e-03, 6.721e-04) * s0_2_1;
	r0 += M4(-1.872e-01, -2.730e-02, 4.286e-02, 8.333e-02, -2.086e-04, -8.880e-04, -8.076e-04, 2.815e-02, -1.657e-02, -1.066e-01, 1.353e-01, 8.888e-02, -3.005e-04, 2.559e-03, 4.856e-05, 6.482e-04) * s0_2_2;
	r0 += V4(1.718e-08, 2.879e-08, 5.555e-09, -1.238e-09);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
