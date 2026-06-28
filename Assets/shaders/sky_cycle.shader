HEADER
{
	Description = "Procedural day / twilight / night sky with Milky Way base layer";
	Version = 2;
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

	SamplerState g_sSky < Filter( Linear ); AddressU( Wrap ); AddressV( Clamp ); >;

	CreateInputTexture2D( MilkyWayTexture, Linear, 8, "", "", "Textures, 1/3", Default( 0.5 ) );
	CreateInputTexture2D( StarTexture, Linear, 8, "", "", "Textures, 2/3", Default( 0.5 ) );
	CreateInputTexture2D( CloudNoise, Linear, 8, "", "", "Textures, 3/3", Default( 0.5 ) );

	Texture2D g_tMilkyWayTexture < Channel( RGBA, Box( MilkyWayTexture ), Linear ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tStarTexture < Channel( RGBA, Box( StarTexture ), Linear ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tCloudNoise < Channel( RGBA, Box( CloudNoise ), Linear ); OutputFormat( BC7 ); SrgbRead( true ); >;

	float3 g_vDayHorizonColor < Default3( 0.72, 0.82, 0.95 ); UiGroup( "Day, 1/2" ); >;
	float3 g_vDayZenithColor < Default3( 0.22, 0.48, 0.92 ); UiGroup( "Day, 2/2" ); >;

	float3 g_vSunriseHorizonColor < Default3( 1.0, 0.55, 0.28 ); UiGroup( "Sunrise, 1/2" ); >;
	float3 g_vSunriseZenithColor < Default3( 0.55, 0.62, 0.88 ); UiGroup( "Sunrise, 2/2" ); >;

	float3 g_vSunsetHorizonColor < Default3( 1.0, 0.42, 0.32 ); UiGroup( "Sunset, 1/2" ); >;
	float3 g_vSunsetZenithColor < Default3( 0.48, 0.38, 0.72 ); UiGroup( "Sunset, 2/2" ); >;

	float3 g_vNightHorizonColor < Default3( 0.04, 0.06, 0.12 ); UiGroup( "Night, 1/2" ); >;
	float3 g_vNightZenithColor < Default3( 0.01, 0.02, 0.06 ); UiGroup( "Night, 2/2" ); >;

	float g_flDayAmount < Default( 1.0 ); UiGroup( "Blend, 1/8" ); >;
	float g_flNightAmount < Default( 0.0 ); UiGroup( "Blend, 2/8" ); >;
	float g_flSunriseAmount < Default( 0.0 ); UiGroup( "Blend, 3/8" ); >;
	float g_flSunsetAmount < Default( 0.0 ); UiGroup( "Blend, 4/8" ); >;
	float g_flStarIntensity < Default( 0.0 ); UiGroup( "Blend, 5/8" ); >;
	float g_flMilkyWayIntensity < Default( 1.0 ); UiGroup( "Blend, 6/8" ); >;
	float g_flCloudCoverage < Default( 0.0 ); UiGroup( "Blend, 7/8" ); >;
	float g_flWeatherDarkness < Default( 0.0 ); UiGroup( "Blend, 8/8" ); >;

	float3 g_vSunDirection < Default3( 0.0, 0.0, 1.0 ); UiGroup( "Celestial, 1/6" ); >;
	float3 g_vMoonDirection < Default3( 0.0, 0.0, -1.0 ); UiGroup( "Celestial, 2/6" ); >;
	float g_flSunGlowStrength < Default( 0.45 ); UiGroup( "Celestial, 3/6" ); >;
	float g_flMoonGlowStrength < Default( 0.18 ); UiGroup( "Celestial, 4/6" ); >;
	float3 g_vSunGlowColor < Default3( 1.0, 0.92, 0.78 ); UiGroup( "Celestial, 5/6" ); >;
	float3 g_vMoonGlowColor < Default3( 0.78, 0.86, 1.0 ); UiGroup( "Celestial, 6/6" ); >;

	float2 EquirectUv( float3 dir )
	{
		float2 uv;
		uv.x = atan2( dir.y, dir.x ) / 6.2831853f + 0.5f;
		uv.y = 1.0f - ( asin( clamp( dir.z, -1.0f, 1.0f ) ) / 3.14159265f + 0.5f );
		return uv;
	}

	float GradientT( float3 rayDir )
	{
		float elev = asin( clamp( rayDir.z, -1.0f, 1.0f ) );
		return saturate( elev / 1.5707963f );
	}

	float3 VerticalGradient( float3 horizonColor, float3 zenithColor, float t )
	{
		float curve = pow( saturate( t ), 0.65 );
		return lerp( horizonColor, zenithColor, curve );
	}

	float Hash( float2 p )
	{
		return frac( sin( dot( p, float2( 127.1, 311.7 ) ) ) * 43758.5453 );
	}

	float ProceduralStars( float3 rayDir )
	{
		float2 uv = float2(
			atan2( rayDir.y, rayDir.x ) / 6.2831853f,
			asin( clamp( rayDir.z, -1.0f, 1.0f ) ) / 3.14159265f + 0.5f );

		float star = 0.0;
		[unroll( 3 )]
		for ( int layer = 0; layer < 3; layer++ )
		{
			float scale = 220.0 + layer * 95.0;
			float2 cell = floor( uv * scale );
			float2 local = frac( uv * scale ) - 0.5;

			float rnd = Hash( cell + layer * 17.0 );
			if ( rnd > 0.965 )
			{
				float size = lerp( 0.015, 0.04, Hash( cell + 41.0 ) );
				float dist = length( local );
				star += smoothstep( size, 0.0, dist ) * lerp( 0.35, 1.0, Hash( cell + 73.0 ) );
			}
		}

		return saturate( star );
	}

	float CelestialGlow( float3 rayDir, float3 bodyDir, float glowDegrees, float strength )
	{
		bodyDir = normalize( bodyDir );
		float cosAngle = dot( rayDir, bodyDir );
		float cosGlow = cos( radians( glowDegrees ) );
		float glow = pow( saturate( (cosAngle - cosGlow) / max( 1.0 - cosGlow, 0.001 ) ), 4.0 );
		return glow * strength;
	}

	struct PS_OUTPUT
	{
		float4 vColor0 : SV_Target0;
	};

	PS_OUTPUT MainPs( PS_INPUT i )
	{
		PS_OUTPUT o;

		float3 vRay = normalize( i.vPositionWs - g_vCameraPositionWs.xyz );
		float gradientT = GradientT( vRay );
		float2 uv = EquirectUv( vRay );

		float3 dayGrad = VerticalGradient( g_vDayHorizonColor, g_vDayZenithColor, gradientT );
		float3 sunriseGrad = VerticalGradient( g_vSunriseHorizonColor, g_vSunriseZenithColor, gradientT );
		float3 sunsetGrad = VerticalGradient( g_vSunsetHorizonColor, g_vSunsetZenithColor, gradientT );
		float3 nightGrad = VerticalGradient( g_vNightHorizonColor, g_vNightZenithColor, gradientT );

		float blendTotal = g_flDayAmount + g_flSunriseAmount + g_flSunsetAmount + g_flNightAmount;
		float invBlend = 1.0 / max( blendTotal, 0.0001 );

		float3 skyGradient = dayGrad * g_flDayAmount
			+ sunriseGrad * g_flSunriseAmount
			+ sunsetGrad * g_flSunsetAmount
			+ nightGrad * g_flNightAmount;
		skyGradient *= invBlend;

		float horizonWarmth = pow( 1.0 - gradientT, 2.5 );
		skyGradient = lerp(
			skyGradient,
			lerp( g_vSunriseHorizonColor, g_vSunsetHorizonColor, g_flSunsetAmount / max( g_flSunriseAmount + g_flSunsetAmount, 0.001 ) ),
			horizonWarmth * saturate( g_flSunriseAmount + g_flSunsetAmount ) * 0.55 );

		float cloudMask = saturate( g_flCloudCoverage );
		float nightReveal = saturate( g_flNightAmount ) * ( 1.0 - cloudMask * 0.95 );

		float3 milkyWay = g_tMilkyWayTexture.SampleLevel( g_sSky, uv, 0 ).rgb;
		milkyWay *= g_flMilkyWayIntensity * nightReveal;

		float3 starSample = g_tStarTexture.SampleLevel( g_sSky, uv, 0 ).rgb;
		float starLuma = dot( starSample, float3( 0.2126, 0.7152, 0.0722 ) );
		float useStarTexture = step( 0.02, starLuma );
		float proceduralStars = ProceduralStars( vRay );
		float stars = lerp( proceduralStars, starLuma, useStarTexture );
		stars *= g_flStarIntensity * nightReveal;

		float3 nightLayer = milkyWay + stars * float3( 0.92, 0.95, 1.0 );

		float gradientCover = saturate( g_flDayAmount + g_flSunriseAmount * 0.85 + g_flSunsetAmount * 0.85 );
		gradientCover = saturate( gradientCover * ( 1.0 - nightReveal * 0.35 ) );

		float3 color = lerp( nightLayer, skyGradient, gradientCover );

		if ( g_flCloudCoverage > 0.001 )
		{
			float cloudNoise = g_tCloudNoise.SampleLevel( g_sSky, uv * float2( 2.0, 1.0 ), 0 ).r;
			float cloudPatch = smoothstep( 1.0 - cloudMask, 1.0, cloudNoise );
			float3 cloudTint = lerp( float3( 0.55, 0.58, 0.62 ), float3( 0.35, 0.38, 0.42 ), g_flNightAmount );
			color = lerp( color, cloudTint, cloudPatch * cloudMask * 0.75 );
		}

		float sunGlow = CelestialGlow( vRay, g_vSunDirection, 8.0, g_flSunGlowStrength ) * g_flDayAmount;
		float moonGlow = CelestialGlow( vRay, g_vMoonDirection, 6.0, g_flMoonGlowStrength ) * g_flNightAmount;
		color += g_vSunGlowColor * sunGlow;
		color += g_vMoonGlowColor * moonGlow;

		color *= 1.0 - g_flWeatherDarkness * 0.65;

		o.vColor0 = float4( max( color, 0.0 ), 1.0 );
		return o;
	}
}
