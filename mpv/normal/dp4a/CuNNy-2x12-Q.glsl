// CuNNy 2x12 (dp4a)
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


//!DESC CuNNy-2x12-in
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
	r0 += V4(7.315e-03, 5.401e-03, 1.281e-01, -2.964e-02) * s0_0_0;
	r1 += V4(2.961e-01, 7.742e-01, 3.199e-02, 3.482e-02) * s0_0_0;
	r2 += V4(-5.165e-02, -3.623e-05, 3.405e-02, -4.994e-02) * s0_0_0;
	r0 += V4(-1.225e-02, 1.345e-02, 2.691e-01, 2.403e-02) * s0_0_1;
	r1 += V4(-3.072e-02, 2.129e-02, -6.025e-04, 4.915e-01) * s0_0_1;
	r2 += V4(-1.371e-01, -9.316e-01, -2.433e-02, -3.154e-01) * s0_0_1;
	r0 += V4(1.274e-02, 7.363e-01, 1.546e-01, 2.194e-01) * s0_0_2;
	r1 += V4(-2.294e-01, -3.471e-02, -4.476e-02, -9.545e-02) * s0_0_2;
	r2 += V4(-7.446e-02, -1.856e-02, -1.176e-02, 3.784e-01) * s0_0_2;
	r0 += V4(-1.900e-02, -1.322e-02, 6.366e-02, -1.492e-02) * s0_1_0;
	r1 += V4(-8.564e-02, -2.505e-02, 8.871e-01, 1.133e-02) * s0_1_0;
	r2 += V4(-1.902e-01, 9.372e-04, -2.995e-01, -7.672e-03) * s0_1_0;
	r0 += V4(-9.277e-01, -5.367e-04, -9.800e-01, -2.079e-01) * s0_1_1;
	r1 += V4(-7.655e-01, -7.871e-01, -8.963e-01, -2.243e-01) * s0_1_1;
	r2 += V4(7.676e-01, 9.365e-01, -5.675e-01, -5.030e-01) * s0_1_1;
	r0 += V4(9.365e-01, -7.240e-01, 2.313e-01, 2.630e-01) * s0_1_2;
	r1 += V4(3.098e-01, 5.136e-02, 1.776e-02, -6.428e-02) * s0_1_2;
	r2 += V4(2.588e-03, 1.187e-02, 3.163e-02, 4.720e-01) * s0_1_2;
	r0 += V4(-6.112e-04, 8.155e-03, 2.568e-01, 3.888e-02) * s0_2_0;
	r1 += V4(-1.350e-01, -1.682e-02, 4.016e-02, -1.248e-02) * s0_2_0;
	r2 += V4(-4.821e-02, -5.645e-04, 8.441e-01, 5.609e-02) * s0_2_0;
	r0 += V4(-1.057e-02, -1.157e-02, -1.183e-01, -1.610e-03) * s0_2_1;
	r1 += V4(2.927e-01, 3.797e-02, -1.084e-02, 2.228e-02) * s0_2_1;
	r2 += V4(1.094e-03, -5.460e-03, 2.365e-02, 6.995e-01) * s0_2_1;
	r0 += V4(8.942e-03, -1.605e-02, -5.720e-03, -1.519e-01) * s0_2_2;
	r1 += V4(3.369e-01, -1.632e-02, -2.436e-02, 3.102e-02) * s0_2_2;
	r2 += V4(-9.254e-02, 5.732e-03, -2.602e-02, -7.288e-01) * s0_2_2;
	r0 += V4(3.272e-03, 7.733e-04, 5.477e-03, 8.162e-03);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(6.159e-03, 2.032e-03, 3.369e-03, 3.483e-03);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(1.347e-02, 8.294e-04, 8.525e-04, 1.231e-03);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-2x12-conv1
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
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			vec4 v2 = l2(x - 1, y - 1) * 1.0000000e+00;
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
	r0 = D(r0, s0_0_0, 0x0BE75626, 0xF2F31306, 0x43E91C17, 0xD41F00FC);
	r1 = D(r1, s0_0_0, 0xF50DF1F4, 0xED15EFEE, 0xDF022110, 0x060DD256);
	r2 = D(r2, s0_0_0, 0xF3E07F4A, 0xF002F701, 0xEC17FF3A, 0x11FBF2F7);
	r0 = D(r0, s0_0_1, 0xDCA1387F, 0x02FFE80E, 0x220DFCED, 0xF545EEF2);
	r1 = D(r1, s0_0_1, 0x030BF0FA, 0x1EFADFCB, 0xF6DFF614, 0xF60D14E1);
	r2 = D(r2, s0_0_1, 0x1890345D, 0x08F907F4, 0xEF12F2D5, 0x070DE601);
	r0 = D(r0, s0_0_2, 0xF8F1FB04, 0x0CFE0DF5, 0xDCE40812, 0xEF230007);
	r1 = D(r1, s0_0_2, 0x120DF9F7, 0x081FF7EE, 0x1111FAF5, 0xEF2003E1);
	r2 = D(r2, s0_0_2, 0xEAE70E08, 0x1001FA08, 0xF719F6F4, 0x0A0A00F9);
	r0 = D(r0, s0_1_0, 0xC7EF3AF1, 0x08CFD52E, 0x112D8181, 0x292A4127);
	r1 = D(r1, s0_1_0, 0x3BF7264C, 0xF8FC17F7, 0x12FDF907, 0x81158144);
	r2 = D(r2, s0_1_0, 0xC217E9DB, 0xE4FDFFFB, 0xE532E237, 0x3001DFD2);
	r0 = D(r0, s0_1_1, 0xEC31702C, 0x398B817F, 0xDF7FE981, 0x3158C720);
	r1 = D(r1, s0_1_1, 0xEAE61A37, 0x16F0E562, 0x22E726D3, 0x7176D381);
	r2 = D(r2, s0_1_1, 0x22E452F1, 0xF9D3212F, 0x19F6FC44, 0xCAF1E8B6);
	r0 = D(r0, s0_1_2, 0x18F6EFEF, 0x414E2481, 0xEDF9F406, 0x141A0CF0);
	r1 = D(r1, s0_1_2, 0xFAF60306, 0xF6080303, 0xF911F8FB, 0x455FFBE3);
	r2 = D(r2, s0_1_2, 0x0810F8F7, 0x1517F5E2, 0x090DFD00, 0x05F9F206);
	r0 = D(r0, s0_2_0, 0x4AF1E5BD, 0x81097F04, 0x03E21FF6, 0xEB221516);
	r1 = D(r1, s0_2_0, 0xED013618, 0xF5051B1C, 0x04FE08FD, 0xAD1EF000);
	r2 = D(r2, s0_2_0, 0x05FEDFE7, 0xF6EE0124, 0x030CF9FC, 0xE0204350);
	r0 = D(r0, s0_2_1, 0xFF06B9DA, 0x9E078181, 0xD1E03D11, 0xB930FB4C);
	r1 = D(r1, s0_2_1, 0x04F62A27, 0xFBD31D0C, 0x03F20B27, 0x215CF8E3);
	r2 = D(r2, s0_2_1, 0x270B0EF8, 0x18DADD0D, 0xF30BFD1B, 0x1CD85A21);
	r0 = D(r0, s0_2_2, 0x1DF9FE01, 0x6CDE1F81, 0x1600F8FB, 0xF7EE1238);
	r1 = D(r1, s0_2_2, 0x00FD0E04, 0xE9F014FB, 0x0AEBFF0E, 0xE93FFADD);
	r2 = D(r2, s0_2_2, 0x0716EAF5, 0xF913FBE8, 0xFF070002, 0x15F90BE9);
	r0 = D(r0, s1_0_0, 0xEAF512FC, 0x0AFC1205, 0xF902041F, 0x1009F3B7);
	r1 = D(r1, s1_0_0, 0xFE06FAFA, 0x0B0AFEFB, 0x010202FA, 0x00F609EB);
	r2 = D(r2, s1_0_0, 0xF0F612FC, 0xFA0C00FC, 0x0110FDE4, 0xF702FE05);
	r0 = D(r0, s1_0_1, 0xD6061101, 0xCFFA11E3, 0xE3EE09F6, 0x0316DDB1);
	r1 = D(r1, s1_0_1, 0x0E1FF9FB, 0xFC2008CB, 0x0B0D02FF, 0x26D5F509);
	r2 = D(r2, s1_0_1, 0xDBE42208, 0x070004FC, 0x0C1202EE, 0x14FA0102);
	r0 = D(r0, s1_0_2, 0xFF24FF04, 0x211AF917, 0x05020000, 0x002EE2B9);
	r1 = D(r1, s1_0_2, 0x0D0DFA00, 0x00F9F202, 0x15FFF010, 0xFF340420);
	r2 = D(r2, s1_0_2, 0x0513F703, 0xF707FA0D, 0xF016FAF5, 0x0CF40709);
	r0 = D(r0, s1_1_0, 0xD6060215, 0x080320E2, 0x38F2E914, 0xECFBEEBD);
	r1 = D(r1, s1_1_0, 0xF105FFEB, 0xFF04F7F0, 0x1108FBFB, 0x04080DED);
	r2 = D(r2, s1_1_0, 0x0C06FE15, 0x11F8F704, 0xFFF4E4F0, 0xF4080109);
	r0 = D(r0, s1_1_1, 0x5CFCF420, 0xFDE12FF6, 0xE181AB3A, 0xD0F5D29F);
	r1 = D(r1, s1_1_1, 0xFBDE00E0, 0x4B2102E3, 0xE700F6F3, 0xC8B61F14);
	r2 = D(r2, s1_1_1, 0x001A0C12, 0x001B17F0, 0x00F422BA, 0xEC11F7ED);
	r0 = D(r0, s1_1_2, 0xE3B03C02, 0x5A810C65, 0xE515241A, 0x39C9D0A4);
	r1 = D(r1, s1_1_2, 0x0C280FEF, 0x24DB11F7, 0xEA7D15F6, 0x3725EDC8);
	r2 = D(r2, s1_1_2, 0xE20DFE06, 0xD33AEF14, 0x3818EEEF, 0x0C2C0212);
	r0 = D(r0, s1_2_0, 0x07080A19, 0xFB13F403, 0x03041204, 0x23E6ECC1);
	r1 = D(r1, s1_2_0, 0x04FE03FF, 0x0106FFF0, 0x0505FFFE, 0x1D0E03FB);
	r2 = D(r2, s1_2_0, 0xF005000A, 0xE80CFEF4, 0x3A03FCF4, 0xA7EDF8F8);
	r0 = D(r0, s1_2_1, 0x0545E0FC, 0x94FB1506, 0xF233E60B, 0xF2AFD9B0);
	r1 = D(r1, s1_2_1, 0x03E60EF3, 0xBBDC05FC, 0xECFB00F6, 0x7FFDBCE5);
	r2 = D(r2, s1_2_1, 0x7F24EA0B, 0x35E8080C, 0xBF0AEAF9, 0x69FE33F0);
	r0 = D(r0, s1_2_2, 0x3C27EAFF, 0x6DD481FA, 0x0CEAF00C, 0x27C601F5);
	r1 = D(r1, s1_2_2, 0xFCE904FD, 0xF4F90604, 0x08E109F0, 0xA1F08102);
	r2 = D(r2, s1_2_2, 0xE201DFFB, 0xCDE51802, 0x01EF09F7, 0xEEEDE21B);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xF7FC01FE, 0x29FBFD12, 0xD71410FE, 0xFE03FE17);
	r1 = D(r1, s0_0_0, 0x0CFDF9F8, 0x0EEBF1F8, 0x0F04FE05, 0x03F5EF3F);
	r2 = D(r2, s0_0_0, 0x02040015, 0x04FDFDF4, 0x070102E6, 0xFF06FC10);
	r0 = D(r0, s0_0_1, 0xEAFD0CBD, 0x1B1DEDF3, 0x12F3F1C9, 0xFB1201D0);
	r1 = D(r1, s0_0_1, 0x0A0410F5, 0x30FFFB54, 0xF80F0AFB, 0xE47C3D9C);
	r2 = D(r2, s0_0_1, 0xE72506A5, 0xFEFAFD2F, 0x2D09FB15, 0x0E0C09E2);
	r0 = D(r0, s0_0_2, 0x0829FFE9, 0xFC0324D3, 0x1FEE1404, 0xF4490FCB);
	r1 = D(r1, s0_0_2, 0xFB24FE0D, 0x02BCFF13, 0xF21CFB01, 0x0BE9E211);
	r2 = D(r2, s0_0_2, 0x001E11E0, 0xF4FCF80D, 0x04F1FFF8, 0x04EB0315);
	r0 = D(r0, s0_1_0, 0xC9FAF915, 0x2104FF01, 0xDBF6F31E, 0x081103F8);
	r1 = D(r1, s0_1_0, 0x0E0206E9, 0x1EF608FB, 0x07FBFBF5, 0xF501E999);
	r2 = D(r2, s0_1_0, 0xE5F4E2FA, 0x23F7F716, 0x1CEBEC1D, 0x000F06D8);
	r0 = D(r0, s0_1_1, 0xDDD83F2F, 0x940E3E81, 0x0EA4DC50, 0x1940D8C3);
	r1 = D(r1, s0_1_1, 0xFA170C0C, 0xF219249E, 0x07153002, 0x02D13A29);
	r2 = D(r2, s0_1_1, 0xF3F35739, 0xFC2F2DB4, 0x011151EF, 0xF0EEEF37);
	r0 = D(r0, s0_1_2, 0xFBF5D42B, 0xC51A12E8, 0x1E1E19DF, 0xFB262A23);
	r1 = D(r1, s0_1_2, 0xF71001E8, 0xF90B25E9, 0xFCF7DA07, 0xD93507CE);
	r2 = D(r2, s0_1_2, 0xF9F7E62C, 0xE91DD142, 0xFF1AF5F1, 0xF00813DE);
	r0 = D(r0, s0_2_0, 0x09FB19E3, 0x1F0411F0, 0x180E0AF9, 0xF102E2F6);
	r1 = D(r1, s0_2_0, 0xFD01F612, 0xFF00F113, 0xFFFDF807, 0x04F3F322);
	r2 = D(r2, s0_2_0, 0xFBF902EC, 0x0601DEF8, 0xFDFADEFB, 0x11F5FA0D);
	r0 = D(r0, s0_2_1, 0x04EAE8F4, 0xE7EDF942, 0x17EF8108, 0xEC02EC7F);
	r1 = D(r1, s0_2_1, 0xFB08FEF5, 0xFD105A09, 0x00040608, 0xEFE581FC);
	r2 = D(r2, s0_2_1, 0xFCF715F1, 0x070F7F00, 0xFE033012, 0xFE0811B2);
	r0 = D(r0, s0_2_2, 0xFFF424E8, 0xF1968132, 0x0507CE19, 0xF13631D3);
	r1 = D(r1, s0_2_2, 0xFE08F3F6, 0xFE060EEB, 0xF8110ED9, 0x0CF4D022);
	r2 = D(r2, s0_2_2, 0xFBF4F902, 0xFAF5F107, 0xFF000AF2, 0x010DD521);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(1.392e-02, -2.496e-03, -8.737e-04, 1.580e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(7.678e-03, 1.043e-02, 9.204e-03, -1.333e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(1.174e-02, -1.491e-03, 3.968e-03, 1.929e-03);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-2x12-conv2
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
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			vec4 v2 = l2(x - 1, y - 1) * 1.0000000e+00;
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
	r0 = D(r0, s0_0_0, 0x0BFD00F8, 0xF611F602, 0xF115F9FA, 0xF60B0C03);
	r1 = D(r1, s0_0_0, 0x0D02E9F5, 0x0F21EAFB, 0x0A0DFFFA, 0xFD040100);
	r2 = D(r2, s0_0_0, 0x0703E7F4, 0x12020C04, 0x0CC7EBFA, 0xFFF8FEF4);
	r0 = D(r0, s0_0_1, 0xCA20F707, 0x10FF8CF2, 0x02FDFEFE, 0xFAFC0207);
	r1 = D(r1, s0_0_1, 0xDAF80EF9, 0xF9A8E1F8, 0xF0F6CDF2, 0xFF03FEFD);
	r2 = D(r2, s0_0_1, 0x13CFC5F4, 0xF80AEF03, 0xF5E81A01, 0x0EC9E1F4);
	r0 = D(r0, s0_0_2, 0xFE09DAFF, 0xDFBD1304, 0xF0DE1A06, 0xFC000700);
	r1 = D(r1, s0_0_2, 0x0C0DF504, 0xFBE10602, 0xFF0B1002, 0xFF0002FF);
	r2 = D(r2, s0_0_2, 0xF7D8F802, 0xFF030401, 0x0306FF00, 0xFED7EA06);
	r0 = D(r0, s0_1_0, 0xDF15DCE0, 0x0108E908, 0xCF28DCE9, 0x210FD4EC);
	r1 = D(r1, s0_1_0, 0xFCC8CDE6, 0xD1C105E7, 0xEE0105F7, 0xFF05F9FE);
	r2 = D(r2, s0_1_0, 0xE912F6E5, 0xFB06DD01, 0xF2810E11, 0xFDFCF6F8);
	r0 = D(r0, s0_1_1, 0x1EB6AE81, 0xF8C081EC, 0x17B1BAEB, 0x10C7D6E9);
	r1 = D(r1, s0_1_1, 0xEEBE37BE, 0xE0B621FD, 0x0F81B5C5, 0x06F4FA26);
	r2 = D(r2, s0_1_1, 0xE08116CC, 0xFBE12AF5, 0x04D0FAE8, 0xF50915CF);
	r0 = D(r0, s0_1_2, 0x018113EA, 0xF28119EE, 0xEAB518F0, 0xFAD40CF9);
	r1 = D(r1, s0_1_2, 0x09E0DAFB, 0x00E108FD, 0xE5E206EE, 0xFF01FFF5);
	r2 = D(r2, s0_1_2, 0x01DF10F7, 0xF3F5F8FD, 0xFE0A1B04, 0x05810713);
	r0 = D(r0, s0_2_0, 0xFDF32209, 0x070CFF00, 0x0114EDF5, 0xDEE91BF2);
	r1 = D(r1, s0_2_0, 0xFD0CFD04, 0x0608FAFB, 0x0714E5FF, 0x01FF01FD);
	r2 = D(r2, s0_2_0, 0x09FEF909, 0xF1070DF9, 0xFDE41400, 0xFDF60607);
	r0 = D(r0, s0_2_1, 0xC6D30805, 0xF5F80DF0, 0xE2C910E0, 0xD8BA1EF6);
	r1 = D(r1, s0_2_1, 0xF9E912ED, 0x0D13E6E8, 0x06C907FC, 0x0302FEF5);
	r2 = D(r2, s0_2_1, 0x1225E2E0, 0xF0F3E721, 0xFDFCF4F6, 0x0B2AD0F2);
	r0 = D(r0, s0_2_2, 0xF6EDEF07, 0x02F603F3, 0x0202F9EF, 0x07F8F4FC);
	r1 = D(r1, s0_2_2, 0xFEEAFAFF, 0xF91001FD, 0xF6EF04EA, 0xFEFC05FB);
	r2 = D(r2, s0_2_2, 0x020CF8FE, 0x05CA03FB, 0x06FD0901, 0xFE07EFE9);
	r0 = D(r0, s1_0_0, 0x040300F9, 0xFEF00603, 0x021C04EA, 0x03F0F715);
	r1 = D(r1, s1_0_0, 0xF5FB0B00, 0xE6B90227, 0xFD0C0603, 0xFD0A0004);
	r2 = D(r2, s1_0_0, 0x04EB0B04, 0xFFF00304, 0xD8FC0FF4, 0xFBF10909);
	r0 = D(r0, s1_0_1, 0xF50FD617, 0xF02407E4, 0xF40E03F9, 0xFD0DF3F8);
	r1 = D(r1, s1_0_1, 0xF503FD18, 0xF9F023F9, 0xEAF9F71F, 0xFAFEF715);
	r2 = D(r2, s1_0_1, 0xF0CB072E, 0x0A04FDFF, 0xEFFAF404, 0xF6F7050D);
	r0 = D(r0, s1_0_2, 0x01F9F60E, 0x06F0FC14, 0x03FC0511, 0xFE0505FE);
	r1 = D(r1, s1_0_2, 0x0405F6FB, 0xF50809FB, 0xFFFEF001, 0xFFFE0203);
	r2 = D(r2, s1_0_2, 0x04070AF5, 0x00F902FC, 0x00050200, 0x0201FF00);
	r0 = D(r0, s1_1_0, 0xCFDA1517, 0x09EFED01, 0xDEEF0322, 0xD6CC2014);
	r1 = D(r1, s1_1_0, 0xFB070CCB, 0xE7321DC7, 0xF8010D07, 0xFB2CFBFF);
	r2 = D(r2, s1_1_0, 0xF60C1F03, 0xFDD6F102, 0x0AE7DEBF, 0xF80601E5);
	r0 = D(r0, s1_1_1, 0xC20A2C18, 0x0F48F3EC, 0xC423C5B3, 0xEBF01EE4);
	r1 = D(r1, s1_1_1, 0xC5AA0364, 0xAE07FDCF, 0xD5F20DE1, 0x16E63BBA);
	r2 = D(r2, s1_1_1, 0xC842E59A, 0xEA2305ED, 0xF9E0E558, 0xF62CF9E8);
	r0 = D(r0, s1_1_2, 0xD2F91404, 0xDCC6F70C, 0xD6E01428, 0xEAFE050F);
	r1 = D(r1, s1_1_2, 0xFE0AEDFD, 0xF2FFFAF9, 0x11E2C234, 0x01F5F61D);
	r2 = D(r2, s1_1_2, 0xF6E50008, 0xE80D0704, 0xFF050DF3, 0xFF16FFBE);
	r0 = D(r0, s1_2_0, 0x132102DB, 0xF9FC0107, 0xEC0A141B, 0xFE0C16D8);
	r1 = D(r1, s1_2_0, 0x081CFBF1, 0x02F00D11, 0x0202FE0D, 0x0101FFFB);
	r2 = D(r2, s1_2_0, 0x07F7FC05, 0xE9FE0D01, 0xE1ED0B29, 0x10F8FC00);
	r0 = D(r0, s1_2_1, 0xF6FEFBC4, 0xFC17FCEC, 0x061804C9, 0xD4F920F3);
	r1 = D(r1, s1_2_1, 0xF8EBF6F4, 0x11F80518, 0x0514F2EC, 0xFFFAED00);
	r2 = D(r2, s1_2_1, 0x06F31729, 0xE82B19D9, 0xFB0EFBEA, 0xF7C40E24);
	r0 = D(r0, s1_2_2, 0x030607FB, 0xFBF00102, 0x09ECF216, 0xF704FAE8);
	r1 = D(r1, s1_2_2, 0x07FCFDFF, 0x0E030B02, 0xFAF2FEF3, 0xFCF7FD0F);
	r2 = D(r2, s1_2_2, 0x0D0F1400, 0xE4FE03F5, 0x03FD0703, 0x041316F5);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0604ECFF, 0xFEF5FB00, 0xF703E1F9, 0xF3FD0DFD);
	r1 = D(r1, s0_0_0, 0x1B06F20D, 0x16FA151D, 0xFB02E700, 0x0CFFF0FF);
	r2 = D(r2, s0_0_0, 0x0806F211, 0x0B030003, 0x07FB070B, 0x0801F611);
	r0 = D(r0, s0_0_1, 0x2808EAF6, 0x3B18D0F5, 0x2D151701, 0x0A05F9F8);
	r1 = D(r1, s0_0_1, 0x14FB0908, 0x37D14213, 0x11FC1114, 0x0201E703);
	r2 = D(r2, s0_0_1, 0x09EE3F19, 0xE7F907F4, 0x2E040704, 0x01FC1A0C);
	r0 = D(r0, s0_0_2, 0x2DFE1306, 0xF61E1200, 0x0605FDFE, 0x08FC0004);
	r1 = D(r1, s0_0_2, 0x1001F9FA, 0x0CFA02FD, 0x3306FFFC, 0x0A01FC00);
	r2 = D(r2, s0_0_2, 0x16F806F9, 0x14020602, 0xEAFBFFFC, 0xEAF60300);
	r0 = D(r0, s0_1_0, 0x1802D422, 0xFB08F407, 0xEB118121, 0x1AF91424);
	r1 = D(r1, s0_1_0, 0x2C0BD102, 0x0AF4F4E3, 0xF5F7E80D, 0x02040CFD);
	r2 = D(r2, s0_1_0, 0xEFF1E00D, 0x10FB19F9, 0xFF111FD8, 0x0D01F603);
	r0 = D(r0, s0_1_1, 0xEAEDFA79, 0x1ADA0FFD, 0x092B2BDD, 0xFAE15218);
	r1 = D(r1, s0_1_1, 0xCC232244, 0x146ECAEA, 0x14FC0321, 0xE0F90FEE);
	r2 = D(r2, s0_1_1, 0x1251ECE9, 0x630A0008, 0x0420FD22, 0xEC1AE807);
	r0 = D(r0, s0_1_2, 0xF4EBF318, 0xFC4FF103, 0x0501EC13, 0x00FD0308);
	r1 = D(r1, s0_1_2, 0x16FD03FE, 0x021DF715, 0x1337FC10, 0xFCF90205);
	r2 = D(r2, s0_1_2, 0xF725F321, 0xFBFCF90B, 0xF3F1FFFE, 0x3227F8EE);
	r0 = D(r0, s0_2_0, 0x1600FCFE, 0xFCFFF91A, 0x0114E539, 0x15EAEDF3);
	r1 = D(r1, s0_2_0, 0x02F605FA, 0xFAF6F51F, 0xF30BF701, 0x04FD00FF);
	r2 = D(r2, s0_2_0, 0xFF0AFB15, 0x09F6F809, 0xE6F5FB1D, 0xFB02090B);
	r0 = D(r0, s0_2_1, 0x2221F4E9, 0x05F102E4, 0x0018F710, 0x1141A91E);
	r1 = D(r1, s0_2_1, 0x052EFCEA, 0xEBDDFD26, 0xFBD31404, 0xFB060D1C);
	r2 = D(r2, s0_2_1, 0xE5C1F239, 0x0CFCEFE6, 0x060801CA, 0xF9F5F425);
	r0 = D(r0, s0_2_2, 0x1601F6FB, 0x0315FD0D, 0xFEFC0C02, 0x0613F109);
	r1 = D(r1, s0_2_2, 0x0A110102, 0xFAF0FBFC, 0x103CF3E8, 0x040506FC);
	r2 = D(r2, s0_2_2, 0xF5ECF7F7, 0xFA17F306, 0xFEFBFB0C, 0xF5F3EA26);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-9.881e-03, -2.724e-03, -7.480e-03, -8.730e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-7.611e-04, -9.225e-03, -5.303e-03, 2.560e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-9.954e-03, -1.309e-02, -4.595e-03, -7.603e-03);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-2x12-out-shuffle
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
	r0 += M4(-4.556e-02, -1.541e-02, 1.278e-02, 8.207e-03, 3.263e-02, 3.553e-03, 7.443e-03, 5.034e-03, -2.704e-02, 1.812e-02, -1.996e-02, 3.040e-03, 5.981e-02, 1.151e-02, -6.906e-03, 3.236e-04) * s0_0_0;
	r0 += M4(-3.442e-02, -6.959e-02, -3.019e-03, 8.627e-03, 6.639e-03, 5.706e-03, -3.299e-03, 1.150e-02, 1.077e-01, -1.121e-01, -4.725e-03, 1.538e-02, 1.506e-01, 1.694e-01, 1.862e-02, -2.027e-03) * s0_0_1;
	r0 += M4(-6.985e-03, -1.026e-02, 3.284e-03, 9.389e-03, 9.706e-04, 2.857e-03, 7.921e-04, -6.898e-04, -8.278e-03, 3.746e-02, -1.368e-03, 1.434e-02, 8.146e-03, 3.337e-02, 1.522e-03, 8.967e-03) * s0_0_2;
	r0 += M4(1.126e-01, -1.405e-02, -1.772e-01, 2.062e-02, -2.939e-01, 6.517e-02, -8.642e-02, 1.384e-02, -5.997e-02, 2.693e-02, -1.360e-02, 2.524e-02, -2.968e-02, 1.342e-02, 5.644e-02, -2.026e-03) * s0_1_0;
	r0 += M4(1.479e-01, 2.789e-01, -3.675e-02, -3.194e-01, -6.826e-02, 2.549e-01, -9.505e-04, 8.471e-02, 2.192e-01, -2.290e-01, 3.311e-01, -3.467e-01, 7.202e-02, -1.185e-02, -2.881e-01, -1.224e-01) * s0_1_1;
	r0 += M4(-7.644e-04, 1.621e-02, -1.730e-02, 1.466e-03, 1.080e-03, -1.703e-02, 3.683e-03, -2.601e-03, -1.740e-02, 4.515e-02, -1.763e-02, 5.115e-02, -6.533e-03, 2.311e-02, 2.826e-02, -5.457e-02) * s0_1_2;
	r0 += M4(1.269e-03, -5.137e-03, 2.966e-02, 3.265e-04, 4.594e-03, -2.711e-02, -1.718e-01, 2.239e-02, 4.639e-03, 1.216e-03, -4.742e-02, 6.007e-03, -2.708e-03, 1.388e-03, -9.709e-03, -4.626e-04) * s0_2_0;
	r0 += M4(-1.481e-02, -9.009e-03, 9.483e-03, 1.826e-02, 3.917e-02, 2.741e-02, -2.954e-02, 1.086e-01, 4.497e-03, 3.122e-03, 2.105e-02, -3.321e-02, 2.846e-03, 1.475e-03, 1.198e-02, 3.736e-03) * s0_2_1;
	r0 += M4(1.077e-03, -3.147e-03, -1.143e-03, 9.409e-03, -2.813e-04, 7.007e-03, 1.907e-04, -7.062e-03, -1.135e-03, 5.196e-03, -8.209e-03, 1.500e-02, -1.186e-03, -1.188e-03, 7.101e-05, -1.289e-03) * s0_2_2;
	r0 += M4(1.936e-02, -1.221e-02, 7.250e-03, -3.828e-03, 7.426e-03, -1.395e-03, 1.493e-03, 2.734e-03, -8.160e-02, -1.195e-02, -2.825e-03, -2.124e-03, -3.509e-03, -1.536e-03, -7.323e-04, -2.258e-03) * s1_0_0;
	r0 += M4(-1.382e-01, 5.481e-02, 3.144e-02, 1.196e-02, 1.654e-02, 1.834e-02, -1.234e-03, 1.386e-04, 9.152e-02, -1.474e-01, -4.088e-03, -8.695e-03, -1.194e-02, -8.781e-03, -7.956e-03, -6.552e-03) * s1_0_1;
	r0 += M4(1.389e-02, -3.060e-02, 7.928e-03, -2.308e-03, 1.954e-03, 4.411e-03, 8.415e-03, 5.323e-03, -9.859e-04, 1.004e-02, -1.483e-03, 2.284e-03, 5.581e-04, -7.696e-04, 2.869e-04, 3.455e-04) * s1_0_2;
	r0 += M4(7.153e-02, -1.363e-02, 6.763e-02, -1.139e-02, 3.723e-02, -1.905e-02, 3.796e-02, 5.780e-03, 1.584e-01, -1.560e-02, 7.886e-02, 1.557e-02, -6.533e-03, -3.586e-03, -2.874e-03, -3.348e-03) * s1_1_0;
	r0 += M4(-7.533e-02, 2.627e-01, -3.603e-01, 2.379e-01, -4.567e-01, -2.802e-02, 1.779e-01, 1.255e-01, 6.088e-02, 8.121e-03, 1.606e-01, -3.476e-01, -6.306e-02, -6.366e-02, -6.454e-02, -6.185e-02) * s1_1_1;
	r0 += M4(1.269e-02, -7.962e-02, 4.841e-03, -7.490e-02, -4.888e-03, -1.470e-01, 1.535e-02, 2.631e-02, -2.026e-03, 9.237e-03, 6.025e-04, 7.747e-03, -4.373e-03, -3.130e-03, -4.293e-03, -4.373e-03) * s1_1_2;
	r0 += M4(-5.314e-03, -5.498e-04, 1.403e-02, -2.847e-03, -3.908e-03, 1.175e-02, -3.908e-03, 4.345e-03, -8.512e-03, -4.549e-03, 3.735e-03, -1.169e-02, 2.319e-03, -5.392e-04, 1.586e-03, 1.358e-03) * s1_2_0;
	r0 += M4(-3.235e-02, -5.836e-03, 6.423e-02, 4.294e-02, -2.029e-02, -2.264e-02, 1.421e-01, -2.741e-02, 7.076e-04, -1.557e-02, 2.501e-02, 6.910e-02, -3.719e-03, -6.014e-03, -5.942e-03, -6.484e-03) * s1_2_1;
	r0 += M4(1.344e-03, -8.437e-03, 1.481e-02, -2.043e-02, 1.405e-02, -1.486e-02, -2.540e-02, 1.923e-02, 1.651e-03, -2.739e-03, -1.441e-03, 6.870e-03, -5.874e-04, 9.071e-04, -1.485e-04, -6.597e-05) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 += M4(4.942e-02, 1.476e-02, -4.208e-03, -3.561e-03, -5.850e-02, -8.324e-03, -1.917e-02, 1.632e-03, 1.705e-03, 2.277e-03, 1.921e-03, 2.232e-03, 1.106e-01, 9.348e-02, -2.887e-03, -2.314e-03) * s0_0_0;
	r0 += M4(1.125e-02, 4.734e-02, -1.702e-02, -1.440e-02, 1.149e-01, -8.228e-02, -4.540e-02, -5.226e-02, 2.319e-02, -1.720e-03, 6.195e-03, -3.009e-03, -5.240e-03, 2.563e-02, -1.435e-03, 9.100e-04) * s0_0_1;
	r0 += M4(1.412e-03, 9.615e-03, -1.598e-03, -5.781e-03, -3.329e-03, 2.753e-02, -1.306e-02, 5.419e-03, -7.488e-02, 8.166e-02, 1.972e-02, 1.212e-02, -4.945e-04, -3.039e-03, 1.972e-03, 1.444e-03) * s0_0_2;
	r0 += M4(-6.948e-02, 4.229e-02, -4.451e-02, -2.077e-03, 4.675e-02, -1.802e-02, -6.673e-03, -2.520e-02, 9.761e-04, 2.871e-03, 1.350e-03, 1.977e-03, -2.134e-01, -6.275e-02, 2.437e-01, -1.357e-01) * s0_1_0;
	r0 += M4(1.091e-01, -4.443e-01, 1.037e-01, 2.312e-01, -3.454e-02, 5.320e-02, 1.499e-01, 2.241e-01, 2.251e-01, 1.669e-02, 9.565e-02, -7.237e-03, 3.478e-02, 1.027e-01, 2.780e-03, 1.478e-01) * s0_1_1;
	r0 += M4(-1.996e-02, 6.860e-02, -5.570e-03, 1.740e-02, 4.070e-03, -1.107e-02, 7.745e-03, 2.313e-02, -6.634e-02, -1.761e-01, -1.496e-01, 1.577e-01, 3.704e-03, -1.874e-03, 4.036e-03, -1.247e-03) * s0_1_2;
	r0 += M4(-6.817e-04, 8.313e-03, 1.544e-02, 7.570e-03, 2.954e-03, -3.075e-03, 2.710e-03, -2.726e-03, 9.740e-05, -3.118e-05, -2.370e-03, -4.282e-05, 2.759e-02, 7.557e-03, -9.178e-02, -5.339e-03) * s0_2_0;
	r0 += M4(3.600e-02, 2.944e-02, -1.556e-01, -1.211e-02, -2.038e-03, 4.485e-03, -4.009e-03, 6.530e-03, -5.981e-02, 2.878e-02, 7.153e-02, 1.807e-02, 3.106e-02, 3.412e-02, 2.727e-03, -5.028e-02) * s0_2_1;
	r0 += M4(-3.417e-03, 2.619e-02, 1.697e-02, -6.750e-03, 4.747e-03, 3.792e-03, 4.838e-03, 4.935e-04, 9.446e-03, -8.613e-03, -2.962e-02, -1.204e-01, -3.024e-03, 5.117e-03, -2.931e-03, -2.010e-02) * s0_2_2;
	r0 += V4(2.357e-03, 2.258e-03, 2.205e-03, 2.159e-03);
	r0 = r0;
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
