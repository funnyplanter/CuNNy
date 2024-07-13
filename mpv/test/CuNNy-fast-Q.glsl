// CuNNy fast (dp4a)
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


//!DESC CuNNy-fast-in
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
	r0 += V4(4.400e-01, 5.188e-02, -3.694e-04, 8.471e-01) * s0_0_0;
	r1 += V4(-2.460e-02, -1.432e-02, -2.055e-01, -8.312e-01) * s0_0_0;
	r2 += V4(3.623e-02, -1.152e-04, -1.332e-02, -6.002e-03) * s0_0_0;
	r0 += V4(-1.856e-01, 9.994e-01, -9.644e-02, 9.447e-02) * s0_0_1;
	r1 += V4(1.194e-01, 6.074e-01, 2.892e-02, 6.082e-01) * s0_0_1;
	r2 += V4(-3.388e-02, 4.591e-03, -5.469e-02, 2.129e-01) * s0_0_1;
	r0 += V4(-7.627e-02, -1.060e+00, -1.160e-01, 7.661e-03) * s0_0_2;
	r1 += V4(4.742e-03, -3.511e-02, -1.636e-01, 4.652e-02) * s0_0_2;
	r2 += V4(-1.230e-02, 6.205e-02, 5.269e-02, 3.546e-01) * s0_0_2;
	r0 += V4(4.021e-01, -3.695e-02, -7.883e-02, -7.715e-01) * s0_1_0;
	r1 += V4(-1.870e-01, -8.632e-01, -7.941e-02, 4.920e-01) * s0_1_0;
	r2 += V4(-6.247e-01, -9.203e-01, 3.176e-02, -2.089e-02) * s0_1_0;
	r0 += V4(-5.371e-01, -1.093e-01, 7.549e-01, -1.224e-01) * s0_1_1;
	r1 += V4(-2.507e-01, 2.781e-01, 6.505e-01, -1.353e-01) * s0_1_1;
	r2 += V4(-8.863e-04, 5.319e-02, -9.929e-01, 1.556e-01) * s0_1_1;
	r0 += V4(4.005e-02, 1.671e-01, -1.626e-01, -4.586e-03) * s0_1_2;
	r1 += V4(6.457e-02, 2.875e-02, -1.248e-01, -1.714e-01) * s0_1_2;
	r2 += V4(7.389e-02, 1.653e-03, -5.664e-02, -1.148e+00) * s0_1_2;
	r0 += V4(-1.179e-01, -1.247e-02, -1.687e-02, -5.045e-02) * s0_2_0;
	r1 += V4(-1.937e-01, 4.455e-04, -3.934e-01, -3.707e-03) * s0_2_0;
	r2 += V4(-9.097e-02, 3.555e-01, -1.567e-02, 3.812e-02) * s0_2_0;
	r0 += V4(-6.047e-03, -8.727e-02, -9.159e-02, 1.230e-02) * s0_2_1;
	r1 += V4(6.714e-01, -1.845e-02, 3.590e-01, -1.105e-01) * s0_2_1;
	r2 += V4(7.114e-01, 1.358e-01, 1.051e+00, 5.805e-02) * s0_2_1;
	r0 += V4(4.169e-02, 9.009e-02, 3.446e-02, -7.705e-03) * s0_2_2;
	r1 += V4(-1.598e-02, 1.424e-02, -7.103e-02, 1.030e-01) * s0_2_2;
	r2 += V4(-5.553e-02, 1.173e-03, -5.087e-03, 4.060e-02) * s0_2_2;
	r0 += V4(6.330e-03, -4.702e-05, 1.173e-02, -1.562e-03);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(1.575e-02, 8.153e-04, 6.111e-04, 1.944e-03);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(-7.945e-04, -6.449e-03, -3.711e-04, -7.724e-03);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-fast-conv1
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
	r0 = D(r0, s0_0_0, 0xE53DDF18, 0x010FF306, 0x244807C3, 0xF531EE04);
	r1 = D(r1, s0_0_0, 0x07FEF30A, 0xFC1501FD, 0x0281FE0C, 0x0DD6E31B);
	r2 = D(r2, s0_0_0, 0xFF06F500, 0x04F7DD15, 0x071D08F0, 0x0200F705);
	r0 = D(r0, s0_0_1, 0xACFEF92D, 0x0221FF17, 0xEA071400, 0xFC19FD2C);
	r1 = D(r1, s0_0_1, 0x01DB0C30, 0xFE0A0708, 0x142DEEE9, 0x0D37F563);
	r2 = D(r2, s0_0_1, 0x02F8F30E, 0xE25DE67F, 0x06D5FED3, 0xFF03FF11);
	r0 = D(r0, s0_0_2, 0xA311FF16, 0xF6F7FF08, 0x13C2131F, 0xECF8FF0F);
	r1 = D(r1, s0_0_2, 0x0CCB02C1, 0xFCF8FFF5, 0xE808FD35, 0x05E9011B);
	r2 = D(r2, s0_0_2, 0x0B20FB1A, 0xA4220138, 0x08220501, 0xF7030004);
	r0 = D(r0, s0_1_0, 0x05CF81ED, 0x09F0EF0B, 0x37FBFCF2, 0x09DFD310);
	r1 = D(r1, s0_1_0, 0x05B9DBF8, 0x0A7FF6EF, 0xE6794104, 0x09FBB809);
	r2 = D(r2, s0_1_0, 0x050807FE, 0xFAA2C9FA, 0x08030E09, 0xFF0AE9F5);
	r0 = D(r0, s0_1_1, 0x2CFCE805, 0x04D2FEEF, 0x81D0FC9E, 0xF4E4F600);
	r1 = D(r1, s0_1_1, 0xF7E2210E, 0xE2811026, 0xAD99BC35, 0x2CBCEB33);
	r2 = D(r2, s0_1_1, 0x0422F6EC, 0x2A1981E2, 0xF52F11D7, 0x1F27F801);
	r0 = D(r0, s0_1_2, 0xF6FBFD20, 0x303900F7, 0x45D917DE, 0x2E3601F1);
	r1 = D(r1, s0_1_2, 0x2B58FEE7, 0xF3DE0412, 0x4433FAF5, 0x1D2C03F4);
	r2 = D(r2, s0_1_2, 0xF2F1FB0F, 0x81CE06FA, 0xACBB0117, 0x01FD0405);
	r0 = D(r0, s0_2_0, 0xFE020EF2, 0x05F31F00, 0xF3C181FB, 0x06FE3901);
	r1 = D(r1, s0_2_0, 0xF8137F0B, 0x0C0301F5, 0xE9A817E5, 0x0DE9DEF4);
	r2 = D(r2, s0_2_0, 0x06041AFE, 0xF83E1F02, 0x02F3DC0A, 0x04FDF8FD);
	r0 = D(r0, s0_2_1, 0x1A1003D2, 0x05E13705, 0x2AF1E875, 0x04D933FF);
	r1 = D(r1, s0_2_1, 0xE7FDE1A1, 0x18FFFC18, 0xC0E2E709, 0x3A161329);
	r2 = D(r2, s0_2_1, 0x05D028EE, 0x32C90FCB, 0x121CE804, 0x24D61505);
	r0 = D(r0, s0_2_2, 0xE80804E6, 0xEB06F2ED, 0xA1F90A27, 0xE410F0E7);
	r1 = D(r1, s0_2_2, 0x4C77CD81, 0xF21809F9, 0x537FF1DB, 0xEB0C01F6);
	r2 = D(r2, s0_2_2, 0x24F5FB15, 0x09030DCE, 0xFAFA1C2C, 0x2AFBF50A);
	r0 = D(r0, s1_0_0, 0x07FFF32D, 0xF70B0010, 0xE6650B7F, 0xEB0910F8);
	r1 = D(r1, s1_0_0, 0x040BFEDA, 0xF90CFF1E, 0x1321EF00, 0x000EE042);
	r2 = D(r2, s1_0_0, 0xFF0403FD, 0x11E1F816, 0x01F70014, 0xFD02FF03);
	r0 = D(r0, s1_0_1, 0xE9FB05DF, 0xFEF0F7EF, 0x1DE0AC19, 0xF0F5050F);
	r1 = D(r1, s1_0_1, 0x04EC00DB, 0xFDF105E6, 0x1201EBC3, 0x22ECC6E2);
	r2 = D(r2, s1_0_1, 0xFAEE082F, 0x0057FD7F, 0xF50004D2, 0x000EFF08);
	r0 = D(r0, s1_0_2, 0xF2E51F16, 0xFBF7FA1A, 0x16D6EEF0, 0xF4F20815);
	r1 = D(r1, s1_0_2, 0x1A15EDE0, 0xF3FC0FF8, 0xF9FB1222, 0x11FDDFF6);
	r2 = D(r2, s1_0_2, 0x0002EDFC, 0xDDBD1027, 0x09E700EB, 0xFFF40209);
	r0 = D(r0, s1_1_0, 0xFDD8E403, 0x0408F30F, 0xCC7F8128, 0xF61FFD11);
	r1 = D(r1, s1_1_0, 0x0FFFF9F8, 0xF94EEAFC, 0x0A152F0E, 0xF905C511);
	r2 = D(r2, s1_1_0, 0x070AFEFF, 0x24CA21BB, 0xEA21FF15, 0x06F5FAF5);
	r0 = D(r0, s1_1_1, 0x5DE8C9FC, 0x13EDF80E, 0x370181D1, 0xFEE31DEA);
	r1 = D(r1, s1_1_1, 0x248112EE, 0x07E302F3, 0xD6BCC2E4, 0x57F6A417);
	r2 = D(r2, s1_1_1, 0xEF0FF9FC, 0x03408E9E, 0xF61A21C1, 0x11E5FDD7);
	r0 = D(r0, s1_1_2, 0xFD0605C6, 0x211206E4, 0x64E20A26, 0x1311F2D6);
	r1 = D(r1, s1_1_2, 0x38DCF325, 0xF7EC05EB, 0xFED8E206, 0x2AEECDEA);
	r2 = D(r2, s1_1_2, 0x0AF2E4EC, 0xF0028108, 0xCFE83A17, 0xFC05FE0A);
	r0 = D(r0, s1_2_0, 0x23FC11F7, 0x0FFDF6F5, 0x0A0AE00B, 0x0FFAEBF0);
	r1 = D(r1, s1_2_0, 0x40050C17, 0x07FCC41C, 0x0738F6F9, 0xFCDDDA05);
	r2 = D(r2, s1_2_0, 0x0901FBFC, 0x272924EE, 0xDEF6E412, 0x04080404);
	r0 = D(r0, s1_2_1, 0x60090E02, 0x49F20CFA, 0x160CE922, 0x78F32EFF);
	r1 = D(r1, s1_2_1, 0x010562F7, 0xFB0A07F9, 0x202905F5, 0x15E6DEF3);
	r2 = D(r2, s1_2_1, 0x12F1FDFF, 0x180C08EC, 0x0B0FE11D, 0x1B082609);
	r0 = D(r0, s1_2_2, 0xFCFE04F3, 0x11F809F7, 0x5B1138F0, 0xFBF414F4);
	r1 = D(r1, s1_2_2, 0xC61A8137, 0x1D010FFD, 0x0C00F330, 0x04F1D9F6);
	r2 = D(r2, s1_2_2, 0xFC000FEF, 0x3EF70308, 0x0C10100A, 0xFB05EF05);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x7FA313F2, 0xFF0506F9, 0xED8125C2, 0xFF140BEA);
	r1 = D(r1, s0_0_0, 0xFD09FB0C, 0xFC0008D3, 0x0A24F9D1, 0x14AC0944);
	r2 = D(r2, s0_0_0, 0xEB17FEF6, 0xEBFB17C5, 0xF3F616F8, 0x0500F802);
	r0 = D(r0, s0_0_1, 0x23E381D0, 0x0A11011E, 0x151F8189, 0x07EFF0FD);
	r1 = D(r1, s0_0_1, 0x15290DE4, 0x0618D51A, 0xF1D93E32, 0x14D9FE57);
	r2 = D(r2, s0_0_1, 0xFE3A0B0F, 0x5E81EBA6, 0xF13EE523, 0xFAF71503);
	r0 = D(r0, s0_0_2, 0x0107F513, 0xFDF50B0B, 0x0120C8F9, 0xFDE82DE9);
	r1 = D(r1, s0_0_2, 0x09122111, 0x0408E4EE, 0x0804EBFC, 0xFCE8EA5F);
	r2 = D(r2, s0_0_2, 0xFD0823E7, 0x0E14F681, 0xF7400A2A, 0x060F00F2);
	r0 = D(r0, s0_1_0, 0xEDD2FE12, 0xE9FBFD00, 0xBB8128B2, 0xE1F503FF);
	r1 = D(r1, s0_1_0, 0xD11EE1EE, 0x17C6FDF9, 0x3D0FCFF9, 0x15C4F03F);
	r2 = D(r2, s0_1_0, 0xF713FB00, 0x9B000A00, 0x81E527FC, 0xE4EFF60B);
	r0 = D(r0, s0_1_1, 0xFF10FA05, 0xDE5C0424, 0x10407F9B, 0xF07FF44F);
	r1 = D(r1, s0_1_1, 0xEEEF0E7F, 0x10F5271C, 0xDFE981C7, 0x0A080931);
	r2 = D(r2, s0_1_1, 0xF31CFA18, 0xE306BC68, 0xFFE8F0EA, 0xFC06F724);
	r0 = D(r0, s0_1_2, 0x0310DC2E, 0x04098E41, 0xF9FF0AE6, 0x0207813F);
	r1 = D(r1, s0_1_2, 0x1CA5DB9F, 0x02F6FF09, 0xFCE52DD3, 0xFFE6DD4B);
	r2 = D(r2, s0_1_2, 0x0E1CD216, 0x1A164703, 0x030B9ED1, 0x06FFCDF3);
	r0 = D(r0, s0_2_0, 0x0F030114, 0xF1FEFF04, 0x290024EA, 0xFF00FD09);
	r1 = D(r1, s0_2_0, 0x2B030FF4, 0xF7F7FEFB, 0x3704D7F5, 0xEDF3E620);
	r2 = D(r2, s0_2_0, 0xF700FC01, 0x420B1313, 0x3AF409F9, 0x2C01FD00);
	r0 = D(r0, s0_2_1, 0x1102F2F8, 0x0BF90AFD, 0x070616FD, 0x090702EF);
	r1 = D(r1, s0_2_1, 0x0B9304E7, 0x0C0BF70F, 0xDE0DCEFD, 0x1AEAE72E);
	r2 = D(r2, s0_2_1, 0x040CF901, 0x1322D4F7, 0x14051508, 0x0706FC02);
	r0 = D(r0, s0_2_2, 0x0107EE0B, 0x00FE140B, 0x12FFB407, 0xFF01F70D);
	r1 = D(r1, s0_2_2, 0xE08A76E7, 0xFBFCDE15, 0xEFF607EC, 0x03F12D1E);
	r2 = D(r2, s0_2_2, 0x0C07DE0A, 0xFD0EC4E5, 0xFAEED505, 0x06FFF7F9);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-7.898e-03, 1.388e-02, -2.472e-02, 8.014e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.326e-02, -1.068e-03, -1.059e-02, -2.161e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(2.790e-04, -2.475e-02, -4.902e-03, -1.218e-03);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-fast-conv2
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
	r0 = D(r0, s0_0_0, 0xEE0421F6, 0x07FC00FA, 0x0AFEF5F9, 0x09FDF70F);
	r1 = D(r1, s0_0_0, 0x13FAEE02, 0xFEFD01F6, 0x0CFEF201, 0x03FFF603);
	r0 = D(r0, s0_0_1, 0x0D0F20F6, 0x04FEF113, 0xFB0706DD, 0x040201FD);
	r1 = D(r1, s0_0_1, 0xFC0E0108, 0x05F7FF1A, 0x030403E0, 0xFD030A0C);
	r0 = D(r0, s0_0_2, 0xE7FF0A08, 0xF9EFFF0C, 0xFE0205F0, 0xF00713EE);
	r1 = D(r1, s0_0_2, 0xF4ECF825, 0xF9FD090A, 0xF80406E6, 0xF1FE0CFE);
	r0 = D(r0, s0_1_0, 0xEA100AFA, 0x00090625, 0xFC04161F, 0x0EFEF906);
	r1 = D(r1, s0_1_0, 0x1704E826, 0xFF070523, 0x18FFEB1F, 0xFD08FF10);
	r0 = D(r0, s0_1_1, 0x2DD24289, 0xDCA14E8E, 0x0FC2F420, 0xD8185003);
	r1 = D(r1, s0_1_1, 0xB9E96CB8, 0xF9FE3ADC, 0xEB05262E, 0xEFE744DF);
	r0 = D(r0, s0_1_2, 0x93DD1DF6, 0xD8EE21CB, 0xF4DF0011, 0x12C6E4B3);
	r1 = D(r1, s0_1_2, 0xD3E23292, 0xF7EE10D5, 0xFED4F222, 0x06FBFCF3);
	r0 = D(r0, s0_2_0, 0xF7121121, 0x0EFFF6D0, 0x1207EDF0, 0x1EF2DBF3);
	r1 = D(r1, s0_2_0, 0x0BFEF6F3, 0x03FEFFFF, 0x1300EB09, 0xFA0404FD);
	r0 = D(r0, s0_2_1, 0x04CC19C9, 0x16ECD110, 0xD2AA31B7, 0xE30941DA);
	r1 = D(r1, s0_2_1, 0x25FFC7F2, 0xF3F00E92, 0xDEEB1FA9, 0xECE42101);
	r0 = D(r0, s0_2_2, 0xFDE8E807, 0x0EE9F7FE, 0xEDE411D3, 0x2381D1D1);
	r1 = D(r1, s0_2_2, 0x0EE6F10A, 0xF3F1FAF5, 0xD2E32ACB, 0xFBFB00F9);
	r0 = D(r0, s1_0_0, 0xF0FD0302, 0xF9FC02ED, 0x0400FCF2, 0x06FFFA00);
	r1 = D(r1, s1_0_0, 0x03FF04EC, 0xFAFFFC03, 0x0AFF00F4, 0xFD0200FB);
	r0 = D(r0, s1_0_1, 0x0D0D08E6, 0x11080CE6, 0xFBFEFDF4, 0xFEFEFDEB);
	r1 = D(r1, s1_0_1, 0xF3F417DC, 0x06FFFEFD, 0xF9FF01F1, 0xFCFB0DFC);
	r0 = D(r0, s1_0_2, 0xE6041303, 0xFEE4FC07, 0xFFFDF606, 0xF50E06F4);
	r1 = D(r1, s1_0_2, 0x15F702FB, 0x02FFFA05, 0xFE00F800, 0xFBFE04FF);
	r0 = D(r0, s1_1_0, 0xFEFB0001, 0x0400FCF0, 0xF2FF00DD, 0x08FEFEFC);
	r1 = D(r1, s1_1_0, 0x03FDFBEF, 0x03FF02FE, 0xFEFFFDE4, 0xFEFDFFFB);
	r0 = D(r0, s1_1_1, 0xE510E5CC, 0xDD21510E, 0x12294AEC, 0xE3FC19CA);
	r1 = D(r1, s1_1_1, 0xF60058FC, 0xF80102F2, 0xF4FD4DC9, 0xFE03F7F6);
	r0 = D(r0, s1_1_2, 0xE2DA340B, 0xF3D70304, 0x05C80605, 0x102F001C);
	r1 = D(r1, s1_1_2, 0xD30C0E12, 0xF0FE1009, 0x1BFC1708, 0xFCF61C03);
	r0 = D(r0, s1_2_0, 0x100901FA, 0xFF04F800, 0x0901FD02, 0xFC01FCFD);
	r1 = D(r1, s1_2_0, 0xF904FCFF, 0xFE020208, 0xFD0100FF, 0x03010104);
	r0 = D(r0, s1_2_1, 0xD0091102, 0x07F7FEF8, 0xD7F71E0A, 0x11000ED8);
	r1 = D(r1, s1_2_1, 0x09FAFBFA, 0xFCFC0510, 0xFEF31910, 0xECFC0E08);
	r0 = D(r0, s1_2_2, 0x230F09ED, 0x0502F802, 0xF804F6FF, 0xDB37F6FE);
	r1 = D(r1, s1_2_2, 0x0400FBFD, 0x0105F4FB, 0xD307FE01, 0xFDFFFBFD);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0AEAFFEA, 0x0503FEF7, 0xFEFE0405, 0xF9020000);
	r1 = D(r1, s0_0_0, 0xFCFFFC07, 0x0609FCFD, 0xF9FA040A, 0x0603FAFD);
	r0 = D(r0, s0_0_1, 0xDEE7FB0D, 0x29020106, 0xFDEF1214, 0xF1E00313);
	r1 = D(r1, s0_0_1, 0x4507F7FC, 0xF7FCFDF9, 0xFFF20F1A, 0x31F6F903);
	r0 = D(r0, s0_0_2, 0xF0FC0E0D, 0x060403FA, 0xF603FD03, 0xFD030006);
	r1 = D(r1, s0_0_2, 0x14010BF6, 0xFB010302, 0xF4000602, 0x18F80A04);
	r0 = D(r0, s0_1_0, 0x27EBF2E2, 0x01F1E4FA, 0x0BEDEBE5, 0xF514FDF4);
	r1 = D(r1, s0_1_0, 0xFF01ECF8, 0xFBFFF8FF, 0xFCFFEFFC, 0x12FE00FC);
	r0 = D(r0, s0_1_1, 0xD620D0BD, 0xE8E5CA1A, 0x44F5C9E4, 0x0099FDE2);
	r1 = D(r1, s0_1_1, 0xF8CBC52D, 0xF8ECE1F0, 0x58D9C2D5, 0xF21604C9);
	r0 = D(r0, s0_1_2, 0x10D02E10, 0x0CF6F504, 0x03FB0506, 0xE4F81225);
	r1 = D(r1, s0_1_2, 0xF6F7DA03, 0xE104F20A, 0x12FDF0F9, 0x1FF5FA02);
	r0 = D(r0, s0_2_0, 0x0EECF2FD, 0xF910FD02, 0xFB15F503, 0xEF04FEF7);
	r1 = D(r1, s0_2_0, 0xFF0E0003, 0x0522F7F1, 0x0019FAFA, 0x010BFD01);
	r0 = D(r0, s0_2_1, 0xF114ECE3, 0x080BF106, 0xF30BF425, 0x3CD3F5D5);
	r1 = D(r1, s0_2_1, 0x0117E808, 0xF924EC3B, 0xED1AEB3F, 0xF909FF0B);
	r0 = D(r0, s0_2_2, 0x0A031100, 0xF90D01FE, 0x0203FAFE, 0x07F3CB01);
	r1 = D(r1, s0_2_2, 0xF60FFF01, 0xEE05F4FF, 0xF403F302, 0x0600FEFE);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-2.802e-02, -9.613e-03, -1.084e-02, -1.748e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.085e-02, -1.066e-02, -1.091e-02, -9.397e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-fast-out-shuffle
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
	r0 += M4(1.398e-02, 6.251e-04, -4.982e-03, 1.053e-03, 1.622e-02, 7.067e-03, 1.056e-02, 9.634e-04, 1.338e-02, -1.718e-04, 1.120e-02, -6.331e-03, 1.399e-01, -8.767e-03, 4.747e-02, 6.013e-03) * s0_0_0;
	r0 += M4(-6.069e-02, 7.783e-02, 2.326e-02, -2.229e-02, -9.733e-03, -6.163e-02, -2.704e-02, -5.484e-06, 2.814e-02, -2.183e-02, 8.194e-03, -2.018e-02, 8.307e-02, -3.330e-01, 6.067e-02, -3.813e-02) * s0_0_1;
	r0 += M4(1.296e-02, -3.161e-02, -2.633e-03, -1.158e-02, 3.866e-03, 2.143e-02, -5.222e-04, 3.822e-04, -4.913e-03, 2.701e-02, 1.943e-03, -5.924e-03, -5.417e-03, 5.375e-02, -2.392e-03, 2.507e-02) * s0_0_2;
	r0 += M4(2.347e-02, -3.687e-02, 3.480e-02, -1.884e-02, 9.351e-02, -5.608e-03, 1.469e-02, 1.389e-02, -1.972e-02, -2.434e-02, 4.436e-02, -1.692e-02, 2.606e-02, -1.965e-02, 1.398e-01, -2.106e-02) * s0_1_0;
	r0 += M4(-2.476e-01, 3.249e-01, -2.611e-01, 3.721e-01, -6.844e-01, 2.485e-01, 1.538e-01, 4.084e-02, 2.146e-01, 6.165e-02, -5.801e-01, 2.310e-01, 2.521e-02, 1.646e-04, 5.289e-02, -2.651e-01) * s0_1_1;
	r0 += M4(1.941e-02, -4.596e-02, 3.277e-02, -3.323e-02, 1.443e-02, -8.321e-03, 1.294e-02, 7.635e-02, -2.147e-04, 8.960e-02, 1.882e-02, 3.538e-02, -4.034e-03, 1.022e-02, -9.765e-03, 3.796e-02) * s0_1_2;
	r0 += M4(-7.935e-04, 3.328e-04, 4.199e-03, -1.085e-02, 1.260e-02, -2.307e-03, 2.803e-02, -2.410e-03, -1.972e-03, 2.160e-04, -9.571e-03, -7.080e-03, -4.773e-03, 1.442e-03, -3.674e-02, -5.463e-03) * s0_2_0;
	r0 += M4(7.049e-03, -2.189e-02, -6.366e-02, 2.557e-02, 1.826e-02, -2.902e-02, 9.731e-03, -2.447e-02, -3.115e-02, 2.460e-04, -8.383e-03, -3.918e-02, 4.608e-04, -1.380e-02, -4.145e-03, -1.168e-02) * s0_2_1;
	r0 += M4(2.439e-03, 7.121e-03, 1.399e-03, -3.381e-02, 9.602e-04, 2.229e-04, -9.947e-03, 7.065e-03, -1.396e-03, -6.599e-03, -9.623e-03, 7.160e-05, -1.476e-03, 5.584e-04, -1.211e-02, -1.128e-02) * s0_2_2;
	r0 += M4(-3.188e-02, -6.010e-03, -2.337e-02, -4.898e-03, 3.553e-03, -1.604e-02, -1.643e-02, 4.589e-04, -3.787e-02, -1.606e-02, -2.640e-02, 5.965e-03, 3.942e-02, 1.569e-02, 2.514e-02, 2.266e-03) * s1_0_0;
	r0 += M4(-8.291e-03, 2.704e-02, -1.293e-02, -1.691e-02, 1.754e-01, 1.626e-01, 2.717e-02, -6.314e-03, 2.592e-02, 7.527e-02, -7.970e-04, 2.513e-02, -1.254e-02, -2.422e-02, 3.082e-02, 1.947e-02) * s1_0_1;
	r0 += M4(-3.109e-03, 1.304e-02, -1.773e-03, -7.587e-03, 7.452e-04, 7.550e-03, 3.776e-03, 8.902e-03, -1.410e-04, 3.669e-03, -6.366e-04, -4.481e-03, 2.771e-03, -1.227e-02, -5.780e-03, 7.890e-03) * s1_0_2;
	r0 += M4(-1.094e-01, 1.893e-02, -6.666e-03, -1.528e-02, -1.775e-02, -1.674e-02, 3.551e-02, -1.933e-02, 2.252e-02, 3.381e-02, -9.400e-02, 2.523e-02, 1.145e-01, 4.553e-02, 7.642e-02, 3.297e-02) * s1_1_0;
	r0 += M4(1.782e-01, -5.801e-01, 1.503e-01, 1.638e-01, -1.614e-01, -1.659e-01, 1.229e-01, 2.192e-01, 1.722e-01, 2.033e-01, 9.620e-02, -6.521e-01, -1.630e-01, -1.204e-02, -3.239e-01, -2.358e-01) * s1_1_1;
	r0 += M4(3.675e-04, 7.349e-02, 1.119e-02, 7.007e-02, 1.479e-03, -4.504e-02, -2.512e-02, -4.285e-02, -2.267e-03, 5.432e-02, -2.081e-03, 6.928e-02, 2.169e-03, -5.717e-02, -3.732e-03, -8.665e-02) * s1_1_2;
	r0 += M4(-1.224e-02, 7.140e-03, -2.102e-02, 6.559e-03, 1.169e-02, 2.610e-03, -2.848e-02, -6.812e-03, -1.363e-02, -5.857e-03, 2.103e-03, 8.879e-03, 5.758e-03, -1.373e-05, 6.860e-02, 1.084e-02) * s1_2_0;
	r0 += M4(-2.102e-03, 2.624e-02, 6.199e-02, 7.690e-02, 6.376e-03, 1.004e-02, -9.060e-02, -9.640e-02, -8.903e-03, -1.715e-02, 3.811e-02, 6.615e-02, 3.307e-02, 7.215e-03, 1.541e-01, 1.509e-01) * s1_2_1;
	r0 += M4(-3.339e-04, -2.653e-03, -3.561e-03, 1.264e-02, -5.781e-03, 1.611e-03, -1.776e-02, -3.626e-02, -1.628e-06, -4.997e-03, -2.854e-03, 1.191e-02, 3.644e-03, 1.051e-02, 3.552e-02, 4.598e-02) * s1_2_2;
	r0 += V4(-1.486e-08, 1.087e-09, -8.524e-09, -1.347e-09);
	r0 = r0;
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
