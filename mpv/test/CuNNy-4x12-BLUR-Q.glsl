// CuNNy 4x12 BLUR (dp4a)
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


//!DESC CuNNy-4x12-BLUR-in
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
	r0 += V4(3.160e-02, -7.305e-03, 8.496e-01, 8.519e-04) * s0_0_0;
	r1 += V4(-1.845e-02, 4.788e-03, -4.872e-01, 3.103e-02) * s0_0_0;
	r2 += V4(1.762e-02, -4.926e-03, 9.843e-03, 8.769e-03) * s0_0_0;
	r0 += V4(-1.803e-01, 6.563e-03, -8.454e-01, 4.529e-01) * s0_0_1;
	r1 += V4(2.026e-02, -2.673e-02, 7.172e-01, 2.959e-01) * s0_0_1;
	r2 += V4(-1.520e-02, -3.973e-01, -8.697e-03, -1.415e-02) * s0_0_1;
	r0 += V4(-3.244e-02, -2.441e-03, -1.740e-02, -4.246e-01) * s0_0_2;
	r1 += V4(9.795e-01, 2.948e-02, -2.529e-01, 6.604e-02) * s0_0_2;
	r2 += V4(-1.047e-02, -2.160e-02, -3.076e-02, 2.204e-03) * s0_0_2;
	r0 += V4(2.006e-02, 2.388e-02, 3.782e-02, 1.627e-02) * s0_1_0;
	r1 += V4(2.138e-03, -1.200e-02, 3.098e-01, 1.197e-01) * s0_1_0;
	r2 += V4(-7.657e-02, 1.217e-02, -1.374e-02, -3.236e-02) * s0_1_0;
	r0 += V4(4.127e-01, 8.851e-01, -2.943e-02, -7.813e-02) * s0_1_1;
	r1 += V4(-1.629e-02, -9.004e-01, -3.403e-01, -7.731e-01) * s0_1_1;
	r2 += V4(-7.054e-01, 1.374e-03, -3.470e-01, -8.927e-01) * s0_1_1;
	r0 += V4(-7.272e-02, 1.321e-02, 7.334e-03, -1.047e-01) * s0_1_2;
	r1 += V4(5.849e-03, 9.091e-01, 1.710e-02, 1.427e-01) * s0_1_2;
	r2 += V4(-1.581e-02, 3.957e-01, 4.296e-01, -2.212e-02) * s0_1_2;
	r0 += V4(-1.096e-01, -2.252e-02, 1.826e-03, -2.927e-02) * s0_2_0;
	r1 += V4(-1.463e-04, 8.154e-04, 2.054e-01, 3.180e-02) * s0_2_0;
	r2 += V4(6.754e-02, 2.068e-03, -5.338e-02, 2.275e-02) * s0_2_0;
	r0 += V4(-4.850e-02, -8.848e-01, -5.558e-03, 1.218e-02) * s0_2_1;
	r1 += V4(-8.069e-03, -5.297e-02, -3.975e-01, 2.335e-02) * s0_2_1;
	r2 += V4(7.222e-01, 1.748e-02, 3.324e-02, 9.085e-01) * s0_2_1;
	r0 += V4(1.297e-02, -1.205e-02, 1.106e-03, 3.227e-02) * s0_2_2;
	r1 += V4(-8.711e-03, 4.851e-02, 2.261e-01, -8.004e-03) * s0_2_2;
	r2 += V4(3.188e-02, -8.789e-03, -6.309e-03, 2.020e-02) * s0_2_2;
	r0 += V4(5.215e-04, 3.120e-03, 3.306e-04, 9.941e-04);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-9.434e-01, 1.566e-03, -4.565e-03, -8.875e-05);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(6.878e-03, -1.508e-03, 1.919e-02, 2.432e-04);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-4x12-BLUR-conv1
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
	r0 = D(r0, s0_0_0, 0x030202FE, 0x02FFFDF1, 0xE20810FA, 0x160714F4);
	r1 = D(r1, s0_0_0, 0x14070DE0, 0xE8FF2A27, 0xE50A1225, 0x0FF5BDE8);
	r2 = D(r2, s0_0_0, 0xD2FC0103, 0xF9000207, 0x1006DA11, 0x02011714);
	r0 = D(r0, s0_0_1, 0xF80381E0, 0xFD0105F8, 0xF30B8104, 0xECFD81E9);
	r1 = D(r1, s0_0_1, 0xF7F507D3, 0xF2E516B8, 0x160B0732, 0x19F53FDE);
	r2 = D(r2, s0_0_1, 0xE70FDA05, 0xFA03FCFB, 0x06027D22, 0xF50CF7D5);
	r0 = D(r0, s0_0_2, 0xFE03FAEE, 0x01001501, 0x0517F2BC, 0xFA000F0C);
	r1 = D(r1, s0_0_2, 0xF9041122, 0x0ACCDB34, 0x0902F606, 0x04F7071E);
	r2 = D(r2, s0_0_2, 0xEAFF09F5, 0xFD04FE01, 0x0306FBF4, 0x05088100);
	r0 = D(r0, s0_1_0, 0xEA00FFEB, 0x0C03FD07, 0x4008EE31, 0x12F9F4FB);
	r1 = D(r1, s0_1_0, 0xE6F5E1E4, 0x240B21EF, 0x43070627, 0x2D0E0210);
	r2 = D(r2, s0_1_0, 0x23FAF3DA, 0x040002FD, 0x06FD00EE, 0xE1021302);
	r0 = D(r0, s0_1_1, 0xE803F93C, 0x0A022E2F, 0x09D70837, 0xFED6080B);
	r1 = D(r1, s0_1_1, 0x14FD0F7F, 0xC9EEC81C, 0xFAD1F7FA, 0x1503EB3E);
	r2 = D(r2, s0_1_1, 0x34ED81C5, 0x06FDF3EB, 0x091806E1, 0x18ED0BC6);
	r0 = D(r0, s0_1_2, 0x05FBFF0C, 0xFB0ED4EA, 0x16C8F512, 0xF6240301);
	r1 = D(r1, s0_1_2, 0xF719F50B, 0x0019130E, 0xFCFFFEEC, 0xEB070810);
	r2 = D(r2, s0_1_2, 0xF30D234D, 0xFDFE0C0D, 0x01F0FE06, 0xDFDFE62B);
	r0 = D(r0, s0_2_0, 0x03FF03FC, 0x0C00FE05, 0x87060110, 0x810302E5);
	r1 = D(r1, s0_2_0, 0x020C06F4, 0xEE04F90E, 0x06060AF5, 0xCFF30207);
	r2 = D(r2, s0_2_0, 0x7F0AFBFB, 0x030002F9, 0xFCFBFCFE, 0x3709EDF7);
	r0 = D(r0, s0_2_1, 0x1500FB03, 0xF0000BF9, 0x02810AC4, 0x1B810211);
	r1 = D(r1, s0_2_1, 0xF20000DB, 0xBEED0F08, 0xF3E508C9, 0xD41E00E6);
	r2 = D(r2, s0_2_1, 0xFBD50309, 0x1402FCFB, 0xE905020F, 0x81090C74);
	r0 = D(r0, s0_2_2, 0xFDFE03F9, 0x0C4FFAEC, 0xFEF703E0, 0x021AF728);
	r1 = D(r1, s0_2_2, 0x0BE108E6, 0xF481F9D8, 0xFBEFFFED, 0x040003F6);
	r2 = D(r2, s0_2_2, 0x0F810305, 0xFF810111, 0xFE00FF05, 0x258104AE);
	r0 = D(r0, s1_0_0, 0xFF0308E6, 0x0200EFEC, 0xFD1718FB, 0x0D0E22E9);
	r1 = D(r1, s1_0_0, 0x0E09174B, 0x060BFEEF, 0xEE08F7FD, 0x05FA81FB);
	r2 = D(r2, s1_0_0, 0x200B2135, 0x01FEFE1B, 0xFBFAE107, 0x04F51C3D);
	r0 = D(r0, s1_0_1, 0x0F05012F, 0x0005E00E, 0xED08B714, 0x0127FBB8);
	r1 = D(r1, s1_0_1, 0x0705103F, 0xDBD98146, 0x09EFE60C, 0x05F0E1D1);
	r2 = D(r2, s1_0_1, 0xED0DFEC3, 0x030003F6, 0xEE0510F6, 0xFA033827);
	r0 = D(r0, s1_0_2, 0x020804F7, 0x0000FA17, 0x2FE9F490, 0xE91418EF);
	r1 = D(r1, s1_0_2, 0xEB0B1801, 0x18F81750, 0x0FE7FEE5, 0xF3FFFA2C);
	r2 = D(r2, s1_0_2, 0xF810FE00, 0x0001FFF3, 0x07050005, 0x0802E6DD);
	r0 = D(r0, s1_1_0, 0x0303F92F, 0x050205FC, 0xCF1E1ADC, 0xFFFDCD7F);
	r1 = D(r1, s1_1_0, 0xEF05C5D4, 0xC8F2402C, 0xDD0F3C44, 0x31F3982C);
	r2 = D(r2, s1_1_0, 0x22038195, 0xFBFE0524, 0x1803FD72, 0xEB080681);
	r0 = D(r0, s1_1_1, 0x020BF429, 0xD3008116, 0x810A8181, 0x8EE8817E);
	r1 = D(r1, s1_1_1, 0xE7C3DD46, 0xEC043B7F, 0xC51C1EF8, 0xF0183015);
	r2 = D(r2, s1_1_1, 0x7FE5FDF5, 0x02FB6FF9, 0x0900F3E9, 0xBD2227C6);
	r0 = D(r0, s1_1_2, 0xFEFE03FB, 0xFA010722, 0x09F907FA, 0xDC1D04F1);
	r1 = D(r1, s1_1_2, 0xE3170A14, 0x13F4AD9A, 0x25040F1D, 0xF5181C2E);
	r2 = D(r2, s1_1_2, 0xDD541037, 0x0F0205F5, 0xFB0B0208, 0x220CF4DB);
	r0 = D(r0, s1_2_0, 0xFFFC0338, 0xF9FFFC7F, 0x0B1C11D5, 0x1BFFEC7F);
	r1 = D(r1, s1_2_0, 0xFEF5087F, 0xFC14D47F, 0x170C0181, 0x0CF9087F);
	r2 = D(r2, s1_2_0, 0xEFFFDD81, 0x05FFFAD3, 0xFDFF0231, 0xEC08F7CA);
	r0 = D(r0, s1_2_1, 0xF60A01D0, 0xFBFDE381, 0x0E111C84, 0x29FCEC5C);
	r1 = D(r1, s1_2_1, 0xF3FC034D, 0x18EBB47F, 0xF7111260, 0x07161C81);
	r2 = D(r2, s1_2_1, 0xF21B3809, 0x05FE094E, 0xF8050511, 0x02EDCC7F);
	r0 = D(r0, s1_2_2, 0x04FCFC00, 0x2203F9C6, 0x391DE708, 0xD50D0D21);
	r1 = D(r1, s1_2_2, 0xF7041B3A, 0xDFFA0CFC, 0x2809FEF7, 0x19FF061B);
	r2 = D(r2, s1_2_2, 0xBAF62418, 0xFC00FA06, 0xFB0207F9, 0x0BE2EC02);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x000A0EF2, 0xF90D0108, 0x06F10815, 0x02ECF5FE);
	r1 = D(r1, s0_0_0, 0xF7FA0F02, 0x0E0B32DA, 0xFFD6F612, 0xA5461216);
	r2 = D(r2, s0_0_0, 0x00D2EDF9, 0x0604FFFD, 0x09EF000B, 0x04F2FDE2);
	r0 = D(r0, s0_0_1, 0x08F1047F, 0x200F09E1, 0x816413FD, 0x49CE18D1);
	r1 = D(r1, s0_0_1, 0xD6C80B2A, 0xDCC8B408, 0x921902AC, 0x8121F5C0);
	r2 = D(r2, s0_0_1, 0x81E71542, 0x03EBFEFD, 0x81EFFCD4, 0xFDD91C2C);
	r0 = D(r0, s0_0_2, 0x12F204E0, 0xD80BFD2F, 0xD3FFFC34, 0x03F00500);
	r1 = D(r1, s0_0_2, 0xE3EA0223, 0x0F96212A, 0x961FDC5A, 0xA922FF68);
	r2 = D(r2, s0_0_2, 0x092D02D8, 0xFFF904FC, 0xF810F507, 0x4430F7AE);
	r0 = D(r0, s0_1_0, 0x1508DEE9, 0xF7F71F0E, 0x1D00D3DD, 0x0043DDEB);
	r1 = D(r1, s0_1_0, 0xF07BFE0E, 0xFCDAF70E, 0xEB053323, 0xC2DE023F);
	r2 = D(r2, s0_1_0, 0x0452C8E4, 0xFFF50506, 0xFE1E2EFF, 0xF803FF11);
	r0 = D(r0, s0_1_1, 0xF2052016, 0xF3DDD905, 0x8BF7F34E, 0x81F33C2E);
	r1 = D(r1, s0_1_1, 0x3638D6CD, 0xFDD3E21B, 0x5709D0C5, 0x7FDECA9A);
	r2 = D(r2, s0_1_1, 0x26FB32E5, 0x092FFDF5, 0xF4FEE7FE, 0xA00EE652);
	r0 = D(r0, s0_1_2, 0x1303F8DD, 0x04F104F8, 0x0D09FBDE, 0x1510E0DB);
	r1 = D(r1, s0_1_2, 0x320DE8DD, 0x037F11E6, 0x19D403DC, 0xEFB91221);
	r2 = D(r2, s0_1_2, 0x13E5ED0B, 0xEDF3030D, 0xEB09F10E, 0x86ED226B);
	r0 = D(r0, s0_2_0, 0x0600EEF7, 0xF70FFB0C, 0x04E1FEFA, 0xFE054AFE);
	r1 = D(r1, s0_2_0, 0xFDE7DBFB, 0x180BEBE7, 0xDFE6FE27, 0xF301D118);
	r2 = D(r2, s0_2_0, 0xE1232F31, 0x010907FD, 0xF6061B10, 0x3A0219C7);
	r0 = D(r0, s0_2_1, 0x01FE0407, 0x14131EE1, 0xF5F2F416, 0xD121933C);
	r1 = D(r1, s0_2_1, 0xFA023413, 0xEB3F030C, 0x2E02EDC7, 0x42FFE6AF);
	r2 = D(r2, s0_2_1, 0xF917EA07, 0x05F0FFFE, 0x11FC1DE4, 0x0D03EDEB);
	r0 = D(r0, s0_2_2, 0x090208F0, 0x02FA0705, 0x1F240CD9, 0x0CEAFEF2);
	r1 = D(r1, s0_2_2, 0x10E0EAF0, 0x1AFB17F6, 0xEBE5FE1E, 0x07E4FBF8);
	r2 = D(r2, s0_2_2, 0x08CCE2F2, 0xFE060400, 0x01F00803, 0x01DC7FF0);
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

//!DESC CuNNy-4x12-BLUR-conv2
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
	r0 = D(r0, s0_0_0, 0xFE000703, 0x11011FE9, 0xEB000D00, 0x0E0D0907);
	r1 = D(r1, s0_0_0, 0x0D011BFA, 0x1004FCFB, 0xFE01F700, 0x05F80AFC);
	r2 = D(r2, s0_0_0, 0x3722DD01, 0xFF0BF604, 0x12E5F0FD, 0x0411E402);
	r0 = D(r0, s0_0_1, 0x03FF04FC, 0x10F400F9, 0x0722ED04, 0xEB02F81A);
	r1 = D(r1, s0_0_1, 0x0304FDFF, 0x01060105, 0xF8FB0402, 0x0109F808);
	r2 = D(r2, s0_0_1, 0x163AC7F9, 0xF30F0300, 0x03E0F703, 0xFAFFFC00);
	r0 = D(r0, s0_0_2, 0x0501FE00, 0x0E1F0203, 0x0603FC07, 0xE8FE0C0E);
	r1 = D(r1, s0_0_2, 0xFEFD02FE, 0xF7FF0701, 0x00030200, 0x090EFBFC);
	r2 = D(r2, s0_0_2, 0x2808F3F6, 0xF1FC0203, 0x0507FCFF, 0xFFF80306);
	r0 = D(r0, s0_1_0, 0xFB01FD0C, 0x09C4DDE8, 0x0207F215, 0x010209F8);
	r1 = D(r1, s0_1_0, 0x0EFB540B, 0x4EF5D6DE, 0xFE03F8F7, 0xFBFB1A0E);
	r2 = D(r2, s0_1_0, 0x53FB2DE8, 0x0CF614F5, 0x1EEE1EED, 0xFEF903ED);
	r0 = D(r0, s0_1_1, 0xF70FF9F8, 0xB99AEE13, 0xE0CEF305, 0xDB2FF7F4);
	r1 = D(r1, s0_1_1, 0xFF0300E3, 0x051D1509, 0xE9FC010E, 0xB5F081A1);
	r2 = D(r2, s0_1_1, 0x818115D6, 0xD5CC22F2, 0xD3B52933, 0xB9F103F1);
	r0 = D(r0, s0_1_2, 0x0406FCF9, 0x030EFEFC, 0xE5110F0C, 0xF4020D01);
	r1 = D(r1, s0_1_2, 0x03040101, 0x0C02FDFD, 0x01110405, 0x0504F8E0);
	r2 = D(r2, s0_1_2, 0x4D63F1E5, 0xFEE8F503, 0xFAF5FBF3, 0xEEF916FD);
	r0 = D(r0, s0_2_0, 0x0407EF1A, 0x18EEF906, 0x08F7F606, 0xEBFA13F3);
	r1 = D(r1, s0_2_0, 0x0E04FDFC, 0x21FBFEB8, 0xFCFE0408, 0x10F40712);
	r2 = D(r2, s0_2_0, 0xE92FC205, 0x0203F505, 0xFE0BFAF3, 0xFEFD14E7);
	r0 = D(r0, s0_2_1, 0xEC0706F6, 0x08EB030C, 0xF2EA03EF, 0x07FA0BFC);
	r1 = D(r1, s0_2_1, 0x040BFCFA, 0x1510F2DF, 0xFCEC025E, 0xF1251FFD);
	r2 = D(r2, s0_2_1, 0x690DB737, 0xDFF5FAE7, 0x0FF4EA22, 0x0411020F);
	r0 = D(r0, s0_2_2, 0xF80202FE, 0x0517FE01, 0x050CF821, 0xEF0009FA);
	r1 = D(r1, s0_2_2, 0x010400FD, 0xF4FF05F2, 0xF6050511, 0x0E070114);
	r2 = D(r2, s0_2_2, 0xF644FEBD, 0x00F1FFFE, 0x0DE20506, 0xF80007FD);
	r0 = D(r0, s1_0_0, 0xFDFCFCFF, 0x0BFB16EA, 0xF502FDFF, 0x0AFE0D15);
	r1 = D(r1, s1_0_0, 0x00FA02FE, 0x03FB0E07, 0xFFF809FD, 0x0E02F4FF);
	r2 = D(r2, s1_0_0, 0x0918F2E2, 0xFAF7E902, 0xFD1A07F8, 0x06F907FD);
	r0 = D(r0, s1_0_1, 0x0007FF01, 0x0712FCFD, 0xEE010404, 0x07FF0807);
	r1 = D(r1, s1_0_1, 0xFC0405FF, 0xFE0C0208, 0x00FBFFFE, 0x11FEF10A);
	r2 = D(r2, s1_0_1, 0x01BBF816, 0xFCDFFA23, 0x0233FDDF, 0xFDE0FC03);
	r0 = D(r0, s1_0_2, 0x000BFBFA, 0x0DF111F8, 0xE210FE07, 0xF8FB0E0E);
	r1 = D(r1, s1_0_2, 0x01FCFCFB, 0x070802FC, 0x02F70202, 0x03110E00);
	r2 = D(r2, s1_0_2, 0xDE0A28F9, 0x09EEF5F0, 0xF612F90C, 0xF3EF0611);
	r0 = D(r0, s1_1_0, 0x0004FB00, 0x161E03DA, 0x0607FCEF, 0xF9FFF002);
	r1 = D(r1, s1_1_0, 0xF9FFF302, 0xEBFD0E04, 0x05FC08F1, 0xFB10F70D);
	r2 = D(r2, s1_1_0, 0xF0C543F2, 0xFA01F20B, 0xE700040F, 0x000AED00);
	r0 = D(r0, s1_1_1, 0x1A14FE07, 0xE9011E04, 0x00320BF9, 0x03E8F000);
	r1 = D(r1, s1_1_1, 0x0CF5FC00, 0x3CDA010D, 0xEFFE0705, 0x0A16F322);
	r2 = D(r2, s1_1_1, 0x27FE4093, 0x2D1101F1, 0x17F10CDA, 0x00EFFDF3);
	r0 = D(r0, s1_1_2, 0x0003FDFF, 0xF7101CFF, 0xF3FBECFC, 0xF8EBF710);
	r1 = D(r1, s1_1_2, 0xFDF70508, 0x00050A15, 0xFEFE050C, 0xEFF7EF0E);
	r2 = D(r2, s1_1_2, 0xD3E424E3, 0xF90A0AF2, 0xFE1B05F3, 0xFCF40106);
	r0 = D(r0, s1_2_0, 0xFF07F9FC, 0x11150FFC, 0xFB0A2702, 0x0509DF04);
	r1 = D(r1, s1_2_0, 0x0601FCF4, 0x05131C07, 0xFFFE00F0, 0xF71109FF);
	r2 = D(r2, s1_2_0, 0x2CEF4ED4, 0x05FF0FFF, 0xD9FCF7ED, 0xF0FFEC07);
	r0 = D(r0, s1_2_1, 0x03FC0200, 0x28FF0400, 0x0D0E0BFC, 0xFE07BA19);
	r1 = D(r1, s1_2_1, 0xF90EFCFE, 0x1124FBFF, 0xFB0406FF, 0xEDDF2607);
	r2 = D(r2, s1_2_1, 0x81B72BD8, 0x04E515EF, 0xFE0F171B, 0xFEFCF207);
	r0 = D(r0, s1_2_2, 0xFD04FAFF, 0x06DA10E7, 0x1A0C09FF, 0xF2F7040D);
	r1 = D(r1, s1_2_2, 0x0601F9FF, 0x1006F2FA, 0x010101FC, 0xF00FECFB);
	r2 = D(r2, s1_2_2, 0xDB1D06EB, 0x1AF005FD, 0x14190FF5, 0xF8091603);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFFFDF706, 0x3CF5B10A, 0x020208F3, 0x12140BFB);
	r1 = D(r1, s0_0_0, 0x06FEEA00, 0x1109FD06, 0x02040CFD, 0x1AFBF60C);
	r2 = D(r2, s0_0_0, 0x1D09F42B, 0x11030913, 0xF0FA04FA, 0x040A2407);
	r0 = D(r0, s0_0_1, 0xFCFEF308, 0x3E0FF805, 0xEE0AF9F0, 0x000725E7);
	r1 = D(r1, s0_0_1, 0x05020400, 0x07FCFBFD, 0x03FE03FF, 0x12FCCE1A);
	r2 = D(r2, s0_0_1, 0x98FFEB15, 0x080402E8, 0x06F60009, 0xFB060B02);
	r0 = D(r0, s0_0_2, 0x010000FF, 0xFCFB0206, 0xE0F80BF5, 0xF70A04F5);
	r1 = D(r1, s0_0_2, 0xFC00FE03, 0x03060004, 0x01010100, 0xFDFCF014);
	r2 = D(r2, s0_0_2, 0x02F9F41A, 0x15FFFBFA, 0x070E0408, 0xEB0505FA);
	r0 = D(r0, s0_1_0, 0xF3F44A05, 0x20D62C0D, 0xDFF819FA, 0x1B09DDF7);
	r1 = D(r1, s0_1_0, 0x09E58103, 0x22F68104, 0xEF100705, 0x05F1811B);
	r2 = D(r2, s0_1_0, 0xC514AC0D, 0x0316F7F5, 0xE11DFBF1, 0x0B1C900A);
	r0 = D(r0, s0_1_1, 0xF6D4FBFF, 0x131D23D9, 0xEE1C13DE, 0x1AEDE703);
	r1 = D(r1, s0_1_1, 0x04150D00, 0x05C50006, 0xFA171EF3, 0x1FEA1338);
	r2 = D(r2, s0_1_1, 0x0D090F0E, 0xBBFAECDE, 0xF4BDE7E9, 0xF6470118);
	r0 = D(r0, s0_1_2, 0x03FD0203, 0xD91EFEFC, 0xD7F303FA, 0xF4E7FE0D);
	r1 = D(r1, s0_1_2, 0x02000104, 0x0DFE05F6, 0xFBFD0200, 0x1E09000B);
	r2 = D(r2, s0_1_2, 0xCEF7FA26, 0x1E150403, 0x170601FC, 0xF00C0103);
	r0 = D(r0, s0_2_0, 0x09090A02, 0x000CF307, 0xF407F401, 0x12FC02F9);
	r1 = D(r1, s0_2_0, 0x05E50801, 0x06F1EAFD, 0xFF0AFE06, 0xF7F00306);
	r2 = D(r2, s0_2_0, 0xADC5E428, 0x10FF04FE, 0xD0E50009, 0xF9EFF202);
	r0 = D(r0, s0_2_1, 0x042302FC, 0xE6F60BF9, 0xFA1DF9FD, 0x15E2FAFB);
	r1 = D(r1, s0_2_1, 0x010C08FF, 0x09F8F803, 0x08FFFDF9, 0x06F5CB1D);
	r2 = D(r2, s0_2_1, 0xE5E0F50C, 0x262AF911, 0xC6E20DED, 0x0FC4F208);
	r0 = D(r0, s0_2_2, 0x0303FFFD, 0x0FFEF610, 0xE7ED00FD, 0x02F4FBF7);
	r1 = D(r1, s0_2_2, 0x03FF00FC, 0xFA070000, 0xF8FCFF00, 0x0AC5EF18);
	r2 = D(r2, s0_2_2, 0x2A2BF816, 0x06FD01F9, 0xF10E06F6, 0x0009FBFC);
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

//!DESC CuNNy-4x12-BLUR-conv3
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
	r0 = D(r0, s0_0_0, 0x07F6FD05, 0x03090A00, 0x07F5FFFE, 0x11110807);
	r1 = D(r1, s0_0_0, 0x050BFDFE, 0x06DA06F8, 0xFFFAFEFF, 0x06010803);
	r2 = D(r2, s0_0_0, 0xFF0AFA09, 0x04FE0204, 0x04FE010A, 0xFB090100);
	r0 = D(r0, s0_0_1, 0x04F7F707, 0xF717FBF6, 0x05010B01, 0xEDEE01FF);
	r1 = D(r1, s0_0_1, 0x06FCFC0C, 0xEDDF1408, 0x04FA0317, 0x030407FD);
	r2 = D(r2, s0_0_1, 0xFAFF1221, 0xFB060CF9, 0xEFFB0F0C, 0x00FBFEEF);
	r0 = D(r0, s0_0_2, 0x05060000, 0x06F50604, 0xFCFB010B, 0x010621C7);
	r1 = D(r1, s0_0_2, 0x01F8FDFC, 0x05DA0E07, 0x00000B07, 0xFE05FF00);
	r2 = D(r2, s0_0_2, 0xF20C04E3, 0x01FE0B0B, 0xFA03FE04, 0xF7FC0108);
	r0 = D(r0, s0_1_0, 0x02F000FB, 0x02022D00, 0x0111F8FF, 0x04130C07);
	r1 = D(r1, s0_1_0, 0x0817FB04, 0x041301FE, 0xF9FBFDF7, 0x05EE080A);
	r2 = D(r2, s0_1_0, 0xFE03FFF9, 0xFBFDFE00, 0x020E11FD, 0xF90A0D01);
	r0 = D(r0, s0_1_1, 0x2214F359, 0xEEF5F7A7, 0x0524FA21, 0x19E803FD);
	r1 = D(r1, s0_1_1, 0x04ECEACD, 0xE9F604D7, 0xFDF50B0D, 0x03E42712);
	r2 = D(r2, s0_1_1, 0x053E25FB, 0x070F12C2, 0xEC3220C5, 0xF21902D1);
	r0 = D(r0, s0_1_2, 0xF9F1EF00, 0x06FBFA0E, 0xFD1503E4, 0xEDEB19DC);
	r1 = D(r1, s0_1_2, 0xFE09F214, 0xFEE00306, 0x010D0809, 0xE8D20D11);
	r2 = D(r2, s0_1_2, 0xEC00EA23, 0xFCF60607, 0xE9F62DE8, 0xFB031005);
	r0 = D(r0, s0_2_0, 0x1607FA06, 0x0408151D, 0x0C14F805, 0xFCEA2A04);
	r1 = D(r1, s0_2_0, 0xFFFDFF00, 0xFDFE06FF, 0xFC04FB02, 0xF7FD02FF);
	r2 = D(r2, s0_2_0, 0xF909F806, 0x0A02F80B, 0xFAFBFF0A, 0xEDFB0E00);
	r0 = D(r0, s0_2_1, 0x0BFDF600, 0x06F4FD09, 0xF3F9EFF0, 0x10F12115);
	r1 = D(r1, s0_2_1, 0x0D17FF08, 0xFF000F08, 0xDDFA01FA, 0xE2EA1804);
	r2 = D(r2, s0_2_1, 0xF50C0CF3, 0x0B050003, 0xFF150905, 0xDA1006F3);
	r0 = D(r0, s0_2_2, 0x03FC06F6, 0x03F6FB05, 0xF9010AEE, 0x04FF1407);
	r1 = D(r1, s0_2_2, 0xFC04DF0B, 0xFBE6F208, 0xFDFB0507, 0xFFE50806);
	r2 = D(r2, s0_2_2, 0xEF0AF7FB, 0x0F0206FD, 0x03030CF9, 0xF4FA03FA);
	r0 = D(r0, s1_0_0, 0x0AFAF2F9, 0x0D130007, 0x03F1FFF8, 0xE5EE02FA);
	r1 = D(r1, s1_0_0, 0x04FAF701, 0xFF0EF405, 0x0600FA06, 0x0400F6FD);
	r2 = D(r2, s1_0_0, 0xEDF00F00, 0x06F90602, 0x0EF207FC, 0x0706FC01);
	r0 = D(r0, s1_0_1, 0xF9130103, 0x01F6FE03, 0xFC0406F2, 0xE50B1DC0);
	r1 = D(r1, s1_0_1, 0x03F1F308, 0xFDE821CF, 0x0811FF0A, 0x0F0F1108);
	r2 = D(r2, s1_0_1, 0xEA0C04FA, 0x0FDCFCFE, 0x1ECEF2E6, 0x03020701);
	r0 = D(r0, s1_0_2, 0x050B0F03, 0x02FEFBF7, 0x0FD90509, 0x010814F1);
	r1 = D(r1, s1_0_2, 0xF9FBFBFE, 0xFD060DFF, 0x07EBFEFD, 0x000CFAFD);
	r2 = D(r2, s1_0_2, 0x00041B18, 0x02F5FC07, 0x01180CFB, 0xFEFB0701);
	r0 = D(r0, s1_1_0, 0x0ADCFBF8, 0xF41EFD09, 0xFDF1F9FF, 0xF0EF1100);
	r1 = D(r1, s1_1_0, 0x1813FAF8, 0xF71309FF, 0xFBF8F5FE, 0x0BFC07FA);
	r2 = D(r2, s1_1_0, 0x07FE0407, 0x19F9FB00, 0x0CF7FCFA, 0x0316F803);
	r0 = D(r0, s1_1_1, 0xB8DF1FBF, 0xEF9A4CFA, 0xDBE733C5, 0x37A03C81);
	r1 = D(r1, s1_1_1, 0x012FEE3C, 0xCB27F53D, 0xCC1DF83C, 0xDD4FF3F1);
	r2 = D(r2, s1_1_1, 0xF0E9D801, 0x2903F116, 0x0BFFDEFD, 0xF131140F);
	r0 = D(r0, s1_1_2, 0xFE061F0E, 0x09F9FBF5, 0x0101270D, 0xFC0A0FED);
	r1 = D(r1, s1_1_2, 0xFE0F1AF7, 0x02FBFBEC, 0xF7EFED07, 0xEBE1F407);
	r2 = D(r2, s1_1_2, 0xDFFCCBF9, 0x15FCFED4, 0x07051F29, 0xFCFCF319);
	r0 = D(r0, s1_2_0, 0x07FAF900, 0x07E80006, 0x02000802, 0xED01F713);
	r1 = D(r1, s1_2_0, 0x10FFF9FF, 0xFA02F6FA, 0x0805FE09, 0xF5000302);
	r2 = D(r2, s1_2_0, 0x020302FF, 0x0CF508FE, 0x05F609F9, 0xFFFF0100);
	r0 = D(r0, s1_2_1, 0x05FF010C, 0x020A2DD6, 0xEE05F409, 0x070A0016);
	r1 = D(r1, s1_2_1, 0x0705F6F3, 0x0CFF05FB, 0x07010009, 0xFAF906FF);
	r2 = D(r2, s1_2_1, 0xFB010208, 0x19F901FE, 0x0AF906FC, 0xF500FEF0);
	r0 = D(r0, s1_2_2, 0xFE060109, 0xF8FE01FD, 0x03FD0AF7, 0x0AF308FB);
	r1 = D(r1, s1_2_2, 0xFB0CFA05, 0x00060DF9, 0x02FD0007, 0x080D14EF);
	r2 = D(r2, s1_2_2, 0xF7FEE9FC, 0x18FC03F5, 0x100002F8, 0x01FEF8FA);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFDFD12FA, 0xFEF00100, 0x0612F103, 0x1124C707);
	r1 = D(r1, s0_0_0, 0x02FFFAF4, 0x0ADF2C01, 0x03FEFB04, 0x01FD01F9);
	r2 = D(r2, s0_0_0, 0x1017EDF2, 0x0702F507, 0x0F11F508, 0x01FA01F8);
	r0 = D(r0, s0_0_1, 0xFCF80FF7, 0x03F3FC04, 0x0816F800, 0xED19F117);
	r1 = D(r1, s0_0_1, 0xFE03FBF2, 0xFEDF0A0F, 0xFEFB0FF8, 0xF9F018F2);
	r2 = D(r2, s0_0_1, 0xF7F7E2E9, 0x0AFAED08, 0x0F03D40A, 0x0312F803);
	r0 = D(r0, s0_0_2, 0x00F802F8, 0xFD05010D, 0x0E18EE04, 0x09F704F8);
	r1 = D(r1, s0_0_2, 0x030E0602, 0xF1F40B05, 0x0513FD06, 0xFBF41BF4);
	r2 = D(r2, s0_0_2, 0x07F6FDF4, 0x0405FB09, 0x08FEEE03, 0x03FCFEF7);
	r0 = D(r0, s0_1_0, 0xF30410F2, 0x0CEE3DF2, 0x0A18E900, 0xDBF1B005);
	r1 = D(r1, s0_1_0, 0x00F300EF, 0xE5D91010, 0xF7F1FD0F, 0x04121DF6);
	r2 = D(r2, s0_1_0, 0x1F1907E7, 0x0BF2FA0F, 0x18021B12, 0xFE07F7F9);
	r0 = D(r0, s0_1_1, 0xD4200404, 0x0B01080B, 0x1349D004, 0xB4D8D0F0);
	r1 = D(r1, s0_1_1, 0x02EBF3E1, 0xFCE21305, 0x01481E12, 0xD700D8E9);
	r2 = D(r2, s0_1_1, 0xF5E200F3, 0x21FEF018, 0x15FCEA1D, 0x09123E0A);
	r0 = D(r0, s0_1_2, 0x09F8F9F6, 0xFC08FF04, 0x1DFFDDFA, 0xF20C1A04);
	r1 = D(r1, s0_1_2, 0x07FA16EB, 0xFCF02310, 0x0C11EC02, 0xFD0912F2);
	r2 = D(r2, s0_1_2, 0xF60109F0, 0x0309EC0F, 0x09F7F70A, 0x0A01F4F2);
	r0 = D(r0, s0_2_0, 0x040C03F4, 0x14E905F8, 0x040EFF04, 0x0704F800);
	r1 = D(r1, s0_2_0, 0xF2FBFEFA, 0xF3DCFA09, 0xFDFDFE00, 0xF9FB1AFE);
	r2 = D(r2, s0_2_0, 0xFE0AF0F9, 0x09FFF807, 0x0410FD0E, 0x110211FC);
	r0 = D(r0, s0_2_1, 0xF300FCF4, 0x06FB160F, 0x110DFFFE, 0xC0120805);
	r1 = D(r1, s0_2_1, 0xF5EE20F3, 0xFACE1F0D, 0x01F90504, 0xF0C113FD);
	r2 = D(r2, s0_2_1, 0x1E18E8F3, 0xEEF9FF12, 0x07EF0613, 0x1CF70802);
	r0 = D(r0, s0_2_2, 0x03FFFBF1, 0x0306F60A, 0x00FCF002, 0xF812EE02);
	r1 = D(r1, s0_2_2, 0xFEFE10F6, 0xEEE41105, 0xFE00F6FE, 0xF9E405F2);
	r2 = D(r2, s0_2_2, 0x0815F1F8, 0xF8010409, 0xFBF7060C, 0x0700FDFC);
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

//!DESC CuNNy-4x12-BLUR-conv4
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
	r0 = D(r0, s0_0_0, 0xFC00FD02, 0xFCFA03F9, 0xFF0D0418, 0xFEF4FB00);
	r1 = D(r1, s0_0_0, 0x02EFFC02, 0x12040405, 0x01FFFEFE, 0x01FBFE00);
	r2 = D(r2, s0_0_0, 0xFF080607, 0xEE22FF01, 0x22DD0103, 0xFB000000);
	r0 = D(r0, s0_0_1, 0xF310F417, 0xF10501F5, 0x0301ED09, 0xF807EC03);
	r1 = D(r1, s0_0_1, 0x02E7EDD2, 0xEDEEF7FE, 0xFD020103, 0x0301FA00);
	r2 = D(r2, s0_0_1, 0xFE04FBFA, 0xE6FBF01A, 0xEAFFE2F4, 0xED06DBFA);
	r0 = D(r0, s0_0_2, 0xF8FEF3FB, 0x07FFF0FD, 0x0301F205, 0x09F6E00E);
	r1 = D(r1, s0_0_2, 0x020CF0EE, 0xCCEBFAF1, 0x0201ED01, 0xFEFFF9FC);
	r2 = D(r2, s0_0_2, 0x0304D7FF, 0xF503E9F9, 0xFFF5E105, 0x0201FFFD);
	r0 = D(r0, s0_1_0, 0xF90302FE, 0xFF07F9F9, 0xF7EB02F1, 0xFD0610EA);
	r1 = D(r1, s0_1_0, 0x0C00F8FA, 0x04F4FF06, 0x000700FF, 0xFE01F800);
	r2 = D(r2, s0_1_0, 0x04180104, 0xFDF90114, 0xE7E2F8F7, 0xF814FF0E);
	r0 = D(r0, s0_1_1, 0xEBFF08E5, 0xD509E5E2, 0xDAFB0EF6, 0xEEF7F1EF);
	r1 = D(r1, s0_1_1, 0xF022E9DD, 0xEDEFF4F9, 0xEFE905EE, 0xFDEFE2E5);
	r2 = D(r2, s0_1_1, 0xC6D6EED7, 0xD6CBE8F6, 0xCCEBE60D, 0xE1D8EEF7);
	r0 = D(r0, s0_1_2, 0xF50A0002, 0x06F5C210, 0xFC0002EF, 0x10FADB0F);
	r1 = D(r1, s0_1_2, 0xD3EBD7E5, 0xCCDB0702, 0xFF02E618, 0xFA03EAFD);
	r2 = D(r2, s0_1_2, 0xEE00F3F7, 0xE3FC0CFC, 0xFDFD0D07, 0x000200FC);
	r0 = D(r0, s0_2_0, 0xFE02FDFD, 0xFDF30003, 0x0217FFEF, 0xF9FD0000);
	r1 = D(r1, s0_2_0, 0x0CFF000D, 0x08FE00FF, 0x04F80202, 0x04F8FD03);
	r2 = D(r2, s0_2_0, 0xF9F20311, 0x000001FA, 0x0203FA04, 0xFDFB0002);
	r0 = D(r0, s0_2_1, 0xF703FEFE, 0x01DFFC23, 0xDE2006D0, 0xF6FB00F6);
	r1 = D(r1, s0_2_1, 0x11EFFE15, 0x01F401FD, 0xF01201EE, 0xFD0A040E);
	r2 = D(r2, s0_2_1, 0x0100FC0F, 0xFEF3FFF8, 0x0202010B, 0x0908FFFE);
	r0 = D(r0, s0_2_2, 0xF5000100, 0x0C06FF0C, 0xF1040004, 0x04FAFD0E);
	r1 = D(r1, s0_2_2, 0x0DFCFD1A, 0x02FBFB05, 0xFAF2EE19, 0x00FC01FD);
	r2 = D(r2, s0_2_2, 0x02FFFD07, 0xF9F100FB, 0x0E0500FD, 0x0002FEFE);
	r0 = D(r0, s1_0_0, 0xFFFCFCF7, 0x040001FE, 0x0EF601E9, 0xFA01FD04);
	r1 = D(r1, s1_0_0, 0xFD00020B, 0x13FB09F8, 0x02FE01FF, 0x070203FE);
	r2 = D(r2, s1_0_0, 0x060204F7, 0xF5FDFD03, 0xFFFB05E7, 0xF309EDFA);
	r0 = D(r0, s1_0_1, 0x1AF2F1D9, 0xF9010612, 0x11F7E5EA, 0x0C0D01F4);
	r1 = D(r1, s1_0_1, 0xDAEB040B, 0xF727EBFB, 0x0006FEF8, 0x0204FDFB);
	r2 = D(r2, s1_0_1, 0xF106FD02, 0x1A10FAEC, 0xFEF3071A, 0x070308F8);
	r0 = D(r0, s1_0_2, 0xFFECFDF2, 0x08FAF603, 0x02FAFBFB, 0xFC0AFA01);
	r1 = D(r1, s1_0_2, 0xF5F31D00, 0x07FA0B07, 0x060002F8, 0xFF04FFFD);
	r2 = D(r2, s1_0_2, 0x05050102, 0xFFFC0D04, 0x030E0FEC, 0x0501FAFD);
	r0 = D(r0, s1_1_0, 0xFFFBFEFC, 0x02020608, 0xFBF9E4F9, 0xE2FAFE03);
	r1 = D(r1, s1_1_0, 0x0CFE0000, 0x060CF9F6, 0xFDFEFAF8, 0xEFFDF703);
	r2 = D(r2, s1_1_0, 0x0FF1D7F1, 0xFF03FD08, 0xFCFD0917, 0xF8FA03E9);
	r0 = D(r0, s1_1_1, 0xFE040E07, 0x4E28FEC8, 0xED1522E7, 0x3A08E8E3);
	r1 = D(r1, s1_1_1, 0x3319EAEB, 0x022C1FFB, 0xED12FE08, 0x0FE20A04);
	r2 = D(r2, s1_1_1, 0xEC5011DB, 0xE11E2AC7, 0x161CE7DA, 0x0C33EF11);
	r0 = D(r0, s1_1_2, 0x0803EE01, 0xEBEEEEFA, 0x00F9FF00, 0xF20C0000);
	r1 = D(r1, s1_1_2, 0x0CFAD9FC, 0x07E4E502, 0x0F0DEAE6, 0x04EA02FA);
	r2 = D(r2, s1_1_2, 0x09EDEF0A, 0x0CF6F30B, 0x00FD01FD, 0xFDF406F8);
	r0 = D(r0, s1_2_0, 0x0500FF01, 0x0906EF00, 0x13FB0A04, 0xFBF518FF);
	r1 = D(r1, s1_2_0, 0xFDFBF808, 0xFF01FFFC, 0x02FBF6F7, 0x07F5FDFE);
	r2 = D(r2, s1_2_0, 0x04FFE4FE, 0x080106FD, 0x06FC0EF8, 0x00FF04F9);
	r0 = D(r0, s1_2_1, 0x00FFFB01, 0xF0FEF600, 0x16F9D00B, 0x110BDF01);
	r1 = D(r1, s1_2_1, 0xF1FAF9F6, 0x0002FC01, 0x060316FB, 0xF410FCF1);
	r2 = D(r2, s1_2_1, 0xF90E18F7, 0x1004F408, 0x07EF0BF8, 0x0204F401);
	r0 = D(r0, s1_2_2, 0x01FB03FE, 0xEC0016FD, 0x08FDEBFF, 0xFF040AFF);
	r1 = D(r1, s1_2_2, 0xFA0008FE, 0xFDFB06FF, 0x0A0FEE01, 0x0106FC05);
	r2 = D(r2, s1_2_2, 0x060AE40E, 0x03050403, 0x0104FE07, 0xFEFE02FF);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0BF3000A, 0x09F90102, 0x0AF8FC01, 0x02050101);
	r1 = D(r1, s0_0_0, 0x0803000A, 0xEFEDFB16, 0x0101FE01, 0xFCFD0304);
	r2 = D(r2, s0_0_0, 0xFD00FCFD, 0xF203F60A, 0x00F212F7, 0x1102FBFE);
	r0 = D(r0, s0_0_1, 0x22E9FD09, 0x0107F107, 0x1AF90DF4, 0xF501FD05);
	r1 = D(r1, s0_0_1, 0xFCF21A06, 0x22F3B2ED, 0x01FD0206, 0xF1FB0C05);
	r2 = D(r2, s0_0_1, 0x09F8FD06, 0xE9E7E6D6, 0x100D080C, 0xF9EC0B0C);
	r0 = D(r0, s0_0_2, 0x1FEDF8FB, 0x07030105, 0x13FE00FD, 0xFBF9F402);
	r1 = D(r1, s0_0_2, 0xFEFB0702, 0xF5091307, 0xFBFEFEFE, 0xFB020101);
	r2 = D(r2, s0_0_2, 0xFDFF0302, 0x0602FA00, 0x0103FEFA, 0xFD02FDFF);
	r0 = D(r0, s0_1_0, 0x03FE04ED, 0x0005F4FC, 0x140BF405, 0x02F503F7);
	r1 = D(r1, s0_1_0, 0x06FFF604, 0x000A0007, 0xFAFB0C03, 0x15FB04FB);
	r2 = D(r2, s0_1_0, 0xF609F00A, 0xFC20E605, 0x1329F7CB, 0x13DF0AF0);
	r0 = D(r0, s0_1_1, 0x0E0806E6, 0x190C350C, 0x20178629, 0xF90CD24B);
	r1 = D(r1, s0_1_1, 0x1F0CADFD, 0xF1FA1206, 0x1303F917, 0x2FF20DF6);
	r2 = D(r2, s0_1_1, 0x00F6C8DE, 0x31012B34, 0xE1F3CF06, 0xDC08040F);
	r0 = D(r0, s0_1_2, 0xFBFF0512, 0x0EF6E8EC, 0x0208F20A, 0xF9040AE8);
	r1 = D(r1, s0_1_2, 0x1B00FEFB, 0xFBFC1B06, 0xFBF3FFFF, 0x13F906FE);
	r2 = D(r2, s0_1_2, 0x05F90F08, 0xFDFFFDFF, 0x10FC00F6, 0x0FFB04FD);
	r0 = D(r0, s0_2_0, 0x00F5FF02, 0xFD07FCFF, 0xFADD1300, 0x02F40C0B);
	r1 = D(r1, s0_2_0, 0xFBF90203, 0x00F8FB06, 0x02F60408, 0x02EA0305);
	r2 = D(r2, s0_2_0, 0x04FD01FF, 0x07F10204, 0xFDEC1300, 0x01F501FF);
	r0 = D(r0, s0_2_1, 0xF4030807, 0xF9CA040D, 0xECF118CF, 0xF904FAFD);
	r1 = D(r1, s0_2_1, 0x09F80409, 0x0004F307, 0x06FDFDDF, 0xFDFF0210);
	r2 = D(r2, s0_2_1, 0xFCDFE7F5, 0x03EEFD06, 0x05F9FD12, 0xFB0603FF);
	r0 = D(r0, s0_2_2, 0x00F904FF, 0x09F4FEF9, 0x03F60B00, 0x00F8FB01);
	r1 = D(r1, s0_2_2, 0x0A010004, 0x01FDFF05, 0xF7F60818, 0x02F8FA02);
	r2 = D(r2, s0_2_2, 0x06050902, 0x01FF0609, 0x04FFF904, 0x06FCFD01);
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

//!DESC CuNNy-4x12-BLUR-out-shuffle
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
	r0 += M4(1.857e-03, -1.084e-02, -1.128e-03, -1.048e-03, 3.456e-02, -1.323e-03, -5.876e-04, 2.452e-05, -3.023e-02, -3.360e-03, -2.801e-03, 6.810e-04, 2.111e-02, 2.281e-03, 2.813e-03, -9.852e-04) * s0_0_0;
	r0 += M4(-1.077e-03, 2.302e-02, 1.649e-03, 1.213e-03, 7.830e-02, 1.110e-01, 2.572e-04, -3.332e-03, -1.013e-01, -7.439e-02, 8.910e-03, 5.834e-04, -8.940e-02, 4.050e-02, 1.746e-02, 5.747e-04) * s0_0_1;
	r0 += M4(5.728e-05, -1.269e-02, -4.551e-05, -8.679e-05, 7.520e-04, -2.593e-03, -1.258e-03, -2.340e-03, -5.927e-03, -5.204e-02, -5.742e-04, 2.549e-04, 4.322e-03, -4.192e-02, 1.262e-04, -3.773e-03) * s0_0_2;
	r0 += M4(-1.226e-01, 3.886e-03, 2.421e-02, 3.964e-04, 9.929e-02, -4.735e-03, 1.011e-01, -6.055e-03, -1.164e-02, 6.087e-03, -5.016e-02, 1.469e-03, 8.574e-02, 1.164e-03, 9.644e-02, 3.808e-03) * s0_1_0;
	r0 += M4(-1.985e-01, -3.466e-01, -2.552e-02, -5.483e-03, 3.132e-03, 1.295e-01, 1.222e-01, 2.638e-01, 1.708e-01, 4.747e-02, -3.241e-01, -2.485e-01, -2.241e-01, 1.813e-01, -3.565e-01, 1.717e-01) * s0_1_1;
	r0 += M4(1.248e-03, 3.080e-02, 6.669e-03, 4.927e-03, 1.151e-04, -8.339e-03, -2.642e-03, 5.562e-03, 1.057e-03, 1.051e-01, 2.627e-03, -1.073e-01, -2.321e-03, -7.739e-02, 1.090e-02, -1.219e-01) * s0_1_2;
	r0 += M4(-4.039e-03, -3.002e-03, 1.103e-01, 3.189e-03, -5.136e-04, 2.088e-03, 1.630e-02, -5.751e-04, 2.377e-05, 1.401e-05, 5.135e-03, 5.879e-04, 7.931e-04, 4.353e-05, 2.851e-02, 6.021e-04) * s0_2_0;
	r0 += M4(8.362e-03, 1.145e-02, 1.377e-01, 2.472e-01, -6.326e-04, -6.435e-03, -1.719e-02, 3.247e-03, 3.035e-03, 3.550e-03, 9.795e-02, 4.162e-02, 5.324e-03, 2.740e-03, -1.017e-02, 5.778e-02) * s0_2_1;
	r0 += M4(-2.126e-03, -7.466e-03, 1.064e-03, 1.011e-02, -4.247e-04, -4.795e-04, -3.369e-04, -5.739e-03, 6.987e-04, 3.824e-05, 4.491e-04, 5.139e-02, 1.233e-04, -9.401e-03, -1.880e-03, -2.045e-02) * s0_2_2;
	r0 += M4(6.321e-02, 6.131e-03, -5.174e-04, 3.060e-04, 2.527e-05, 2.834e-04, 8.107e-07, -1.638e-05, 4.980e-02, 3.847e-03, 5.898e-02, -1.982e-03, 9.259e-03, 2.299e-03, -4.011e-03, -4.721e-04) * s1_0_0;
	r0 += M4(2.968e-02, 9.058e-02, 2.047e-03, 2.426e-03, -1.674e-03, 7.327e-03, 1.507e-03, 1.185e-03, 4.633e-03, -3.272e-01, -1.630e-02, -5.728e-02, 2.549e-01, 1.586e-01, 2.915e-03, 9.855e-03) * s1_0_1;
	r0 += M4(4.679e-04, 6.214e-03, 1.446e-04, -2.747e-07, -1.798e-03, -5.729e-03, -5.434e-06, 7.987e-04, 2.318e-04, 1.760e-03, -1.093e-03, -4.858e-04, 2.463e-03, 9.216e-02, 3.393e-04, -7.640e-03) * s1_0_2;
	r0 += M4(-1.685e-01, 2.643e-03, 1.056e-01, 1.033e-02, -6.798e-02, 1.228e-03, 5.188e-03, -1.242e-03, 1.668e-01, -1.112e-02, 9.513e-02, 8.851e-03, 4.365e-03, 1.155e-02, 3.665e-03, 5.951e-03) * s1_1_0;
	r0 += M4(-1.919e-01, -3.684e-01, 6.563e-02, 1.340e-01, -4.464e-02, -1.958e-01, -4.256e-02, -6.788e-04, -1.848e-02, -6.828e-04, 1.584e-02, -3.412e-01, -6.962e-03, -3.277e-02, -2.998e-01, -2.487e-01) * s1_1_1;
	r0 += M4(1.632e-03, -6.555e-03, 1.158e-03, 1.012e-02, 4.804e-03, 6.737e-02, 5.651e-03, 1.840e-02, 1.760e-04, 1.592e-03, 3.160e-03, 3.742e-03, 5.498e-04, 1.875e-02, 3.042e-03, -6.363e-02) * s1_1_2;
	r0 += M4(-8.609e-04, -1.792e-03, -6.330e-02, -1.534e-02, -3.676e-02, 1.945e-03, -1.222e-01, 7.440e-03, 1.229e-03, 2.521e-03, 6.474e-02, -6.044e-03, 1.816e-04, -6.186e-05, -6.239e-03, 3.652e-05) * s1_2_0;
	r0 += M4(1.370e-03, 1.021e-02, -7.690e-02, -1.004e-01, -2.318e-02, -7.140e-02, 7.261e-04, -2.666e-01, 2.670e-03, -4.755e-03, -5.051e-03, 5.356e-02, 4.124e-04, 1.012e-03, 1.436e-02, 2.093e-04) * s1_2_1;
	r0 += M4(1.184e-03, -6.114e-04, 1.457e-03, -1.852e-02, 2.686e-03, -1.569e-03, 2.787e-04, 5.334e-02, -4.326e-04, -2.164e-03, -8.153e-04, -3.186e-03, 1.184e-04, 1.604e-04, -8.034e-03, -5.085e-04) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 += M4(-1.274e-02, -2.601e-03, -1.001e-02, 1.657e-03, -4.058e-03, 1.626e-04, 2.785e-04, 3.046e-05, -1.406e-03, 7.035e-07, 7.125e-08, -1.496e-07, -4.245e-03, -1.087e-03, -9.282e-04, -1.932e-04) * s0_0_0;
	r0 += M4(1.305e-01, 3.135e-02, -2.331e-03, 6.074e-03, -1.322e-02, -1.976e-02, -9.791e-03, -3.622e-03, 9.471e-03, -2.297e-03, 1.210e-03, -6.248e-05, 2.768e-02, -3.363e-03, -5.045e-03, 3.069e-03) * s0_0_1;
	r0 += M4(1.756e-03, 5.170e-02, -9.563e-04, -1.007e-03, -3.526e-03, 2.881e-03, 1.485e-03, 9.336e-04, 4.665e-03, 3.411e-04, -8.842e-04, 3.900e-04, -6.421e-03, 2.739e-02, 1.485e-04, 2.722e-03) * s0_0_2;
	r0 += M4(-1.381e-01, 1.341e-02, -8.817e-02, -1.053e-02, 3.832e-03, -5.877e-03, -6.320e-03, 8.584e-04, 2.728e-02, 3.383e-04, -5.090e-03, 8.213e-04, 7.750e-03, 4.620e-03, 1.157e-03, 4.465e-04) * s0_1_0;
	r0 += M4(2.180e-01, -2.588e-01, 3.370e-01, -1.255e-01, 2.513e-01, 1.662e-01, 9.529e-02, 1.934e-02, -2.791e-01, -2.910e-02, -3.082e-02, -1.775e-02, -3.564e-01, 2.918e-02, -9.399e-02, -7.932e-03) * s0_1_1;
	r0 += M4(7.530e-04, 6.958e-02, -2.178e-03, 1.195e-01, -6.794e-03, 8.789e-02, -8.275e-03, 5.070e-02, 9.097e-03, -1.695e-01, -8.153e-03, -3.907e-02, 3.279e-03, 1.675e-01, 1.001e-03, 1.184e-01) * s0_1_2;
	r0 += M4(1.036e-03, -8.574e-04, -4.684e-02, 4.445e-03, -1.985e-03, -2.844e-03, 3.709e-03, -1.988e-03, 3.375e-03, 7.673e-06, 5.378e-03, 2.150e-03, -1.908e-03, -1.637e-03, 3.546e-03, 6.199e-05) * s0_2_0;
	r0 += M4(-2.781e-03, 1.431e-02, 1.060e-02, -8.008e-02, -4.508e-03, -1.135e-03, 1.073e-01, 9.986e-02, 1.575e-03, -2.045e-02, -1.593e-01, -1.014e-01, -2.391e-02, -2.992e-02, -2.549e-01, 5.268e-03) * s0_2_1;
	r0 += M4(-1.913e-03, 4.224e-03, 9.614e-04, 8.426e-03, -9.075e-05, -3.446e-04, -9.384e-04, 3.151e-02, -8.667e-05, 5.600e-03, 4.897e-03, -6.615e-02, -1.686e-03, 4.531e-02, -1.379e-03, 1.167e-01) * s0_2_2;
	r0 += V4(4.499e-09, 3.659e-12, -1.009e-10, 2.486e-09);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
