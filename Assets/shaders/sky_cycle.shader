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

	SamplerState g_sSky < Filter( Anisotropic ); MaxAniso( 8 ); AddressU( Wrap ); AddressV( Clamp ); >;
	SamplerState g_sMoon < Filter( Anisotropic ); MaxAniso( 4 ); AddressU( Clamp ); AddressV( Clamp ); >;

	CreateInputTexture2D( MilkyWayTexture, Linear, 8, "", "", "Textures, 1/3", Default( 0.5 ) );
	CreateInputTexture2D( SunTexture, Linear, 8, "", "", "Textures, 2/3", Default( 0.5 ) );
	CreateInputTexture2D( MoonTexture, Linear, 8, "", "", "Textures, 3/3", Default( 0.5 ) );

	// None + RGBA8888 keeps the equirect milky-way sharp (BC7/Box looked soft and blocky on sky).
	Texture2D g_tMilkyWayTexture < Channel( RGBA, None( MilkyWayTexture ), Linear ); OutputFormat( RGBA8888 ); SrgbRead( false ); >;
	Texture2D g_tSunTexture < Channel( RGBA, Box( SunTexture ), Linear ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tMoonTexture < Channel( RGBA, Box( MoonTexture ), Linear ); OutputFormat( BC7 ); SrgbRead( true ); >;

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
	float g_flMilkyWayBrightness < Default( 2.5 ); UiGroup( "Milky Way, 1/1" ); >;
	float g_flWeatherDarkness < Default( 0.0 ); UiGroup( "Blend, 7/7" ); >;

	float3 g_vSunDirection < Default3( 0.0, 0.0, 1.0 ); UiGroup( "Celestial, 1/12" ); >;
	float3 g_vMoonDirection < Default3( 0.0, 0.0, -1.0 ); UiGroup( "Celestial, 2/12" ); >;
	float g_flSunDiscSize < Default( 1.15 ); UiGroup( "Celestial, 3/12" ); >;
	float g_flMoonDiscSize < Default( 1.8 ); UiGroup( "Celestial, 4/12" ); >;
	float g_flSunBrightness < Default( 0.0 ); UiGroup( "Celestial, 5/12" ); >;
	float g_flMoonBrightness < Default( 0.0 ); UiGroup( "Celestial, 6/12" ); >;
	float g_flSunGlowStrength < Default( 0.35 ); UiGroup( "Celestial, 7/12" ); >;
	float g_flMoonGlowStrength < Default( 0.15 ); UiGroup( "Celestial, 8/12" ); >;
	float g_flSunGlowSize < Default( 4.0 ); UiGroup( "Celestial, 9/14" ); >;
	float g_flMoonGlowSize < Default( 4.5 ); UiGroup( "Celestial, 10/14" ); >;
	float3 g_vSunDiscColor < Default3( 1.0, 0.95, 0.85 ); UiGroup( "Celestial, 11/14" ); >;
	float3 g_vMoonDiscColor < Default3( 1.0, 1.0, 1.0 ); UiGroup( "Celestial, 12/14" ); >;
	float g_flSunFlareStrength < Default( 0.0 ); UiGroup( "Celestial, 13/18" ); >;
	float3 g_vSunFlareColor < Default3( 1.0, 0.96, 0.88 ); UiGroup( "Celestial, 14/18" ); >;
	float g_flSunFlareBloom < Default( 1.0 ); UiGroup( "Celestial, 15/18" ); >;
	float g_flSunFlareStreaks < Default( 1.0 ); UiGroup( "Celestial, 16/18" ); >;
	float g_flSunFlareGhosts < Default( 1.0 ); UiGroup( "Celestial, 17/18" ); >;
	float g_flSunFlareHalo < Default( 1.0 ); UiGroup( "Celestial, 18/18" ); >;

	float g_flMoonTextureRadial < Default( 0.42 ); UiGroup( "Moon Texture, 1/3" ); >;
	float g_flMoonEdgeSoft < Default( 0.08 ); UiGroup( "Moon Texture, 2/3" ); >;
	float g_flMoonTextureBrightness < Default( 1.0 ); UiGroup( "Moon Texture, 3/3" ); >;

	float g_flStarNoiseScale < Default( 280.0 ); UiGroup( "Stars, 1/4" ); >;
	float g_flStarNoiseDensity < Default( 0.985 ); UiGroup( "Stars, 2/4" ); >;
	float g_flStarTwinkleSpeed < Default( 1.2 ); UiGroup( "Stars, 3/4" ); >;
	float g_flStarTwinkleAmount < Default( 0.7 ); UiGroup( "Stars, 4/4" ); >;

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

	float StarSparkle( float2 cell, float baseBright )
	{
		float phase = Hash( cell + 31.0 ) * 6.2831853f;
		float slowRate = lerp( 0.35, 1.6, Hash( cell + 67.0 ) );
		float fastRate = lerp( 2.2, 9.0, Hash( cell + 89.0 ) );
		float flickerRate = lerp( 4.0, 12.0, Hash( cell + 113.0 ) );
		float time = g_flTime * g_flStarTwinkleSpeed;

		float slowPulse = sin( time * slowRate + phase ) * 0.5 + 0.5;
		float sharpFlash = pow( abs( sin( time * fastRate + phase * 1.73 ) ), 6.0 );

		// Occasional blinks — stay mostly on so stars remain visible.
		float flickerNoise = Hash( cell + floor( time * flickerRate ) + 191.0 );
		float hardFlicker = lerp( 0.35, 1.0, step( 0.18, flickerNoise ) );

		float sparkle = saturate( slowPulse * 0.45 + sharpFlash * 0.7 ) * hardFlicker;

		// Twinkle modulates brightness but keeps a solid floor so stars don't vanish.
		float floorBright = lerp( 0.45, 0.7, saturate( baseBright ) );
		float flash = lerp( floorBright, 1.0, sparkle * g_flStarTwinkleAmount );
		return saturate( flash );
	}

	float StarCore( float2 local, float2 starCenter, float size, float bright )
	{
		float2 delta = local - starCenter;
		float dist = length( delta );
		float core = smoothstep( size, 0.0, dist );

		float cross = exp( -abs( delta.x ) * 120.0 ) + exp( -abs( delta.y ) * 120.0 );
		cross *= smoothstep( size * 2.5, 0.0, dist ) * bright * 0.35;

		return core + cross;
	}

	float NoiseIlluminatedStars( float2 uv )
	{
		float star = 0.0;
		[unroll( 3 )]
		for ( int layer = 0; layer < 3; layer++ )
		{
			float scale = g_flStarNoiseScale + layer * (g_flStarNoiseScale * 0.35);
			float2 cell = floor( uv * scale );
			float2 local = frac( uv * scale );

			float noise = Hash( cell + layer * 17.0 );
			if ( noise > g_flStarNoiseDensity )
			{
				float2 starCenter = float2( Hash( cell + 41.0 ), Hash( cell + 73.0 ) );
				float size = lerp( 0.018, 0.045, Hash( cell + 109.0 ) );
				float bright = lerp( 0.55, 1.0, Hash( cell + 151.0 ) );
				float core = StarCore( local, starCenter, size, bright );
				star += core * bright * StarSparkle( cell + layer * 23.0, bright );
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

	float3 SunLensFlare( float3 rayDir, float3 sunDir, float3 flareColor, float strength )
	{
		if ( strength <= 0.001 )
			return float3( 0.0, 0.0, 0.0 );

		sunDir = normalize( sunDir );
		float mu = saturate( dot( rayDir, sunDir ) );

		float bloom = (pow( mu, 96.0 ) * 2.2 + pow( mu, 18.0 ) * 0.55 + pow( mu, 6.0 ) * 0.12) * g_flSunFlareBloom;

		float3 upRef = abs( sunDir.z ) < 0.99 ? float3( 0.0, 0.0, 1.0 ) : float3( 0.0, 1.0, 0.0 );
		float3 right = normalize( cross( upRef, sunDir ) );
		float3 upSun = cross( sunDir, right );
		float3 offset = rayDir - sunDir * mu;
		float u = dot( offset, right );
		float v = dot( offset, upSun );

		float streakH = exp( -abs( u ) * 26.0 ) * exp( -abs( v ) * 160.0 );
		float streakHSoft = exp( -abs( u ) * 10.0 ) * exp( -abs( v ) * 70.0 );
		float streakV = exp( -abs( v ) * 26.0 ) * exp( -abs( u ) * 160.0 );
		float streaks = (streakH * 1.55 + streakHSoft * 0.65 + streakV * 0.45) * g_flSunFlareStreaks;

		float ghosts = 0.0;
		[unroll]
		for ( int i = 1; i <= 5; i++ )
		{
			float t = i * 0.16;
			float3 ghostDir = normalize( lerp( sunDir, -sunDir, t ) );
			float ghostMu = saturate( dot( rayDir, ghostDir ) );
			ghosts += pow( ghostMu, 280.0 / max( t, 0.08 ) ) * (0.42 / i);
		}
		ghosts *= g_flSunFlareGhosts;

		float ring = abs( mu - 0.72 );
		float halo = exp( -ring * ring * 220.0 ) * 0.22 * g_flSunFlareHalo;

		return flareColor * (bloom + streaks + ghosts + halo) * strength;
	}

	float CelestialDiscMask( float3 rayDir, float3 bodyDir, float discDegrees )
	{
		bodyDir = normalize( bodyDir );
		float cosAngle = saturate( dot( rayDir, bodyDir ) );
		float cosInner = cos( radians( discDegrees ) );
		float cosOuter = cos( radians( discDegrees * 1.12 ) );
		return smoothstep( cosOuter, cosInner, cosAngle );
	}

	float MoonRadialMask( float3 rayDir, float3 bodyDir, float discDegrees )
	{
		bodyDir = normalize( bodyDir );
		float cosAngle = saturate( dot( rayDir, bodyDir ) );
		float cosInner = cos( radians( discDegrees ) );
		float cosOuter = cos( radians( discDegrees * (1.0 + g_flMoonEdgeSoft) ) );
		return smoothstep( cosOuter, cosInner, cosAngle );
	}

	float3 MoonDiscColor(
		float3 rayDir,
		float3 bodyDir,
		float discDegrees,
		float3 tintColor,
		float brightness )
	{
		bodyDir = normalize( bodyDir );
		float cosAngle = dot( rayDir, bodyDir );
		float discRadius = max( radians( discDegrees ), 0.001 );

		float3 upRef = abs( bodyDir.z ) < 0.999 ? float3( 0.0, 0.0, 1.0 ) : float3( 0.0, 1.0, 0.0 );
		float3 tangent = normalize( cross( upRef, bodyDir ) );
		float3 bitangent = cross( bodyDir, tangent );

		float sinTheta = sqrt( saturate( 1.0 - cosAngle * cosAngle ) );
		float phi = atan2( dot( rayDir, bitangent ), dot( rayDir, tangent ) );
		float radial = saturate( sinTheta / discRadius );
		float2 uvDir = float2( cos( phi ), sin( phi ) );

		float maxUvOffset = max( g_flMoonTextureRadial, 0.01 );
		float2 uvOffset = uvDir * radial * maxUvOffset;
		float uvOffsetLen = length( uvOffset );
		if ( uvOffsetLen > maxUvOffset )
			uvOffset = uvOffset * (maxUvOffset / uvOffsetLen);

		float2 discUv = uvOffset + 0.5;
		float3 sampleRgb = g_tMoonTexture.SampleLevel( g_sMoon, discUv, 0 ).rgb;
		return sampleRgb * tintColor * brightness * g_flMoonTextureBrightness;
	}

	float3 CelestialDiscColor(
		float3 rayDir,
		float3 bodyDir,
		float discDegrees,
		Texture2D discTexture,
		float3 tintColor,
		float brightness,
		float fullBrightDisc )
	{
		float mask = CelestialDiscMask( rayDir, bodyDir, discDegrees );
		if ( mask <= 0.001 )
			return float3( 0.0, 0.0, 0.0 );

		bodyDir = normalize( bodyDir );
		float cosAngle = dot( rayDir, bodyDir );
		float discRadius = max( radians( discDegrees ), 0.001 );

		float luma = 1.0;
		float3 surfaceColor = tintColor;

		if ( fullBrightDisc > 0.5 )
		{
			if ( cosAngle < 0.9995 )
			{
				float3 upRef = abs( bodyDir.z ) < 0.999 ? float3( 0.0, 0.0, 1.0 ) : float3( 0.0, 1.0, 0.0 );
				float3 tangent = normalize( cross( upRef, bodyDir ) );
				float3 bitangent = cross( bodyDir, tangent );

				float sinTheta = sqrt( saturate( 1.0 - cosAngle * cosAngle ) );
				float phi = atan2( dot( rayDir, bitangent ), dot( rayDir, tangent ) );
				float radial = saturate( sinTheta / discRadius );
				float2 discUv = float2( cos( phi ), sin( phi ) ) * radial * 0.5 + 0.5;

				float texLuma = dot( discTexture.SampleLevel( g_sSky, discUv, 0 ).rgb, float3( 0.2126, 0.7152, 0.0722 ) );
				float centerDetail = (1.0 - radial) * (1.0 - radial);
				luma = lerp( 1.0, max( texLuma, 1.0 ), centerDetail * 0.2 );
			}

			return tintColor * luma * brightness;
		}

		return MoonDiscColor( rayDir, bodyDir, discDegrees, tintColor, brightness );
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

		float sunriseW = g_flSunriseAmount;
		float sunsetW = g_flSunsetAmount;
		// Extra safety: do not keep warm twilight once night owns the blend.
		float deepNight = saturate( (g_flNightAmount - 0.35) / 0.65 );
		sunriseW *= 1.0 - deepNight;
		sunsetW *= 1.0 - deepNight;

		float blendTotal = g_flDayAmount + sunriseW + sunsetW + g_flNightAmount;
		float invBlend = 1.0 / max( blendTotal, 0.0001 );

		float3 skyGradient = dayGrad * g_flDayAmount
			+ sunriseGrad * sunriseW
			+ sunsetGrad * sunsetW
			+ nightGrad * g_flNightAmount;
		skyGradient *= invBlend;

		float horizonWarmth = pow( 1.0 - gradientT, 2.5 );
		float twilightAmt = saturate( sunriseW + sunsetW );
		skyGradient = lerp(
			skyGradient,
			lerp( g_vSunriseHorizonColor, g_vSunsetHorizonColor, sunsetW / max( sunriseW + sunsetW, 0.001 ) ),
			horizonWarmth * twilightAmt * 0.55 );

		float milkyReveal = saturate( g_flMilkyWayIntensity ) * saturate( g_flNightAmount );

		// Near-black night wash so the milky-way base texture doesn't dominate.
		float3 blackNight = VerticalGradient(
			g_vNightHorizonColor * 0.35,
			g_vNightZenithColor * 0.15,
			gradientT );

		float3 milkyWay = g_tMilkyWayTexture.Sample( g_sSky, uv ).rgb;
		// Soften into the dark gradient, but keep a readable band.
		milkyWay = pow( saturate( milkyWay ), 1.2 );
		milkyWay *= g_flMilkyWayBrightness * milkyReveal * 0.55;

		float stars = 0.0;
		if ( g_flStarIntensity > 0.001 && g_flNightAmount > 0.05 )
			stars = NoiseIlluminatedStars( uv ) * g_flStarIntensity * saturate( g_flNightAmount ) * 2.4;

		float3 nightLayer = blackNight;
		nightLayer = lerp( nightLayer, nightLayer + milkyWay, milkyReveal );

		float gradientCover = saturate( g_flDayAmount + sunriseW * 0.85 + sunsetW * 0.85 );
		// Night owns more of the sky once dark — keep black gradient over the base texture.
		gradientCover *= 1.0 - saturate( g_flNightAmount ) * 0.92;

		float3 color = lerp( nightLayer, skyGradient, gradientCover );
		// Add stars after the sky blend so they always read on top of the night wash.
		color += stars * float3( 0.95, 0.97, 1.0 );

		float sunGlow = CelestialGlow( vRay, g_vSunDirection, g_flSunGlowSize, g_flSunGlowStrength );
		float moonGlow = CelestialGlow( vRay, g_vMoonDirection, g_flMoonGlowSize, g_flMoonGlowStrength );
		float sunMask = CelestialDiscMask( vRay, g_vSunDirection, g_flSunDiscSize );
		float moonMask = MoonRadialMask( vRay, g_vMoonDirection, g_flMoonDiscSize );
		float3 sunDisc = CelestialDiscColor( vRay, g_vSunDirection, g_flSunDiscSize, g_tSunTexture, g_vSunDiscColor, g_flSunBrightness, 1.0 );
		// Keep disc albedo bright; use g_flMoonBrightness as visibility/blend, not as RGB scale
		// (scaling then lerping punched a black hole in the sky while the moon was rising).
		float moonVis = saturate( g_flMoonBrightness );
		float3 moonDisc = MoonDiscColor( vRay, g_vMoonDirection, g_flMoonDiscSize, g_vMoonDiscColor, 1.0 );

		color += g_vSunDiscColor * sunGlow * saturate( g_flSunBrightness );
		color += SunLensFlare( vRay, g_vSunDirection, g_vSunFlareColor, g_flSunFlareStrength * g_flSunBrightness );
		color += g_vMoonDiscColor * moonGlow * g_flNightAmount * moonVis;
		color = max( color, sunDisc * sunMask );

		float moonBlend = moonMask * (1.0 - sunMask * 0.85) * moonVis;
		color = lerp( color, moonDisc, moonBlend );

		color *= 1.0 - g_flWeatherDarkness * 0.65;

		o.vColor0 = float4( max( color, 0.0 ), 1.0 );
		return o;
	}
}
