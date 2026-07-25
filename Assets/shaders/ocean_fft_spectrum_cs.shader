HEADER
{
	Description = "Ocean FFT — TMA/JONSWAP spectrum (GodotOceanWaves port)";
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

	RWStructuredBuffer<float4> Spectrum < Attribute( "Spectrum" ); >;

	int MapSize < Attribute( "MapSize" ); Default( 256 ); >;
	int CascadeIndex < Attribute( "CascadeIndex" ); Default( 0 ); >;
	float2 Seed < Attribute( "Seed" ); Default2( 0, 0 ); >;
	float2 TileLength < Attribute( "TileLength" ); Default2( 50, 50 ); >;
	float Alpha < Attribute( "Alpha" ); Default( 0.008 ); >;
	float PeakFrequency < Attribute( "PeakFrequency" ); Default( 0.5 ); >;
	float WindSpeed < Attribute( "WindSpeed" ); Default( 20 ); >;
	float WindAngle < Attribute( "WindAngle" ); Default( 0 ); >;
	float Depth < Attribute( "Depth" ); Default( 20 ); >;
	float Swell < Attribute( "Swell" ); Default( 0.8 ); >;
	float Detail < Attribute( "Detail" ); Default( 1 ); >;
	float Spread < Attribute( "Spread" ); Default( 0.2 ); >;

	float2 Hash( uint2 x )
	{
		uint h32 = x.y + 374761393u + x.x * 3266489917u;
		h32 = 2246822519u * ( h32 ^ ( h32 >> 15 ) );
		h32 = 3266489917u * ( h32 ^ ( h32 >> 13 ) );
		uint n = h32 ^ ( h32 >> 16 );
		uint2 rz = uint2( n, n * 48271u );
		return float2( ( rz >> 1 ) & uint2( 0x7FFFFFFFu, 0x7FFFFFFFu ) ) / float( 0x7FFFFFFF );
	}

	float2 Gaussian( float2 x )
	{
		float r = sqrt( -2.0 * log( max( x.x, 1e-6 ) ) );
		float theta = 2.0 * PI * x.y;
		return float2( r * cos( theta ), r * sin( theta ) );
	}

	float2 ConjComplex( float2 x )
	{
		return float2( x.x, -x.y );
	}

	float2 DispersionRelation( float k )
	{
		float a = k * Depth;
		float b = tanh( a );
		float dispersion = sqrt( G * k * b );
		float dDispersion = 0.5 * G * ( b + a * ( 1.0 - b * b ) ) / max( dispersion, 1e-6 );
		return float2( dispersion, dDispersion );
	}

	float LonguetHigginsNormalization( float s )
	{
		float a = sqrt( max( s, 0.0 ) );
		return ( s < 0.4 )
			? ( 0.5 / PI ) + s * ( 0.220636 + s * ( -0.109 + s * 0.090 ) )
			: rsqrt( PI ) * ( a * 0.5 + ( 1.0 / max( a, 1e-6 ) ) * 0.0625 );
	}

	float LonguetHigginsFunction( float s, float theta )
	{
		return LonguetHigginsNormalization( s ) * pow( abs( cos( theta * 0.5 ) ), 2.0 * s );
	}

	float HasselmannDirectionalSpread( float w, float w_p, float windSpeed, float theta )
	{
		float p = w / max( w_p, 1e-6 );
		float s = ( w <= w_p )
			? 6.97 * pow( abs( p ), 4.06 )
			: 9.77 * pow( abs( p ), -2.33 - 1.45 * ( windSpeed * w_p / G - 1.17 ) );
		float s_xi = 16.0 * tanh( w_p / max( w, 1e-6 ) ) * Swell * Swell;
		return LonguetHigginsFunction( s + s_xi, theta - WindAngle );
	}

	float TMASpectrum( float w, float w_p, float alpha )
	{
		const float beta = 1.25;
		const float gamma = 3.3;
		float sigma = ( w <= w_p ) ? 0.07 : 0.09;
		float r = exp( -( w - w_p ) * ( w - w_p ) / ( 2.0 * sigma * sigma * w_p * w_p ) );
		float jonswap = ( alpha * G * G ) / pow( max( w, 1e-4 ), 5.0 ) * exp( -beta * pow( w_p / max( w, 1e-4 ), 4.0 ) ) * pow( gamma, r );

		float w_h = min( w * sqrt( Depth / G ), 2.0 );
		float depthAtten = ( w_h <= 1.0 ) ? 0.5 * w_h * w_h : 1.0 - 0.5 * ( 2.0 - w_h ) * ( 2.0 - w_h );
		return jonswap * depthAtten;
	}

	float2 GetSpectrumAmplitude( int2 id, int2 mapSize )
	{
		float2 dk = 2.0 * PI / max( TileLength, float2( 0.001, 0.001 ) );
		float2 kVec = ( float2( id ) - float2( mapSize ) * 0.5 ) * dk;
		float k = length( kVec ) + 1e-6;
		float theta = atan2( kVec.x, kVec.y );

		float2 dispersion = DispersionRelation( k );
		float w = dispersion.x;
		float wNorm = dispersion.y / k * dk.x * dk.y;
		float s = TMASpectrum( w, PeakFrequency, Alpha );
		float d = lerp( 0.5 / PI, HasselmannDirectionalSpread( w, PeakFrequency, WindSpeed, theta ), 1.0 - Spread )
			* exp( -( 1.0 - Detail ) * ( 1.0 - Detail ) * k * k );

		int2 seedi = int2( Seed );
		return Gaussian( Hash( uint2( id + seedi ) ) ) * sqrt( max( 2.0 * s * d * wNorm, 0.0 ) );
	}

	[numthreads( 16, 16, 1 )]
	void MainCs( uint3 id : SV_DispatchThreadID )
	{
		int N = MapSize;
		if ( (int)id.x >= N || (int)id.y >= N )
			return;

		int2 id0 = int2( id.xy );
		int2 id1 = int2( ( ( N - id0.x ) % N ), ( ( N - id0.y ) % N ) );

		float4 value = float4( GetSpectrumAmplitude( id0, int2( N, N ) ), ConjComplex( GetSpectrumAmplitude( id1, int2( N, N ) ) ) );
		Spectrum[CascadeIndex * N * N + id0.y * N + id0.x] = value;
	}
}


