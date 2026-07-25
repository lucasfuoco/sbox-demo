HEADER
{
	Description = "Ocean FFT — matrix transpose for 2D FFT";
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
	#define TILE_SIZE 32
	#define NUM_SPECTRA 4

	RWStructuredBuffer<float4> FFTBuffer < Attribute( "FFTBuffer" ); >;
	int MapSize < Attribute( "MapSize" ); Default( 256 ); >;
	int CascadeIndex < Attribute( "CascadeIndex" ); Default( 0 ); >;

	groupshared float2 Tile[TILE_SIZE][TILE_SIZE + 1];

	[numthreads( TILE_SIZE, TILE_SIZE, 1 )]
	void MainCs( uint3 groupId : SV_GroupID, uint3 groupThreadId : SV_GroupThreadID, uint3 dispatchId : SV_DispatchThreadID )
	{
		uint mapSize = (uint)MapSize;
		uint spectrum = dispatchId.z;
		uint cascade = (uint)CascadeIndex;

		if ( spectrum >= NUM_SPECTRA )
			return;

		uint layerSize = mapSize * mapSize;
		uint cascadeBase = cascade * layerSize * NUM_SPECTRA * 2u;
		uint inBase = cascadeBase + NUM_SPECTRA * layerSize + spectrum * layerSize;
		uint outBase = cascadeBase + spectrum * layerSize;

		uint2 local = groupThreadId.xy;
		uint2 src = dispatchId.xy;

		if ( src.x < mapSize && src.y < mapSize )
			Tile[local.y][local.x] = FFTBuffer[inBase + src.y * mapSize + src.x].xy;
		else
			Tile[local.y][local.x] = 0;

		GroupMemoryBarrierWithGroupSync();

		uint2 dst = groupId.yx * TILE_SIZE + local.xy;
		if ( dst.x < mapSize && dst.y < mapSize )
			FFTBuffer[outBase + dst.y * mapSize + dst.x] = float4( Tile[local.x][local.y], 0, 0 );
	}
}


