// CuNNy 2x12 DS (dp4a)
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


//!DESC CuNNy-2x12-DS-in
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
	r0 += V4(-5.191e-02, 2.455e-02, 3.272e-01, 2.582e-02) * s0_0_0;
	r1 += V4(-4.211e-02, -7.496e-04, -2.097e-01, 1.265e-02) * s0_0_0;
	r2 += V4(-7.447e-02, 1.310e-02, -8.455e-02, 1.625e-02) * s0_0_0;
	r0 += V4(-2.028e-01, -5.257e-02, 1.477e-01, -5.079e-02) * s0_0_1;
	r1 += V4(4.814e-01, -8.497e-01, -2.609e-01, 2.017e-02) * s0_0_1;
	r2 += V4(-8.010e-02, -3.924e-02, -2.022e-02, -1.350e-01) * s0_0_1;
	r0 += V4(2.706e-01, 2.162e-02, -9.736e-03, 2.180e-02) * s0_0_2;
	r1 += V4(4.432e-01, 8.543e-01, 4.775e-01, -3.009e-02) * s0_0_2;
	r2 += V4(-3.725e-02, -6.188e-02, 4.952e-01, -9.321e-02) * s0_0_2;
	r0 += V4(5.377e-01, -8.473e-02, 6.348e-01, -1.252e-01) * s0_1_0;
	r1 += V4(-2.185e-03, 3.782e-03, -1.004e-01, -5.375e-02) * s0_1_0;
	r2 += V4(-2.385e-01, -1.786e-02, -1.480e-02, 2.699e-02) * s0_1_0;
	r0 += V4(-9.434e-01, -8.926e-01, -1.007e+00, -8.675e-01) * s0_1_1;
	r1 += V4(-9.980e-01, -5.412e-02, -4.424e-01, -1.035e+00) * s0_1_1;
	r2 += V4(1.031e+00, -7.735e-02, -2.289e-02, 6.952e-01) * s0_1_1;
	r0 += V4(4.494e-03, -1.101e-01, -1.018e-01, -1.142e-01) * s0_1_2;
	r1 += V4(1.165e-01, 7.109e-02, 6.309e-01, 1.087e+00) * s0_1_2;
	r2 += V4(-1.140e-01, -8.667e-02, -1.041e-01, -3.534e-01) * s0_1_2;
	r0 += V4(3.375e-01, 6.424e-02, 1.994e-02, 9.097e-02) * s0_2_0;
	r1 += V4(3.208e-02, 1.428e-03, 2.434e-02, 2.824e-02) * s0_2_0;
	r2 += V4(-5.633e-02, 5.896e-02, -5.889e-03, 3.063e-02) * s0_2_0;
	r0 += V4(2.049e-01, 9.394e-01, -1.221e-01, 9.395e-01) * s0_2_1;
	r1 += V4(-7.108e-03, -8.539e-03, -1.112e-01, -2.324e-02) * s0_2_1;
	r2 += V4(-2.983e-01, -1.784e-01, -4.995e-02, -5.822e-02) * s0_2_1;
	r0 += V4(-1.770e-01, 9.111e-02, 1.068e-01, 8.840e-02) * s0_2_2;
	r1 += V4(-2.290e-02, -1.237e-02, 7.306e-03, -3.704e-03) * s0_2_2;
	r2 += V4(-1.217e-01, 5.689e-01, -2.592e-02, -6.608e-03) * s0_2_2;
	r0 += V4(-4.064e-03, -7.491e-03, -4.980e-04, 1.221e-02);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(9.808e-04, 1.763e-02, 2.270e-03, -5.116e-03);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(3.953e-03, 8.306e-03, 1.239e-02, 4.828e-03);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-2x12-DS-conv1
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
	r0 = D(r0, s0_0_0, 0xEF110CFB, 0x200BF6EF, 0xF60B1A0C, 0x2DECA227);
	r1 = D(r1, s0_0_0, 0x47EE9C1F, 0x1902EA01, 0xB8F72B14, 0x2E02CD03);
	r2 = D(r2, s0_0_0, 0x2D07B4EC, 0xCF0C4CE1, 0x0302FCFE, 0xAA0C55CB);
	r0 = D(r0, s0_0_1, 0x7F0181EB, 0xD8046BFA, 0x8102810D, 0x6A02FC11);
	r1 = D(r1, s0_0_1, 0x3101FD23, 0x44FFDAFE, 0x7F00810E, 0x81F77F08);
	r2 = D(r2, s0_0_1, 0xA6EF0519, 0x9A007FF0, 0x64FDC5E6, 0x1F1F18B8);
	r0 = D(r0, s0_0_2, 0x1AED9EB1, 0xB2005D0B, 0x24E2B30C, 0x81FF4941);
	r1 = D(r1, s0_0_2, 0xAD18711E, 0x1913F2F9, 0xE0073400, 0x3306C603);
	r2 = D(r2, s0_0_2, 0x2CEFBF1A, 0x4217CEEC, 0xF2061DFB, 0x3928F698);
	r0 = D(r0, s0_1_0, 0x27F4EF0C, 0xCC041DF9, 0xDAF13302, 0x2FD58126);
	r1 = D(r1, s0_1_0, 0x2CED920C, 0x1501FA0D, 0x59F3B0F4, 0xE6F40B21);
	r2 = D(r2, s0_1_0, 0x06FBF80C, 0xD3010CF9, 0x55FDBBF1, 0xF82003C6);
	r0 = D(r0, s0_1_1, 0x99377F2B, 0xC4ED68C8, 0xF518F01C, 0x31ECACFB);
	r1 = D(r1, s0_1_1, 0xCDD8880F, 0x5306CD13, 0x0126491F, 0x47EDDBFB);
	r2 = D(r2, s0_1_1, 0x0902E124, 0xC7E932B0, 0x0CFC45EF, 0x2F1BA9B2);
	r0 = D(r0, s0_1_2, 0x31D0DCF5, 0x300F8129, 0x2898DAD9, 0xDBF9332B);
	r1 = D(r1, s0_1_2, 0xFF022F37, 0xF02114F6, 0x1FF8E5FA, 0xEA2B380B);
	r2 = D(r2, s0_1_2, 0x1C24FA06, 0x2E20C2DC, 0x2904E0DB, 0xFE4F04CB);
	r0 = D(r0, s0_2_0, 0x1BF6E810, 0xF603EF0C, 0x10F6EB13, 0xBFD23120);
	r1 = D(r1, s0_2_0, 0xECD1FD24, 0xFC02FE01, 0xFA060A08, 0x05E7F202);
	r2 = D(r2, s0_2_0, 0x08ECF60B, 0x180CEBF1, 0xFFFF0202, 0xEB4527D1);
	r0 = D(r0, s0_2_1, 0xDBF324FD, 0x1E23B911, 0x100A0CF5, 0x3CAAA625);
	r1 = D(r1, s0_2_1, 0x1281DB28, 0x071B0AFB, 0x05F0FEF4, 0xE8222D0B);
	r2 = D(r2, s0_2_1, 0x04F30DE7, 0xE84023F4, 0x2811ECE1, 0x0A6E07BF);
	r0 = D(r0, s0_2_2, 0x331DE3FE, 0xD09081DB, 0xFE321D05, 0xD0EE2C12);
	r1 = D(r1, s0_2_2, 0xC6FA2101, 0xEE0E14FD, 0xF62114EF, 0x002A10F7);
	r2 = D(r2, s0_2_2, 0x1E53F2EB, 0x582998EA, 0xFC0F0BF5, 0x1E40D4C4);
	r0 = D(r0, s1_0_0, 0x24EDF2F0, 0x2DEB2004, 0x04ECFFE2, 0x12E80220);
	r1 = D(r1, s1_0_0, 0xEBE40C1C, 0xEB12FDFC, 0x210401FE, 0x0107FCFE);
	r2 = D(r2, s1_0_0, 0xEC12EF04, 0x050BF7F3, 0xF607FAFB, 0xBD1AE9E9);
	r0 = D(r0, s1_0_1, 0xDA0DFCE0, 0x45F60C07, 0x81FCFDF3, 0xB912EE08);
	r1 = D(r1, s1_0_1, 0x3BFE171D, 0x090EFFFF, 0xF31203FE, 0xE70AFAFE);
	r2 = D(r2, s1_0_1, 0xCE100310, 0xD2FEF8E4, 0xF90CF5F6, 0x29F312E7);
	r0 = D(r0, s1_0_2, 0xBA1B08FF, 0x0E09EF08, 0xF02DDFDF, 0xA80DF9F5);
	r1 = D(r1, s1_0_2, 0xDD040703, 0xF60300FA, 0xDF040103, 0x1011FFFE);
	r2 = D(r2, s1_0_2, 0x151D050A, 0x0F0900EF, 0xFC09F902, 0x2FD917E8);
	r0 = D(r0, s1_1_0, 0xCC3FEEFC, 0x7FE9FCF9, 0x182911F6, 0xF2DB2C4C);
	r1 = D(r1, s1_1_0, 0x81F23046, 0x330C1AF9, 0x81F2D50C, 0x3DFCF006);
	r2 = D(r2, s1_1_0, 0x8413ED04, 0x65F2EEE9, 0x0C08FFF1, 0x1DE251DE);
	r0 = D(r0, s1_1_1, 0x40D3FF81, 0x7FABC7C0, 0x9FFE4081, 0x5DE020C4);
	r1 = D(r1, s1_1_1, 0xF5E4ABF9, 0x0406F9E9, 0x40FB0B1C, 0xEF1FF903);
	r2 = D(r2, s1_1_1, 0x30151C17, 0x38CD39B0, 0x2907F8F9, 0xDDE920B4);
	r0 = D(r0, s1_1_2, 0xF9E734E9, 0xC3D6E8E4, 0x0406E20B, 0x13F8410E);
	r1 = D(r1, s1_1_2, 0x19FA1CE3, 0x0CFB0BF1, 0xFEF037FB, 0x1409E809);
	r2 = D(r2, s1_1_2, 0x2AF3E7FF, 0x36DB16EE, 0x0CFBFCF9, 0x3CFFEED2);
	r0 = D(r0, s1_2_0, 0x2DEFF9E4, 0x07E4E32E, 0x2ED9E60F, 0xE60CC31F);
	r1 = D(r1, s1_2_0, 0xD92CA7B6, 0x070CF715, 0x1AC181B3, 0xECF6BE2C);
	r2 = D(r2, s1_2_0, 0x3A01E288, 0xF6E1FE19, 0x06E81B22, 0xDDFE34EC);
	r0 = D(r0, s1_2_1, 0x050C9622, 0x9A4EA804, 0xFFD57F61, 0xF0FEF309);
	r1 = D(r1, s1_2_1, 0xCB331FEC, 0x14EF13F6, 0xE729C8DD, 0x0AF0083A);
	r2 = D(r2, s1_2_1, 0x0FD4650E, 0xD6FB1440, 0x05E50FFB, 0xD60439F0);
	r0 = D(r0, s1_2_2, 0x1BBF3309, 0x81EF4CF0, 0x23D500EF, 0x31CE1624);
	r1 = D(r1, s1_2_2, 0x32E610FB, 0x02F4FF09, 0x050B1BF8, 0x12EFFDFE);
	r2 = D(r2, s1_2_2, 0x21D221E9, 0xDD1100E8, 0x04F2F7FB, 0xE82BC9EB);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x23524EEE, 0xEACD8127, 0x0D475407, 0xE1E1B503);
	r1 = D(r1, s0_0_0, 0x02E303F3, 0x08FC2EF6, 0x040421F7, 0x040814FB);
	r2 = D(r2, s0_0_0, 0x110853E0, 0x090E83FA, 0x1900D2FA, 0xF3FFE429);
	r0 = D(r0, s0_0_1, 0x2024A4E4, 0xD5FF091F, 0xCC00C410, 0xC4112CFA);
	r1 = D(r1, s0_0_1, 0x9CD4E40A, 0xD5F3F205, 0xFFE3F6F1, 0x1402EEEF);
	r2 = D(r2, s0_0_1, 0xFADF2CD3, 0x0C1F3236, 0xF80CFB0C, 0xDD1D0B10);
	r0 = D(r0, s0_0_2, 0x230C4120, 0xF0FFF72E, 0x7227ED03, 0x4A01081B);
	r1 = D(r1, s0_0_2, 0x1AE2F416, 0x09020204, 0x01F9EA00, 0x03FB0EFD);
	r2 = D(r2, s0_0_2, 0xDEDEEBFB, 0xDCFBE73B, 0x0800F503, 0x0C0FDF1E);
	r0 = D(r0, s0_1_0, 0xFB99E00C, 0x0526F100, 0xD8B513F2, 0x2C1F0A2C);
	r1 = D(r1, s0_1_0, 0xCF282B0E, 0xE6020BEC, 0x1F01B230, 0x170318F3);
	r2 = D(r2, s0_1_0, 0xEE170AFA, 0x312B310F, 0xFA0D111A, 0xE5E73B03);
	r0 = D(r0, s0_1_1, 0xB29A112C, 0xFC58EAC3, 0xD0A7546D, 0x3A1444B9);
	r1 = D(r1, s0_1_1, 0x083843E8, 0x2DEEFC0C, 0xFF0E0CEF, 0x04FCF423);
	r2 = D(r2, s0_1_1, 0x04081948, 0x4554E0DF, 0xF30316E8, 0xEEE2F027);
	r0 = D(r0, s0_1_2, 0x0F3606DA, 0x08094DCA, 0xD53B0ED3, 0xD820E4F4);
	r1 = D(r1, s0_1_2, 0xF009CA0C, 0xF3160816, 0xF7F8F8EA, 0xF4E8F3F4);
	r2 = D(r2, s0_1_2, 0xEAC9FAEA, 0xACFC37F6, 0xEB16031A, 0xC3210E1C);
	r0 = D(r0, s0_2_0, 0xED2300FC, 0x11B91717, 0xFE17E71A, 0x08810509);
	r1 = D(r1, s0_2_0, 0x040B0AEC, 0xEBFFFBFB, 0xFE4F0BFF, 0xE20CF711);
	r2 = D(r2, s0_2_0, 0xFD78EDEE, 0xF9A1FE1D, 0x16CCF304, 0x14101AEB);
	r0 = D(r0, s0_2_1, 0xEC27E312, 0x1CC75BC9, 0x0FC3DCFE, 0x501C0B0B);
	r1 = D(r1, s0_2_1, 0x5C0B311D, 0xF6FDFC04, 0x0323FC02, 0xFA17F7E8);
	r2 = D(r2, s0_2_1, 0xDAE5EDED, 0xD5CB0EEF, 0x30F203FF, 0x0EB81F02);
	r0 = D(r0, s0_2_2, 0xFACFFAF8, 0x1237FB4E, 0x060DF8EA, 0xC7C70818);
	r1 = D(r1, s0_2_2, 0xC1F10401, 0x02000104, 0x01E6FAFC, 0x00F7FF09);
	r2 = D(r2, s0_2_2, 0x01EAF212, 0x4AE3031D, 0xFD08FA0C, 0xFD170723);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.999e-02, 1.836e-02, 3.515e-04, -3.747e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.488e-02, -1.641e-02, 2.274e-02, 1.248e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-8.843e-03, -2.921e-02, 4.954e-03, -4.043e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-2x12-DS-conv2
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
	r0 = D(r0, s0_0_0, 0xF109FCFD, 0x1CFDC2F9, 0x1600EFEE, 0x0CFAEA00);
	r1 = D(r1, s0_0_0, 0xE8FCDE05, 0x04F30C0F, 0x0D00E9FA, 0x0803F601);
	r2 = D(r2, s0_0_0, 0x0DD60798, 0xF102C806, 0xF905FCF8, 0xE608DFF9);
	r0 = D(r0, s0_0_1, 0xF4FFF3F9, 0xEB03F9F7, 0x0307F0EF, 0x0A0BF9F5);
	r1 = D(r1, s0_0_1, 0x36DF99FF, 0x0AEE0516, 0xF5F8EE0F, 0x0106F805);
	r2 = D(r2, s0_0_1, 0x40A112CA, 0x0606ECE5, 0xFCFEFA05, 0x0BFBBCEA);
	r0 = D(r0, s0_0_2, 0xF80403F8, 0x0302F5FF, 0xFC01F501, 0x09FBF306);
	r1 = D(r1, s0_0_2, 0xFF131FE7, 0x04F40605, 0xFE08FDF9, 0xFFFDF50B);
	r2 = D(r2, s0_0_2, 0x02DD1302, 0xF9FA0701, 0xFBFEF80C, 0xF9FE0EF4);
	r0 = D(r0, s0_1_0, 0xF6D9F6ED, 0x11E3CFD2, 0x0FF9D5D1, 0x07F9E6FA);
	r1 = D(r1, s0_1_0, 0xE5F8E4EE, 0xFDEEFE1E, 0xF8E9FEE5, 0xFF00BDF5);
	r2 = D(r2, s0_1_0, 0xF9FAF4F2, 0xF7E5CFEC, 0x050AF323, 0xE4FAD5E7);
	r0 = D(r0, s0_1_1, 0xFBDB13F4, 0xDEE01B1D, 0xF0E2048D, 0x18E5CE09);
	r1 = D(r1, s0_1_1, 0x36D9E6CB, 0x0DD21F62, 0x33CAF810, 0x1403D4FA);
	r2 = D(r2, s0_1_1, 0xBBE7EFEB, 0xE2EC0804, 0x2909F500, 0x28C7E8E7);
	r0 = D(r0, s0_1_2, 0xF90304F3, 0x0C0FFFF9, 0xFD12FFF5, 0xEA0AFAEC);
	r1 = D(r1, s0_1_2, 0xBD0E0CF9, 0x0DE8121A, 0x02F50008, 0xFD18E6C1);
	r2 = D(r2, s0_1_2, 0xF8EEF801, 0xF5FCFEFA, 0x0B0AF70B, 0xEB080F01);
	r0 = D(r0, s0_2_0, 0xF9FA04F3, 0xF8FAEAFC, 0xF2F6FAEE, 0xFFFB12ED);
	r1 = D(r1, s0_2_0, 0xFEFBFFFD, 0x0CF21213, 0xF8FBF3E8, 0x05FD06F2);
	r2 = D(r2, s0_2_0, 0x07040CF7, 0x05FA13ED, 0x0AF9D3D7, 0xFEF2FFEA);
	r0 = D(r0, s0_2_1, 0xEEECFFEF, 0x0BF40606, 0x150214E6, 0xF7E602EF);
	r1 = D(r1, s0_2_1, 0x04E8FBF7, 0x06ED1425, 0xFEEBF2EF, 0x04FB02FF);
	r2 = D(r2, s0_2_1, 0x12080B01, 0xF4E7F5F7, 0x00C7F9E7, 0x0ED102E7);
	r0 = D(r0, s0_2_2, 0xED0A02F4, 0xF60FFCF3, 0x050E02EC, 0x19F50100);
	r1 = D(r1, s0_2_2, 0xFE10FDF8, 0x03F9070A, 0x08F901FD, 0x22EB0713);
	r2 = D(r2, s0_2_2, 0x0E050601, 0xF905FCFF, 0xF10104DD, 0xE90D0100);
	r0 = D(r0, s1_0_0, 0xFC03F603, 0xDE05F5EF, 0x0E0C00EF, 0xFFFBFCF2);
	r1 = D(r1, s1_0_0, 0x02040E1E, 0x1302FFF8, 0xFE0D04FA, 0xFE0403F2);
	r2 = D(r2, s1_0_0, 0xE4EB0300, 0xE8F9060D, 0xE30C030A, 0xEB010E19);
	r0 = D(r0, s1_0_1, 0xEB0800F2, 0x0C0EF9F4, 0x1AFF19EC, 0x140110FB);
	r1 = D(r1, s1_0_1, 0xEE0EE99B, 0x10F40BFE, 0xEF14D809, 0x00011000);
	r2 = D(r2, s1_0_1, 0xFBDADDBF, 0x05050AE5, 0xF90DFC06, 0xFF0FFACE);
	r0 = D(r0, s1_0_2, 0x020D06FB, 0xF80415F4, 0xF4FD02FE, 0xEBFA03F9);
	r1 = D(r1, s1_0_2, 0x030714EB, 0x06F9FF01, 0x06130BF4, 0xEDF3EF05);
	r2 = D(r2, s1_0_2, 0xED060FF3, 0xFBFDFEFF, 0x070BF406, 0xFA0C11F1);
	r0 = D(r0, s1_1_0, 0xDD030902, 0xEB1A3AFB, 0xE0FAF401, 0xFE05080B);
	r1 = D(r1, s1_1_0, 0x04070310, 0x0FF00900, 0x04071A0B, 0xFDF9F809);
	r2 = D(r2, s1_1_0, 0x0905E90E, 0x0D10F8F4, 0x210107F1, 0x01FAFF10);
	r0 = D(r0, s1_1_1, 0x0CEA1AF6, 0x0C0FD8DA, 0x41CCF4CE, 0xF1E9CAA3);
	r1 = D(r1, s1_1_1, 0xE1FC1BE2, 0xB7AA32FD, 0x00241EC0, 0x2EF6C5A6);
	r2 = D(r2, s1_1_1, 0x1E04F725, 0xF8E1DFE5, 0xE1FE14CB, 0x0E0C03D1);
	r0 = D(r0, s1_1_2, 0xF60935F4, 0xF50B3FE7, 0xFFFD48E3, 0x170E1801);
	r1 = D(r1, s1_1_2, 0xF82029BF, 0x0A04F9F1, 0xFA08F8F7, 0x31F727D9);
	r2 = D(r2, s1_1_2, 0x0B000F19, 0xFD151CF7, 0xFCE7FDEF, 0xF51416D2);
	r0 = D(r0, s1_2_0, 0x03FD0007, 0xFFFA0206, 0xF51D1A15, 0xFFFCFEFA);
	r1 = D(r1, s1_2_0, 0x0302090A, 0x18F9FBFF, 0x08FDFE0A, 0xF40408F4);
	r2 = D(r2, s1_2_0, 0xF10210F8, 0xFFF306FE, 0xEEE4F5EA, 0xFC051309);
	r0 = D(r0, s1_2_1, 0x09081203, 0xFE00F9F4, 0xF3EF07F0, 0x160B1624);
	r1 = D(r1, s1_2_1, 0x080501FF, 0x0EE6BA02, 0x13120A0D, 0xF9001C20);
	r2 = D(r2, s1_2_1, 0x02FD17F9, 0x0D0C120B, 0x2FC4CECA, 0x0B0319FC);
	r0 = D(r0, s1_2_2, 0xFBF8090D, 0xF70116FF, 0xF10830F9, 0xF4F3F5F6);
	r1 = D(r1, s1_2_2, 0xF2FF01FF, 0x0AFBE6FA, 0xFC02F806, 0xEDF6E9C3);
	r2 = D(r2, s1_2_2, 0xF4FDFAF9, 0xFAF30009, 0x20F6FCCF, 0xF10BF902);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x06F90002, 0x04F30F10, 0xFFF006FA, 0x04FD0506);
	r1 = D(r1, s0_0_0, 0xFCF1FEFD, 0xFFE800FE, 0xFE030004, 0x01FE0807);
	r2 = D(r2, s0_0_0, 0xE3261603, 0xFB070203, 0x03020E0D, 0xF5040C03);
	r0 = D(r0, s0_0_1, 0xF8FA2200, 0xF9000CE5, 0xF3F1E9EA, 0xFEFCF2F9);
	r1 = D(r1, s0_0_1, 0xF5FB2F0B, 0xFB050505, 0xFA0611FF, 0xF710F806);
	r2 = D(r2, s0_0_1, 0xD74910C2, 0x06E80112, 0x03160D10, 0xFCE50F06);
	r0 = D(r0, s0_0_2, 0xFCEC0CFB, 0x06E600FD, 0x04F7F6FD, 0x08EAF506);
	r1 = D(r1, s0_0_2, 0x05E0E1DC, 0xFC040108, 0xF1F3F5FE, 0x0C16E60B);
	r2 = D(r2, s0_0_2, 0x080602F8, 0xFFFA0EFA, 0xFD090907, 0xFCFC15F1);
	r0 = D(r0, s0_1_0, 0xEDFE2203, 0xE2DD1B27, 0xDB14180E, 0xF4FDFEF5);
	r1 = D(r1, s0_1_0, 0x18EAED0B, 0xF9ED0E02, 0xFDDEF90C, 0xFC0604FA);
	r2 = D(r2, s0_1_0, 0x16EB08F7, 0x0BEE1101, 0xEB03F6F6, 0x10FCF213);
	r0 = D(r0, s0_1_1, 0xFA41ECB5, 0x160EF2BB, 0xF0E522B6, 0xFD3617ED);
	r1 = D(r1, s0_1_1, 0xB5084EFA, 0x01DC002E, 0xE90415DD, 0x010413E3);
	r2 = D(r2, s0_1_1, 0xEAE623FE, 0xDF4A10CB, 0xFBAFCD03, 0xD6DB51D2);
	r0 = D(r0, s0_1_2, 0xFDF205F6, 0xEBDF1202, 0xE3C211F5, 0xE82514E4);
	r1 = D(r1, s0_1_2, 0x0EE2F403, 0x0906FBFE, 0x0610F1F9, 0xE30125D5);
	r2 = D(r2, s0_1_2, 0xE0F40CFB, 0x070705FC, 0x22F4F4F2, 0x07F8F3FE);
	r0 = D(r0, s0_2_0, 0xFB0717FB, 0xD7021B0E, 0xD5F40BFE, 0xFEFEFEF8);
	r1 = D(r1, s0_2_0, 0xFFF80803, 0x020A0411, 0x0800010A, 0xFFFB0BFC);
	r2 = D(r2, s0_2_0, 0x08FAF501, 0xF5010BF1, 0xEC133A11, 0x0FF30F0A);
	r0 = D(r0, s0_2_1, 0x11F0FCF7, 0x1A03EAF8, 0x140CEDF3, 0xFDF201F0);
	r1 = D(r1, s0_2_1, 0xFF0909FB, 0x0C0FFD18, 0xE9F50003, 0xEB030FF1);
	r2 = D(r2, s0_2_1, 0x080300FF, 0x1CF3FEFE, 0xD73C52DC, 0xE60307F8);
	r0 = D(r0, s0_2_2, 0xE9FD0804, 0xF0F70900, 0xF3F40C02, 0x09F5FCFC);
	r1 = D(r1, s0_2_2, 0xF6F70305, 0x0509FA07, 0xFDFDFFFF, 0x1104E300);
	r2 = D(r2, s0_2_2, 0x0EFFF602, 0xE6FB0A08, 0xD90812F9, 0x12FB0402);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.251e-02, -9.490e-03, 1.249e-02, -9.247e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-6.161e-03, 2.679e-02, -2.325e-02, -8.886e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-1.745e-02, -9.552e-03, -9.257e-03, 6.033e-04);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-2x12-DS-out-shuffle
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
	r0 += M4(9.440e-03, 1.458e-03, -6.458e-03, -2.700e-03, 5.549e-03, -7.639e-04, 2.096e-03, -8.989e-04, 2.640e-02, -1.410e-03, 1.869e-02, 1.409e-03, 1.023e-01, 2.487e-02, -1.416e-02, 3.629e-02) * s0_0_0;
	r0 += M4(1.509e-01, 8.438e-02, 1.143e-02, 7.978e-03, -5.750e-02, -4.674e-03, 3.891e-04, -1.231e-02, -1.345e-01, -1.840e-02, 2.323e-02, -1.079e-02, 1.333e-01, 1.919e-01, 1.433e-02, 2.509e-02) * s0_0_1;
	r0 += M4(2.302e-03, 5.351e-02, 8.480e-03, 6.431e-03, 2.905e-03, 2.131e-02, 3.915e-03, -1.758e-02, 3.072e-03, -3.438e-02, -3.509e-05, 1.477e-02, 8.195e-03, 2.424e-02, 5.391e-04, 1.488e-02) * s0_0_2;
	r0 += M4(7.642e-02, -1.506e-02, 4.578e-02, 6.141e-03, 4.553e-02, -7.810e-03, 3.074e-02, -1.146e-02, 2.712e-02, 4.883e-03, 4.200e-02, -2.749e-03, 8.652e-02, -5.921e-02, -1.753e-01, -3.594e-02) * s0_1_0;
	r0 += M4(-3.115e-01, 1.107e-01, 1.518e-01, 2.172e-01, -3.271e-01, 1.567e-01, -3.639e-01, 7.900e-02, 1.036e-01, 1.448e-01, -1.876e-01, 1.294e-01, -1.135e-01, 1.738e-01, -6.591e-02, -4.482e-01) * s0_1_1;
	r0 += M4(1.008e-02, -2.001e-01, -3.162e-02, -1.160e-01, 1.728e-02, 1.439e-01, 1.267e-02, 1.849e-01, -7.903e-03, -7.609e-02, -4.156e-03, -1.518e-01, 1.712e-02, -2.836e-02, -2.087e-02, 2.260e-02) * s0_1_2;
	r0 += M4(1.232e-02, 1.138e-02, 1.824e-02, -4.395e-04, -2.328e-03, -2.045e-03, 2.178e-02, 1.811e-03, -2.592e-03, -1.386e-03, 4.552e-03, 4.235e-04, -3.959e-03, -3.804e-04, -1.466e-02, -1.121e-02) * s0_2_0;
	r0 += M4(2.040e-02, -2.045e-02, -1.567e-01, -8.699e-02, 1.209e-02, -3.504e-02, -2.003e-02, 2.460e-02, 1.098e-03, -1.320e-03, 7.594e-02, 3.979e-02, 9.844e-03, -1.918e-02, 1.771e-02, 6.114e-02) * s0_2_1;
	r0 += M4(4.157e-04, 7.436e-03, 2.223e-04, -2.286e-02, -2.104e-03, 9.648e-03, 1.889e-03, 1.958e-02, -1.945e-03, -3.176e-03, 1.402e-02, 5.585e-03, -4.020e-03, -3.422e-03, -1.357e-02, -1.231e-02) * s0_2_2;
	r0 += M4(-9.219e-04, 1.067e-02, 6.003e-03, 4.274e-03, 1.317e-02, 1.407e-02, 1.695e-02, 5.354e-04, 7.108e-03, 1.250e-03, 3.536e-03, 1.130e-03, -2.529e-01, -5.931e-02, 2.179e-02, -6.267e-03) * s1_0_0;
	r0 += M4(-1.188e-02, 3.071e-02, 5.405e-03, -9.395e-03, -7.347e-03, -1.450e-02, 3.142e-02, 3.383e-02, 6.958e-02, 6.564e-02, -2.168e-03, -6.023e-03, -3.457e-02, -2.212e-01, -3.443e-02, 2.412e-02) * s1_0_1;
	r0 += M4(3.835e-03, -1.222e-03, -6.219e-04, -1.726e-03, 1.053e-02, 1.544e-02, -6.418e-03, 1.120e-02, -4.585e-03, 1.540e-02, -3.284e-03, -2.096e-03, -1.085e-02, -2.486e-02, 1.199e-03, -2.206e-02) * s1_0_2;
	r0 += M4(1.880e-01, -2.005e-02, 9.356e-02, -6.820e-03, -1.041e-02, 2.891e-02, -1.238e-02, 2.985e-02, -8.709e-02, 2.214e-02, -8.611e-02, 9.603e-03, -7.273e-04, 1.492e-02, 2.154e-01, 8.375e-02) * s1_1_0;
	r0 += M4(9.604e-02, -3.090e-01, -3.613e-03, -7.105e-02, -1.194e-01, -1.199e-01, -1.168e-01, -1.322e-01, 4.389e-02, -2.666e-01, 1.958e-01, 6.058e-03, 1.357e-02, -5.326e-03, 6.519e-02, 1.595e-01) * s1_1_1;
	r0 += M4(-3.195e-03, -7.204e-03, 7.797e-04, -5.749e-03, 4.041e-02, 3.136e-03, 4.230e-02, 5.178e-03, 1.800e-02, 1.284e-01, 1.478e-02, 9.075e-02, -6.532e-04, 7.743e-03, 7.242e-03, 1.729e-02) * s1_1_2;
	r0 += M4(4.188e-02, 1.297e-02, 1.209e-01, 4.563e-03, 2.177e-02, 3.521e-03, 1.837e-02, 1.764e-02, 8.617e-03, 1.867e-03, -2.678e-03, 1.357e-02, 1.339e-03, 7.034e-04, -4.800e-04, -3.468e-03) * s1_2_0;
	r0 += M4(-4.626e-02, -1.761e-03, 3.884e-02, -1.890e-01, 3.670e-02, 4.163e-02, -3.976e-03, -6.805e-04, -2.983e-02, 2.953e-02, -1.042e-01, -1.275e-01, 4.059e-04, 6.681e-04, 1.813e-03, -2.442e-03) * s1_2_1;
	r0 += M4(1.841e-04, 5.195e-03, -2.239e-04, 3.067e-03, -7.669e-03, 7.809e-03, 6.520e-03, 1.144e-02, 5.097e-03, -9.792e-03, 4.629e-03, 3.235e-02, -4.693e-04, 6.857e-04, 1.249e-03, 7.149e-03) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 += M4(-4.696e-03, -2.235e-03, -2.791e-03, -2.194e-03, -1.833e-02, -1.581e-02, 5.379e-04, -1.388e-02, 5.286e-02, -1.501e-02, -6.261e-02, -7.594e-03, -2.580e-02, 4.535e-03, -8.267e-03, 8.031e-03) * s0_0_0;
	r0 += M4(6.454e-03, 2.442e-03, -8.540e-05, 8.841e-04, 2.841e-02, 6.067e-02, 3.903e-02, -1.573e-02, 2.436e-01, 2.725e-01, -3.018e-01, -3.434e-01, 1.569e-02, -1.343e-01, -2.169e-02, 2.065e-02) * s0_0_1;
	r0 += M4(-5.644e-03, -2.650e-03, -2.462e-03, -4.319e-03, -4.638e-02, -6.754e-02, 2.064e-02, -2.172e-02, 9.204e-03, 6.314e-02, 1.391e-02, -1.852e-02, -6.803e-03, 2.286e-02, -8.599e-03, 5.785e-04) * s0_0_2;
	r0 += M4(2.435e-02, 1.320e-03, -3.189e-03, 1.138e-03, -5.201e-02, 2.589e-02, 4.576e-02, -1.926e-02, 1.763e-03, 4.594e-03, 2.996e-02, 1.729e-02, -1.821e-01, -3.079e-03, -1.220e-01, 4.117e-03) * s0_1_0;
	r0 += M4(-9.798e-03, 5.708e-03, -3.612e-03, -1.162e-02, 2.359e-01, -2.764e-01, -4.033e-01, 4.334e-02, -3.732e-03, -3.111e-03, 3.083e-02, 3.689e-02, 1.859e-01, 9.787e-02, 1.922e-01, -2.378e-01) * s0_1_1;
	r0 += M4(1.447e-02, 3.129e-02, 3.177e-04, 5.861e-03, -9.554e-03, 1.665e-01, 2.331e-02, 1.331e-02, 1.948e-03, -7.511e-04, 1.151e-02, 3.967e-02, -2.507e-03, 3.308e-02, -2.168e-04, 5.515e-02) * s0_1_2;
	r0 += M4(-4.432e-02, 7.455e-03, 9.602e-03, -1.349e-02, -1.484e-02, 1.011e-02, 1.215e-02, -8.993e-03, -1.493e-03, -1.009e-03, -5.513e-04, -9.491e-04, -1.443e-03, -5.219e-03, -5.041e-02, -1.353e-02) * s0_2_0;
	r0 += M4(-2.705e-01, -3.268e-01, 2.529e-01, 2.607e-01, -1.693e-02, 3.220e-02, 1.566e-01, 4.674e-02, 1.344e-03, 7.439e-04, 8.556e-04, 1.329e-03, 1.046e-02, 8.395e-03, 4.775e-02, 1.428e-01) * s0_2_1;
	r0 += M4(2.118e-02, -1.406e-02, -5.702e-04, 4.942e-02, -9.092e-04, -8.394e-04, -3.924e-04, 2.301e-03, -4.209e-04, -9.198e-04, -7.673e-04, -1.429e-03, -1.101e-03, -1.320e-03, -7.397e-04, 1.053e-02) * s0_2_2;
	r0 += V4(-4.856e-12, -1.403e-10, 5.258e-11, -1.187e-10);
	r0 = r0;
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
