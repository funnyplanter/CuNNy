// CuNNy 4x12 DS (dp4a)
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


//!DESC CuNNy-4x12-DS-in
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
	r0 += V4(7.213e-02, 1.733e-02, -3.150e-02, 7.941e-02) * s0_0_0;
	r1 += V4(-8.719e-02, -5.164e-02, -9.595e-03, -7.228e-01) * s0_0_0;
	r2 += V4(-5.824e-02, 8.887e-01, -1.939e-01, 5.263e-01) * s0_0_0;
	r0 += V4(-1.067e-01, -7.984e-02, 7.952e-03, -5.510e-02) * s0_0_1;
	r1 += V4(-2.899e-01, -2.258e-01, -2.293e-02, -1.225e-01) * s0_0_1;
	r2 += V4(5.098e-01, 4.531e-02, -2.709e-01, 2.784e-01) * s0_0_1;
	r0 += V4(4.817e-03, 3.208e-02, 3.013e-02, -5.709e-03) * s0_0_2;
	r1 += V4(2.968e-02, -3.136e-03, 3.592e-03, -7.651e-03) * s0_0_2;
	r2 += V4(3.897e-02, 2.448e-02, -6.043e-02, 3.701e-02) * s0_0_2;
	r0 += V4(9.402e-01, -3.262e-02, 8.933e-02, 9.899e-01) * s0_1_0;
	r1 += V4(-8.804e-02, -7.544e-02, -2.538e-02, -3.894e-02) * s0_1_0;
	r2 += V4(-3.278e-02, -9.047e-01, -1.428e-01, -1.920e-02) * s0_1_0;
	r0 += V4(-8.417e-01, 3.517e-02, -5.337e-01, -9.473e-01) * s0_1_1;
	r1 += V4(-5.215e-01, -6.740e-01, 4.098e-01, 8.845e-01) * s0_1_1;
	r2 += V4(-4.230e-01, -1.704e-02, 7.559e-01, -7.090e-01) * s0_1_1;
	r0 += V4(-4.984e-02, -9.923e-02, 4.385e-01, -6.385e-02) * s0_1_2;
	r1 += V4(-1.509e-01, -1.208e-01, -1.174e-01, 5.624e-03) * s0_1_2;
	r2 += V4(-2.278e-02, -2.569e-02, -6.774e-03, -1.139e-01) * s0_1_2;
	r0 += V4(7.169e-02, 1.340e+00, -1.159e-01, 8.696e-02) * s0_2_0;
	r1 += V4(1.578e-01, 1.618e-01, 1.798e-02, 3.642e-03) * s0_2_0;
	r2 += V4(1.420e-02, 8.781e-03, -2.179e-02, -3.206e-02) * s0_2_0;
	r0 += V4(-1.150e-01, -7.690e-02, -4.444e-01, -1.325e-01) * s0_2_1;
	r1 += V4(8.634e-01, 8.553e-01, -1.158e-01, 1.544e-03) * s0_2_1;
	r2 += V4(-5.076e-03, -2.967e-02, 2.064e-02, -4.888e-02) * s0_2_1;
	r0 += V4(2.359e-02, 5.222e-02, 5.680e-01, 5.186e-02) * s0_2_2;
	r1 += V4(8.462e-02, 1.323e-01, 8.534e-02, -8.340e-04) * s0_2_2;
	r2 += V4(-1.776e-02, 7.646e-03, -1.835e-02, 8.228e-02) * s0_2_2;
	r0 += V4(1.752e-02, -1.156e+00, -2.883e-03, -2.400e-02);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(1.910e-02, -1.065e-02, 1.682e-02, 1.024e-02);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(3.166e-02, -4.865e-03, 1.062e-02, 1.609e-02);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-4x12-DS-conv1
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
	r0 = D(r0, s0_0_0, 0xCDF9F739, 0xFF07F906, 0xF219DEF8, 0xEDFE0107);
	r1 = D(r1, s0_0_0, 0x1DEADC99, 0xEEC4F414, 0x34B560E2, 0x4BFA0DBD);
	r2 = D(r2, s0_0_0, 0xDF46F52B, 0x100703F6, 0xEF33FB10, 0x0D07FFF2);
	r0 = D(r0, s0_0_1, 0xE436F712, 0xFE0C0C03, 0x08F0FAEB, 0x2511E4EB);
	r1 = D(r1, s0_0_1, 0x3CEC1B13, 0x1619C3FF, 0xB4FBCE19, 0xD316812E);
	r2 = D(r2, s0_0_1, 0x81AA4107, 0x080A00F9, 0x22F2F7E9, 0x1905EBE5);
	r0 = D(r0, s0_0_2, 0xFEAF7FC9, 0x01FFF3FF, 0x0CFFF603, 0x0BFD81C5);
	r1 = D(r1, s0_0_2, 0x4E1D6EDF, 0x0A0AA1F2, 0x32F981AD, 0xF01D811B);
	r2 = D(r2, s0_0_2, 0x110467BC, 0x00020F05, 0xE8060623, 0x0C0D1B0E);
	r0 = D(r0, s0_1_0, 0x2E17FFDD, 0xFEF4F406, 0x17FE1ADE, 0x26C7D8D9);
	r1 = D(r1, s0_1_0, 0xD1AE1F13, 0x03E2160A, 0x81A0047F, 0xC481DD56);
	r2 = D(r2, s0_1_0, 0xAD0DB64C, 0x03F1FB0F, 0x1D47FADA, 0x0309FA01);
	r0 = D(r0, s0_1_1, 0x7EAB02AB, 0x22EDF918, 0x7ECE2A8C, 0x2A504981);
	r1 = D(r1, s0_1_1, 0x9FD1D36B, 0x2A3DE6C9, 0xA2092A7F, 0x81817F41);
	r2 = D(r2, s0_1_1, 0xCFECF147, 0x00090638, 0x7FD3FD92, 0xE208FA25);
	r0 = D(r0, s0_1_2, 0x7FF4A981, 0x0B030806, 0xE6ED242F, 0x811103CF);
	r1 = D(r1, s0_1_2, 0xBAD92751, 0x810A0DDD, 0x91F2077F, 0x3FD78181);
	r2 = D(r2, s0_1_2, 0xCBFC4B4A, 0x0503F1F4, 0x3A0200B9, 0xD016167F);
	r0 = D(r0, s0_2_0, 0xF20C1211, 0xF404F619, 0xF6EBF713, 0xFD0EE7F5);
	r1 = D(r1, s0_2_0, 0x8104E201, 0x06F5F0FD, 0x21E5E6E0, 0x3B061CD8);
	r2 = D(r2, s0_2_0, 0x42FA00C7, 0x0C07F1FF, 0xFB050610, 0x0CFCF5F2);
	r0 = D(r0, s0_2_1, 0xAC1AF348, 0x0907FA16, 0xF3E5C7FD, 0x22E7FC06);
	r1 = D(r1, s0_2_1, 0xDF0417F6, 0xFAFAED18, 0xEBF90C3E, 0x0E2EF2FF);
	r2 = D(r2, s0_2_1, 0x35E426B5, 0x31040EC6, 0xFAFDF201, 0x1403F9E3);
	r0 = D(r0, s0_2_2, 0xFF070512, 0x0B060EEE, 0x6AFF0181, 0x4D0745C8);
	r1 = D(r1, s0_2_2, 0x421FB39C, 0x25FDF6D5, 0x1C010DED, 0x1F0FDAF7);
	r2 = D(r2, s0_2_2, 0x400903AD, 0xEA060535, 0xEE050122, 0xF1FC050E);
	r0 = D(r0, s1_0_0, 0xE6DFF013, 0xFF1003FA, 0xF10426DC, 0x01C821FE);
	r1 = D(r1, s1_0_0, 0xFFF0E12C, 0x088135D9, 0x0BD7B34D, 0x20EBED0B);
	r2 = D(r2, s1_0_0, 0x0FEEFBE5, 0x06F7EE17, 0x01FEF7F6, 0x03F2F502);
	r0 = D(r0, s1_0_1, 0xE21E7DA4, 0x0116F013, 0xF9FBCE3B, 0xE50E8149);
	r1 = D(r1, s1_0_1, 0x18122339, 0xEC88817F, 0xFAC1EC22, 0x39D1D481);
	r2 = D(r2, s1_0_1, 0xF25CF30B, 0x0D0E1EE5, 0xFB281001, 0x08ADF609);
	r0 = D(r0, s1_0_2, 0xE17F7F91, 0x05FD12EB, 0x0E1C09F5, 0xE82E0AF3);
	r1 = D(r1, s1_0_2, 0x0D035E8C, 0xF4E60EE5, 0xF6E01AE4, 0xFEDFA47F);
	r2 = D(r2, s1_0_2, 0x0AFC0AFD, 0x00F2EF11, 0x051102F8, 0xEE0AD527);
	r0 = D(r0, s1_1_0, 0x0BA7E232, 0xF513FC0B, 0x06ECFF06, 0xE7FAB243);
	r1 = D(r1, s1_1_0, 0xCF0EDC1F, 0x01F3CB3C, 0x00589B3B, 0x1D158127);
	r2 = D(r2, s1_1_0, 0x000105FC, 0x02F9F713, 0x088233C4, 0xFF040901);
	r0 = D(r0, s1_1_1, 0xEEAD30AF, 0x04D30622, 0x0FC1957F, 0xA30C1C09);
	r1 = D(r1, s1_1_1, 0x1A129038, 0x810D3ECD, 0xD1E2F50C, 0x8116817F);
	r2 = D(r2, s1_1_1, 0x48E99738, 0xF24231B2, 0x0A58EE09, 0xF16AF207);
	r0 = D(r0, s1_1_2, 0xEB453A9A, 0x00F803F7, 0x33FCFEE8, 0x0DB9F43D);
	r1 = D(r1, s1_1_2, 0x22E153B1, 0xDE21F115, 0x081A28E4, 0xC1250481);
	r2 = D(r2, s1_1_2, 0xA6042DDB, 0xF8EFFC13, 0x160EF102, 0xFDD223D7);
	r0 = D(r0, s1_2_0, 0x1AF2D435, 0xF9F30302, 0x0A1C10F0, 0xF0E915FC);
	r1 = D(r1, s1_2_0, 0xECFB8132, 0x02F2FC06, 0x140CBC37, 0xFF1B63A2);
	r2 = D(r2, s1_2_0, 0x0810EC14, 0xF906FCFD, 0xFCED10F0, 0x040B13F0);
	r0 = D(r0, s1_2_1, 0xDE1009F0, 0x2907E71C, 0x0F118169, 0x1A081ADD);
	r1 = D(r1, s1_2_1, 0x2F0DBD36, 0xF9232CE4, 0x50201BED, 0x26E6C73E);
	r2 = D(r2, s1_2_1, 0xF1C8F815, 0x03EB51C5, 0xDE04E315, 0xFE08EA18);
	r0 = D(r0, s1_2_2, 0x3CE30FF4, 0x2EFF12F3, 0x4314E4FF, 0x08252BD5);
	r1 = D(r1, s1_2_2, 0x01F22BCF, 0xC006EE11, 0xF51111F1, 0x491B1EDA);
	r2 = D(r2, s1_2_2, 0x220820E0, 0xE5EBFB01, 0x3FEF0900, 0xF0FE0EEA);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x081EF4EB, 0xFD0202F5, 0x1936F81C, 0x101BF110);
	r1 = D(r1, s0_0_0, 0x32EB0424, 0x0B02FC14, 0x07B1F6D3, 0xE49E1ECC);
	r2 = D(r2, s0_0_0, 0x02F3F1DB, 0xFCE705F4, 0xFF1401FE, 0xF9F2030A);
	r0 = D(r0, s0_0_1, 0xF9700346, 0x02F906FC, 0x1FDFD0E5, 0x2404DCDF);
	r1 = D(r1, s0_0_1, 0xCEB0E1D0, 0xF23CF7E7, 0xCE433955, 0xCF2D3F06);
	r2 = D(r2, s0_0_1, 0xD00A0C41, 0xFEF60805, 0x15EFF2E0, 0xF6140417);
	r0 = D(r0, s0_0_2, 0xD6FCB2FB, 0x08FEFCFE, 0xF5F80906, 0xFF2E0C07);
	r1 = D(r1, s0_0_2, 0xF613332E, 0x24FF06EB, 0x040ADA02, 0xF5EE1D14);
	r2 = D(r2, s0_0_2, 0xF5F48117, 0xFF000302, 0xFDFE1105, 0x030AEDFD);
	r0 = D(r0, s0_1_0, 0xE1001D09, 0xFF26FE00, 0x1CDC03F7, 0x1032F4EE);
	r1 = D(r1, s0_1_0, 0x163F0C5B, 0xED1106F4, 0xCE2301F6, 0xFB0F14E3);
	r2 = D(r2, s0_1_0, 0x0BF8E296, 0xF8060100, 0xFDDDFCF8, 0x05020010);
	r0 = D(r0, s0_1_1, 0xFDA21D7F, 0xF2C5F700, 0xE1B2FAF1, 0x452CCC79);
	r1 = D(r1, s0_1_1, 0x00BB8681, 0x7F29052C, 0x11C641BE, 0x7F45E002);
	r2 = D(r2, s0_1_1, 0x248119F7, 0x051D07F3, 0xD51D1B03, 0x05F301D4);
	r0 = D(r0, s0_1_2, 0xA030DDCC, 0xF2162006, 0xF7FF2AE0, 0xF300CBE4);
	r1 = D(r1, s0_1_2, 0x5D0B003D, 0x021CD91F, 0xECFB3411, 0x342981CE);
	r2 = D(r2, s0_1_2, 0x5942E1D1, 0x04FAFE03, 0xE9050E11, 0x160115F5);
	r0 = D(r0, s0_2_0, 0xF1E104B4, 0xE70F08F2, 0x08EC011C, 0x06FF0417);
	r1 = D(r1, s0_2_0, 0x1D3AF312, 0x07FCFD0E, 0xFF0B1D81, 0xB7E9261D);
	r2 = D(r2, s0_2_0, 0xFB000F1A, 0xE72004EB, 0x0DF9F91A, 0x08F9FC01);
	r0 = D(r0, s0_2_1, 0x20221116, 0xE21918D3, 0xF75C0981, 0xB7F6BBD7);
	r1 = D(r1, s0_2_1, 0xA40DF3EB, 0xF433F7DC, 0xE5EE53C7, 0xB0D333EB);
	r2 = D(r2, s0_2_1, 0xF23A0A1E, 0x30DB257F, 0x0513F007, 0x090DF400);
	r0 = D(r0, s0_2_2, 0xE6F85FD0, 0x05FC19FE, 0xBA126422, 0xB9D7853C);
	r1 = D(r1, s0_2_2, 0xED2C252E, 0xF31D8105, 0xCC05232D, 0x0C1C8116);
	r2 = D(r2, s0_2_2, 0xF30AF31D, 0x3002EFDA, 0xFB0026F9, 0xFCFCF807);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(4.805e-03, 2.806e-02, 1.261e-02, 1.173e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-7.202e-02, 1.409e-02, -2.948e-02, 6.207e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-5.126e-02, 4.930e-03, 4.749e-02, -1.679e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-DS-conv2
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
	r0 = D(r0, s0_0_0, 0x0102F4F4, 0x040BECF8, 0x0609FAFB, 0xCE110AED);
	r1 = D(r1, s0_0_0, 0x051304F8, 0x01001329, 0x01EB2C0C, 0x0AF00318);
	r2 = D(r2, s0_0_0, 0x01070405, 0xED03F403, 0xEC24F2E7, 0xF603FF01);
	r0 = D(r0, s0_0_1, 0x13F6F510, 0xFBF50D01, 0xF6104409, 0x02C1FB12);
	r1 = D(r1, s0_0_1, 0xF91F1701, 0x14E31C19, 0x0601C8FA, 0xFC232C10);
	r2 = D(r2, s0_0_1, 0x040CE4FC, 0xCC2381E8, 0xF62CD8DB, 0xF8F8AEE8);
	r0 = D(r0, s0_0_2, 0x05F7F907, 0x04FA0302, 0x05F001FF, 0xE009050F);
	r1 = D(r1, s0_0_2, 0x00010103, 0x10ECD1FB, 0x0007F6FF, 0x0304F5FD);
	r2 = D(r2, s0_0_2, 0xFE050207, 0xEB2FE0FE, 0x0309F7E3, 0xF912E5F8);
	r0 = D(r0, s0_1_0, 0x18EB07DB, 0xF0ECD4F5, 0xFA04FFED, 0xDFFFF304);
	r1 = D(r1, s0_1_0, 0xFE0614FF, 0x0FDAE906, 0x23F30F1A, 0xF516E6FA);
	r2 = D(r2, s0_1_0, 0x13DFFD0A, 0xF8141510, 0xE51EEEE0, 0xFB05080C);
	r0 = D(r0, s0_1_1, 0x0E001506, 0xF1082803, 0xEF203DED, 0xED8105B5);
	r1 = D(r1, s0_1_1, 0xF0F1E9F6, 0xC50340FD, 0xEE1BD913, 0xF10E16FB);
	r2 = D(r2, s0_1_1, 0x0EE2F8FA, 0xD50D1D0D, 0x041B3BD3, 0x00FF1400);
	r0 = D(r0, s0_1_2, 0xFDFF0606, 0x07FD08FF, 0x0DF4F0F3, 0x28C81F00);
	r1 = D(r1, s0_1_2, 0xFEEB14FE, 0xEA17010B, 0x07FD0608, 0x05050EF5);
	r2 = D(r2, s0_1_2, 0xF8FEF200, 0xFA05150A, 0x1712D7E3, 0x05FCFE01);
	r0 = D(r0, s0_2_0, 0x16F10216, 0xF5FB0CFC, 0x08FD010F, 0xEC0C0317);
	r1 = D(r1, s0_2_0, 0xFC0107FC, 0xF4EF0603, 0x0603F314, 0x0508F513);
	r2 = D(r2, s0_2_0, 0x01FCFB02, 0x0507F903, 0x0406EEE8, 0x0400030F);
	r0 = D(r0, s0_2_1, 0x13FDF802, 0xFF07F9FE, 0x07FF0EFA, 0x15E31A0A);
	r1 = D(r1, s0_2_1, 0x0204F7F4, 0x00D604FA, 0xF9020806, 0xFC010F13);
	r2 = D(r2, s0_2_1, 0xF213EC0F, 0x07F20F0E, 0x09FEFFE4, 0x04FB0504);
	r0 = D(r0, s0_2_2, 0x0BEE1300, 0x04F70E00, 0xFCFF06F6, 0x07FB1C0B);
	r1 = D(r1, s0_2_2, 0xFE04EFFE, 0xEDF3FF2C, 0xF2FF0A0A, 0x000B01FF);
	r2 = D(r2, s0_2_2, 0x04FB0604, 0x06F8021A, 0xFC0D0AE7, 0x01FB040B);
	r0 = D(r0, s1_0_0, 0x0906FAFD, 0x18FBEE04, 0xFCF9EE03, 0x37F2E018);
	r1 = D(r1, s1_0_0, 0xFD04FA05, 0x060306FA, 0x03F91014, 0xFCF504FD);
	r2 = D(r2, s1_0_0, 0x070202FD, 0xFBFE04F3, 0x0EF1F4FA, 0x0F0206F2);
	r0 = D(r0, s1_0_1, 0x1306E5F9, 0x0E04F801, 0x0106EEF2, 0x2909E018);
	r1 = D(r1, s1_0_1, 0x090BF7F8, 0xF9FB1618, 0x03FFDE15, 0xF1FE02F9);
	r2 = D(r2, s1_0_1, 0xFA0A0503, 0x14FE81FD, 0x11F5F2FB, 0x21F7EB16);
	r0 = D(r0, s1_0_2, 0x12FFF30D, 0x14FA0205, 0x0F01F905, 0x3E03130F);
	r1 = D(r1, s1_0_2, 0x0205FE02, 0x01F8FEF9, 0x04FCF8FE, 0xF9FFF80B);
	r2 = D(r2, s1_0_2, 0xFB03FA02, 0x050F20F4, 0x1404EE03, 0x120D0BFF);
	r0 = D(r0, s1_1_0, 0x1B060602, 0x28061DFA, 0x00FD0A09, 0x6CF5ED28);
	r1 = D(r1, s1_1_0, 0x0209FD05, 0xEA00DE04, 0x0BF71E0B, 0xFFF8FE0C);
	r2 = D(r2, s1_1_0, 0xFD0106FA, 0x000804F1, 0x1BF6F3F9, 0x150BF303);
	r0 = D(r0, s1_1_1, 0x2A245804, 0x32090C08, 0x3C0DCEFE, 0x73AADE29);
	r1 = D(r1, s1_1_1, 0x1A0BAC09, 0xFC15A30A, 0xFEFB851A, 0x06F6F2FD);
	r2 = D(r2, s1_1_1, 0x060AF107, 0xEBFADC2D, 0x23D146E7, 0x24F00D1E);
	r0 = D(r0, s1_1_2, 0x26F50B11, 0x16EBFA0A, 0x0AF3FA06, 0x3394BC1A);
	r1 = D(r1, s1_1_2, 0xF9010003, 0xF6212622, 0xF8E6DD05, 0xF7DCEB15);
	r2 = D(r2, s1_1_2, 0x0A17FF01, 0xFA03EBF9, 0x0CE905FB, 0x09FAFEF6);
	r0 = D(r0, s1_2_0, 0x18FFEFFC, 0x22030500, 0x0BFCFB01, 0x5C16EADC);
	r1 = D(r1, s1_2_0, 0x06FFFBFF, 0xFC01E7E7, 0x0BFA0E08, 0xF8FBF4F4);
	r2 = D(r2, s1_2_0, 0x09000702, 0xF20313F1, 0x0BF8F1FA, 0x0F0000FB);
	r0 = D(r0, s1_2_1, 0x19FFFD03, 0x1F02F50B, 0x1A04FA08, 0x7701F212);
	r1 = D(r1, s1_2_1, 0x031106F3, 0xC1F1FC04, 0xFF050AF5, 0x09F9E2F1);
	r2 = D(r2, s1_2_1, 0xFF130EFD, 0x02E307FC, 0x14E30FE7, 0x17F6FAFF);
	r0 = D(r0, s1_2_2, 0x10F8F0FC, 0x13F3F9FD, 0x14F809F9, 0x44B7E921);
	r1 = D(r1, s1_2_2, 0xFDFB06F7, 0xEC042308, 0xF3FB070C, 0x05EEF5FF);
	r2 = D(r2, s1_2_2, 0x01F1F7F9, 0x03FBF4F4, 0x05EEF2E6, 0x14FDFE05);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x03FC0DF6, 0xF90115FD, 0xFFFB05FA, 0xE20021FF);
	r1 = D(r1, s0_0_0, 0x0EFC0EFD, 0x13FBFC0F, 0x1FFED7FB, 0xF6030EFF);
	r2 = D(r2, s0_0_0, 0x0BFFF905, 0xE6FEFB09, 0xE7FF110C, 0x0CFE07FE);
	r0 = D(r0, s0_0_1, 0x07F61805, 0xF605FDF4, 0xF80CD9FB, 0x113F81FF);
	r1 = D(r1, s0_0_1, 0xF602F6FE, 0xFE09DE2B, 0xFEF6FD03, 0x01EEEC12);
	r2 = D(r2, s0_0_1, 0xF5EC0D08, 0xF1EC7FE4, 0xE9041B07, 0xF6156AF0);
	r0 = D(r0, s0_0_2, 0xF8F107F7, 0xFF02FBF9, 0x01EE0201, 0x0B0ABDEB);
	r1 = D(r1, s0_0_2, 0xF80CF8F3, 0xFC0AFD03, 0x0504E6FB, 0x03EA0315);
	r2 = D(r2, s0_0_2, 0x020503F9, 0x0414F3FD, 0x0BF9FF0D, 0x0826EDF4);
	r0 = D(r0, s0_1_0, 0x35060803, 0x36F81E09, 0x18FE0BFF, 0x81262800);
	r1 = D(r1, s0_1_0, 0xF00B0806, 0x091217F2, 0xC1F20011, 0xBCFE14FA);
	r2 = D(r2, s0_1_0, 0xFBFDF8F9, 0x2FF2F106, 0x24FB060D, 0xDB00F204);
	r0 = D(r0, s0_1_1, 0xD7E7EAFB, 0xF0811BE8, 0x0D13EDE3, 0x08D2F60C);
	r1 = D(r1, s0_1_1, 0x2249FFFF, 0x39FDB7D8, 0x60100D09, 0x05FB2B14);
	r2 = D(r2, s0_1_1, 0x1E4A7802, 0xF6F10139, 0xFA000321, 0x130BFD13);
	r0 = D(r0, s0_1_2, 0x0C09F8ED, 0x0304FAFB, 0x0A32F903, 0x1CDE0DDE);
	r1 = D(r1, s0_1_2, 0xFDEE18EB, 0xECDE19FD, 0x0203020A, 0xFCF20DF7);
	r2 = D(r2, s0_1_2, 0xFE1BF7F9, 0x0C1B011A, 0x0E3DE821, 0x071A020B);
	r0 = D(r0, s0_2_0, 0x01FF0AF7, 0x04030800, 0xFC000712, 0xC3F10415);
	r1 = D(r1, s0_2_0, 0x0B0BFDEE, 0xCEFEFEF0, 0x00FEFA1C, 0xD1F60410);
	r2 = D(r2, s0_2_0, 0xBDFBF40A, 0x06FAF307, 0x04FB061A, 0x0402FD06);
	r0 = D(r0, s0_2_1, 0xFBF30800, 0xF706FF00, 0x18FB08ED, 0x08061B2E);
	r1 = D(r1, s0_2_1, 0xF010EFF7, 0x07F4090C, 0x0FE70312, 0x0FD60A22);
	r2 = D(r2, s0_2_1, 0xBFDEFCE6, 0xF30C0B0A, 0x26FB0B1D, 0xEFF00B00);
	r0 = D(r0, s0_2_2, 0x01EC050D, 0x00000508, 0x07100306, 0xFBD71308);
	r1 = D(r1, s0_2_2, 0xF402FCEB, 0x0BFDF2EF, 0x0710FD07, 0x00030A09);
	r2 = D(r2, s0_2_2, 0x080CFCED, 0x07F0F819, 0x05F70A18, 0x03050010);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(6.578e-03, 2.212e-02, -1.035e-02, 2.020e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.911e-02, -1.805e-02, 2.739e-03, 7.450e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-1.128e-02, -2.384e-02, -4.026e-03, -7.107e-03);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-DS-conv3
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
	r0 = D(r0, s0_0_0, 0x0E05F5F8, 0xFC08FFFE, 0xFDFB0301, 0x10EDF90F);
	r1 = D(r1, s0_0_0, 0x06FBF9FC, 0xF7FD000F, 0xFBFE0BF2, 0xFCF604FD);
	r2 = D(r2, s0_0_0, 0xFFEA0911, 0x05F815E8, 0x09FC0210, 0x090BFE04);
	r0 = D(r0, s0_0_1, 0x1E0C04FC, 0xF9EE12F4, 0xD0F3F90C, 0x1CE9F301);
	r1 = D(r1, s0_0_1, 0x0D09FBF4, 0xF50BF605, 0xFBEB20F2, 0xFCF403DF);
	r2 = D(r2, s0_0_1, 0xF404F50A, 0x1DF106EC, 0x0E32E117, 0x0805FD03);
	r0 = D(r0, s0_0_2, 0x0AFE15F9, 0xFBFE0BFC, 0xECF1F708, 0x14FAFAFD);
	r1 = D(r1, s0_0_2, 0x01070905, 0x09F50307, 0xFD04FBFF, 0xFF04F60B);
	r2 = D(r2, s0_0_2, 0x010016F9, 0x0BE90CFC, 0x0302F406, 0x0302FE03);
	r0 = D(r0, s0_1_0, 0x15EE0100, 0x060308EE, 0x010DF7F4, 0x1A00F10C);
	r1 = D(r1, s0_1_0, 0xFB140009, 0xF3F8FEED, 0xFE030BF6, 0xF121FC04);
	r2 = D(r2, s0_1_0, 0xF413F50C, 0x110501F6, 0x080BEA28, 0x16E5040F);
	r0 = D(r0, s0_1_1, 0x1B930CD4, 0xFF073FC5, 0xED1317D4, 0x1FC4D3DD);
	r1 = D(r1, s0_1_1, 0xFEF22ABA, 0xE4DD2409, 0x001B29F8, 0x002926A2);
	r2 = D(r2, s0_1_1, 0x063E1794, 0x04D32CF3, 0x13319930, 0x04090E12);
	r0 = D(r0, s0_1_2, 0x20FED908, 0xFB0B0F0C, 0xEF1B06FD, 0x1F08C202);
	r1 = D(r1, s0_1_2, 0x050AEBFD, 0x0CFDC509, 0xFE021304, 0xFFF8EEEE);
	r2 = D(r2, s0_1_2, 0x02EF01F0, 0x1600C81F, 0x00F6E909, 0x0E10FC02);
	r0 = D(r0, s0_2_0, 0x060802FB, 0xFF07F9FC, 0x02F70304, 0x0AFFF907);
	r1 = D(r1, s0_2_0, 0xFAF1F7FD, 0xFE010CFE, 0xFF0101FB, 0x05F305F7);
	r2 = D(r2, s0_2_0, 0xFC0A0EE2, 0x03060004, 0x040EFE07, 0x0E14FA00);
	r0 = D(r0, s0_2_1, 0x0DFA10E7, 0xF70322D3, 0x09F1FDF9, 0x1BEDF7F1);
	r1 = D(r1, s0_2_1, 0xF30C0003, 0xFEEE0105, 0xF90BFC08, 0xF2FDF600);
	r2 = D(r2, s0_2_1, 0x090010D7, 0x19F0FF19, 0x0D10E601, 0x14001CF4);
	r0 = D(r0, s0_2_2, 0x0A080AF3, 0xF8FA1B05, 0x05F9F8FB, 0x0B0BF6F3);
	r1 = D(r1, s0_2_2, 0xF3FC110A, 0x05FB030D, 0xFF0908FD, 0xFFF713FD);
	r2 = D(r2, s0_2_2, 0x0A06FD04, 0x110BE6F6, 0x020608FE, 0x04080803);
	r0 = D(r0, s1_0_0, 0xEEF20DED, 0xFF0C06FB, 0xF70B0D0C, 0xF7FB0D02);
	r1 = D(r1, s1_0_0, 0xF9090002, 0x04120CFB, 0x0303FD01, 0x090D1F0A);
	r2 = D(r2, s1_0_0, 0x1601ED08, 0xF5FC080A, 0x0FF50AFE, 0xFAFD09F5);
	r0 = D(r0, s1_0_1, 0x0FF62CF7, 0x040702FD, 0xF0FF01F0, 0x14050E11);
	r1 = D(r1, s1_0_1, 0x1F0108E6, 0xDAF9E602, 0x1504F909, 0x081A1B0C);
	r2 = D(r2, s1_0_1, 0xF6F6D9FA, 0xF3E3051C, 0xE0E5FDEC, 0x0BFF10F3);
	r0 = D(r0, s1_0_2, 0xFDF6FAF1, 0xFB080401, 0xF306E2FA, 0xF8F202FD);
	r1 = D(r1, s1_0_2, 0x160107EA, 0xFCFB050B, 0x03FD0502, 0x070DFEF4);
	r2 = D(r2, s1_0_2, 0xEC00F30F, 0x03E9F10B, 0xF5F1FEF9, 0x04F20BFD);
	r0 = D(r0, s1_1_0, 0x0C1CFD05, 0xE910E7FE, 0x02E500F5, 0x041904F6);
	r1 = D(r1, s1_1_0, 0x0907FB02, 0xEE150CF6, 0x1025F60D, 0xE4DE14EF);
	r2 = D(r2, s1_1_0, 0xEAEE0DE3, 0xFEFD0100, 0xF4E41BF8, 0x1C14F601);
	r0 = D(r0, s1_1_1, 0x1F213032, 0xDDF93143, 0x15E21F37, 0x3B0E0562);
	r1 = D(r1, s1_1_1, 0x08BCFD36, 0x367F0C18, 0xE0C90AF0, 0xBF30ED11);
	r2 = D(r2, s1_1_1, 0x0F070BED, 0x3017F04C, 0xDE1DF3A9, 0x341A04F8);
	r0 = D(r0, s1_1_2, 0xE707FDF3, 0xF019ECED, 0x090F1AFD, 0xF5FF1613);
	r1 = D(r1, s1_1_2, 0xD906F5F7, 0x0AFB0913, 0xF309E9FC, 0x03F9180E);
	r2 = D(r2, s1_1_2, 0x2BEC1D04, 0x140C2B29, 0x15F624F0, 0xEFFE04EA);
	r0 = D(r0, s1_2_0, 0x070F0EF1, 0x0B05F9F6, 0x08FF1802, 0x0A0911F9);
	r1 = D(r1, s1_2_0, 0x090008F8, 0xFF1DFD0B, 0x01010006, 0xFE0AFCF5);
	r2 = D(r2, s1_2_0, 0xFFFEF60F, 0x03FF0A06, 0xEEFEF801, 0x0F09F81E);
	r0 = D(r0, s1_2_1, 0xEF040EEC, 0xF20A0D13, 0x0D0301EF, 0xF114FAF4);
	r1 = D(r1, s1_2_1, 0x0EFE10F0, 0xF706FAFF, 0xF7FD06FE, 0x01F507DC);
	r2 = D(r2, s1_2_1, 0x0619DC0E, 0xFD24FAFF, 0x0111F3ED, 0xFEF6F711);
	r0 = D(r0, s1_2_2, 0xF2020DFB, 0x040E04F7, 0xFB010D0A, 0xE204FC02);
	r1 = D(r1, s1_2_2, 0x0F010DFB, 0xF503FD0F, 0x05FE00FE, 0x08FF1BFE);
	r2 = D(r2, s1_2_2, 0xE90FEDEA, 0xD400E9F8, 0xF706FCEC, 0xEF0603F8);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xE80D170A, 0xFA0508F6, 0xFFF70801, 0xEB0808F5);
	r1 = D(r1, s0_0_0, 0xF9130AF4, 0xFFF100D2, 0xF81303FA, 0x00FB10F3);
	r2 = D(r2, s0_0_0, 0x08EAF3EE, 0x0BF30001, 0x16EDF318, 0x0104040D);
	r0 = D(r0, s0_0_1, 0xFCF90ACB, 0x06F1FEDD, 0xFFF60414, 0xF60802A5);
	r1 = D(r1, s0_0_1, 0xFBED02CD, 0xF80B0305, 0x08F9FD0F, 0xF9F305E9);
	r2 = D(r2, s0_0_1, 0xF913030C, 0xFC000118, 0x0105FD36, 0x0509FCE0);
	r0 = D(r0, s0_0_2, 0xF5030AEC, 0xFA0F0904, 0xFD0BF50B, 0xFAFA0BEE);
	r1 = D(r1, s0_0_2, 0xFCF80EFD, 0x0604F5E4, 0xFF030205, 0x02D90AE6);
	r2 = D(r2, s0_0_2, 0x030303F4, 0xFCFC0004, 0x0DF7ED05, 0x0702FB01);
	r0 = D(r0, s0_1_0, 0xEFEC06F0, 0x040BE7FB, 0xFCFA0CF6, 0xF2F710F1);
	r1 = D(r1, s0_1_0, 0x12C509E9, 0x1C1D0DF6, 0x03E702F8, 0x19F30AE5);
	r2 = D(r2, s0_1_0, 0x091C0F02, 0xEF01130A, 0xFF090117, 0xDEF90C16);
	r0 = D(r0, s0_1_1, 0x2F12ECE8, 0x2CE10414, 0xDA0B210F, 0x0600D2CE);
	r1 = D(r1, s0_1_1, 0x3AF01548, 0xD4FE070B, 0x08F5231E, 0x23D71F1A);
	r2 = D(r2, s0_1_1, 0xD4071E26, 0xED20DECE, 0xBA2CDF2D, 0x0D1003B8);
	r0 = D(r0, s0_1_2, 0xFD031116, 0xEC06090A, 0xE9F41D09, 0x20FC06E4);
	r1 = D(r1, s0_1_2, 0xEF070BF7, 0x1AFEFCE4, 0xFB05FE01, 0x22F4F3FB);
	r2 = D(r2, s0_1_2, 0x10000D08, 0x2200EBB9, 0x07F1F21A, 0xFCFC110B);
	r0 = D(r0, s0_2_0, 0x0D0006F9, 0xF8E8F6F8, 0x0FFBFBFB, 0xFEFA03F3);
	r1 = D(r1, s0_2_0, 0x18130409, 0x0D0100EF, 0x010909FF, 0x1F10FDFF);
	r2 = D(r2, s0_2_0, 0x14FF04FC, 0xF9F907FC, 0x0EF8F30E, 0xC2FB04F6);
	r0 = D(r0, s0_2_1, 0x0A141205, 0xED1C1D0A, 0xF0EA1902, 0xEDFD2009);
	r1 = D(r1, s0_2_1, 0xF9011702, 0xED06E700, 0xFC01FE03, 0x040204FC);
	r2 = D(r2, s0_2_1, 0xCDEF2603, 0xDCEE0303, 0xE1F9E11C, 0xBF002E01);
	r0 = D(r0, s0_2_2, 0xF9FE0402, 0xFEF9F5FE, 0xF0020906, 0xFB0311FF);
	r1 = D(r1, s0_2_2, 0x04F80BFE, 0x1209F1F9, 0xF8F50A04, 0x05FE0AFF);
	r2 = D(r2, s0_2_2, 0xE1091302, 0x06091409, 0xF80B0F13, 0xF20404FC);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-8.696e-03, -1.619e-02, 1.249e-03, 2.223e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(1.056e-03, -2.117e-02, -1.120e-02, -3.689e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-3.018e-02, -1.854e-03, 7.050e-03, -1.472e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-DS-conv4
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
	r0 = D(r0, s0_0_0, 0x0400FDF3, 0xE6000012, 0xF706040D, 0x0702FA03);
	r1 = D(r1, s0_0_0, 0x0402FD05, 0xF306F80B, 0xFEFE0003, 0xF9060903);
	r2 = D(r2, s0_0_0, 0xFCFC2DF5, 0xFF030000, 0xFBFE0700, 0xF3F30B00);
	r0 = D(r0, s0_0_1, 0xE7F00AEE, 0xD813FC00, 0xE119F329, 0x07010709);
	r1 = D(r1, s0_0_1, 0xD113F621, 0xF40DF917, 0x0406FEFD, 0xF707FD03);
	r2 = D(r2, s0_0_1, 0x00F60F02, 0x0001FBFA, 0x09FB09FB, 0xF2040CF2);
	r0 = D(r0, s0_0_2, 0x19E417F7, 0x0600F605, 0xFB010017, 0xFF03FD08);
	r1 = D(r1, s0_0_2, 0x0109EC11, 0xFD00F708, 0x0BF706FC, 0xFF01F9FF);
	r2 = D(r2, s0_0_2, 0x020201FD, 0xF902F7FD, 0x05010102, 0x0AF71303);
	r0 = D(r0, s0_1_0, 0xFAEA2AF4, 0xFE1AFCF9, 0xF8090210, 0xE10F0305);
	r1 = D(r1, s0_1_0, 0xFF0C0009, 0xF5310204, 0xFF05F709, 0xEF210810);
	r2 = D(r2, s0_1_0, 0x0B1038B9, 0x000909FC, 0xC915181A, 0xEEFC0D03);
	r0 = D(r0, s0_1_1, 0xE7252C12, 0xE50EF400, 0xF91608EE, 0xF2F8DAC9);
	r1 = D(r1, s0_1_1, 0xDA550BE1, 0xD22E059F, 0xE9DD43EF, 0xF7F220E7);
	r2 = D(r2, s0_1_1, 0x01EAEBE4, 0x0B00F30D, 0xCAE3F7DD, 0xF6001601);
	r0 = D(r0, s0_1_2, 0x290941F0, 0x0702FFF7, 0xEF0FEBFF, 0x0503F8FD);
	r1 = D(r1, s0_1_2, 0x080804CC, 0x0EFFFCFC, 0xFFF91DEE, 0xFB0AFDF3);
	r2 = D(r2, s0_1_2, 0x06060601, 0xDE05F109, 0x0BFD14FF, 0x1CF724E0);
	r0 = D(r0, s0_2_0, 0x00E714E0, 0x04F903FB, 0x02F802FD, 0x0311FAF6);
	r1 = D(r1, s0_2_0, 0x02000201, 0x06F502FB, 0x02F30108, 0x03FEFB02);
	r2 = D(r2, s0_2_0, 0x01F80106, 0xFA0DFE01, 0xF6000406, 0x06FF00FF);
	r0 = D(r0, s0_2_1, 0x2D09438E, 0x02FD0201, 0xF018F211, 0x02390ED5);
	r1 = D(r1, s0_2_1, 0x05F2FBFC, 0x08FFFDF9, 0xFE070EEE, 0x0C2606E7);
	r2 = D(r2, s0_2_1, 0x01FF0005, 0xE416FD14, 0xFD0609DD, 0x03FA02E3);
	r0 = D(r0, s0_2_2, 0x81D6DBBB, 0x0501FE02, 0xFFEA04E8, 0x0C04FDF2);
	r1 = D(r1, s0_2_2, 0x07FFFDF7, 0xFFFEFFFD, 0x14020FD4, 0x0C0900F5);
	r2 = D(r2, s0_2_2, 0x05FF0300, 0xF5060206, 0x0AFD0109, 0x06FA07FC);
	r0 = D(r0, s1_0_0, 0xF2FB000C, 0x01F5020A, 0xF9FD0200, 0x0001FCFB);
	r1 = D(r1, s1_0_0, 0xFEFE00FF, 0x01F90702, 0x05FD0201, 0xFEFD0103);
	r2 = D(r2, s1_0_0, 0x01FAF706, 0x0502FDFE, 0xF9FAF605, 0xFDFF03FC);
	r0 = D(r0, s1_0_1, 0x0FF5FC09, 0x2205EE25, 0xFCE70C12, 0xF5FF00FC);
	r1 = D(r1, s1_0_1, 0x0BEF180B, 0xFEF70E12, 0x0B00FF00, 0x0908FDFF);
	r2 = D(r2, s1_0_1, 0x0507F6F4, 0x0813F8FB, 0x03FEFAF5, 0x17040806);
	r0 = D(r0, s1_0_2, 0x00FCF2F7, 0xF006F314, 0xEB03F40A, 0x0000FEFD);
	r1 = D(r1, s1_0_2, 0xEC08000B, 0xF8060901, 0xFFFA01F9, 0xFFFDFD00);
	r2 = D(r2, s1_0_2, 0x01FCFCF7, 0x0008FAFE, 0xFE02FD00, 0xF3F6FDFD);
	r0 = D(r0, s1_1_0, 0xE017F808, 0xF20BFDFA, 0x06F6FD01, 0xFF02FF03);
	r1 = D(r1, s1_1_0, 0x02FEFDFE, 0xE809F7FE, 0xFEFAFC01, 0xF8F1F8FD);
	r2 = D(r2, s1_1_0, 0x101DC904, 0x040DF9FB, 0xECEA0C07, 0xF5FCFBFF);
	r0 = D(r0, s1_1_1, 0x27F8F503, 0xED180AF7, 0x1434C610, 0x381BF31A);
	r1 = D(r1, s1_1_1, 0xDF34BEE2, 0x1427FFD2, 0xF81DD5FF, 0xF41DDF0C);
	r2 = D(r2, s1_1_1, 0x0009EDE4, 0x0E1FF5E2, 0x39230BE6, 0x2912C9E2);
	r0 = D(r0, s1_1_2, 0xCC0CFDEE, 0x0E00FFF8, 0x1D1BFE0E, 0xFC08FD04);
	r1 = D(r1, s1_1_2, 0x17F808F1, 0xFFF4EE07, 0x12E41605, 0x00FE05F5);
	r2 = D(r2, s1_1_2, 0xFC06F905, 0x0D1DF6F4, 0xF6FEF7F5, 0x02E1E717);
	r0 = D(r0, s1_2_0, 0xC707DFFA, 0x01FAFF02, 0x0104FFFC, 0xFBFBFDFC);
	r1 = D(r1, s1_2_0, 0xFD0004FF, 0x02FD04FE, 0x06FF07FE, 0x06F50CFE);
	r2 = D(r2, s1_2_0, 0xFEF90603, 0xFE07F9FD, 0x02F2FF05, 0x0807FEFC);
	r0 = D(r0, s1_2_1, 0x58D7931F, 0x06FCFA05, 0xEC0303FF, 0xE2FD07FF);
	r1 = D(r1, s1_2_1, 0x0CF10A02, 0xFDF1F80E, 0xED0DE3FD, 0x09F6FD0A);
	r2 = D(r2, s1_2_1, 0x0BFDF7F8, 0xFF17FCF8, 0x21160DE0, 0x070105F1);
	r0 = D(r0, s1_2_2, 0xC02524C1, 0xFD00F9FE, 0xE8ED0300, 0x01F2F403);
	r1 = D(r1, s1_2_2, 0xF8FFF706, 0x04010600, 0x21EA0CF8, 0xFDF5F304);
	r2 = D(r2, s1_2_2, 0xFEFEFE01, 0x0909FDFA, 0xF9FDEF06, 0x08F80202);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFBFDF907, 0xFFFFFF04, 0x0302FBFE, 0xFFFFF806);
	r1 = D(r1, s0_0_0, 0x02FEF304, 0xFFF7DE0A, 0xFDFEFFFD, 0x04FDF703);
	r2 = D(r2, s0_0_0, 0xFE00C704, 0xFC030003, 0x02F60102, 0x01FFFD07);
	r0 = D(r0, s0_0_1, 0x0A0E13F2, 0xF509F2FE, 0xF3EEEA1A, 0xFFF8F606);
	r1 = D(r1, s0_0_1, 0xFB06DDFD, 0xF411EBF0, 0x0107F4FB, 0x0506EBF5);
	r2 = D(r2, s0_0_1, 0x0500110A, 0x0816FD03, 0xFE08F601, 0xF410F60E);
	r0 = D(r0, s0_0_2, 0x0612FC05, 0xF903FEF9, 0xE9010300, 0x0200FF04);
	r1 = D(r1, s0_0_2, 0xF904F7FF, 0x0300FD05, 0xF8FE040E, 0x090002FD);
	r2 = D(r2, s0_0_2, 0xFEFCFFFA, 0x19060505, 0xFEFF04FE, 0xDFF71212);
	r0 = D(r0, s0_1_0, 0xEE230BF0, 0x0108F903, 0x0306F503, 0x000BF2F6);
	r1 = D(r1, s0_1_0, 0xFF010205, 0x010DEE07, 0x07F4F90F, 0x08FFF7FD);
	r2 = D(r2, s0_1_0, 0x06F1E2FE, 0xF8140406, 0x08FC08F5, 0xF90706FB);
	r0 = D(r0, s0_1_1, 0x0D18BB19, 0xFAF4FF1E, 0xF120CFF7, 0x0320E8FD);
	r1 = D(r1, s0_1_1, 0xFB09C933, 0xF9EAE63B, 0xFE20FBDF, 0x1110F71A);
	r2 = D(r2, s0_1_1, 0xF9EE000F, 0xD618FB05, 0x04F2CF35, 0xF715F33E);
	r0 = D(r0, s0_1_2, 0xD3F0B121, 0xFAFDF109, 0xF4FFF202, 0x03FDFE0A);
	r1 = D(r1, s0_1_2, 0xF8F3FB0E, 0xFBFFFFF9, 0xF0EC1127, 0x03FAFD0B);
	r2 = D(r2, s0_1_2, 0xFD02FEFC, 0xFF000E10, 0xFA000AF9, 0xF20719F4);
	r0 = D(r0, s0_2_0, 0x0A16F0F0, 0x00FD0301, 0xFCFE0603, 0x00F7080E);
	r1 = D(r1, s0_2_0, 0xFE02FF01, 0xFDFE0100, 0xFE00FDFD, 0xFFF80201);
	r2 = D(r2, s0_2_0, 0x0406F9FD, 0x00080905, 0xFF0AFDF1, 0x0100FD07);
	r0 = D(r0, s0_2_1, 0xE6B8E65F, 0x000004FC, 0xFFF8130A, 0x02ED0A17);
	r1 = D(r1, s0_2_1, 0x00FF0DF7, 0x05030AF3, 0x0206F20F, 0x10F707FF);
	r2 = D(r2, s0_2_1, 0xFFF8FE02, 0xF501110A, 0xFEEEEC15, 0xFFF9000F);
	r0 = D(r0, s0_2_2, 0xE1C08115, 0x020100FC, 0x03FD04F9, 0xFCFCFCFD);
	r1 = D(r1, s0_2_2, 0x0501FFF9, 0x02FF00FF, 0xF8F5FF02, 0x01FBFEF9);
	r2 = D(r2, s0_2_2, 0x00FF02FF, 0xFEFE0704, 0xFDFE01FA, 0xFA0204F6);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-2.040e-02, -1.480e-02, -1.592e-02, -1.825e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.581e-02, -1.523e-02, -1.309e-02, -1.260e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-1.799e-02, -9.665e-03, -1.202e-02, -1.983e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-DS-out-shuffle
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
	r0 += M4(2.388e-02, -2.179e-02, -1.495e-02, -1.356e-02, 5.239e-03, -2.309e-03, 7.517e-04, 9.522e-04, -2.581e-02, -5.443e-03, 8.823e-03, -3.491e-03, 2.703e-02, -2.640e-03, -9.476e-03, 5.470e-03) * s0_0_0;
	r0 += M4(-4.142e-02, 1.382e-01, -8.695e-03, 4.808e-02, 1.351e-03, 4.193e-03, -7.097e-03, -3.681e-03, -1.436e-02, -1.713e-02, 1.211e-02, 2.090e-02, 1.362e-01, 9.544e-02, 2.338e-02, -3.694e-03) * s0_0_1;
	r0 += M4(-2.989e-03, -2.343e-02, -4.827e-04, -1.972e-02, -9.735e-03, -5.032e-03, -3.987e-03, -6.905e-03, 8.789e-03, 4.511e-03, 7.229e-03, 8.087e-03, -1.911e-02, 3.528e-02, -1.214e-02, 2.181e-03) * s0_0_2;
	r0 += M4(1.270e-02, -1.064e-03, 6.812e-02, -1.000e-02, 1.484e-02, 1.731e-02, 6.290e-03, 3.235e-03, 6.860e-02, 9.856e-03, -1.395e-01, 3.042e-02, 2.633e-02, -2.918e-03, 7.205e-02, -9.850e-03) * s0_1_0;
	r0 += M4(-1.438e-02, -5.431e-04, -3.300e-02, 7.007e-02, -3.142e-01, -2.705e-01, -2.310e-02, -9.285e-03, 1.468e-01, 2.173e-01, -5.744e-02, -3.330e-01, 1.171e-01, 8.227e-02, -5.113e-01, -1.525e-01) * s0_1_1;
	r0 += M4(1.387e-03, -2.067e-03, -2.032e-03, -2.885e-03, 1.220e-02, -6.065e-02, -6.519e-03, -5.779e-03, 5.931e-03, 4.504e-02, -1.373e-03, 4.382e-02, -2.055e-02, -1.359e-02, 2.163e-02, -1.851e-01) * s0_1_2;
	r0 += M4(-2.418e-03, -2.180e-03, -2.329e-03, 2.661e-03, -7.243e-03, -7.124e-03, 7.299e-02, 6.392e-03, 6.362e-03, 3.663e-03, 4.165e-02, 3.493e-03, -6.592e-03, 1.473e-03, 3.676e-03, 1.119e-03) * s0_2_0;
	r0 += M4(-1.542e-03, -3.847e-04, -3.249e-04, -1.279e-03, 8.499e-02, 5.020e-02, 9.531e-02, 1.557e-01, -8.286e-04, 6.556e-03, 5.992e-02, 8.960e-02, -1.044e-02, -1.032e-02, 4.056e-02, 2.354e-02) * s0_2_1;
	r0 += M4(-7.458e-04, 1.362e-04, 7.283e-05, 1.277e-03, -9.639e-03, -1.936e-03, 3.132e-02, 6.958e-02, 1.119e-03, -3.076e-03, 9.122e-04, 2.042e-02, -6.981e-03, -1.187e-02, -6.684e-03, -7.752e-03) * s0_2_2;
	r0 += M4(2.814e-03, 3.148e-03, -1.132e-03, -6.398e-03, 1.439e-02, 2.829e-03, -2.626e-04, 5.178e-03, 8.911e-02, 6.704e-03, 3.282e-03, -7.610e-03, 4.977e-04, 4.986e-04, 2.492e-03, -4.189e-03) * s1_0_0;
	r0 += M4(-2.823e-02, 3.015e-02, 2.882e-03, -1.051e-02, 4.334e-02, -8.423e-03, -4.752e-03, 7.005e-03, 2.837e-02, -2.014e-01, -1.233e-02, 9.915e-03, 1.724e-01, 1.304e-01, 5.953e-03, 1.205e-02) * s1_0_1;
	r0 += M4(-2.935e-03, 1.517e-03, -6.146e-03, -4.596e-03, 5.094e-03, -1.761e-02, -4.354e-03, -5.804e-03, -3.110e-03, 1.074e-02, -3.243e-03, -4.863e-03, 3.929e-03, 5.750e-02, 7.298e-03, 1.157e-02) * s1_0_2;
	r0 += M4(6.277e-02, 1.277e-02, 7.593e-02, 9.044e-03, -2.377e-02, -2.143e-02, 1.635e-02, -1.530e-03, 7.029e-02, 4.014e-03, 1.431e-01, 1.862e-02, -5.418e-02, 1.065e-02, -2.371e-02, 3.166e-02) * s1_1_0;
	r0 += M4(1.483e-01, -5.953e-01, 1.826e-02, 3.266e-01, -5.438e-01, 2.192e-01, 1.694e-01, 1.648e-02, 4.286e-02, -1.889e-01, 7.104e-02, -4.457e-01, -1.159e-01, -1.840e-01, 2.338e-01, -3.845e-02) * s1_1_1;
	r0 += M4(-3.541e-03, 4.060e-05, 1.047e-02, -1.971e-02, -3.058e-02, 6.355e-02, -1.071e-03, 5.601e-03, -2.668e-03, 2.787e-02, -7.114e-04, 3.528e-02, 7.299e-03, 7.689e-02, -5.682e-03, 1.274e-01) * s1_1_2;
	r0 += M4(-1.342e-02, -7.935e-04, -3.368e-02, -5.183e-03, -3.825e-03, -2.990e-03, -5.412e-02, -5.920e-03, 5.003e-05, -5.121e-04, 7.959e-03, -3.997e-03, 5.189e-03, -1.387e-03, -1.053e-02, 1.819e-03) * s1_2_0;
	r0 += M4(-2.544e-02, 3.770e-02, -5.524e-03, 9.469e-02, -2.353e-02, -4.780e-02, 1.780e-01, -6.772e-02, 1.365e-03, -1.446e-05, 1.205e-02, 4.146e-02, 1.905e-02, 6.786e-03, -7.593e-02, -5.630e-02) * s1_2_1;
	r0 += M4(4.612e-03, 1.180e-02, -6.454e-03, -5.981e-03, 1.082e-03, -3.748e-02, -2.229e-02, -3.288e-02, -3.184e-03, 7.064e-04, -5.054e-03, 1.021e-02, 3.146e-04, 1.630e-02, 8.987e-03, 1.049e-02) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 += M4(-2.370e-04, -8.572e-04, -2.001e-03, 7.761e-04, 2.123e-02, 1.536e-02, 1.274e-02, -7.336e-03, 2.614e-03, -1.381e-03, -4.164e-03, -4.223e-03, 1.770e-02, 4.606e-04, 3.006e-03, 2.284e-03) * s0_0_0;
	r0 += M4(-3.455e-02, -6.941e-03, -1.279e-02, -4.495e-03, -6.119e-03, -2.816e-03, 4.406e-02, 4.285e-02, -1.856e-01, -9.240e-03, 2.836e-02, -2.436e-02, 3.072e-02, 3.407e-02, 1.014e-02, -6.580e-03) * s0_0_1;
	r0 += M4(-2.424e-02, -8.274e-03, 1.670e-02, -1.367e-03, 1.744e-02, 1.847e-02, -4.058e-03, 1.788e-02, 4.189e-04, 7.005e-02, -6.018e-04, -8.652e-03, 6.124e-04, -8.224e-03, 1.516e-04, 2.652e-03) * s0_0_2;
	r0 += M4(-5.683e-03, -9.489e-03, 3.950e-04, -6.793e-03, 8.911e-03, 5.503e-02, 1.017e-02, 5.414e-02, 7.029e-03, 2.001e-03, 3.845e-03, -5.365e-03, 8.470e-02, -3.136e-03, 6.568e-02, -2.159e-04) * s0_1_0;
	r0 += M4(-1.289e-01, 2.727e-02, -6.540e-02, -2.783e-03, -1.609e-01, -1.479e-01, -1.606e-01, -1.509e-01, -1.125e-01, 2.898e-02, -4.326e-01, 6.509e-02, -2.135e-01, 2.303e-01, -9.698e-02, 1.964e-01) * s0_1_1;
	r0 += M4(2.749e-01, -1.897e-01, 6.079e-02, -6.428e-02, 3.901e-02, -1.324e-02, 3.964e-02, -1.455e-02, 2.624e-03, 1.321e-01, 2.834e-03, 1.880e-01, 1.176e-02, -6.067e-02, 6.097e-03, -4.895e-02) * s0_1_2;
	r0 += M4(-2.229e-03, -4.046e-04, -4.468e-03, -4.846e-03, 8.917e-03, -1.339e-02, 1.825e-02, 1.288e-02, 6.357e-03, -1.097e-03, 8.546e-03, 1.583e-03, 8.010e-03, 4.861e-03, 4.602e-02, 3.677e-03) * s0_2_0;
	r0 += M4(-1.234e-02, -1.343e-02, -1.067e-01, -3.090e-03, 4.602e-02, 4.333e-02, -3.324e-03, -3.199e-03, -7.482e-03, -2.385e-03, 5.757e-02, -9.232e-03, 3.198e-02, 1.649e-02, -6.421e-02, 9.351e-02) * s0_2_1;
	r0 += M4(2.706e-02, 6.566e-02, 1.387e-01, -3.276e-02, -5.716e-03, 1.415e-02, 1.209e-02, 1.568e-02, -2.524e-03, -5.214e-03, -1.433e-03, 1.958e-02, 2.355e-03, -1.244e-02, 1.034e-02, -3.471e-02) * s0_2_2;
	r0 += V4(-2.068e-10, -4.688e-10, -2.061e-10, -2.685e-10);
	r0 = r0;
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
