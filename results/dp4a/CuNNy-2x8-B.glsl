// CuNNy 2x8 BOX
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


//!DESC CuNNy-2x8-BOX-in
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
	r0 += V4(5.154e-05, -1.935e-03, 1.973e-01, -2.929e-02) * s0_0_0;
	r1 += V4(-6.666e-02, -8.325e-02, 3.798e-01, 1.959e-02) * s0_0_0;
	r0 += V4(4.362e-02, -2.906e-02, -1.335e-02, 1.800e-02) * s0_0_1;
	r1 += V4(-1.323e-01, 2.610e-01, -9.861e-02, -6.627e-03) * s0_0_1;
	r0 += V4(-3.431e-02, 3.523e-02, -1.558e-01, 1.251e-02) * s0_0_2;
	r1 += V4(-1.253e-01, 8.636e-02, 1.752e-02, -1.206e-02) * s0_0_2;
	r0 += V4(-1.481e-02, 4.860e-02, -2.928e-02, 7.353e-01) * s0_1_0;
	r1 += V4(-2.282e-02, 2.046e-01, -5.510e+00, 1.166e-02) * s0_1_0;
	r0 += V4(-7.485e-01, -3.357e-01, -6.341e-01, -7.090e-01) * s0_1_1;
	r1 += V4(-3.708e-02, -4.620e-01, 5.799e-01, 7.162e-01) * s0_1_1;
	r0 += V4(7.520e-01, -5.645e-01, 2.007e-02, -2.537e-02) * s0_1_2;
	r1 += V4(3.037e-01, 6.818e-02, -2.219e-02, -3.961e-02) * s0_1_2;
	r0 += V4(2.445e-02, -1.191e-02, -1.657e-01, 2.784e-03) * s0_2_0;
	r1 += V4(5.231e-02, -2.019e-02, 2.491e-01, -3.070e-02) * s0_2_0;
	r0 += V4(-7.319e-03, 7.129e-01, 2.614e-01, -1.460e-02) * s0_2_1;
	r1 += V4(3.452e-01, 2.844e-01, 5.344e-02, -7.012e-01) * s0_2_1;
	r0 += V4(-9.293e-03, 1.483e-01, 5.158e-01, 2.001e-02) * s0_2_2;
	r1 += V4(3.685e-02, 2.581e-02, 1.138e-02, 4.516e-02) * s0_2_2;
	r0 += V4(2.979e-03, 7.334e-04, 1.524e-03, -3.258e-04);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(2.117e-02, 1.515e-02, 3.821e-02, 1.041e-03);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-2x8-BOX-conv1
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
	r0 = D(r0, s0_0_0, 0xF5F6E3F9, 0x04B14743, 0x00D92A23, 0x05FD05FE);
	r1 = D(r1, s0_0_0, 0x01F10707, 0xF4EDF911, 0xFDF911FC, 0x05EF0113);
	r0 = D(r0, s0_0_1, 0xED09C9FE, 0xCEB53DFB, 0xD893561E, 0x1A06F815);
	r1 = D(r1, s0_0_1, 0x00F2FD0E, 0xD6DFFFDD, 0x1503F80D, 0xFFFA1611);
	r0 = D(r0, s0_0_2, 0xDE14EDF7, 0xF9E417FE, 0xFBC324F9, 0x11FA0502);
	r1 = D(r1, s0_0_2, 0x02FB02FB, 0x0EFD0AE9, 0xF9040502, 0xD9ED08E1);
	r0 = D(r0, s0_1_0, 0x0C114012, 0x15BA265A, 0xF7A33AF0, 0xF80308C9);
	r1 = D(r1, s0_1_0, 0x01FB0917, 0x0016F121, 0xFD072115, 0x05E9F509);
	r0 = D(r0, s0_1_1, 0x241E1C03, 0xDB964E38, 0xED8157F0, 0x070E173A);
	r1 = D(r1, s0_1_1, 0x3EED021C, 0x3EEF0350, 0x5F0C202D, 0x02E3C57F);
	r0 = D(r0, s0_1_2, 0xF5110E05, 0xDCE11AF1, 0x379D471B, 0xEAF40400);
	r1 = D(r1, s0_1_2, 0x0906FEFE, 0xCFF7EFFA, 0xF60C00FB, 0x81DFDF81);
	r0 = D(r0, s0_2_0, 0xF5EEFE42, 0xEAAD31BB, 0x04DA2B02, 0x0202FFEE);
	r1 = D(r1, s0_2_0, 0x040303FD, 0xFC09FDC8, 0x00000012, 0xFDF40D0A);
	r0 = D(r0, s0_2_1, 0x200010E9, 0x32A01E0C, 0xEA993707, 0x0202F90D);
	r1 = D(r1, s0_2_1, 0x0BFDFE05, 0x0405F8EB, 0x2AFF05EC, 0x1506170B);
	r0 = D(r0, s0_2_2, 0xF60402EC, 0x05EA220A, 0xDCD02315, 0x120202FF);
	r1 = D(r1, s0_2_2, 0xFFFFFFFF, 0x0CED090E, 0x0EFD00FC, 0xF4EAFA03);
	r0 = D(r0, s1_0_0, 0xF606FCF8, 0x18FEE9C2, 0xF5FFEEAB, 0xFAFFFD04);
	r1 = D(r1, s1_0_0, 0x2100FA06, 0x4703EE06, 0x0401FAFA, 0x01FFFF0A);
	r0 = D(r0, s1_0_1, 0xE8ECDEFF, 0xE0F9F409, 0x04D9000D, 0x27FEF4F5);
	r1 = D(r1, s1_0_1, 0x7F07E1E1, 0x6701E6E4, 0xF7F8EEFB, 0x250C16E6);
	r0 = D(r0, s1_0_2, 0xFFF118FF, 0xF0F90217, 0xEFF20135, 0x131F0C04);
	r1 = D(r1, s1_0_2, 0xFE0B0201, 0x05CD03F7, 0x000D08FE, 0x8107F519);
	r0 = D(r0, s1_1_0, 0xFBFFFDEC, 0x0705FFAF, 0x0104FCDF, 0x0800FD00);
	r1 = D(r1, s1_1_0, 0x01030708, 0xF203F714, 0xFBFFF0F0, 0xFD01F4F3);
	r0 = D(r0, s1_1_1, 0x240857F1, 0x0009F3E9, 0xF6D50FA3, 0xF2051DFD);
	r1 = D(r1, s1_1_1, 0x0F063DF6, 0xC90550EE, 0x25ED3814, 0x1B01472F);
	r0 = D(r0, s1_1_2, 0xEE22DC0D, 0xF80F252E, 0x18FE2064, 0x067FF60A);
	r1 = D(r1, s1_1_2, 0x0416FEFA, 0xE1080CF4, 0xEC2500F9, 0xE00CCBFC);
	r0 = D(r0, s1_2_0, 0x0DFD0310, 0xFD0A0AE1, 0xF103E4C6, 0xFE000001);
	r1 = D(r1, s1_2_0, 0xFBFCFDFB, 0xFBF510FA, 0x03FCFB06, 0xFE00FEF5);
	r0 = D(r0, s1_2_1, 0xFE0DEFFF, 0x1B93340B, 0xF7CE0C08, 0xFCFDED01);
	r1 = D(r1, s1_2_1, 0x0005FC03, 0xFE01D207, 0xF906E10A, 0xEDF5F3EA);
	r0 = D(r0, s1_2_2, 0xF7F2FEFE, 0x0E19171B, 0x20EE1B35, 0xFF10F806);
	r1 = D(r1, s1_2_2, 0x050C0BFE, 0x06030B10, 0x02FA0CFF, 0x0010D32B);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-9.959e-04, 4.509e-03, 6.380e-03, 7.434e-03);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(6.373e-04, -8.130e-04, 2.172e-03, -1.508e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-2x8-BOX-conv2
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
	r0 = D(r0, s0_0_0, 0xDF52ED04, 0x03E6FB02, 0x020AF200, 0xF4811706);
	r1 = D(r1, s0_0_0, 0xFF14FDFD, 0x0BF218FF, 0x07E802FD, 0x01F600FF);
	r0 = D(r0, s0_0_1, 0x15968194, 0x06D0B7E4, 0x0ACD25F8, 0x22F84760);
	r1 = D(r1, s0_0_1, 0xDFE505E4, 0x0C5CCEE1, 0xFAF61B07, 0x08F609FA);
	r0 = D(r0, s0_0_2, 0xFDDE4002, 0xFEEC0BFA, 0xE8FC1B14, 0x05F9081E);
	r1 = D(r1, s0_0_2, 0x0AEF2BFC, 0x1DF1ED20, 0xFA01FF04, 0x05FD0204);
	r0 = D(r0, s0_1_0, 0xFC101A0D, 0x19ADEDF2, 0x170A04F7, 0x3372F1DC);
	r1 = D(r1, s0_1_0, 0xD343000E, 0x0AFCFAFC, 0x0A160809, 0x10030000);
	r0 = D(r0, s0_1_1, 0xF1E781BA, 0xE2C219E3, 0x81ECF724, 0xF6F09781);
	r1 = D(r1, s0_1_1, 0x249ACC81, 0xFB81452F, 0xEBF7DEF3, 0x4D02F80C);
	r0 = D(r0, s0_1_2, 0x09EE01E5, 0x0D01BEF6, 0xD50110E9, 0x0DF20E18);
	r1 = D(r1, s0_1_2, 0xE00456E4, 0x02D94AFC, 0xF1FD0FFC, 0x0B0101FE);
	r0 = D(r0, s0_2_0, 0x14FBFF07, 0x1402E8FA, 0x0C0607FF, 0xEFD40B21);
	r1 = D(r1, s0_2_0, 0x13F10FF4, 0xFDF800F7, 0xFAF00011, 0x04FE0001);
	r0 = D(r0, s0_2_1, 0xFCF1F1E7, 0xC3E30E0E, 0xFFFAF400, 0xE9EF2B24);
	r1 = D(r1, s0_2_1, 0x08FB1BF4, 0x0F25E123, 0xEB050133, 0x00FE0413);
	r0 = D(r0, s0_2_2, 0xFBFAF90E, 0x100BEDF8, 0x07FDFF02, 0x04071319);
	r1 = D(r1, s0_2_2, 0x04E717E6, 0x0304EF12, 0x02FFFF01, 0x04000401);
	r0 = D(r0, s1_0_0, 0x21FFDA31, 0xFCF3F807, 0xF40005F7, 0xECC732E3);
	r1 = D(r1, s1_0_0, 0x0CF2F310, 0x09050CED, 0x07FB01FD, 0x04FF06F9);
	r0 = D(r0, s1_0_1, 0x04C514E3, 0x1AFE05F6, 0xF9F717DE, 0xCDA202D5);
	r1 = D(r1, s1_0_1, 0x0EFDF21E, 0xCBD430DA, 0x04FEED12, 0x02040AFD);
	r0 = D(r0, s1_0_2, 0x002409F3, 0xFC1C0EF4, 0x072BF911, 0xFEE10B04);
	r1 = D(r1, s1_0_2, 0x08EDF7FF, 0xF2CA13D3, 0x00080003, 0xFEF900FF);
	r0 = D(r0, s1_1_0, 0xE6F621C9, 0xDE0103ED, 0x0F03FAF6, 0x8D6B190A);
	r1 = D(r1, s1_1_0, 0xDE0BEC18, 0xBCE5070C, 0x311B12E5, 0xE5050205);
	r0 = D(r0, s1_1_1, 0x4460A36D, 0x6B7D0A01, 0x7FAB161A, 0xE47F41EF);
	r1 = D(r1, s1_1_1, 0x2E2A19E6, 0xEC46A855, 0xE8533FA6, 0x0A281209);
	r0 = D(r0, s1_1_2, 0xF7152EC8, 0x02C8E919, 0xFD541014, 0xEE04F5F8);
	r1 = D(r1, s1_1_2, 0xF520E3E4, 0xDC14ED2D, 0xFC2F0604, 0xFCF603FE);
	r0 = D(r0, s1_2_0, 0xF1F301E9, 0x0407ED10, 0xF5FF0AF1, 0x29C905D7);
	r1 = D(r1, s1_2_0, 0x3CFEEFC9, 0xC7142EE7, 0x1EDDFFFF, 0x00FEFAFB);
	r0 = D(r0, s1_2_1, 0x132615EF, 0x0EF847C1, 0xFDF1FA27, 0xF2D5FB1B);
	r1 = D(r1, s1_2_1, 0xD4F2041A, 0x01BE11E0, 0xFEB42664, 0x06E4FE04);
	r0 = D(r0, s1_2_2, 0x06F0F20B, 0xF70705F8, 0x0B01FFFD, 0xFED70FFD);
	r1 = D(r1, s1_2_2, 0x0524FDF2, 0x06E20DF1, 0x0001FE07, 0xFFFCFFFE);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.616e-02, -1.151e-02, -7.433e-03, -1.992e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.651e-02, -1.617e-02, -6.913e-03, -9.090e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-2x8-BOX-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv2
//!BIND LUMA
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 1
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
	r0 = D(r0, s0_0_0, 0xFFFDFA04, 0x00FF01FC, 0x000002FF, 0x000203FF);
	r0 = D(r0, s0_0_1, 0x04F9F5FF, 0x01F71DF8, 0xFF02FE01, 0x00030105);
	r0 = D(r0, s0_0_2, 0xFF0005FD, 0x05FDF803, 0xFFFF03FF, 0xFE0102FE);
	r0 = D(r0, s0_1_0, 0x060512F4, 0xFDFDFB03, 0x02050507, 0x00F5F8FF);
	r0 = D(r0, s0_1_1, 0xCEF5ED34, 0x013102DC, 0x1BEDDD26, 0x0C1037C4);
	r0 = D(r0, s0_1_2, 0x030101FF, 0xDBFB07FE, 0x050103FA, 0x18FCF40E);
	r0 = D(r0, s0_2_0, 0x00FAFA03, 0x01020203, 0xFDF700F6, 0x00010200);
	r0 = D(r0, s0_2_1, 0xFFFF0100, 0xFDFA06F9, 0x09FD030A, 0xFF0DF400);
	r0 = D(r0, s0_2_2, 0xFF01FE00, 0xFF00FF03, 0xFC00FF01, 0x06FF03FC);
	r0 = D(r0, s1_0_0, 0x000002E5, 0xFDFFFE19, 0x000202F5, 0xFF020108);
	r0 = D(r0, s1_0_1, 0x07220711, 0x060907F1, 0x05FD01FD, 0x04FC0107);
	r0 = D(r0, s1_0_2, 0xFFFFFE00, 0x010DFE03, 0xFF020100, 0x02FD00FF);
	r0 = D(r0, s1_1_0, 0xFFFE090E, 0x0702FFFB, 0xFFFBF5F9, 0x02FE060B);
	r0 = D(r0, s1_1_1, 0xC80B2614, 0xD2F731E4, 0xE031CA29, 0xE412C8D3);
	r0 = D(r0, s1_1_2, 0x01FD00FB, 0xF504000A, 0x04FC07FF, 0xFC0DF700);
	r0 = D(r0, s1_2_0, 0x0101FFFE, 0xFFFF0001, 0xFF020306, 0xFF0101FD);
	r0 = D(r0, s1_2_1, 0x0102FA00, 0x0602FA06, 0xEF0007F7, 0xFDFB0502);
	r0 = D(r0, s1_2_2, 0x04000000, 0x000000FF, 0x0300FFFD, 0xFA000305);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-2.972e-08, -1.074e-08, -2.944e-08, -1.583e-08);
	f0 = tanh(f0);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(f0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(f0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(f0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(f0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
