HEADER
{
	Description = "Underwater fill with fog and caustics";
	Version = 1;
	DevShader = true;
}

MODES
{
	Forward();
}

COMMON
{
	#include "postprocess/shared.hlsl"
}

struct VertexInput
{
	float3 pos : POSITION < Semantic( PosXyz ); >;
	float2 uv : TEXCOORD0 < Semantic( LowPrecisionUv ); >;
};

struct PixelInput
{
	float2 uv : TEXCOORD0;
	float4 pos : SV_Position;
};

VS
{
	PixelInput MainVs( VertexInput i )
	{
		PixelInput o;
		o.pos = float4( i.pos.xy, 0.0f, 1.0f );
		o.uv = i.uv;
		return o;
	}
}

PS
{
	#include "postprocess/common.hlsl"
	#include "postprocess/functions.hlsl"
	#include "procedural.hlsl"

	Texture2D colorBuffer < Attribute( "ColorBuffer" ); SrgbRead( true ); >;

	float3 g_vWaterColor < Attribute( "WaterColor" ); Default3( 0.28, 0.72, 0.88 ); >;
	float3 g_vDeepWaterColor < Attribute( "DeepWaterColor" ); Default3( 0.08, 0.28, 0.48 ); >;
	float3 g_vCausticsColor < Attribute( "CausticsColor" ); Default3( 0.85, 0.98, 1.0 ); >;
	float g_flFogDensity < Attribute( "FogDensity" ); Default1( 0.018 ); >;
	float g_flFogOpacity < Attribute( "FogOpacity" ); Default1( 0.55 ); >;
	float g_flCausticsIntensity < Attribute( "CausticsIntensity" ); Default1( 1.5 ); >;
	float g_flCausticsScale < Attribute( "CausticsScale" ); Default1( 0.007 ); >;
	float g_flCausticsSpeed < Attribute( "CausticsSpeed" ); Default1( 0.4 ); >;
	float g_flSurfaceZ < Attribute( "SurfaceZ" ); Default1( 0 ); >;
	float g_flMaxFogDepth < Attribute( "MaxFogDepth" ); Default1( 4500 ); >;
	float g_flGodRayIntensity < Attribute( "GodRayIntensity" ); Default1( 0.7 ); >;

	float SampleCaustics( float2 worldXY, float time )
	{
		float2 uvA = worldXY * g_flCausticsScale + float2( time * g_flCausticsSpeed, time * g_flCausticsSpeed * 0.65 );
		float2 uvB = worldXY * g_flCausticsScale * 1.37 + float2( -time * g_flCausticsSpeed * 0.75, time * g_flCausticsSpeed * 0.5 );
		float a = VoronoiNoise( uvA, time * 1.25, 10 );
		float b = VoronoiNoise( uvB + float2( 11.3, -7.1 ), time * 0.95, 10 );
		return pow( saturate( smoothstep( 0.2, 1.3, a * b ) ), 1.5 );
	}

	float4 MainPs( PixelInput i ) : SV_Target0
	{
		float2 uv = CalculateViewportUv( i.uv.xy );
		float3 sceneColor = colorBuffer.SampleLevel( g_sBilinearMirror, uv, 0 ).rgb;

		float3 worldPos = Depth::GetWorldPosition( i.pos.xy );
		float cameraDepth = max( g_flSurfaceZ - g_vCameraPositionWs.z, 0.0 );
		float viewDist = length( worldPos - g_vCameraPositionWs );

		// 0 at surface → 1 at MaxFogDepth. Upper ~55% stays shallow before darkening.
		float depthLinear = saturate( cameraDepth / max( g_flMaxFogDepth, 1.0 ) );
		float delayed = saturate( ( depthLinear - 0.55 ) / 0.45 );
		float depthFactor = delayed * delayed * ( 3.0 - 2.0 * delayed );

		// Distance haze only — never replace the whole frame with solid water.
		float density = lerp( g_flFogDensity * 0.55, g_flFogDensity, depthFactor );
		float fogAmount = saturate( ( 1.0 - exp( -viewDist * density ) ) * g_flFogOpacity );
		fogAmount = min( fogAmount, lerp( 0.28, 0.42, depthFactor ) );

		float3 sunDir = -g_DirectionalLightDirection.xyz;
		float sunHeight = max( saturate( dot( sunDir, float3( 0, 0, 1 ) ) ), 0.2 );

		float3 shallowLit = g_vWaterColor * lerp( 1.15, 1.55, sunHeight );
		float3 deepLit = g_vDeepWaterColor * lerp( 1.0, 1.25, sunHeight );
		float3 waterLit = lerp( shallowLit, deepLit, depthFactor );

		// Keep scene visible; tint/haze toward water color with depth.
		float waterLum = max( dot( waterLit, float3( 0.299, 0.587, 0.114 ) ), 0.08 );
		float3 tintedScene = sceneColor * lerp( float3( 1, 1, 1 ), waterLit / waterLum, depthFactor * 0.45 );
		float3 color = lerp( tintedScene, waterLit, fogAmount );

		float caustics = SampleCaustics( worldPos.xy, g_flTime );
		float shallowFade = lerp( 1.0, 0.45, depthFactor );
		color += g_vCausticsColor * caustics * g_flCausticsIntensity * shallowFade * ( 0.45 + sunHeight );

		float3 viewDir = normalize( worldPos - g_vCameraPositionWs );
		float lookUp = saturate( viewDir.z );
		float shaft = pow( lookUp, 2.8 ) * g_flGodRayIntensity * sunHeight * shallowFade;
		float shaftPattern = SampleCaustics( g_vCameraPositionWs.xy * 0.35 + viewDir.xy * 50.0, g_flTime * 0.65 );
		color += g_vCausticsColor * shaft * ( 0.45 + shaftPattern );

		// Soft absorption on distant geometry only.
		float absorbScale = lerp( 0.0002, 0.0008, depthFactor );
		float3 absorb = float3(
			exp( -viewDist * absorbScale * 1.4 ),
			exp( -viewDist * absorbScale * 0.8 ),
			exp( -viewDist * absorbScale * 0.45 ) );
		color *= lerp( float3( 1, 1, 1 ), absorb, 0.35 + depthFactor * 0.25 );

		color *= lerp( 1.06, 0.85, depthFactor );

		return float4( saturate( color ), 1 );
	}
}
