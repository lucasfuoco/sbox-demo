HEADER
{
	Description = "Blended day / sunrise / sunset / night sky panorama";
	Version = 1;
	DevShader = true;
}

MODES
{
	Forward();
}

COMMON
{
	#include "system.fxc"
	#include "vr_common.fxc"
}

struct VS_INPUT
{
	float4 vPositionOs : POSITION < Semantic( PosXyz ); >;
};

struct PS_INPUT
{
	float3 vPositionWs : TEXCOORD1;

	#if ( PROGRAM == VFX_PROGRAM_VS )
	float4 vPositionPs : SV_Position;
	#endif
	#if ( PROGRAM == VFX_PROGRAM_PS )
	float4 vPositionSs : SV_Position;
	#endif
};

VS
{
	#define IS_SPRITECARD 1
	#include "system.fxc"

	PS_INPUT MainVs( const VS_INPUT i )
	{
		PS_INPUT o;

		float flSkyboxScale = g_flNearPlane + g_flFarPlane;
		float3 vPositionWs = g_vCameraPositionWs.xyz + i.vPositionOs.xyz * flSkyboxScale;

		o.vPositionPs = Position3WsToPs( vPositionWs );
		o.vPositionWs = vPositionWs;

		return o;
	}
}

PS
{
	RenderState( CullMode, NONE );
	RenderState( DepthWriteEnable, false );
	RenderState( DepthEnable, true );
	RenderState( DepthFunc, GREATER_EQUAL );

	BoolAttribute( sky, true );

	SamplerState g_sSky < Filter( Linear ); AddressU( Clamp ); AddressV( Clamp ); >;

	CreateInputTexture2D( SkyDay, Linear, 8, "", "", "Skies, 1/4", Default( 0.5 ) );
	CreateInputTexture2D( SkySunrise, Linear, 8, "", "", "Skies, 2/4", Default( 0.5 ) );
	CreateInputTexture2D( SkySunset, Linear, 8, "", "", "Skies, 3/4", Default( 0.5 ) );
	CreateInputTexture2D( SkyNight, Linear, 8, "", "", "Skies, 4/4", Default( 0.5 ) );

	Texture2D g_tSkyDay < Channel( RGBA, Box( SkyDay ), Linear ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tSkySunrise < Channel( RGBA, Box( SkySunrise ), Linear ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tSkySunset < Channel( RGBA, Box( SkySunset ), Linear ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tSkyNight < Channel( RGBA, Box( SkyNight ), Linear ); OutputFormat( BC7 ); SrgbRead( true ); >;

	float g_flBlendDay < Default( 1.0 ); UiGroup( "Blend, 1/5" ); >;
	float g_flBlendSunrise < Default( 0.0 ); UiGroup( "Blend, 2/5" ); >;
	float g_flBlendSunset < Default( 0.0 ); UiGroup( "Blend, 3/5" ); >;
	float g_flBlendNight < Default( 0.0 ); UiGroup( "Blend, 4/5" ); >;
	float3 g_vWeatherTint < Default3( 1.0, 1.0, 1.0 ); UiGroup( "Blend, 5/5" ); >;

	float2 PanoramaUv( float3 dir )
	{
		float2 uv;
		uv.x = atan2( dir.y, dir.x ) / 6.2831853f + 0.5f;
		uv.y = 1.0f - ( asin( clamp( dir.z, -1.0f, 1.0f ) ) / 3.14159265f + 0.5f );
		return uv;
	}

	struct PS_OUTPUT
	{
		float4 vColor0 : SV_Target0;
	};

	PS_OUTPUT MainPs( PS_INPUT i )
	{
		PS_OUTPUT o;

		float3 vRay = normalize( i.vPositionWs - g_vCameraPositionWs.xyz );
		float2 uv = PanoramaUv( vRay );

		float3 day = g_tSkyDay.SampleLevel( g_sSky, uv, 0 ).rgb;
		float3 sunrise = g_tSkySunrise.SampleLevel( g_sSky, uv, 0 ).rgb;
		float3 sunset = g_tSkySunset.SampleLevel( g_sSky, uv, 0 ).rgb;
		float3 night = g_tSkyNight.SampleLevel( g_sSky, uv, 0 ).rgb;

		float3 color = day * g_flBlendDay
			+ sunrise * g_flBlendSunrise
			+ sunset * g_flBlendSunset
			+ night * g_flBlendNight;

		color *= g_vWeatherTint;
		o.vColor0 = float4( color, 1.0 );
		return o;
	}
}
