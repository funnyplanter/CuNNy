// CuNNy faster DS (dp4a)
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


//!DESC CuNNy-faster-DS-in
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
	r0 += V4(-6.647e-03, 4.964e-02, -2.908e-02, 3.274e-02) * s0_0_0;
	r1 += V4(5.020e-02, 3.348e-02, 3.657e-02, 8.082e-02) * s0_0_0;
	r0 += V4(9.356e-02, -3.546e-02, 1.771e-02, 8.521e-02) * s0_0_1;
	r1 += V4(1.017e+00, 5.007e-03, -2.789e-02, -1.145e+00) * s0_0_1;
	r0 += V4(-1.140e-01, 6.929e-02, -2.388e-02, 3.269e-01) * s0_0_2;
	r1 += V4(3.515e-02, -6.010e-02, -8.201e-03, 5.516e-02) * s0_0_2;
	r0 += V4(4.282e-02, -1.758e-01, -1.948e-01, 6.453e-03) * s0_1_0;
	r1 += V4(-5.546e-02, 7.343e-02, -1.412e-01, -2.480e-02) * s0_1_0;
	r0 += V4(7.933e-01, -8.927e-01, -6.775e-01, -3.506e-02) * s0_1_1;
	r1 += V4(-9.785e-01, -3.975e-01, -1.027e+00, 1.082e+00) * s0_1_1;
	r0 += V4(-8.133e-01, 2.647e-01, -1.921e-01, -9.885e-01) * s0_1_2;
	r1 += V4(-5.502e-02, 5.224e-01, 1.169e+00, -1.512e-02) * s0_1_2;
	r0 += V4(-4.301e-02, 1.457e-01, 1.994e-01, 5.749e-02) * s0_2_0;
	r1 += V4(3.674e-02, -4.163e-02, 1.091e-01, -2.804e-02) * s0_2_0;
	r0 += V4(1.606e-01, 2.628e-01, 7.473e-01, 1.664e-01) * s0_2_1;
	r1 += V4(-6.618e-02, 9.939e-02, -9.963e-02, 5.338e-02) * s0_2_1;
	r0 += V4(-1.081e-01, 1.326e-01, 1.620e-01, 1.126e-01) * s0_2_2;
	r1 += V4(2.913e-02, -3.944e-02, -6.417e-03, -4.873e-02) * s0_2_2;
	r0 += V4(9.666e-03, -1.577e-02, -1.042e-02, -1.118e-02);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-1.072e-02, 5.370e-02, 3.258e-03, -9.123e-03);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-faster-DS-conv1
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
	r0 = D(r0, s0_0_0, 0xD6080ADF, 0xE8050FF2, 0xCAA82CE7, 0xC6FC091F);
	r1 = D(r1, s0_0_0, 0x12E11526, 0xD8FC0BE8, 0xE7F206D5, 0x13F7E71F);
	r0 = D(r0, s0_0_1, 0x2017F905, 0x33F8F51B, 0x027F25D8, 0x091E099E);
	r1 = D(r1, s0_0_1, 0xD9F8D69B, 0x0C0D171C, 0x06050030, 0xF8DBFEE1);
	r0 = D(r0, s0_0_2, 0xF610F004, 0x04FC24F8, 0x04FE0610, 0x090CF1E9);
	r1 = D(r1, s0_0_2, 0xE6017F20, 0x06000706, 0x03F70C0F, 0xFFF80F01);
	r0 = D(r0, s0_1_0, 0xDF050413, 0x08FB0006, 0x312938D6, 0x7F810481);
	r1 = D(r1, s0_1_0, 0xFC070905, 0x192B2536, 0x81ED0EED, 0xA8FA05F1);
	r0 = D(r0, s0_1_1, 0x0AB30500, 0xE9DA152B, 0xB8C29D3D, 0x2DBD5474);
	r1 = D(r1, s0_1_1, 0xC0ACCB0C, 0x1CA932F0, 0x1B3FC7D4, 0x0EEDE11B);
	r0 = D(r0, s0_1_2, 0xFF1CF002, 0xFD03C72A, 0x1F81D6F1, 0x20CD1411);
	r1 = D(r1, s0_1_2, 0x11C8F505, 0x0C00E70B, 0xF7C3DF11, 0x060B0900);
	r0 = D(r0, s0_2_0, 0xE7FF0501, 0xE8020016, 0x5F24D281, 0xED06F610);
	r1 = D(r1, s0_2_0, 0x15040EEE, 0xCE0BEFF0, 0xF7FBFB0A, 0xFEFE1520);
	r0 = D(r0, s0_2_1, 0x2102FB0C, 0xF1F5021A, 0xB7C44D2E, 0x06F5FDF2);
	r1 = D(r1, s0_2_1, 0xF8FADDF0, 0x0D16EFE4, 0x33F716F3, 0xE30DCF11);
	r0 = D(r0, s0_2_2, 0x0109E4FA, 0x0E05F8E7, 0x240701E0, 0x070B04E7);
	r1 = D(r1, s0_2_2, 0x2115F2DE, 0x10F3F4FA, 0x10FAE307, 0x06001EF8);
	r0 = D(r0, s1_0_0, 0x02190E03, 0x0619F705, 0x0714F901, 0x05FF1E06);
	r1 = D(r1, s1_0_0, 0x0900E5FD, 0xFD103602, 0xF2180308, 0x05EB17FC);
	r0 = D(r0, s1_0_1, 0x0003EEFC, 0x09F819FF, 0xF635FB20, 0xF9490B13);
	r1 = D(r1, s1_0_1, 0xED815FAF, 0xFEE3F80A, 0x0CECFDF8, 0xFD160AF9);
	r0 = D(r0, s1_0_2, 0xFEFB0DF9, 0xEDED24F4, 0x07FB14FC, 0x0814CEFC);
	r1 = D(r1, s1_0_2, 0xFC987F8F, 0x02FD12FE, 0xFEEA3508, 0xFCFC0401);
	r0 = D(r0, s1_1_0, 0xE8281F21, 0xF8010001, 0x12B41738, 0x0537C516);
	r1 = D(r1, s1_1_0, 0x3A0016E4, 0xE5B20817, 0xDAF12F09, 0x2A0CCFEC);
	r0 = D(r0, s1_1_1, 0x3510DBDF, 0x440BBDDF, 0xCFD6D0EE, 0xAA813681);
	r1 = D(r1, s1_1_1, 0xBF329B0B, 0x3BF4C1A3, 0x5EE9B081, 0xC7F42346);
	r0 = D(r0, s1_1_2, 0xF004000A, 0xD7F81F1D, 0x30239EE6, 0x57F411A7);
	r1 = D(r1, s1_1_2, 0x8112C803, 0xF1031413, 0xD605181D, 0x1BFC00E4);
	r0 = D(r0, s1_2_0, 0x05FE10FF, 0x05F21700, 0xDCD00BED, 0x55EBE91A);
	r1 = D(r1, s1_2_0, 0x291BEFF1, 0xE04DCBFB, 0x0C3212FD, 0x2F0DFAFD);
	r0 = D(r0, s1_2_1, 0x1306FA51, 0x0600E428, 0xD4A57F81, 0xC4B558B9);
	r1 = D(r1, s1_2_1, 0x691A0F0C, 0x2009E47F, 0x8F108128, 0x7F03F9ED);
	r0 = D(r0, s1_2_2, 0xFE0BEFFB, 0x3413F30C, 0x7F1FFF1A, 0x1021D1EF);
	r1 = D(r1, s1_2_2, 0x501DD924, 0x13EB340B, 0x46EC4BF1, 0x11FAF4F1);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-3.762e-03, -6.053e-03, -8.130e-04, -2.601e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.316e-02, -8.945e-03, -1.580e-02, -2.905e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-faster-DS-conv2
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
	r0 = D(r0, s0_0_0, 0xFD030102, 0xEAF4EE08, 0xE41B11F4, 0x06FDFE02);
	r1 = D(r1, s0_0_0, 0xE1D8C302, 0xEDE7EAFF, 0xDCD409F0, 0xD5E1EEFD);
	r0 = D(r0, s0_0_1, 0xDDD5D3F0, 0xD1E0E90B, 0xCCDBEFFA, 0xE908EFF8);
	r1 = D(r1, s0_0_1, 0xC5E80D36, 0xCFF40C2D, 0xD9EC1C0F, 0xDCDB1116);
	r0 = D(r0, s0_0_2, 0x02EE022B, 0xD2E4FE26, 0xF8EB1304, 0xDDE1F718);
	r1 = D(r1, s0_0_2, 0x0AF3FFF0, 0x01F7FFEC, 0x0BF403FC, 0x29EA0AF8);
	r0 = D(r0, s0_1_0, 0x0D00FA00, 0xF001FEF6, 0xA9210B11, 0x09FA02FA);
	r1 = D(r1, s0_1_0, 0xB3FB3BD0, 0xCDE7FD08, 0xC6E13FE4, 0xD0F900DB);
	r0 = D(r0, s0_1_1, 0xDB071DEA, 0xE8DB28D6, 0xB7CA48AF, 0xEA0C1303);
	r1 = D(r1, s0_1_1, 0x99B801ED, 0xAFBBFF0B, 0xC500DF1F, 0xA2B30743);
	r0 = D(r0, s0_1_2, 0xC8EFFA01, 0xD3E3DA32, 0xA5C4E918, 0xA7C248AB);
	r1 = D(r1, s0_1_2, 0x01FF0A06, 0xCAE90930, 0x0801FFF8, 0x25D602E7);
	r0 = D(r0, s0_2_0, 0xFD0106FE, 0x0AFDFDFD, 0xF80CE018, 0x04000001);
	r1 = D(r1, s0_2_0, 0x130ADA0B, 0xEF1009F4, 0x0B0924F7, 0xDC020DEC);
	r0 = D(r0, s0_2_1, 0x11FEEA00, 0x0A09E509, 0xB7F43AD8, 0x0605EF06);
	r1 = D(r1, s0_2_1, 0x0E0AF51E, 0xB40909F0, 0xE6F4F8FD, 0xF2FCCA32);
	r0 = D(r0, s0_2_2, 0x1904FF0E, 0x22FFFB07, 0x14F2E809, 0x070CEF1F);
	r1 = D(r1, s0_2_2, 0x04FFFC04, 0x0D0FF8EE, 0x04FAFFFE, 0x22F3FE04);
	r0 = D(r0, s1_0_0, 0xFAFD0008, 0xFE0007FE, 0xFE07EE02, 0xFDFE04FE);
	r1 = D(r1, s1_0_0, 0xF80D2A16, 0xFCFE0817, 0xEC17FFF7, 0xFD1B0405);
	r0 = D(r0, s1_0_1, 0x05011905, 0x17F71204, 0xEE171BFC, 0xFE0CF910);
	r1 = D(r1, s1_0_1, 0x4DBC2C09, 0xFEB75704, 0x26F6E6FC, 0x1E0BE202);
	r0 = D(r0, s1_0_2, 0x5BD0FD07, 0x2808F504, 0x1D10DE00, 0x22CC5A0A);
	r1 = D(r1, s1_0_2, 0xF1080E00, 0xF1091C00, 0xF508FFFD, 0xF307E406);
	r0 = D(r0, s1_1_0, 0x000103EB, 0xFF07FFE6, 0xF210DAFA, 0x02FF0006);
	r1 = D(r1, s1_1_0, 0x1404F197, 0xF1F025F8, 0xDFF71CD6, 0xF90715EE);
	r0 = D(r0, s1_1_1, 0x0EFFFFDE, 0x15FEEEDC, 0x118161D3, 0x08FFFEBF);
	r1 = D(r1, s1_1_1, 0xEDE0EAF8, 0xFBC7EB0A, 0x1C15C706, 0x2FB1D304);
	r0 = D(r0, s1_1_2, 0xE7E305EA, 0xEE19E914, 0xF443CB0D, 0xEFD9F7BB);
	r1 = D(r1, s1_1_2, 0xF9F906FD, 0x12F1E602, 0xF8110403, 0xBD270CFA);
	r0 = D(r0, s1_2_0, 0x0001FD00, 0x04FCFFFF, 0x0405FCD4, 0x00FFFEFB);
	r1 = D(r1, s1_2_0, 0x020600E2, 0x060702EC, 0xFE01FEE0, 0x010EF9ED);
	r0 = D(r0, s1_2_1, 0xFD0502ED, 0xFAF60FE8, 0x01F90794, 0x010700DA);
	r1 = D(r1, s1_2_1, 0xFD000BE0, 0xF9FAFBE4, 0xFD04F0F6, 0x0517F2C6);
	r0 = D(r0, s1_2_2, 0x01FF07ED, 0x02050302, 0xFA1FE529, 0x020BFFDB);
	r1 = D(r1, s1_2_2, 0x0203FB03, 0x02020B00, 0x0103FE06, 0x02160115);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-6.391e-03, -1.585e-03, -9.834e-03, -7.627e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-5.339e-03, -3.776e-03, -1.098e-02, -7.419e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-faster-DS-out-shuffle
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
	r0 += M4(1.660e-03, 2.314e-03, -1.012e-03, 2.441e-03, 3.747e-02, -2.146e-04, 5.481e-03, -1.344e-02, -1.283e-02, 1.053e-02, -1.674e-02, -2.003e-03, -3.562e-02, 3.651e-02, -4.051e-03, -2.734e-02) * s0_0_0;
	r0 += M4(2.024e-03, -2.599e-03, 2.393e-03, 1.828e-03, 3.901e-02, 9.253e-02, -8.879e-03, -1.798e-02, 1.199e-01, -7.677e-02, 1.290e-03, 9.861e-03, -4.770e-04, 1.837e-02, 1.324e-03, -8.318e-04) * s0_0_1;
	r0 += M4(-5.494e-04, 2.273e-03, 6.550e-07, 1.307e-03, -1.217e-03, 8.696e-03, -6.402e-03, -9.065e-03, 1.251e-03, 2.712e-02, 5.863e-04, 5.282e-03, 3.818e-04, -8.847e-05, 2.150e-06, -4.560e-04) * s0_0_2;
	r0 += M4(2.308e-01, 1.611e-01, 2.787e-02, 1.983e-02, 2.561e-01, -2.866e-03, 1.714e-01, 3.276e-02, 1.269e-03, 8.213e-03, 1.570e-02, 6.427e-03, 1.712e-01, -6.621e-01, 1.902e-01, 3.410e-01) * s0_1_0;
	r0 += M4(1.156e-01, 2.191e-01, 4.987e-03, 3.673e-02, -2.827e-01, -3.916e-01, 1.964e-02, 1.228e-01, 1.655e-01, -1.205e-01, 1.973e-01, -5.877e-01, -3.387e-02, 6.413e-02, 1.015e-03, 2.831e-02) * s0_1_1;
	r0 += M4(1.972e-03, 3.803e-03, -2.817e-03, -4.123e-03, -3.967e-03, -2.580e-02, 8.103e-03, 1.723e-02, 2.918e-03, 6.406e-02, -9.111e-03, 9.476e-02, -5.600e-04, -2.795e-04, 6.872e-04, 3.513e-03) * s0_1_2;
	r0 += M4(-1.117e-02, -3.023e-02, -4.808e-01, -1.734e-01, 2.168e-02, -1.160e-03, 1.477e-01, -8.682e-03, -4.604e-03, 4.469e-04, -9.565e-03, 6.736e-03, -3.058e-02, 6.274e-02, 9.399e-02, 2.368e-02) * s0_2_0;
	r0 += M4(-2.130e-02, -1.903e-02, 1.081e-01, -2.353e-01, -1.524e-03, 3.980e-02, -1.717e-01, -1.762e-02, -7.755e-03, -2.105e-02, 2.897e-02, 2.710e-02, 1.183e-03, 1.106e-02, -9.653e-03, -3.333e-02) * s0_2_1;
	r0 += M4(1.199e-03, 3.033e-02, -3.098e-03, 5.418e-02, -2.125e-03, -2.904e-02, 5.323e-03, -6.242e-02, -8.443e-04, -3.056e-03, 5.941e-04, 1.679e-02, 5.455e-04, 2.626e-04, -4.719e-06, -3.853e-04) * s0_2_2;
	r0 += M4(-3.465e-03, 1.640e-03, -4.329e-03, 1.001e-03, -7.616e-03, -3.321e-03, 5.518e-03, -3.360e-03, 5.572e-03, -2.305e-05, -6.040e-03, -5.090e-05, 5.033e-02, -5.926e-04, 5.913e-03, 3.442e-03) * s1_0_0;
	r0 += M4(1.189e-01, 1.742e-02, -4.976e-03, 1.881e-02, -9.441e-02, -5.116e-02, 6.332e-03, 4.534e-03, -4.859e-02, -8.393e-03, 3.305e-02, -2.016e-03, -9.394e-02, 1.027e-01, 3.910e-03, -1.818e-02) * s1_0_1;
	r0 += M4(1.629e-02, 2.986e-02, 2.844e-03, 9.427e-03, -1.234e-02, -5.286e-02, 5.778e-04, 3.077e-03, -5.274e-03, 2.558e-02, 6.806e-03, -1.307e-02, -8.166e-04, -8.735e-02, -9.794e-03, -2.683e-02) * s1_0_2;
	r0 += M4(-2.023e-02, -1.153e-02, 2.835e-03, -5.048e-03, 8.570e-02, 2.077e-03, -3.243e-02, 2.263e-02, -1.910e-02, 6.780e-04, 1.222e-02, 9.575e-04, 7.105e-02, -2.017e-03, 9.246e-02, -8.623e-03) * s1_1_0;
	r0 += M4(-8.336e-01, 5.295e-02, 2.082e-01, 8.144e-02, 2.686e-01, 2.555e-01, -3.624e-01, -3.577e-01, -3.213e-01, -2.692e-02, -3.148e-01, 2.508e-03, -7.984e-02, 2.144e-01, -3.284e-01, 3.261e-01) * s1_1_1;
	r0 += M4(2.195e-02, -1.484e-01, -1.935e-02, -4.888e-03, 1.157e-02, 6.477e-02, 2.209e-02, -4.484e-02, 5.529e-02, 2.900e-01, 1.936e-02, 2.565e-01, 8.261e-03, -6.458e-02, 2.038e-02, -1.655e-01) * s1_1_2;
	r0 += M4(-1.330e-02, -7.404e-05, -3.838e-02, 1.984e-03, -3.572e-03, -1.702e-04, 4.016e-02, -2.063e-03, 7.928e-03, -2.048e-03, -1.177e-02, -2.385e-03, -1.452e-03, 1.914e-03, 1.813e-02, 4.902e-04) * s1_2_0;
	r0 += M4(4.407e-02, -6.506e-03, 1.105e-01, 4.407e-02, -2.636e-03, -5.617e-03, 1.031e-01, 1.111e-01, 2.959e-02, 3.508e-03, -4.404e-02, -2.642e-02, 2.009e-03, 9.054e-03, 3.614e-02, 3.235e-02) * s1_2_1;
	r0 += M4(1.190e-02, -1.027e-02, 1.332e-02, 1.372e-01, 9.382e-04, 2.129e-03, 7.459e-04, 3.293e-02, -1.084e-02, -1.942e-02, 1.067e-02, 6.713e-02, 4.681e-03, 5.181e-03, -5.452e-03, -6.364e-03) * s1_2_2;
	r0 += V4(2.207e-10, -2.114e-12, 8.846e-10, 9.629e-10);
	r0 = r0;
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
