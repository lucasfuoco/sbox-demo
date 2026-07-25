HEADER
{
	Description = "Ocean FFT — spectrum time modulation + gradient packing";
}

MODES
{
	Default();
}

COMMON
{
	#include "common/shared.hlsl"
}

CS
{
	#define PI 3.141592653589793
	#define G 9.81
	#define NUM_SPECTRA 4

	StructuredBuffer<float4> Spectrum < Attribute( "Spectrum" ); >;
	RWStructuredBuffer<float4> FFTBuffer < Attribute( "FFTBuffer" ); >;

	int MapSize < Attribute( "MapSize" ); Default( 256 ); >;
	int CascadeIndex < Attribute( "CascadeIndex" ); Default( 0 ); >;
	float2 TileLength < Attribute( "TileLength" ); Default2( 50, 50 ); >;
	float Depth < Attribute( "Depth" ); Default( 20 ); >;
	float Time < Attribute( "Time" ); Default( 0 ); >;

	float2 ExpComplex( float x )
	{
		return float2( cos( x ), sin( x ) );
	}

	float2 MulComplex( float2 a, float2 b )
	{
		return float2( a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x );
	}

	float2 ConjComplex( float2 x )
	{
		return float2( x.x, -x.y );
	}

	float DispersionRelation( float k )
	{
		return sqrt( G * k * tanh( k * Depth ) );
	}

	[numthreads( 16, 16, 1 )]
	void MainCs( uint3 dispatchId : SV_DispatchThreadID )
	{
		int N = MapSize;
		if ( (int)dispatchId.x >= N || (int)dispatchId.y >= N )
			return;

		int3 id = int3( dispatchId.xy, CascadeIndex );
		float2 kVec = ( float2( id.xy ) - float2( N, N ) * 0.5 ) * 2.0 * PI / max( TileLength, float2( 0.001, 0.001 ) );
		float k = length( kVec ) + 1e-6;
		float2 kUnit = kVec / k;

		float4 h0 = Spectrum[CascadeIndex * N * N + id.y * N + id.x];
		float dispersion = DispersionRelation( k ) * Time;
		float2 modulation = ExpComplex( dispersion );
		float2 h = MulComplex( h0.xy, modulation ) + MulComplex( h0.zw, ConjComplex( modulation ) );
		float2 hInv = float2( -h.y, h.x );

		float2 hx = hInv * kUnit.y;
		float2 hy = h;
		float2 hz = hInv * kUnit.x;

		float2 dhy_dx = hInv * kVec.y;
		float2 dhy_dz = hInv * kVec.x;
		float2 dhx_dx = -h * kVec.y * kUnit.y;
		float2 dhz_dz = -h * kVec.x * kUnit.x;
		float2 dhz_dx = -h * kVec.y * kUnit.x;

		uint base = (uint)CascadeIndex * (uint)N * (uint)N * NUM_SPECTRA * 2u;
		uint idx = (uint)id.y * (uint)N + (uint)id.x;
		uint layerSize = (uint)N * (uint)N;

		FFTBuffer[base + 0 * layerSize + idx] = float4( hx.x - hy.y, hx.y + hy.x, 0, 0 );
		FFTBuffer[base + 1 * layerSize + idx] = float4( hz.x - dhy_dx.y, hz.y + dhy_dx.x, 0, 0 );
		FFTBuffer[base + 2 * layerSize + idx] = float4( dhy_dz.x - dhx_dx.y, dhy_dz.y + dhx_dx.x, 0, 0 );
		FFTBuffer[base + 3 * layerSize + idx] = float4( dhz_dz.x - dhz_dx.y, dhz_dz.y + dhz_dx.x, 0, 0 );
	}
}


