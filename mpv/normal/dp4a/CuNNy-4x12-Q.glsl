// CuNNy 4x12 (dp4a)
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


//!DESC CuNNy-4x12-in
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
	r0 += V4(-2.112e-02, -1.544e-02, -2.704e-02, -7.520e-03) * s0_0_0;
	r1 += V4(2.740e-02, -1.137e-03, 1.662e-02, -1.469e-02) * s0_0_0;
	r2 += V4(3.224e-02, 2.582e-02, -5.569e-02, -1.683e-02) * s0_0_0;
	r0 += V4(6.700e-01, -7.346e-02, -8.053e-01, -1.984e-02) * s0_0_1;
	r1 += V4(-4.508e-02, 8.288e-04, 2.851e-03, 5.234e-02) * s0_0_1;
	r2 += V4(2.837e-02, 1.488e+00, -1.124e-01, 1.196e-01) * s0_0_1;
	r0 += V4(2.955e-01, -7.147e-03, 1.351e-01, 2.011e-02) * s0_0_2;
	r1 += V4(6.127e-02, -3.987e-03, -1.342e-02, -3.306e-02) * s0_0_2;
	r2 += V4(-9.165e-02, 1.438e-02, -3.430e-02, 7.140e-02) * s0_0_2;
	r0 += V4(3.123e-02, -1.062e-01, 4.892e-04, 1.809e-02) * s0_1_0;
	r1 += V4(8.906e-02, 1.465e-03, -5.441e-02, 7.902e-02) * s0_1_0;
	r2 += V4(-6.041e-02, -2.523e-02, -2.485e-01, 5.020e-02) * s0_1_0;
	r0 += V4(-1.163e-01, 7.457e-01, 7.414e-01, 9.434e-01) * s0_1_1;
	r1 += V4(-9.460e-01, -7.732e-01, 8.008e-01, 6.258e-01) * s0_1_1;
	r2 += V4(8.680e-01, 1.527e-02, 6.066e-01, 9.284e-02) * s0_1_1;
	r0 += V4(-8.457e-01, -6.246e-02, -3.140e-02, -1.030e-01) * s0_1_2;
	r1 += V4(1.931e-01, 4.819e-03, -8.157e-04, -7.052e-01) * s0_1_2;
	r2 += V4(-7.765e-01, -1.577e-02, 1.368e-02, -1.395e+00) * s0_1_2;
	r0 += V4(-1.562e-02, 3.186e-02, 9.132e-03, -2.619e-02) * s0_2_0;
	r1 += V4(5.846e-02, -4.804e-04, -7.950e-01, -6.580e-02) * s0_2_0;
	r2 += V4(2.917e-02, -4.981e-03, -2.065e-01, -4.764e-03) * s0_2_0;
	r0 += V4(-1.811e-02, -1.666e-01, -2.846e-03, -7.733e-01) * s0_2_1;
	r1 += V4(2.192e-01, 1.058e-02, 3.009e-02, -6.738e-01) * s0_2_1;
	r2 += V4(5.749e-02, 1.023e-03, 7.463e-02, 6.158e-02) * s0_2_1;
	r0 += V4(1.835e-02, 4.880e-02, -2.191e-02, -4.936e-02) * s0_2_2;
	r1 += V4(2.008e-01, 7.598e-01, 1.518e-02, 7.389e-01) * s0_2_2;
	r2 += V4(-8.574e-02, -9.801e-03, 9.699e-03, 7.865e-02) * s0_2_2;
	r0 += V4(3.645e-03, 6.797e-03, 4.457e-03, 1.489e-02);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-1.605e-02, 6.707e-04, 2.307e-05, 2.531e-04);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(6.144e-03, -1.462e+00, 5.950e-03, 5.919e-03);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-4x12-conv1
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
	r0 = D(r0, s0_0_0, 0x1206E601, 0x320AEEF8, 0xE31313FE, 0xFB05FE02);
	r1 = D(r1, s0_0_0, 0xC90808FF, 0x12FD1EFB, 0xE1060908, 0x15F505B9);
	r2 = D(r2, s0_0_0, 0xFA02DD00, 0xFC0F1004, 0x1304D1FA, 0xF60ECEF7);
	r0 = D(r0, s0_0_1, 0x81169DFC, 0x070824FD, 0xE1FEE10E, 0x0F04EE08);
	r1 = D(r1, s0_0_1, 0x27F5DC07, 0x3C12D4FE, 0x1802B100, 0x16FD00DE);
	r2 = D(r2, s0_0_1, 0x1C0CD6F9, 0x3DF700F5, 0x1C09F706, 0xE9FF4615);
	r0 = D(r0, s0_0_2, 0xFC04D2FC, 0x010EFD0F, 0x06EE1DFC, 0xFFFF1803);
	r1 = D(r1, s0_0_2, 0x1717ED03, 0x0911B707, 0xFA0DF801, 0xFD01D5E8);
	r2 = D(r2, s0_0_2, 0xF804F804, 0xD3FFFB0A, 0xF7F90901, 0xD1EE4F09);
	r0 = D(r0, s0_1_0, 0x20E3F6DE, 0x07C811BB, 0x0125FEF3, 0xFE12D612);
	r1 = D(r1, s0_1_0, 0xFC33F412, 0xEB011903, 0xED090826, 0x02DD2917);
	r2 = D(r2, s0_1_0, 0x2AEA321A, 0xF71AE5D8, 0xEAECF9F9, 0x05E40859);
	r0 = D(r0, s0_1_1, 0x147345EF, 0x816EB2E9, 0x0EE2F9D9, 0x00115D0A);
	r1 = D(r1, s0_1_1, 0x78AA26DC, 0x0B03E3FD, 0x141532F6, 0xE9C520EA);
	r2 = D(r2, s0_1_1, 0xE6E50807, 0xD0BDCD81, 0xEDEEC9F5, 0x0E26F93A);
	r0 = D(r0, s0_1_2, 0x22F1E902, 0x0FF21925, 0xF60CDB04, 0xF408E305);
	r1 = D(r1, s0_1_2, 0x8126901D, 0xF1FEF512, 0xFB15FF02, 0xD4F0041C);
	r2 = D(r2, s0_1_2, 0xE71C120A, 0x001D520C, 0x04027D05, 0x43183E13);
	r0 = D(r0, s0_2_0, 0xF9FC1F0B, 0xF81DF302, 0xFBF0FFF0, 0xFAFC0F23);
	r1 = D(r1, s0_2_0, 0xD8D138FC, 0x17214BFA, 0x0103F1EC, 0xF4F70009);
	r2 = D(r2, s0_2_0, 0xF6BB0FD5, 0x00100514, 0x0501F20F, 0x10CEDC19);
	r0 = D(r0, s0_2_1, 0xFDE33CFF, 0x0D253281, 0x03F80A15, 0x070EDB34);
	r1 = D(r1, s0_2_1, 0x09814A81, 0x0A0A35F6, 0x05F50F08, 0x1221E7E4);
	r2 = D(r2, s0_2_1, 0xFC26FD01, 0xFB07F51F, 0x03FDE700, 0x03FDE2CC);
	r0 = D(r0, s0_2_2, 0xFBE42AF9, 0x0A81F40D, 0xFF081509, 0x0800FD05);
	r1 = D(r1, s0_2_2, 0xFC420934, 0xF013EC04, 0xFD171500, 0xFA2CFD1F);
	r2 = D(r2, s0_2_2, 0xFD0DFCFA, 0x1781F50C, 0x00E312FC, 0x1C0D9607);
	r0 = D(r0, s1_0_0, 0x01F718F7, 0x17113720, 0x0D0228F3, 0x04FDFC04);
	r1 = D(r1, s1_0_0, 0x0817EB06, 0xF204FAEF, 0xFBFF2206, 0x16EC2FED);
	r2 = D(r2, s1_0_0, 0x06F9EA01, 0x03FAFF0B, 0xFF0102FF, 0x1AF60EEC);
	r0 = D(r0, s1_0_1, 0xFF04F5E5, 0x0607FEEC, 0xDD2026FF, 0x08000EF7);
	r1 = D(r1, s1_0_1, 0x24E43509, 0x32D40907, 0x01FF0602, 0x042A81D9);
	r2 = D(r2, s1_0_1, 0x0E1BDBE9, 0xC906D724, 0x06F909FC, 0xC700D80D);
	r0 = D(r0, s1_0_2, 0x0B1605FC, 0x2CFAD71C, 0x00CEF710, 0x03F10905);
	r1 = D(r1, s1_0_2, 0x12FDFCFC, 0xFA77FAF7, 0x16170AF9, 0x11A5E203);
	r2 = D(r2, s1_0_2, 0x0E30FD04, 0xDAC6E127, 0x040AE709, 0x02810A0C);
	r0 = D(r0, s1_1_0, 0xF805D80B, 0xFC13F7FA, 0xF8070F02, 0x1EF022F3);
	r1 = D(r1, s1_1_0, 0xF3FE0C24, 0x13FFF4E3, 0xF60A1A0B, 0x09F5FFFB);
	r2 = D(r2, s1_1_0, 0xE1F60808, 0x1AFB14D6, 0x100005FD, 0xF4011AF4);
	r0 = D(r0, s1_1_1, 0x08EFFD2E, 0xFA124AE6, 0xFA01ED05, 0x2B0D01E4);
	r1 = D(r1, s1_1_1, 0xAFEDEEEB, 0xFD2CF11A, 0xF4F7F0D6, 0xF714F8DD);
	r2 = D(r2, s1_1_1, 0xF7F4EC27, 0x1D15E2FB, 0xF7051BFB, 0xD8B2481D);
	r0 = D(r0, s1_1_2, 0xFDE3FFFE, 0xBCC5CBFE, 0xFD0901F4, 0xFE110AE1);
	r1 = D(r1, s1_1_2, 0x207FF9E7, 0xEA2B0304, 0x0B0306E3, 0x153BF41E);
	r2 = D(r2, s1_1_2, 0x0110FD12, 0xFD1A817F, 0xF812F529, 0x218125F3);
	r0 = D(r0, s1_2_0, 0x03010E04, 0x1FFCE90B, 0x00000AF9, 0x04FF0B00);
	r1 = D(r1, s1_2_0, 0xFDFDEB2D, 0xE10CD211, 0xFF0007FE, 0x07020503);
	r2 = D(r2, s1_2_0, 0xFA02F8FE, 0x0A06081F, 0x0301FEFD, 0xFD12E7EC);
	r0 = D(r0, s1_2_1, 0xFB0200FF, 0xADE9EF19, 0x000604F2, 0x0E070ED4);
	r1 = D(r1, s1_2_1, 0xFC2313DB, 0xF5DDD47B, 0x02FA0AF0, 0x0C08FAF6);
	r2 = D(r2, s1_2_1, 0x00100105, 0x25041CE2, 0x010109EE, 0x11EB0E1F);
	r0 = D(r0, s1_2_2, 0xFB01FB10, 0xF2E3C218, 0x02FAFE01, 0xFFF908EF);
	r1 = D(r1, s1_2_2, 0x0FEED922, 0xFCF4FA2A, 0x080305ED, 0x01FFFC21);
	r2 = D(r2, s1_2_2, 0x05090102, 0x0DF8EA03, 0xFFFAFD0A, 0x14DF05CD);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x240F0319, 0x1A086310, 0x18FD3733, 0xFD000909);
	r1 = D(r1, s0_0_0, 0x23E6EF05, 0x2EF181CD, 0x1DF7CAFF, 0xD900E615);
	r2 = D(r2, s0_0_0, 0xF3041317, 0xDDF61E13, 0xFA01030C, 0xF312FF0D);
	r0 = D(r0, s0_0_1, 0xF7EC8213, 0x17D3DB1C, 0x08DB13F1, 0xEEF40410);
	r1 = D(r1, s0_0_1, 0x23045CF2, 0x282100E0, 0xFDF52C02, 0x8128D1E9);
	r2 = D(r2, s0_0_1, 0x0BF6F717, 0xF5F481F2, 0x01FD07FB, 0xBFF4651F);
	r0 = D(r0, s0_0_2, 0x0AF8F802, 0xD2BD0DF0, 0x071505FF, 0xF9F30E02);
	r1 = D(r1, s0_0_2, 0xEAF439F1, 0xF6B52206, 0xF9F020FD, 0xF015D10E);
	r2 = D(r2, s0_0_2, 0xEF0D2904, 0xF0FDD931, 0xFF0B09FE, 0xC5DCBD11);
	r0 = D(r0, s0_1_0, 0xEDFE7F0E, 0xE5BE432C, 0x06EAD357, 0x091ED714);
	r1 = D(r1, s0_1_0, 0x81E286E8, 0x7FF825F9, 0x8FF805E3, 0x812E7F0B);
	r2 = D(r2, s0_1_0, 0x3114BF36, 0x2128EDF6, 0x1E0F0A10, 0x1415F9D7);
	r0 = D(r0, s0_1_1, 0x071681FC, 0x94B3A381, 0x1901490E, 0xF801F416);
	r1 = D(r1, s0_1_1, 0xE8222112, 0x04127FFB, 0x1722AE14, 0xA29F7F07);
	r2 = D(r2, s0_1_1, 0xFE16F507, 0x812E7F81, 0x81E8F881, 0x1652099C);
	r0 = D(r0, s0_1_2, 0xF21511FF, 0x4737BAF4, 0x0A0A81F9, 0xF2F7F608);
	r1 = D(r1, s0_1_2, 0xF6B4210F, 0xEBE2E1F9, 0xF61A0009, 0xF9CC7F0D);
	r2 = D(r2, s0_1_2, 0xF10B210D, 0xC43B81F5, 0x2C27E5E3, 0xDBEB81E8);
	r0 = D(r0, s0_2_0, 0xCAF923FE, 0x8106B2EA, 0xD1088111, 0xF708E323);
	r1 = D(r1, s0_2_0, 0xA414BC16, 0x20E581DB, 0x1703A7FB, 0x5CFC1615);
	r2 = D(r2, s0_2_0, 0xDCFF592A, 0xEDEED418, 0x05F9E104, 0xF6DAD0F0);
	r0 = D(r0, s0_2_1, 0xF10A3308, 0xB96D81A6, 0x02FBDDF6, 0xEDD66EF9);
	r1 = D(r1, s0_2_1, 0x0CFF7FFE, 0x182781E8, 0x14087F14, 0x30FC2B09);
	r2 = D(r2, s0_2_1, 0xFCE28A06, 0xACBAD020, 0x1BF81409, 0x0A13D00D);
	r0 = D(r0, s0_2_2, 0xFDFA1C02, 0x085C7FE6, 0x0E0F81F8, 0x000DEBF9);
	r1 = D(r1, s0_2_2, 0x0D2D7FEB, 0x00FB8102, 0xEEE71309, 0xE3F02EED);
	r2 = D(r2, s0_2_2, 0xF0F00000, 0x05054CDF, 0xFDFD2909, 0x27277F04);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(5.541e-03, -2.474e-02, 5.547e-03, -3.326e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-4.390e-03, -4.099e-03, 2.687e-03, -3.581e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(9.665e-03, 1.349e-02, 3.283e-03, -1.162e-03);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-conv2
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
	r0 = D(r0, s0_0_0, 0x01000AFA, 0xF0EF1708, 0x042319FE, 0x0905F9FE);
	r1 = D(r1, s0_0_0, 0x180F12ED, 0x1006EC01, 0xF8FDF8FF, 0x29EA000C);
	r2 = D(r2, s0_0_0, 0xE8FD0701, 0xEEE7E131, 0xE6F90705, 0xF71002F7);
	r0 = D(r0, s0_0_1, 0x02F30C03, 0x891A0BF8, 0x350C001E, 0x02FC0B06);
	r1 = D(r1, s0_0_1, 0x21D71A1C, 0x2807E803, 0xF504E6FD, 0xE2FA12F6);
	r2 = D(r2, s0_0_1, 0xF40BDEFC, 0x4F00E9F7, 0xF319E6F1, 0x1F0DCD01);
	r0 = D(r0, s0_0_2, 0x050001FD, 0xC11A03E9, 0xF03E2CE2, 0x0904FC07);
	r1 = D(r1, s0_0_2, 0xE41306F4, 0xFE07E3F9, 0xFF0400FF, 0x0C01090D);
	r2 = D(r2, s0_0_2, 0x0E060201, 0xED0ADF03, 0xD612F6EC, 0x1302FD01);
	r0 = D(r0, s0_1_0, 0x06FD0A00, 0xFBF8140A, 0xDD00EB30, 0xFF051602);
	r1 = D(r1, s0_1_0, 0x09FF32E6, 0xFCF00109, 0x0F0BDB00, 0xECFC02FE);
	r2 = D(r2, s0_1_0, 0x00EEFFF8, 0xF01BE035, 0x0304D00F, 0xE8E3DCED);
	r0 = D(r0, s0_1_1, 0xCD07F2F8, 0x7CF5109D, 0x63F89662, 0x16090116);
	r1 = D(r1, s0_1_1, 0xDCF72C1B, 0xF0DEF326, 0x7F0700F5, 0x3D02E007);
	r2 = D(r2, s0_1_1, 0x3622FD05, 0x1A34F329, 0x18E6EADD, 0x8115F2E6);
	r0 = D(r0, s0_1_2, 0x0C06F7F7, 0x2AB40B0F, 0x06E13FE6, 0x001605F7);
	r1 = D(r1, s0_1_2, 0x091608D7, 0x10F0F1F8, 0x0B0F0714, 0xDF2F16FD);
	r2 = D(r2, s0_1_2, 0x14160C05, 0x23EEEAFC, 0x14EA0BE3, 0xF8F005EF);
	r0 = D(r0, s0_2_0, 0x04F6FA08, 0xF9061DF4, 0xB27336E1, 0xFE02F2F7);
	r1 = D(r1, s0_2_0, 0x11EA0BF3, 0x04F200F5, 0xFBF90DEE, 0xFEFE11F5);
	r2 = D(r2, s0_2_0, 0x02F20FF4, 0xDC32CC14, 0xFF14F215, 0x16E7E813);
	r0 = D(r0, s0_2_1, 0x1204EA3C, 0xE31B15E9, 0x5738221F, 0x0D0A0612);
	r1 = D(r1, s0_2_1, 0xED42FC12, 0x0008010C, 0xE3E01381, 0xF00C1DD7);
	r2 = D(r2, s0_2_1, 0xF4050BFF, 0x12FFD52B, 0x1BE5F637, 0xD57B1994);
	r0 = D(r0, s0_2_2, 0xF31A0914, 0x0F02FE06, 0x30A424BD, 0xF82EFF14);
	r1 = D(r1, s0_2_2, 0x01E114EE, 0x000001F2, 0x0EE601F7, 0xF31EF9ED);
	r2 = D(r2, s0_2_2, 0x0A05FCF9, 0x0AE7F802, 0xFB03FB0E, 0xFAF50805);
	r0 = D(r0, s1_0_0, 0x010F0207, 0xFE0BF825, 0xD1F21EFF, 0x0001FE0A);
	r1 = D(r1, s1_0_0, 0x0316120C, 0xFBF0100D, 0x00FFFCE2, 0x01F0F72D);
	r2 = D(r2, s1_0_0, 0xFD0C00FA, 0x11C2F80E, 0x0300F6F7, 0x0F0CFDFE);
	r0 = D(r0, s1_0_1, 0x02F9F303, 0xF22A00FE, 0xEBC9DB13, 0xFFF90009);
	r1 = D(r1, s1_0_1, 0x0DD8E9F4, 0xF0FCFAFC, 0x0B08FDF4, 0xF51307F4);
	r2 = D(r2, s1_0_1, 0xEA0B01F8, 0x05F80C1F, 0xFE1918F7, 0x100B15F6);
	r0 = D(r0, s1_0_2, 0xFF0400FB, 0xE215EF0E, 0xE7FD09E3, 0x05EF06FF);
	r1 = D(r1, s1_0_2, 0x070C0F02, 0x03FD0005, 0xFE0AFE00, 0xFBE91002);
	r2 = D(r2, s1_0_2, 0xF4E7FB1A, 0xF5F8F401, 0xF91AFBF6, 0x09EAF912);
	r0 = D(r0, s1_1_0, 0xF9F406FE, 0xFD0612F1, 0x21DA384C, 0x07F6F905);
	r1 = D(r1, s1_1_0, 0x02EB03EF, 0x02E90EFF, 0xFCEF200C, 0xFCECF917);
	r2 = D(r2, s1_1_0, 0x10060A09, 0xBBF0C833, 0x01FCFBFC, 0x062FF0B6);
	r0 = D(r0, s1_1_1, 0xF01603FD, 0x362A1A11, 0xE081E241, 0x01FAFE05);
	r1 = D(r1, s1_1_1, 0x006AFE1B, 0x0618D128, 0xF9E3F5E5, 0xE216C50A);
	r2 = D(r2, s1_1_1, 0xF317EB1B, 0x03B6FF0F, 0x15AB0CA6, 0xDA7F3722);
	r0 = D(r0, s1_1_2, 0x01170DF8, 0xF1D9FF06, 0x18FEC516, 0xFE040002);
	r1 = D(r1, s1_1_2, 0xF40A00F7, 0xF8EAFA06, 0x05E806FD, 0xFC2100F8);
	r2 = D(r2, s1_1_2, 0x10B6F70C, 0x0FE30F0A, 0x080716F4, 0x0CDEE11E);
	r0 = D(r0, s1_2_0, 0xF603FF03, 0xFDF80B0B, 0xD5F20BF6, 0xFDF6FAFA);
	r1 = D(r1, s1_2_0, 0x0702F4E3, 0xF4FFFB0C, 0xFFF803EB, 0xFEFF0705);
	r2 = D(r2, s1_2_0, 0x04040001, 0xDCD2281F, 0xEDFD0D0F, 0xDDE4F5EE);
	r0 = D(r0, s1_2_1, 0xEB1BF9FA, 0x0DF7170C, 0xE80C955C, 0xEFFD07F8);
	r1 = D(r1, s1_2_1, 0x0AEC10E9, 0xF3F5FE0B, 0x01CE1BF6, 0x18FC0103);
	r2 = D(r2, s1_2_1, 0xE6F8FC11, 0x05F4E820, 0xF212E611, 0x043226F3);
	r0 = D(r0, s1_2_2, 0x06F403FF, 0x0B02090C, 0xDCDC1D73, 0xFDEB1AFD);
	r1 = D(r1, s1_2_2, 0x0107FAF9, 0xFD060201, 0x0B0706FC, 0xFAFA0DF1);
	r2 = D(r2, s1_2_2, 0x060BFEFC, 0xFB03EF09, 0x10FC06F8, 0xE520F90B);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x04FA0001, 0xF7E63118, 0xD7E447EF, 0xFCFFFAFB);
	r1 = D(r1, s0_0_0, 0xF0F0E1F7, 0xEA1E15F2, 0xF8FF0009, 0xEF3D0010);
	r2 = D(r2, s0_0_0, 0x01F90706, 0xC9010C01, 0x07EA1F09, 0x03E901F1);
	r0 = D(r0, s0_0_1, 0xFBFBFD07, 0x31D40624, 0xFD21312A, 0x01F903FF);
	r1 = D(r1, s0_0_1, 0xF00A0704, 0xE30E0FFA, 0xF7080405, 0xE50904CA);
	r2 = D(r2, s0_0_1, 0x13F006F3, 0x0A121A01, 0x23F40D11, 0x080911EE);
	r0 = D(r0, s0_0_2, 0x040AFEFA, 0x10EDFD13, 0x03FEE30F, 0xF9FEFB05);
	r1 = D(r1, s0_0_2, 0x1403EFFE, 0xFE02FF0E, 0x06FD07F4, 0xFB000807);
	r2 = D(r2, s0_0_2, 0xFBF8050F, 0xEE04F8FD, 0x02F80104, 0xF312FF0D);
	r0 = D(r0, s0_1_0, 0xFBF805FD, 0x0DDB320A, 0xF306B99A, 0xFB27F7EF);
	r1 = D(r1, s0_1_0, 0xF0F8E201, 0xD62EF40F, 0xFA2509FB, 0x0BFE05F7);
	r2 = D(r2, s0_1_0, 0x0EE41428, 0xCBF302E4, 0x050AFD01, 0xFD81202C);
	r0 = D(r0, s0_1_1, 0xFB571303, 0xF7CE04F3, 0x862415F3, 0xF2FC0CDD);
	r1 = D(r1, s0_1_1, 0x06EC1102, 0xDA3516C6, 0x040110C6, 0x02AE0DE3);
	r2 = D(r2, s0_1_1, 0xD3BFC5DA, 0xDC1E03E6, 0xF4010C1B, 0x17AEAB12);
	r0 = D(r0, s0_1_2, 0x01FD06EC, 0xF7FC0C16, 0xFC0D1634, 0x02040809);
	r1 = D(r1, s0_1_2, 0x07E6E9DD, 0xF708FFF2, 0x01090E08, 0x05F6FFFE);
	r2 = D(r2, s0_1_2, 0xF902F02F, 0xDD06FE02, 0x09010701, 0xFF120E08);
	r0 = D(r0, s0_2_0, 0xFCFDFF0B, 0xED011FF1, 0x8A950493, 0xFFFF0308);
	r1 = D(r1, s0_2_0, 0xFDF4F70C, 0xEB05FA0E, 0xEBE724F5, 0x03F6110D);
	r2 = D(r2, s0_2_0, 0x07F612FE, 0xF0F507CA, 0xF3FFFBEC, 0x23CE1020);
	r0 = D(r0, s0_2_1, 0xFB1801FA, 0xFD0017B2, 0xAAF1C58A, 0x0CDF0308);
	r1 = D(r1, s0_2_1, 0x01FF12D4, 0x02060E22, 0x02EB021A, 0x14F90D15);
	r2 = D(r2, s0_2_1, 0xFEED00F6, 0xF11CFCE8, 0xF80102DB, 0x32210CCB);
	r0 = D(r0, s0_2_2, 0xFF0009FC, 0x03100400, 0xE3072CD6, 0x0BFD0827);
	r1 = D(r1, s0_2_2, 0x0005FD16, 0x0502FE05, 0xFD0504E8, 0x0101FD20);
	r2 = D(r2, s0_2_2, 0x0703F60C, 0xF80609FF, 0xF9FF0CF5, 0xF7F4052E);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-2.887e-03, -1.102e-02, -2.625e-02, -4.158e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-3.549e-03, -9.179e-03, 5.907e-03, -1.126e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-9.801e-03, -8.412e-03, -7.580e-03, -1.980e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-conv3
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
	r0 = D(r0, s0_0_0, 0xF0FEFDFC, 0xF314FD01, 0xF80A03FF, 0xD6150DE1);
	r1 = D(r1, s0_0_0, 0xF6110503, 0xF5040102, 0x0207F8FF, 0xF807FFF7);
	r2 = D(r2, s0_0_0, 0x010F06EE, 0xFDD7F403, 0xF20AFC01, 0xF0FDFCF3);
	r0 = D(r0, s0_0_1, 0xEEF30B12, 0xFA1D04F8, 0x00050003, 0xD30C1220);
	r1 = D(r1, s0_0_1, 0xE8162FFD, 0xE1F60EEB, 0x0704F015, 0x0FFD0B0F);
	r2 = D(r2, s0_0_1, 0xAFF01FE9, 0xF6FCF8F8, 0xF1B10300, 0x162006FD);
	r0 = D(r0, s0_0_2, 0xF7090C00, 0x100B000C, 0x070208FF, 0xE40C0A08);
	r1 = D(r1, s0_0_2, 0x0D0205F7, 0x160202FA, 0x0206010C, 0xFF0406FB);
	r2 = D(r2, s0_0_2, 0x03EB0A12, 0x020100FC, 0x050203FC, 0xF5FFFFFC);
	r0 = D(r0, s0_1_0, 0xB91201F0, 0x09F2F109, 0xF202FB00, 0xDD15E206);
	r1 = D(r1, s0_1_0, 0xBB0BFBE9, 0xF808F908, 0x050D0209, 0xFFFFF003);
	r2 = D(r2, s0_1_0, 0xFA1F00EB, 0xEFED00F1, 0x0E14FBEF, 0xDBFF0AE0);
	r0 = D(r0, s0_1_1, 0x84FEE41D, 0xE8E940F6, 0xE905D74F, 0xCEFD0F2A);
	r1 = D(r1, s0_1_1, 0xCB085081, 0xF121F0F5, 0x2309FFFD, 0xF308FC09);
	r2 = D(r2, s0_1_1, 0x180C2EED, 0x04F7FD10, 0xEEE5BB04, 0x5017D6F8);
	r0 = D(r0, s0_1_2, 0x0C0D181A, 0x24231100, 0x0606FFFC, 0x33091DFC);
	r1 = D(r1, s0_1_2, 0x201611F8, 0x1822FCF1, 0x040C0203, 0xFF08FE02);
	r2 = D(r2, s0_1_2, 0x02111C0D, 0x0D1520EB, 0x04FD04FF, 0xDCDB0FDE);
	r0 = D(r0, s0_2_0, 0x0517E70C, 0x02FFF2F8, 0x0404FBF9, 0x0F1AF9F2);
	r1 = D(r1, s0_2_0, 0xF80901DF, 0x03FF0007, 0xFF0002FD, 0x040400FF);
	r2 = D(r2, s0_2_0, 0x020805F5, 0x0FF703FC, 0x0F04F108, 0xE9FC19FF);
	r0 = D(r0, s0_2_1, 0x200913E8, 0x19F427C2, 0xF8FDF701, 0x1A14E2D5);
	r1 = D(r1, s0_2_1, 0xFB10FDCB, 0x0100F80D, 0x0602FFFD, 0x0205FE00);
	r2 = D(r2, s0_2_1, 0x0710040A, 0xEEFE2017, 0xFFF816F9, 0x3E2D1BFF);
	r0 = D(r0, s0_2_2, 0xFE120806, 0xDD0F0C03, 0xFFFE0803, 0xFC1A161C);
	r1 = D(r1, s0_2_2, 0xFC100E02, 0xF803040A, 0xFD050200, 0x03020102);
	r2 = D(r2, s0_2_2, 0x00030BFA, 0x040D0604, 0x00FFF9FD, 0xCAE0E7F4);
	r0 = D(r0, s1_0_0, 0xFFF6F908, 0x1205F704, 0x05FB0402, 0x0705F518);
	r1 = D(r1, s1_0_0, 0x0EFFE9F2, 0x0006FEFD, 0x010402FC, 0x090BFA04);
	r2 = D(r2, s1_0_0, 0xF2FB160F, 0xF8050F07, 0x0DF50207, 0x08EE0FFF);
	r0 = D(r0, s1_0_1, 0x0101F304, 0x0310FC0E, 0x0A01F8F9, 0x14051407);
	r1 = D(r1, s1_0_1, 0x0281F716, 0xFE2FE511, 0xF70703FD, 0x00451BF5);
	r2 = D(r2, s1_0_1, 0x0EFC0E18, 0x0D00FDF7, 0x0D0303FE, 0x12FB05EA);
	r0 = D(r0, s1_0_2, 0x09FFF903, 0x0C0C02FE, 0x0604FFFA, 0x0DFD0205);
	r1 = D(r1, s1_0_2, 0x00F7FF04, 0x0010E309, 0xFFF500FD, 0x0A08FD07);
	r2 = D(r2, s1_0_2, 0x23C8EFF1, 0x03FA0DF5, 0x0401FAFA, 0x09F20BF0);
	r0 = D(r0, s1_1_0, 0x19F7070E, 0x11EDF1F8, 0x0002FCFD, 0x32FBE0FD);
	r1 = D(r1, s1_1_0, 0x250A0B1B, 0x1407EFFF, 0x03F808FE, 0x1F0611FC);
	r2 = D(r2, s1_1_0, 0x0D06EBF7, 0xED04FF09, 0x1514FFFE, 0xFBF32320);
	r0 = D(r0, s1_1_1, 0x010F10E9, 0x1C921515, 0x0B020DFD, 0xDC20FAE3);
	r1 = D(r1, s1_1_1, 0x4DE1F326, 0x031126D1, 0xF513090F, 0xE9F600EB);
	r2 = D(r2, s1_1_1, 0xDE067F28, 0xE0B0C7BC, 0xF3E8061A, 0x01DAFDB3);
	r0 = D(r0, s1_1_2, 0x250CDC04, 0x19B4D90F, 0x07160A0B, 0x1F11B30A);
	r1 = D(r1, s1_1_2, 0x01F2DFF8, 0x0A1213D3, 0xF8F7E7FE, 0x0BFA0AFA);
	r2 = D(r2, s1_1_2, 0x2CDECBD3, 0x280928F8, 0x08FDFDF2, 0x29E20016);
	r0 = D(r0, s1_2_0, 0x2E0DD6F5, 0x0CF8FC01, 0x0CFC0303, 0x280DE109);
	r1 = D(r1, s1_2_0, 0x130103F6, 0x0DFA0204, 0x06FDF8FC, 0x0602FC01);
	r2 = D(r2, s1_2_0, 0x08F91604, 0x020EF9FA, 0x170505F9, 0xF2F81411);
	r0 = D(r0, s1_2_1, 0x10091C2E, 0x28E4F4E6, 0x1CFEF711, 0x30023727);
	r1 = D(r1, s1_2_1, 0x0BFD1EC7, 0xFA07F406, 0x05FE0CFC, 0x08FEFFFD);
	r2 = D(r2, s1_2_1, 0x0FF7EFFA, 0x02F788ED, 0x13F20203, 0x17EF0EB3);
	r0 = D(r0, s1_2_2, 0x10FBECFF, 0x42D4E4D2, 0x1DFB08F6, 0xFDE8F90B);
	r1 = D(r1, s1_2_2, 0x03FA1421, 0xF007F611, 0x06FB01FF, 0x0BFEFC00);
	r2 = D(r2, s1_2_2, 0x1EFBF0F2, 0x1B0124F6, 0xF606FBF9, 0x24F42814);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFBFC010E, 0xFFFFF7F8, 0xFF02FE04, 0xFBF9ED18);
	r1 = D(r1, s0_0_0, 0x08F3EFFF, 0xFE0EFCFA, 0x010A0309, 0xFDF7FE19);
	r2 = D(r2, s0_0_0, 0x0325F2FC, 0x06020100, 0xF8FDF812, 0x00090C11);
	r0 = D(r0, s0_0_1, 0x00E9F709, 0x06180106, 0x0EFEF000, 0xF719D41B);
	r1 = D(r1, s0_0_1, 0x05ED0F0B, 0x03D90BCD, 0xF92CF9F7, 0xF31AFA05);
	r2 = D(r2, s0_0_1, 0x18810FBB, 0x11E00702, 0x0AEAF1FE, 0xF5FAF2D6);
	r0 = D(r0, s0_0_2, 0xFF080208, 0x040AF9F8, 0xFD0103FA, 0xFF23E20E);
	r1 = D(r1, s0_0_2, 0x011409FF, 0xFEFF29F2, 0xFD05EA02, 0xFFFBFAFD);
	r2 = D(r2, s0_0_2, 0x00FA09F4, 0x0B08F803, 0x030603FD, 0x0704FDF7);
	r0 = D(r0, s0_1_0, 0x000EFC33, 0x04F2FB0B, 0xFF030102, 0xE510F317);
	r1 = D(r1, s0_1_0, 0xE7F7FFD7, 0xECF0FBF6, 0x04030104, 0xFDF2F422);
	r2 = D(r2, s0_1_0, 0xEE07F407, 0x110BFBFB, 0xECDCF72A, 0x06F80D30);
	r0 = D(r0, s0_1_1, 0xF20DCF1E, 0x100C1715, 0xE7D8130E, 0xEAADE904);
	r1 = D(r1, s0_1_1, 0x5F00CC01, 0xC3FC0E50, 0xF9EBF62C, 0x04F21EFE);
	r2 = D(r2, s0_1_1, 0x0A3407F5, 0x0BFFF9EE, 0x1A04E7C4, 0x021911C2);
	r0 = D(r0, s0_1_2, 0xF804EDF5, 0xF1F43BD7, 0xF8FFFAFE, 0xF0F1F7ED);
	r1 = D(r1, s0_1_2, 0xF611FBEB, 0xE207B8EF, 0xFEFB14FA, 0xFDFEEF05);
	r2 = D(r2, s0_1_2, 0x0409C8CE, 0x01F4D8FD, 0xFDF7FFFD, 0x02EBE10F);
	r0 = D(r0, s0_2_0, 0xE5F1E7F4, 0x080606F3, 0x0406FD03, 0xEDFCDBEE);
	r1 = D(r1, s0_2_0, 0xFE100302, 0x04FA05FE, 0xFD02FEF8, 0x01FE0308);
	r2 = D(r2, s0_2_0, 0xFD0C060D, 0x1E0808F5, 0x08F8F5FE, 0x07F32015);
	r0 = D(r0, s0_2_1, 0x02E0E74D, 0xE72906A2, 0x0B07F6F0, 0xDA16C01E);
	r1 = D(r1, s0_2_1, 0x043BF229, 0x0CFBFDEF, 0x03FE0500, 0x0004F302);
	r2 = D(r2, s0_2_1, 0x12E9FDEE, 0x13FAFCE9, 0x0D0624EE, 0xC0B1FDC3);
	r0 = D(r0, s0_2_2, 0xF2ECCAEF, 0x0619CBFB, 0x0000F5FD, 0xFD00C1F1);
	r1 = D(r1, s0_2_2, 0x140EC5FD, 0x0EF61DFA, 0xFF04FA01, 0x020102FD);
	r2 = D(r2, s0_2_2, 0x0C000FEB, 0x07F3ECFD, 0x0007F4F9, 0x10211019);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.970e-02, -5.568e-05, -1.482e-03, -2.748e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-2.409e-03, -8.275e-03, -1.861e-03, -1.444e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-1.986e-03, 6.477e-04, -8.860e-05, -7.055e-03);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-conv4
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
	r0 = D(r0, s0_0_0, 0xFFF8F2F6, 0xF8F5F20E, 0x05F9EEFC, 0xFEFDFA03);
	r1 = D(r1, s0_0_0, 0x09F5F006, 0x09F4F40A, 0x09F4F00A, 0x0FF909E9);
	r2 = D(r2, s0_0_0, 0xFFFCEE03, 0x81818181, 0xFB05F610, 0x0503F608);
	r0 = D(r0, s0_0_1, 0x0FF1F3E6, 0x0AF9F7E0, 0xF902F6D5, 0xFF00FA08);
	r1 = D(r1, s0_0_1, 0xFF04FAFB, 0xFE03F9FA, 0xFC02F9FF, 0xE9E2F722);
	r2 = D(r2, s0_0_1, 0x1906EBCC, 0x0B03F4F2, 0x0705F801, 0x0C0BF0E8);
	r0 = D(r0, s0_0_2, 0x00F3FBF6, 0x040006FE, 0xFF020107, 0x03020201);
	r1 = D(r1, s0_0_2, 0xF802FA0C, 0xFA05FB0C, 0xF805FA0D, 0xFCE50215);
	r2 = D(r2, s0_0_2, 0x03FF0102, 0x04FA01F8, 0x02020403, 0x020406F7);
	r0 = D(r0, s0_1_0, 0x00FB020B, 0x0310E501, 0x06FDF902, 0x0207D006);
	r1 = D(r1, s0_1_0, 0xFB0102F3, 0xFD0204F7, 0xFC0004F7, 0x080CF602);
	r2 = D(r2, s0_1_0, 0xFDFFE901, 0xFE080406, 0x0309C7DF, 0xE624C1F0);
	r0 = D(r0, s0_1_1, 0xF636C6E8, 0xDA3BCE25, 0x1D7FE5E4, 0xE70BD7EA);
	r1 = D(r1, s0_1_1, 0xF0F302F2, 0xEEF202F5, 0xF1F303F8, 0x1613F9DF);
	r2 = D(r2, s0_1_1, 0xF064BAFF, 0x050FFDF4, 0xEC29D72B, 0x0C4ED627);
	r0 = D(r0, s0_1_2, 0x0709E307, 0x050908F7, 0x0C0E01E8, 0xFC000205);
	r1 = D(r1, s0_1_2, 0xECF907F6, 0xEBF805FA, 0xECF906FC, 0x011001F0);
	r2 = D(r2, s0_1_2, 0x1207FBEA, 0xFD0101FE, 0xFB0507EC, 0xFC090AF4);
	r0 = D(r0, s0_2_0, 0x02000305, 0x04F5FAFB, 0x01020201, 0xFDF80500);
	r1 = D(r1, s0_2_0, 0xF209FEF5, 0xF306F8F7, 0xF309F9F9, 0xFFF50408);
	r2 = D(r2, s0_2_0, 0x02FF0902, 0x01FCFF01, 0xFE1100F7, 0x0CF602F8);
	r0 = D(r0, s0_2_1, 0xFDFC0AFD, 0x09FC05F6, 0x03010301, 0x1912ECF8);
	r1 = D(r1, s0_2_1, 0xF3F60900, 0xF8F406FF, 0xF6F60606, 0xFBF70504);
	r2 = D(r2, s0_2_1, 0x09020902, 0x01020001, 0x2C1DEFE6, 0x030600F9);
	r0 = D(r0, s0_2_2, 0x01FA0103, 0xFAFF0406, 0xFDFD00FF, 0xFDFF01FD);
	r1 = D(r1, s0_2_2, 0xF2FA03FC, 0xF7F600FA, 0xF7FB0701, 0x0000FF08);
	r2 = D(r2, s0_2_2, 0xFDFEFFFE, 0xFF000000, 0xFBFB04FF, 0xF9FD0704);
	r0 = D(r0, s1_0_0, 0xFE01F709, 0xFF09FA09, 0xFD03FD0B, 0xFF02FE06);
	r1 = D(r1, s1_0_0, 0xF7EBFD07, 0xFDEDF806, 0xF8EFFA08, 0x05F906F6);
	r2 = D(r2, s1_0_0, 0xFD03F50B, 0x81818181, 0x0004FF07, 0xFF06F70C);
	r0 = D(r0, s1_0_1, 0x0108FE0F, 0x0905FE07, 0x06FD04F3, 0x04000406);
	r1 = D(r1, s1_0_1, 0xF1E504F9, 0xF7E201F9, 0xF3E002FA, 0xF0FFF6B8);
	r2 = D(r2, s1_0_1, 0x0708FD10, 0x0DE805E6, 0x04FF0106, 0x0604FE05);
	r0 = D(r0, s1_0_2, 0x0A06FE07, 0x000000FF, 0x0104FEFE, 0xFF020002);
	r1 = D(r1, s1_0_2, 0xFAEE03FE, 0xFEE80301, 0xFBF005FE, 0x04070BEF);
	r2 = D(r2, s1_0_2, 0x0100FD02, 0xFCFF0004, 0xFF020003, 0xFFFF0000);
	r0 = D(r0, s1_1_0, 0xF2091608, 0xF218000C, 0xF116FAFE, 0xFA090207);
	r1 = D(r1, s1_1_0, 0x03EBEEE7, 0x02EFF1E7, 0x00EFF1E7, 0xFF201BDD);
	r2 = D(r2, s1_1_0, 0xF60517FF, 0x1500F2C1, 0xFEF90C05, 0x05F50BE2);
	r0 = D(r0, s1_1_1, 0x082D17EB, 0x1AF00CBF, 0x1520E8BC, 0x070508E9);
	r1 = D(r1, s1_1_1, 0xE1EAFC06, 0xE2EB0104, 0xE1E2FF05, 0xFDFB1600);
	r2 = D(r2, s1_1_1, 0x1AF41ECA, 0x09FBFCEB, 0x000501D7, 0x07E709AE);
	r0 = D(r0, s1_1_2, 0x1EE501EF, 0xFFFDFCE9, 0xFAFA01E3, 0x000502F9);
	r1 = D(r1, s1_1_2, 0xF0E1F100, 0xF1EEF101, 0xF2EAEFFF, 0x06F501F3);
	r2 = D(r2, s1_1_2, 0x03F8FEE6, 0xFE010101, 0xFE0304FB, 0xFB07FFFE);
	r0 = D(r0, s1_2_0, 0x04FC0608, 0xF7F3FB0A, 0xFE010207, 0xFBF1FE08);
	r1 = D(r1, s1_2_0, 0xE2EEF105, 0xE5F3F906, 0xE6F4F903, 0xFB011006);
	r2 = D(r2, s1_2_0, 0x05FCFB02, 0xFFFE0305, 0x0EEAE0D1, 0xFFF4EBF8);
	r0 = D(r0, s1_2_1, 0x0005F3FC, 0x374FD4DE, 0xF4020902, 0x5C1BE3D4);
	r1 = D(r1, s1_2_1, 0xF1FAEFFA, 0xF7F0F6F9, 0xF6F1F1F8, 0xE9152603);
	r2 = D(r2, s1_2_1, 0x15F7F8E5, 0xFCFE0004, 0x6104FCB1, 0x3C44E7E0);
	r0 = D(r0, s1_2_2, 0x1405F5F4, 0xE60CFCFF, 0xFB020001, 0xFBF002F7);
	r1 = D(r1, s1_2_2, 0x03E9F0FF, 0xFFF6EC01, 0x02F2F002, 0xF00A0E02);
	r2 = D(r2, s1_2_2, 0x02FBFE01, 0x040001FF, 0xE9FB0206, 0xDA080100);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFB04FD03, 0xF900FFFC, 0xF703FC09, 0x0400FFFB);
	r1 = D(r1, s0_0_0, 0xFC0001FE, 0xFCFE00FD, 0xFC000000, 0x02F60214);
	r2 = D(r2, s0_0_0, 0xFC04F90A, 0x81818181, 0x0AFEFFFC, 0x0CFCFE03);
	r0 = D(r0, s0_0_1, 0x1502ECFE, 0xFF01F8FE, 0x0CFDF503, 0xFBFFFFFC);
	r1 = D(r1, s0_0_1, 0x06F7F8F8, 0x06F8F7F7, 0x06FDF7FC, 0x2E171900);
	r2 = D(r2, s0_0_1, 0x05FCEF03, 0xFE81EE02, 0xF900F901, 0xE5F8F502);
	r0 = D(r0, s0_0_2, 0xEBFE00FE, 0x0803FE03, 0xFAFCFA01, 0x0608FB06);
	r1 = D(r1, s0_0_2, 0xFEFA07FA, 0xFEFE07F7, 0xFDFE0AFE, 0xE5001702);
	r2 = D(r2, s0_0_2, 0x04FBF901, 0x020181FD, 0x0507FA06, 0x0802FC03);
	r0 = D(r0, s0_1_0, 0x0605FBEC, 0xF506E7F1, 0x0108F7E3, 0xEB06F3F6);
	r1 = D(r1, s0_1_0, 0x04F301F3, 0x05F3FFF7, 0x04F501F8, 0xFAFE0301);
	r2 = D(r2, s0_1_0, 0xFE04FEE8, 0xF7F900F6, 0xFCFE05FD, 0xF3FE0FE6);
	r0 = D(r0, s0_1_1, 0xE0E4FFD0, 0x15ADB9F4, 0xFCE003CD, 0x1BC3BE0B);
	r1 = D(r1, s0_1_1, 0xFBF8F6F7, 0xFBFBF6F6, 0xFAFFFCFB, 0x0403EEC3);
	r2 = D(r2, s0_1_1, 0x07D40DE0, 0xFF15F507, 0xE2BBAA0F, 0xF9D3A310);
	r0 = D(r0, s0_1_2, 0x023AF00A, 0xEF190109, 0xF605F409, 0xF7050300);
	r1 = D(r1, s0_1_2, 0xF8FEF304, 0xF700F903, 0xF701F909, 0x0C05F5FE);
	r2 = D(r2, s0_1_2, 0xEA19F808, 0x01F803FE, 0x13F00100, 0x13E1FE01);
	r0 = D(r0, s0_2_0, 0xFEFD02FD, 0x0408FBE7, 0x00FE00FE, 0x0303F4EE);
	r1 = D(r1, s0_2_0, 0xFDF6FF02, 0xFDF5FD06, 0xFDF90007, 0xFFF8FB01);
	r2 = D(r2, s0_2_0, 0xFFFDFF01, 0x010100E6, 0xFBFE07E5, 0x0405FCF0);
	r0 = D(r0, s0_2_1, 0xF8FBF3DD, 0x02FCF0C0, 0x04FEF8EB, 0xFEEFFDC4);
	r1 = D(r1, s0_2_1, 0x1302F3F2, 0x1207F8F5, 0x1207F8F6, 0x060CF301);
	r2 = D(r2, s0_2_1, 0x0000FBDF, 0xFF02FF02, 0x08F8F4F0, 0x01F4F5ED);
	r0 = D(r0, s0_2_2, 0xFD090407, 0xFBF902FD, 0x01FD0004, 0xF40B0206);
	r1 = D(r1, s0_2_2, 0xF7EEF002, 0xF8EEF506, 0xF8F2F507, 0x0608FAF4);
	r2 = D(r2, s0_2_2, 0x01FB0203, 0x0004FF00, 0xFEEA03FD, 0xF8F801FF);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.856e-03, -3.778e-03, -3.381e-03, -2.631e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.466e-01, -1.426e-01, -1.450e-01, -9.908e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-1.820e-03, -4.958e-03, -2.848e-03, -3.746e-03);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-out-shuffle
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
	r0 += M4(-9.741e-02, -1.439e-03, 1.035e-02, 1.380e-02, -1.297e-02, 2.215e-02, 3.315e-03, 1.187e-02, 2.811e-02, -1.049e-04, -6.212e-03, -1.966e-03, -4.063e-02, -2.820e-03, -3.814e-02, -7.968e-03) * s0_0_0;
	r0 += M4(-1.304e-02, 6.538e-02, -8.742e-03, 8.349e-03, 9.364e-02, 1.217e-01, -5.739e-03, 6.741e-03, 4.724e-02, 5.209e-02, -6.799e-03, -1.141e-02, 3.447e-01, -4.588e-01, -2.918e-02, -9.156e-02) * s0_0_1;
	r0 += M4(-3.177e-05, -1.802e-03, -9.762e-08, -2.610e-04, -1.316e-03, 2.368e-02, -1.523e-03, -1.919e-03, -1.938e-03, 1.630e-02, -6.071e-06, -3.935e-03, -1.837e-02, 3.192e-02, -8.693e-03, -1.058e-02) * s0_0_2;
	r0 += M4(-9.221e-02, -8.016e-03, -2.093e-01, -2.350e-02, -3.082e-02, -1.863e-03, -8.091e-02, -9.824e-04, 3.467e-02, 1.775e-02, 1.130e-01, 1.825e-02, -6.987e-03, 3.755e-04, 3.719e-02, 9.991e-03) * s0_1_0;
	r0 += M4(1.587e-02, 1.401e-01, 1.753e-02, 1.724e-01, -6.100e-02, -9.201e-02, 2.725e-01, -3.521e-01, -2.549e-01, -3.453e-01, 2.036e-01, 2.455e-01, 3.172e-03, 4.806e-03, 1.294e-01, 1.087e-01) * s0_1_1;
	r0 += M4(1.641e-05, 1.421e-03, 2.440e-07, 1.501e-04, 8.943e-03, 4.846e-02, -2.789e-04, 8.521e-02, 1.156e-02, 1.194e-02, 5.658e-03, 5.264e-02, -1.826e-03, -1.120e-03, 6.985e-04, 1.925e-02) * s0_1_2;
	r0 += M4(-1.929e-05, 6.556e-04, 2.338e-04, 5.488e-03, -9.794e-05, -4.408e-04, -9.353e-03, 1.020e-03, -1.858e-03, -8.158e-04, -1.482e-02, -1.240e-03, 1.579e-05, 2.735e-04, 3.103e-04, 1.061e-03) * s0_2_0;
	r0 += M4(9.636e-04, 3.891e-03, -3.562e-03, 2.789e-02, 4.992e-03, -9.949e-04, -2.031e-02, -1.225e-02, 1.158e-03, 2.876e-04, -7.398e-02, -1.017e-01, 5.385e-04, -1.220e-03, 8.671e-04, -4.457e-03) * s0_2_1;
	r0 += M4(1.245e-05, -5.754e-06, -3.118e-07, -7.122e-05, -1.256e-03, -1.186e-03, -1.094e-03, 7.014e-03, -7.088e-04, 1.940e-03, -1.490e-03, -6.511e-03, -2.196e-05, -4.202e-05, 6.778e-06, 6.187e-05) * s0_2_2;
	r0 += M4(3.753e-02, -1.532e-02, 2.121e-02, -2.017e-02, -1.095e-01, -1.039e-01, -4.153e-02, -4.972e-02, 2.535e-02, 2.866e-02, 5.431e-02, 3.229e-02, 9.169e-03, 2.173e-04, 5.293e-03, -1.785e-03) * s1_0_0;
	r0 += M4(2.716e-02, 1.147e-01, 3.609e-02, 9.121e-02, 1.824e-02, 6.244e-03, -1.239e-03, 5.618e-02, -2.622e-03, -1.246e-02, -3.120e-02, -5.108e-03, 6.839e-02, 6.470e-02, 1.124e-02, 2.364e-02) * s1_0_1;
	r0 += M4(-2.583e-02, 1.467e-02, 3.196e-02, 3.447e-02, 1.956e-02, 2.180e-02, 2.443e-02, 2.413e-02, -4.811e-02, -4.326e-02, -4.573e-02, -4.198e-02, 3.221e-03, 1.673e-02, 1.395e-03, 2.150e-03) * s1_0_2;
	r0 += M4(-1.883e-02, 5.528e-02, 1.624e-02, 3.337e-02, 3.200e-02, 5.002e-02, -1.842e-02, -1.969e-02, -5.106e-02, -4.939e-02, -7.944e-02, -7.260e-02, -3.107e-02, 2.567e-03, -2.305e-02, 1.548e-03) * s1_1_0;
	r0 += M4(-3.041e-02, -1.560e-02, -8.780e-03, -1.713e-03, -3.201e-02, -2.961e-02, -5.273e-02, -6.193e-02, -1.207e-01, -1.084e-01, -1.249e-01, -1.226e-01, -1.150e-01, -1.042e-01, -1.335e-02, -4.671e-02) * s1_1_1;
	r0 += M4(-1.214e-02, -8.727e-03, -7.567e-03, -2.183e-03, -9.814e-03, -8.272e-03, -3.107e-02, -2.885e-02, 1.879e-02, 2.143e-02, 1.732e-02, 1.734e-02, 1.453e-02, -2.160e-02, 1.162e-02, 2.177e-02) * s1_1_2;
	r0 += M4(-2.398e-02, 5.129e-02, -2.388e-02, 2.714e-02, -1.149e-03, 3.734e-02, 3.293e-02, 1.244e-02, 3.152e-02, 4.031e-02, 3.761e-02, 4.167e-02, 2.033e-03, 3.860e-04, -1.187e-02, 7.240e-04) * s1_2_0;
	r0 += M4(-1.562e-02, 1.569e-03, -1.363e-02, -1.534e-02, -1.281e-01, -1.270e-01, -1.269e-01, -1.306e-01, 9.635e-02, 1.144e-01, 9.599e-02, 1.019e-01, -5.948e-05, -2.525e-03, -3.674e-02, -3.607e-02) * s1_2_1;
	r0 += M4(1.224e-02, 1.282e-02, 1.143e-02, 1.877e-02, -9.009e-02, -9.522e-02, -8.248e-02, -8.009e-02, -5.332e-02, -5.232e-02, -5.087e-02, -4.624e-02, 5.844e-03, 7.294e-03, 5.892e-03, -3.987e-03) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 += M4(4.599e-02, -1.201e-02, -8.655e-03, -1.605e-02, -2.526e-02, -1.321e-02, 1.921e-03, 3.210e-03, 5.111e-02, -6.547e-03, 2.387e-02, -4.771e-03, 1.010e-02, 8.127e-05, 2.465e-03, 4.279e-04) * s0_0_0;
	r0 += M4(-4.912e-02, -1.333e-01, 1.004e-02, -2.843e-03, 7.236e-02, 2.603e-02, 1.273e-02, 1.016e-02, -5.526e-01, 1.597e-01, 3.796e-02, 7.780e-02, 1.214e-01, 7.739e-02, -3.115e-04, -2.870e-03) * s0_0_1;
	r0 += M4(1.433e-03, -1.517e-02, -8.760e-05, 4.516e-03, 1.691e-02, 2.604e-02, -1.213e-02, -3.308e-02, 1.002e-02, -9.496e-03, 2.590e-03, 2.329e-02, 1.261e-02, -1.882e-02, 6.876e-03, -7.449e-03) * s0_0_2;
	r0 += M4(1.140e-01, -1.937e-03, 1.101e-01, 4.996e-03, 1.942e-01, -1.016e-02, -1.909e-03, -6.324e-02, 2.779e-03, -5.411e-04, 2.667e-02, 2.358e-03, 3.430e-02, 2.430e-03, 3.673e-02, -1.929e-03) * s0_1_0;
	r0 += M4(2.558e-01, 2.104e-01, -2.108e-01, -4.268e-01, -1.481e+00, 4.561e-01, 2.562e-01, 2.440e-01, 4.975e-03, 4.628e-03, 6.275e-02, 8.814e-02, 5.896e-02, 9.448e-02, -4.708e-01, 1.489e-01) * s0_1_1;
	r0 += M4(-1.070e-02, -1.402e-02, -5.051e-03, -5.359e-02, 5.530e-01, -1.005e+00, 5.979e-02, 7.249e-02, 5.728e-05, -6.160e-03, 4.045e-03, 3.528e-02, -6.855e-03, -3.844e-02, 1.270e-03, -1.183e-01) * s0_1_2;
	r0 += M4(5.461e-04, -8.961e-04, 2.496e-02, -2.793e-03, -4.893e-02, -8.989e-03, 6.566e-02, -6.144e-03, 3.676e-05, -7.491e-06, 3.901e-04, 6.974e-05, 1.487e-04, -9.950e-05, 1.028e-02, -4.236e-04) * s0_2_0;
	r0 += M4(-3.358e-03, -3.818e-03, 7.009e-02, 6.274e-02, 3.505e-01, 2.643e-01, -1.303e+00, 5.445e-01, -7.226e-04, 5.085e-04, -1.771e-03, 1.776e-03, -2.704e-03, 3.577e-03, 2.277e-02, 1.812e-02) * s0_2_1;
	r0 += M4(4.883e-04, -9.306e-04, 8.811e-04, 6.209e-03, 2.497e-02, -2.548e-02, -2.837e-02, -3.596e-02, 2.259e-04, 4.681e-04, 1.360e-04, 4.553e-04, 5.357e-04, 3.680e-04, 2.108e-03, -6.166e-03) * s0_2_2;
	r0 += V4(-1.439e-11, -8.409e-11, 2.110e-09, 3.189e-11);
	r0 = r0;
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
