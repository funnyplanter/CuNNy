// CuNNy fast SOFT (dp4a)
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


//!DESC CuNNy-fast-SOFT-in
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
	r0 += V4(3.010e-02, 1.564e-02, -1.653e-02, -3.702e-03) * s0_0_0;
	r1 += V4(-1.406e-02, 1.070e-02, -3.109e-02, 2.731e-02) * s0_0_0;
	r2 += V4(-5.163e-02, 4.491e-02, 7.853e-01, 2.529e-01) * s0_0_0;
	r0 += V4(2.803e-02, -1.895e-02, 1.012e+00, 2.149e-02) * s0_0_1;
	r1 += V4(1.870e-01, -2.768e-02, -2.353e-01, 2.040e-01) * s0_0_1;
	r2 += V4(-5.183e-01, -3.464e-02, -7.988e-01, -4.419e-02) * s0_0_1;
	r0 += V4(-2.810e-02, -2.463e-03, 1.985e-02, -3.392e-02) * s0_0_2;
	r1 += V4(6.055e-01, 1.673e-02, -1.892e-01, 4.952e-02) * s0_0_2;
	r2 += V4(-1.032e-01, -7.236e-02, 3.918e-03, -2.431e-02) * s0_0_2;
	r0 += V4(3.346e-01, 8.850e-01, 2.140e-03, -9.192e-03) * s0_1_0;
	r1 += V4(-5.193e-02, -2.364e-02, 4.263e-02, 7.263e-02) * s0_1_0;
	r2 += V4(-4.015e-03, -5.815e-03, -7.910e-01, -5.395e-01) * s0_1_0;
	r0 += V4(-8.111e-01, -8.756e-01, -9.627e-01, -6.735e-02) * s0_1_1;
	r1 += V4(-7.967e-01, -9.668e-01, 3.975e-01, -8.028e-01) * s0_1_1;
	r2 += V4(7.652e-01, 9.664e-01, 7.637e-01, -1.460e-01) * s0_1_1;
	r0 += V4(7.927e-02, -5.525e-03, -4.855e-02, -9.200e-01) * s0_1_2;
	r1 += V4(2.806e-02, 9.875e-01, 8.642e-03, 2.861e-01) * s0_1_2;
	r2 += V4(-5.948e-02, -4.044e-01, 2.062e-02, 9.010e-02) * s0_1_2;
	r0 += V4(-1.899e-02, 2.585e-02, 1.148e-02, 1.157e-02) * s0_2_0;
	r1 += V4(7.441e-02, 6.822e-03, -3.548e-02, -4.318e-02) * s0_2_0;
	r2 += V4(1.059e-02, -6.225e-02, -6.352e-04, 1.452e-01) * s0_2_0;
	r0 += V4(2.635e-01, -1.487e-02, -4.457e-02, 5.068e-02) * s0_2_1;
	r1 += V4(-7.955e-03, 1.923e-02, 1.438e-02, -1.157e-02) * s0_2_1;
	r2 += V4(-1.213e-01, -4.688e-01, 4.193e-02, 3.039e-01) * s0_2_1;
	r0 += V4(2.899e-02, -1.022e-02, 2.218e-02, 9.512e-01) * s0_2_2;
	r1 += V4(-2.496e-02, -2.301e-02, -5.402e-03, 8.511e-02) * s0_2_2;
	r2 += V4(8.476e-02, 3.721e-02, -2.634e-02, -4.782e-02) * s0_2_2;
	r0 += V4(-1.865e-03, 9.461e-04, -2.628e-04, 2.123e-04);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-8.868e-03, 5.735e-04, -8.273e-03, -1.885e-03);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(1.006e-02, 3.972e-03, -2.517e-03, -8.864e-03);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-fast-SOFT-conv1
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
	r0 = D(r0, s0_0_0, 0xE6000A0A, 0x81FE06DE, 0xE5FE06EC, 0xC0EBEF1C);
	r1 = D(r1, s0_0_0, 0xE9F8F518, 0xED0D02F6, 0x81E60CF2, 0x0803F811);
	r2 = D(r2, s0_0_0, 0xFAFD04FC, 0x810205E8, 0x06F9F628, 0x02FFFDFE);
	r0 = D(r0, s0_0_1, 0xF0FAEEF9, 0xF7F2E781, 0x0F0CFCF8, 0xC4E7E3E5);
	r1 = D(r1, s0_0_1, 0xEE192045, 0xFEFA06ED, 0xD1D5CC81, 0x00F508F3);
	r2 = D(r2, s0_0_1, 0xF6FA08FD, 0x3DFE2A0F, 0x0217E010, 0x0402F204);
	r0 = D(r0, s0_0_2, 0x050901DB, 0xFD0404EF, 0x00FDF5FC, 0xFADFC005);
	r1 = D(r1, s0_0_2, 0x0CFFF609, 0xFC011CD2, 0x00C8F41D, 0xFEF20202);
	r2 = D(r2, s0_0_2, 0xFC01F7F2, 0xFB091DB2, 0x0011E305, 0x03FEF4F4);
	r0 = D(r0, s0_1_0, 0xE806F4F9, 0xF80F0404, 0x21EFFD0D, 0x43BAE55D);
	r1 = D(r1, s0_1_0, 0x81012AC2, 0xFB15F424, 0xFDF4FEF3, 0x23D7FA01);
	r2 = D(r2, s0_1_0, 0x03F500FE, 0xCF271FC9, 0x53F60AD5, 0x1CFBF80C);
	r0 = D(r0, s0_1_1, 0x02EE6F23, 0xF92505D3, 0x0A3733DE, 0xD0403ECB);
	r1 = D(r1, s0_1_1, 0x00818181, 0x29E1F908, 0xFF39F9C6, 0xDDF051FD);
	r2 = D(r2, s0_1_1, 0xDE0A06F7, 0x28E0F525, 0xD508EFDF, 0x34FE03F0);
	r0 = D(r0, s0_1_2, 0x07FDE8D5, 0xFB18DE0D, 0x0C0600EF, 0xFFE4C8DB);
	r1 = D(r1, s0_1_2, 0x0A1524EC, 0xF8189DF3, 0x0109DAF7, 0x02EF07FB);
	r2 = D(r2, s0_1_2, 0xFDDB8181, 0x041381D6, 0x02F6EDF4, 0xFE0813FA);
	r0 = D(r0, s0_2_0, 0xFBF00204, 0xECF1F71D, 0xF6F7F90C, 0xD1D7E533);
	r1 = D(r1, s0_2_0, 0x05FDFFDF, 0xF608F813, 0xFBFEFC0E, 0x06C8DC27);
	r2 = D(r2, s0_2_0, 0x05F40105, 0xFC3C1CF1, 0xA93515D9, 0xC3E903F5);
	r0 = D(r0, s0_2_1, 0x06080D13, 0xF0D9E74A, 0x03F3040B, 0xE38FE17A);
	r1 = D(r1, s0_2_1, 0x01F500EA, 0xEDC9EC22, 0x0902F80C, 0xFAE2F5FE);
	r2 = D(r2, s0_2_1, 0xFD0601F0, 0x0681D3F8, 0xC5C42F24, 0xF081D630);
	r0 = D(r0, s0_2_2, 0xFFF8E4FE, 0xFEED040F, 0x051415F7, 0xFEEAF23A);
	r1 = D(r1, s0_2_2, 0x07290D08, 0x01EE05E6, 0x06FD11F5, 0x0202F80D);
	r2 = D(r2, s0_2_2, 0xFFECF7E0, 0x071607FC, 0xF1EDF33C, 0x00F5F6EB);
	r0 = D(r0, s1_0_0, 0xF2F5120A, 0xE7FC040C, 0x0601FBFF, 0x1B3BDD03);
	r1 = D(r1, s1_0_0, 0x100FDB02, 0xF7FBF603, 0x0AF6E81A, 0xEE0FF413);
	r2 = D(r2, s1_0_0, 0xFDF405FF, 0xCAC3EC1F, 0x03E30804, 0xF8F6FB05);
	r0 = D(r0, s1_0_1, 0x001DFDF0, 0xE8FCEFF3, 0xFCF51200, 0x49C4F511);
	r1 = D(r1, s1_0_1, 0xE923F307, 0x2A1C03F4, 0x1311943F, 0xF6FEF211);
	r2 = D(r2, s1_0_1, 0xF80A0808, 0xBA413D03, 0xE24232F8, 0x0926FDFB);
	r0 = D(r0, s1_0_2, 0x14F0F9FD, 0x04F3F30B, 0x03F70D00, 0x63FBE100);
	r1 = D(r1, s1_0_2, 0xF41D0704, 0x28EB06F5, 0x04F1F512, 0x0DF0F608);
	r2 = D(r2, s1_0_2, 0x01FFFCFD, 0x06B7080F, 0xE9FD0CF8, 0x0F020102);
	r0 = D(r0, s1_1_0, 0xDFFFCC02, 0xE03ED9FD, 0xF54ACA1D, 0xCBF6AB48);
	r1 = D(r1, s1_1_0, 0x18FBCA64, 0xF016D8DE, 0xF23C0010, 0x0618AC3F);
	r2 = D(r2, s1_1_0, 0x030EFCFA, 0xF77F8135, 0x11F22A19, 0xF710030B);
	r0 = D(r0, s1_1_1, 0xD1FE0A10, 0x3ADEFE04, 0x0FD70803, 0xF0FC1610);
	r1 = D(r1, s1_1_1, 0x151881BB, 0x39F14DEF, 0x0CD23427, 0xD1E20528);
	r2 = D(r2, s1_1_1, 0x09003210, 0x35C19FF5, 0xD60F30EF, 0xFA04100B);
	r0 = D(r0, s1_1_2, 0x4E0AEBFC, 0xF1FB000A, 0xF80B0AF2, 0x64FAEDF7);
	r1 = D(r1, s1_1_2, 0xE9DCFDFF, 0x3819ECE9, 0xEC05030F, 0x1007F909);
	r2 = D(r2, s1_1_2, 0x8106D8EB, 0xE1281AE1, 0x1BF4BDF0, 0xECFB06FB);
	r0 = D(r0, s1_2_0, 0xFCD404F1, 0xDFE0FA1E, 0xF904F00D, 0x23BCC808);
	r1 = D(r1, s1_2_0, 0x171E03EF, 0xE1DB13EA, 0xF1F3FC0B, 0x10F1F14A);
	r2 = D(r2, s1_2_0, 0xFAF90505, 0xB5145081, 0x08EAC305, 0xF6F7DE29);
	r0 = D(r0, s1_2_1, 0x00DBFF14, 0xBBFB0301, 0x1130FAF4, 0xCF3FCC4B);
	r1 = D(r1, s1_2_1, 0xEAA41416, 0xE124101F, 0xF80CF108, 0xDE04071B);
	r2 = D(r2, s1_2_1, 0x0A2B2212, 0x01712C12, 0x15BEBDFB, 0x2E3DE3DC);
	r0 = D(r0, s1_2_2, 0x0010F8FC, 0xEA070B01, 0x06FFFEF9, 0x110FE8EB);
	r1 = D(r1, s1_2_2, 0xE8F11308, 0xF7E605FA, 0x01050300, 0xEDFC0700);
	r2 = D(r2, s1_2_2, 0xF3E6F5FB, 0x14E5FAFD, 0x436296E3, 0x0700FE00);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFE010309, 0x05FF0D12, 0xFDFF0EFF, 0xFF032FDA);
	r1 = D(r1, s0_0_0, 0x0E04C1FF, 0xEFFEF703, 0x05FD1003, 0x01010DFE);
	r2 = D(r2, s0_0_0, 0x0800FA08, 0x170EF523, 0x1DF8281C, 0x04FFFF03);
	r0 = D(r0, s0_0_1, 0xDF0803F1, 0x0E0927EA, 0x03FF160C, 0x1DF9EE1F);
	r1 = D(r1, s0_0_1, 0xE20114FB, 0xCFFFFFF8, 0xFA0E0AF1, 0xDA0B02F2);
	r2 = D(r2, s0_0_1, 0x0B0103FA, 0xC722BD06, 0xF203F9C7, 0xFF02F8F2);
	r0 = D(r0, s0_0_2, 0x3AF7F804, 0x35FD010E, 0xBC0604FE, 0x0E07EA04);
	r1 = D(r1, s0_0_2, 0xB71413D6, 0x06FFFB05, 0xFEF1FD0B, 0xFE020011);
	r2 = D(r2, s0_0_2, 0x0302EC03, 0x061E150C, 0xE0F8F608, 0xF00102FA);
	r0 = D(r0, s0_1_0, 0xF3FA20F3, 0x0109F20F, 0x07FC0DE9, 0x06F709FD);
	r1 = D(r1, s0_1_0, 0xF607F90E, 0x09F807FD, 0xF207F71A, 0xF308F922);
	r2 = D(r2, s0_1_0, 0xFF02FAF8, 0xFB25D1F7, 0xF403F1E7, 0xF8041F04);
	r0 = D(r0, s0_1_1, 0x39F1E30E, 0x14F3F3C5, 0xE414FC08, 0xF93801AF);
	r1 = D(r1, s0_1_1, 0xD3021B02, 0x1FC6E9F5, 0x1FF20DB2, 0xE30306E1);
	r2 = D(r2, s0_1_1, 0x0007EFF0, 0xF2AF39C8, 0x081081E3, 0xEA18DFF0);
	r0 = D(r0, s0_1_2, 0x09FFFFF9, 0x22FC020B, 0x130AFBF5, 0x0A39E931);
	r1 = D(r1, s0_1_2, 0x7F10F7F9, 0x09F60EF6, 0xD7FA0105, 0x0A0B00FC);
	r2 = D(r2, s0_1_2, 0x140B170B, 0x02D8FD0B, 0x2B08E146, 0x19190400);
	r0 = D(r0, s0_2_0, 0x0305FE03, 0xECFCFD04, 0x01F902F8, 0xFEFEFD0D);
	r1 = D(r1, s0_2_0, 0x0E030AFD, 0xFB05F921, 0xFD08FF1F, 0xEFEFFEF3);
	r2 = D(r2, s0_2_0, 0xFFFE04FD, 0xE321F17F, 0x0B0505CB, 0x0700F4FD);
	r0 = D(r0, s0_2_1, 0xFF120104, 0xE5FAFF19, 0x0C08F9ED, 0xEC34FEC6);
	r1 = D(r1, s0_2_1, 0xF8EEED20, 0x0DF70428, 0x0B0CFE07, 0xB70903FB);
	r2 = D(r2, s0_2_1, 0xFF0F02FE, 0x65A8089D, 0x3B080200, 0x0705043B);
	r0 = D(r0, s0_2_2, 0xF2F300FB, 0x2BE4FC03, 0xF60C07F6, 0x3944FC50);
	r1 = D(r1, s0_2_2, 0x0A0B0AF1, 0x23D00208, 0xE41D0114, 0xF42E000C);
	r2 = D(r2, s0_2_2, 0x0ED3FA1E, 0xDCD40ADD, 0x2144F603, 0x03C702F2);
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

//!DESC CuNNy-fast-SOFT-conv2
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
	r0 = D(r0, s0_0_0, 0x0102FC01, 0xF704F501, 0xFB00FF01, 0xF4FA0309);
	r1 = D(r1, s0_0_0, 0xFA0500F1, 0xF4020003, 0xF50CF5FB, 0xF3FF0400);
	r0 = D(r0, s0_0_1, 0xFF04FF01, 0xF60CEF05, 0xF70EF3F4, 0xF60CFEFE);
	r1 = D(r1, s0_0_1, 0xF10402F2, 0x08F80802, 0xDAFBFE0A, 0x02FC0BF6);
	r0 = D(r0, s0_0_2, 0xF2000301, 0xFB01FF02, 0xF505FA04, 0xFC01040D);
	r1 = D(r1, s0_0_2, 0xFE01FF05, 0xFA030504, 0xF604F632, 0xFB020301);
	r0 = D(r0, s0_1_0, 0xEBFE010F, 0xF2F20406, 0xF809FEFB, 0xF501F303);
	r1 = D(r1, s0_1_0, 0xEA1CFFF5, 0x05FD0101, 0xF5030601, 0xF110FDFC);
	r0 = D(r0, s0_1_1, 0xFAD712C3, 0xCCCD2F0D, 0xE1F2F607, 0xE708EDE3);
	r1 = D(r1, s0_1_1, 0xE5DCF606, 0xCD15E2EB, 0x1AFC1FF6, 0xE1F3D20E);
	r0 = D(r0, s0_1_2, 0xF10BEE14, 0xF8FEFC0B, 0x19F4FC1C, 0xE713EE5D);
	r1 = D(r1, s0_1_2, 0xF215F153, 0x0606F741, 0xFC0B05F9, 0xEC14F946);
	r0 = D(r0, s0_2_0, 0x1AEAF3EA, 0xFC100200, 0x00070400, 0xF408FDFF);
	r1 = D(r1, s0_2_0, 0xFA040202, 0xF9030404, 0xFFFF01FF, 0xF9090902);
	r0 = D(r0, s0_2_1, 0xD832E620, 0xF20C5803, 0xF7152EFB, 0xFD200200);
	r1 = D(r1, s0_2_1, 0xFA1A03FC, 0x04192FFE, 0xFB040303, 0xE81A59F8);
	r0 = D(r0, s0_2_2, 0x03F71FFE, 0xFF090100, 0xFB0BF507, 0xF808F902);
	r1 = D(r1, s0_2_2, 0xFA080200, 0xF7FC0A01, 0x00FE0201, 0xFD040301);
	r0 = D(r0, s1_0_0, 0xE8000109, 0x071004FF, 0xFE04FE01, 0xF700F9FB);
	r1 = D(r1, s1_0_0, 0x13030100, 0xF8FFFD03, 0x070D06ED, 0xFF01FCFE);
	r0 = D(r0, s1_0_1, 0xFC0002FA, 0xE6080BFC, 0x100B08E8, 0x0E000004);
	r1 = D(r1, s1_0_1, 0xEEF9FF0D, 0x03FBF5FE, 0xF90FF8F1, 0x0BF5FE07);
	r0 = D(r0, s1_0_2, 0x0CFDFF02, 0xF9030800, 0xEF030702, 0xF2FCFFFE);
	r1 = D(r1, s1_0_2, 0x00FF0201, 0x02FDFCFE, 0xFE0900F3, 0xFC000102);
	r0 = D(r0, s1_1_0, 0xC4DAF416, 0xF404FE01, 0x05080502, 0x03050410);
	r1 = D(r1, s1_1_0, 0x02E01602, 0xFF07F408, 0xFFEF07FF, 0x06110806);
	r0 = D(r0, s1_1_1, 0x38EEFA05, 0x22EB99F8, 0x000AF3EF, 0x10FEDEC3);
	r1 = D(r1, s1_1_1, 0xEE2D97DB, 0x171A17B6, 0xFEEAE4F8, 0xE230C6D5);
	r0 = D(r0, s1_1_2, 0xDE08FCFF, 0xF905F5F6, 0xF401ECF1, 0xFE0300EF);
	r1 = D(r1, s1_1_2, 0xFCF906F7, 0xAB0BFEEF, 0x04EF02FE, 0x030400EE);
	r0 = D(r0, s1_2_0, 0xB207F603, 0xF8F2FBF9, 0xFAF402FC, 0x03FA0102);
	r1 = D(r1, s1_2_0, 0xFDFB07FC, 0xFDFEFEFD, 0x02FF00FD, 0xF5ED04F8);
	r0 = D(r0, s1_2_1, 0xFE01FBFB, 0xF70503FF, 0xFAF8F6F0, 0xF8E0F7EE);
	r1 = D(r1, s1_2_1, 0xECE0F7F8, 0xF6BDF9E9, 0x01F9FC02, 0xF8F8FAF8);
	r0 = D(r0, s1_2_2, 0xF8F9FDEB, 0xFEF80300, 0xE90800FD, 0x0401F8FB);
	r1 = D(r1, s1_2_2, 0xFC06FBFF, 0x0F09FE00, 0x03000001, 0xF905FDFC);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x00FDFBF8, 0xF7FEFFF8, 0x03F90006, 0x0BFAFD0B);
	r1 = D(r1, s0_0_0, 0xF50201F4, 0x04FEFD03, 0x08F9FCF1, 0x06F9FD0B);
	r0 = D(r0, s0_0_1, 0xFAFCFE01, 0xFAFB0006, 0xF2F8FE00, 0xFBE8F710);
	r1 = D(r1, s0_0_1, 0x10F0F025, 0x03FC01FF, 0x5405ED1A, 0xFEFAFA0A);
	r0 = D(r0, s0_0_2, 0xFA0AFC09, 0xFEFCFF04, 0x0204FD03, 0xFD0DFE00);
	r1 = D(r1, s0_0_2, 0xFDFFF8FF, 0xFA02FD07, 0x03FFF700, 0xFEF4FC01);
	r0 = D(r0, s0_1_0, 0xF0FD0120, 0x23F5F702, 0x04FDFDF3, 0xEF00F3F9);
	r1 = D(r1, s0_1_0, 0x01F501F9, 0x06FBFD01, 0x0205FF04, 0x04F2F9ED);
	r0 = D(r0, s0_1_1, 0xC1CAD7ED, 0x622BD3E7, 0x1806EE63, 0x19DADD08);
	r1 = D(r1, s0_1_1, 0xF925D95F, 0x2BC0EE37, 0xFA07F317, 0x14F9E339);
	r0 = D(r0, s0_1_2, 0xFD17F207, 0x0B05EB03, 0x100CF2F9, 0xFC05F8FF);
	r1 = D(r1, s0_1_2, 0xFD01DCF9, 0x040EFEF5, 0x02FEF100, 0xFF02EAFF);
	r0 = D(r0, s0_2_0, 0x03FDDEE5, 0x02EFFE00, 0xFD050001, 0x01F7FCFE);
	r1 = D(r1, s0_2_0, 0x0006FEFD, 0x0305FBFC, 0x02FD0100, 0xFE070101);
	r0 = D(r0, s0_2_1, 0x0AD3E50B, 0xFF02E302, 0x0100EF07, 0xF700E50C);
	r1 = D(r1, s0_2_1, 0xF901EA0F, 0xF30EFA03, 0x0204FE03, 0x0207EC07);
	r0 = D(r0, s0_2_2, 0x0504F201, 0xF902F5FE, 0x00FDF60B, 0x03FFFA0A);
	r1 = D(r1, s0_2_2, 0x0200F906, 0x05FAFA06, 0x0201FF00, 0xFF00F805);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-fast-SOFT-out-shuffle
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
	r0 += M4(-8.745e-02, 3.383e-02, 4.779e-03, 1.345e-02, -1.868e-03, 2.867e-03, -2.889e-04, 1.115e-03, 6.221e-02, 2.749e-03, -1.133e-02, -4.452e-03, -3.269e-02, -3.297e-04, 7.234e-03, -4.700e-03) * s0_0_0;
	r0 += M4(4.776e-01, -2.351e-01, -4.595e-02, -1.193e-01, -2.361e-02, -2.980e-02, 9.339e-04, 3.573e-03, 4.443e-03, -5.262e-02, 2.593e-04, -4.259e-02, 2.009e-02, 3.289e-02, -1.821e-03, 1.233e-02) * s0_0_1;
	r0 += M4(-6.475e-03, 9.050e-02, 1.046e-02, 8.310e-02, 1.110e-02, 1.366e-02, -7.064e-04, 6.121e-03, -1.315e-03, -1.964e-03, 8.686e-05, -1.607e-03, 6.700e-03, 2.105e-02, -1.192e-03, 2.453e-03) * s0_0_2;
	r0 += M4(-2.723e-02, 1.998e-02, -4.554e-02, 2.205e-02, -4.439e-02, -4.404e-03, -2.104e-02, 8.697e-03, 2.229e-01, 1.297e-02, 3.286e-01, 9.755e-03, -2.192e-01, 4.147e-03, -1.890e-01, -1.323e-03) * s0_1_0;
	r0 += M4(9.382e-03, 4.344e-02, 1.685e-01, 7.939e-02, -3.460e-01, -2.019e-01, 4.834e-01, 1.129e-01, -2.867e-02, -2.495e-01, -1.358e-02, 2.568e-01, 2.339e-01, -4.131e-01, 4.346e-01, 6.522e-03) * s0_1_1;
	r0 += M4(2.435e-04, -3.573e-03, -3.126e-03, 1.075e-02, -3.135e-03, -6.763e-02, -5.822e-03, 1.431e-01, -1.461e-04, -5.105e-03, 2.164e-03, -2.817e-02, -7.371e-03, 1.032e-01, -1.119e-03, 1.146e-01) * s0_1_2;
	r0 += M4(8.547e-04, 6.011e-04, 1.048e-05, 1.014e-02, -4.715e-04, -1.370e-03, -2.071e-02, -1.915e-03, -1.364e-02, -2.617e-03, 1.969e-02, -4.878e-03, 2.998e-03, 6.190e-03, -3.958e-02, 1.057e-02) * s0_2_0;
	r0 += M4(7.958e-04, -5.562e-04, 5.722e-03, 1.152e-02, 1.077e-02, 2.148e-03, -1.172e-01, -6.975e-02, -4.030e-03, -9.735e-03, -6.964e-03, -7.798e-02, -7.563e-03, 1.614e-02, 1.546e-02, -1.085e-01) * s0_2_1;
	r0 += M4(2.204e-04, 1.508e-04, 1.628e-05, 1.893e-03, -4.284e-04, 5.033e-03, -7.737e-03, -3.635e-02, 1.147e-04, -2.175e-03, 1.822e-03, 2.527e-04, 7.215e-04, 1.079e-02, -9.029e-04, 2.809e-02) * s0_2_2;
	r0 += M4(2.697e-03, -1.313e-03, -1.015e-03, 4.832e-04, 1.273e-02, -1.454e-02, -1.164e-02, 1.968e-04, -1.176e-05, 3.554e-06, -1.848e-07, 6.425e-06, -6.480e-02, 8.408e-03, 5.938e-03, 1.289e-04) * s1_0_0;
	r0 += M4(2.913e-02, 4.024e-02, -2.495e-03, 7.654e-03, 4.229e-03, -9.018e-02, -8.102e-03, -1.311e-02, -1.756e-03, -1.098e-03, 5.380e-06, -2.058e-05, -2.447e-01, -2.065e-01, 6.129e-03, 7.875e-03) * s1_0_1;
	r0 += M4(-7.388e-04, -6.594e-03, -3.001e-04, -2.827e-03, 1.036e-03, 3.589e-03, -1.856e-03, -3.167e-03, 3.969e-04, -1.935e-06, -3.594e-06, 2.495e-07, 4.183e-03, -4.137e-02, 1.717e-03, 8.706e-03) * s1_0_2;
	r0 += M4(4.236e-02, -7.043e-03, 2.397e-02, 6.630e-03, 7.486e-02, -2.240e-02, -6.752e-03, -4.068e-03, 4.342e-02, -4.620e-03, 8.827e-03, 3.317e-04, -8.227e-02, 1.475e-03, -7.788e-02, 6.877e-03) * s1_1_0;
	r0 += M4(-5.452e-01, 3.314e-01, -9.257e-02, 1.323e-01, 3.059e-02, 7.693e-02, 3.600e-02, -6.459e-01, 2.915e-01, 3.681e-01, 2.526e-04, 1.969e-02, 4.150e-01, 3.682e-01, -2.828e-01, -2.700e-02) * s1_1_1;
	r0 += M4(1.040e-02, -1.398e-01, -1.829e-03, -2.740e-02, 1.530e-03, 1.808e-02, 4.368e-05, 4.800e-02, -1.787e-02, 3.889e-02, 7.303e-04, -1.238e-02, -4.286e-03, 4.341e-02, 6.535e-03, -7.488e-02) * s1_1_2;
	r0 += M4(4.696e-04, -2.962e-03, 8.343e-03, 1.359e-03, -8.558e-04, -3.073e-03, -1.854e-04, -1.114e-02, -4.766e-02, 2.779e-03, -1.173e-01, -4.016e-02, 8.598e-03, 3.102e-03, 9.206e-03, 6.121e-03) * s1_2_0;
	r0 += M4(1.529e-02, -7.346e-03, -1.218e-01, 7.152e-02, 3.859e-03, 4.380e-03, 1.324e-02, 3.100e-02, -4.309e-02, -1.859e-02, -2.529e-01, 2.073e-01, -1.059e-02, 2.768e-03, 1.333e-01, 1.159e-01) * s1_2_1;
	r0 += M4(-6.572e-04, -7.312e-03, -3.383e-03, -5.428e-02, -6.678e-04, 9.883e-04, -2.315e-03, 2.015e-03, 4.007e-04, -7.839e-03, -4.416e-03, -6.325e-02, -3.776e-05, -4.929e-03, 6.210e-03, 3.366e-02) * s1_2_2;
	r0 += V4(-1.011e-09, -5.997e-09, 3.794e-09, 4.918e-10);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
