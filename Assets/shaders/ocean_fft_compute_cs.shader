HEADER
{
	Description = "Ocean FFT — Stockham row FFT";
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
	#define MAX_MAP_SIZE 256
	#define NUM_SPECTRA 4

	StructuredBuffer<float4> Butterfly < Attribute( "Butterfly" ); >;
	RWStructuredBuffer<float4> FFTBuffer < Attribute( "FFTBuffer" ); >;

	int MapSize < Attribute( "MapSize" ); Default( 256 ); >;
	int CascadeIndex < Attribute( "CascadeIndex" ); Default( 0 ); >;

	groupshared float2 RowShared[2 * MAX_MAP_SIZE];

	float2 MulComplex( float2 a, float2 b )
	{
		return float2( a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x );
	}

	uint Log2Pow2( uint value )
	{
		uint n = 0u;
		uint v = value;
		while ( v > 1u )
		{
			v >>= 1u;
			n++;
		}
		return n;
	}

	[numthreads( MAX_MAP_SIZE, 1, 1 )]
	void MainCs( uint3 groupThreadId : SV_GroupThreadID, uint3 dispatchId : SV_DispatchThreadID )
	{
		uint mapSize = (uint)MapSize;
		uint numStages = Log2Pow2( mapSize );
		uint col = dispatchId.x;
		uint row = dispatchId.y;
		uint spectrum = dispatchId.z;
		uint cascade = (uint)CascadeIndex;

		// Must not early-return before group barriers when mapSize < MAX_MAP_SIZE.
		bool active = col < mapSize && row < mapSize && spectrum < NUM_SPECTRA;

		uint layerSize = mapSize * mapSize;
		uint cascadeBase = cascade * layerSize * NUM_SPECTRA * 2u;
		uint inBase = cascadeBase + spectrum * layerSize;
		uint outBase = cascadeBase + NUM_SPECTRA * layerSize + spectrum * layerSize;

		if ( active )
			RowShared[col] = FFTBuffer[inBase + row * mapSize + col].xy;

		for ( uint stage = 0u; stage < numStages; ++stage )
		{
			GroupMemoryBarrierWithGroupSync();

			if ( active )
			{
				uint readPP = stage % 2u;
				uint writePP = ( stage + 1u ) % 2u;
				float4 butterflyData = Butterfly[stage * mapSize + col];

				uint2 readIndices = uint2( asuint( butterflyData.x ), asuint( butterflyData.y ) );
				float2 twiddle = butterflyData.zw;

				float2 upper = RowShared[readPP * MAX_MAP_SIZE + readIndices.x];
				float2 lower = RowShared[readPP * MAX_MAP_SIZE + readIndices.y];
				RowShared[writePP * MAX_MAP_SIZE + col] = upper + MulComplex( lower, twiddle );
			}
		}

		GroupMemoryBarrierWithGroupSync();
		if ( active )
			FFTBuffer[outBase + row * mapSize + col] = float4( RowShared[( numStages % 2u ) * MAX_MAP_SIZE + col], 0, 0 );
	}
}


