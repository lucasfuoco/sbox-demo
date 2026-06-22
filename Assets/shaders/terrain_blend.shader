HEADER
{
	Description = "Terrain multiblend with noise-based squiggly anti-tiling";
	Version = 1;
	DevShader = true;
}

FEATURES
{
	#include "common/features.hlsl"
	Feature( F_VERTEX_DISPLACEMENT, 0..1, "Displacement" );
}

MODES
{
	Forward();
	Depth( S_MODE_DEPTH );
	ToolsShadingComplexity( "tools_shading_complexity.shader" );
}

COMMON
{
	#include "common/shared.hlsl"

	#if ( PROGRAM == VFX_PROGRAM_PS ) || ( PROGRAM == VFX_PROGRAM_VS )
		float2 RotateTerrainUv( float2 uv, float degrees )
		{
			float rad = radians( degrees );
			float s = sin( rad );
			float c = cos( rad );
			return float2( uv.x * c - uv.y * s, uv.x * s + uv.y * c );
		}

		float HashTerrain1( float2 p, float seed )
		{
			float3 p3 = frac( float3( p.x, p.y, seed ) * float3( 0.1031, 0.1030, 0.0973 ) );
			p3 += dot( p3, p3.yzx + 33.33 );
			return frac( ( p3.x + p3.y ) * p3.z );
		}

		float TerrainValueNoise( float2 p, float seed )
		{
			float2 i = floor( p );
			float2 f = frac( p );
			float2 u = f * f * ( 3.0 - 2.0 * f );

			float a = HashTerrain1( i, seed );
			float b = HashTerrain1( i + float2( 1.0, 0.0 ), seed );
			float c = HashTerrain1( i + float2( 0.0, 1.0 ), seed );
			float d = HashTerrain1( i + float2( 1.0, 1.0 ), seed );

			return lerp( lerp( a, b, u.x ), lerp( c, d, u.x ), u.y );
		}

		float TerrainFbmNoise( float2 p, float seed )
		{
			float value = 0.0;
			value += TerrainValueNoise( p, seed ) * 0.5;
			value += TerrainValueNoise( p * 2.07 + 1.7, seed + 17.0 ) * 0.25;
			value += TerrainValueNoise( p * 4.31 + 3.1, seed + 43.0 ) * 0.125;
			return value / 0.875;
		}

		float SquigglyAntiTileBlend( float2 worldUv, float layerSeed, float frequency, float softness )
		{
			float2 p = worldUv * frequency + float2( layerSeed * 1.13, layerSeed * 0.71 );

			float2 warp;
			warp.x = TerrainValueNoise( p * 0.65 + 3.7, layerSeed ) * 2.0 - 1.0;
			warp.y = TerrainValueNoise( p * 0.65 + 9.1, layerSeed + 41.0 ) * 2.0 - 1.0;
			p += warp * 0.55;

			float noise = TerrainFbmNoise( p, layerSeed );
			float edge = lerp( 0.06, 0.42, softness );
			return smoothstep( 0.5 - edge, 0.5 + edge, noise );
		}

		float2 LayerBaseUv( float2 worldUv, float2 scale, float rotation, float2 layerOffset, float extraRotation )
		{
			float2 uv = worldUv * scale + layerOffset;
			return RotateTerrainUv( uv, rotation + extraRotation );
		}

		float2 WarpLayerUv( float2 uv, float layerSeed, float strength )
		{
			float2 p = uv * 0.11 + layerSeed;
			float wx = TerrainFbmNoise( p, layerSeed ) * 2.0 - 1.0;
			float wy = TerrainFbmNoise( p + 13.7, layerSeed + 29.0 ) * 2.0 - 1.0;
			return uv + float2( wx, wy ) * strength * 0.14;
		}

		float2 LayerAntiTileUvA(
			float2 worldUv,
			float2 scale,
			float rotation,
			float2 layerOffset,
			float layerSeed,
			float warpStrength )
		{
			float2 uv = LayerBaseUv( worldUv, scale, rotation, layerOffset, 0.0 );
			return WarpLayerUv( uv, layerSeed, warpStrength );
		}

		float2 LayerAntiTileUvB(
			float2 worldUv,
			float2 scale,
			float rotation,
			float2 layerOffset,
			float layerSeed,
			float variantRotation,
			float2 variantOffset,
			float variantScale,
			float warpStrength )
		{
			float2 uv = LayerBaseUv( worldUv, scale * variantScale, rotation, layerOffset + variantOffset, variantRotation );
			return WarpLayerUv( uv, layerSeed + 19.0, warpStrength );
		}

		float AntiTileBlendFactor(
			float2 worldUv,
			float layerSeed,
			float frequency,
			float strength,
			float softness )
		{
			float blend = SquigglyAntiTileBlend( worldUv, layerSeed, frequency, softness );
			return lerp( 0.0, blend, strength );
		}
	#endif
}

struct VertexInput
{
	float4 vColorBlendValues : TEXCOORD4 < Semantic( VertexPaintBlendParams ); >;
	float4 vColorPaintValues : TEXCOORD5 < Semantic( VertexPaintTintColor ); >;
	#include "common/vertexinput.hlsl"
};

struct PixelInput
{
	float4 vBlendValues : TEXCOORD14;
	float4 vPaintValues : TEXCOORD15;
	#include "common/pixelinput.hlsl"
};

VS
{
	#include "common/vertex.hlsl"

	StaticCombo( S_VERTEX_DISPLACEMENT, F_VERTEX_DISPLACEMENT, Sys( PC ) );

	CreateInputTexture2D( TextureDisplacementGrass, Linear, 8, "", "_disp", "Grass,10/50", Default( 0.5 ) );
	CreateInputTexture2D( TextureDisplacementSand, Linear, 8, "", "_disp", "Sand,10/50", Default( 0.5 ) );
	CreateInputTexture2D( TextureDisplacementRock, Linear, 8, "", "_disp", "Rock,10/50", Default( 0.5 ) );

	Texture2D g_tDispGrass < Channel( R, Box( TextureDisplacementGrass ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tDispSand < Channel( R, Box( TextureDisplacementSand ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tDispRock < Channel( R, Box( TextureDisplacementRock ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;

	float2 g_vScaleGrass < Default2( 1.0, 1.0 ); >;
	float g_flRotationGrass < Default( 0.0 ); >;
	float2 g_vOffsetGrass < Default2( 0.0, 0.0 ); >;
	float2 g_vScaleSand < Default2( 0.87, 0.93 ); >;
	float g_flRotationSand < Default( 47.0 ); >;
	float2 g_vOffsetSand < Default2( 0.31, 0.67 ); >;
	float2 g_vScaleRock < Default2( 1.14, 0.82 ); >;
	float g_flRotationRock < Default( 103.0 ); >;
	float2 g_vOffsetRock < Default2( 0.79, 0.23 ); >;
	float g_flAntiTileStrengthGrass < Default( 1.0 ); Range( 0.0, 1.0 ); UiGroup( "Anti-Tile,10/10" ); >;
	float g_flAntiTileStrengthSand < Default( 1.0 ); Range( 0.0, 1.0 ); UiGroup( "Anti-Tile,10/20" ); >;
	float g_flAntiTileStrengthRock < Default( 1.0 ); Range( 0.0, 1.0 ); UiGroup( "Anti-Tile,10/30" ); >;
	float g_flAntiTileFrequency < Default( 0.4 ); Range( 0.05, 2.0 ); UiGroup( "Anti-Tile,10/40" ); >;
	float g_flAntiTileSoftness < Default( 0.65 ); Range( 0.0, 1.0 ); UiGroup( "Anti-Tile,10/45" ); >;
	float g_flUvWarpStrengthGrass < Default( 0.6 ); Range( 0.0, 2.0 ); UiGroup( "Anti-Tile,10/50" ); >;
	float g_flUvWarpStrengthSand < Default( 0.55 ); Range( 0.0, 2.0 ); UiGroup( "Anti-Tile,10/60" ); >;
	float g_flUvWarpStrengthRock < Default( 0.65 ); Range( 0.0, 2.0 ); UiGroup( "Anti-Tile,10/70" ); >;

	float g_flDisplacementScaleGrass < Default( 4.0 ); Range( 0.0, 32.0 ); UiGroup( "Grass,10/60" ); >;
	float g_flDisplacementScaleSand < Default( 3.0 ); Range( 0.0, 32.0 ); UiGroup( "Sand,10/60" ); >;
	float g_flDisplacementScaleRock < Default( 8.0 ); Range( 0.0, 32.0 ); UiGroup( "Rock,10/60" ); >;

	float SampleDisplacement( float2 uv, Texture2D map )
	{
		return map.SampleLevel( g_sAniso, uv, 0 ).r;
	}

	float SampleLayerDisplacement(
		Texture2D map,
		float2 worldUv,
		float2 scale,
		float rotation,
		float2 layerOffset,
		float layerSeed,
		float variantRotation,
		float2 variantOffset,
		float variantScale,
		float warpStrength,
		float antiTileStrength )
	{
		float2 uvA = LayerAntiTileUvA( worldUv, scale, rotation, layerOffset, layerSeed, warpStrength );
		float2 uvB = LayerAntiTileUvB( worldUv, scale, rotation, layerOffset, layerSeed, variantRotation, variantOffset, variantScale, warpStrength );
		float blend = AntiTileBlendFactor( worldUv, layerSeed, g_flAntiTileFrequency, antiTileStrength, g_flAntiTileSoftness );

		float sampleA = SampleDisplacement( uvA, map );
		float sampleB = SampleDisplacement( uvB, map );
		return lerp( sampleA, sampleB, blend );
	}

	float BlendDisplacement( float2 worldUv, float3 weights )
	{
		float grass = ( SampleLayerDisplacement( g_tDispGrass, worldUv, g_vScaleGrass, g_flRotationGrass, g_vOffsetGrass, 17.3, 137.5, float2( 2.17, -1.83 ), 1.09, g_flUvWarpStrengthGrass, g_flAntiTileStrengthGrass ) - 0.5 ) * 2.0 * g_flDisplacementScaleGrass;
		float sand = ( SampleLayerDisplacement( g_tDispSand, worldUv, g_vScaleSand, g_flRotationSand, g_vOffsetSand, 41.9, 211.0, float2( -1.41, 3.26 ), 1.07, g_flUvWarpStrengthSand, g_flAntiTileStrengthSand ) - 0.5 ) * 2.0 * g_flDisplacementScaleSand;
		float rock = ( SampleLayerDisplacement( g_tDispRock, worldUv, g_vScaleRock, g_flRotationRock, g_vOffsetRock, 93.7, 283.0, float2( 3.08, 0.92 ), 1.11, g_flUvWarpStrengthRock, g_flAntiTileStrengthRock ) - 0.5 ) * 2.0 * g_flDisplacementScaleRock;

		return grass * weights.r + sand * weights.g + rock * weights.b;
	}

	PixelInput MainVs( VertexInput i )
	{
		PixelInput o = ProcessVertex( i );
		o.vBlendValues = i.vColorBlendValues;
		o.vPaintValues = i.vColorPaintValues;

		if ( o.vPaintValues.w == 0.0 )
			o.vPaintValues = 1.0;

		#if S_VERTEX_DISPLACEMENT
			float3 weights = saturate( o.vBlendValues.rgb );
			float displacement = BlendDisplacement( o.vTextureCoords.xy, weights );
			o.vPositionWs += o.vNormalWs * displacement;
			o.vPositionPs = Position3WsToPs( o.vPositionWs );
		#endif

		return FinalizeVertex( o );
	}
}

PS
{
	#include "common/pixel.hlsl"
	#include "common/utils/normal.hlsl"

	CreateInputTexture2D( TextureGrass, Srgb, 8, "", "_color", "Grass,10/10", Default3( 0.2, 0.45, 0.1 ) );
	CreateInputTexture2D( TextureRoughnessGrass, Linear, 8, "", "_rough", "Grass,10/20", Default( 0.85 ) );
	CreateInputTexture2D( TextureDisplacementGrass, Linear, 8, "", "_disp", "Grass,10/50", Default( 0.5 ) );

	CreateInputTexture2D( TextureSand, Srgb, 8, "", "_color", "Sand,10/10", Default3( 0.78, 0.72, 0.45 ) );
	CreateInputTexture2D( TextureRoughnessSand, Linear, 8, "", "_rough", "Sand,10/20", Default( 0.75 ) );
	CreateInputTexture2D( TextureDisplacementSand, Linear, 8, "", "_disp", "Sand,10/50", Default( 0.5 ) );

	CreateInputTexture2D( TextureRock, Srgb, 8, "", "_color", "Rock,10/10", Default3( 0.45, 0.42, 0.38 ) );
	CreateInputTexture2D( TextureRoughnessRock, Linear, 8, "", "_rough", "Rock,10/20", Default( 0.9 ) );
	CreateInputTexture2D( TextureDisplacementRock, Linear, 8, "", "_disp", "Rock,10/50", Default( 0.5 ) );

	Texture2D g_tGrass < Channel( RGB, Box( TextureGrass ), Srgb ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tRoughGrass < Channel( R, Box( TextureRoughnessGrass ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tDispGrass < Channel( R, Box( TextureDisplacementGrass ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;

	Texture2D g_tSand < Channel( RGB, Box( TextureSand ), Srgb ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tRoughSand < Channel( R, Box( TextureRoughnessSand ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tDispSand < Channel( R, Box( TextureDisplacementSand ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;

	Texture2D g_tRock < Channel( RGB, Box( TextureRock ), Srgb ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tRoughRock < Channel( R, Box( TextureRoughnessRock ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tDispRock < Channel( R, Box( TextureDisplacementRock ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;

	float g_flRoughnessScale < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Material,10/10" ); >;

	float2 g_vScaleGrass < Default2( 1.0, 1.0 ); Range2( 0.1, 0.1, 4.0, 4.0 ); UiGroup( "Grass,10/30" ); >;
	float g_flRotationGrass < Default( 0.0 ); Range( 0.0, 360.0 ); UiGroup( "Grass,10/40" ); >;
	float2 g_vOffsetGrass < Default2( 0.0, 0.0 ); UiGroup( "Grass,10/50" ); >;
	float g_flNormalStrengthGrass < Default( 1.5 ); Range( 0.0, 8.0 ); UiGroup( "Grass,10/55" ); >;

	float2 g_vScaleSand < Default2( 0.87, 0.93 ); Range2( 0.1, 0.1, 4.0, 4.0 ); UiGroup( "Sand,10/30" ); >;
	float g_flRotationSand < Default( 47.0 ); Range( 0.0, 360.0 ); UiGroup( "Sand,10/40" ); >;
	float2 g_vOffsetSand < Default2( 0.31, 0.67 ); UiGroup( "Sand,10/50" ); >;
	float g_flNormalStrengthSand < Default( 1.0 ); Range( 0.0, 8.0 ); UiGroup( "Sand,10/55" ); >;

	float2 g_vScaleRock < Default2( 1.14, 0.82 ); Range2( 0.1, 0.1, 4.0, 4.0 ); UiGroup( "Rock,10/30" ); >;
	float g_flRotationRock < Default( 103.0 ); Range( 0.0, 360.0 ); UiGroup( "Rock,10/40" ); >;
	float2 g_vOffsetRock < Default2( 0.79, 0.23 ); UiGroup( "Rock,10/50" ); >;
	float g_flNormalStrengthRock < Default( 2.5 ); Range( 0.0, 8.0 ); UiGroup( "Rock,10/55" ); >;
	float g_flAntiTileStrengthGrass < Default( 1.0 ); Range( 0.0, 1.0 ); UiGroup( "Anti-Tile,10/10" ); >;
	float g_flAntiTileStrengthSand < Default( 1.0 ); Range( 0.0, 1.0 ); UiGroup( "Anti-Tile,10/20" ); >;
	float g_flAntiTileStrengthRock < Default( 1.0 ); Range( 0.0, 1.0 ); UiGroup( "Anti-Tile,10/30" ); >;
	float g_flAntiTileFrequency < Default( 0.4 ); Range( 0.05, 2.0 ); UiGroup( "Anti-Tile,10/40" ); >;
	float g_flAntiTileSoftness < Default( 0.65 ); Range( 0.0, 1.0 ); UiGroup( "Anti-Tile,10/45" ); >;
	float g_flUvWarpStrengthGrass < Default( 0.6 ); Range( 0.0, 2.0 ); UiGroup( "Anti-Tile,10/50" ); >;
	float g_flUvWarpStrengthSand < Default( 0.55 ); Range( 0.0, 2.0 ); UiGroup( "Anti-Tile,10/60" ); >;
	float g_flUvWarpStrengthRock < Default( 0.65 ); Range( 0.0, 2.0 ); UiGroup( "Anti-Tile,10/70" ); >;

	float SampleDisplacement( float2 uv, Texture2D map )
	{
		return map.SampleLevel( g_sAniso, uv, 0 ).r;
	}

	float3 NormalFromDisplacement( Texture2D dispMap, float2 uv, float strength )
	{
		float2 texel = float2( 0.002, 0.002 ) * max( strength, 0.001 );
		float center = dispMap.Sample( g_sAniso, uv ).r;
		float dx = dispMap.Sample( g_sAniso, uv + float2( texel.x, 0 ) ).r - center;
		float dy = dispMap.Sample( g_sAniso, uv + float2( 0, texel.y ) ).r - center;
		return normalize( float3( -dx * strength, -dy * strength, 1.0 ) );
	}

	struct LayerSample
	{
		float3 albedo;
		float roughness;
		float3 normalTs;
	};

	LayerSample SampleLayer(
		Texture2D colorMap,
		Texture2D roughMap,
		Texture2D dispMap,
		float2 uv,
		float normalStrength )
	{
		LayerSample layer;
		layer.albedo = colorMap.Sample( g_sAniso, uv ).rgb;
		layer.roughness = roughMap.Sample( g_sAniso, uv ).r;
		layer.normalTs = NormalFromDisplacement( dispMap, uv, normalStrength );
		return layer;
	}

	LayerSample SampleLayerAntiTile(
		Texture2D colorMap,
		Texture2D roughMap,
		Texture2D dispMap,
		float2 worldUv,
		float2 scale,
		float rotation,
		float2 layerOffset,
		float layerSeed,
		float variantRotation,
		float2 variantOffset,
		float variantScale,
		float warpStrength,
		float antiTileStrength,
		float normalStrength )
	{
		float2 uvA = LayerAntiTileUvA( worldUv, scale, rotation, layerOffset, layerSeed, warpStrength );
		float2 uvB = LayerAntiTileUvB( worldUv, scale, rotation, layerOffset, layerSeed, variantRotation, variantOffset, variantScale, warpStrength );
		float blend = AntiTileBlendFactor( worldUv, layerSeed, g_flAntiTileFrequency, antiTileStrength, g_flAntiTileSoftness );

		LayerSample sampleA = SampleLayer( colorMap, roughMap, dispMap, uvA, normalStrength );
		LayerSample sampleB = SampleLayer( colorMap, roughMap, dispMap, uvB, normalStrength );

		LayerSample result;
		result.albedo = lerp( sampleA.albedo, sampleB.albedo, blend );
		result.roughness = lerp( sampleA.roughness, sampleB.roughness, blend );
		result.normalTs = normalize( lerp( sampleA.normalTs, sampleB.normalTs, blend ) );
		return result;
	}

	float4 MainPs( PixelInput i ) : SV_Target0
	{
		float2 worldUv = i.vTextureCoords.xy;

		LayerSample grass = SampleLayerAntiTile(
			g_tGrass, g_tRoughGrass, g_tDispGrass,
			worldUv, g_vScaleGrass, g_flRotationGrass, g_vOffsetGrass,
			17.3, 137.5, float2( 2.17, -1.83 ), 1.09, g_flUvWarpStrengthGrass, g_flAntiTileStrengthGrass,
			g_flNormalStrengthGrass );

		LayerSample sand = SampleLayerAntiTile(
			g_tSand, g_tRoughSand, g_tDispSand,
			worldUv, g_vScaleSand, g_flRotationSand, g_vOffsetSand,
			41.9, 211.0, float2( -1.41, 3.26 ), 1.07, g_flUvWarpStrengthSand, g_flAntiTileStrengthSand,
			g_flNormalStrengthSand );

		LayerSample rock = SampleLayerAntiTile(
			g_tRock, g_tRoughRock, g_tDispRock,
			worldUv, g_vScaleRock, g_flRotationRock, g_vOffsetRock,
			93.7, 283.0, float2( 3.08, 0.92 ), 1.11, g_flUvWarpStrengthRock, g_flAntiTileStrengthRock,
			g_flNormalStrengthRock );

		float3 weights = saturate( i.vBlendValues.rgb );
		float weightSum = max( dot( weights, 1.0 ), 0.0001 );
		weights /= weightSum;

		float3 albedo = grass.albedo * weights.r + sand.albedo * weights.g + rock.albedo * weights.b;
		albedo *= i.vPaintValues.rgb;

		float roughness = grass.roughness * weights.r + sand.roughness * weights.g + rock.roughness * weights.b;
		roughness = saturate( roughness * g_flRoughnessScale );

		float3 normalTs = grass.normalTs * weights.r + sand.normalTs * weights.g + rock.normalTs * weights.b;
		normalTs = normalize( normalTs );

		Material m = Material::Init( i );
		m.Albedo = albedo;
		m.Roughness = roughness;
		m.Metalness = 0.0;
		m.AmbientOcclusion = 1.0;
		m.Opacity = 1.0;
		m.Normal = TransformNormal( normalTs, i.vNormalWs, i.vTangentUWs, i.vTangentVWs );

		return ShadingModelStandard::Shade( i, m );
	}
}
