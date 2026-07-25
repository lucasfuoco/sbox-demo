HEADER
{
	Description = "Realistic water for oceans, rivers, lakes and pools";
	Version = 1;
	DevShader = true;
}

FEATURES
{
	#include "common/features.hlsl"
	Feature( F_TRANSLUCENT, 0..1, "Rendering" );
}

MODES
{
	Forward();
	Depth();
	ToolsShadingComplexity( "tools_shading_complexity.shader" );
}

COMMON
{
	#include "common/shared.hlsl"
	#include "procedural.hlsl"

	#define S_UV2 1
}

struct VertexInput
{
	#include "common/vertexinput.hlsl"
	float4 vColor : COLOR0 < Semantic( Color ); >;
};

struct PixelInput
{
	#include "common/pixelinput.hlsl"
	float3 vPositionOs : TEXCOORD14;
	float3 vNormalOs : TEXCOORD15;
	float4 vTangentUOs_flTangentVSign : TANGENT < Semantic( TangentU_SignV ); >;
	float4 vColor : COLOR0;
	float4 vTintColor : COLOR1;
	// x = crest steepness mask from geometric waves (0 flat .. 1 steep)
	float flWaveCrest : TEXCOORD16;
	#if ( PROGRAM == VFX_PROGRAM_PS )
		bool vFrontFacing : SV_IsFrontFace;
	#endif
};

VS
{
	#include "common/vertex.hlsl"

	float g_flWavesIntensity < Attribute( "WavesIntensity" ); Default1( 4 ); >;
	float g_flWavesSpeed < Attribute( "WavesSpeed" ); Default1( 0.3 ); >;
	float g_flWavesScale < Attribute( "WavesScale" ); Default1( 0.05 ); >;
	float2 g_vWavesDirection < Attribute( "WavesDirection" ); Default2( 1, 0.5 ); >;
	int g_nWavesOctaves < Attribute( "WavesOctaves" ); Default1( 3 ); >;
	float g_flWavesLacunarity < Attribute( "WavesLacunarity" ); Default1( 2.0 ); >;
	float g_flWavesPersistence < Attribute( "WavesPersistence" ); Default1( 0.5 ); >;
	float g_flWavesSteepness < Attribute( "WavesSteepness" ); Default1( 0.5 ); >;

	float g_flSwellIntensity < Attribute( "SwellIntensity" ); Default1( 15 ); >;
	float g_flSwellSpeed < Attribute( "SwellSpeed" ); Default1( 0.1 ); >;
	float g_flSwellScale < Attribute( "SwellScale" ); Default1( 0.002 ); >;
	float2 g_vSwellDirection < Attribute( "SwellDirection" ); Default2( 0.7, 0.3 ); >;
	int g_nSwellOctaves < Attribute( "SwellOctaves" ); Default1( 2 ); >;
	float g_flSwellLacunarity < Attribute( "SwellLacunarity" ); Default1( 1.8 ); >;
	float g_flSwellPersistence < Attribute( "SwellPersistence" ); Default1( 0.6 ); >;
	float g_flSwellSteepness < Attribute( "SwellSteepness" ); Default1( 0.3 ); >;

	float g_flWaterTime < Attribute( "WaterTime" ); Default1( 0 ); >;

	float g_flWaveNormalEpsScale < Attribute( "WaveNormalEpsScale" ); Default1( 0.047 ); >;
	float g_flWaveNormalEpsMin < Attribute( "WaveNormalEpsMin" ); Default1( 8 ); >;

	int g_nRippleCount < Attribute( "RippleCount" ); Default1( 0 ); >;
	float g_flRippleAmplitude < Attribute( "RippleAmplitude" ); Default1( 8 ); >;
	float g_flRippleSpeed < Attribute( "RippleSpeed" ); Default1( 250 ); >;
	float g_flRippleDamping < Attribute( "RippleDamping" ); Default1( 1.5 ); >;
	StructuredBuffer<float4> g_vRippleData < Attribute( "RippleData" ); >;

	// GodotOceanWaves-style FFT cascade maps (atlas: cascade stacked on Y).
	// Bound from the game project via Material.Attributes (no Libraries/ edits).
	int g_nUseOceanFft < Attribute( "UseOceanFft" ); Default( 0 ); >;
	int g_nOceanFftCascades < Attribute( "OceanFftCascades" ); Default( 0 ); >;
	int g_nOceanFftCascadeCapacity < Attribute( "OceanFftCascadeCapacity" ); Default( 2 ); >;
	float g_flOceanFftFadeStart < Attribute( "OceanFftFadeStart" ); Default1( 5900 ); >;
	float g_flOceanFftFadeRate < Attribute( "OceanFftFadeRate" ); Default1( 0.00018 ); >;
	float g_flOceanFftDetailFade < Attribute( "OceanFftDetailFade" ); Default1( 23600 ); >;
	float4 g_vOceanFftScale0 < Attribute( "OceanFftScale0" ); Default4( 0, 0, 0, 0 ); >;
	float4 g_vOceanFftScale1 < Attribute( "OceanFftScale1" ); Default4( 0, 0, 0, 0 ); >;
	float4 g_vOceanFftScale2 < Attribute( "OceanFftScale2" ); Default4( 0, 0, 0, 0 ); >;
	float4 g_vOceanFftScale3 < Attribute( "OceanFftScale3" ); Default4( 0, 0, 0, 0 ); >;
	Texture2D g_tOceanFftDisplacement < Attribute( "OceanFftDisplacement" ); SrgbRead( false ); >;
	Texture2D g_tOceanFftNormal < Attribute( "OceanFftNormal" ); SrgbRead( false ); >;
	SamplerState g_sOceanFft < Filter( Anisotropic ); AddressU( WRAP ); AddressV( WRAP ); >;

	float4 GetOceanFftScale( int cascade )
	{
		if ( cascade == 0 ) return g_vOceanFftScale0;
		if ( cascade == 1 ) return g_vOceanFftScale1;
		if ( cascade == 2 ) return g_vOceanFftScale2;
		return g_vOceanFftScale3;
	}

	float2 OceanFftAtlasUV( float2 worldXY, float4 scales, int cascade )
	{
		float2 uv = frac( worldXY * scales.xy );
		float invCap = 1.0 / max( (float)g_nOceanFftCascadeCapacity, 1.0 );
		return float2( uv.x, ( (float)cascade + uv.y ) * invCap );
	}

	// One pass: displacement + slope gradient + foam. Avoids 3x finite-difference sampling.
	void SampleOceanFft( float2 worldXY, out float3 displacement, out float2 gradient, out float foam )
	{
		displacement = 0;
		gradient = 0;
		foam = 0;

		float dist = length( worldXY - g_vCameraPositionWs.xy );
		// Match GodotOceanWaves: full strength until ~150m, then exponential fade (scaled to world units).
		float distanceFactor = min( exp( -( dist - g_flOceanFftFadeStart ) * g_flOceanFftFadeRate ), 1.0 );
		int cascadeCount = g_nOceanFftCascades;
		if ( cascadeCount > 1 && dist > g_flOceanFftDetailFade )
			cascadeCount = 1;

		[loop]
		for ( int i = 0; i < cascadeCount; i++ )
		{
			float4 scales = GetOceanFftScale( i );
			float2 atlasUv = OceanFftAtlasUV( worldXY, scales, i );
			displacement += g_tOceanFftDisplacement.SampleLevel( g_sOceanFft, atlasUv, 0 ).xyz * scales.z;
			float4 nrm = g_tOceanFftNormal.SampleLevel( g_sOceanFft, atlasUv, 0 );
			gradient += nrm.xy * scales.w;
			foam += nrm.a;
		}

		displacement *= distanceFactor;
		gradient *= distanceFactor;
		foam = saturate( foam );
	}

	// Must match WaterWaveUtility / WaterManager CPU Gerstner.
	float3 ComputeGerstner( float2 worldXY, float scale, float speed, float2 dir, int octaves, float lacunarity, float persistence, float steepness, float time )
	{
		float2 wDir = normalize( dir );
		float t = time * speed;

		float3 displacement = float3( 0, 0, 0 );
		float amp = 1.0;
		float freq = scale;
		float maxAmp = 0;

		for ( int oct = 0; oct < octaves; oct++ )
		{
			float angle = oct * 1.2;
			float2 octDir = float2(
				wDir.x * cos( angle ) - wDir.y * sin( angle ),
				wDir.x * sin( angle ) + wDir.y * cos( angle )
			);

			float phase = freq * dot( octDir, worldXY ) + t * freq * 0.5;
			displacement.xy += steepness * amp * octDir * cos( phase );
			displacement.z += amp * sin( phase );

			maxAmp += amp;
			amp *= persistence;
			freq *= lacunarity;
		}

		return displacement / maxAmp;
	}

	float ComputeRipples( float2 worldXY )
	{
		if ( g_nRippleCount <= 0 )
			return 0.0;

		float z = 0.0;

		[loop]
		for ( int r = 0; r < g_nRippleCount; r++ )
		{
			float4 row0 = g_vRippleData[r * 2 + 0];
			float4 row1 = g_vRippleData[r * 2 + 1];

			float2 center = row0.xy;
			float startT = row0.z;
			float strength = row0.w;
			float wavelength = row1.x;
			float width = row1.y;

			float age = g_flWaterTime - startT;
			if ( age < 0.0 )
				continue;

			float freq = wavelength > 0.001 ? ( 6.28318530718 / wavelength ) : 0.0;
			float invWidthSq = width > 0.001 ? 1.0 / ( width * width ) : 0.0;

			float d = length( worldXY - center );
			float ring = age * g_flRippleSpeed;
			float ringDelta = d - ring;

			float spatialEnv = exp( -ringDelta * ringDelta * invWidthSq );
			float timeEnv = exp( -age * g_flRippleDamping );
			float wave = sin( ringDelta * freq );

			z += wave * spatialEnv * timeEnv * g_flRippleAmplitude * strength;
		}

		return z;
	}

	float3 TotalDisplacementGerstner( float2 worldXY )
	{
		float3 detail = ComputeGerstner( worldXY, g_flWavesScale, g_flWavesSpeed, g_vWavesDirection, g_nWavesOctaves, g_flWavesLacunarity, g_flWavesPersistence, g_flWavesSteepness, g_flWaterTime ) * g_flWavesIntensity;
		float3 swell = ComputeGerstner( worldXY, g_flSwellScale, g_flSwellSpeed, g_vSwellDirection, g_nSwellOctaves, g_flSwellLacunarity, g_flSwellPersistence, g_flSwellSteepness, g_flWaterTime ) * g_flSwellIntensity;
		float3 disp = detail + swell;
		disp.z += ComputeRipples( worldXY );
		return disp;
	}

	PixelInput MainVs( VertexInput v )
	{
		PixelInput i = ProcessVertex( v );
		i.vPositionOs = v.vPositionOs.xyz;
		i.vColor = v.vColor;

		ExtraShaderData_t extraShaderData = GetExtraPerInstanceShaderData( v.nInstanceTransformID );
		i.vTintColor = extraShaderData.vTint;

		VS_DecodeObjectSpaceNormalAndTangent( v, i.vNormalOs, i.vTangentUOs_flTangentVSign );

		// Clipmap vertices are authored in world space; keep them there (see WaterTool notes).
		i.vPositionWs.xyz = v.vPositionOs.xyz;

		float2 worldXY = i.vPositionWs.xy;
		float3 basePos = i.vPositionWs.xyz;

		float3 d0;
		float3 waveNormal;
		float3 tangentX;
		float3 tangentY;

		if ( g_nUseOceanFft != 0 && g_nOceanFftCascades > 0 )
		{
			float2 gradient;
			float foam;
			SampleOceanFft( worldXY, d0, gradient, foam );
			d0.z += ComputeRipples( worldXY );

			// Z-up normal from FFT slope (Godot used Y-up: (-gx, 1, -gz)).
			waveNormal = normalize( float3( -gradient.x, -gradient.y, 1.0 ) );
			tangentX = normalize( float3( 1.0, 0.0, gradient.x ) );
			tangentY = normalize( float3( 0.0, 1.0, gradient.y ) );
			i.flWaveCrest = foam;
		}
		else
		{
			float distToCam = distance( worldXY, g_vCameraPositionWs.xy );
			float eps = max( g_flWaveNormalEpsMin, distToCam * g_flWaveNormalEpsScale );
			d0 = TotalDisplacementGerstner( worldXY );
			float3 dX = TotalDisplacementGerstner( worldXY + float2( eps, 0.0 ) );
			float3 dY = TotalDisplacementGerstner( worldXY + float2( 0.0, eps ) );

			tangentX = float3( eps, 0.0, 0.0 ) + ( dX - d0 );
			tangentY = float3( 0.0, eps, 0.0 ) + ( dY - d0 );
			waveNormal = normalize( cross( tangentX, tangentY ) );
			i.flWaveCrest = saturate( 1.0 - waveNormal.z );
		}

		i.vPositionWs.xyz = basePos + d0;
		i.vPositionPs.xyzw = Position3WsToPs( i.vPositionWs.xyz );

		i.vNormalWs = waveNormal;
		i.vTangentUWs = normalize( tangentX );
		i.vTangentVWs = normalize( tangentY );

		return FinalizeVertex( i );
	}
}

PS
{
	#include "common/pixel.hlsl"
	#include "water_inclusion_volume.fxc"
	#include "water_exclusion_volume.fxc"
	#include "water_hull_exclusion.fxc"

	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT, Sys( ALL ) );

	RenderState( CullMode, F_RENDER_BACKFACES ? NONE : DEFAULT );

	Texture2D g_tFrameBufferCopyTexture < Attribute( "FrameBufferCopyTexture" ); SrgbRead( false ); >;

	CreateInputTexture2D( MainNormal, Linear, 8, "NormalizeNormals", "_normal", "Normals,0/,0/0", DefaultFile( "materials/default/default_normal.tga" ) );
	CreateInputTexture2D( SecondNormal, Linear, 8, "NormalizeNormals", "_normal", "Normals,0/,0/0", DefaultFile( "materials/default/default_normal.tga" ) );
	Texture2D g_tMainNormal < Channel( RGBA, Box( MainNormal ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	Texture2D g_tSecondNormal < Channel( RGBA, Box( SecondNormal ), Linear ); OutputFormat( DXT5 ); SrgbRead( False ); >;
	TextureAttribute( LightSim_DiffuseAlbedoTexture, g_tSecondNormal )
	TextureAttribute( RepresentativeTexture, g_tSecondNormal )

	// ── Normals / flow ──
	float2 g_vNormalTiling < Attribute( "NormalTiling" ); Default2( 50, 50 ); >;
	float g_flSpeedMainNormal < UiGroup( "Normals,0/,0/0" ); Default1( 50 ); Range1( -1000, 1000 ); >;
	float g_flSpeedSecondNormal < UiGroup( "Normals,0/,0/0" ); Default1( -25 ); Range1( -1000, 1000 ); >;
	float g_flNormalStrength < UiType( Slider ); UiGroup( "Normals,0/,0/0" ); Default1( 0.35 ); Range1( 0, 2 ); >;
	float2 g_vFlowDirection < UiGroup( "Flow,0/,0/0" ); Default2( 1, 0 ); >;
	float g_flFlowSpeed < UiType( Slider ); UiGroup( "Flow,0/,0/0" ); Default1( 0 ); Range1( 0, 5 ); >;

	// ── Refraction ──
	float g_flRefractionStrength < UiType( Slider ); UiGroup( "Refraction,0/,0/0" ); Default1( 0.08 ); Range1( 0, 1 ); >;

	// ── Depth / absorption ──
	float4 g_vShallowColor < UiType( Color ); UiGroup( "Depth,0/,0/0" ); Default4( 0.25, 0.65, 0.62, 0.45 ); >;
	float4 g_vDeepColor < UiType( Color ); UiGroup( "Depth,0/,0/0" ); Default4( 0.02, 0.12, 0.22, 0.92 ); >;
	float3 g_vScatterColor < UiType( Color ); UiGroup( "Depth,0/,1/0" ); Default3( 0.05, 0.35, 0.40 ); >;
	float g_flDepthMax < Attribute( "DepthMax" ); Default1( 1000 ); >;
	float g_flDepthMultiplier < UiGroup( "Depth,0/,0/0" ); Default1( 1 ); Range1( 0, 2 ); >;
	float g_flDepthFalloff < UiGroup( "Depth,0/,0/0" ); Default1( 0.65 ); Range1( 0, 2 ); >;
	float g_flDepthBlend < UiGroup( "Depth,0/,0/0" ); Default1( 0.85 ); Range1( 0, 1 ); >;
	float g_flAbsorption < UiType( Slider ); UiGroup( "Depth,0/,1/0" ); Default1( 0.035 ); Range1( 0, 0.2 ); >;
	float g_flShoreOpacity < UiType( Slider ); UiGroup( "Depth,0/,2/0" ); Default1( 0 ); Range1( 0, 1 ); >;
	float g_flShoreOpacityRange < UiGroup( "Depth,0/,2/0" ); Default1( 8 ); Range1( 0, 1000 ); >;

	// ── Caustics ──
	float g_flCausticsThresholdMin < UiGroup( "Caustics,0/,0/0" ); Default1( 0.35 ); Range1( 0, 2 ); >;
	float g_flCausticsThresholdMax < UiGroup( "Caustics,0/,0/0" ); Default1( 1.6 ); Range1( 0, 2 ); >;
	float g_flCausticsTilingMultiplier < UiGroup( "Caustics,0/,0/0" ); Default1( 1.25 ); Range1( 0.1, 10 ); >;
	float g_flCausticsScrollSpeed < UiGroup( "Caustics,0/,0/0" ); Default1( 0.012 ); Range1( 0, 0.1 ); >;
	float g_flCausticsAnimSpeed < UiGroup( "Caustics,0/,0/0" ); Default1( 1.2 ); Range1( 0.1, 10 ); >;
	float g_flCausticsIntensity < UiGroup( "Caustics,0/,0/0" ); Default1( 0.15 ); Range1( 0, 1 ); >;

	// ── Shore foam ──
	float4 g_vFoamColor < UiType( Color ); UiGroup( "Foam,0/,0/0" ); Default4( 0.92, 0.95, 0.97, 1 ); >;
	float g_flFoamDepth < UiType( Slider ); UiGroup( "Foam,0/,0/0" ); Default1( 40 ); Range1( 0, 500 ); >;
	float g_flFoamFalloff < UiType( Slider ); UiGroup( "Foam,0/,0/0" ); Default1( 1.8 ); Range1( 0.1, 5 ); >;
	float g_flFoamIntensity < UiType( Slider ); UiGroup( "Foam,0/,0/0" ); Default1( 1.2 ); Range1( 0, 10 ); >;
	float g_flFoamNoiseScale < UiGroup( "Foam,0/,0/0" ); Default1( 18 ); Range1( 1, 100 ); >;
	float g_flFoamNoiseSpeed < UiType( Slider ); UiGroup( "Foam,0/,0/0" ); Default1( 0.35 ); Range1( 0, 2 ); >;
	float g_flFoamSoftness < UiType( Slider ); UiGroup( "Foam,0/,0/0" ); Default1( 1.2 ); Range1( 0, 5 ); >;
	float g_flFoamCoverage < UiType( Slider ); UiGroup( "Foam,0/,0/0" ); Default1( 0.45 ); Range1( 0, 5 ); >;
	float g_flFoamEdgeWarp < UiType( Slider ); UiGroup( "Foam,0/,0/0" ); Default1( 0.55 ); Range1( 0, 1 ); >;
	float g_flFoamEdgeScale < UiGroup( "Foam,0/,0/0" ); Default1( 5 ); Range1( 0.5, 30 ); >;
	float g_flFoamEdgeSpeed < UiType( Slider ); UiGroup( "Foam,0/,0/0" ); Default1( 0.12 ); Range1( 0, 1 ); >;
	float g_flCrestFoamIntensity < UiType( Slider ); UiGroup( "Foam,0/,1/0" ); Default1( 0.65 ); Range1( 0, 3 ); >;
	float g_flCrestFoamThreshold < UiType( Slider ); UiGroup( "Foam,0/,1/0" ); Default1( 0.35 ); Range1( 0, 1 ); >;

	// ── Fresnel / reflection ──
	float g_flFresnelF0 < UiType( Slider ); UiGroup( "Fresnel,0/,0/0" ); Default1( 0.02 ); Range1( 0, 0.2 ); >;
	float g_flFresnelPower < UiType( Slider ); UiGroup( "Fresnel,0/,0/0" ); Default1( 5 ); Range1( 0.5, 12 ); >;
	float4 g_vFresnelColor < UiType( Color ); UiGroup( "Fresnel,0/,0/0" ); Default4( 0.55, 0.72, 0.82, 1 ); >;
	bool g_bUseScreenSpaceReflection < UiGroup( "Reflection,0/,0/10" ); Default1( 1 ); >;
	float g_flReflectionStrength < UiType( Slider ); UiGroup( "Reflection,0/,0/20" ); Default1( 0.85 ); Range1( 0, 1 ); >;
	float g_flFoamReflectionStrength < UiType( Slider ); UiGroup( "Reflection,0/,0/30" ); Default1( 0.15 ); Range1( 0, 1 ); >;
	float g_flReflectionStepSize < UiType( Slider ); UiGroup( "Reflection,0/,0/40" ); Default1( 1200 ); Range1( 10, 4000 ); >;
	float3 g_vHorizonColor < UiType( Color ); UiGroup( "Reflection,0/,1/0" ); Default3( 0.45, 0.62, 0.78 ); >;
	float g_flHorizonStrength < UiType( Slider ); UiGroup( "Reflection,0/,1/0" ); Default1( 0.35 ); Range1( 0, 1 ); >;

	// ── Specular / SSS ──
	float3 g_vSunDirection < UiGroup( "Lighting,0/,0/0" ); Default3( 0.35, 0.55, 0.75 ); >;
	float3 g_vSunColor < UiType( Color ); UiGroup( "Lighting,0/,0/0" ); Default3( 1.0, 0.96, 0.88 ); >;
	float g_flSpecularIntensity < UiType( Slider ); UiGroup( "Lighting,0/,0/0" ); Default1( 1.4 ); Range1( 0, 5 ); >;
	float g_flSpecularPower < UiType( Slider ); UiGroup( "Lighting,0/,0/0" ); Default1( 256 ); Range1( 8, 2048 ); >;
	float g_flGlitterIntensity < UiType( Slider ); UiGroup( "Lighting,0/,1/0" ); Default1( 0.55 ); Range1( 0, 3 ); >;
	float g_flGlitterScale < UiGroup( "Lighting,0/,1/0" ); Default1( 28 ); Range1( 1, 120 ); >;
	float g_flSubsurfaceIntensity < UiType( Slider ); UiGroup( "Lighting,0/,2/0" ); Default1( 0.45 ); Range1( 0, 2 ); >;
	float3 g_vSubsurfaceColor < UiType( Color ); UiGroup( "Lighting,0/,2/0" ); Default3( 0.05, 0.45, 0.42 ); >;

	// ── Surface ──
	float g_flRoughness < UiType( Slider ); UiGroup( "Surface,0/,0/0" ); Default1( 0.08 ); Range1( 0, 1 ); >;
	float g_flContrast < UiType( Slider ); UiGroup( "Surface,0/,0/0" ); Default1( 1.05 ); Range1( 0, 2 ); >;

	bool g_bRequireWaterInclusionVolumes < Attribute( "RequireWaterInclusionVolumes" ); Default( 0 ); >;
	bool g_bUseHybridInclusionBounds < Attribute( "UseHybridInclusionBounds" ); Default1( 0 ); >;
	float2 g_vHybridInclusionBoundsMin < Attribute( "HybridInclusionBoundsMin" ); Default2( 0, 0 ); >;
	float2 g_vHybridInclusionBoundsMax < Attribute( "HybridInclusionBoundsMax" ); Default2( 0, 0 ); >;

	float3 BlendNormals( float3 a, float3 b )
	{
		return normalize( float3( a.xy + b.xy, a.z * b.z ) );
	}

	float4 Hash4( float2 p )
	{
		return frac( sin( float4(
			1.0 + dot( p, float2( 37.0, 17.0 ) ),
			2.0 + dot( p, float2( 11.0, 47.0 ) ),
			3.0 + dot( p, float2( 41.0, 29.0 ) ),
			4.0 + dot( p, float2( 23.0, 31.0 ) )
		) ) * 103.0 );
	}

	float3 SampleNormalNoTile( Texture2D tex, SamplerState samp, float2 uv )
	{
		float2 iuv = floor( uv );
		float2 fuv = frac( uv );

		float4 ofa = Hash4( iuv + float2( 0, 0 ) );
		float4 ofb = Hash4( iuv + float2( 1, 0 ) );
		float4 ofc = Hash4( iuv + float2( 0, 1 ) );
		float4 ofd = Hash4( iuv + float2( 1, 1 ) );

		ofa.zw = sign( ofa.zw - 0.5 );
		ofb.zw = sign( ofb.zw - 0.5 );
		ofc.zw = sign( ofc.zw - 0.5 );
		ofd.zw = sign( ofd.zw - 0.5 );

		float2 uvddx = ddx( uv );
		float2 uvddy = ddy( uv );

		float2 uva = uv * ofa.zw + ofa.xy;
		float2 uvb = uv * ofb.zw + ofb.xy;
		float2 uvc = uv * ofc.zw + ofc.xy;
		float2 uvd = uv * ofd.zw + ofd.xy;

		float3 sa = DecodeNormal( tex.SampleGrad( samp, uva, uvddx * ofa.zw, uvddy * ofa.zw ).xyz );
		float3 sb = DecodeNormal( tex.SampleGrad( samp, uvb, uvddx * ofb.zw, uvddy * ofb.zw ).xyz );
		float3 sc = DecodeNormal( tex.SampleGrad( samp, uvc, uvddx * ofc.zw, uvddy * ofc.zw ).xyz );
		float3 sd = DecodeNormal( tex.SampleGrad( samp, uvd, uvddx * ofd.zw, uvddy * ofd.zw ).xyz );

		sa.xy *= ofa.zw;
		sb.xy *= ofb.zw;
		sc.xy *= ofc.zw;
		sd.xy *= ofd.zw;

		float2 b = smoothstep( 0.25, 0.75, fuv );
		return normalize( lerp( lerp( sa, sb, b.x ), lerp( sc, sd, b.x ), b.y ) );
	}

	float ColorDodge( float base, float blend )
	{
		if ( base <= 0.0f ) return 0.0f;
		if ( blend >= 1.0f ) return 1.0f;
		return saturate( base / ( 1.0f - blend ) );
	}

	float3 ColorDodge3( float3 base, float3 blend )
	{
		return float3( ColorDodge( base.r, blend.r ), ColorDodge( base.g, blend.g ), ColorDodge( base.b, blend.b ) );
	}

	float SchlickFresnel( float nDotV, float f0, float power )
	{
		return f0 + ( 1.0 - f0 ) * pow( saturate( 1.0 - nDotV ), power );
	}

	float Hash12( float2 p )
	{
		float3 p3 = frac( float3( p.xyx ) * 0.1031 );
		p3 += dot( p3, p3.yzx + 33.33 );
		return frac( ( p3.x + p3.y ) * p3.z );
	}

	float4 MainPs( PixelInput i ) : SV_Target0
	{
		Material m = Material::Init( i );
		m.Albedo = float3( 1, 1, 1 );
		m.Normal = float3( 0, 0, 1 );
		m.Roughness = 1;
		m.Metalness = 0;
		m.AmbientOcclusion = 1;
		m.TintMask = 1;
		m.Opacity = 1;
		m.Emission = float3( 0, 0, 0 );
		m.Transmission = 0;

		float3 surfacePos = i.vPositionWithOffsetWs.xyz + g_vHighPrecisionLightingOffsetWs.xyz;
		bool withinHybridInclusionBounds = !g_bUseHybridInclusionBounds ||
			( surfacePos.x >= g_vHybridInclusionBoundsMin.x && surfacePos.x <= g_vHybridInclusionBoundsMax.x &&
			  surfacePos.y >= g_vHybridInclusionBoundsMin.y && surfacePos.y <= g_vHybridInclusionBoundsMax.y );

		if ( withinHybridInclusionBounds && g_bRequireWaterInclusionVolumes && g_iWaterInclusionVolumeCount <= 0 )
			discard;

		if ( withinHybridInclusionBounds && g_iWaterInclusionVolumeCount > 0 && CheckWaterInclusionVolume( surfacePos ) < 0.5 )
			discard;

		if ( CheckWaterExclusionVolume( surfacePos ) > 0.5 )
			discard;

		if ( CheckWaterHullExclusion( surfacePos ) > 0.5 )
			discard;

		// Flow-aware dual scrolling normals
		float2 flowDir = length( g_vFlowDirection ) > 0.001 ? normalize( g_vFlowDirection ) : float2( 1, 0 );
		float2 flowOffset = flowDir * g_flTime * g_flFlowSpeed;

		float mainNormalOffset = g_flTime / max( abs( g_flSpeedMainNormal ), 0.001 ) * sign( g_flSpeedMainNormal );
		float2 mainNormalUV = TileAndOffsetUv( i.vTextureCoords.xy, g_vNormalTiling, float2( mainNormalOffset, mainNormalOffset ) + flowOffset );
		float3 mainNormal = TransformNormal( SampleNormalNoTile( g_tMainNormal, g_sAniso, mainNormalUV ), i.vNormalWs, i.vTangentUWs, i.vTangentVWs );

		float secondNormalOffset = g_flTime / max( abs( g_flSpeedSecondNormal ), 0.001 ) * sign( g_flSpeedSecondNormal );
		float2 secondNormalUV = TileAndOffsetUv( i.vTextureCoords.xy, g_vNormalTiling * 1.37, float2( secondNormalOffset, secondNormalOffset ) - flowOffset * 0.65 );
		float3 secondNormal = TransformNormal( SampleNormalNoTile( g_tSecondNormal, g_sAniso, secondNormalUV ), i.vNormalWs, i.vTangentUWs, i.vTangentVWs );

		float3 blendedNormal = BlendNormals( mainNormal, secondNormal );
		float3 surfaceNormal = normalize( lerp( i.vNormalWs, blendedNormal, g_flNormalStrength ) );

		float2 screenUV = CalculateViewportUv( i.vPositionSs.xy );
		float3 scenePosRaw = Depth::GetWorldPosition( i.vPositionSs.xy );
		float rawWaterDepth = max( surfacePos.z - scenePosRaw.z, 0 );

		float cameraDist = length( surfacePos - g_vCameraPositionWs );
		float distanceScale = 1.0 / max( cameraDist * 0.01, 1.0 );
		float3 refractionOffset = surfaceNormal * g_flRefractionStrength * distanceScale;
		float2 distortedUV = refractionOffset.xy + screenUV;

		bool outOfBounds = any( distortedUV < 0.0 ) || any( distortedUV > 1.0 );
		float2 safeSS = outOfBounds ? i.vPositionSs.xy : ( distortedUV * g_vRenderTargetSize );
		float3 scenePos = Depth::GetWorldPosition( safeSS );
		bool refractedAboveWater = scenePos.z > surfacePos.z;
		float2 finalSampleUV = ( refractedAboveWater || outOfBounds ) ? screenUV : distortedUV;

		float4 sceneColor = g_tFrameBufferCopyTexture.Sample( g_sBilinearMirror, finalSampleUV );
		float3 finalScenePos = refractedAboveWater ? scenePosRaw : scenePos;
		float waterDepth = max( surfacePos.z - finalScenePos.z, 0 );

		// Beer-Lambert absorption + scatter body
		float opticalDepth = waterDepth * g_flAbsorption;
		float transmittance = exp( -opticalDepth );
		float normalizedDepth = saturate( waterDepth / max( g_flDepthMax * g_flDepthMultiplier, 0.001 ) );
		float depthGradient = pow( normalizedDepth, g_flDepthFalloff );
		float4 waterColor = lerp( g_vShallowColor, g_vDeepColor, depthGradient );

		float3 absorbedScene = sceneColor.rgb * transmittance;
		float3 scattered = g_vScatterColor * ( 1.0 - transmittance );
		float3 bodyColor = lerp( absorbedScene + scattered, waterColor.rgb, saturate( depthGradient * g_flDepthBlend ) );

		// Shallow caustics
		float2 causticsTiling = g_vNormalTiling * g_flCausticsTilingMultiplier;
		float2 causticsUV = TileAndOffsetUv( i.vTextureCoords.xy, causticsTiling, float2( g_flTime * g_flCausticsScrollSpeed, g_flTime * g_flCausticsScrollSpeed * 0.7 ) );
		float causticsNoise = VoronoiNoise( causticsUV, g_flTime * g_flCausticsAnimSpeed, 10 );
		float causticsPattern = smoothstep( g_flCausticsThresholdMin, g_flCausticsThresholdMax, causticsNoise );
		float shallowCausticMask = saturate( 1.0 - depthGradient * 1.4 ) * transmittance;
		bodyColor = lerp( bodyColor, ColorDodge3( bodyColor, float3( causticsPattern, causticsPattern, causticsPattern ) ), g_flCausticsIntensity * shallowCausticMask );

		float3 viewDirNorm = normalize( g_vCameraPositionWs - surfacePos );
		float foamMask = 0.0;
		float4 finalColor = float4( bodyColor, waterColor.a );

		// Shore foam
		[branch]
		if ( waterDepth < g_flFoamDepth * ( 1.0 + g_flFoamEdgeWarp ) && g_flFoamIntensity > 0.001 )
		{
			float2 edgeWarpUV = i.vTextureCoords.xy * g_flFoamEdgeScale * g_vNormalTiling.x;
			float edgeWarpTime = g_flTime * g_flFoamEdgeSpeed;
			float edgeWarp = Simplex2D( edgeWarpUV + float2( edgeWarpTime * 0.7, edgeWarpTime * 0.4 ) ) * 0.5 + 0.5;
			float warpedFoamDepth = g_flFoamDepth * lerp( 1.0 - g_flFoamEdgeWarp, 1.0 + g_flFoamEdgeWarp, edgeWarp );

			float foamNormDepth = saturate( waterDepth / max( warpedFoamDepth, 0.001 ) );
			float foamFalloffStart = 1.0 - ( 1.0 / max( g_flFoamFalloff + 1.0, 1.0 ) );
			float foamDepthMask = 1.0 - smoothstep( foamFalloffStart, 1.0, foamNormDepth );

			float foamTime = g_flTime * g_flFoamNoiseSpeed;
			float2 foamBaseUV = i.vTextureCoords.xy * g_flFoamNoiseScale * g_vNormalTiling.x + flowOffset * 0.25;
			float2 foamUV1 = foamBaseUV + float2( foamTime * 0.6, foamTime * 0.3 );
			float2 foamUV2 = foamBaseUV * 1.4 + float2( -foamTime * 0.4, foamTime * 0.5 ) + float2( 3.7, 8.2 );
			float foamCombined = ( Simplex2D( foamUV1 ) * 0.5 + 0.5 ) * ( Simplex2D( foamUV2 ) * 0.5 + 0.5 );
			float foamThreshold = Simplex2D( foamBaseUV * 0.2 + float2( foamTime * 0.08, -foamTime * 0.05 ) ) * 0.1 + 0.15;
			float foamNoise = smoothstep( foamThreshold - g_flFoamSoftness, foamThreshold + g_flFoamCoverage, foamCombined );
			float foamViewFade = saturate( dot( i.vNormalWs, viewDirNorm ) );

			foamMask = saturate( foamDepthMask * foamNoise ) * g_flFoamIntensity * foamViewFade;
			finalColor = lerp( finalColor, g_vFoamColor, foamMask );
		}

		// Wave-crest whitecaps
		float crest = smoothstep( g_flCrestFoamThreshold, 1.0, i.flWaveCrest );
		float crestNoise = Simplex2D( i.vTextureCoords.xy * g_flFoamNoiseScale * 0.35 + flowOffset + g_flTime * 0.05 ) * 0.5 + 0.5;
		float crestFoam = crest * crestNoise * g_flCrestFoamIntensity * saturate( dot( i.vNormalWs, viewDirNorm ) + 0.15 );
		finalColor = lerp( finalColor, g_vFoamColor, saturate( crestFoam ) );
		foamMask = saturate( foamMask + crestFoam );

		// Physically-based Fresnel
		float nDotV = saturate( dot( surfaceNormal, viewDirNorm ) );
		float fresnel = SchlickFresnel( nDotV, g_flFresnelF0, g_flFresnelPower );

		// Horizon fallback for grazing angles / failed SSR
		float horizon = saturate( 1.0 - nDotV );
		float3 reflectionFallback = lerp( g_vFresnelColor.rgb, g_vHorizonColor, horizon * g_flHorizonStrength );
		finalColor.rgb = lerp( finalColor.rgb, reflectionFallback, fresnel * 0.55 );

		// Screen-space reflection
		if ( g_bUseScreenSpaceReflection )
		{
			float3 reflDirWs = reflect( -viewDirNorm, surfaceNormal );
			float viewDot = saturate( dot( surfaceNormal, viewDirNorm ) );
			float angleFactor = lerp( 1.5, 0.25, viewDot );
			float heightFactor = saturate( abs( surfacePos.z - g_vCameraPositionWs.z ) * 0.01 );
			float stepSize = g_flReflectionStepSize * angleFactor * ( 0.5 + heightFactor );

			float3 virtualHit = surfacePos + reflDirWs * stepSize;
			float4 clipPos = Position3WsToPs( virtualHit );
			float2 reflUV = ( clipPos.xy / clipPos.w ) * 0.5 + 0.5;
			reflUV.y = 1.0 - reflUV.y;

			bool validUV = all( reflUV >= 0.0 ) && all( reflUV <= 1.0 );
			float2 edgeDist = abs( reflUV - 0.5 ) * 2.0;
			float ssrWeight = validUV ? ( 1.0 - smoothstep( 0.65, 1.0, max( edgeDist.x, edgeDist.y ) ) ) : 0.0;

			if ( ssrWeight > 0.0 )
			{
				float3 ssrColor = g_tFrameBufferCopyTexture.Sample( g_sPointClamp, reflUV ).rgb;
				float foamReflMod = lerp( 1.0, g_flFoamReflectionStrength, foamMask );
				float reflAmount = fresnel * g_flReflectionStrength * ssrWeight * foamReflMod;
				finalColor.rgb = lerp( finalColor.rgb, ssrColor, reflAmount );
			}
		}

		// Specular sun glitter — GGX (Atlas / GodotOceanWaves) with Blinn fallback via power.
		float3 sunDir = normalize( g_vSunDirection );
		float3 halfVec = normalize( sunDir + viewDirNorm );
		float nDotH = saturate( dot( surfaceNormal, halfVec ) );
		float a = max( g_flRoughness, 0.02 );
		float a2 = a * a;
		float dDenom = ( nDotH * nDotH ) * ( a2 - 1.0 ) + 1.0;
		float ggxD = a2 / max( 3.14159265 * dDenom * dDenom, 1e-5 );
		float blinn = pow( nDotH, g_flSpecularPower );
		float spec = lerp( blinn, ggxD, 0.85 ) * g_flSpecularIntensity;
		float sunFacing = saturate( sunDir.z * 2.0 + 0.2 );

		float2 glitterUv = i.vTextureCoords.xy * g_flGlitterScale * g_vNormalTiling.x;
		float glitter = Hash12( floor( glitterUv + g_flTime * 0.15 ) );
		glitter = pow( saturate( glitter ), 18.0 ) * g_flGlitterIntensity;
		float3 specular = g_vSunColor * ( spec + glitter * spec * 4.0 ) * sunFacing * ( 1.0 - foamMask * 0.7 );
		finalColor.rgb += specular;

		// Subsurface scattering through wave crests / thin water
		float wrap = saturate( dot( -surfaceNormal, sunDir ) * 0.5 + 0.5 );
		float sss = wrap * wrap * g_flSubsurfaceIntensity * ( 0.35 + i.flWaveCrest ) * transmittance;
		finalColor.rgb += g_vSubsurfaceColor * sss * g_vSunColor;

		finalColor.rgb = saturate( ( finalColor.rgb - 0.5 ) * g_flContrast + 0.5 );

		float shoreBlend = saturate( rawWaterDepth / max( g_flShoreOpacityRange, 0.001 ) );
		float shoreOpacity = lerp( g_flShoreOpacity, 1.0, shoreBlend );
		float opacity = saturate( shoreOpacity * waterColor.a );

		// Looking up from underwater: solid blue surface lid (swim feel).
		if ( !i.vFrontFacing )
		{
			float3 upNormal = -surfaceNormal;
			float upNdotV = saturate( dot( upNormal, viewDirNorm ) );
			float undersideFresnel = SchlickFresnel( upNdotV, 0.06, 4.0 );
			float3 underside = lerp( g_vDeepColor.rgb * 1.6, g_vFresnelColor.rgb * 1.35, undersideFresnel );
			underside += specular * 0.7;
			finalColor.rgb = underside;
			opacity = saturate( 0.94 + undersideFresnel * 0.06 );
			m.Emission = underside * 0.3;
		}
		else
		{
			m.Emission = specular * 0.35;
		}

		m.Albedo = finalColor.rgb;
		m.Opacity = opacity;
		m.Normal = surfaceNormal;
		m.Roughness = saturate( lerp( g_flRoughness, 0.55, foamMask ) );

		return ShadingModelStandard::Shade( m );
	}
}
