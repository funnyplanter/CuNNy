// CuNNy 3x12 (dp4a)
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


//!DESC CuNNy-3x12-in
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
	r0 += V4(-2.641e-02, -1.353e-01, 7.065e-01, -9.857e-03) * s0_0_0;
	r1 += V4(-6.666e-02, 1.384e-02, 1.474e-01, -8.756e-03) * s0_0_0;
	r2 += V4(7.809e-02, -1.218e-01, 1.166e-05, 7.255e-03) * s0_0_0;
	r0 += V4(1.539e-01, -1.179e-01, 3.238e-01, 2.648e-02) * s0_0_1;
	r1 += V4(1.668e-02, -1.265e-01, -2.529e-01, 5.193e-03) * s0_0_1;
	r2 += V4(-7.264e-01, -2.781e-01, -1.027e+00, -6.373e-03) * s0_0_1;
	r0 += V4(1.788e-01, -4.406e-02, -6.757e-03, -1.946e-02) * s0_0_2;
	r1 += V4(7.242e-02, -4.132e-02, 1.386e-01, -5.778e-03) * s0_0_2;
	r2 += V4(2.319e-01, -4.297e-03, -1.578e-04, -2.129e-03) * s0_0_2;
	r0 += V4(7.541e-02, -1.462e-01, -8.418e-01, -4.660e-02) * s0_1_0;
	r1 += V4(-2.823e-01, 1.356e-02, -1.899e-01, -6.786e-02) * s0_1_0;
	r2 += V4(-1.017e-01, 8.192e-01, -4.901e-05, 9.004e-01) * s0_1_0;
	r0 += V4(-9.538e-02, 6.085e-01, -1.672e-01, 5.200e-01) * s0_1_1;
	r1 += V4(-6.286e-01, 5.082e-01, 3.993e-01, 7.897e-02) * s0_1_1;
	r2 += V4(3.916e-02, -4.170e-01, 1.021e+00, -8.981e-01) * s0_1_1;
	r0 += V4(-3.745e-01, 3.717e-02, 2.154e-02, -1.021e-01) * s0_1_2;
	r1 += V4(-1.147e-01, -1.484e-01, 4.427e-03, -1.072e-02) * s0_1_2;
	r2 += V4(4.756e-01, -2.165e-02, 1.131e-04, -1.458e-03) * s0_1_2;
	r0 += V4(-1.255e-02, -9.723e-02, 1.863e-02, 2.364e-02) * s0_2_0;
	r1 += V4(3.193e-01, -2.688e-02, 5.510e-02, -9.130e-01) * s0_2_0;
	r2 += V4(1.113e-02, 5.091e-02, 4.554e-06, 3.799e-03) * s0_2_0;
	r0 += V4(-1.282e-02, -1.740e-02, -4.465e-02, -3.184e-01) * s0_2_1;
	r1 += V4(6.382e-01, -1.888e-02, -4.642e-02, 9.160e-01) * s0_2_1;
	r2 += V4(4.519e-02, 4.140e-02, 5.868e-05, -5.348e-03) * s0_2_1;
	r0 += V4(6.345e-03, -7.274e-03, -1.071e-02, 3.236e-02) * s0_2_2;
	r1 += V4(3.943e-02, -1.360e-03, -2.384e-02, 5.356e-03) * s0_2_2;
	r2 += V4(-5.239e-02, -5.589e-02, 3.031e-06, 8.610e-04) * s0_2_2;
	r0 += V4(1.092e-01, 4.188e-03, 4.987e-03, -4.346e-04);
	r0 = clamp(r0, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(1.910e-02, 8.148e-03, 4.262e-02, 6.877e-03);
	r1 = clamp(r1, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(1.221e-03, 2.740e-02, -3.096e-05, 7.607e-04);
	r2 = clamp(r2, V4(0.0), V4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-3x12-conv1
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
	r0 = D(r0, s0_0_0, 0x9700F616, 0x66E3DA7F, 0xF1FDFE1B, 0x1D05FEFA);
	r1 = D(r1, s0_0_0, 0xDB0B25F0, 0xA8152DC6, 0xF9EDF601, 0x2BFF13FD);
	r2 = D(r2, s0_0_0, 0xF2F2513E, 0x12F6D905, 0x17FA2013, 0x02060AE6);
	r0 = D(r0, s0_0_1, 0xDADC02E2, 0xE6941AE4, 0x03FD1314, 0xD5060408);
	r1 = D(r1, s0_0_1, 0x07FCCD08, 0x24031305, 0xDB061C1A, 0xF70FCBDB);
	r2 = D(r2, s0_0_1, 0xB71EEF08, 0xEEF316F0, 0xD8F90FF3, 0xF010FB14);
	r0 = D(r0, s0_0_2, 0x242EF605, 0xCC812621, 0x06FE01F5, 0xFAFE0E02);
	r1 = D(r1, s0_0_2, 0x1D00E004, 0xF61DEA12, 0x22F90005, 0x1B09ED17);
	r2 = D(r2, s0_0_2, 0x16F00A00, 0xE6191009, 0x0F05EE0C, 0x04FE0601);
	r0 = D(r0, s0_1_0, 0xEAFEEC75, 0x72D011D6, 0xE203F0D0, 0x1BF75101);
	r1 = D(r1, s0_1_0, 0xF616D930, 0x7F08D217, 0xFCFEE8FC, 0xF80633FC);
	r2 = D(r2, s0_1_0, 0xF41969BF, 0x13E9DF03, 0x110BD6D2, 0xE70513F7);
	r0 = D(r0, s0_1_1, 0x723417D1, 0x231781C3, 0x2618F804, 0xE5FBE208);
	r1 = D(r1, s0_1_1, 0xCE0D15DF, 0xC827D235, 0x172CC2EE, 0xEDF6050B);
	r2 = D(r2, s0_1_1, 0x20281101, 0x14F86133, 0xE703E2F6, 0xE705F803);
	r0 = D(r0, s0_1_2, 0xF31014FB, 0x841217EB, 0xFFFC15F3, 0x0C0BDD04);
	r1 = D(r1, s0_1_2, 0x1AF558F8, 0x1001CDDE, 0x27E826F9, 0x04EA02FE);
	r2 = D(r2, s0_1_2, 0x09E1D6FC, 0xC624E4F0, 0x1BDD0712, 0x0B15FEF1);
	r0 = D(r0, s0_2_0, 0x28DEE6E2, 0xCB152F2D, 0x12011700, 0xEFED0108);
	r1 = D(r1, s0_2_0, 0xFA16D80F, 0xE2FEBDE8, 0x15102FD6, 0x0709FAF9);
	r2 = D(r2, s0_2_0, 0xFC071516, 0xCDF92EE0, 0xF005EF07, 0x0DFF070F);
	r0 = D(r0, s0_2_1, 0x27F3170F, 0xD2D6DCD3, 0xFA4EED1C, 0x18FEDBEF);
	r1 = D(r1, s0_2_1, 0x21BC03D9, 0x4BB11EF1, 0xDA281F2D, 0xEF0CFB1E);
	r2 = D(r2, s0_2_1, 0x1607D11D, 0x253E913E, 0x1AF9010C, 0x0311E90A);
	r0 = D(r0, s0_2_2, 0xE0E3C1EE, 0x35454002, 0x030CFEFD, 0x06150B03);
	r1 = D(r1, s0_2_2, 0x03813E0B, 0xF6F01814, 0x0EF7DEFA, 0xFDFC0D02);
	r2 = D(r2, s0_2_2, 0x1CF1CCE9, 0x2DC118EB, 0x0706F002, 0x19EBF4F1);
	r0 = D(r0, s1_0_0, 0x07DC13DC, 0x180F2627, 0x00131D1A, 0xE3E9E8E7);
	r1 = D(r1, s1_0_0, 0x11011404, 0xF50700F9, 0x130D2C24, 0xEF0B02FC);
	r2 = D(r2, s1_0_0, 0xB3EF22ED, 0x0BFB2603, 0x040E13EE, 0xF40A0E01);
	r0 = D(r0, s1_0_1, 0x81F7332E, 0x917E2E81, 0x27080DF4, 0x81FD0F1E);
	r1 = D(r1, s1_0_1, 0xF2D92813, 0xD53C09FD, 0x0D09BAEA, 0x2E160112);
	r2 = D(r2, s1_0_1, 0x94061619, 0xDBF41CC7, 0x0E236905, 0x050D220D);
	r0 = D(r0, s1_0_2, 0xEFF5DC11, 0xF3F8CA9B, 0x0F0AF6F9, 0x0708FCF4);
	r1 = D(r1, s1_0_2, 0xE5F7C60C, 0xFFF0011A, 0xD8080CDF, 0x0CFDFFF2);
	r2 = D(r2, s1_0_2, 0x7F22F6E2, 0xCE04DE47, 0xEDFF07F9, 0x390A09E7);
	r0 = D(r0, s1_1_0, 0x149AD618, 0xEA1402EB, 0xF6FA200D, 0xFD441BFA);
	r1 = D(r1, s1_1_0, 0xF7E832E0, 0x16E336F4, 0xEB7FB50F, 0xF91FE010);
	r2 = D(r2, s1_1_0, 0xF81C0D26, 0x09D91E28, 0x00F93208, 0xFB0A0909);
	r0 = D(r0, s1_1_1, 0x09D622D8, 0xF9D3B199, 0xE720F5CF, 0x18BCCD36);
	r1 = D(r1, s1_1_1, 0x1D0CEA0C, 0x25DEBBDD, 0xCB813B56, 0xF90F09FD);
	r2 = D(r2, s1_1_1, 0xFADCE21A, 0x051F1C81, 0xF1DE9CDE, 0x0CE6E8F6);
	r0 = D(r0, s1_1_2, 0xFC274A43, 0xE213C61F, 0x1E0108F9, 0x03091AFE);
	r1 = D(r1, s1_1_2, 0xD7EC1A13, 0x06FE0805, 0x250EE2C3, 0x0AE0D7DB);
	r2 = D(r2, s1_1_2, 0x00D21F00, 0x51E41817, 0x1B00DBCC, 0x411C0E0F);
	r0 = D(r0, s1_2_0, 0x0406BAF4, 0xF70FEE13, 0x0719C802, 0x031C3B05);
	r1 = D(r1, s1_2_0, 0x06EA0000, 0x0A09040F, 0xFE02FEF3, 0xFC02F7FE);
	r2 = D(r2, s1_2_0, 0xFFF8D40D, 0xFB19E008, 0x0306E706, 0x01FFE001);
	r0 = D(r0, s1_2_1, 0x033C16FE, 0x0DEA2E06, 0xF59CEFFC, 0x0007F0FA);
	r1 = D(r1, s1_2_1, 0xFC4023D9, 0x0B0706DC, 0xFFE50818, 0xFDE41E08);
	r2 = D(r2, s1_2_1, 0x050301F0, 0x21F9A326, 0x1306ECFD, 0xFDEB0DF0);
	r0 = D(r0, s1_2_2, 0xFF420D05, 0x06814B00, 0xF6030703, 0x02E3DD00);
	r1 = D(r1, s1_2_2, 0x0BFDBCF3, 0x100FEB05, 0x01F8030F, 0xFD0EFEFF);
	r2 = D(r2, s1_2_2, 0x0706FDFA, 0x152133CE, 0x0DF0100C, 0xFFDFE903);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x190501FC, 0xCB052A01, 0x01FB05FB, 0x01FE0304);
	r1 = D(r1, s0_0_0, 0x07EDF715, 0x1C11E304, 0xD6FB1EEF, 0xEAF80418);
	r2 = D(r2, s0_0_0, 0xDECE180D, 0x120F07EF, 0x02F5FB03, 0x03F1FC11);
	r0 = D(r0, s0_0_1, 0x4FDB280D, 0x81E8D9FB, 0xE9F512FE, 0xF5FA1AF8);
	r1 = D(r1, s0_0_1, 0x0C110408, 0x1FFCC400, 0xF4FE18FF, 0x0C07D51F);
	r2 = D(r2, s0_0_1, 0x8FEE3101, 0xF7EFF3F9, 0xEDE6060A, 0x0105F50F);
	r0 = D(r0, s0_0_2, 0xD9031EFC, 0xA3F83CF7, 0xF6FA13FC, 0xFDFDFEFE);
	r1 = D(r1, s0_0_2, 0x170CFEF2, 0xEE1AFFE1, 0xE8EF1BF7, 0x1909F20F);
	r2 = D(r2, s0_0_2, 0xF3FA1908, 0xF007FE0A, 0xFD000203, 0x0BFAFC00);
	r0 = D(r0, s0_1_0, 0x1A7BF290, 0xBF81DD17, 0x11FE0609, 0xE9DD2401);
	r1 = D(r1, s0_1_0, 0x0909F427, 0x1C0CC524, 0x05F2FBE0, 0x12A6F95B);
	r2 = D(r2, s0_1_0, 0xFD8127D9, 0xDE02100B, 0x1AF7E835, 0x0FF7F503);
	r0 = D(r0, s0_1_1, 0x7F91EBD2, 0x21812B43, 0x0E26D0FD, 0x79F12A0F);
	r1 = D(r1, s0_1_1, 0x2C10D5FF, 0x2623F6EA, 0xF43AE20A, 0x2149B3FF);
	r2 = D(r2, s0_1_1, 0x5EFDE8DD, 0xB8C2111C, 0x4C480A17, 0x1E17E006);
	r0 = D(r0, s0_1_2, 0xA5C528FC, 0x7F5EB019, 0xF201F5F9, 0x2A08EA04);
	r1 = D(r1, s0_1_2, 0x81D1E8F3, 0x812BF2EF, 0xF2090703, 0x18140A03);
	r2 = D(r2, s0_1_2, 0xE81B060F, 0x81F057ED, 0x700EBFFB, 0x0016F503);
	r0 = D(r0, s0_2_0, 0xF417FA0C, 0x171BE135, 0x0CEBFF1B, 0xFBFFF9C4);
	r1 = D(r1, s0_2_0, 0x1154FD08, 0x2D18EEC9, 0xF7BA0C10, 0x0BD4F029);
	r2 = D(r2, s0_2_0, 0xFFECF80A, 0xF4E20A4B, 0x1217E909, 0x01F8FEFE);
	r0 = D(r0, s0_2_1, 0xCDAA3329, 0x2C2EF3C5, 0x4B7FC9DD, 0xD9F1FDEE);
	r1 = D(r1, s0_2_1, 0xC8A9152E, 0xE88121AD, 0x407FC800, 0x0908FD03);
	r2 = D(r2, s0_2_1, 0x2D3BDF19, 0x7F81CDA8, 0x277FFA0C, 0x1F7FFAF0);
	r0 = D(r0, s0_2_2, 0xE4EF25F0, 0x02101111, 0xF00C1D02, 0xEC0E0000);
	r1 = D(r1, s0_2_2, 0x81B17FFB, 0x8181262B, 0x1D33DF03, 0xF90C050E);
	r2 = D(r2, s0_2_2, 0x3923D7FE, 0x8181D5F2, 0x1B2FDD0E, 0xF31119FB);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-6.420e-02, -9.667e-03, 1.158e-02, -2.135e-02);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-2.275e-03, 6.474e-02, -7.463e-03, 1.522e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-1.713e-02, -4.283e-02, 3.805e-02, 4.800e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-3x12-conv2
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
	r0 = D(r0, s0_0_0, 0x09F9F8FF, 0x0CFB0405, 0x01FA06FD, 0x19F00C07);
	r1 = D(r1, s0_0_0, 0xFB0FF403, 0xEF0B0C01, 0xFB00F209, 0x020DFAF1);
	r2 = D(r2, s0_0_0, 0x2528CDFC, 0x01F90300, 0xD3FB08FD, 0x03F8F706);
	r0 = D(r0, s0_0_1, 0xF5D91300, 0xF7DEF4F0, 0xFBDC03FC, 0x06C91104);
	r1 = D(r1, s0_0_1, 0x1614E807, 0x065CEFEF, 0xFC080111, 0x2172F5F4);
	r2 = D(r2, s0_0_1, 0x37EEEEF0, 0xFFF4FFFD, 0xBAA320CF, 0xFF121908);
	r0 = D(r0, s0_0_2, 0x00F00EFE, 0x12070BFA, 0xFCEEF9F1, 0x01D306FF);
	r1 = D(r1, s0_0_2, 0x00E7E702, 0x05FE0501, 0x121AF211, 0x240B0AFC);
	r2 = D(r2, s0_0_2, 0xFF20EB06, 0xFEEC0C03, 0xD3D911EE, 0x14FC1201);
	r0 = D(r0, s0_1_0, 0x09F10FF8, 0x06EC07F4, 0xFEFC06F9, 0x0A1A09ED);
	r1 = D(r1, s0_1_0, 0x0C0FDF07, 0xEE0C0A02, 0xFD05FF13, 0x010402FD);
	r2 = D(r2, s0_1_0, 0x1EECEBE7, 0x01FE08FB, 0x17423202, 0x00E1F7F0);
	r0 = D(r0, s0_1_1, 0x0227F6ED, 0xFC1B11F5, 0xF3FE24F0, 0x8116CA08);
	r1 = D(r1, s0_1_1, 0x13F920FB, 0x071210D7, 0xCE81E171, 0x0CE4D6E4);
	r2 = D(r2, s0_1_1, 0xF8FF1DCE, 0xFE1E0AF9, 0xF2EA7F17, 0x1781DED8);
	r0 = D(r0, s0_1_2, 0x0B0608F2, 0x0A0EFE1B, 0xFA0412EE, 0x970E1D0C);
	r1 = D(r1, s0_1_2, 0xF5F8F1FC, 0xD9EA0A04, 0x8107E72E, 0x0AF5CCFD);
	r2 = D(r2, s0_1_2, 0x2105D707, 0x3AFAF50F, 0xC8200D0D, 0x1CF52AEB);
	r0 = D(r0, s0_2_0, 0x020102F4, 0xF4FB1700, 0xF5010A05, 0xF7FD2AF1);
	r1 = D(r1, s0_2_0, 0x1604D7F4, 0xFD061A07, 0xF905E80B, 0x00FC0304);
	r2 = D(r2, s0_2_0, 0x0402F1F7, 0x0301FBFC, 0xFCF927E3, 0xE816C918);
	r0 = D(r0, s0_2_1, 0xF9FFFBE8, 0xEC0017E8, 0xFDFB0E1D, 0x080A4A04);
	r1 = D(r1, s0_2_1, 0x110515CD, 0x04FF060D, 0xFC05ED49, 0x0602E901);
	r2 = D(r2, s0_2_1, 0x06F9FD0A, 0x0103F801, 0x070815FE, 0x81DD22D7);
	r0 = D(r0, s0_2_2, 0x0306FFFA, 0x0BF71105, 0x05FB1515, 0x1CF92107);
	r1 = D(r1, s0_2_2, 0x0F03D10C, 0xF9FB0E04, 0xEAF02528, 0xFDF5FA03);
	r2 = D(r2, s0_2_2, 0x0DFBECF9, 0x0B05FA07, 0xFBFC1907, 0x11E11CDC);
	r0 = D(r0, s1_0_0, 0xF8FEFBFC, 0xF51A080A, 0xF601FB13, 0xEE01F916);
	r1 = D(r1, s1_0_0, 0xFE02FFEE, 0x0602F804, 0x0E040B14, 0x04060205);
	r2 = D(r2, s1_0_0, 0xF9FA02FC, 0xFF0B0005, 0x1BD80C47, 0xFC060700);
	r0 = D(r0, s1_0_1, 0xF608F8EB, 0x0AF3F510, 0xEE0FFE11, 0x02FF1D15);
	r1 = D(r1, s1_0_1, 0xFFD5F7DD, 0x1417F817, 0x1AF50C14, 0x0EFBF324);
	r2 = D(r2, s1_0_1, 0xECF5EFD0, 0xFD14F7F7, 0x24C3FED8, 0xF903F7F3);
	r0 = D(r0, s1_0_2, 0xF406FD01, 0xF7F5FDDE, 0x061CFE12, 0x03171307);
	r1 = D(r1, s1_0_2, 0xFAF305FC, 0x10F90513, 0x110104F7, 0x0FF802FC);
	r2 = D(r2, s1_0_2, 0xECF306D0, 0xF604FD08, 0xF50604F1, 0xFCF9F90B);
	r0 = D(r0, s1_1_0, 0xF606FA04, 0xF90B040B, 0xFAFFFD14, 0x06DF073F);
	r1 = D(r1, s1_1_0, 0x0213FCFB, 0x06F6FAEA, 0x080B180B, 0x040003F6);
	r2 = D(r2, s1_1_0, 0x0011FDDB, 0xFF060203, 0xD807F723, 0xEBFC082D);
	r0 = D(r0, s1_1_1, 0x27FCED07, 0x1BEA040E, 0x0FFF1234, 0x57BA231B);
	r1 = D(r1, s1_1_1, 0x00E9DDAE, 0xD3F7F3D8, 0xBB3B34CB, 0xE1F3040E);
	r2 = D(r2, s1_1_1, 0x4039F2EF, 0x0B00F1FE, 0x0F09F73B, 0xFF24EC4B);
	r0 = D(r0, s1_1_2, 0x060AFCFB, 0xF5E20FEE, 0xEBF4FDFD, 0xD70C22E9);
	r1 = D(r1, s1_1_2, 0x0D3116BD, 0xEEFCFD00, 0x2EE90900, 0x0C05FFF9);
	r2 = D(r2, s1_1_2, 0xFD25F4D9, 0xE30305FE, 0xD9D80A03, 0x0BF5EE11);
	r0 = D(r0, s1_2_0, 0xFFFF02FC, 0xF6F9FA00, 0x01F000FD, 0xECF30013);
	r1 = D(r1, s1_2_0, 0xFF1AF3E9, 0xF3FFFC0E, 0x1406050B, 0x0303FFF5);
	r2 = D(r2, s1_2_0, 0x07F301F3, 0x010302FE, 0x0EE5F614, 0xFC0421D5);
	r0 = D(r0, s1_2_1, 0x0FFAFCFF, 0xFDDFFC00, 0x00FE0706, 0xE9FFF600);
	r1 = D(r1, s1_2_1, 0x1D16E8F2, 0xF0FEFD0A, 0xF21F0109, 0x02FFFFF7);
	r2 = D(r2, s1_2_1, 0xE2030200, 0x08F6040B, 0xF6E8FC05, 0x12232CAF);
	r0 = D(r0, s1_2_2, 0x00FD020D, 0xFF13FC00, 0x08FD0200, 0xC929FD1B);
	r1 = D(r1, s1_2_2, 0xD4FBF8F6, 0x020304F7, 0x09080106, 0x060300F7);
	r2 = D(r2, s1_2_2, 0xFDF2FCE9, 0xF203040A, 0xF616070A, 0xFA1A10FD);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x13FC0004, 0x16ECFF03, 0x0B03FFFB, 0x100327FC);
	r1 = D(r1, s0_0_0, 0xF7011800, 0xF3F60905, 0xE0F4FD0E, 0xF7FC0EFC);
	r2 = D(r2, s0_0_0, 0x21E31AF2, 0xFDFE0201, 0xB8450DF7, 0x0AFD2207);
	r0 = D(r0, s0_0_1, 0x2D0F0305, 0xE61D09FA, 0x3409E605, 0xD3FBE708);
	r1 = D(r1, s0_0_1, 0x0EF61905, 0xEAF1F700, 0xD0D5F908, 0xF5E701E4);
	r2 = D(r2, s0_0_1, 0x110733ED, 0x230FE7F8, 0x2073910E, 0x2AE607FD);
	r0 = D(r0, s0_0_2, 0xFC04FD09, 0xF400FF02, 0x0B05F8FA, 0xE411FB13);
	r1 = D(r1, s0_0_2, 0xFBFC0D07, 0x0F00FEFD, 0xE3F8FCFF, 0x02E908F4);
	r2 = D(r2, s0_0_2, 0x11FC170D, 0x0D0801FC, 0xCFF3E31D, 0x01010F10);
	r0 = D(r0, s0_1_0, 0x18030504, 0x2703FE12, 0xFD0E0A01, 0x080821F1);
	r1 = D(r1, s0_1_0, 0xEE031DFD, 0xFE020DFA, 0xD8051105, 0xF7F806F9);
	r2 = D(r2, s0_1_0, 0x08E82DEC, 0xF70A0905, 0xAD210719, 0x210D3700);
	r0 = D(r0, s0_1_1, 0xF6FE00DC, 0xD7F70AD9, 0xBAE309FD, 0x8181192F);
	r1 = D(r1, s0_1_1, 0x4517EBF3, 0xBE54FD17, 0x4FACEB3C, 0x38130CF9);
	r2 = D(r2, s0_1_1, 0xF3D02F06, 0xDB09FEF4, 0xF0DDF30E, 0xF80290D0);
	r0 = D(r0, s0_1_2, 0x00EEF9F9, 0x1503F505, 0xEE1B0DF8, 0x145F0818);
	r1 = D(r1, s0_1_2, 0xF8BD1B1C, 0x0516FBF1, 0x17100017, 0xFDEF080E);
	r2 = D(r2, s0_1_2, 0xF1FC17E8, 0x07FFFCF9, 0x0321F115, 0x0E1C20FE);
	r0 = D(r0, s0_2_0, 0x05000200, 0x0402010F, 0x0507F7FE, 0xFD0A25FF);
	r1 = D(r1, s0_2_0, 0xF7EC14F5, 0xFAF9FE09, 0xF808FC00, 0xFBFF0102);
	r2 = D(r2, s0_2_0, 0x01FB0414, 0xFCFC02FD, 0x071A0C03, 0xDF12F322);
	r0 = D(r0, s0_2_1, 0x0C0602F4, 0x0F13F90A, 0x17ECFD0E, 0x04EDFD27);
	r1 = D(r1, s0_2_1, 0xE3F715F2, 0xF6FEF80E, 0xE9EE0810, 0xF806FD0A);
	r2 = D(r2, s0_2_1, 0x05EC0CF7, 0x0C0303FA, 0x18F7EF06, 0xCCA70D14);
	r0 = D(r0, s0_2_2, 0x02000400, 0xFBF2FD05, 0xFDF40209, 0xE5FA0AFA);
	r1 = D(r1, s0_2_2, 0x110923F0, 0xF7FAFA06, 0xF0150AFF, 0x08F60302);
	r2 = D(r2, s0_2_2, 0x0F040EF7, 0xFE0103FF, 0xFAF3F809, 0xDF072420);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-4.629e-03, -1.643e-02, -3.388e-03, 9.694e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.930e-02, 7.681e-03, 8.343e-03, -4.187e-03);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-3.027e-02, 7.263e-03, 1.989e-02, -1.865e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-3x12-conv3
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
	r0 = D(r0, s0_0_0, 0x090301FE, 0x11FE0000, 0x10FFFFFF, 0x07F901FC);
	r1 = D(r1, s0_0_0, 0xFAEAF814, 0xF9FA0501, 0x01060203, 0xDA0C24EC);
	r2 = D(r2, s0_0_0, 0xFF0610F9, 0xF80C01FA, 0x07FAFD03, 0x16FDFF01);
	r0 = D(r0, s0_0_1, 0xCFF9F603, 0xD30200F7, 0x07EEF810, 0xF20D01EE);
	r1 = D(r1, s0_0_1, 0x10020D07, 0x0DFE0B1B, 0x040206F3, 0x09071F1E);
	r2 = D(r2, s0_0_1, 0x06FC0106, 0x8107FFF1, 0xFE040812, 0xFBF1F912);
	r0 = D(r0, s0_0_2, 0x0708FB01, 0xF605FBFC, 0x0C02FE01, 0xF7FDF8F3);
	r1 = D(r1, s0_0_2, 0xCE0716F7, 0x0301FEF9, 0xFAFF0202, 0xEE0907F8);
	r2 = D(r2, s0_0_2, 0xDA0811FF, 0xFF090202, 0x0703FDFA, 0x1104F900);
	r0 = D(r0, s0_1_0, 0xE4EE07F5, 0xF5FC08FD, 0x00F008FB, 0xFBF10600);
	r1 = D(r1, s0_1_0, 0xD9E704E9, 0xBEF10FF1, 0x080406FE, 0x81C6F61E);
	r2 = D(r2, s0_1_0, 0x03FA0900, 0xFE0AF90B, 0xD4EDE9F8, 0xE7F914EE);
	r0 = D(r0, s0_1_1, 0xC9D3ED57, 0xD5C2D421, 0xD4E6F5F4, 0xF2FCEB13);
	r1 = D(r1, s0_1_1, 0x991FEE03, 0xC315FEEE, 0xF1EA24E7, 0x0CFCF6FC);
	r2 = D(r2, s0_1_1, 0xE1D8EBE8, 0xEA31FC2B, 0xD7FB322D, 0xC5D4F324);
	r0 = D(r0, s0_1_2, 0x0F081C10, 0xE7071B1F, 0xDDF11016, 0xFB06030C);
	r1 = D(r1, s0_1_2, 0x18E6E80B, 0x1C010409, 0xDEFE110A, 0xEB0D0AFE);
	r2 = D(r2, s0_1_2, 0xDD183508, 0x000E0202, 0x090207F9, 0x02011C0F);
	r0 = D(r0, s0_2_0, 0x0413FCFD, 0x061006FC, 0x030006FE, 0x0107FB03);
	r1 = D(r1, s0_2_0, 0x05150FFA, 0xFD0F0FF7, 0x05FE0003, 0xEADA26FC);
	r2 = D(r2, s0_2_0, 0x04FC1609, 0x0104FDFC, 0x00F6F30A, 0xFBFEF9FE);
	r0 = D(r0, s0_2_1, 0x0141FBF5, 0xFC43F5F8, 0xE32BDD03, 0xFF0202FC);
	r1 = D(r1, s0_2_1, 0xC3D71000, 0xE0F30800, 0xFD1B08EC, 0x20E402FD);
	r2 = D(r2, s0_2_1, 0xECC61B10, 0x04F9FEF7, 0x02170D03, 0xE838F70C);
	r0 = D(r0, s0_2_2, 0x0408FAFD, 0x0509FDFB, 0x050A07FF, 0x0104F7FB);
	r1 = D(r1, s0_2_2, 0x0EFE06F9, 0x05FEFD02, 0x01F30305, 0xF60E04F8);
	r2 = D(r2, s0_2_2, 0x04F623F7, 0xFF02FCFB, 0xFF0300FC, 0x0A00FFFC);
	r0 = D(r0, s1_0_0, 0x0202FB1D, 0x01FDFA06, 0x05FFFC05, 0xFA02F907);
	r1 = D(r1, s1_0_0, 0x10FAF319, 0x0802F915, 0x00FF0302, 0x0DDAFFF9);
	r2 = D(r2, s1_0_0, 0xFD0501F5, 0xF90004FB, 0x01010203, 0x03FEFE01);
	r0 = D(r0, s1_0_1, 0xFF0402FD, 0x0302FB26, 0x07F6F7F6, 0xF5F20127);
	r1 = D(r1, s1_0_1, 0x05DFEAE8, 0x0BE0E9F9, 0x0000F80D, 0xF5FCFF21);
	r2 = D(r2, s1_0_1, 0xF8E40A38, 0xF7020D18, 0x0100FEFE, 0x04FDFAF5);
	r0 = D(r0, s1_0_2, 0xFFFC00FF, 0xFE0205F3, 0x00FD05FA, 0xF6030C02);
	r1 = D(r1, s1_0_2, 0xFB090510, 0x04FAF909, 0xFDFF0CEE, 0x0203FDF6);
	r2 = D(r2, s1_0_2, 0x0500FAF5, 0xF8FF0C06, 0xFFFFF800, 0x00FB01FE);
	r0 = D(r0, s1_1_0, 0x00060FE7, 0x03FE04EF, 0x09FB05EE, 0x08FE0FF9);
	r1 = D(r1, s1_1_0, 0xF70A23EB, 0xFB130EEB, 0x01FD04FD, 0x18BFF4FD);
	r2 = D(r2, s1_1_0, 0x0BD5F7F1, 0x0003FEFB, 0x0B0D0308, 0x04030DF7);
	r0 = D(r0, s1_1_1, 0x34862302, 0x218846F4, 0x07816423, 0x3B062EE2);
	r1 = D(r1, s1_1_1, 0xFED4DA1C, 0x21E3F017, 0xFDEAFFF1, 0xDFD50C09);
	r2 = D(r2, s1_1_1, 0xE9BB1B35, 0x17F300ED, 0xFCD919FA, 0x0F88550E);
	r0 = D(r0, s1_1_2, 0xF7FC06FF, 0x0400F9FF, 0x00011002, 0x13FF04FA);
	r1 = D(r1, s1_1_2, 0x06F00013, 0xF7E2090F, 0x0608EC0C, 0x04FFF9EE);
	r2 = D(r2, s1_1_2, 0x0F02DBDF, 0xFF02F2F4, 0xFE010106, 0xFC000901);
	r0 = D(r0, s1_2_0, 0xFBFEFEFD, 0xFCFFFFFD, 0x000001FA, 0x000100FE);
	r1 = D(r1, s1_2_0, 0xEEF90503, 0xEAFF06FF, 0x0401FEFC, 0x1FF5ED02);
	r2 = D(r2, s1_2_0, 0xFCFBF1FE, 0xF5000001, 0x0A03FCFB, 0x040501FA);
	r0 = D(r0, s1_2_1, 0xF5FB0300, 0xF5FAFBFC, 0x1A06F9F9, 0xF10304FF);
	r1 = D(r1, s1_2_1, 0x1CFFF507, 0x1404E700, 0xF4FD05FC, 0xF20806F9);
	r2 = D(r2, s1_2_1, 0x13E2110A, 0xF60105FF, 0xFC01FDFB, 0x1905F3FC);
	r0 = D(r0, s1_2_2, 0xFD00F5FB, 0xFBFDFC00, 0x0502FA02, 0xFB000500);
	r1 = D(r1, s1_2_2, 0xF6FEFF08, 0x06040002, 0x03FDF503, 0xFD05FD02);
	r2 = D(r2, s1_2_2, 0xF701EEF7, 0x0100FBFF, 0x0301FF01, 0xFEFF0100);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xE00209F9, 0x0C0105FF, 0x02000003, 0xF302F903);
	r1 = D(r1, s0_0_0, 0xCC03F602, 0xEBFEFD01, 0x0AFFF2FE, 0x81FEFEF8);
	r2 = D(r2, s0_0_0, 0x1CFFF500, 0xF9000605, 0xE700FFFB, 0xEC0102FC);
	r0 = D(r0, s0_0_1, 0xE3FEEF06, 0xE0FEFDF8, 0xD10001F6, 0xB3010703);
	r1 = D(r1, s0_0_1, 0xB5030FEF, 0x04FCF9FA, 0xDDFB0CFC, 0xFEF3F9FB);
	r2 = D(r2, s0_0_1, 0xD7F50BF8, 0xCDFDF10A, 0xD4FFF7FC, 0xE700FEF8);
	r0 = D(r0, s0_0_2, 0xE40203FC, 0xEDFFFF05, 0xEC0205F8, 0xD50205F9);
	r1 = D(r1, s0_0_2, 0x040BF208, 0xFE0404FE, 0xE5FAFC07, 0x060AF108);
	r2 = D(r2, s0_0_2, 0xFB01EE0A, 0xF7FCFA07, 0xFF020101, 0xED0304FA);
	r0 = D(r0, s0_1_0, 0x0CF915FD, 0x0FFD1601, 0x10FB17FF, 0x0200FFF2);
	r1 = D(r1, s0_1_0, 0x0DF80205, 0x0F01F00F, 0x05FFF5FA, 0x0D0CF6B4);
	r2 = D(r2, s0_1_0, 0x0E0506F4, 0xFFFC0807, 0xF4FDF2F6, 0xF6FC14F7);
	r0 = D(r0, s0_1_1, 0xF2FE01CD, 0xEFEB2DCF, 0xC6EF24E7, 0x0FF7F7D8);
	r1 = D(r1, s0_1_1, 0xBFE4F21D, 0xECF00911, 0xFDF55103, 0xFBD7FF09);
	r2 = D(r2, s0_1_1, 0xFFE427BC, 0x0FFD13F1, 0xE7FAF709, 0xB6EEF702);
	r0 = D(r0, s0_1_2, 0x01EAFD0A, 0x08FCF400, 0xE0EFF11F, 0x0603FDF0);
	r1 = D(r1, s0_1_2, 0xE9E513E7, 0xF7D50AF5, 0x0603ED07, 0x060DFA08);
	r2 = D(r2, s0_1_2, 0xFE17EBE3, 0xFBF703F2, 0xFFF70003, 0xFAEEFB0F);
	r0 = D(r0, s0_2_0, 0xFBF905FC, 0xFBFB04F5, 0xFDFC01F6, 0x00FDFF00);
	r1 = D(r1, s0_2_0, 0xF7FB020F, 0xF0030418, 0x04FB0002, 0x111906DA);
	r2 = D(r2, s0_2_0, 0x100B03DD, 0xFE01FEFE, 0x04FEFFFB, 0x03F60105);
	r0 = D(r0, s0_2_1, 0x00FF0D0E, 0x00031115, 0x13FD0F04, 0xF9010113);
	r1 = D(r1, s0_2_1, 0x0CF4FAEF, 0x04F3F9F3, 0xFAFE0806, 0xFAE5071A);
	r2 = D(r2, s0_2_1, 0xF4F0ED0B, 0xFAFE0105, 0xFFF6F1F6, 0x0F0C03E4);
	r0 = D(r0, s0_2_2, 0xF9F40201, 0xF8EF0400, 0x03FB02E0, 0xFCFB050B);
	r1 = D(r1, s0_2_2, 0x02F303FA, 0x04F006FE, 0xFDFE01F6, 0x0805FC01);
	r2 = D(r2, s0_2_2, 0x0BFFF3FA, 0xFE02040B, 0xFDFD0001, 0xFBEF02F5);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.480e-02, -1.361e-02, -1.395e-02, -4.197e-03);
	f0 = clamp(f0, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.376e-02, -1.053e-02, -2.970e-03, -2.017e-02);
	f1 = clamp(f1, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-7.744e-03, -1.578e-03, -3.582e-03, -1.247e-02);
	f2 = clamp(f2, vec4(0.0), vec4(1.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-3x12-out-shuffle
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
	r0 += M4(1.593e-02, -3.245e-03, -3.872e-04, 3.656e-04, 1.034e-03, 8.552e-03, -4.032e-03, -5.639e-04, 7.180e-04, -4.587e-03, -8.155e-05, 1.349e-03, 1.948e-03, -3.059e-07, 1.438e-05, -5.482e-04) * s0_0_0;
	r0 += M4(6.027e-02, 2.924e-02, -1.889e-03, -6.615e-04, 4.220e-02, 5.991e-02, 7.107e-04, -7.632e-03, -2.068e-02, -2.284e-02, -7.936e-03, 1.019e-02, -2.326e-03, 2.260e-04, -3.116e-04, 8.042e-04) * s0_0_1;
	r0 += M4(3.844e-03, -8.335e-03, -1.616e-04, 1.956e-03, -1.029e-03, 1.882e-02, -6.277e-05, -2.152e-03, 7.073e-04, -1.728e-03, -3.118e-04, 2.291e-03, 6.352e-05, 1.353e-03, 4.077e-05, -2.523e-04) * s0_0_2;
	r0 += M4(4.675e-02, -4.204e-03, 4.267e-02, -1.437e-03, -1.177e-02, 3.082e-03, 1.740e-02, 3.699e-03, -4.783e-02, 6.295e-05, -8.260e-02, 1.427e-03, -6.421e-02, -1.158e-02, 1.189e-02, -5.909e-03) * s0_1_0;
	r0 += M4(-5.676e-01, 1.514e-01, 1.969e-01, 1.528e-01, 1.440e-01, -5.605e-01, 1.587e-01, 1.958e-01, 1.304e-01, 1.947e-01, 1.792e-01, -5.068e-01, -1.551e-01, -1.999e-01, -2.285e-02, -1.574e-04) * s0_1_1;
	r0 += M4(1.246e-02, -6.049e-02, -3.863e-03, -2.977e-02, -4.157e-03, 4.674e-02, 2.763e-03, 4.998e-02, 1.176e-03, 3.347e-02, -5.633e-03, 6.274e-02, -6.638e-03, -5.079e-03, 1.485e-03, 5.322e-03) * s0_1_2;
	r0 += M4(8.840e-03, -7.321e-07, -5.537e-03, -2.882e-04, -4.047e-03, 6.481e-03, -6.991e-03, -5.271e-03, -7.403e-04, -3.479e-03, -2.821e-03, 4.508e-03, -1.739e-03, 1.503e-04, 2.874e-02, 3.315e-03) * s0_2_0;
	r0 += M4(6.406e-03, -9.414e-03, -1.467e-02, -8.839e-03, 6.823e-03, 1.073e-02, -5.937e-02, -8.013e-02, -2.482e-03, -1.800e-03, 3.405e-02, 5.579e-02, 3.408e-03, 1.326e-02, 1.645e-01, 1.589e-01) * s0_2_1;
	r0 += M4(2.298e-03, -7.398e-03, -6.371e-03, 7.148e-04, -8.667e-04, 1.653e-02, -5.142e-03, -1.560e-02, 2.835e-04, -4.195e-03, -3.635e-03, 1.193e-02, 2.700e-03, -9.886e-03, 1.048e-03, 3.746e-02) * s0_2_2;
	r0 += M4(4.192e-03, -1.288e-02, 1.228e-02, -1.678e-02, 9.219e-04, 6.182e-03, 1.093e-02, 7.623e-03, -6.166e-03, 5.725e-03, -8.776e-03, 4.639e-03, -5.412e-04, -1.592e-06, -1.861e-05, 2.041e-07) * s1_0_0;
	r0 += M4(-2.485e-02, -4.776e-02, 6.192e-02, -2.267e-03, -2.805e-02, -5.237e-02, 1.418e-03, -1.299e-03, -1.381e-03, 4.529e-02, 6.237e-04, -1.855e-03, 4.843e-03, -3.478e-03, 1.760e-03, -3.145e-03) * s1_0_1;
	r0 += M4(2.435e-02, 6.907e-02, 3.089e-03, 2.135e-02, 5.066e-03, -1.893e-03, -3.004e-05, 2.999e-03, -2.475e-06, 1.219e-03, 1.102e-05, 1.072e-03, -2.398e-02, 4.670e-02, 9.588e-03, -1.206e-03) * s1_0_2;
	r0 += M4(-7.446e-02, -3.719e-02, 1.617e-02, -3.071e-02, 9.634e-02, 1.584e-02, 5.793e-02, 2.339e-02, -1.978e-01, -1.690e-02, -1.478e-01, -2.130e-02, -3.221e-04, 2.517e-06, 1.654e-04, 5.009e-07) * s1_1_0;
	r0 += M4(2.414e-01, 6.537e-02, -2.509e-01, 2.783e-01, -1.734e-01, 1.130e-01, -1.753e-01, -1.257e-01, 9.793e-03, 1.449e-01, 8.277e-03, 1.662e-01, 2.999e-02, -1.754e-02, 6.306e-03, -1.435e-02) * s1_1_1;
	r0 += M4(2.622e-02, -7.165e-02, 4.455e-02, -3.605e-02, -1.253e-03, -7.250e-02, 4.435e-03, -3.666e-02, 3.006e-06, -1.177e-03, -8.035e-04, -1.095e-03, -2.998e-01, 2.666e-01, -2.172e-01, 2.095e-01) * s1_1_2;
	r0 += M4(-8.149e-03, -2.372e-03, -2.577e-02, -1.002e-02, -1.431e-03, 1.655e-03, 2.423e-02, 2.532e-03, -3.756e-03, 2.015e-03, -4.406e-02, 7.720e-03, -5.653e-04, -2.575e-07, -1.367e-03, -6.225e-07) * s1_2_0;
	r0 += M4(-2.752e-02, -2.103e-02, 1.768e-02, -7.933e-02, 1.884e-02, 4.601e-03, 7.733e-02, 1.135e-01, -5.251e-03, 1.177e-02, -4.428e-03, 3.529e-02, -8.819e-03, -1.533e-03, 1.414e-02, -1.181e-02) * s1_2_1;
	r0 += M4(-1.063e-02, -1.531e-02, 3.227e-02, -1.179e-02, 9.778e-03, 1.886e-03, 1.642e-02, -3.511e-03, 5.497e-08, -1.120e-06, 8.155e-04, 1.974e-05, -3.217e-02, -3.809e-03, -1.448e-01, 1.280e-01) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 += M4(5.472e-03, 1.083e-02, -7.282e-03, 6.687e-03, -1.564e-04, 1.016e-04, 4.660e-06, 1.682e-07, -3.052e-03, 5.045e-05, -2.326e-04, -8.066e-07, -1.787e-02, -2.352e-03, 7.507e-03, -9.897e-04) * s0_0_0;
	r0 += M4(7.978e-02, -1.373e-01, -1.483e-03, 8.567e-03, 1.388e-04, -2.379e-04, -1.239e-05, -1.400e-07, 4.944e-02, 5.957e-03, 1.678e-02, 1.543e-03, -6.658e-02, -5.275e-02, 1.215e-02, 5.445e-03) * s0_0_1;
	r0 += M4(1.189e-04, 2.622e-02, 1.178e-03, 3.108e-03, 7.479e-06, -3.700e-07, 7.922e-06, -8.231e-08, -3.084e-03, -4.733e-02, -3.809e-03, -4.289e-03, -5.036e-03, 6.534e-04, 1.492e-03, -3.273e-03) * s0_0_2;
	r0 += M4(1.296e-03, 1.338e-02, 8.207e-03, 9.185e-03, 3.454e-02, -1.862e-03, -1.319e-02, 3.568e-05, 3.776e-03, -5.479e-05, -3.541e-04, 7.041e-07, 3.625e-02, 3.979e-03, 4.820e-02, -2.458e-03) * s0_1_0;
	r0 += M4(1.609e-01, -1.662e-01, 1.978e-01, -3.603e-01, 1.714e-01, 1.948e-01, 1.701e-02, 1.629e-03, 1.665e-01, -1.167e-03, 1.694e-01, 8.379e-03, 2.378e-01, 1.606e-01, -6.106e-01, 1.636e-01) * s0_1_1;
	r0 += M4(-3.608e-03, 1.729e-02, -3.308e-03, 3.151e-02, 1.637e-03, 2.148e-02, -2.689e-04, 2.216e-03, -6.674e-03, -1.550e-01, -2.543e-02, -1.946e-01, 3.394e-03, 3.884e-02, 1.926e-02, -1.409e-02) * s0_1_2;
	r0 += M4(-1.170e-02, 2.713e-03, -1.086e-02, 8.731e-03, 1.029e-02, -7.281e-04, -2.656e-02, -8.012e-03, -7.604e-07, 4.256e-06, 9.739e-04, 7.109e-08, -9.409e-05, 7.868e-04, 1.715e-02, 1.401e-03) * s0_2_0;
	r0 += M4(-8.557e-03, -9.916e-03, 4.210e-02, 1.842e-02, -1.752e-02, -2.020e-02, -1.870e-01, -1.707e-01, 3.237e-03, 9.598e-05, 3.471e-02, -4.579e-03, -1.025e-02, 5.725e-03, 3.364e-02, 3.009e-02) * s0_2_1;
	r0 += M4(-3.995e-04, -2.271e-04, 1.437e-03, 1.181e-02, 1.515e-03, 1.367e-02, -1.460e-02, -4.963e-02, 8.288e-05, -1.418e-02, 1.837e-02, -1.910e-02, -1.840e-03, -1.969e-03, 9.175e-03, 4.356e-03) * s0_2_2;
	r0 += V4(-5.847e-13, -1.039e-08, 1.513e-08, 1.619e-10);
	r0 = r0;
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
