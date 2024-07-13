// CuNNy 4x16 DS (dp4a)
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


//!DESC CuNNy-4x16-DS-in
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND LUMA
//!SAVE in
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
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
	F s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2;
	V4 r0, r1, r2, r3;
	r0 = V4(0.0); r1 = V4(0.0); r2 = V4(0.0); r3 = V4(0.0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2];
	r0 += V4(1.788e-02, 9.228e-02, 1.276e-02, -1.347e-02) * s0_0_0;
	r1 += V4(1.482e-02, -2.908e-02, 7.169e-02, -4.113e-02) * s0_0_0;
	r2 += V4(1.425e-02, 9.581e-02, 7.619e-02, -3.136e-02) * s0_0_0;
	r3 += V4(-6.137e-01, -2.612e-02, -5.735e-02, -2.123e-02) * s0_0_0;
	r0 += V4(2.841e-01, 6.152e-01, 1.061e-01, 4.163e-02) * s0_0_1;
	r1 += V4(-2.933e-02, -7.730e-03, -8.994e-02, -1.130e-01) * s0_0_1;
	r2 += V4(6.252e-01, 2.783e-01, 1.036e-01, -7.267e-02) * s0_0_1;
	r3 += V4(4.932e-02, -1.178e-01, -7.147e-03, -6.465e-01) * s0_0_1;
	r0 += V4(6.771e-01, 4.364e-02, 1.024e-01, -2.629e-02) * s0_0_2;
	r1 += V4(6.176e-03, -2.737e-03, -3.966e-04, 1.380e-01) * s0_0_2;
	r2 += V4(-2.149e-02, 1.072e-01, 3.302e-03, 1.145e-01) * s0_0_2;
	r3 += V4(2.251e-02, 5.900e-03, -8.374e-02, 5.348e-03) * s0_0_2;
	r0 += V4(-2.682e-02, -4.554e-02, -5.527e-02, -1.278e-02) * s0_1_0;
	r1 += V4(1.062e+00, 5.409e-02, 3.330e-01, -3.386e-01) * s0_1_0;
	r2 += V4(-6.352e-01, -2.680e-02, -2.086e+00, -3.117e-01) * s0_1_0;
	r3 += V4(4.234e-02, -2.371e-01, 9.448e-02, 5.827e-02) * s0_1_0;
	r0 += V4(-2.582e-01, -5.810e-01, -9.931e-02, 6.215e-01) * s0_1_1;
	r1 += V4(1.461e-02, -1.327e-01, -4.055e-01, -4.580e-01) * s0_1_1;
	r2 += V4(8.506e-03, -7.773e-01, 8.033e-02, -4.596e-01) * s0_1_1;
	r3 += V4(5.438e-01, -2.400e-01, 6.334e-01, 6.297e-01) * s0_1_1;
	r0 += V4(-5.957e-01, -2.832e-02, -2.785e-01, -5.958e-01) * s0_1_2;
	r1 += V4(-1.624e-02, 3.387e-01, -6.068e-03, 8.204e-01) * s0_1_2;
	r2 += V4(9.166e-03, 1.604e-01, -2.713e-02, 7.559e-01) * s0_1_2;
	r3 += V4(-4.210e-02, -1.626e-01, -3.933e-01, -3.854e-02) * s0_1_2;
	r0 += V4(-1.214e-03, -3.737e-02, -3.454e-02, 2.390e-02) * s0_2_0;
	r1 += V4(-3.435e-03, 1.213e-02, 1.004e-01, 2.782e-03) * s0_2_0;
	r2 += V4(1.367e-02, -2.685e-02, 5.416e-02, -1.064e-03) * s0_2_0;
	r3 += V4(-1.073e-04, 6.851e-02, -3.380e-02, -4.146e-02) * s0_2_0;
	r0 += V4(2.554e-02, -3.787e-02, 1.072e-01, -3.989e-02) * s0_2_1;
	r1 += V4(-2.676e-02, -1.329e-02, 3.959e-03, -1.080e-01) * s0_2_1;
	r2 += V4(-1.568e-02, 7.774e-02, -4.529e-02, -8.814e-02) * s0_2_1;
	r3 += V4(-1.695e-02, 6.310e-01, -1.190e-02, 4.941e-02) * s0_2_1;
	r0 += V4(-1.136e-01, -2.241e-02, 1.603e-01, 5.764e-03) * s0_2_2;
	r1 += V4(6.791e-03, -7.158e-02, -1.655e-02, 9.945e-02) * s0_2_2;
	r2 += V4(2.137e-03, 3.491e-03, 8.381e-02, 9.264e-02) * s0_2_2;
	r3 += V4(1.743e-02, 9.058e-02, -1.358e-01, 9.263e-03) * s0_2_2;
	r0 += V4(1.632e-02, -1.462e-02, 4.336e-03, 1.858e-03);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-1.004e+00, -1.225e-03, 2.959e-02, 1.617e-02);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(5.447e-06, 2.543e-03, 4.396e-02, -1.157e-02);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r2));
	r3 += V4(-1.267e-02, 1.800e-02, 2.404e-02, 5.023e-03);
	r3 = clamp(r3, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r3));
}

//!DESC CuNNy-4x16-DS-conv1
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND in
//!BIND LUMA
//!SAVE conv1
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
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
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * in_pt;
			r = in_gather(p, 0);
			g = in_gather(p, 1);
			b = in_gather(p, 2);
			a = in_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xBC0DB03F, 0xFBF1FF14, 0xD7BC0BD2, 0x27C11BE9);
	r1 = D(r1, s0_0_0, 0x18F003EA, 0xD7DFFDDB, 0x06150B02, 0x09271CE1);
	r2 = D(r2, s0_0_0, 0xF3D51203, 0xBACD22D0, 0x21C52AFA, 0xF1FBFF06);
	r3 = D(r3, s0_0_0, 0xF8D9251A, 0x1CEF18F6, 0x3DFE06EF, 0xFFCEF143);
	r0 = D(r0, s0_0_1, 0x53F1F9E0, 0xFB01E608, 0xFDEB66E5, 0xC7F1342A);
	r1 = D(r1, s0_0_1, 0xDFF71D16, 0x12CF6BC6, 0x0CEF0602, 0x30DE061A);
	r2 = D(r2, s0_0_1, 0xF2FEF50A, 0xFF001500, 0x01F80CEA, 0x08F514F6);
	r3 = D(r3, s0_0_1, 0xDCCEEE0F, 0x1CF60004, 0x080A1EF8, 0x17FF99FD);
	r0 = D(r0, s0_0_2, 0x13EF3507, 0xFFFBFE01, 0x2F3CE5F9, 0x2ED1C609);
	r1 = D(r1, s0_0_2, 0xF7EDE6FF, 0x012FF10E, 0x03030306, 0xF502DB04);
	r2 = D(r2, s0_0_2, 0x09FFE805, 0x24F5F5FF, 0x250039FF, 0x03F60603);
	r3 = D(r3, s0_0_2, 0x19011800, 0xFFF3FEFF, 0x12FB0800, 0xFA0426F9);
	r0 = D(r0, s0_1_0, 0x3F291114, 0xDB1B11E4, 0x0221F00E, 0xF13DFD9C);
	r1 = D(r1, s0_1_0, 0xEA24F9D0, 0xF93204DF, 0x63F5F5E4, 0x1E16FBC6);
	r2 = D(r2, s0_1_0, 0x810A21E0, 0xE7161A81, 0x8114F31F, 0xEB08FD0D);
	r3 = D(r3, s0_1_0, 0x812C2601, 0x25480700, 0x02E1EA39, 0x0C00F623);
	r0 = D(r0, s0_1_1, 0x3AE002E3, 0xF6F339FB, 0xD2D30417, 0x132CF9CE);
	r1 = D(r1, s0_1_1, 0x91F715F0, 0x282BEE1B, 0xED060F10, 0x2EE2520A);
	r2 = D(r2, s0_1_1, 0xFFCDD2F3, 0x070EC4DF, 0x0FFAFB1E, 0xF31321CF);
	r3 = D(r3, s0_1_1, 0x0EEB04FA, 0x01053F0E, 0x24FEBAFE, 0xE8F52D1C);
	r0 = D(r0, s0_1_2, 0xEDF433FA, 0x02F0FC04, 0x64EE0630, 0x272B0E0B);
	r1 = D(r1, s0_1_2, 0x19F425FF, 0xFAD92705, 0x1213FCFF, 0x1908F501);
	r2 = D(r2, s0_1_2, 0x04FD1007, 0x11011E01, 0x0923FBFD, 0xE811F909);
	r3 = D(r3, s0_1_2, 0x0F0307FB, 0x0B01F501, 0x0D010EFD, 0x0708E807);
	r0 = D(r0, s0_2_0, 0x3D141CE6, 0x100720C9, 0xDA11F91D, 0xE2DF0020);
	r1 = D(r1, s0_2_0, 0x212218E9, 0x0FDB6B81, 0xFEF9FA04, 0xCBFFF6D6);
	r2 = D(r2, s0_2_0, 0x190BFB10, 0x21FE0CF9, 0xDDE5FE24, 0xE7EFFF03);
	r3 = D(r3, s0_2_0, 0xEF1623DB, 0xF4DD0C15, 0x241A00FD, 0x0F14F941);
	r0 = D(r0, s0_2_1, 0x010506BA, 0x02F9CEEE, 0xED3C3AC2, 0x400816CD);
	r1 = D(r1, s0_2_1, 0x00F781E9, 0x0B14127F, 0xFFFDFC24, 0x01FE16FF);
	r2 = D(r2, s0_2_1, 0xFA0E04FC, 0xF71114FE, 0xF809104F, 0xF40BF50C);
	r3 = D(r3, s0_2_1, 0x02091A10, 0x09F9E0F3, 0x06FBE5D0, 0x0403DD02);
	r0 = D(r0, s0_2_2, 0xD9F05DFB, 0x04F92CFC, 0x10E8E610, 0xFFF33805);
	r1 = D(r1, s0_2_2, 0xCD022CF8, 0x4DF981F5, 0xFFFFF906, 0xFBEF0B01);
	r2 = D(r2, s0_2_2, 0x0503F000, 0x08FEF303, 0x05FDFA03, 0xF0FA03FD);
	r3 = D(r3, s0_2_2, 0x1CFB0C01, 0x0BFF17FD, 0xFFFFFAF9, 0x05F605FB);
	r0 = D(r0, s1_0_0, 0x81D6D901, 0xF901F8F7, 0x3E21E913, 0xCFEEB1DB);
	r1 = D(r1, s1_0_0, 0xFD03FCCA, 0x8124ECED, 0x110CFFFD, 0xECFA0FE5);
	r2 = D(r2, s1_0_0, 0xF1F5F0F7, 0x450EB3ED, 0xEF08C900, 0xF901E7F5);
	r3 = D(r3, s1_0_0, 0x030717FB, 0xF4F7E0FD, 0x000B00FC, 0xCA021D05);
	r0 = D(r0, s1_0_1, 0x9D2B040D, 0x0204F4FC, 0xFA1AF3DD, 0xCBEF0F03);
	r1 = D(r1, s1_0_1, 0xF612DA7F, 0x21290C00, 0x0EFC1208, 0x0FCEFF06);
	r2 = D(r2, s1_0_1, 0x17A800DE, 0x01CE1EC1, 0x18C00A0F, 0x1710ECF3);
	r3 = D(r3, s1_0_1, 0x10FB041A, 0xF4D91A14, 0xE2EE0E24, 0x04E7E934);
	r0 = D(r0, s1_0_2, 0xCBD91F28, 0x0BF403FE, 0x26A7FF31, 0x103EE381);
	r1 = D(r1, s1_0_2, 0x10CEDC81, 0x0112FEF0, 0x1203F000, 0x45F5FBA9);
	r2 = D(r2, s1_0_2, 0xF824EC3D, 0x001BE7F2, 0xE01EE731, 0xEA05EB18);
	r3 = D(r3, s1_0_2, 0xFF14F108, 0x1306F51F, 0xED1C0B1B, 0xF7F8FD4A);
	r0 = D(r0, s1_1_0, 0xD10B0846, 0x3B09D9FF, 0x28041009, 0x59F60C09);
	r1 = D(r1, s1_1_0, 0xFA1D6A62, 0x60C01716, 0x81F4F212, 0x8116E4F3);
	r2 = D(r2, s1_1_0, 0xBA1245BF, 0x38050904, 0x1402250A, 0x02FDFA08);
	r3 = D(r3, s1_1_0, 0x981DE015, 0x1EFC9BF5, 0x08FE19FC, 0x3D04E0CE);
	r0 = D(r0, s1_1_1, 0xD7ED2C30, 0xD6F50DF9, 0x81CE0FA0, 0x81B64E3A);
	r1 = D(r1, s1_1_1, 0xCA64E80A, 0x0CEDDDCD, 0xCB2EF3F6, 0x812B0258);
	r2 = D(r2, s1_1_1, 0x2570DF16, 0x41E74506, 0x49371A94, 0x472442FF);
	r3 = D(r3, s1_1_1, 0xFB0D167F, 0x180E4F01, 0x18D30F79, 0xE9F12336);
	r0 = D(r0, s1_1_2, 0x2ADAE5AD, 0xE22AF4C4, 0x920E087F, 0x0BE112E0);
	r1 = D(r1, s1_1_2, 0xDE031A81, 0xF1F42E7F, 0xE83105D4, 0xD42F020B);
	r2 = D(r2, s1_1_2, 0x19B7077F, 0x08FE205A, 0x0EFB1C42, 0x3CC316EF);
	r3 = D(r3, s1_1_2, 0xFD42E27F, 0xF509F8A1, 0x2BF10A56, 0xEF1809F4);
	r0 = D(r0, s1_2_0, 0x331015E0, 0xC6FB3304, 0x24F2C522, 0x1128D113);
	r1 = D(r1, s1_2_0, 0xF0F40ACA, 0xDE18EFDB, 0xE6F52109, 0xD7E92CEC);
	r2 = D(r2, s1_2_0, 0xFD100E06, 0x1C0CD0FF, 0x020803E0, 0xE506FF06);
	r3 = D(r3, s1_2_0, 0xED0020D7, 0x02FEF2DC, 0x1B09F703, 0x08FA0ADB);
	r0 = D(r0, s1_2_1, 0x28C1E1BC, 0x2E2C0A0C, 0x2617FCBB, 0x26FA1A0E);
	r1 = D(r1, s1_2_1, 0xECF2F93D, 0xD9E311EC, 0xFE0B02FA, 0xEA20F71D);
	r2 = D(r2, s1_2_1, 0xE1F637E2, 0xF0ED1729, 0x26080BED, 0xF003F102);
	r3 = D(r3, s1_2_1, 0x18070F24, 0x15041CDE, 0xFBDDF829, 0x04F4FE2D);
	r0 = D(r0, s1_2_2, 0x42F00112, 0x1CD1F837, 0x40D93919, 0xEDF61000);
	r1 = D(r1, s1_2_2, 0x08DDE98F, 0xFB1909CD, 0x0FDFF9F6, 0x1EF3F0F9);
	r2 = D(r2, s1_2_2, 0xFD26FA10, 0xEA0E011D, 0xF8DEF4C3, 0xFFFFEF00);
	r3 = D(r3, s1_2_2, 0x0805FC36, 0x0E0603DC, 0xE111F070, 0x1EF1F081);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x5D0759F5, 0x0504FFFE, 0xB7090100, 0x03FE0205);
	r1 = D(r1, s0_0_0, 0x04070705, 0x6D282AE6, 0xECF8FDFA, 0x0E0EDF05);
	r2 = D(r2, s0_0_0, 0x14F008FF, 0xCFFDEFFD, 0x1201F5F5, 0x0AFF02FA);
	r3 = D(r3, s0_0_0, 0xFE01F7EE, 0x0AF8FDF7, 0x06051303, 0x1BF6F905);
	r0 = D(r0, s0_0_1, 0x6AD604D4, 0x09F211FC, 0xCFED15E5, 0x35F0B90F);
	r1 = D(r1, s0_0_1, 0x22D320FD, 0xE781BBEF, 0xEF0601EB, 0xFDEE0515);
	r2 = D(r2, s0_0_1, 0xF7F90CFF, 0x17071802, 0x001102F6, 0xF1F102F8);
	r3 = D(r3, s0_0_1, 0x0F08EDF9, 0xFEED07F4, 0x091AE514, 0xDB065CF0);
	r0 = D(r0, s0_0_2, 0x372AE0CF, 0xF6FFFBFB, 0xC507FD32, 0xE904F52B);
	r1 = D(r1, s0_0_2, 0xF21A0DEF, 0xE926242E, 0xF0F3FC00, 0xAE0B0BF9);
	r2 = D(r2, s0_0_2, 0x03F90E04, 0x071C0AFE, 0x35DFF7E8, 0x1AFC0201);
	r3 = D(r3, s0_0_2, 0x0801FBF0, 0xEDE70E03, 0x0B0B170C, 0x0EFEFAE4);
	r0 = D(r0, s0_1_0, 0x2C1A0CC0, 0xCC01F8F4, 0xB9EFF4ED, 0xAE073622);
	r1 = D(r1, s0_1_0, 0xDBE6DE0D, 0xC5E6EE28, 0x7509E507, 0x7FFDEF01);
	r2 = D(r2, s0_1_0, 0x4BFCED18, 0xE401E4FA, 0xFCEAD8F3, 0xF6FCF301);
	r3 = D(r3, s0_1_0, 0x67F3DFFC, 0xE2F0D602, 0xF1F0230C, 0xC301F3FC);
	r0 = D(r0, s0_1_1, 0x3714FA18, 0x0F0DF200, 0x4FF0F2EA, 0x37573CBD);
	r1 = D(r1, s0_1_1, 0x2D0A7F17, 0xFBE1FD43, 0x37F8172D, 0x7F81FC05);
	r2 = D(r2, s0_1_1, 0xD903F62E, 0xA50506F3, 0xAD043FFD, 0x13F101F8);
	r3 = D(r3, s0_1_1, 0xBC200AB2, 0xECD11714, 0x172538DC, 0x1602DC2E);
	r0 = D(r0, s0_1_2, 0xCD091BE3, 0x232407FC, 0x5E1007D6, 0x0D30FC11);
	r1 = D(r1, s0_1_2, 0x267F22C8, 0xF8813581, 0x16F511E9, 0x2C0D11EE);
	r2 = D(r2, s0_1_2, 0xE1811588, 0xEAF90EE1, 0xE7E411BF, 0xBD0F2405);
	r3 = D(r3, s0_1_2, 0x12D109D3, 0x0FF9091C, 0xD813FD2E, 0x1401FA28);
	r0 = D(r0, s0_2_0, 0xEA120EDE, 0x31F30D06, 0xDCFFFBF9, 0xFBFDFD0C);
	r1 = D(r1, s0_2_0, 0x1CEFDF01, 0x02ED11EB, 0x16000402, 0x2504E3FF);
	r2 = D(r2, s0_2_0, 0x02F3110A, 0xDFFFF5FA, 0x1309FEFF, 0x1EF9FB01);
	r3 = D(r3, s0_2_0, 0x24F6DCFE, 0xFD02FFFB, 0xEDEE0208, 0xFD100EF8);
	r0 = D(r0, s0_2_1, 0xD10209EB, 0xD606FAF3, 0xAB07EF01, 0xD8F2EDE8);
	r1 = D(r1, s0_2_1, 0x39FCDC81, 0x252D05F8, 0x11FAFDFD, 0x11030C29);
	r2 = D(r2, s0_2_1, 0x1E2204EE, 0x15F7F20B, 0xF000F8DC, 0x1EFAFC04);
	r3 = D(r3, s0_2_1, 0x050E12F9, 0xEDF9F2FC, 0xF0F60F0C, 0xFB00E8E5);
	r0 = D(r0, s0_2_2, 0xB4E7F8F4, 0xE1E60207, 0x930107F0, 0x1116004C);
	r1 = D(r1, s0_2_2, 0xFB0AFB19, 0x1421E908, 0xF313FBD9, 0xE41209FD);
	r2 = D(r2, s0_2_2, 0x0A0405FE, 0x25FFFB0C, 0x1420EEA9, 0xFFFFFAF7);
	r3 = D(r3, s0_2_2, 0xF806FDF2, 0xF5E6F706, 0x1C02202F, 0xDE0E0705);
	r0 = D(r0, s1_0_0, 0xF846B607, 0xFB0A0002, 0xD2EF110B, 0x27E4FD15);
	r1 = D(r1, s1_0_0, 0xFE19F905, 0xD432C111, 0xF91BE6FF, 0xFF3501F8);
	r2 = D(r2, s1_0_0, 0xE7121B03, 0xF8E30B02, 0xF51BD303, 0x040BFE06);
	r3 = D(r3, s1_0_0, 0xE6212FFE, 0xF11EFE01, 0xFEE91BFB, 0xF61AFCFC);
	r0 = D(r0, s1_0_1, 0xD3E6052F, 0xFBFC0304, 0x0500EE0F, 0xF9E84CE7);
	r1 = D(r1, s1_0_1, 0xE7200505, 0x14AAF02F, 0x01060909, 0x0DCCFDF9);
	r2 = D(r2, s1_0_1, 0x15D4F20C, 0x0FCE4BFF, 0x061AE915, 0xF7E91500);
	r3 = D(r3, s1_0_1, 0xF7F5161D, 0x0D00EB0B, 0x0102CC07, 0x0D258119);
	r0 = D(r0, s1_0_2, 0xF4EFDD35, 0xFF050505, 0x21EDB8FB, 0x09D9EBE1);
	r1 = D(r1, s1_0_2, 0x0506F408, 0xDB0DFD1E, 0x05FCFEF6, 0x03130BF4);
	r2 = D(r2, s1_0_2, 0x0BEBFDF7, 0x15D9E5ED, 0x03DEF104, 0xFFFC0804);
	r3 = D(r3, s1_0_2, 0x03E00EF5, 0xFC0302FB, 0x07EB020D, 0xF905EF06);
	r0 = D(r0, s1_1_0, 0xD1E0BB4B, 0x06F11707, 0xCD2304FB, 0xB2FEBAFA);
	r1 = D(r1, s1_1_0, 0x340510FC, 0xCDF1FD15, 0x23471117, 0xE96C26FB);
	r2 = D(r2, s1_1_0, 0xC5F7E1F1, 0xE8EF0CEB, 0x0CE72024, 0x1DF60303);
	r3 = D(r3, s1_1_0, 0xE1443108, 0x0B1A080E, 0x0803F3F3, 0xFDF30213);
	r0 = D(r0, s1_1_1, 0x1BA204DA, 0xF60241ED, 0xC135CF18, 0xF33AC242);
	r1 = D(r1, s1_1_1, 0x81FFFF81, 0x55ED26D8, 0xF206EAE9, 0xF3D60418);
	r2 = D(r2, s1_1_1, 0x18390D1F, 0x1E3004CE, 0xB10EE80C, 0xF5CB18DF);
	r3 = D(r3, s1_1_1, 0xC522191A, 0xEBF60BFC, 0xF0C3BF18, 0xF4EEDE40);
	r0 = D(r0, s1_1_2, 0xF71C0BF9, 0x02F5FFFB, 0x598D3EE9, 0x38B2DD01);
	r1 = D(r1, s1_1_2, 0xF2E6E9F9, 0xAC02047F, 0xFCE9FCFC, 0x03DCEC14);
	r2 = D(r2, s1_1_2, 0x0F05FF1D, 0x19FFFCEA, 0xF9F3FC0C, 0xFD1423F9);
	r3 = D(r3, s1_1_2, 0x1BE2F61D, 0x03ECF505, 0x14F10405, 0xF9F2F0DD);
	r0 = D(r0, s1_2_0, 0xF5DAE74B, 0xD7FE03FB, 0xE0FC1511, 0xE8EC02DE);
	r1 = D(r1, s1_2_0, 0xFDF00007, 0xEB28FA11, 0x0BE70005, 0xD7020704);
	r2 = D(r2, s1_2_0, 0x0DF90502, 0xEA0004F8, 0xD3ED03F4, 0xFD0C0306);
	r3 = D(r3, s1_2_0, 0xE3010204, 0xFDFB04FC, 0x1D180002, 0x03F90BFE);
	r0 = D(r0, s1_2_1, 0xF7F00924, 0x7A02070F, 0x0623F5E1, 0x51DD1E17);
	r1 = D(r1, s1_2_1, 0x07FB0FFD, 0x141E18D5, 0xDEF907FA, 0x14F4F7C0);
	r2 = D(r2, s1_2_1, 0xD20901E2, 0x041D07FE, 0xB4E01904, 0x15F4FCED);
	r3 = D(r3, s1_2_1, 0x16FEF8CE, 0xFDFF05FF, 0x3021F010, 0x20FBF902);
	r0 = D(r0, s1_2_2, 0xC8280348, 0xE2FFFD03, 0x5EF1F4F2, 0x1F26FCE2);
	r1 = D(r1, s1_2_2, 0xF33803FF, 0xFFBAFFE1, 0xEA030B10, 0x0C03FF1F);
	r2 = D(r2, s1_2_2, 0x3CF8FA8B, 0x10EEF9F6, 0xE2000237, 0xF30E0217);
	r3 = D(r3, s1_2_2, 0xFCEC06FA, 0xFEF903FF, 0x3B02F7DA, 0xF4030630);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(7.821e-02, -1.181e-02, 2.486e-02, 5.901e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(1.066e-02, 1.157e-02, 1.048e-02, 1.067e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-6.791e-02, 2.061e-02, 2.751e-02, 2.634e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-1.610e-02, 7.276e-02, 3.187e-02, 5.688e-03);
	f3 = clamp(f3, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-DS-conv2
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv1
//!BIND LUMA
//!SAVE conv2
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
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
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv1_pt;
			r = conv1_gather(p, 0);
			g = conv1_gather(p, 1);
			b = conv1_gather(p, 2);
			a = conv1_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x040A02F8, 0x00F4FB06, 0xFD02F410, 0x13F2FAD3);
	r1 = D(r1, s0_0_0, 0xFE0F0EE1, 0xFFF9E207, 0x05100AFC, 0xFD10ECFA);
	r2 = D(r2, s0_0_0, 0x102FE90A, 0x101FBE0F, 0x090EE0FA, 0xF9F9AB12);
	r3 = D(r3, s0_0_0, 0xFDF70803, 0x09FEF215, 0x000A08FE, 0x030307DF);
	r0 = D(r0, s0_0_1, 0xF54739B4, 0x070914F8, 0x07089201, 0x04F5F0DA);
	r1 = D(r1, s0_0_1, 0x0E047008, 0x08FE2FF1, 0x000B0E0C, 0xF7062C03);
	r2 = D(r2, s0_0_1, 0x12FD81DA, 0xFCD781DC, 0x0EFF8103, 0x02F51605);
	r3 = D(r3, s0_0_1, 0x0009F309, 0x070915ED, 0xF70AFFF7, 0x08F517FF);
	r0 = D(r0, s0_0_2, 0x12560E14, 0x03060D11, 0x0EF2FDF8, 0xFAF20ACC);
	r1 = D(r1, s0_0_2, 0xE6DDB0DA, 0x00FE0D04, 0x00050000, 0xFD080208);
	r2 = D(r2, s0_0_2, 0x111C13F2, 0x0DF0DD06, 0x09F804E8, 0x01F4EAF8);
	r3 = D(r3, s0_0_2, 0x0106E1FE, 0x0217EE08, 0x070A4307, 0x05E806E3);
	r0 = D(r0, s0_1_0, 0xE4AC1930, 0x0AF60B03, 0x07F2F800, 0x26FDF4C4);
	r1 = D(r1, s0_1_0, 0xFBFC24FC, 0xFC02FE02, 0x040405FD, 0xFAF0F00B);
	r2 = D(r2, s0_1_0, 0x0C17FF05, 0x1A3E01D6, 0x1527EDEE, 0xFDFFE0E4);
	r3 = D(r3, s0_1_0, 0xFFFB03FC, 0xFF100A0A, 0xF8FD06FC, 0x17C2DB07);
	r0 = D(r0, s0_1_1, 0xEE26C4FE, 0x0EFF34FF, 0x1E0B3009, 0x23D522A0);
	r1 = D(r1, s0_1_1, 0x29DE4DE5, 0x0E13EFEF, 0x0C0E222A, 0xEB0431F8);
	r2 = D(r2, s0_1_1, 0x17DFA82E, 0x042619D1, 0x0C05211E, 0xF1F80103);
	r3 = D(r3, s0_1_1, 0x04031015, 0x1B0021FD, 0x02E8EE19, 0x0C0A1409);
	r0 = D(r0, s0_1_2, 0xE042E2E1, 0x081114F8, 0x16EDEBFA, 0x0DFA10D8);
	r1 = D(r1, s0_1_2, 0x15E325BA, 0xF2081B02, 0x0A010900, 0xED0AF600);
	r2 = D(r2, s0_1_2, 0x33F7F3CA, 0x110AEF24, 0x13F7FDE2, 0xFBFF0FFB);
	r3 = D(r3, s0_1_2, 0x0CFEC606, 0x140BF4FE, 0xFB020308, 0x12FE06DA);
	r0 = D(r0, s0_2_0, 0x0133B77D, 0xF249FFFB, 0x11F20008, 0x1FF6F79B);
	r1 = D(r1, s0_2_0, 0xFAE9F418, 0xFE0509F7, 0x0401070B, 0xF1EDF103);
	r2 = D(r2, s0_2_0, 0x0071FE05, 0x1806FC05, 0x1012030A, 0x070B050F);
	r3 = D(r3, s0_2_0, 0x02FC0505, 0xFCF9FC09, 0xFFFD0200, 0x0013EEED);
	r0 = D(r0, s0_2_1, 0xF445A1A5, 0x0D03E5CC, 0x030B0CD4, 0x09FCFFB0);
	r1 = D(r1, s0_2_1, 0xE8EFFD26, 0x05F9FB02, 0xFD060607, 0x0600D622);
	r2 = D(r2, s0_2_1, 0x1735CBB8, 0xF8182E28, 0x01FF0FFF, 0x000807FC);
	r3 = D(r3, s0_2_1, 0x0A0C0507, 0x0F060305, 0xF114FC01, 0x06F700D7);
	r0 = D(r0, s0_2_2, 0xEEF706B8, 0xFE0EE808, 0x030CFFF8, 0x08F913D5);
	r1 = D(r1, s0_2_2, 0x0AEFF62B, 0xFA0307FF, 0x03FDFCF8, 0x04F7E602);
	r2 = D(r2, s0_2_2, 0x14EDCDA9, 0x0811050A, 0x0CFCEC05, 0x0110F805);
	r3 = D(r3, s0_2_2, 0xFFF8F905, 0xFA0201F0, 0x09060002, 0x0E0404F9);
	r0 = D(r0, s1_0_0, 0x8109FEE5, 0x08FF09FA, 0xEF0C0207, 0x19F918F6);
	r1 = D(r1, s1_0_0, 0xFFF303FE, 0xFBFCFD00, 0xFC00030C, 0xFDE2FE18);
	r2 = D(r2, s1_0_0, 0xF5140FED, 0xC417F924, 0xDF0AF516, 0xCAF9F7F9);
	r3 = D(r3, s1_0_0, 0x020401FF, 0xDE1AFF06, 0x0105F806, 0x27E406F2);
	r0 = D(r0, s1_0_1, 0xF4F33AF8, 0x04F5FE01, 0xD004F417, 0x15F304E8);
	r1 = D(r1, s1_0_1, 0xF5F81A1C, 0xFD000106, 0xF3F70219, 0x0208FA0C);
	r2 = D(r2, s1_0_1, 0x57DF0BAC, 0xBFBAF71E, 0xD9FEED14, 0x29DFED0A);
	r3 = D(r3, s1_0_1, 0x14F60404, 0xE3150EF2, 0xFEE0F614, 0x1BF00CE9);
	r0 = D(r0, s1_0_2, 0x45DA32FD, 0xF90B0500, 0xCD200002, 0x06F5F104);
	r1 = D(r1, s1_0_2, 0xF0030836, 0xF714000F, 0xE7150302, 0xFA000711);
	r2 = D(r2, s1_0_2, 0x1201FCF8, 0xD51A07EE, 0xE5FE01FC, 0x03F306F7);
	r3 = D(r3, s1_0_2, 0xF6F6F805, 0x19EF030A, 0x03F41602, 0x21D0FCF3);
	r0 = D(r0, s1_1_0, 0x07DF3481, 0x0B07FCDF, 0xFB0C0605, 0x1CE2090E);
	r1 = D(r1, s1_1_0, 0x1FFA07EE, 0x0101FCF4, 0xFF050302, 0xF0020323);
	r2 = D(r2, s1_1_0, 0xE5F305F6, 0xE1E5F803, 0xF3F4FC1D, 0x1ACDFAF6);
	r3 = D(r3, s1_1_0, 0x030A05FE, 0xF918010C, 0x00FBF7FA, 0x0215FF13);
	r0 = D(r0, s1_1_1, 0x07135BDE, 0x2B26FEC6, 0xD60AF446, 0x1DCBF6E2);
	r1 = D(r1, s1_1_1, 0xB26D16A8, 0xE822FE01, 0xF0030D06, 0x223406FA);
	r2 = D(r2, s1_1_1, 0x811A0934, 0xF6EFFBAD, 0xBD0DF04E, 0xFE300419);
	r3 = D(r3, s1_1_1, 0x12FC00CD, 0xED3604EA, 0x1AE4EB0B, 0x20EE04ED);
	r0 = D(r0, s1_1_2, 0x32C62E03, 0x020F00F5, 0xB12E01F8, 0x20E001FC);
	r1 = D(r1, s1_1_2, 0xE259120F, 0xF34CFB13, 0xDA3C0510, 0x1C0E0821);
	r2 = D(r2, s1_1_2, 0x37EC1BF3, 0xF6160BF6, 0xC42104F7, 0xF616FAFD);
	r3 = D(r3, s1_1_2, 0xEDC8FED8, 0x090AFEF3, 0x29EC15ED, 0x2AF102FC);
	r0 = D(r0, s1_2_0, 0x1DCF35DF, 0xF9F0FFFB, 0x021507FC, 0x24F014EE);
	r1 = D(r1, s1_2_0, 0x07E80316, 0x010201FB, 0x0AFE0801, 0xF2F2F710);
	r2 = D(r2, s1_2_0, 0x05070D1B, 0x06061F12, 0xFB12FDFE, 0x03FE0808);
	r3 = D(r3, s1_2_0, 0xFD0704FD, 0x02F80F00, 0xFAFFFB05, 0xE709FB08);
	r0 = D(r0, s1_2_1, 0xEA0A46F0, 0xC703F1BC, 0xF0FE0014, 0x41D8DB17);
	r1 = D(r1, s1_2_1, 0x20F014FD, 0xEE10FDFE, 0x0B020904, 0xF5FCFC05);
	r2 = D(r2, s1_2_1, 0x97D71C4B, 0x1E1329EA, 0x0DF9FD11, 0x00FC1009);
	r3 = D(r3, s1_2_1, 0x10F40BF7, 0x020A06FE, 0xFDF40610, 0x0F0001FF);
	r0 = D(r0, s1_2_2, 0x813D0731, 0x23AE07F9, 0xCF15F8F8, 0x22FC11FD);
	r1 = D(r1, s1_2_2, 0xEE1A0012, 0xFB0A02F9, 0xFA020106, 0x03F70802);
	r2 = D(r2, s1_2_2, 0xD80728DC, 0xF41E1811, 0xF6F704F3, 0x00F4FDFE);
	r3 = D(r3, s1_2_2, 0xD809EF00, 0xF901FB02, 0xF015FEF3, 0x29F112FA);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xE7DD0019, 0x0CFF01F1, 0xFE0405F3, 0xE6F8FCF9);
	r1 = D(r1, s0_0_0, 0x5200FEE3, 0x04FFFE05, 0x0006FB01, 0xEDFFF609);
	r2 = D(r2, s0_0_0, 0x0D0A1205, 0xEC06DD16, 0xE315FA0F, 0xBE0BD925);
	r3 = D(r3, s0_0_0, 0xF804FDF9, 0x22010FF8, 0x0704F405, 0x13F3F603);
	r0 = D(r0, s0_0_1, 0x1BFA03BF, 0x0202F3FE, 0x2BF8FBF0, 0xF2FC04F2);
	r1 = D(r1, s0_0_1, 0xC408CEC4, 0x060D05F9, 0x0AEA05EE, 0x0EF5F705);
	r2 = D(r2, s0_0_1, 0xFF36FFFF, 0xE70EF310, 0xEF1AF721, 0x0138F317);
	r3 = D(r3, s0_0_1, 0x06F10500, 0x0519FEEB, 0x33FEFBED, 0x1A22F115);
	r0 = D(r0, s0_0_2, 0x1505DAF0, 0xFB0105F3, 0x040FF704, 0x0C00F01E);
	r1 = D(r1, s0_0_2, 0x0A8820AF, 0xF6FAFF02, 0x08F6F5F3, 0xFAFBF5FA);
	r2 = D(r2, s0_0_2, 0xF5FE02F8, 0xE60B05F1, 0xF30704FC, 0xF10B02EE);
	r3 = D(r3, s0_0_2, 0x000EF405, 0x0EF5FEEF, 0xFD0C00FF, 0xEF23FAF8);
	r0 = D(r0, s0_1_0, 0xDAF2FAE3, 0x08130204, 0xF20702F4, 0x57EEFC09);
	r1 = D(r1, s0_1_0, 0xD026F6FB, 0xEDFC08FE, 0x180B02F4, 0xFB08FB0D);
	r2 = D(r2, s0_1_0, 0xA9DD0D1D, 0x0900090B, 0xDC21EBE9, 0xE6FAE105);
	r3 = D(r3, s0_1_0, 0x1206F900, 0xE3F10FF8, 0x0804FF01, 0x2005E90B);
	r0 = D(r0, s0_1_1, 0xD4D9BBC4, 0x08DC08FC, 0x160822EB, 0x0114D81B);
	r1 = D(r1, s0_1_1, 0x81F8D8C9, 0xE707D713, 0xE01943F2, 0x130702B5);
	r2 = D(r2, s0_1_1, 0xCFB84251, 0x0FF1EF0C, 0xFE19D1EA, 0xFD03E4CF);
	r3 = D(r3, s0_1_1, 0x51F731D5, 0xF609B8FA, 0x0901F902, 0x0001DCD2);
	r0 = D(r0, s0_1_2, 0xF4C7FAC6, 0x0D06E90C, 0x0FEAF504, 0xE913F7ED);
	r1 = D(r1, s0_1_2, 0x38DD02BA, 0x0CDD1CD5, 0x0CE300ED, 0xFBF9190A);
	r2 = D(r2, s0_1_2, 0xD921E3B9, 0xFEF01CA1, 0xFA05DB2A, 0x06F409F1);
	r3 = D(r3, s0_1_2, 0xF11BE43D, 0x10EF15FA, 0x011C1A16, 0x0211FA00);
	r0 = D(r0, s0_2_0, 0x15F8E412, 0xD602E501, 0xEB100604, 0xD9F3E70B);
	r1 = D(r1, s0_2_0, 0x060FFA1E, 0xFF010202, 0xF906FBFA, 0x11FBFEFE);
	r2 = D(r2, s0_2_0, 0x2120F4E7, 0xE60CDB02, 0xE903F00B, 0x07F1F218);
	r3 = D(r3, s0_2_0, 0x050100F7, 0x06F30BF5, 0xFE030008, 0x00EB1AF7);
	r0 = D(r0, s0_2_1, 0x21B43B57, 0x4BB7303C, 0x0212FE1D, 0xF817C3EC);
	r1 = D(r1, s0_2_1, 0xF10526CB, 0xEEFB1009, 0x0B24EBFE, 0x12E207F5);
	r2 = D(r2, s0_2_1, 0x241581F6, 0xF1FCFF04, 0x1011D8FC, 0x050C0D03);
	r3 = D(r3, s0_2_1, 0x0406E802, 0x02FEF312, 0xF9020505, 0xFDE8F1F9);
	r0 = D(r0, s0_2_2, 0x3FEB29F4, 0xDF08DF0C, 0xFDFA0102, 0xFD09F2D2);
	r1 = D(r1, s0_2_2, 0xF8E23BDE, 0xFCF606F6, 0xFA0CE004, 0x06FAFA16);
	r2 = D(r2, s0_2_2, 0x1610A706, 0x17FF0A27, 0x0005DD11, 0x02FCFB00);
	r3 = D(r3, s0_2_2, 0x01F60C18, 0xF9000EE5, 0x0F000EFD, 0x04F9E909);
	r0 = D(r0, s1_0_0, 0x2A1ADF1B, 0xFB06FDF8, 0xF413F700, 0x0415FC00);
	r1 = D(r1, s1_0_0, 0xF0D3FB0D, 0x04F80200, 0xFC06FA00, 0xEFDA1C05);
	r2 = D(r2, s1_0_0, 0x24170010, 0xE407FFF3, 0xF2FC0603, 0xCBEA0114);
	r3 = D(r3, s1_0_0, 0xFD09F9FE, 0x03F5F1FD, 0xFEF1FCFF, 0x0EEEFFF4);
	r0 = D(r0, s1_0_1, 0x21F4FD15, 0x0304FCF9, 0xFED90A08, 0xEF040CFC);
	r1 = D(r1, s1_0_1, 0x252903EB, 0x00FB01F8, 0x00F5200E, 0xFF0700FE);
	r2 = D(r2, s1_0_1, 0x010ECE19, 0xA7DB5536, 0xF5F8020C, 0xDDF10A1F);
	r3 = D(r3, s1_0_1, 0x06FD080D, 0x0B08E4E0, 0x03E91000, 0x100DE1E5);
	r0 = D(r0, s1_0_2, 0x0AFCE0EE, 0xFA0AF911, 0x04FEFCF8, 0x03F6F503);
	r1 = D(r1, s1_0_2, 0x06E20A4C, 0x0402FDFF, 0x03F40E0D, 0x0403ECF4);
	r2 = D(r2, s1_0_2, 0x0D19EE04, 0xE7121F1B, 0xF9100302, 0xFB071611);
	r3 = D(r3, s1_0_2, 0xF3F30D07, 0x0CECFB02, 0x1511EEFE, 0xEDFEF3E1);
	r0 = D(r0, s1_1_0, 0x1D30D5EE, 0x171B04F7, 0xF805F6FD, 0x17F200F0);
	r1 = D(r1, s1_1_0, 0xF83F30EB, 0x05FD0908, 0x020608F8, 0xF1F9FDFE);
	r2 = D(r2, s1_1_0, 0xE3D33612, 0x0CD0240D, 0xE9E71105, 0x101C342A);
	r3 = D(r3, s1_1_0, 0xF807F5F7, 0xEE06F506, 0x0BFA0508, 0x0BF2ED07);
	r0 = D(r0, s1_1_1, 0xF80F3BFF, 0x1921FD0E, 0xF4204305, 0x2E10C9EF);
	r1 = D(r1, s1_1_1, 0x74A0AEDC, 0xF0F8F31B, 0xFBEEDCDE, 0x2F3AD2EF);
	r2 = D(r2, s1_1_1, 0xC20B0EE8, 0x0704F046, 0xE1243909, 0x0A1725EF);
	r3 = D(r3, s1_1_1, 0x111D13FA, 0x232B56E4, 0x08FC18E7, 0x10245DFF);
	r0 = D(r0, s1_1_2, 0xD2E017ED, 0x08F8FFF6, 0xFFE7ED1A, 0xEE110722);
	r1 = D(r1, s1_1_2, 0x81DDD69B, 0x080C13F6, 0xF6FAF808, 0xF318FEE5);
	r2 = D(r2, s1_1_2, 0xE23C17E5, 0xF403FFE3, 0xFDFC020A, 0xFDFAF607);
	r3 = D(r3, s1_1_2, 0xE3F3ECFB, 0x01F9FCFD, 0x2A20E7D5, 0x0A1BEFE9);
	r0 = D(r0, s1_2_0, 0xF0B30F35, 0xF3F10BFD, 0x0D0CED14, 0xEBFDFD1B);
	r1 = D(r1, s1_2_0, 0xE2E91AEA, 0x03FFFC04, 0xFF0CFFFC, 0xDADA1803);
	r2 = D(r2, s1_2_0, 0xCA24E2FC, 0xF0000B09, 0x0A02F41D, 0x0CF3F107);
	r3 = D(r3, s1_2_0, 0x0604F702, 0xFFFAFBFE, 0x04F00002, 0xFBCEFF1A);
	r0 = D(r0, s1_2_1, 0x7F01E845, 0x81B4AD2A, 0xACFEFFF6, 0xE71833F1);
	r1 = D(r1, s1_2_1, 0xF0F11EE8, 0x0CF10407, 0xF227FDE5, 0x05EC191C);
	r2 = D(r2, s1_2_1, 0x81CB092B, 0x4820C8DF, 0xDF08F7FD, 0x210DEA05);
	r3 = D(r3, s1_2_1, 0x050CFBFC, 0x0A060002, 0xE9FE0AFF, 0x08110D17);
	r0 = D(r0, s1_2_2, 0xFDECE6E2, 0x00F82518, 0xF9F4FD05, 0xE51AF6E1);
	r1 = D(r1, s1_2_2, 0xFB08FBFB, 0xF7050209, 0xF2F608FE, 0x0BF20504);
	r2 = D(r2, s1_2_2, 0xC9EF2907, 0x1C12D1F8, 0xF9000A03, 0x02FA090A);
	r3 = D(r3, s1_2_2, 0xFEEAFC11, 0xF9F80C0E, 0x180EEC09, 0x080FEDE4);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(9.426e-04, 2.051e-02, -3.443e-02, 4.614e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(2.640e-02, -4.707e-03, 2.231e-02, -1.792e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(1.242e-02, -1.125e-02, -2.571e-02, -4.941e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-1.575e-02, -2.705e-02, -6.058e-03, -1.294e-02);
	f3 = clamp(f3, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-DS-conv3
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv2
//!BIND LUMA
//!SAVE conv3
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
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
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv2_pt;
			r = conv2_gather(p, 0);
			g = conv2_gather(p, 1);
			b = conv2_gather(p, 2);
			a = conv2_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x120313FB, 0x09FE06FD, 0x0403F407, 0xFC0DF917);
	r1 = D(r1, s0_0_0, 0x08F60E03, 0xF803FB02, 0xFCFC0802, 0xFF04F700);
	r2 = D(r2, s0_0_0, 0xE00FE40B, 0xED10FB0C, 0xE4F3230D, 0x00FA0B02);
	r3 = D(r3, s0_0_0, 0x01FFFE01, 0xF901FD0E, 0xF8FBFB08, 0x04FA02FF);
	r0 = D(r0, s0_0_1, 0xE0F73D08, 0xF6E32202, 0xF9E322FD, 0x0EF21AFC);
	r1 = D(r1, s0_0_1, 0xFB05FD04, 0xBDE7ED1F, 0xC9D80805, 0xFE0005FC);
	r2 = D(r2, s0_0_1, 0x251EFFEC, 0x111616FA, 0x19F7F7EE, 0x07EF2EFE);
	r3 = D(r3, s0_0_1, 0x0A0DEA08, 0x0DF73A00, 0x0AD62FF3, 0xFF0BD9F4);
	r0 = D(r0, s0_0_2, 0xEE17FA10, 0xFEFCFDFF, 0xFB150207, 0xD9D32A15);
	r1 = D(r1, s0_0_2, 0xFA040202, 0xF4F20805, 0xFDEA000F, 0xF302FF00);
	r2 = D(r2, s0_0_2, 0xEFF6100C, 0xF3EF0000, 0xFAE22E24, 0x0CFE050A);
	r3 = D(r3, s0_0_2, 0xFAF80D04, 0xCBF32726, 0xE2050408, 0x0000FFFE);
	r0 = D(r0, s0_1_0, 0x08FAF608, 0x03FE0000, 0xF8091F05, 0xFE0D0BFC);
	r1 = D(r1, s0_1_0, 0x1002FEF7, 0x0FF0F1F3, 0x04ECF606, 0x04050BF9);
	r2 = D(r2, s0_1_0, 0xE3061406, 0xF0010E0B, 0x0722DDCB, 0xFCFAF60C);
	r3 = D(r3, s0_1_0, 0xFD02F8F4, 0x02040A02, 0xF7191B10, 0x07F1F9F6);
	r0 = D(r0, s0_1_1, 0xE3F8EDF1, 0xFBF32A00, 0x16EAF4E8, 0x0FFAE8EB);
	r1 = D(r1, s0_1_1, 0xFA1904F5, 0x04AC17FA, 0xE7CA080C, 0xEF0C32FD);
	r2 = D(r2, s0_1_1, 0xF7CD1F11, 0xF1F9F211, 0x619FA8EA, 0x00EAE208);
	r3 = D(r3, s0_1_1, 0xFD2601F1, 0x0911EBF3, 0x29CF09E3, 0xF412FEFB);
	r0 = D(r0, s0_1_2, 0xEB1809FD, 0xF9F00BF9, 0x03F80BF2, 0xFBE20114);
	r1 = D(r1, s0_1_2, 0x0110FCFD, 0x01F2191C, 0xF1FC0404, 0x07060E01);
	r2 = D(r2, s0_1_2, 0xD0E9EB12, 0xEF08F0FF, 0xE4E8200A, 0xE8DD0308);
	r3 = D(r3, s0_1_2, 0xF40008FE, 0xFA2EFDF2, 0x03F411F0, 0xF90802F9);
	r0 = D(r0, s0_2_0, 0xF7F90100, 0xFAFF04FD, 0x0506F810, 0x06FC0006);
	r1 = D(r1, s0_2_0, 0x0504FDF9, 0xF5F60307, 0xF6F903FB, 0x02050800);
	r2 = D(r2, s0_2_0, 0xFAFC0308, 0xFEF60209, 0x150102D9, 0x03F8FF01);
	r3 = D(r3, s0_2_0, 0x0507FDFB, 0x07FE0206, 0x0E0DF017, 0x02FF02FD);
	r0 = D(r0, s0_2_1, 0x01F9F4F2, 0x02FCF7FC, 0xF6020B0E, 0xFE05F800);
	r1 = D(r1, s0_2_1, 0x080804FE, 0xDF070613, 0xF9F1F4FE, 0x05FF05FE);
	r2 = D(r2, s0_2_1, 0xFBE8FDFB, 0xF0FA0809, 0x0B38ECEC, 0xFDF3F7FE);
	r3 = D(r3, s0_2_1, 0x030203F6, 0x0204FDF6, 0xF1F90B02, 0x0202F9EE);
	r0 = D(r0, s0_2_2, 0x1015FCFE, 0x0B0905FD, 0xFCFE0709, 0xF9FF0C17);
	r1 = D(r1, s0_2_2, 0x0000FB00, 0xDBFEF4F7, 0x05F0FDE1, 0x010104F9);
	r2 = D(r2, s0_2_2, 0xEA0404FE, 0xEB07F805, 0xF20AFF19, 0x00FEFF07);
	r3 = D(r3, s0_2_2, 0xFEFEFB05, 0x010A0210, 0xF8F30A16, 0xFD02F9F9);
	r0 = D(r0, s1_0_0, 0x18FFF2F9, 0x07FCF4FF, 0x0C03F2F5, 0x020305FA);
	r1 = D(r1, s1_0_0, 0x0805FCFF, 0x06F70DF0, 0x0205F7FB, 0x03FC01FF);
	r2 = D(r2, s1_0_0, 0x080809F7, 0x08F7F3FC, 0x091300F6, 0xFD0B15F5);
	r3 = D(r3, s1_0_0, 0x010205FD, 0x0007F506, 0xFB0DEF0C, 0xFB1107FA);
	r0 = D(r0, s1_0_1, 0x321FDCF9, 0x0222FD05, 0x0A14FAEF, 0xFF1F2300);
	r1 = D(r1, s1_0_1, 0x0E0CF600, 0x0C1D07FC, 0xED061804, 0x00FF0500);
	r2 = D(r2, s1_0_1, 0x03E7F600, 0x1BF4E10B, 0x0208F3F8, 0x061001F7);
	r3 = D(r3, s1_0_1, 0x12FAF60D, 0x070CCBF9, 0xF916EB03, 0xF9090611);
	r0 = D(r0, s1_0_2, 0x2909E6F5, 0x0F0AFBF9, 0x0B04FBF3, 0xFF0DFBF8);
	r1 = D(r1, s1_0_2, 0x0500FB01, 0xF9FAFF03, 0xE3FEFD06, 0x03000101);
	r2 = D(r2, s1_0_2, 0x0D03FE00, 0x1112F002, 0x1206FA01, 0x0FF3FCFF);
	r3 = D(r3, s1_0_2, 0x020EFD01, 0x2724E100, 0x0E1AFAF5, 0xFCFE0402);
	r0 = D(r0, s1_1_0, 0x0E13BBFC, 0x0C05EDFC, 0xF6FDFBDF, 0x04F5F106);
	r1 = D(r1, s1_1_0, 0x011B2C09, 0xDB0F0701, 0xF9050300, 0xF8FF0601);
	r2 = D(r2, s1_1_0, 0xE6E9DD06, 0xFBF0E10B, 0x81E7E70E, 0x1801FDEA);
	r3 = D(r3, s1_1_0, 0xF2F7ED0F, 0x07FB0D0C, 0xE9F9DC07, 0xF4EDD90B);
	r0 = D(r0, s1_1_1, 0x042BCFF2, 0x2BC92228, 0xF1E740F5, 0xF6FBE908);
	r1 = D(r1, s1_1_1, 0x0FFAEDE8, 0xFCE31716, 0xED090903, 0xFFF5EBF5);
	r2 = D(r2, s1_1_1, 0xFEFBF60F, 0xE3FF1B08, 0xFC2DD314, 0xE8E63A0D);
	r3 = D(r3, s1_1_1, 0x0CF19034, 0x04D7AFCB, 0xEAE1F025, 0x06EEDCEF);
	r0 = D(r0, s1_1_2, 0x3E09E6FF, 0x0525F4FA, 0x0610FDFB, 0xEF191B05);
	r1 = D(r1, s1_1_2, 0x0CF50001, 0xD3F00B04, 0xF0020101, 0x05FCFB01);
	r2 = D(r2, s1_1_2, 0x02140C03, 0x1202F3FF, 0x21F32014, 0x1108FEF6);
	r3 = D(r3, s1_1_2, 0xFE09140D, 0x37F2FE03, 0xFD07FF05, 0x00E70000);
	r0 = D(r0, s1_2_0, 0xEF07E5F3, 0xFB11F6FF, 0xF7F9EC00, 0x0003F504);
	r1 = D(r1, s1_2_0, 0xFDF6FEFF, 0x05FCE402, 0xF5070401, 0xFC0D0D04);
	r2 = D(r2, s1_2_0, 0x030A0503, 0x0C02FFF1, 0xD2DD34D2, 0x0A0707D8);
	r3 = D(r3, s1_2_0, 0x01F20206, 0xFBFD0405, 0x0AEEFDF7, 0x02FDFE03);
	r0 = D(r0, s1_2_1, 0xF9FFE4FB, 0x07151111, 0xE010F2FA, 0xFF0102FA);
	r1 = D(r1, s1_2_1, 0xFFF8FCFF, 0x00EEECFA, 0xFC0AFEFA, 0xEA161011);
	r2 = D(r2, s1_2_1, 0xFF130E03, 0x1105EFF0, 0xF4CF2914, 0x13FB05FC);
	r3 = D(r3, s1_2_1, 0xF9EFEC0D, 0xF0000202, 0xE2F20202, 0x02FDF5FE);
	r0 = D(r0, s1_2_2, 0x2DEFEDFA, 0xFF08FFFF, 0x0A09F2FE, 0xF908FEFA);
	r1 = D(r1, s1_2_2, 0x09F9FD01, 0x0C08FC00, 0x03010A02, 0xF9090208);
	r2 = D(r2, s1_2_2, 0x0907F7FE, 0x0C01FAEB, 0xEAF21803, 0x0900F9FD);
	r3 = D(r3, s1_2_2, 0x00050606, 0x03E9FE05, 0xFC0C0202, 0x10F602FE);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFDFA0B17, 0xFEF9FD07, 0x00EC0AFE, 0x020600FE);
	r1 = D(r1, s0_0_0, 0x01FF040B, 0x05000208, 0x0102EAFE, 0xFC03FDFD);
	r2 = D(r2, s0_0_0, 0x001808F2, 0xFE1308FC, 0xEE2CFAED, 0x07FEFAF8);
	r3 = D(r3, s0_0_0, 0xFD0E0003, 0xFB070A01, 0xFFFA01F8, 0x0300FF00);
	r0 = D(r0, s0_0_1, 0xE41D141A, 0xF91DFF0A, 0xF3170809, 0xFAD8FC0C);
	r1 = D(r1, s0_0_1, 0xFB030B02, 0xDA1A10E2, 0xFB1AEF05, 0xFE100404);
	r2 = D(r2, s0_0_1, 0x09E8FAE8, 0x01E3F5F0, 0xF409F002, 0x05F90605);
	r3 = D(r3, s0_0_1, 0x06F10206, 0xFD03F823, 0x0613FE0B, 0x0EF0F204);
	r0 = D(r0, s0_0_2, 0xEC011207, 0xFDF90200, 0xFA03FE00, 0x0BE9F404);
	r1 = D(r1, s0_0_2, 0xFE040503, 0x0CF5FC02, 0x0B00F2F9, 0xFC03FE02);
	r2 = D(r2, s0_0_2, 0xFE04FB02, 0xFF03F5FB, 0x091D040E, 0x03FB0405);
	r3 = D(r3, s0_0_2, 0xFF070203, 0xF5212507, 0x0302F600, 0x00010202);
	r0 = D(r0, s0_1_0, 0xF7EB1B1B, 0xFCFBFD0A, 0xFF0203F1, 0x0308F604);
	r1 = D(r1, s0_1_0, 0xFEFE0A0A, 0xF3F11308, 0x10FCF307, 0xFF00FFF2);
	r2 = D(r2, s0_1_0, 0xFA100DFA, 0xF00C09F2, 0x08EF1DE3, 0xF1080A0A);
	r3 = D(r3, s0_1_0, 0x04FF0B08, 0x04FD0700, 0x0EFF05E7, 0x03FDF70B);
	r0 = D(r0, s0_1_1, 0xB1E73416, 0x0518FFFA, 0xFAFB04F7, 0xF1FCFF06);
	r1 = D(r1, s0_1_1, 0x0CDF170C, 0x0108F0CD, 0x2116BCEE, 0x02E505FA);
	r2 = D(r2, s0_1_1, 0x0ED5E0F2, 0x04A3F7DF, 0x03D20C06, 0xD60E1511);
	r3 = D(r3, s0_1_1, 0xF0F6FE0D, 0xFBEA321B, 0x30C9E7E9, 0x131D0006);
	r0 = D(r0, s0_1_2, 0xE9DF1E19, 0x14E60306, 0xEDF109FB, 0x1AD4F2CC);
	r1 = D(r1, s0_1_2, 0xF2FD0307, 0x271408E2, 0x1127EB0D, 0xF3000508);
	r2 = D(r2, s0_1_2, 0xFAE0F1F6, 0x3FD8FBF7, 0xF7E81A0C, 0x1DD50D0D);
	r3 = D(r3, s0_1_2, 0xF0090B06, 0xF7EA210E, 0x25EE1000, 0xFE170403);
	r0 = D(r0, s0_2_0, 0xF4041D09, 0xFEFA02FE, 0x0607FA01, 0x04FE0303);
	r1 = D(r1, s0_2_0, 0xF7F70F07, 0xFF0A140D, 0xFFF8F9F9, 0xFFF4FD00);
	r2 = D(r2, s0_2_0, 0x01FFF8FB, 0xFE0AF4FE, 0x0EF6040C, 0x0AF8FCFC);
	r3 = D(r3, s0_2_0, 0x01F80C01, 0xFC010007, 0x060BF30B, 0x03F5FE03);
	r0 = D(r0, s0_2_1, 0x26EB1414, 0x12ECF8F8, 0x1907F3E8, 0x09120600);
	r1 = D(r1, s0_2_1, 0x05F90D12, 0x0D06FEFC, 0x010CEFF5, 0x02F1FBE3);
	r2 = D(r2, s0_2_1, 0x0CEBF2E7, 0x0203FE00, 0x9F21101D, 0xF5FF0D0E);
	r3 = D(r3, s0_2_1, 0xE8050C0D, 0x04FA0CFF, 0xF218EFE9, 0x04000B0B);
	r0 = D(r0, s0_2_2, 0x1CE71C21, 0x0CE90909, 0x1AFA0902, 0xE616FA09);
	r1 = D(r1, s0_2_2, 0x04FC0302, 0xDE151204, 0x0208F9DE, 0xEAFE03EF);
	r2 = D(r2, s0_2_2, 0xFDF60317, 0x14F80322, 0xFDF4FFEF, 0x24E10E0B);
	r3 = D(r3, s0_2_2, 0xE7FB05FC, 0x0FF8121B, 0xF10F0602, 0x02FE0004);
	r0 = D(r0, s1_0_0, 0x03F60400, 0x01F9FF00, 0x10F0FF0B, 0x01FCF9EF);
	r1 = D(r1, s1_0_0, 0xF902090D, 0x0A070404, 0xFB02FE0C, 0x0301FEFA);
	r2 = D(r2, s1_0_0, 0x00F0F5E6, 0xFBF1FDF1, 0xEFFC1606, 0x07EBF903);
	r3 = D(r3, s1_0_0, 0x02090204, 0xFDF4FF04, 0x0FEFFE15, 0x05FF08F9);
	r0 = D(r0, s1_0_1, 0x10000AE0, 0x06F70603, 0x1B00F8F1, 0x18E4FCEA);
	r1 = D(r1, s1_0_1, 0x08FB0BEC, 0xFF08F0F3, 0xFAFEF5FE, 0xFF03FBF8);
	r2 = D(r2, s1_0_1, 0xFFF80B17, 0xE9F21C1A, 0x11F0F2DE, 0x0DF20411);
	r3 = D(r3, s1_0_1, 0x00F7F6F3, 0xF7111425, 0x17F2EEF5, 0xFC0508EF);
	r0 = D(r0, s1_0_2, 0x06F6FAEB, 0x0BF80CF8, 0x04F5EB05, 0x3BE7EC13);
	r1 = D(r1, s1_0_2, 0xFFFF01FF, 0x0506FC10, 0x0009FF0D, 0x08FEF7FC);
	r2 = D(r2, s1_0_2, 0x00000A04, 0xF7021C01, 0x00080104, 0x02FF05F8);
	r3 = D(r3, s1_0_2, 0x110003FC, 0x1DF7FFFA, 0x1DF4FBF0, 0x06FC0EFD);
	r0 = D(r0, s1_1_0, 0x0BDA0D32, 0x0BFE0A23, 0x16F8FC17, 0xF3FFFF01);
	r1 = D(r1, s1_1_0, 0xF8CAFAD8, 0xEEDC0114, 0x0DE3F816, 0x0BF2FEF0);
	r2 = D(r2, s1_1_0, 0x02170909, 0x00261116, 0xAEEB26AF, 0xF522FE07);
	r3 = D(r3, s1_1_0, 0xF9EFFEF5, 0xFA060C28, 0x05E5FBFB, 0xF30F0807);
	r0 = D(r0, s1_1_1, 0xDFA919D9, 0xE2DD1737, 0xF6E6E6EA, 0x42C8E539);
	r1 = D(r1, s1_1_1, 0x1DFD24F4, 0xFD072606, 0x06094B1F, 0x05FE0407);
	r2 = D(r2, s1_1_1, 0xF704F049, 0xFB04E7E8, 0xD0261608, 0xF2F7D501);
	r3 = D(r3, s1_1_1, 0x20100841, 0xE281F713, 0xF7030545, 0x1E014BDE);
	r0 = D(r0, s1_1_2, 0x08E707E3, 0x14001907, 0x15FBE6F5, 0x1BFC02F9);
	r1 = D(r1, s1_1_2, 0xF9FBFAF8, 0xEE09110F, 0x02F90300, 0xFE0207FB);
	r2 = D(r2, s1_1_2, 0xFE021807, 0xF4000AF8, 0x0EEB320A, 0x1DF70617);
	r3 = D(r3, s1_1_2, 0xFD06FC05, 0xF8F903EB, 0x1B04FBFA, 0xF4F70CF9);
	r0 = D(r0, s1_2_0, 0x08DFFA08, 0x14FE0605, 0x02010416, 0xFE070607);
	r1 = D(r1, s1_2_0, 0x07ECF504, 0x0904FB23, 0xFFFE0104, 0x0801F800);
	r2 = D(r2, s1_2_0, 0x06EC0E09, 0xF2F11106, 0xA0270FD7, 0x0502FF0E);
	r3 = D(r3, s1_2_0, 0xF40C0501, 0xF4FDFF0C, 0xFCF9FB06, 0x00F60B09);
	r0 = D(r0, s1_2_1, 0x0CE607F5, 0x0BFEFE05, 0x2AE6160F, 0x0FF9FEE9);
	r1 = D(r1, s1_2_1, 0xFB040204, 0x13E71821, 0xFB0AFF0E, 0xF90FFAFC);
	r2 = D(r2, s1_2_1, 0xFDFA0DF9, 0xF5FA0EF2, 0xACE8C7DC, 0x12D5E30C);
	r3 = D(r3, s1_2_1, 0xFAF6F808, 0x0A05FD0A, 0x19DC1D28, 0xF105F504);
	r0 = D(r0, s1_2_2, 0xF6F504ED, 0x02020504, 0x0FF4FE00, 0x18FEF6F7);
	r1 = D(r1, s1_2_2, 0xFDFE06FA, 0xF9F90509, 0xF7090604, 0xFC0702FF);
	r2 = D(r2, s1_2_2, 0x040B04FF, 0x08FCFCFA, 0x0320F208, 0x0EFFF10E);
	r3 = D(r3, s1_2_2, 0xFB0916FB, 0xF90600F9, 0x13F80F0C, 0xF6FC04FB);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-2.375e-02, 1.036e-02, -2.018e-02, -3.606e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.004e-02, -2.417e-02, -1.400e-03, -4.897e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-1.569e-02, -1.748e-02, 1.294e-02, -1.214e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(2.844e-03, 1.053e-02, -1.975e-02, 2.844e-03);
	f3 = clamp(f3, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-DS-conv4
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv3
//!BIND LUMA
//!SAVE conv4
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.3 > OUTPUT.h LUMA.h / 1.3 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
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
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv3_pt;
			r = conv3_gather(p, 0);
			g = conv3_gather(p, 1);
			b = conv3_gather(p, 2);
			a = conv3_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFC0AFD00, 0x0114FBFF, 0x04FCFEF7, 0xFF040000);
	r1 = D(r1, s0_0_0, 0xFE0CFC04, 0xFCFC00FE, 0x01F9FBFE, 0xFEFC04F9);
	r2 = D(r2, s0_0_0, 0xF9FAFAFC, 0x04F90600, 0x0610F703, 0xFA050201);
	r3 = D(r3, s0_0_0, 0x06F60100, 0xFD0EFD01, 0x01FA0200, 0x08FDFC02);
	r0 = D(r0, s0_0_1, 0x0003FD15, 0xFC2D00F4, 0x021100D2, 0x0005FC01);
	r1 = D(r1, s0_0_1, 0x02F50301, 0xFC0A01F5, 0xFF0CFFE8, 0x000AFBF4);
	r2 = D(r2, s0_0_1, 0xFC1B01E4, 0xFDF31BF7, 0x011C0209, 0xFD01F20E);
	r3 = D(r3, s0_0_1, 0x020500F3, 0x02FE0502, 0x0400FBF7, 0xFEFE03F4);
	r0 = D(r0, s0_0_2, 0x000DFB03, 0x000FF9FC, 0xFDFA0100, 0x00020400);
	r1 = D(r1, s0_0_2, 0xFE020103, 0x00060300, 0xFF030003, 0x020001FD);
	r2 = D(r2, s0_0_2, 0x000E02F1, 0xFE0203FC, 0xFF03FDFD, 0xFDFE0109);
	r3 = D(r3, s0_0_2, 0x020201F9, 0xFD05FEFE, 0xFF0804F9, 0x01FFFFFC);
	r0 = D(r0, s0_1_0, 0x01F004F6, 0xDBF803F5, 0xF000060B, 0x0007FE04);
	r1 = D(r1, s0_1_0, 0xF2FAFCF0, 0xE602FFFB, 0xE51100F8, 0xE6F615EE);
	r2 = D(r2, s0_1_0, 0x09030BF5, 0xF80321F9, 0xFBF207F2, 0x01F9F00A);
	r3 = D(r3, s0_1_0, 0xF7F408F8, 0x0AE9FDF6, 0x0F04FE06, 0x050301F8);
	r0 = D(r0, s0_1_1, 0x01B518ED, 0x09D910D8, 0xEBDE1FF4, 0x01E10BDE);
	r1 = D(r1, s0_1_1, 0x0004F8C9, 0x06CE19EC, 0x0CAF01BE, 0x05F300D6);
	r2 = D(r2, s0_1_1, 0xCADB15C8, 0x19E1814C, 0x02B120EE, 0xF9197FC6);
	r3 = D(r3, s0_1_1, 0xF6D511ED, 0x00CC04E3, 0xE8F50BE3, 0xF6E40CDB);
	r0 = D(r0, s0_1_2, 0xFAF503F0, 0x01F506F5, 0xFBE405F6, 0xFD1007E1);
	r1 = D(r1, s0_1_2, 0x04090102, 0x030D0DF3, 0x020B03FF, 0xFF01FEFC);
	r2 = D(r2, s0_1_2, 0xEE1D01E2, 0xFEF30BF9, 0xFBF505ED, 0xFF05FB0E);
	r3 = D(r3, s0_1_2, 0x00F901F2, 0xFD09FCF8, 0x04FE06DF, 0x0108FAE5);
	r0 = D(r0, s0_2_0, 0x0806FDFC, 0x1BF6FEF9, 0x0908FC04, 0x14F800FB);
	r1 = D(r1, s0_2_0, 0x0405FC01, 0x040A01FB, 0x15FBFBFD, 0x000702F7);
	r2 = D(r2, s0_2_0, 0x03FDF7F7, 0x12FE09FC, 0x050CFDF8, 0xEBFA0206);
	r3 = D(r3, s0_2_0, 0x0CFEFD08, 0xFD00030D, 0x07FF00FC, 0x1903F8FD);
	r0 = D(r0, s0_2_1, 0x0801FE0B, 0x17FF0204, 0x1AF1F309, 0xE20902F8);
	r1 = D(r1, s0_2_1, 0x0FDD08EF, 0xFAF409F4, 0x09FD0705, 0xF9EF05F4);
	r2 = D(r2, s0_2_1, 0x060AFFED, 0xF30216FE, 0xF7FF02F7, 0x06FDF50B);
	r3 = D(r3, s0_2_1, 0xFDFF0303, 0xEBFB0AF8, 0x06000006, 0xEDFC0EF0);
	r0 = D(r0, s0_2_2, 0x0504FCFE, 0x0604FDFB, 0x08FAFAFF, 0x07FC02FA);
	r1 = D(r1, s0_2_2, 0xFF03FF00, 0x04040406, 0xFB0100FC, 0x010A00FE);
	r2 = D(r2, s0_2_2, 0x0011FBFA, 0x00020300, 0x020500FE, 0xFEFFFF05);
	r3 = D(r3, s0_2_2, 0x05000401, 0x050006FD, 0x06FA0402, 0xFDFA01FB);
	r0 = D(r0, s1_0_0, 0x12FE01FB, 0x08FE00F9, 0x19F80D03, 0x00FE0000);
	r1 = D(r1, s1_0_0, 0xF60002FD, 0xFC04FE05, 0xFF05FE03, 0x0300FA08);
	r2 = D(r2, s1_0_0, 0x04010200, 0xEC00F908, 0x0B02FBFB, 0x0AFB0AFC);
	r3 = D(r3, s1_0_0, 0x0AFF00FF, 0xFEFD0400, 0xFF01FD03, 0xF90303FF);
	r0 = D(r0, s1_0_1, 0x1A06F9F7, 0x18E708F6, 0x1FFD1205, 0x02050004);
	r1 = D(r1, s1_0_1, 0xF3FF00FE, 0x07050501, 0x09FD1007, 0x0405080F);
	r2 = D(r2, s1_0_1, 0xFFFC0C02, 0x1BF60F05, 0xD9EDF5E7, 0xF203F5F9);
	r3 = D(r3, s1_0_1, 0x260301F7, 0xFBFDFEF8, 0x1300040D, 0x0D020A10);
	r0 = D(r0, s1_0_2, 0x16F903FE, 0x00F814F8, 0xFBFA04F8, 0xF6FD0701);
	r1 = D(r1, s1_0_2, 0x03FB0C08, 0xFC03FE02, 0xFCFD0302, 0xFBFF03FD);
	r2 = D(r2, s1_0_2, 0xF5FC0BF1, 0xEBFBFE03, 0x0DF90DFB, 0x03FE04F5);
	r3 = D(r3, s1_0_2, 0x07020400, 0x0B00F9F4, 0xF6FFFE06, 0xF200050B);
	r0 = D(r0, s1_1_0, 0x00F412FC, 0xFCFA0CFA, 0xEBFFF6FA, 0xF805FB01);
	r1 = D(r1, s1_1_0, 0xF0F50709, 0xFE090401, 0xEFF70A06, 0xD4F00C05);
	r2 = D(r2, s1_1_0, 0xFDFCF903, 0x0E0404F9, 0x02F018F5, 0xF5FCF806);
	r3 = D(r3, s1_1_0, 0xFF0106FB, 0x04F413FE, 0x02FFFE00, 0xDBF3F306);
	r0 = D(r0, s1_1_1, 0xEBE028FF, 0xE316DEFB, 0xDFFCF1EB, 0xFFF228F8);
	r1 = D(r1, s1_1_1, 0x1A15153D, 0xE304F4F8, 0xF71BD73B, 0x1115E442);
	r2 = D(r2, s1_1_1, 0xE61228DD, 0x3228ECB4, 0xE80718FF, 0xD2D60B43);
	r3 = D(r3, s1_1_1, 0x33F4FBFA, 0x4ED43707, 0xE61215F5, 0x04291146);
	r0 = D(r0, s1_1_2, 0xF90B0215, 0x0901EAFA, 0x2302F605, 0xF007F733);
	r1 = D(r1, s1_1_2, 0xECFEFF03, 0xE90206FA, 0xFDF60C02, 0xFBFB0808);
	r2 = D(r2, s1_1_2, 0xFCEDE614, 0x00FA024F, 0xFA08FE09, 0xFEF8FCB0);
	r3 = D(r3, s1_1_2, 0x0206F915, 0xF9051600, 0xF6FCE735, 0xFDF4F51B);
	r0 = D(r0, s1_2_0, 0xFFFF06FC, 0x00F505FE, 0x01FA0801, 0x02000402);
	r1 = D(r1, s1_2_0, 0x01070800, 0x01080404, 0x00020100, 0xF10A0701);
	r2 = D(r2, s1_2_0, 0x02FF00FF, 0xFC03FE06, 0x000008FE, 0xFDF501FC);
	r3 = D(r3, s1_2_0, 0xFE000301, 0xFC07EA00, 0x0101FD01, 0x05FC0305);
	r0 = D(r0, s1_2_1, 0x0DF6FAF3, 0x0AE418FF, 0x22F522F0, 0xF5090204);
	r1 = D(r1, s1_2_1, 0xF5ECE403, 0xEEF1F302, 0xF8E10300, 0xFFFEF007);
	r2 = D(r2, s1_2_1, 0x01EC1704, 0xF0E80509, 0x08F6F9FC, 0x0F09FEF9);
	r3 = D(r3, s1_2_1, 0xF5F8FEEC, 0xDEFDDBE6, 0xF8F60004, 0xEE110103);
	r0 = D(r0, s1_2_2, 0xFF01F5F7, 0xFDF2FFF6, 0xFCF809E2, 0xFDF0FD04);
	r1 = D(r1, s1_2_2, 0x02FE0506, 0xFC09F8F7, 0x03FCFB04, 0xFFF904FC);
	r2 = D(r2, s1_2_2, 0x02F3F7F9, 0x02EF04FD, 0xFFFBFAF7, 0xFD05FF00);
	r3 = D(r3, s1_2_2, 0xFD03FFF6, 0x05F9F7E3, 0xFEF8FD03, 0x01F0FE10);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xF7FC03FD, 0x02F9F309, 0xFCFB1DF1, 0x0401FF00);
	r1 = D(r1, s0_0_0, 0xFF0204FA, 0x04FE0100, 0xFDF407F9, 0x08F8FD05);
	r2 = D(r2, s0_0_0, 0x13F7F9F7, 0xF707F904, 0x09F6EA0A, 0x02FFFFFE);
	r3 = D(r3, s0_0_0, 0x04FD0AFE, 0xFEFFFE05, 0xFF00F905, 0x0EFD0000);
	r0 = D(r0, s0_0_1, 0xF3FDF30D, 0xE50224EE, 0xF2FF14ED, 0x00F902FE);
	r1 = D(r1, s0_0_1, 0x01F6FD08, 0xF3F1FD09, 0xFBFFF405, 0x01F9F30A);
	r2 = D(r2, s0_0_1, 0xFAF60DE7, 0xF1080A01, 0xECFA0013, 0x01FFF303);
	r3 = D(r3, s0_0_1, 0xFEFAFF04, 0x06FAEC14, 0xE7F218EB, 0xFAF9FFFF);
	r0 = D(r0, s0_0_2, 0x03FCFF11, 0x02FF05EC, 0xFFFF0BED, 0xFFFA0008);
	r1 = D(r1, s0_0_2, 0x000009FA, 0xFFF9FF0E, 0x00FF08FD, 0x02FE00FD);
	r2 = D(r2, s0_0_2, 0xFEFCF90A, 0x01010500, 0x07FEF50C, 0xFD00FF05);
	r3 = D(r3, s0_0_2, 0xFDFDFE0C, 0x05020009, 0xF8FB0009, 0x0AFBF809);
	r0 = D(r0, s0_1_0, 0x00F3EE0B, 0xF301F912, 0x05F8ED05, 0x0BFAF50E);
	r1 = D(r1, s0_1_0, 0x05E31CEF, 0x0AECFCF7, 0x12ED0CE9, 0xF7F0FD01);
	r2 = D(r2, s0_1_0, 0x1BF9FFFE, 0xE90617F0, 0xFDF5E701, 0x0406F20D);
	r3 = D(r3, s0_1_0, 0x01F5F608, 0xEDF41AF8, 0x0CFE02FF, 0x1BED0316);
	r0 = D(r0, s0_1_1, 0xD3F0F720, 0xC801EE3C, 0xCFEBB435, 0xBFF218DB);
	r1 = D(r1, s0_1_1, 0xECFAE32B, 0xE1F0CD1A, 0xDAF41C3A, 0x09F8E810);
	r2 = D(r2, s0_1_1, 0xF802E80A, 0xEA16EBEE, 0xDDFDFA03, 0x0EF6FF0B);
	r3 = D(r3, s0_1_1, 0xDCFCE41D, 0xBF042DDF, 0xD6F2EDFD, 0xE901E108);
	r0 = D(r0, s0_1_2, 0xFBF90309, 0xF6FD0F11, 0xFBEFF91D, 0xEDF70A18);
	r1 = D(r1, s0_1_2, 0xFAFE06F3, 0xEEF10106, 0xFEFE00F4, 0x07FF0501);
	r2 = D(r2, s0_1_2, 0x18E0080D, 0xFB02F01D, 0x00FAFD0A, 0xFA0002EE);
	r3 = D(r3, s0_1_2, 0xF9FCFF09, 0xF3FD00FE, 0xF1F51A16, 0x0CF90405);
	r0 = D(r0, s0_2_0, 0x04020500, 0x02020EF7, 0xFE0AFFF6, 0x020007F9);
	r1 = D(r1, s0_2_0, 0x0DF8FFF3, 0x08FBF202, 0x03FC0CFF, 0x0AF903F3);
	r2 = D(r2, s0_2_0, 0x08FCF302, 0x000AFF02, 0x06FDF005, 0xF7030703);
	r3 = D(r3, s0_2_0, 0x09FC0608, 0x1701F80A, 0xFF010502, 0x08FB05FF);
	r0 = D(r0, s0_2_1, 0x0604EE02, 0x0DFFF9F8, 0x1FFEE9EC, 0x03FAF907);
	r1 = D(r1, s0_2_1, 0xF5FA1503, 0xFEF80D0C, 0x0AF9FD02, 0xFBFA1004);
	r2 = D(r2, s0_2_1, 0x1DFAF215, 0xF707001A, 0x08FDFB0A, 0xFD04F7EE);
	r3 = D(r3, s0_2_1, 0x0C020DED, 0x1DFF1D02, 0x03F90A03, 0x01FDF8FA);
	r0 = D(r0, s0_2_2, 0x02030807, 0x0301FF00, 0x0AFDE2F3, 0x03FB02F9);
	r1 = D(r1, s0_2_2, 0x03FCF7FE, 0x04F4EDFC, 0x01FDFDFD, 0x02FBFA01);
	r2 = D(r2, s0_2_2, 0x02F2EC03, 0xFD00F8F5, 0xFDFB0703, 0x0003FF09);
	r3 = D(r3, s0_2_2, 0x07FFFB02, 0x08F60300, 0x03FBF9FE, 0x00F7FF01);
	r0 = D(r0, s1_0_0, 0x00FBFBFE, 0xFD0B07E9, 0x081700F5, 0x02060001);
	r1 = D(r1, s1_0_0, 0xFF02FF09, 0xFE0EFF0C, 0xFC02F810, 0xF600F205);
	r2 = D(r2, s1_0_0, 0xFA0505FE, 0xFB09FE07, 0xFA0101F8, 0x02FAFEF8);
	r3 = D(r3, s1_0_0, 0x000004FE, 0x01F604F9, 0x02000100, 0xFBFEF700);
	r0 = D(r0, s1_0_1, 0x04F5FEF9, 0x12F20DEF, 0x020E0403, 0xFB01FD06);
	r1 = D(r1, s1_0_1, 0xFA010000, 0xF70BFE0B, 0xFB010207, 0xFC07FF0A);
	r2 = D(r2, s1_0_1, 0x030E04FA, 0x010701FF, 0x08E708EB, 0xFEFCFCFE);
	r3 = D(r3, s1_0_1, 0x02060000, 0x02F008F3, 0xFB07F410, 0xF608FA0C);
	r0 = D(r0, s1_0_2, 0x0307FCFF, 0x00020003, 0x00030A03, 0xFDFF0101);
	r1 = D(r1, s1_0_2, 0x0300FF03, 0xFBFE0104, 0x00FA0002, 0xFFFB0300);
	r2 = D(r2, s1_0_2, 0xFA0109FB, 0xFDFA03FC, 0xFFFFFF06, 0x0208FE00);
	r3 = D(r3, s1_0_2, 0xFE030000, 0x020302FF, 0xF9F90404, 0xFFFE0500);
	r0 = D(r0, s1_1_0, 0x0E05F211, 0x08DFEF0A, 0xDC04E904, 0x02F9FAFD);
	r1 = D(r1, s1_1_0, 0xFDF3D622, 0xF9F8EB1A, 0xF4F8C81D, 0xE701F103);
	r2 = D(r2, s1_1_0, 0xF50703FD, 0x01F5FC2C, 0x12FFF010, 0xFD04F5D6);
	r3 = D(r3, s1_1_0, 0x06FEF40E, 0x0913F2FE, 0xFE02F2FC, 0xECFCD90F);
	r0 = D(r0, s1_1_1, 0xDF33E7D3, 0x29F5EEF0, 0xEB0AE2DE, 0xEC00DE43);
	r1 = D(r1, s1_1_1, 0xE82ED7FA, 0xDA14FA45, 0xED2DD7F2, 0x011501EA);
	r2 = D(r2, s1_1_1, 0xFBE7AD14, 0x08EFD10B, 0x212DF5E4, 0x00FF15FA);
	r3 = D(r3, s1_1_1, 0xF6FDF1F2, 0x0F3DF1F7, 0xEFE7EB3F, 0xEA02CFEF);
	r0 = D(r0, s1_1_2, 0xFF12FCF2, 0xF701FEF5, 0x0215E5F8, 0xEF1004F3);
	r1 = D(r1, s1_1_2, 0xFBEE0605, 0xEC020BF8, 0xF7F40605, 0xFB0001FE);
	r2 = D(r2, s1_1_2, 0xF31A04EC, 0xFF0EF8F7, 0x0219F4EF, 0x01ED030C);
	r3 = D(r3, s1_1_2, 0xFF0BFAF6, 0x060BFF00, 0xEB1805F4, 0xF9050404);
	r0 = D(r0, s1_2_0, 0x11F7EDF7, 0x0D01FFF3, 0x0CFFF600, 0xF8FEFB01);
	r1 = D(r1, s1_2_0, 0xF903D307, 0xF1FAEF0B, 0xF5F8F707, 0xFDF9E7FC);
	r2 = D(r2, s1_2_0, 0xFFFE0CF9, 0xFCFCF906, 0x1BF9F1F9, 0x0401FCFD);
	r3 = D(r3, s1_2_0, 0x0703E7F5, 0x0609D9EA, 0xFAFD0102, 0xFBF7E602);
	r0 = D(r0, s1_2_1, 0x2F05F5F9, 0x0506FAF7, 0x1B0904EF, 0x08F2D107);
	r1 = D(r1, s1_2_1, 0x18FDF508, 0x0C03F607, 0x0E02FD04, 0xFE07FF03);
	r2 = D(r2, s1_2_1, 0x03EE1802, 0x2C07E508, 0x3000F7FB, 0xE8FD06F6);
	r3 = D(r3, s1_2_1, 0xE100FAEC, 0x0DFBEAEA, 0xFFFCEA06, 0x05FDF2FE);
	r0 = D(r0, s1_2_2, 0x1104FAFE, 0x15010101, 0x0B07FFF8, 0xFE080601);
	r1 = D(r1, s1_2_2, 0xEF010100, 0xF40A03FB, 0xFA0101FE, 0xFEFA0302);
	r2 = D(r2, s1_2_2, 0xFDF90C03, 0x06000301, 0x1005FA00, 0x0300FAFD);
	r3 = D(r3, s1_2_2, 0x0803FEFD, 0x05EB02FA, 0xFF0501FD, 0xF40F02FF);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-8.721e-03, -1.653e-02, -1.863e-02, -2.118e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.713e-02, -2.685e-02, -1.923e-02, -1.789e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-1.822e-02, -1.558e-02, -1.133e-02, -2.768e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-1.432e-02, -1.945e-02, -2.069e-02, -2.167e-02);
	f3 = clamp(f3, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-DS-out-shuffle
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
shared V4 G[4][10][10];
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
			vec2 p;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv4_pt;
			V4 sr0 = V4(conv4_gather(p, 0));
			V4 sg0 = V4(conv4_gather(p, 1));
			V4 sb0 = V4(conv4_gather(p, 2));
			V4 sa0 = V4(conv4_gather(p, 3));
			G[0][ay][ax] = V4(sr0.w, sg0.w, sb0.w, sa0.w);
			G[1][ay][ax] = V4(sr0.z, sg0.z, sb0.z, sa0.z);
			G[2][ay][ax] = V4(sr0.x, sg0.x, sb0.x, sa0.x);
			G[3][ay][ax] = V4(sr0.y, sg0.y, sb0.y, sa0.y);
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
	r0 += M4(-5.995e-03, 4.945e-03, 1.067e-03, 1.000e-03, 1.214e-02, 5.690e-04, 1.167e-03, 1.437e-03, 1.579e-02, 1.253e-02, -1.648e-03, 2.777e-04, 1.670e-02, -1.328e-02, 6.442e-03, -3.961e-03) * s0_0_0;
	r0 += M4(-8.513e-02, -7.450e-02, 4.316e-03, -1.147e-03, 3.058e-02, 2.366e-02, -7.475e-03, -4.622e-03, -1.192e-02, 7.398e-03, -5.571e-03, -5.490e-03, -1.430e-02, -2.143e-02, 5.814e-03, 1.732e-02) * s0_0_1;
	r0 += M4(8.188e-03, -1.974e-02, -1.421e-03, 2.216e-03, 7.702e-03, 2.437e-02, 3.103e-03, -3.055e-03, 2.958e-03, -2.427e-03, -1.088e-03, -1.527e-03, 1.192e-03, 9.478e-04, 2.037e-04, 2.855e-03) * s0_0_2;
	r0 += M4(5.455e-02, -6.095e-03, 2.648e-02, 1.887e-03, -1.129e-03, 6.554e-03, 2.223e-02, -3.715e-03, -1.352e-01, 7.001e-03, 5.332e-02, 8.001e-03, 1.138e-02, -2.657e-02, 1.098e-01, 2.640e-02) * s0_1_0;
	r0 += M4(1.223e-01, 1.675e-01, 9.407e-02, 3.818e-02, -3.041e-01, -1.655e-01, 1.255e-01, 1.023e-01, -5.969e-02, -2.588e-01, 1.158e-01, 1.528e-01, -2.329e-02, 9.395e-02, 1.792e-01, -5.532e-01) * s0_1_1;
	r0 += M4(9.873e-04, 2.327e-02, -1.180e-02, 5.969e-02, 7.430e-04, -1.284e-01, -1.632e-02, 2.920e-02, -6.442e-04, 5.948e-02, 7.548e-03, 3.617e-02, -3.080e-04, -4.607e-03, -5.603e-03, 7.056e-02) * s0_1_2;
	r0 += M4(-6.654e-03, -1.173e-05, -2.432e-02, 1.389e-03, -4.595e-03, -1.734e-03, -1.510e-03, 2.310e-03, 1.132e-02, 2.819e-03, 1.310e-02, 5.400e-03, 3.838e-03, 8.973e-04, 7.009e-03, -2.104e-03) * s0_2_0;
	r0 += M4(-8.597e-03, -1.427e-02, -7.879e-02, -9.497e-02, -1.182e-03, 7.331e-04, 9.392e-02, 3.236e-02, 1.500e-02, 1.899e-02, -8.082e-02, -2.123e-02, -3.992e-03, -3.513e-03, 2.524e-02, 4.161e-02) * s0_2_1;
	r0 += M4(5.866e-04, 2.202e-03, 8.718e-04, -1.882e-02, 2.026e-05, -4.847e-03, -4.457e-03, 4.836e-02, 2.789e-03, 5.601e-03, 3.429e-04, -4.186e-02, 3.049e-05, -5.566e-04, -9.132e-04, 5.467e-03) * s0_2_2;
	r0 += M4(8.802e-03, -7.795e-04, 1.688e-03, -5.253e-03, 1.208e-02, 2.589e-03, 2.892e-04, 1.559e-03, -1.315e-03, -3.969e-03, -4.646e-03, -4.147e-04, 2.012e-03, -1.112e-03, 2.075e-03, 1.805e-04) * s1_0_0;
	r0 += M4(-5.655e-02, 1.327e-02, 9.886e-03, 1.593e-02, -7.974e-03, 6.795e-03, 1.393e-02, 1.951e-03, 1.178e-02, 1.128e-02, -1.090e-02, -4.452e-03, -4.506e-02, 7.565e-03, 6.446e-03, 6.311e-03) * s1_0_1;
	r0 += M4(2.525e-04, -2.229e-03, -1.282e-03, -3.064e-03, 6.856e-04, -9.450e-03, -1.911e-03, 7.053e-04, -2.222e-03, -7.426e-03, 2.544e-03, -1.837e-03, -2.013e-03, 1.753e-02, -3.794e-03, 8.085e-03) * s1_0_2;
	r0 += M4(-1.404e-02, -9.317e-04, 5.482e-02, -1.041e-02, 8.166e-02, 3.676e-03, 7.495e-02, 3.798e-03, 3.138e-02, -7.983e-03, -1.355e-02, 2.598e-04, -3.683e-04, 3.317e-04, -3.180e-03, -8.964e-04) * s1_1_0;
	r0 += M4(1.252e-01, 3.328e-02, -4.104e-01, 2.460e-01, -1.677e-01, 1.284e-01, -1.763e-01, 1.239e-01, -4.541e-01, 1.997e-01, 3.728e-02, 4.114e-03, -2.852e-01, -4.191e-02, -2.798e-01, -3.993e-02) * s1_1_1;
	r0 += M4(-1.600e-02, -1.270e-03, 5.646e-04, 1.125e-01, 7.740e-04, -6.665e-02, 7.803e-03, -7.215e-02, 7.810e-03, 1.036e-01, -1.893e-02, -1.527e-02, 1.568e-02, 8.520e-02, 2.811e-02, 9.585e-02) * s1_1_2;
	r0 += M4(-1.199e-03, -2.526e-04, 3.804e-03, -1.325e-03, -3.196e-03, 1.733e-03, 1.568e-02, 2.864e-03, 3.747e-03, -2.459e-03, -9.719e-03, -9.395e-05, 8.920e-04, -8.818e-04, 3.437e-03, -1.316e-03) * s1_2_0;
	r0 += M4(-3.646e-03, -7.665e-04, 4.480e-02, 3.372e-02, 8.046e-03, -4.775e-03, 5.261e-03, 1.890e-03, 6.027e-03, 1.823e-02, -7.143e-02, -1.739e-03, 7.385e-05, 4.309e-03, -5.982e-02, 1.023e-02) * s1_2_1;
	r0 += M4(3.822e-03, 1.573e-03, 4.677e-03, -1.596e-03, 1.322e-04, -1.563e-03, -2.221e-03, -3.253e-03, -2.441e-03, -1.186e-02, 2.360e-03, -1.242e-02, -2.677e-03, 9.064e-03, -1.109e-02, 8.459e-03) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 += M4(-2.187e-02, -5.752e-03, -3.526e-04, 3.286e-03, -1.035e-02, -2.966e-04, -1.070e-04, -9.189e-07, -8.651e-03, 7.416e-04, -1.373e-03, -1.131e-03, 1.124e-02, 1.398e-06, 5.600e-07, 9.953e-07) * s0_0_0;
	r0 += M4(-1.540e-02, -2.724e-02, 4.078e-03, 2.466e-03, -2.911e-02, -2.924e-02, 3.959e-06, 3.905e-06, -4.422e-02, -3.100e-02, 8.653e-03, 3.745e-03, 3.357e-02, 3.333e-02, -5.626e-08, 3.352e-07) * s0_0_1;
	r0 += M4(2.286e-04, -2.615e-03, 5.489e-04, 2.567e-03, -1.365e-04, -1.059e-02, -9.060e-07, -6.379e-04, -4.281e-03, -2.496e-02, -2.958e-03, 4.439e-03, 1.667e-06, 1.224e-02, 1.057e-06, 2.774e-06) * s0_0_2;
	r0 += M4(-4.736e-02, -2.802e-02, -6.003e-02, -2.759e-02, -2.899e-02, 6.474e-07, -2.889e-02, -4.668e-07, -1.340e-02, -7.627e-03, -2.521e-02, 3.139e-03, 3.235e-02, -2.336e-06, 3.210e-02, -9.201e-07) * s0_1_0;
	r0 += M4(-1.132e-02, -1.853e-01, -4.847e-02, -9.058e-02, -8.225e-02, -8.227e-02, -8.228e-02, -8.276e-02, 9.184e-02, 4.058e-02, -1.436e-01, -1.173e-01, 9.498e-02, 9.512e-02, 9.463e-02, 9.477e-02) * s0_1_1;
	r0 += M4(7.670e-04, -1.755e-02, 1.643e-03, -1.739e-02, 7.014e-07, -2.952e-02, 2.536e-05, -2.936e-02, -9.995e-03, 2.752e-02, 7.793e-03, -4.232e-02, 5.156e-06, 3.308e-02, 5.141e-07, 3.321e-02) * s0_1_2;
	r0 += M4(-1.318e-02, -2.586e-04, -2.864e-02, -2.083e-02, -7.256e-05, -3.192e-06, -1.004e-02, -3.678e-04, 3.599e-03, -1.518e-03, 2.399e-02, -1.000e-02, 5.211e-07, -6.098e-07, 1.112e-02, 3.412e-07) * s0_2_0;
	r0 += M4(-1.194e-03, -1.357e-02, -2.997e-02, -2.485e-02, 8.260e-05, 4.389e-05, -2.863e-02, -2.820e-02, 8.932e-03, 1.333e-02, 1.401e-01, 1.401e-01, 4.806e-07, 4.716e-06, 3.406e-02, 3.428e-02) * s0_2_1;
	r0 += M4(3.853e-05, 1.574e-03, -2.097e-05, -1.693e-02, -6.357e-07, -8.190e-05, -8.311e-05, -1.071e-02, -1.577e-03, -1.646e-03, -3.394e-03, 3.699e-02, -4.295e-07, 9.416e-05, 1.295e-06, 1.156e-02) * s0_2_2;
	r0 += M4(1.436e-02, -3.681e-03, -1.747e-04, -2.611e-03, 7.324e-03, -7.632e-03, -1.737e-03, -1.743e-04, 3.010e-02, 5.378e-03, 4.855e-03, 1.515e-03, -7.348e-03, 5.262e-03, 3.246e-03, 1.487e-03) * s1_0_0;
	r0 += M4(1.579e-01, 1.210e-01, 4.900e-03, 6.993e-03, 9.487e-02, 7.983e-02, -2.281e-03, 1.721e-03, 3.308e-02, 4.089e-02, -7.328e-03, -2.611e-03, 4.702e-02, -5.968e-03, 1.401e-02, 5.173e-03) * s1_0_1;
	r0 += M4(-6.480e-03, 4.306e-02, 2.046e-03, 3.048e-03, 5.928e-04, 3.496e-02, 6.720e-04, -3.550e-03, -1.417e-03, 1.070e-02, 2.358e-04, 4.609e-05, 5.396e-04, 9.596e-03, -1.056e-03, -4.326e-03) * s1_0_2;
	r0 += M4(-1.899e-02, 2.230e-04, 1.178e-03, -1.764e-02, 2.040e-02, -3.702e-03, -5.188e-02, 2.287e-02, 1.567e-01, 5.945e-02, 7.475e-02, 1.866e-03, -3.744e-02, 1.047e-02, -4.762e-02, 1.109e-02) * s1_1_0;
	r0 += M4(-1.680e-01, -1.323e-01, 1.121e-01, 1.035e-01, 9.350e-02, 8.716e-02, -3.037e-01, -2.866e-01, 1.606e-01, -4.899e-01, -8.259e-03, 1.264e-01, 1.798e-01, -2.036e-01, 1.919e-01, -1.957e-01) * s1_1_1;
	r0 += M4(1.169e-02, -4.984e-02, -2.178e-02, -5.446e-03, -7.014e-03, 2.597e-02, 8.576e-03, -7.251e-02, -7.627e-04, 6.910e-02, -3.691e-04, -3.502e-04, -8.899e-04, 7.573e-02, 1.307e-03, 7.642e-02) * s1_1_2;
	r0 += M4(-2.761e-03, -1.731e-03, -1.272e-02, -2.617e-03, 2.759e-03, 2.202e-03, 1.779e-02, 8.336e-03, 2.510e-02, -5.055e-04, 4.140e-02, 5.240e-03, 1.463e-03, 1.858e-03, 1.219e-03, 5.176e-03) * s1_2_0;
	r0 += M4(6.036e-03, -6.748e-04, -6.274e-02, -4.721e-02, -5.174e-03, -1.696e-03, 2.422e-02, 2.032e-02, 4.474e-03, 4.041e-02, -2.256e-02, -3.415e-02, 9.583e-03, 3.242e-03, 3.723e-02, -2.373e-02) * s1_2_1;
	r0 += M4(-3.321e-03, 4.355e-03, 2.255e-03, -2.645e-02, 2.431e-03, -2.197e-03, 4.350e-03, 1.894e-02, -5.017e-04, 2.102e-03, 2.024e-03, 4.611e-03, -6.688e-05, -4.810e-03, -3.306e-04, 1.096e-02) * s1_2_2;
	r0 += V4(1.133e-11, -1.175e-10, 3.519e-11, 1.088e-10);
	r0 = r0;
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
