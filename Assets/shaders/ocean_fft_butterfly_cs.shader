HEADER
{
	Description = "Ocean FFT — Stockham butterfly factors";
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

	RWStructuredBuffer<float4> Butterfly < Attribute( "Butterfly" ); >;
	int MapSize < Attribute( "MapSize" ); Default( 256 ); >;

	float2 ExpComplex( float x )
	{
		return float2( cos( x ), sin( x ) );
	}

	[numthreads( 64, 1, 1 )]
	void MainCs( uint3 id : SV_DispatchThreadID )
	{
		uint mapSize = (uint)MapSize;
		uint col = id.x;
		uint stage = id.y;

		if ( col >= mapSize / 2 )
			return;

		uint stride = 1u << stage;
		uint mid = mapSize >> ( stage + 1 );
		uint i = col >> stage;
		uint j = col % stride;

		float2 twiddle = ExpComplex( PI / float( stride ) * float( j ) );
		uint r0 = stride * ( i + 0 ) + j;
		uint r1 = stride * ( i + mid ) + j;
		uint w0 = stride * ( 2 * i + 0 ) + j;
		uint w1 = stride * ( 2 * i + 1 ) + j;

		float2 readIndices = float2( asfloat( r0 ), asfloat( r1 ) );
		Butterfly[stage * mapSize + w0] = float4( readIndices, twiddle );
		Butterfly[stage * mapSize + w1] = float4( readIndices, -twiddle );
	}
}


