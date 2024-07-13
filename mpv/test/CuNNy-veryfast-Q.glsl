// CuNNy veryfast (dp4a)
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


//!DESC CuNNy-veryfast-in
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
	r0 += V4(-1.179e-01, 2.095e-02, -4.845e-02, -8.450e-02) * s0_0_0;
	r1 += V4(-4.307e-02, -2.371e-03, 8.534e-02, -6.432e-02) * s0_0_0;
	r0 += V4(3.258e-01, 7.289e-03, -3.098e-02, 8.524e-01) * s0_0_1;
	r1 += V4(-1.160e+00, -4.193e-02, 1.884e-01, -3.077e-01) * s0_0_1;
	r0 += V4(3.525e-01, -2.835e-02, -4.552e-02, 2.284e-01) * s0_0_2;
	r1 += V4(3.382e-01, 2.898e-02, -2.647e-01, 3.194e-02) * s0_0_2;
	r0 += V4(-1.347e-01, 1.156e+00, 4.223e-02, 1.726e-01) * s0_1_0;
	r1 += V4(3.434e-02, 3.483e-02, -5.933e-02, 5.794e-02) * s0_1_0;
	r0 += V4(-5.037e-01, -1.137e+00, -1.632e-01, -8.916e-01) * s0_1_1;
	r1 += V4(3.241e-01, -1.047e+00, -1.067e+00, 7.285e-01) * s0_1_1;
	r0 += V4(-3.222e-01, -2.705e-02, 6.446e-01, -2.568e-01) * s0_1_2;
	r1 += V4(5.138e-01, 7.025e-02, 1.137e+00, -1.596e-01) * s0_1_2;
	r0 += V4(2.203e-01, -1.973e-02, 1.787e-02, -6.273e-02) * s0_2_0;
	r1 += V4(4.552e-02, -2.844e-02, -2.335e-02, 2.171e-02) * s0_2_0;
	r0 += V4(2.086e-01, -9.576e-03, -1.274e-01, 2.122e-02) * s0_2_1;
	r1 += V4(-2.452e-02, 1.090e+00, 4.637e-02, 2.889e-02) * s0_2_1;
	r0 += V4(1.208e-01, 4.318e-02, -9.696e-02, 1.854e-02) * s0_2_2;
	r1 += V4(-2.500e-02, -1.005e-01, -4.134e-02, -4.631e-02) * s0_2_2;
	r0 += V4(2.326e-02, -1.206e-03, 3.472e-03, -1.422e-04);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(1.253e-03, -7.881e-04, -2.753e-04, -2.586e-03);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-veryfast-conv1
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
	r0 = D(r0, s0_0_0, 0xFABEF9F7, 0x11E5F1E1, 0xE67F0915, 0xFC14FF0B);
	r1 = D(r1, s0_0_0, 0x0FCBFD06, 0xF9D2F9F7, 0xCB130505, 0x03FBFDEF);
	r0 = D(r0, s0_0_1, 0x1208FE16, 0xF025CC31, 0xF2E91842, 0x000AF6F2);
	r1 = D(r1, s0_0_1, 0xF0F50922, 0x16810395, 0xDE7FF31E, 0x01010BF5);
	r0 = D(r0, s0_0_2, 0xFCFFFFE7, 0xE5D8F00A, 0xDD48C206, 0xFEFE0600);
	r1 = D(r1, s0_0_2, 0xF222FE03, 0x37A81F04, 0x817FD120, 0x00F7F403);
	r0 = D(r0, s0_1_0, 0xF31E05FC, 0x0B7F12EE, 0xF6100119, 0x0A3C05EC);
	r1 = D(r1, s0_1_0, 0x19CBF1ED, 0xD7E9051F, 0xDCB7FEF0, 0xE2F6F106);
	r0 = D(r0, s0_1_1, 0xED20D90A, 0x81818142, 0x81E7EC17, 0xE1E0E523);
	r1 = D(r1, s0_1_1, 0xF1176FE8, 0xEB0500B8, 0xC1A3EEEB, 0x0A2B2A11);
	r0 = D(r0, s0_1_2, 0x07FCF706, 0x0CEEEBDE, 0xDCEE26E6, 0x0CFF0AF9);
	r1 = D(r1, s0_1_2, 0xEDF608F4, 0xDE7F8132, 0x1D9F7281, 0xF8F3C60B);
	r0 = D(r0, s0_2_0, 0x0D08F808, 0xF802FBF1, 0x1AC401FC, 0x3DD7F8F0);
	r1 = D(r1, s0_2_0, 0x3104DF11, 0xE0E0080C, 0xE3F00409, 0xDBFE0601);
	r0 = D(r0, s0_2_1, 0xF6091106, 0xE9E9EA0E, 0x43E90CE2, 0x40051227);
	r1 = D(r1, s0_2_1, 0xEC07FAFB, 0x2B3D12FA, 0xDAFEEBD7, 0x3B0709EB);
	r0 = D(r0, s0_2_2, 0x00F60002, 0x241F4BFB, 0x2017FBFA, 0x080A06EE);
	r1 = D(r1, s0_2_2, 0x0AF2ECFD, 0xCD2F1F3F, 0x7A24A432, 0x04F6D907);
	r0 = D(r0, s1_0_0, 0x2000F9FE, 0x1A20E4F0, 0xEBE63AFD, 0xFB000B04);
	r1 = D(r1, s1_0_0, 0xEF020AF3, 0x0A141824, 0x20132CF5, 0x06F6F5FC);
	r0 = D(r0, s1_0_1, 0xDA466415, 0x0719BA0D, 0xD39BE8E8, 0x04F603FC);
	r1 = D(r1, s1_0_1, 0x010E5B10, 0xB37F7F17, 0x0F81DBB8, 0x1E03E7FD);
	r0 = D(r0, s1_0_2, 0xFEEF26F6, 0xE92C400E, 0x4FD81BF8, 0xECFAF803);
	r1 = D(r1, s1_0_2, 0x29F206FD, 0xEC399FFA, 0x7F99AEE1, 0xFA0AF1F9);
	r0 = D(r0, s1_1_0, 0x05F0E3F5, 0x00D1DEDA, 0xCF171BCE, 0xEC1BE209);
	r1 = D(r1, s1_1_0, 0x6BBCB734, 0x34111A03, 0xFFFF1EF7, 0x1AF71A0A);
	r0 = D(r0, s1_1_1, 0x0405F109, 0x36818105, 0x01C30823, 0x3325EADE);
	r1 = D(r1, s1_1_1, 0xC91F32D2, 0xE116DB9A, 0x9A4244F6, 0xC24F3A15);
	r0 = D(r0, s1_1_2, 0xCF18FE00, 0x0C327F0E, 0xC9E81329, 0xE2FAF714);
	r1 = D(r1, s1_1_2, 0xDDEFF400, 0x7F8181BE, 0x81DDCDE1, 0x11FEF9EF);
	r0 = D(r0, s1_2_0, 0xF4E8FDF0, 0x0EE90612, 0xF12E0D10, 0x1002014B);
	r1 = D(r1, s1_2_0, 0x190B09C4, 0xDA18F7FC, 0x19240F1A, 0xF11CF21A);
	r0 = D(r0, s1_2_1, 0x26FE0305, 0xB9FF0ABA, 0xF8230BCC, 0xCA080CBB);
	r1 = D(r1, s1_2_1, 0xFF14F3E7, 0xF3C5EFEA, 0x196FF306, 0x2123FEEF);
	r0 = D(r0, s1_2_2, 0x0804F905, 0xF92802A4, 0x0FF90CEF, 0x20F4F7FE);
	r1 = D(r1, s1_2_2, 0xECFFFB0E, 0x41BFF181, 0x1E0806E3, 0xE212070D);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-3.268e-03, -1.851e-02, -2.509e-02, -4.254e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(3.697e-03, -7.529e-03, -2.972e-03, 2.563e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-veryfast-conv2
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
	r0 = D(r0, s0_0_0, 0x040110FC, 0x0CF70DF6, 0x010107FF, 0x02050C00);
	r0 = D(r0, s0_0_1, 0x36EDCDFB, 0x1BB0D6F2, 0x24EAD5F8, 0x14FCDEFF);
	r0 = D(r0, s0_0_2, 0x2300F7FE, 0x1B03F0FA, 0x01FBFDFD, 0x0C05F602);
	r0 = D(r0, s0_1_0, 0x07FB1AEC, 0xFDFF0802, 0x04FD0AF4, 0x03F9EDF6);
	r0 = D(r0, s0_1_1, 0xEB0AC11B, 0xEB0ECC40, 0xF9F70C0F, 0xECF1E511);
	r0 = D(r0, s0_1_2, 0x0DE7F5EE, 0x09F8FA00, 0xF11CEFD5, 0x16FCED01);
	r0 = D(r0, s0_2_0, 0xFEFF03FA, 0xFF01FFFE, 0x00FB0905, 0x02F8050E);
	r0 = D(r0, s0_2_1, 0xFFF2F42E, 0x05F80100, 0xFEEFF829, 0x03E9E739);
	r0 = D(r0, s0_2_2, 0x07F9FCF4, 0x02FE00FF, 0x0FF6FB3B, 0x09FDFE12);
	r0 = D(r0, s1_0_0, 0xFBFBF101, 0xFD1CF9FF, 0xFCFDF301, 0x0402FF01);
	r0 = D(r0, s1_0_1, 0xF325EDFC, 0xFA2CE403, 0xF429FEFD, 0x070EFBFB);
	r0 = D(r0, s1_0_2, 0x18FF0910, 0x0FFF0401, 0x2D080316, 0x04FF0102);
	r0 = D(r0, s1_1_0, 0xFEFAE602, 0x07EFB700, 0xFFFEE902, 0x04EEEAFE);
	r0 = D(r0, s1_1_1, 0x02F59309, 0x07CDD707, 0x01FBB505, 0x1104E603);
	r0 = D(r0, s1_1_2, 0x0F0C1207, 0xFB010813, 0xD0F40624, 0xF30000F9);
	r0 = D(r0, s1_2_0, 0x04FAFD02, 0x01F90B01, 0x0AF9F800, 0x0B02FCFF);
	r0 = D(r0, s1_2_1, 0x02EA0904, 0xFEFD0EFE, 0xFEF21505, 0x04F80C00);
	r0 = D(r0, s1_2_2, 0xFA0AFD0F, 0x0001FE00, 0xFCF8F818, 0xF6000217);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-4.903e-03, -3.706e-03, -4.622e-03, -4.990e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
}

//!DESC CuNNy-veryfast-out-shuffle
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
	r0 += M4(-8.728e-02, 4.206e-03, 1.255e-02, 1.210e-02, -1.232e-02, 4.811e-03, 4.636e-06, 1.626e-03, 1.038e-01, -9.651e-03, -2.826e-02, -8.975e-03, 4.332e-02, -1.088e-02, -6.006e-06, -4.288e-03) * s0_0_0;
	r0 += M4(-1.171e-02, -8.962e-02, -9.331e-03, -5.812e-03, -2.344e-02, -1.861e-02, 2.894e-03, -7.689e-04, -4.335e-03, 3.748e-02, -1.293e-04, -7.172e-03, 1.069e-01, 2.124e-01, 1.830e-02, 4.413e-03) * s0_0_1;
	r0 += M4(-7.719e-03, -1.941e-02, 1.120e-03, 4.693e-03, 4.128e-03, -4.531e-03, -9.671e-04, 4.709e-04, -1.973e-03, 1.291e-03, 2.515e-04, -1.127e-03, 1.212e-02, 2.875e-02, 1.442e-04, -3.611e-03) * s0_0_2;
	r0 += M4(-2.417e-01, 3.150e-01, -3.330e-01, 5.994e-02, 2.807e-02, 9.954e-04, -1.013e-02, -2.199e-03, -1.150e-01, -3.330e-01, 3.951e-01, -7.174e-02, 2.232e-01, 1.183e-02, 1.870e-01, -1.807e-02) * s0_1_0;
	r0 += M4(1.694e-01, -4.734e-01, 1.248e-01, -3.369e-01, 1.380e-01, 8.551e-02, 1.057e-02, 5.109e-02, 5.163e-02, 1.485e-01, -3.284e-03, 1.801e-01, -6.949e-01, -1.590e-01, -2.123e-01, 4.228e-01) * s0_1_1;
	r0 += M4(-8.638e-03, 5.553e-02, -1.432e-02, 1.255e-02, -3.772e-02, 2.399e-02, -3.622e-03, -1.593e-02, 2.800e-03, -7.006e-05, -1.297e-04, 4.340e-03, 3.696e-02, -1.070e-01, 2.970e-02, -2.808e-02) * s0_1_2;
	r0 += M4(-1.403e-02, 3.227e-02, 4.768e-02, 1.577e-01, 1.909e-01, -1.805e-03, -1.243e-01, 7.528e-02, -6.208e-02, 3.650e-02, -3.705e-01, -1.304e-01, 4.797e-02, -3.895e-02, 2.261e-01, -3.211e-02) * s0_2_0;
	r0 += M4(-1.888e-02, 2.954e-02, 3.115e-01, 2.294e-01, 3.818e-01, 3.135e-01, -2.359e-01, -7.361e-01, -3.023e-02, 1.135e-01, 7.940e-03, 9.837e-02, 4.382e-02, -1.062e-01, -1.213e-01, -1.420e-01) * s0_2_1;
	r0 += M4(1.552e-02, -3.430e-02, 2.689e-03, 4.765e-02, -3.280e-02, 6.763e-02, -1.885e-02, 1.981e-02, -8.034e-04, -3.350e-04, 8.152e-05, -7.242e-03, -6.244e-03, 1.776e-02, -3.152e-03, -1.906e-02) * s0_2_2;
	r0 += V4(1.024e-11, 3.627e-09, -1.388e-09, 5.119e-09);
	r0 = r0;
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
