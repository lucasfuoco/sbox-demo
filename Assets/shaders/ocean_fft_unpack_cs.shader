HEADER
{
	Description = "Ocean FFT — unpack displacement / normal / foam atlases";
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
	#define TILE_SIZE 16
	#define NUM_SPECTRA 4

	StructuredBuffer<float4> FFTBuffer < Attribute( "FFTBuffer" ); >;
	RWStructuredBuffer<float4> FoamBuffer < Attribute( "FoamBuffer" ); >;
	RWTexture2D<float4> DisplacementAtlas < Attribute( "DisplacementAtlas" ); >;
	RWTexture2D<float4> NormalAtlas < Attribute( "NormalAtlas" ); >;

	int MapSize < Attribute( "MapSize" ); Default( 256 ); >;
	int CascadeCapacity < Attribute( "CascadeCapacity" ); Default( 2 ); >;
	int CascadeIndex < Attribute( "CascadeIndex" ); Default( 0 ); >;
	float Whitecap < Attribute( "Whitecap" ); Default( 0.5 ); >;
	float FoamGrowRate < Attribute( "FoamGrowRate" ); Default( 0 ); >;
	float FoamDecayRate < Attribute( "FoamDecayRate" ); Default( 0 ); >;

	groupshared float2 Tile[NUM_SPECTRA][TILE_SIZE][TILE_SIZE];

	[numthreads( TILE_SIZE, TILE_SIZE, 2 )]
	void MainCs( uint3 groupThreadId : SV_GroupThreadID, uint3 dispatchId : SV_DispatchThreadID )
	{
		uint mapSize = (uint)MapSize;
		uint cascade = (uint)CascadeIndex;
		int2 pixel = int2( dispatchId.xy );
		bool active = pixel.x < (int)mapSize && pixel.y < (int)mapSize;

		uint layerSize = mapSize * mapSize;
		uint cascadeBase = cascade * layerSize * NUM_SPECTRA * 2u;
		// After second FFT, results live in ping-pong half 1.
		uint fftHalf = cascadeBase + NUM_SPECTRA * layerSize;

		uint localZ = groupThreadId.z;
		if ( active )
		{
			Tile[localZ * 2u][groupThreadId.y][groupThreadId.x] = FFTBuffer[fftHalf + ( localZ * 2u ) * layerSize + (uint)pixel.y * mapSize + (uint)pixel.x].xy;
			Tile[localZ * 2u + 1u][groupThreadId.y][groupThreadId.x] = FFTBuffer[fftHalf + ( localZ * 2u + 1u ) * layerSize + (uint)pixel.y * mapSize + (uint)pixel.x].xy;
		}

		GroupMemoryBarrierWithGroupSync();
		if ( !active )
			return;

		float signShift = (float)( -2 * ( ( pixel.x & 1 ) ^ ( pixel.y & 1 ) ) + 1 );
		int2 atlasPixel = int2( pixel.x, CascadeIndex * MapSize + pixel.y );

		if ( localZ == 0 )
		{
			float hx = Tile[0][groupThreadId.y][groupThreadId.x].x;
			float hy = Tile[0][groupThreadId.y][groupThreadId.x].y; // Godot Y-up height
			float hz = Tile[1][groupThreadId.y][groupThreadId.x].x;
			// S&box Z-up: (x, y horizontal, z height)
			DisplacementAtlas[atlasPixel] = float4( hx, hz, hy, 0 ) * signShift;
		}
		else
		{
			float dhy_dx = Tile[1][groupThreadId.y][groupThreadId.x].y * signShift;
			float dhy_dz = Tile[2][groupThreadId.y][groupThreadId.x].x * signShift;
			float dhx_dx = Tile[2][groupThreadId.y][groupThreadId.x].y * signShift;
			float dhz_dz = Tile[3][groupThreadId.y][groupThreadId.x].x * signShift;
			float dhz_dx = Tile[3][groupThreadId.y][groupThreadId.x].y * signShift;

			float jacobian = ( 1.0 + dhx_dx ) * ( 1.0 + dhz_dz ) - dhz_dx * dhz_dx;
			float foamFactor = -min( 0.0, jacobian - Whitecap );

			uint foamIndex = cascade * layerSize + (uint)pixel.y * mapSize + (uint)pixel.x;
			float foam = FoamBuffer[foamIndex].x;
			foam *= exp( -FoamDecayRate );
			foam += foamFactor * FoamGrowRate;
			foam = saturate( foam );
			FoamBuffer[foamIndex] = float4( foam, 0, 0, 0 );

			float2 gradient = float2( dhy_dx, dhy_dz ) / ( 1.0 + abs( float2( dhx_dx, dhz_dz ) ) );
			NormalAtlas[atlasPixel] = float4( gradient, dhx_dx, foam );
		}
	}
}


