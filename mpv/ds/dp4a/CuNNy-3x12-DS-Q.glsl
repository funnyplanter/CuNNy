// CuNNy 3x12 DS (dp4a)
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


//!DESC CuNNy-3x12-DS-in
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
	r0 += V4(1.678e-01, 1.604e-02, -1.335e-01, -1.412e-01) * s0_0_0;
	r1 += V4(3.048e-03, 2.490e-01, 7.037e-01, 1.393e-01) * s0_0_0;
	r2 += V4(-2.513e-02, 5.565e-02, -4.521e-01, -1.128e-01) * s0_0_0;
	r0 += V4(-2.459e-01, -1.631e-01, -7.604e-01, 1.907e-01) * s0_0_1;
	r1 += V4(9.485e-01, 1.525e-01, 6.440e-02, 4.822e-01) * s0_0_1;
	r2 += V4(2.451e-03, 9.345e-01, -2.703e-01, 1.168e-01) * s0_0_1;
	r0 += V4(4.524e-02, 1.343e-02, 5.090e-02, -3.698e-02) * s0_0_2;
	r1 += V4(1.596e-03, 2.291e-02, -1.665e-02, 2.847e-01) * s0_0_2;
	r2 += V4(-1.470e-02, 6.811e-02, 6.616e-03, -3.255e-02) * s0_0_2;
	r0 += V4(7.864e-01, 3.347e-01, 9.085e-01, 4.008e-02) * s0_1_0;
	r1 += V4(-2.224e-02, -8.055e-02, 1.450e-01, -1.462e-02) * s0_1_0;
	r2 += V4(1.284e-01, -3.005e-01, -2.764e-01, -8.187e-01) * s0_1_0;
	r0 += V4(-6.699e-01, -2.131e-01, -2.456e-02, -3.329e-01) * s0_1_1;
	r1 += V4(-9.199e-01, -9.877e-01, -8.485e-01, -9.486e-01) * s0_1_1;
	r2 += V4(3.352e-01, -5.996e-01, 9.794e-01, 8.613e-01) * s0_1_1;
	r0 += V4(-8.619e-02, -6.088e-03, -4.200e-02, 8.447e-02) * s0_1_2;
	r1 += V4(-1.112e-02, 1.299e-01, -4.221e-02, 1.054e-02) * s0_1_2;
	r2 += V4(-1.845e-01, -1.158e-01, 2.289e-02, 1.642e-02) * s0_1_2;
	r0 += V4(7.534e-02, -3.221e-02, -5.311e-02, -2.348e-03) * s0_2_0;
	r1 += V4(2.002e-02, 3.208e-02, -2.445e-02, 1.234e-01) * s0_2_0;
	r2 += V4(-5.716e-02, 1.075e-02, 3.455e-02, -7.073e-02) * s0_2_0;
	r0 += V4(-6.689e-02, 6.796e-02, 6.740e-02, 1.433e-02) * s0_2_1;
	r1 += V4(-2.959e-02, -3.576e-02, -4.847e-02, -1.231e-01) * s0_2_1;
	r2 += V4(-3.316e-02, -5.719e-02, 8.220e-03, 2.205e-02) * s0_2_1;
	r0 += V4(-9.039e-03, 6.588e-03, -1.251e-02, -1.546e-02) * s0_2_2;
	r1 += V4(1.093e-02, 1.360e-01, 6.161e-02, 1.319e-02) * s0_2_2;
	r2 += V4(-8.948e-02, 5.146e-03, -5.310e-02, 1.393e-02) * s0_2_2;
	r0 += V4(2.032e-02, 5.188e-02, -2.736e-04, 2.116e-01);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-1.868e-03, 2.315e-03, -2.456e-03, -1.397e-02);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(3.198e-03, 2.130e-02, -7.639e-03, 2.031e-02);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-3x12-DS-conv1
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
	r0 = D(r0, s0_0_0, 0xEB02E000, 0x00FA0D01, 0x0D0301F5, 0xEC00C92C);
	r1 = D(r1, s0_0_0, 0xF0F304D9, 0xFFF8070A, 0x3AF94818, 0x1FE60F04);
	r2 = D(r2, s0_0_0, 0xE9C72B3C, 0x2B00FA10, 0x10F4F525, 0xF007C91C);
	r0 = D(r0, s0_0_1, 0xD2F51001, 0x6A134AE7, 0x1612F3F5, 0x08EA481A);
	r1 = D(r1, s0_0_1, 0xDC0FF581, 0xEBF41DF8, 0x1A13110D, 0xC0CC24BD);
	r2 = D(r2, s0_0_1, 0x00CB4F50, 0x2BF1062B, 0xDCEB2027, 0xEFFC1107);
	r0 = D(r0, s0_0_2, 0xE70618EA, 0x2CFDDA37, 0xF7F7F815, 0x0E00F00F);
	r1 = D(r1, s0_0_2, 0x0705F5FC, 0xD7EE41F2, 0xFF1D15EC, 0x01DC45E8);
	r2 = D(r2, s0_0_2, 0x1DE8F327, 0xF3FA1324, 0x0B0BF210, 0x0F0C22E6);
	r0 = D(r0, s0_1_0, 0x12FDE8FC, 0x0D0CBB14, 0x1216EDF9, 0x6A1DDFB9);
	r1 = D(r1, s0_1_0, 0x03E8C41D, 0x0915DAFC, 0xD5F3C504, 0xF1F70CE7);
	r2 = D(r2, s0_1_0, 0x55EDFB11, 0xFE02CE10, 0xF90ADE16, 0x1C027F30);
	r0 = D(r0, s0_1_1, 0x5F2B11FE, 0x81DCF44A, 0xD806ECF2, 0xA6E6A381);
	r1 = D(r1, s0_1_1, 0x28B65B78, 0x57FF450D, 0x8D101240, 0x19CE06E3);
	r2 = D(r2, s0_1_1, 0x8829C1D5, 0x83EAD1A6, 0x51DB07E3, 0x16C1D06E);
	r0 = D(r0, s0_1_2, 0xF2E2E42A, 0xE30F15C9, 0x1DF13CF4, 0xFF124DA4);
	r1 = D(r1, s0_1_2, 0x042810F9, 0xFAF3D531, 0x1A1DBBF4, 0xF9CE0607);
	r2 = D(r2, s0_1_2, 0x19DBE0C3, 0x3710DDBB, 0xEDC71BD1, 0xF1101DDE);
	r0 = D(r0, s0_2_0, 0xFAEEFD12, 0xF5010EF2, 0x18130602, 0x0AFC0518);
	r1 = D(r1, s0_2_0, 0x07F11AF3, 0x0022C802, 0x34B453E9, 0x17E8FCD5);
	r2 = D(r2, s0_2_0, 0x08FFF3ED, 0x1129A6FF, 0xFD18F1EB, 0x20F1DD0D);
	r0 = D(r0, s0_2_1, 0xDFEC343C, 0x100608F7, 0xBD34E60F, 0xFD0F20E5);
	r1 = D(r1, s0_2_1, 0x10080D25, 0xCF26C607, 0x0008D4E8, 0x11EED5EE);
	r2 = D(r2, s0_2_1, 0x1F2204A1, 0xE9BD3E58, 0xE20627FE, 0xFDE6D4F5);
	r0 = D(r0, s0_2_2, 0x1F11D806, 0xF3F41205, 0x010ADD17, 0xE5EB1E1A);
	r1 = D(r1, s0_2_2, 0xEB18E4CF, 0x1A0E11EE, 0xEEF7060D, 0x0402EBD0);
	r2 = D(r2, s0_2_2, 0xE5ED1DB7, 0x0A815FF4, 0xF60309F9, 0xE7021AEF);
	r0 = D(r0, s1_0_0, 0xE6040911, 0xEE07F8FA, 0x060BF7F9, 0x07F10009);
	r1 = D(r1, s1_0_0, 0xFF13E2E0, 0x0FFD02EF, 0xFFF51D0A, 0x0024C81A);
	r2 = D(r2, s1_0_0, 0x07EBEBA5, 0x0D141A20, 0x39EC00C8, 0x0BF3E1FB);
	r0 = D(r0, s1_0_1, 0xE6F3FEF6, 0x1337017F, 0x23FDFEF5, 0x19F7E915);
	r1 = D(r1, s1_0_1, 0x3205BCFE, 0xFDF6FEEE, 0xD7FC20D7, 0x133EF9D9);
	r2 = D(r2, s1_0_1, 0xB7170248, 0xEEF6C67F, 0x25F916D8, 0xF20DD82A);
	r0 = D(r0, s1_0_2, 0x0406FE12, 0xFEF4F7F3, 0x03FF02F1, 0x04FCFE09);
	r1 = D(r1, s1_0_2, 0x1FEE2E16, 0xFCF40BEF, 0x1C1E00EB, 0xFD081623);
	r2 = D(r2, s1_0_2, 0xF20F091D, 0x08DDD35D, 0x040119EB, 0x0607F4FD);
	r0 = D(r0, s1_1_0, 0xF516E611, 0x10FCFA10, 0x0B181035, 0x0B27F341);
	r1 = D(r1, s1_1_0, 0x4B221086, 0xF70D082C, 0xEE81818E, 0xBA29000A);
	r2 = D(r2, s1_1_0, 0xD6032FAE, 0xFDF3F649, 0x2BFD09B0, 0x7FE759F4);
	r0 = D(r0, s1_1_1, 0x030A313E, 0xEF811AAE, 0x1FE5F9F0, 0xECC420B1);
	r1 = D(r1, s1_1_1, 0x900CDF86, 0xFB34BC61, 0xBF63887F, 0xDB7EA723);
	r2 = D(r2, s1_1_1, 0xE9FCC233, 0x2535F66C, 0x7FF63C8A, 0xDDF8F6FC);
	r0 = D(r0, s1_1_2, 0xF1FC0BFE, 0xFFFB111F, 0x100D01DF, 0x0E18F906);
	r1 = D(r1, s1_1_2, 0xFB06107E, 0xFDED03E3, 0xF1FE0512, 0xE4423D07);
	r2 = D(r2, s1_1_2, 0xE1410212, 0x1BDD14ED, 0xF8090108, 0x000F090C);
	r0 = D(r0, s1_2_0, 0xFA08EEF7, 0x0407F6DE, 0xEF041118, 0xFD11ECDD);
	r1 = D(r1, s1_2_0, 0x29FAF0F5, 0xFA02124B, 0x23FAFD81, 0xD9350641);
	r2 = D(r2, s1_2_0, 0xD82EF54C, 0x1500D945, 0xF60F02E3, 0x19141192);
	r0 = D(r0, s1_2_1, 0xF5F4DEA6, 0x15F806F8, 0xEF23FF2A, 0x2411F7F0);
	r1 = D(r1, s1_2_1, 0xFDE9E70C, 0xECEAF77F, 0xFA06F942, 0xDD550929);
	r2 = D(r2, s1_2_1, 0x0D38F53E, 0x00E78181, 0xD9D8F706, 0x03F40206);
	r0 = D(r0, s1_2_2, 0x02D4E90F, 0x08FE06F6, 0x090700DB, 0x040605FA);
	r1 = D(r1, s1_2_2, 0x0102177F, 0x0F0303F3, 0x09010211, 0xEA440319);
	r2 = D(r2, s1_2_2, 0xF974FBF0, 0xCE812CEB, 0xF01B071E, 0x06140002);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFC0C03FB, 0xFD0CFDF9, 0x1DF1FF04, 0xE914FEE6);
	r1 = D(r1, s0_0_0, 0xFF17FD10, 0xFE010FFF, 0x04E2FE16, 0xE718D423);
	r2 = D(r2, s0_0_0, 0x964A600E, 0xFC08DFDF, 0xE11A14CE, 0xD810F428);
	r0 = D(r0, s0_0_1, 0x21012214, 0x2FCC81C3, 0x1502F0E1, 0x0F04EEFC);
	r1 = D(r1, s0_0_1, 0x6CDDF9E1, 0xF2101502, 0x04012FC3, 0xFD3B050E);
	r2 = D(r2, s0_0_1, 0x9321E526, 0xF414B1EC, 0xD70E0DF8, 0xE3EEE4DF);
	r0 = D(r0, s0_0_2, 0x16F6F5F8, 0xE0181601, 0xF4030606, 0xE704F0FF);
	r1 = D(r1, s0_0_2, 0xB70BCB06, 0x140A180C, 0x2DDA0D0D, 0xDD20CAE3);
	r2 = D(r2, s0_0_2, 0xDC26F6E1, 0x1CFBC328, 0x10F4FEEC, 0x18F70606);
	r0 = D(r0, s0_1_0, 0xFFF61A1E, 0xFD02C3E5, 0x17DDD2FF, 0x31CFBFD0);
	r1 = D(r1, s0_1_0, 0xC42D1909, 0x0105E80E, 0xD65412C0, 0xDF5FE4FA);
	r2 = D(r2, s0_1_0, 0xE14A2CF6, 0x011BBF5A, 0xFDF422F6, 0x8132B4F9);
	r0 = D(r0, s0_1_1, 0x0AF4D6CE, 0xF238814E, 0x2609E928, 0x334E431C);
	r1 = D(r1, s0_1_1, 0x81237F18, 0x06D4CEFE, 0x83C3D13E, 0xF302C6FB);
	r2 = D(r2, s0_1_1, 0x5EE9FCA3, 0x2FE9AABD, 0x19950A13, 0xC9FA0735);
	r0 = D(r0, s0_1_2, 0xF81B1412, 0x31D4D4FC, 0xEC010501, 0x44D6FD0C);
	r1 = D(r1, s0_1_2, 0x16E3DAF0, 0xCB3611F3, 0x37FFF3F1, 0x0727F3F6);
	r2 = D(r2, s0_1_2, 0x4E07F029, 0x812DF611, 0xFB17EE19, 0x1BEDFA07);
	r0 = D(r0, s0_2_0, 0xFDF513F5, 0x06FB11EE, 0x00EC0402, 0xF7EB390F);
	r1 = D(r1, s0_2_0, 0x19EAF8E1, 0x08F7DCE5, 0xFCEF3702, 0xF519AFAE);
	r2 = D(r2, s0_2_0, 0xF922B2D2, 0x22DC9FD4, 0x0C09CF11, 0xD91920FF);
	r0 = D(r0, s0_2_1, 0xF310430D, 0x1E00E914, 0x14D52EED, 0x03FFC70B);
	r1 = D(r1, s0_2_1, 0xFE0BC5FE, 0xFC3ED823, 0x16B2C401, 0xED26AA1C);
	r2 = D(r2, s0_2_1, 0x360B8145, 0x03F87F56, 0x042AD408, 0xEE17F8F2);
	r0 = D(r0, s0_2_2, 0x1808F8F3, 0xFFFE0506, 0xF90417EF, 0xE00DFF06);
	r1 = D(r1, s0_2_2, 0x3FF5D028, 0xE820EDFC, 0x07FBF70D, 0x1406ED35);
	r2 = D(r2, s0_2_2, 0xFAE2E607, 0xDFEFF1ED, 0x1006EC0D, 0x09FB0304);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-2.899e-02, 4.178e-02, 4.237e-02, 2.289e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-5.522e-03, 1.665e-02, -1.502e-02, 3.328e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-2.398e-02, 1.008e-01, 2.692e-04, -6.093e-03);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-3x12-DS-conv2
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
	r0 = D(r0, s0_0_0, 0x02F50409, 0x0EFD170E, 0xF7E1041C, 0xFBD50A46);
	r1 = D(r1, s0_0_0, 0xEA091107, 0x0EF6F1FD, 0x0117FEF9, 0xF035F204);
	r2 = D(r2, s0_0_0, 0xFB13F701, 0x140F0703, 0xF50DFC0A, 0x07EAF9F5);
	r0 = D(r0, s0_0_1, 0x0EEB0305, 0x0C12F80F, 0xE1D5FEDF, 0x01C527AD);
	r1 = D(r1, s0_0_1, 0xF756E9E4, 0x00EB0719, 0x00FC031A, 0xF2C9FC02);
	r2 = D(r2, s0_0_1, 0x030A0211, 0x09070301, 0xFA3607F0, 0x0AED10DE);
	r0 = D(r0, s0_0_2, 0x0206F50A, 0xEDFBF601, 0x11FFFC05, 0x160CF91C);
	r1 = D(r1, s0_0_2, 0xE011E723, 0xEEF9F001, 0xED0FFCFD, 0xB1D7E5E4);
	r2 = D(r2, s0_0_2, 0x00FB0101, 0x09E307F5, 0xF10A0303, 0xF91808F2);
	r0 = D(r0, s0_1_0, 0xFE0A0606, 0xE4223013, 0xCF49CF46, 0xE010A248);
	r1 = D(r1, s0_1_0, 0x12F4280F, 0x0328F8CA, 0x020CFBE1, 0xFF00D1CF);
	r2 = D(r2, s0_1_0, 0xF120F5ED, 0xFEF3F9E9, 0x0402EEFB, 0x000A000B);
	r0 = D(r0, s0_1_1, 0x17BF140A, 0x0CC92B2A, 0x8127FCC4, 0x99F9811A);
	r1 = D(r1, s0_1_1, 0x53972395, 0x14E61C0D, 0xA6F5FB69, 0x293581BE);
	r2 = D(r2, s0_1_1, 0x0CE809F1, 0xFECFF4EC, 0xF3FABE23, 0x05E409BD);
	r0 = D(r0, s0_1_2, 0x441B16E8, 0x040708FA, 0x140CFB0E, 0x0319E813);
	r1 = D(r1, s0_1_2, 0x421B06D9, 0x05FD01EC, 0xDEE9FFDD, 0xEF16EED8);
	r2 = D(r2, s0_1_2, 0xEFFFFE01, 0xF6F50208, 0xFA040209, 0x1A0E0301);
	r0 = D(r0, s0_2_0, 0xF80301FF, 0xEE091E13, 0xFB0BD4E6, 0xEA06E8E3);
	r1 = D(r1, s0_2_0, 0x0607EEEB, 0xFC1819E7, 0xF80CF904, 0x02041504);
	r2 = D(r2, s0_2_0, 0x020E00EB, 0xF00CD4F2, 0xF905FBFB, 0x02F5F605);
	r0 = D(r0, s0_2_1, 0xFEF7DF08, 0xF5FC15F5, 0x0AF416BC, 0x0DFDFADC);
	r1 = D(r1, s0_2_1, 0x00D8BB21, 0x0CF6EEEE, 0xF5FEDFF6, 0x1602EDDA);
	r2 = D(r2, s0_2_1, 0xFFFDFA0A, 0xD1231CE5, 0xFBFEF5F3, 0x00070C18);
	r0 = D(r0, s0_2_2, 0x03080D1A, 0x180501F2, 0x1808FA00, 0x2305F101);
	r1 = D(r1, s0_2_2, 0x20F2FF05, 0x1609F3F7, 0x080204EE, 0x0707F2F6);
	r2 = D(r2, s0_2_2, 0x0108F4FE, 0xC815F802, 0x040306FD, 0xF601F70A);
	r0 = D(r0, s1_0_0, 0x0104FEF9, 0xFB1028FB, 0xFBFBF308, 0xE311BB17);
	r1 = D(r1, s1_0_0, 0x091FF9F9, 0xFD183D03, 0xFD010D03, 0xF80D0F13);
	r2 = D(r2, s1_0_0, 0x020AF7FB, 0xFA0E2504, 0xF4F0F806, 0x0EFF0202);
	r0 = D(r0, s1_0_1, 0xF7050F00, 0xFDEBCAF3, 0x0510130B, 0x0A072510);
	r1 = D(r1, s1_0_1, 0xE01CD702, 0x09F0AE06, 0xF204D50A, 0x14EEEDF7);
	r2 = D(r2, s1_0_1, 0xFC04F005, 0x06F5080A, 0xF7FFFF10, 0xFDF45DF5);
	r0 = D(r0, s1_0_2, 0x0009DC0A, 0xF607EFF5, 0xF30EFD05, 0xD8290B23);
	r1 = D(r1, s1_0_2, 0xE4FEF6F0, 0x1006F709, 0xFFF6F701, 0xF210F40A);
	r2 = D(r2, s1_0_2, 0xFF07FC04, 0xFF06FC10, 0xFCFD020E, 0xECE70C0F);
	r0 = D(r0, s1_1_0, 0xFEF4F706, 0xEFF2DD04, 0xEDE9D100, 0xF802E501);
	r1 = D(r1, s1_1_0, 0x15171E15, 0xE5220229, 0xECF50B1C, 0xDBFD1C33);
	r2 = D(r2, s1_1_0, 0xE9FDE80F, 0xE504291B, 0x04000C0A, 0x070904F4);
	r0 = D(r0, s1_1_1, 0x00033A01, 0xB71C3311, 0x2B36F523, 0x0BD10A23);
	r1 = D(r1, s1_1_1, 0xD2E66C0D, 0xC9C1410D, 0x0FF217FE, 0x1AD9EE48);
	r2 = D(r2, s1_1_1, 0x08263020, 0xCD3ED72D, 0xF1E72A16, 0xE800D716);
	r0 = D(r0, s1_1_2, 0xF0CEEC02, 0xFDFD130D, 0xFA02FE06, 0x1923E903);
	r1 = D(r1, s1_1_2, 0x2201FF18, 0x11F50800, 0x0B00F2F8, 0x2129F90F);
	r2 = D(r2, s1_1_2, 0xFB01F808, 0xE8FC1015, 0xF6FCF802, 0x0AF1F8FF);
	r0 = D(r0, s1_2_0, 0x00FDFE0C, 0xEFFAF6F2, 0x05F40C16, 0x0F07ECF1);
	r1 = D(r1, s1_2_0, 0xFDFEFB12, 0xE00E0B1B, 0x0CFFFD0C, 0xF8FF1D1E);
	r2 = D(r2, s1_2_0, 0x06020109, 0xEA1AE20E, 0x04FFFB07, 0xFDFD00FC);
	r0 = D(r0, s1_2_1, 0x03090302, 0x070F06F8, 0x201E111F, 0x2DFCF0FF);
	r1 = D(r1, s1_2_1, 0xB1220422, 0x0524031B, 0xDBFFF7FE, 0xEA010A10);
	r2 = D(r2, s1_2_1, 0xF5190507, 0x48F4E005, 0xFDF80116, 0x00FA0AF0);
	r0 = D(r0, s1_2_2, 0xF7FCF4FF, 0xFE090403, 0xFB0EEF14, 0x0CFD0305);
	r1 = D(r1, s1_2_2, 0xCFF90C26, 0xF2110108, 0x10F90304, 0xEC08021C);
	r2 = D(r2, s1_2_2, 0x040AF905, 0x0239D909, 0x0C00F7FF, 0xE3F5010A);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x02FDF904, 0xFEFCF4E2, 0x090A17F5, 0xF0393B04);
	r1 = D(r1, s0_0_0, 0xF801EF0E, 0xFD1AF6F4, 0xFDF1FA18, 0x0DF7091D);
	r2 = D(r2, s0_0_0, 0xFEFA0610, 0xFF0309FC, 0xFEEE0215, 0xF916FBF2);
	r0 = D(r0, s0_0_1, 0xFF08FBF6, 0xDC10F7F6, 0xEF010403, 0xF001F7FF);
	r1 = D(r1, s0_0_1, 0x10C8EC39, 0xF71402FA, 0x02061603, 0xFFE10FF4);
	r2 = D(r2, s0_0_1, 0xFAFCFE08, 0xEF0D0D08, 0x09CC1309, 0xF417ED0C);
	r0 = D(r0, s0_0_2, 0xFE190200, 0x15F803F8, 0x05010002, 0xF1080B06);
	r1 = D(r1, s0_0_2, 0xF0E2050B, 0xF71005EF, 0xFBFD0000, 0xE2161CFC);
	r2 = D(r2, s0_0_2, 0xFBF60706, 0x0B0104F7, 0xFBDB0712, 0xD805F80F);
	r0 = D(r0, s0_1_0, 0x05FFF601, 0x0DF0F40A, 0xF7DF220B, 0x07155202);
	r1 = D(r1, s0_1_0, 0x001AE9BC, 0x04B90A13, 0xFD08090D, 0x03DD0C0A);
	r2 = D(r2, s0_1_0, 0xFFF8071F, 0xF7E10E30, 0xFAFC09FA, 0x040AF607);
	r0 = D(r0, s0_1_1, 0x0E07FBFB, 0x1EC0F322, 0x040207E3, 0xBE3E2028);
	r1 = D(r1, s0_1_1, 0xEF9DEE0D, 0x08C4F923, 0x0B221004, 0xF12754C0);
	r2 = D(r2, s0_1_1, 0x15EEFAFE, 0x01F11C0E, 0xFCE7032B, 0xFDFDFA08);
	r0 = D(r0, s0_1_2, 0xE4E1FF1D, 0xFF0AF7E2, 0xEEEEF41B, 0x9A200EF9);
	r1 = D(r1, s0_1_2, 0xD9BBF6AC, 0x0D0706F0, 0x121F07FB, 0x810B08F3);
	r2 = D(r2, s0_1_2, 0x21040D08, 0xD0EE040D, 0xEF0904F1, 0x1807FD01);
	r0 = D(r0, s0_2_0, 0xFF0302FD, 0xFCF1FEFF, 0xFB0505E0, 0xFA1A0CDE);
	r1 = D(r1, s0_2_0, 0x0217F9EE, 0x00DF00E2, 0xFEFE0804, 0x03F40A00);
	r2 = D(r2, s0_2_0, 0xFAF604FF, 0x03FA2BF8, 0x02060804, 0xFA070207);
	r0 = D(r0, s0_2_1, 0xFF05FD13, 0xED0002E7, 0xE404F8D7, 0xF41B03DE);
	r1 = D(r1, s0_2_1, 0x1807EB2F, 0xF9EC06FC, 0xFA19120D, 0xEBEE0B10);
	r2 = D(r2, s0_2_1, 0xF7F8090E, 0xF87F24DE, 0x030E0BF9, 0x07E20013);
	r0 = D(r0, s0_2_2, 0x06F503FD, 0xFD1101DF, 0x1802FD0B, 0xF90D07EA);
	r1 = D(r1, s0_2_2, 0x08F60C02, 0xF21208FD, 0x090602E8, 0x05010220);
	r2 = D(r2, s0_2_2, 0x050C0305, 0xE40A0606, 0xF90603FC, 0x0AFF0320);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-2.146e-02, -5.026e-02, 4.526e-03, 7.379e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-3.941e-02, -3.429e-02, -1.140e-02, -1.707e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-1.822e-02, -2.728e-02, -2.755e-04, -6.827e-03);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-3x12-DS-conv3
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
	r0 = D(r0, s0_0_0, 0xFEFD04F7, 0xFC04030B, 0x05FF03FF, 0x0002FE0C);
	r1 = D(r1, s0_0_0, 0x050B0415, 0xFD03FB0D, 0xFA0AFD30, 0x01FD00F7);
	r2 = D(r2, s0_0_0, 0xFD03FE06, 0x0100FFF0, 0x040C031A, 0x0505080C);
	r0 = D(r0, s0_0_1, 0xFB03FA01, 0xFE0504F6, 0xFF0206FE, 0x000101F3);
	r1 = D(r1, s0_0_1, 0xD4D2F904, 0xF9F6FDF3, 0xEBD42106, 0xFB01F9FA);
	r2 = D(r2, s0_0_1, 0xFC1B0304, 0x00FBFEF4, 0xFFE8F70E, 0xF0D2FE03);
	r0 = D(r0, s0_0_2, 0xFAF7FAFE, 0x000508FF, 0xFD05F906, 0xFF0506FF);
	r1 = D(r1, s0_0_2, 0xFAFEFDFE, 0x02FAF9FF, 0xFEFEF100, 0xF909F8FD);
	r2 = D(r2, s0_0_2, 0x00100905, 0xFCECFF00, 0xFBF608FF, 0xFEEDF201);
	r0 = D(r0, s0_1_0, 0xFC04FB00, 0x03020904, 0x01F7F5FD, 0x02FC06D4);
	r1 = D(r1, s0_1_0, 0x07F5F643, 0xE7C50F27, 0xFAFAFBC9, 0x01040816);
	r2 = D(r2, s0_1_0, 0xFD040014, 0xFDF9FCFE, 0x03FEF839, 0xF601F6ED);
	r0 = D(r0, s0_1_1, 0xFFDD161E, 0xF7E5E502, 0xE50510FE, 0xF8F3111F);
	r1 = D(r1, s0_1_1, 0xCEABFCCB, 0xFF00FC01, 0xF8FCCCEC, 0xF8EF0400);
	r2 = D(r2, s0_1_1, 0xF21BFCFF, 0xF1EB2517, 0xFBDF201A, 0x06030CF7);
	r0 = D(r0, s0_1_2, 0xFB02FA02, 0xFBDDFF05, 0xFDE6EB04, 0xFBDDDC01);
	r1 = D(r1, s0_1_2, 0xFB010A06, 0x0300FDFE, 0xF000FDFD, 0x00E70303);
	r2 = D(r2, s0_1_2, 0xFEF61605, 0xF9EE0604, 0xFDF8FB04, 0xF60004FE);
	r0 = D(r0, s0_2_0, 0xF5000A04, 0xFAFF00EE, 0x0AFA04E3, 0xFE01FAFC);
	r1 = D(r1, s0_2_0, 0xFFFDF510, 0x00DC0B00, 0x05FFFF07, 0xFC03FCE7);
	r2 = D(r2, s0_2_0, 0xFB02030A, 0xFF0301F9, 0xFDFDFA10, 0x0200FF02);
	r0 = D(r0, s0_2_1, 0xF5F50005, 0xFEEE0600, 0xEEE2D11B, 0xF908EDE2);
	r1 = D(r1, s0_2_1, 0x00EFFFFB, 0xFFF9D901, 0x09020503, 0xEA010FFE);
	r2 = D(r2, s0_2_1, 0xE3090106, 0xE204E7E9, 0x07F80304, 0xF801FEFE);
	r0 = D(r0, s0_2_2, 0xFCFB02FB, 0xF6030200, 0xFC07F7F5, 0xFCFF1EFE);
	r1 = D(r1, s0_2_2, 0xFFF802FF, 0x04FF0BFD, 0x0A020AFC, 0xE9FD0400);
	r2 = D(r2, s0_2_2, 0xF8FE0202, 0xEC020AFE, 0xFAF9FA05, 0x020107FF);
	r0 = D(r0, s1_0_0, 0xFEF90100, 0xFDF90301, 0x00FE0103, 0xFCFB0002);
	r1 = D(r1, s1_0_0, 0xFE000007, 0xFFFFFE07, 0xD0F306F5, 0x03020001);
	r2 = D(r2, s1_0_0, 0x01FEFE00, 0xFEFE0105, 0x00FE0202, 0x02FD030F);
	r0 = D(r0, s1_0_1, 0xF9FBFF06, 0xFCF400F2, 0xFD03F803, 0x00FA05F6);
	r1 = D(r1, s1_0_1, 0xFBEC03FD, 0x0106F8F8, 0xA1CC2613, 0xFC10F811);
	r2 = D(r2, s1_0_1, 0x01F700F9, 0x02F60904, 0xF8EB01FD, 0xDEE01218);
	r0 = D(r0, s1_0_2, 0x05030200, 0x02F3FE00, 0x02050605, 0x05FC0100);
	r1 = D(r1, s1_0_2, 0x02FEFF03, 0xFF050405, 0xF0F121FE, 0xFA03FE05);
	r2 = D(r2, s1_0_2, 0x03E702FD, 0x02FDF800, 0x09F1F9FC, 0xFB00F901);
	r0 = D(r0, s1_1_0, 0xFAEAFE06, 0xFFF1020E, 0xFB010402, 0x04FB060E);
	r1 = D(r1, s1_1_0, 0x000001D8, 0xBFFA011F, 0xF2FCFDFE, 0x03E70214);
	r2 = D(r2, s1_1_0, 0xFF01FDFF, 0xF7F508FC, 0x01FA02DB, 0xF9FE03FB);
	r0 = D(r0, s1_1_1, 0xE9FFF700, 0xEDCC0822, 0x02E2FD00, 0xD3CC0A27);
	r1 = D(r1, s1_1_1, 0xDCE51B0F, 0x0501CDEA, 0xE4F6F3ED, 0xFEC2F5FE);
	r2 = D(r2, s1_1_1, 0x03EAF1E1, 0xE4C510EF, 0xE6D21307, 0xEAF9F7E8);
	r0 = D(r0, s1_1_2, 0xF70C03FC, 0x00F9F102, 0xFF0E0C07, 0xE90C0A09);
	r1 = D(r1, s1_1_2, 0x0E06FEFF, 0xFE030707, 0x0901EEFF, 0x05FBF9F9);
	r2 = D(r2, s1_1_2, 0x22D2E6F7, 0xD8022805, 0x09F3F6F5, 0xFFF90C02);
	r0 = D(r0, s1_2_0, 0xF9F6030A, 0xF0F805EF, 0xFFF60511, 0xFA0001F7);
	r1 = D(r1, s1_2_0, 0xFDFD04F3, 0xE504EA1D, 0xFF0000FC, 0xF0FE00EC);
	r2 = D(r2, s1_2_0, 0xFDFF0006, 0xFCF901FB, 0xFDFC01F9, 0xFEFEFFFD);
	r0 = D(r0, s1_2_1, 0xDEF8E4F7, 0xE901FDE8, 0xD4CCEBF1, 0xFE0605EF);
	r1 = D(r1, s1_2_1, 0xF9F3030E, 0x0EF602F4, 0x0AFF03FA, 0xEF16FCF3);
	r2 = D(r2, s1_2_1, 0xFCFAFC02, 0xF8F6010D, 0xF3F20507, 0x03000603);
	r0 = D(r0, s1_2_2, 0x00020F06, 0xE8FC1A08, 0xDA182C08, 0xF1EDF9F5);
	r1 = D(r1, s1_2_2, 0x02FD0200, 0xFD000904, 0xFF04FB04, 0xF4FF1407);
	r2 = D(r2, s1_2_2, 0x0DF8F900, 0xF0EFFBF7, 0x00F80201, 0xFD00F9FE);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x02020207, 0x0204FCF9, 0x03FF02FA, 0x0003FFFF);
	r1 = D(r1, s0_0_0, 0xF4FC02FF, 0x05F8EA0A, 0xF2070DFA, 0xFCF80105);
	r2 = D(r2, s0_0_0, 0x02040104, 0xFF01FF02, 0xFC0006FF, 0x000103F9);
	r0 = D(r0, s0_0_1, 0x01FCF011, 0xFD0CFDED, 0xFF02FBFC, 0x0306FCF5);
	r1 = D(r1, s0_0_1, 0x0501DF15, 0xFC04F100, 0x0C27E103, 0xFBF90AF4);
	r2 = D(r2, s0_0_1, 0x010B01FF, 0x0704FA06, 0x0407E71B, 0xF60FB725);
	r0 = D(r0, s0_0_2, 0x0204E705, 0x00FCEAFC, 0x01FCF706, 0x0400F2FE);
	r1 = D(r1, s0_0_2, 0xFEFEFF0A, 0x04FE0507, 0x080009F3, 0xF70404FD);
	r2 = D(r2, s0_0_2, 0x00050002, 0x0605F40B, 0xFFFFEC04, 0x0709F0F6);
	r0 = D(r0, s0_1_0, 0x07040608, 0x0212FDFB, 0xFE030C09, 0x0208FD00);
	r1 = D(r1, s0_1_0, 0xEF02FF03, 0x01F6D25C, 0x0D1E000F, 0xFEFDF8F0);
	r2 = D(r2, s0_1_0, 0x0509060A, 0x04050203, 0xE802FC06, 0xFC0A04FF);
	r0 = D(r0, s0_1_1, 0xFDF9E35B, 0x1824D62E, 0x10FAD204, 0xFA06D025);
	r1 = D(r1, s0_1_1, 0xF70BE702, 0xFAF7E9E8, 0x16E4FF09, 0x16F6D41F);
	r2 = D(r2, s0_1_1, 0x0111122E, 0x0402020B, 0x0815EA0C, 0x40120AE6);
	r0 = D(r0, s0_1_2, 0xF3F5DFF8, 0xFD01D917, 0xF7FECE19, 0x0213AD09);
	r1 = D(r1, s0_1_2, 0x01F6020F, 0x0206FE02, 0xF908F905, 0x09FDE513);
	r2 = D(r2, s0_1_2, 0xFE030BF7, 0x0C0AFBF8, 0xF7F80111, 0x0AFC0501);
	r0 = D(r0, s0_2_0, 0x0E000000, 0xF6160102, 0x0FF406F0, 0x060504FE);
	r1 = D(r1, s0_2_0, 0x0003FD11, 0x0300F209, 0xFE0700FB, 0xF6120301);
	r2 = D(r2, s0_2_0, 0xF8030404, 0x150902FF, 0xEF02FB10, 0x0304FF02);
	r0 = D(r0, s0_2_1, 0xF10EF918, 0x094804F2, 0x0015F152, 0x432108EE);
	r1 = D(r1, s0_2_1, 0xB7F2FD0C, 0xEFF5FE13, 0xFF0707FD, 0x1F3EFDED);
	r2 = D(r2, s0_2_1, 0xD3E20205, 0x42FC07F3, 0xF9F90407, 0xF7040101);
	r0 = D(r0, s0_2_2, 0xF5F5FB07, 0x091E03E2, 0xEBF2CEE7, 0x1E010CF5);
	r1 = D(r1, s0_2_2, 0x040AFCFC, 0x000003F9, 0xFBFC02FC, 0x070607EE);
	r2 = D(r2, s0_2_2, 0xFA040310, 0x130806FA, 0xF006FB05, 0x02FE01FF);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.064e-02, -2.091e-02, -8.879e-03, -1.104e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-8.137e-03, -1.143e-02, -1.886e-02, -1.138e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(4.187e-03, -3.746e-04, -2.149e-03, -8.940e-03);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-3x12-DS-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv3
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
#define l0(x, y) V4((conv3_mul * texelFetch(conv3_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0), 0)))
#define l1(x, y) V4((conv3_mul * texelFetch(conv3_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0), 0)))
#define l2(x, y) V4((conv3_mul * texelFetch(conv3_raw, clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0), 0)))
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
	r0 += M4(-1.997e-02, 1.593e-02, -2.142e-02, 7.622e-04, -3.536e-02, 2.103e-03, 1.303e-02, -1.799e-03, -7.402e-02, 6.540e-03, -3.651e-02, 5.539e-03, 1.983e-02, 6.777e-03, -3.650e-03, 4.805e-03) * s0_0_0;
	r0 += M4(7.902e-02, -1.173e-01, -2.952e-03, 2.966e-02, -1.938e-01, -1.946e-01, -6.755e-03, -6.502e-03, 3.750e-01, -2.842e-01, 1.714e-01, -1.670e-01, -3.480e-02, 1.401e-01, -7.627e-03, 2.983e-02) * s0_0_1;
	r0 += M4(-9.827e-06, 8.648e-02, 5.681e-04, 1.421e-02, 7.311e-03, -3.528e-02, -2.757e-03, -3.441e-03, -2.976e-02, -6.379e-02, -1.534e-02, -3.162e-02, 1.302e-02, -6.079e-03, 3.418e-04, 8.850e-04) * s0_0_2;
	r0 += M4(-3.943e-02, 3.901e-03, -2.970e-02, 1.213e-02, 4.213e-02, -9.102e-03, 1.316e-02, -1.873e-02, -1.531e-02, -6.819e-03, -4.968e-02, 3.036e-03, 6.084e-02, -1.935e-02, -7.472e-02, 2.745e-04) * s0_1_0;
	r0 += M4(-7.007e-02, -1.478e-01, 1.102e-01, -3.643e-01, 2.456e-01, 1.712e-01, -1.057e-01, 7.243e-02, 9.262e-03, 7.300e-02, 1.632e-01, 3.768e-02, 6.763e-02, 3.095e-01, -1.974e-02, -6.307e-01) * s0_1_1;
	r0 += M4(1.968e-02, 1.837e-01, 9.659e-03, 2.056e-01, -2.334e-02, 4.368e-02, 1.104e-02, -1.860e-02, -1.091e-02, -3.694e-03, -2.213e-02, -2.179e-02, 2.128e-03, 4.726e-03, -6.886e-03, 3.059e-03) * s0_1_2;
	r0 += M4(-1.910e-03, -3.374e-03, -1.663e-02, -3.118e-04, -7.201e-03, -2.534e-03, 2.877e-03, -3.363e-03, -3.070e-03, 6.711e-03, -1.279e-02, 9.499e-03, -3.176e-03, -9.044e-04, 2.521e-02, 7.151e-03) * s0_2_0;
	r0 += M4(8.323e-03, -1.064e-02, -5.213e-02, -2.899e-03, -4.474e-03, -3.807e-03, 9.883e-02, 4.822e-02, -1.508e-03, -6.790e-03, 1.486e-03, -1.581e-02, 4.014e-03, -1.972e-03, 4.285e-02, 7.056e-02) * s0_2_1;
	r0 += M4(5.893e-03, -2.701e-03, 1.565e-02, 3.970e-02, -1.924e-03, -7.485e-04, -1.496e-02, 2.259e-02, 4.866e-04, -4.067e-03, -3.708e-03, -9.145e-03, -3.362e-05, -3.369e-03, -1.659e-03, 6.882e-03) * s0_2_2;
	r0 += M4(-1.960e-04, 5.872e-03, 7.844e-03, -4.121e-04, 6.116e-04, 2.624e-03, -1.555e-03, 1.646e-04, -5.790e-03, -4.048e-03, -7.185e-05, -2.863e-04, 4.604e-03, 4.096e-03, -1.733e-03, -4.615e-03) * s1_0_0;
	r0 += M4(-3.610e-02, -3.994e-03, -8.747e-03, -4.655e-03, 2.051e-02, -2.021e-02, 2.228e-02, -4.602e-03, 4.379e-03, 4.941e-03, 4.027e-03, 3.186e-03, -9.781e-02, -7.371e-02, -5.962e-02, -1.819e-02) * s1_0_1;
	r0 += M4(-2.788e-02, 2.187e-02, -4.971e-03, 2.069e-02, -2.280e-01, 1.610e-01, 3.266e-04, 6.641e-04, -2.020e-03, -7.089e-04, 3.127e-03, 2.448e-03, 3.046e-02, -3.403e-03, 2.073e-02, 5.470e-03) * s1_0_2;
	r0 += M4(-8.911e-02, -2.936e-03, -4.901e-02, 3.868e-03, 3.227e-03, 4.200e-03, 4.224e-03, 3.722e-03, -1.486e-02, -4.009e-05, -2.495e-03, 4.505e-03, -3.212e-02, -4.170e-03, -1.027e-02, 3.936e-03) * s1_1_0;
	r0 += M4(4.320e-01, -1.701e-01, 2.161e-01, -8.004e-02, 1.988e-02, -8.646e-03, 2.634e-02, -1.403e-02, -1.947e-02, -2.643e-02, -3.308e-02, -1.529e-02, -1.929e-01, -1.002e-01, 4.013e-01, 1.489e-01) * s1_1_1;
	r0 += M4(3.786e-02, -1.644e-01, -2.061e-03, -7.494e-02, -9.516e-02, 6.127e-02, -3.860e-01, 3.154e-01, -1.994e-02, -3.162e-02, -4.892e-03, -1.594e-02, -1.864e-02, -7.866e-02, -3.749e-02, 9.448e-02) * s1_1_2;
	r0 += M4(-7.443e-04, -5.879e-04, -4.339e-02, -1.307e-03, -7.464e-07, 1.094e-03, 9.849e-04, 4.206e-03, 1.530e-02, -1.216e-02, -4.662e-03, 2.543e-04, 5.228e-03, 5.050e-03, -3.274e-03, 7.251e-03) * s1_2_0;
	r0 += M4(-3.684e-02, -6.909e-03, 1.322e-01, -4.979e-02, 4.264e-03, 1.835e-03, 3.456e-03, -4.366e-03, -3.037e-01, -1.302e-02, 3.096e-01, 7.007e-02, -1.986e-03, -3.014e-03, -9.684e-02, -4.846e-02) * s1_2_1;
	r0 += M4(-7.767e-03, 4.328e-02, 7.981e-03, -4.539e-02, -2.176e-03, 2.009e-02, 2.741e-02, -3.035e-03, 2.188e-02, -1.078e-01, -2.000e-02, 5.295e-02, -2.538e-03, -5.671e-03, 6.670e-05, -3.864e-02) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 += M4(-1.060e-02, -2.417e-03, -3.369e-03, 1.480e-02, 5.994e-02, -5.429e-03, 2.402e-03, 2.703e-03, 8.873e-03, -2.112e-03, -1.887e-03, 2.919e-03, 4.741e-04, -1.312e-03, 1.228e-03, 4.626e-03) * s0_0_0;
	r0 += M4(-2.710e-03, -2.305e-03, -4.674e-02, -4.219e-02, 9.789e-02, 1.613e-01, 2.820e-03, -1.824e-04, 6.007e-02, 1.435e-02, 1.656e-02, 8.830e-03, -1.302e-02, -2.279e-03, -8.817e-03, -8.452e-03) * s0_0_1;
	r0 += M4(-6.971e-03, -1.478e-02, 6.121e-03, -1.394e-02, -1.154e-02, -3.490e-04, -8.617e-04, -6.654e-03, -1.631e-02, -6.873e-03, 2.901e-03, 9.940e-03, 7.430e-03, -1.870e-03, 4.319e-03, 1.705e-03) * s0_0_2;
	r0 += M4(-4.503e-03, -4.896e-02, -5.193e-03, -4.382e-02, -8.422e-02, 3.081e-02, 4.278e-02, -2.068e-02, 1.091e-01, 2.391e-04, 6.067e-02, -5.288e-03, -5.053e-04, 1.032e-02, -8.952e-03, 5.276e-04) * s0_1_0;
	r0 += M4(1.380e-01, 1.265e-01, 1.372e-01, 1.228e-01, -1.409e-01, -3.525e-01, 1.968e-01, 3.135e-01, -2.881e-01, 2.308e-01, -1.155e-01, 1.105e-01, 2.600e-01, -1.081e-04, 4.038e-02, -2.889e-02) * s0_1_1;
	r0 += M4(-2.483e-02, 1.872e-02, -2.569e-02, 2.053e-02, -7.188e-03, 2.944e-02, -1.394e-02, 7.372e-03, 1.913e-02, -1.840e-01, -1.666e-02, -1.460e-01, -1.489e-02, 6.679e-03, -3.915e-03, -3.907e-03) * s0_1_2;
	r0 += M4(-6.747e-03, 1.047e-02, -1.259e-02, -1.197e-02, 5.572e-03, 7.804e-04, -2.943e-02, -8.698e-03, 1.529e-03, 3.779e-03, 5.330e-02, 3.234e-03, -1.139e-02, 6.493e-03, 1.925e-02, -6.306e-03) * s0_2_0;
	r0 += M4(-4.016e-02, -3.574e-02, 8.974e-04, 4.319e-03, -9.350e-03, 4.734e-03, -6.455e-02, -9.546e-02, 3.710e-02, -1.051e-03, -5.462e-02, 6.518e-02, 8.670e-02, -4.548e-02, -5.918e-01, 1.432e-01) * s0_2_1;
	r0 += M4(2.316e-03, -1.466e-02, -9.226e-03, -1.570e-02, 2.743e-03, 1.230e-03, -1.084e-03, -9.783e-03, -8.812e-03, -6.144e-03, 6.925e-03, -5.774e-02, -5.707e-04, -6.470e-02, 8.674e-03, -1.456e-02) * s0_2_2;
	r0 += V4(9.114e-10, 2.263e-11, 1.001e-09, 2.503e-11);
	r0 = r0;
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
