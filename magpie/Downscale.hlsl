// lanczos2 with antiring, apply after upscaling
// Copyright (c) 2024 funnyplanter
// SPDX-License-Identifier: CC0-1.0

//!MAGPIE EFFECT
//!VERSION 4

//!PARAMETER
//!LABEL blur
//!DEFAULT 1.0
//!MIN 0.9
//!MAX 1.2
//!STEP 0.01
float blur;

//!TEXTURE
Texture2D INPUT;

//!TEXTURE
Texture2D OUTPUT;

//!SAMPLER
//!FILTER POINT
SamplerState S;

//!PASS 1
//!STYLE PS
//!IN INPUT
//!OUT OUTPUT
float lanczos(float x)
{
	float s = 1./blur, kx = 3.1415926535897932*s*x, wx = .5*kx;
	return x < 1e-5 ? 1. : sin(kx)*sin(wx)/(x*x);
}

#define K(x) lanczos(x)
#define D(x) (q4 = (x), q4*q4)
#define E(x) sqrt(x)

float4 Pass1(float2 p)
{
	float2 pt = GetInputPt(), sz = GetInputSize(),
		   pp = p*sz - .5, p0 = floor(pp), f = pp - p0, s = p0*pt;
	float4 wx = float4(K(1+f.x), K(0+f.x), K(1-f.x), K(2-f.x)),
	       wy = float4(K(1+f.y), K(0+f.y), K(1-f.y), K(2-f.y)), q4;
	wx /= dot(wx, 1);
	wy /= dot(wy, 1);
	float3 l[4][4], vmin = 1e6, vmax = -1e6, q3;
	#define L(x) (q3 = x, vmin = min(vmin, q3), vmax = max(vmax, q3), q3)
	for (int y = 0; y < 4; y += 2) {
		for (int x = 0; x < 4; x += 2) {
			float2 t = s + float2(x, y)*pt;
			float4 r = D(INPUT.GatherRed(S, t)),
				   g = D(INPUT.GatherGreen(S, t)),
				   b = D(INPUT.GatherBlue(S, t));
			l[y+0][x+0] = L(float3(r.w, g.w, b.w));
			l[y+0][x+1] = L(float3(r.z, g.z, b.z));
			l[y+1][x+0] = L(float3(r.x, g.x, b.x));
			l[y+1][x+1] = L(float3(r.y, g.y, b.y));
		}
	}
	float3 v = mul(wy, float4x3(
		mul(wx, float4x3(l[0][0], l[0][1], l[0][2], l[0][3])), 
		mul(wx, float4x3(l[1][0], l[1][1], l[1][2], l[1][3])), 
		mul(wx, float4x3(l[2][0], l[2][1], l[2][2], l[2][3])), 
		mul(wx, float4x3(l[3][0], l[3][1], l[3][2], l[3][3]))));
	v = clamp(v, vmin, vmax);
	return float4(E(v), 1.);
}
