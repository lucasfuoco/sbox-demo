HEADER
{
	Description = "Terrain multiblend with per-tile random rotation";
	Version = 1;
	DevShader = true;
}

FEATURES
{
	#include "common/features.hlsl"
	Feature( F_VERTEX_DISPLACEMENT, 0..1, "Displacement" );
	Feature( F_PARALLAX_OCCLUSION, 0..1, "Parallax" );
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

		float TerrainFbmNoiseLite( float2 p, float seed )
		{
			float value = 0.0;
			float amplitude = 0.5;
			float frequency = 1.0;
			value += TerrainValueNoise( p * frequency, seed ) * amplitude;
			frequency *= 2.0;
			amplitude *= 0.5;
			value += TerrainValueNoise( p * frequency + 1.7, seed + 17.0 ) * amplitude;
			frequency *= 2.0;
			amplitude *= 0.5;
			value += TerrainValueNoise( p * frequency + 3.1, seed + 43.0 ) * amplitude;
			frequency *= 2.0;
			amplitude *= 0.5;
			value += TerrainValueNoise( p * frequency + 5.3, seed + 71.0 ) * amplitude;
			return value / 0.9375;
		}

		float2 SampleHueSatNoiseProc(
			float2 worldUv,
			float seed,
			float hueScale,
			float satScale )
		{
			float2 hueUv = worldUv * hueScale + float2( seed * 0.013, seed * 0.017 );
			float2 satUv = worldUv * satScale + float2( seed * 0.021 + 41.0, seed * 0.029 - 17.0 );

			float2 warp;
			warp.x = TerrainValueNoise( hueUv * 0.55, seed + 3.0 ) * 2.0 - 1.0;
			warp.y = TerrainValueNoise( hueUv * 0.55 + 9.0, seed + 19.0 ) * 2.0 - 1.0;
			hueUv += warp * 0.35;

			float hue = TerrainFbmNoiseLite( hueUv, seed ) * 2.0 - 1.0;
			float sat = TerrainFbmNoiseLite( satUv, seed + 73.0 ) * 2.0 - 1.0;
			return float2( hue, sat );
		}

		float2 OffsetSquigglyTile(
			float2 tileUv,
			float layerSeed,
			float squiggleStrength,
			float squiggleScale )
		{
			if ( squiggleStrength <= 0.001 )
				return tileUv;

			float2 p = tileUv * squiggleScale + float2( layerSeed * 1.13, layerSeed * 0.71 );

			float2 warp;
			warp.x = TerrainValueNoise( p * 0.65 + 3.7, layerSeed ) * 2.0 - 1.0;
			warp.y = TerrainValueNoise( p * 0.65 + 9.1, layerSeed + 41.0 ) * 2.0 - 1.0;
			p = tileUv + warp * squiggleStrength * 0.45;

			warp.x = TerrainFbmNoise( p * squiggleScale, layerSeed + 17.0 ) * 2.0 - 1.0;
			warp.y = TerrainFbmNoise( p * squiggleScale + 13.7, layerSeed + 29.0 ) * 2.0 - 1.0;
			return p + warp * squiggleStrength * 0.35;
		}

		float2 RotateUvInCell(
			float2 uv,
			float cellSize,
			float2 cellId,
			float layerSeed,
			float baseRotationDeg )
		{
			float2 cellCenter = ( cellId + 0.5 ) * cellSize;
			float randomDeg = HashTerrain1( cellId, layerSeed + 911.0 ) * 360.0;
			float totalRad = radians( baseRotationDeg + randomDeg );
			float s = sin( totalRad );
			float c = cos( totalRad );

			float2 local = uv - cellCenter;
			float2 rotated = float2( local.x * c - local.y * s, local.x * s + local.y * c );
			return rotated + cellCenter;
		}

		struct RotatedUvPair
		{
			float2 primary;
			float2 secondary;
			float primaryWeight;
		};

		RotatedUvPair GetSquigglyRotatedUvs(
			float2 uv,
			float layerSeed,
			float baseRotationDeg,
			float tilesPerCell,
			float squiggleStrength,
			float squiggleScale,
			float edgeBlend )
		{
			RotatedUvPair result;
			float cellSize = max( tilesPerCell, 1.0 );
			float2 tileUv = uv / cellSize;
			float2 lookupUv = OffsetSquigglyTile( tileUv, layerSeed + 311.0, squiggleStrength, squiggleScale );
			float2 cellId = floor( lookupUv );
			float2 fracTile = lookupUv - cellId;

			result.primary = RotateUvInCell( uv, cellSize, cellId, layerSeed, baseRotationDeg );
			result.secondary = result.primary;
			result.primaryWeight = 1.0;

			if ( edgeBlend <= 0.001 )
				return result;

			float edgeNoise = TerrainValueNoise( lookupUv * 4.3 + layerSeed * 0.19, layerSeed + 211.0 );
			float squigglyBlend = edgeBlend * lerp( 0.55, 1.05, edgeNoise );

			float distX = min( fracTile.x, 1.0 - fracTile.x );
			float distY = min( fracTile.y, 1.0 - fracTile.y );
			float2 neighbor = float2( 0.0, 0.0 );
			float edgeDist = distY;
			if ( distX < distY )
			{
				edgeDist = distX;
				neighbor.x = ( fracTile.x < 0.5 ) ? -1.0 : 1.0;
			}
			else
				neighbor.y = ( fracTile.y < 0.5 ) ? -1.0 : 1.0;

			if ( edgeDist >= squigglyBlend )
				return result;

			result.secondary = RotateUvInCell( uv, cellSize, cellId + neighbor, layerSeed, baseRotationDeg );
			result.primaryWeight = smoothstep( 0.0, squigglyBlend, edgeDist );
			return result;
		}

		float2 WarpLayerUv( float2 uv, float layerSeed, float strength )
		{
			float2 p = uv * 0.11 + layerSeed;
			float wx = TerrainFbmNoise( p, layerSeed ) * 2.0 - 1.0;
			float wy = TerrainFbmNoise( p + 13.7, layerSeed + 29.0 ) * 2.0 - 1.0;
			return uv + float2( wx, wy ) * strength * 0.14;
		}

		RotatedUvPair LayerAntiTileUvPair(
			float2 worldUv,
			float2 scale,
			float rotation,
			float2 layerOffset,
			float layerSeed,
			float warpStrength,
			float rotationTileSize,
			bool randomizeRotation,
			float squiggleStrength,
			float squiggleScale,
			float edgeBlend )
		{
			float2 uv = worldUv * scale + layerOffset;
			RotatedUvPair pair;

			if ( randomizeRotation )
				pair = GetSquigglyRotatedUvs( uv, layerSeed, rotation, rotationTileSize, squiggleStrength, squiggleScale, edgeBlend );
			else
			{
				pair.primary = RotateTerrainUv( uv, rotation );
				pair.secondary = pair.primary;
				pair.primaryWeight = 1.0;
			}

			pair.primary = WarpLayerUv( pair.primary, layerSeed, warpStrength );
			pair.secondary = WarpLayerUv( pair.secondary, layerSeed, warpStrength );
			return pair;
		}

		float3 ApplyTextureBlendWeights(
			float3 weights,
			float softness,
			float grassWeight,
			float sandWeight,
			float rockWeight )
		{
			weights = saturate( weights * float3( grassWeight, sandWeight, rockWeight ) );
			weights /= max( dot( weights, 1.0 ), 0.0001 );

			if ( softness <= 0.001 )
				return weights;

			float exponent = lerp( 3.0, 0.55, softness );
			weights = pow( weights, exponent );
			return weights / max( dot( weights, 1.0 ), 0.0001 );
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
	float g_flTextureBlendSoftness < Default( 0.35 ); Range( 0.0, 1.0 ); UiGroup( "Texture Blend,10/10" ); >;
	float g_flGrassTextureWeight < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Texture Blend,10/20" ); >;
	float g_flSandTextureWeight < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Texture Blend,10/30" ); >;
	float g_flRockTextureWeight < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Texture Blend,10/40" ); >;
	float g_flRotationTileSize < Default( 1.0 ); Range( 1.0, 8.0 ); UiGroup( "Rotation,10/10" ); >;
	float g_flRotationSquiggleStrength < Default( 0.6 ); Range( 0.0, 1.5 ); UiGroup( "Rotation,10/15" ); >;
	float g_flRotationSquiggleScale < Default( 2.0 ); Range( 0.5, 8.0 ); UiGroup( "Rotation,10/16" ); >;
	float g_flRotationEdgeBlend < Default( 0.25 ); Range( 0.0, 0.5 ); UiGroup( "Rotation,10/17" ); >;
	bool g_bRandomRotationGrass < Default1( 1 ); UiGroup( "Grass,10/45" ); >;
	bool g_bRandomRotationSand < Default1( 1 ); UiGroup( "Sand,10/45" ); >;
	bool g_bRandomRotationRock < Default1( 1 ); UiGroup( "Rock,10/45" ); >;
	float g_flUvWarpStrengthGrass < Default( 0.0 ); Range( 0.0, 2.0 ); UiGroup( "Rotation,10/20" ); >;
	float g_flUvWarpStrengthSand < Default( 0.0 ); Range( 0.0, 2.0 ); UiGroup( "Rotation,10/30" ); >;
	float g_flUvWarpStrengthRock < Default( 0.0 ); Range( 0.0, 2.0 ); UiGroup( "Rotation,10/40" ); >;

	float g_flDisplacementScale < Default( 1.0 ); Range( 0.0, 4.0 ); UiGroup( "Material,10/5" ); >;
	float g_flDisplacementScaleGrass < Default( 2.5 ); Range( 0.0, 32.0 ); UiGroup( "Grass,10/61" ); >;
	float g_flDisplacementScaleSand < Default( 2.0 ); Range( 0.0, 32.0 ); UiGroup( "Sand,10/61" ); >;
	float g_flDisplacementScaleRock < Default( 5.0 ); Range( 0.0, 32.0 ); UiGroup( "Rock,10/61" ); >;
	float g_flDisplacementCenter < Default( 0.5 ); Range( 0.0, 1.0 ); UiGroup( "Material,10/6" ); >;
	float g_flDisplacementFadeStart < Default( 3072.0 ); Range( 0.0, 65536.0 ); UiGroup( "Material,10/7" ); >;
	float g_flDisplacementFadeEnd < Default( 12288.0 ); Range( 0.0, 65536.0 ); UiGroup( "Material,10/8" ); >;

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
		float warpStrength,
		bool randomizeRotation )
	{
		RotatedUvPair uvs = LayerAntiTileUvPair(
			worldUv, scale, rotation, layerOffset, layerSeed, warpStrength,
			g_flRotationTileSize, randomizeRotation,
			g_flRotationSquiggleStrength, g_flRotationSquiggleScale, g_flRotationEdgeBlend );
		float sampleA = SampleDisplacement( uvs.primary, map );
		if ( uvs.primaryWeight >= 0.999 )
			return sampleA;

		float sampleB = SampleDisplacement( uvs.secondary, map );
		return lerp( sampleB, sampleA, uvs.primaryWeight );
	}

	float LayerDisplacementAmount(
		Texture2D map,
		float2 worldUv,
		float2 scale,
		float rotation,
		float2 layerOffset,
		float layerSeed,
		float warpStrength,
		bool randomizeRotation,
		float layerScale )
	{
		float sample = SampleLayerDisplacement(
			map, worldUv, scale, rotation, layerOffset, layerSeed, warpStrength, randomizeRotation );
		return ( sample - g_flDisplacementCenter ) * 2.0 * layerScale;
	}

	float BlendDisplacement( float2 worldUv, float3 weights )
	{
		float displacement = 0.0;

		// Skip inactive biome layers to avoid wasted texture fetches.
		if ( weights.r > 0.001 )
		{
			displacement += LayerDisplacementAmount(
				g_tDispGrass, worldUv, g_vScaleGrass, g_flRotationGrass, g_vOffsetGrass, 17.3,
				g_flUvWarpStrengthGrass, g_bRandomRotationGrass, g_flDisplacementScaleGrass ) * weights.r;
		}

		if ( weights.g > 0.001 )
		{
			displacement += LayerDisplacementAmount(
				g_tDispSand, worldUv, g_vScaleSand, g_flRotationSand, g_vOffsetSand, 41.9,
				g_flUvWarpStrengthSand, g_bRandomRotationSand, g_flDisplacementScaleSand ) * weights.g;
		}

		if ( weights.b > 0.001 )
		{
			displacement += LayerDisplacementAmount(
				g_tDispRock, worldUv, g_vScaleRock, g_flRotationRock, g_vOffsetRock, 93.7,
				g_flUvWarpStrengthRock, g_bRandomRotationRock, g_flDisplacementScaleRock ) * weights.b;
		}

		return displacement * g_flDisplacementScale;
	}

	float DisplacementDistanceFade( float3 worldPos )
	{
		float fadeStart = min( g_flDisplacementFadeStart, g_flDisplacementFadeEnd );
		float fadeEnd = max( g_flDisplacementFadeStart, g_flDisplacementFadeEnd );
		float distanceToCamera = length( worldPos - g_vCameraPositionWs );

		if ( distanceToCamera >= fadeEnd )
			return 0.0;

		if ( distanceToCamera <= fadeStart )
			return 1.0;

		return 1.0 - saturate( ( distanceToCamera - fadeStart ) / max( fadeEnd - fadeStart, 1e-3 ) );
	}

	PixelInput MainVs( VertexInput i )
	{
		PixelInput o = ProcessVertex( i );
		o.vBlendValues = i.vColorBlendValues;
		o.vPaintValues = i.vColorPaintValues;

		if ( o.vPaintValues.w == 0.0 )
			o.vPaintValues = 1.0;

		#if S_VERTEX_DISPLACEMENT
			float fade = DisplacementDistanceFade( o.vPositionWs );
			if ( fade > 0.001 )
			{
				float3 weights = ApplyTextureBlendWeights(
					saturate( o.vBlendValues.rgb ),
					g_flTextureBlendSoftness,
					g_flGrassTextureWeight,
					g_flSandTextureWeight,
					g_flRockTextureWeight );
				float displacement = BlendDisplacement( o.vTextureCoords.xy, weights ) * fade;
				o.vPositionWs += o.vNormalWs * displacement;
				o.vPositionPs = Position3WsToPs( o.vPositionWs );
			}
		#endif

		return FinalizeVertex( o );
	}
}

PS
{
	#include "common/pixel.hlsl"
	#include "common/utils/normal.hlsl"

	StaticCombo( S_PARALLAX_OCCLUSION, F_PARALLAX_OCCLUSION, Sys( PC ) );

	CreateInputTexture2D( TextureDisplacementGrass, Linear, 8, "", "_disp", "Grass,10/50", Default( 0.5 ) );
	CreateInputTexture2D( TextureDisplacementSand, Linear, 8, "", "_disp", "Sand,10/50", Default( 0.5 ) );
	CreateInputTexture2D( TextureDisplacementRock, Linear, 8, "", "_disp", "Rock,10/50", Default( 0.5 ) );

	Texture2D g_tDispGrass < Channel( R, Box( TextureDisplacementGrass ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tDispSand < Channel( R, Box( TextureDisplacementSand ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tDispRock < Channel( R, Box( TextureDisplacementRock ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;

	CreateInputTexture2D( TextureGrass, Srgb, 8, "", "_color", "Grass,10/10", Default3( 0.2, 0.45, 0.1 ) );
	CreateInputTexture2D( TextureNormalGrass, Linear, 8, "NormalizeNormals", "_normal", "Grass,10/15", Default3( 0.5, 0.5, 1.0 ) );
	CreateInputTexture2D( TextureRoughnessGrass, Linear, 8, "", "_rough", "Grass,10/20", Default( 0.85 ) );
	CreateInputTexture2D( TextureGlossGrass, Linear, 8, "", "_gloss", "Grass,10/22", Default( 0.0 ) );
	CreateInputTexture2D( TextureSpecularGrass, Linear, 8, "", "_spec", "Grass,10/25", Default( 1.0 ) );
	CreateInputTexture2D( TextureAmbientOcclusionGrass, Linear, 8, "", "_ao", "Grass,10/28", Default( 1.0 ) );
	CreateInputTexture2D( TextureBumpGrass, Linear, 8, "", "_bump", "Grass,10/29", Default( 0.5 ) );
	CreateInputTexture2D( TextureCavityGrass, Linear, 8, "", "_cavity", "Grass,10/30", Default( 1.0 ) );

	CreateInputTexture2D( TextureSand, Srgb, 8, "", "_color", "Sand,10/10", Default3( 0.78, 0.72, 0.45 ) );
	CreateInputTexture2D( TextureNormalSand, Linear, 8, "NormalizeNormals", "_normal", "Sand,10/15", Default3( 0.5, 0.5, 1.0 ) );
	CreateInputTexture2D( TextureRoughnessSand, Linear, 8, "", "_rough", "Sand,10/20", Default( 0.75 ) );
	CreateInputTexture2D( TextureGlossSand, Linear, 8, "", "_gloss", "Sand,10/22", Default( 0.0 ) );
	CreateInputTexture2D( TextureSpecularSand, Linear, 8, "", "_spec", "Sand,10/25", Default( 1.0 ) );
	CreateInputTexture2D( TextureAmbientOcclusionSand, Linear, 8, "", "_ao", "Sand,10/28", Default( 1.0 ) );
	CreateInputTexture2D( TextureBumpSand, Linear, 8, "", "_bump", "Sand,10/29", Default( 0.5 ) );
	CreateInputTexture2D( TextureCavitySand, Linear, 8, "", "_cavity", "Sand,10/30", Default( 1.0 ) );

	CreateInputTexture2D( TextureRock, Srgb, 8, "", "_color", "Rock,10/10", Default3( 0.45, 0.42, 0.38 ) );
	CreateInputTexture2D( TextureNormalRock, Linear, 8, "NormalizeNormals", "_normal", "Rock,10/15", Default3( 0.5, 0.5, 1.0 ) );
	CreateInputTexture2D( TextureRoughnessRock, Linear, 8, "", "_rough", "Rock,10/20", Default( 0.9 ) );
	CreateInputTexture2D( TextureGlossRock, Linear, 8, "", "_gloss", "Rock,10/22", Default( 0.0 ) );
	CreateInputTexture2D( TextureSpecularRock, Linear, 8, "", "_spec", "Rock,10/25", Default( 1.0 ) );
	CreateInputTexture2D( TextureAmbientOcclusionRock, Linear, 8, "", "_ao", "Rock,10/28", Default( 1.0 ) );
	CreateInputTexture2D( TextureBumpRock, Linear, 8, "", "_bump", "Rock,10/29", Default( 0.5 ) );
	CreateInputTexture2D( TextureCavityRock, Linear, 8, "", "_cavity", "Rock,10/30", Default( 1.0 ) );

	CreateInputTexture2D( TextureHueSatNoise, Linear, 8, "", "_color", "Color Noise,10/10", Default3( 0.5, 0.5, 0.5 ) );

	Texture2D g_tGrass < Channel( RGB, Box( TextureGrass ), Srgb ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tNormalGrass < Channel( RGB, Box( TextureNormalGrass ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tRoughGrass < Channel( R, Box( TextureRoughnessGrass ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tGlossGrass < Channel( R, Box( TextureGlossGrass ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tSpecGrass < Channel( R, Box( TextureSpecularGrass ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tAoGrass < Channel( R, Box( TextureAmbientOcclusionGrass ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tBumpGrass < Channel( R, Box( TextureBumpGrass ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tCavityGrass < Channel( R, Box( TextureCavityGrass ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;

	Texture2D g_tSand < Channel( RGB, Box( TextureSand ), Srgb ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tNormalSand < Channel( RGB, Box( TextureNormalSand ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tRoughSand < Channel( R, Box( TextureRoughnessSand ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tGlossSand < Channel( R, Box( TextureGlossSand ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tSpecSand < Channel( R, Box( TextureSpecularSand ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tAoSand < Channel( R, Box( TextureAmbientOcclusionSand ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tBumpSand < Channel( R, Box( TextureBumpSand ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tCavitySand < Channel( R, Box( TextureCavitySand ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;

	Texture2D g_tRock < Channel( RGB, Box( TextureRock ), Srgb ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tNormalRock < Channel( RGB, Box( TextureNormalRock ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tRoughRock < Channel( R, Box( TextureRoughnessRock ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tGlossRock < Channel( R, Box( TextureGlossRock ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tSpecRock < Channel( R, Box( TextureSpecularRock ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tAoRock < Channel( R, Box( TextureAmbientOcclusionRock ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tBumpRock < Channel( R, Box( TextureBumpRock ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tCavityRock < Channel( R, Box( TextureCavityRock ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tHueSatNoise < Channel( RG, Box( TextureHueSatNoise ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;

	float g_flRoughnessScale < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Material,10/10" ); >;
	float g_flGlossMapBlend < Default( 0.0 ); Range( 0.0, 1.0 ); UiGroup( "Material,10/15" ); >;
	float g_flGlossScale < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Material,10/16" ); >;
	float g_flMetalnessScale < Default( 1.0 ); Range( 0.0, 1.0 ); UiGroup( "Material,10/20" ); >;
	float g_flSpecularScale < Default( 1.0 ); Range( 0.0, 3.0 ); UiGroup( "Material,10/30" ); >;
	float g_flAmbientOcclusionScale < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Material,10/40" ); >;
	float g_flAmbientOcclusionStrength < Default( 1.0 ); Range( 0.0, 1.0 ); UiGroup( "Material,10/45" ); >;
	float g_flCavityAoStrength < Default( 0.35 ); Range( 0.0, 1.0 ); UiGroup( "Material,10/50" ); >;
	float g_flSlopeAoStrength < Default( 0.25 ); Range( 0.0, 1.0 ); UiGroup( "Material,10/55" ); >;
	float g_flBumpTexelScale < Default( 1.5 ); Range( 0.25, 4.0 ); UiGroup( "Material,10/60" ); >;
	float g_flCavityMapStrength < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Material,10/70" ); >;
	float g_flCavityFromBumpStrength < Default( 0.55 ); Range( 0.0, 2.0 ); UiGroup( "Material,10/75" ); >;
	float g_flCavityAlbedoDarken < Default( 0.35 ); Range( 0.0, 1.0 ); UiGroup( "Material,10/80" ); >;
	float g_flCavitySpecularDarken < Default( 0.45 ); Range( 0.0, 1.0 ); UiGroup( "Material,10/85" ); >;

	float g_flPomScale < Default( 0.04 ); Range( 0.0, 0.25 ); UiGroup( "Parallax,10/10" ); >;
	float g_flPomCenter < Default( 0.5 ); Range( 0.0, 1.0 ); UiGroup( "Parallax,10/15" ); >;
	float g_flPomMinSteps < Default( 4.0 ); Range( 1.0, 16.0 ); UiGroup( "Parallax,10/20" ); >;
	float g_flPomMaxSteps < Default( 16.0 ); Range( 4.0, 64.0 ); UiGroup( "Parallax,10/25" ); >;
	float g_flPomFadeStart < Default( 2048.0 ); Range( 0.0, 65536.0 ); UiGroup( "Parallax,10/30" ); >;
	float g_flPomFadeEnd < Default( 8192.0 ); Range( 0.0, 65536.0 ); UiGroup( "Parallax,10/35" ); >;
	bool g_bPomInvertHeight < Default1( 0 ); UiGroup( "Parallax,10/40" ); >;

	float2 g_vScaleGrass < Default2( 1.0, 1.0 ); Range2( 0.1, 0.1, 4.0, 4.0 ); UiGroup( "Grass,10/30" ); >;
	float g_flRotationGrass < Default( 0.0 ); Range( 0.0, 360.0 ); UiGroup( "Grass,10/40" ); >;
	float2 g_vOffsetGrass < Default2( 0.0, 0.0 ); UiGroup( "Grass,10/50" ); >;
	float g_flNormalStrengthGrass < Default( 1.5 ); Range( 0.0, 8.0 ); UiGroup( "Grass,10/55" ); >;
	float g_flMetalnessGrass < Default( 0.0 ); Range( 0.0, 1.0 ); UiGroup( "Grass,10/56" ); >;
	float g_flSpecularGrass < Default( 0.35 ); Range( 0.0, 2.0 ); UiGroup( "Grass,10/57" ); >;
	float g_flGlossBlendGrass < Default( 0.0 ); Range( 0.0, 1.0 ); UiGroup( "Grass,10/57a" ); >;
	float g_flAmbientOcclusionGrass < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Grass,10/58" ); >;
	float g_flBumpStrengthGrass < Default( 1.0 ); Range( 0.0, 8.0 ); UiGroup( "Grass,10/59" ); >;
	float g_flCavityGrass < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Grass,10/60" ); >;

	float2 g_vScaleSand < Default2( 0.87, 0.93 ); Range2( 0.1, 0.1, 4.0, 4.0 ); UiGroup( "Sand,10/30" ); >;
	float g_flRotationSand < Default( 47.0 ); Range( 0.0, 360.0 ); UiGroup( "Sand,10/40" ); >;
	float2 g_vOffsetSand < Default2( 0.31, 0.67 ); UiGroup( "Sand,10/50" ); >;
	float g_flNormalStrengthSand < Default( 1.0 ); Range( 0.0, 8.0 ); UiGroup( "Sand,10/55" ); >;
	float g_flMetalnessSand < Default( 0.0 ); Range( 0.0, 1.0 ); UiGroup( "Sand,10/56" ); >;
	float g_flSpecularSand < Default( 0.85 ); Range( 0.0, 2.0 ); UiGroup( "Sand,10/57" ); >;
	float g_flGlossBlendSand < Default( 0.0 ); Range( 0.0, 1.0 ); UiGroup( "Sand,10/57a" ); >;
	float g_flAmbientOcclusionSand < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Sand,10/58" ); >;
	float g_flBumpStrengthSand < Default( 1.0 ); Range( 0.0, 8.0 ); UiGroup( "Sand,10/59" ); >;
	float g_flCavitySand < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Sand,10/60" ); >;

	float2 g_vScaleRock < Default2( 1.14, 0.82 ); Range2( 0.1, 0.1, 4.0, 4.0 ); UiGroup( "Rock,10/30" ); >;
	float g_flRotationRock < Default( 103.0 ); Range( 0.0, 360.0 ); UiGroup( "Rock,10/40" ); >;
	float2 g_vOffsetRock < Default2( 0.79, 0.23 ); UiGroup( "Rock,10/50" ); >;
	float g_flNormalStrengthRock < Default( 2.5 ); Range( 0.0, 8.0 ); UiGroup( "Rock,10/55" ); >;
	float g_flMetalnessRock < Default( 0.0 ); Range( 0.0, 1.0 ); UiGroup( "Rock,10/56" ); >;
	float g_flSpecularRock < Default( 1.35 ); Range( 0.0, 2.0 ); UiGroup( "Rock,10/57" ); >;
	float g_flGlossBlendRock < Default( 0.0 ); Range( 0.0, 1.0 ); UiGroup( "Rock,10/57a" ); >;
	float g_flAmbientOcclusionRock < Default( 1.15 ); Range( 0.0, 2.0 ); UiGroup( "Rock,10/58" ); >;
	float g_flBumpStrengthRock < Default( 1.5 ); Range( 0.0, 8.0 ); UiGroup( "Rock,10/59" ); >;
	float g_flCavityRock < Default( 1.25 ); Range( 0.0, 2.0 ); UiGroup( "Rock,10/60" ); >;

	float g_flTextureBlendSoftness < Default( 0.35 ); Range( 0.0, 1.0 ); UiGroup( "Texture Blend,10/10" ); >;
	float g_flGrassTextureWeight < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Texture Blend,10/20" ); >;
	float g_flSandTextureWeight < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Texture Blend,10/30" ); >;
	float g_flRockTextureWeight < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Texture Blend,10/40" ); >;
	float g_flRotationTileSize < Default( 1.0 ); Range( 1.0, 8.0 ); UiGroup( "Rotation,10/10" ); >;
	float g_flRotationSquiggleStrength < Default( 0.6 ); Range( 0.0, 1.5 ); UiGroup( "Rotation,10/15" ); >;
	float g_flRotationSquiggleScale < Default( 2.0 ); Range( 0.5, 8.0 ); UiGroup( "Rotation,10/16" ); >;
	float g_flRotationEdgeBlend < Default( 0.25 ); Range( 0.0, 0.5 ); UiGroup( "Rotation,10/17" ); >;
	bool g_bRandomRotationGrass < Default1( 1 ); UiGroup( "Grass,10/45" ); >;
	bool g_bRandomRotationSand < Default1( 1 ); UiGroup( "Sand,10/45" ); >;
	bool g_bRandomRotationRock < Default1( 1 ); UiGroup( "Rock,10/45" ); >;
	float g_flUvWarpStrengthGrass < Default( 0.0 ); Range( 0.0, 2.0 ); UiGroup( "Rotation,10/20" ); >;
	float g_flUvWarpStrengthSand < Default( 0.0 ); Range( 0.0, 2.0 ); UiGroup( "Rotation,10/30" ); >;
	float g_flUvWarpStrengthRock < Default( 0.0 ); Range( 0.0, 2.0 ); UiGroup( "Rotation,10/40" ); >;

	float g_flColorNoiseStrength < Default( 1.0 ); Range( 0.0, 1.0 ); UiGroup( "Color Noise,10/10" ); >;
	float g_flHueNoiseStrength < Default( 0.045 ); Range( 0.0, 0.25 ); UiGroup( "Color Noise,10/20" ); >;
	float g_flSaturationNoiseStrength < Default( 0.18 ); Range( 0.0, 0.75 ); UiGroup( "Color Noise,10/30" ); >;
	float g_flHueNoiseScale < Default( 0.012 ); Range( 0.001, 0.1 ); UiGroup( "Color Noise,10/40" ); >;
	float g_flSaturationNoiseScale < Default( 0.016 ); Range( 0.001, 0.1 ); UiGroup( "Color Noise,10/50" ); >;
	float g_flColorNoiseSeed < Default( 1337.0 ); Range( 0.0, 9999.0 ); UiGroup( "Color Noise,10/60" ); >;
	float g_flColorNoiseTextureBlend < Default( 0.65 ); Range( 0.0, 1.0 ); UiGroup( "Color Noise,10/70" ); >;
	float2 g_vColorNoiseTextureScale < Default2( 0.0015, 0.0015 ); Range2( 0.0001, 0.0001, 0.05, 0.05 ); UiGroup( "Color Noise,10/80" ); >;
	float2 g_vColorNoiseTextureOffset < Default2( 0.0, 0.0 ); UiGroup( "Color Noise,10/90" ); >;

	float3 SampleNormalTs( Texture2D normalMap, float2 uv, float strength )
	{
		float3 normalTs = DecodeNormal( normalMap.Sample( g_sAniso, uv ).xyz );
		normalTs.xy *= strength;
		return normalize( normalTs );
	}

	// Height/bump map → tangent-space normal via central differences.
	float3 SampleBumpNormalTs( Texture2D bumpMap, float2 uv, float strength )
	{
		if ( strength <= 0.001 )
			return float3( 0, 0, 1 );

		float2 texel = max( abs( ddx( uv ) ), abs( ddy( uv ) ) ) * g_flBumpTexelScale;
		texel = max( texel, float2( 1e-5, 1e-5 ) );

		float hL = bumpMap.Sample( g_sAniso, uv - float2( texel.x, 0 ) ).r;
		float hR = bumpMap.Sample( g_sAniso, uv + float2( texel.x, 0 ) ).r;
		float hD = bumpMap.Sample( g_sAniso, uv - float2( 0, texel.y ) ).r;
		float hU = bumpMap.Sample( g_sAniso, uv + float2( 0, texel.y ) ).r;

		return normalize( float3( ( hL - hR ) * strength, ( hD - hU ) * strength, 1.0 ) );
	}

	float3 CombineNormalAndBump( float3 normalTs, float3 bumpTs, float bumpStrength )
	{
		if ( bumpStrength <= 0.001 )
			return normalTs;

		// Detail bump adds micro relief on top of the authored normal map.
		return normalize( float3( normalTs.xy + bumpTs.xy, normalTs.z ) );
	}

	// White = open surface, black = cavity. Also derives crevices from bump height curvature.
	float SampleCavity( Texture2D cavityMap, Texture2D bumpMap, float2 uv )
	{
		float mapCavity = cavityMap.Sample( g_sAniso, uv ).r;

		float2 texel = max( abs( ddx( uv ) ), abs( ddy( uv ) ) ) * g_flBumpTexelScale;
		texel = max( texel, float2( 1e-5, 1e-5 ) );
		float hC = bumpMap.Sample( g_sAniso, uv ).r;
		float hL = bumpMap.Sample( g_sAniso, uv - float2( texel.x, 0 ) ).r;
		float hR = bumpMap.Sample( g_sAniso, uv + float2( texel.x, 0 ) ).r;
		float hD = bumpMap.Sample( g_sAniso, uv - float2( 0, texel.y ) ).r;
		float hU = bumpMap.Sample( g_sAniso, uv + float2( 0, texel.y ) ).r;
		float lap = ( hL + hR + hD + hU ) * 0.25 - hC; // >0 when neighbors higher (crevice)
		float bumpCavity = saturate( 1.0 - lap * 4.0 * g_flCavityFromBumpStrength );

		return saturate( mapCavity * bumpCavity );
	}

	struct LayerSample
	{
		float3 albedo;
		float roughness;
		float gloss;
		float specular;
		float ao;
		float cavity;
		float3 normalTs;
	};

	float ResolveLayerRoughness( float roughSample, float glossSample, float layerGlossBlend )
	{
		float fromRough = roughSample;
		float fromGloss = saturate( 1.0 - saturate( glossSample * g_flGlossScale ) );
		float blend = saturate( g_flGlossMapBlend * layerGlossBlend );
		return lerp( fromRough, fromGloss, blend );
	}

	LayerSample SampleLayer(
		Texture2D colorMap,
		Texture2D roughMap,
		Texture2D glossMap,
		Texture2D specMap,
		Texture2D aoMap,
		Texture2D normalMap,
		Texture2D bumpMap,
		Texture2D cavityMap,
		float2 uv,
		float normalStrength,
		float bumpStrength,
		float layerGlossBlend )
	{
		LayerSample layer;
		layer.albedo = colorMap.Sample( g_sAniso, uv ).rgb;
		layer.gloss = glossMap.Sample( g_sAniso, uv ).r;
		layer.roughness = ResolveLayerRoughness( roughMap.Sample( g_sAniso, uv ).r, layer.gloss, layerGlossBlend );
		layer.specular = specMap.Sample( g_sAniso, uv ).r;
		layer.ao = aoMap.Sample( g_sAniso, uv ).r;
		layer.cavity = SampleCavity( cavityMap, bumpMap, uv );
		float3 normalTs = SampleNormalTs( normalMap, uv, normalStrength );
		float3 bumpTs = SampleBumpNormalTs( bumpMap, uv, bumpStrength );
		layer.normalTs = CombineNormalAndBump( normalTs, bumpTs, bumpStrength );
		return layer;
	}

	LayerSample SampleLayerBlended(
		Texture2D colorMap,
		Texture2D roughMap,
		Texture2D glossMap,
		Texture2D specMap,
		Texture2D aoMap,
		Texture2D normalMap,
		Texture2D bumpMap,
		Texture2D cavityMap,
		RotatedUvPair uvs,
		float normalStrength,
		float bumpStrength,
		float layerGlossBlend )
	{
		LayerSample sampleA = SampleLayer( colorMap, roughMap, glossMap, specMap, aoMap, normalMap, bumpMap, cavityMap, uvs.primary, normalStrength, bumpStrength, layerGlossBlend );
		if ( uvs.primaryWeight >= 0.999 )
			return sampleA;

		LayerSample sampleB = SampleLayer( colorMap, roughMap, glossMap, specMap, aoMap, normalMap, bumpMap, cavityMap, uvs.secondary, normalStrength, bumpStrength, layerGlossBlend );
		LayerSample result;
		result.albedo = lerp( sampleB.albedo, sampleA.albedo, uvs.primaryWeight );
		result.roughness = lerp( sampleB.roughness, sampleA.roughness, uvs.primaryWeight );
		result.gloss = lerp( sampleB.gloss, sampleA.gloss, uvs.primaryWeight );
		result.specular = lerp( sampleB.specular, sampleA.specular, uvs.primaryWeight );
		result.ao = lerp( sampleB.ao, sampleA.ao, uvs.primaryWeight );
		result.cavity = lerp( sampleB.cavity, sampleA.cavity, uvs.primaryWeight );
		result.normalTs = normalize( lerp( sampleB.normalTs, sampleA.normalTs, uvs.primaryWeight ) );
		return result;
	}

	LayerSample SampleBiomeLayer(
		Texture2D colorMap,
		Texture2D roughMap,
		Texture2D glossMap,
		Texture2D specMap,
		Texture2D aoMap,
		Texture2D normalMap,
		Texture2D bumpMap,
		Texture2D cavityMap,
		float2 worldUv,
		float2 scale,
		float rotation,
		float2 layerOffset,
		float layerSeed,
		float warpStrength,
		float normalStrength,
		float bumpStrength,
		float layerGlossBlend,
		bool randomizeRotation )
	{
		RotatedUvPair uvs = LayerAntiTileUvPair(
			worldUv, scale, rotation, layerOffset, layerSeed, warpStrength,
			g_flRotationTileSize, randomizeRotation,
			g_flRotationSquiggleStrength, g_flRotationSquiggleScale, g_flRotationEdgeBlend );
		return SampleLayerBlended( colorMap, roughMap, glossMap, specMap, aoMap, normalMap, bumpMap, cavityMap, uvs, normalStrength, bumpStrength, layerGlossBlend );
	}

	// Specular 0 = matte, 1 = roughness map as authored, >1 = glossier highlights.
	float ApplySpecularToRoughness( float roughness, float specular )
	{
		specular = max( specular, 0.0 );
		if ( specular <= 1.0 )
			return lerp( 1.0, roughness, specular );

		float gloss = saturate( 1.0 - roughness );
		gloss = saturate( gloss * specular );
		return saturate( 1.0 - gloss );
	}

	float2 SampleHueSatNoiseTexture( float2 worldUv )
	{
		float2 uv = worldUv * g_vColorNoiseTextureScale + g_vColorNoiseTextureOffset;
		return g_tHueSatNoise.Sample( g_sAniso, uv ).rg * 2.0 - 1.0;
	}

	float3 ApplyHueSaturationNoise( float3 rgb, float2 worldUv )
	{
		if ( g_flColorNoiseStrength <= 0.001 )
			return rgb;

		float2 proc = SampleHueSatNoiseProc(
			worldUv,
			g_flColorNoiseSeed,
			g_flHueNoiseScale,
			g_flSaturationNoiseScale );
		float2 tex = SampleHueSatNoiseTexture( worldUv );
		float2 noise = lerp( proc, tex, g_flColorNoiseTextureBlend );

		float3 hsv = RgbToHsv( rgb );
		hsv.x = frac( hsv.x + noise.x * g_flHueNoiseStrength );
		hsv.y = saturate( hsv.y * ( 1.0 + noise.y * g_flSaturationNoiseStrength ) );
		float3 varied = HsvToRgb( hsv );
		return lerp( rgb, varied, g_flColorNoiseStrength );
	}

#if S_PARALLAX_OCCLUSION
	float PomDistanceFade( float3 worldPos )
	{
		float fadeStart = min( g_flPomFadeStart, g_flPomFadeEnd );
		float fadeEnd = max( g_flPomFadeStart, g_flPomFadeEnd );
		float distanceToCamera = length( worldPos - g_vCameraPositionWs );

		if ( distanceToCamera >= fadeEnd )
			return 0.0;

		if ( distanceToCamera <= fadeStart )
			return 1.0;

		return 1.0 - saturate( ( distanceToCamera - fadeStart ) / max( fadeEnd - fadeStart, 1e-3 ) );
	}

	float3 GetViewDirTs( PixelInput i )
	{
		float3 viewWs = normalize( g_vCameraPositionWs - i.vPositionWs );
		float3 t = normalize( i.vTangentUWs );
		float3 b = normalize( i.vTangentVWs );
		float3 n = normalize( i.vNormalWs );
		return normalize( float3( dot( viewWs, t ), dot( viewWs, b ), dot( viewWs, n ) ) );
	}

	// 0 = grass, 1 = sand, 2 = rock. Grass-first when grass has meaningful weight.
	int SelectPomHeightLayerIndex( float3 weights )
	{
		if ( weights.r >= 0.25 || ( weights.r >= weights.g && weights.r >= weights.b ) )
			return 0;

		if ( weights.g >= weights.b )
			return 1;

		return 2;
	}

	float SamplePomHeightAtWorldUv( float2 worldUv, int layerIndex )
	{
		float2 scale = g_vScaleGrass;
		float rotation = g_flRotationGrass;
		float2 layerOffset = g_vOffsetGrass;
		float layerSeed = 17.3;
		float warpStrength = g_flUvWarpStrengthGrass;
		bool randomizeRotation = g_bRandomRotationGrass;

		if ( layerIndex == 1 )
		{
			scale = g_vScaleSand;
			rotation = g_flRotationSand;
			layerOffset = g_vOffsetSand;
			layerSeed = 41.9;
			warpStrength = g_flUvWarpStrengthSand;
			randomizeRotation = g_bRandomRotationSand;
		}
		else if ( layerIndex == 2 )
		{
			scale = g_vScaleRock;
			rotation = g_flRotationRock;
			layerOffset = g_vOffsetRock;
			layerSeed = 93.7;
			warpStrength = g_flUvWarpStrengthRock;
			randomizeRotation = g_bRandomRotationRock;
		}

		RotatedUvPair uvs = LayerAntiTileUvPair(
			worldUv, scale, rotation, layerOffset, layerSeed, warpStrength,
			g_flRotationTileSize, randomizeRotation,
			g_flRotationSquiggleStrength, g_flRotationSquiggleScale, g_flRotationEdgeBlend );

		float heightA = 0.5;
		float heightB = 0.5;
		if ( layerIndex == 0 )
		{
			heightA = g_tDispGrass.Sample( g_sAniso, uvs.primary ).r;
			heightB = ( uvs.primaryWeight < 0.999 ) ? g_tDispGrass.Sample( g_sAniso, uvs.secondary ).r : heightA;
		}
		else if ( layerIndex == 1 )
		{
			heightA = g_tDispSand.Sample( g_sAniso, uvs.primary ).r;
			heightB = ( uvs.primaryWeight < 0.999 ) ? g_tDispSand.Sample( g_sAniso, uvs.secondary ).r : heightA;
		}
		else
		{
			heightA = g_tDispRock.Sample( g_sAniso, uvs.primary ).r;
			heightB = ( uvs.primaryWeight < 0.999 ) ? g_tDispRock.Sample( g_sAniso, uvs.secondary ).r : heightA;
		}

		float height = lerp( heightB, heightA, uvs.primaryWeight );
		if ( g_bPomInvertHeight )
			height = 1.0 - height;

		// Remap around the authored mid-grey so POM treats center as flat.
		height = saturate( ( height - g_flPomCenter ) + 0.5 );
		return height;
	}

	float2 ParallaxOcclusionWorldUv( PixelInput i, float2 worldUv, float3 weights, float fade )
	{
		if ( fade <= 0.001 || g_flPomScale <= 1e-6 )
			return worldUv;

		int layerIndex = SelectPomHeightLayerIndex( weights );
		float3 viewDirTs = GetViewDirTs( i );
		float2 parallaxDir = viewDirTs.xy / max( viewDirTs.z, 0.12 );
		float heightScale = g_flPomScale * fade;

		int minSteps = (int)clamp( g_flPomMinSteps, 1.0, 64.0 );
		int maxSteps = (int)clamp( g_flPomMaxSteps, (float)minSteps, 64.0 );
		int steps = (int)lerp( (float)minSteps, (float)maxSteps, fade );
		steps = clamp( steps, minSteps, maxSteps );

		float layerDepth = 1.0 / (float)steps;
		float2 deltaUv = parallaxDir * heightScale * layerDepth;

		float2 offsetUv = worldUv;
		float currentDepth = 0.0;
		float currentHeight = SamplePomHeightAtWorldUv( offsetUv, layerIndex );

		[loop]
		for ( int stepIndex = 0; stepIndex < 64; stepIndex++ )
		{
			if ( stepIndex >= steps || currentHeight <= currentDepth )
				break;

			offsetUv -= deltaUv;
			currentDepth += layerDepth;
			currentHeight = SamplePomHeightAtWorldUv( offsetUv, layerIndex );
		}

		// One-step refinement between the last two samples.
		float2 prevUv = offsetUv + deltaUv;
		float prevDepth = currentDepth - layerDepth;
		float prevHeight = SamplePomHeightAtWorldUv( prevUv, layerIndex );

		float before = prevHeight - prevDepth;
		float after = currentHeight - currentDepth;
		float weight = saturate( after / max( after - before, 1e-4 ) );
		return lerp( offsetUv, prevUv, weight );
	}
#endif

	float4 MainPs( PixelInput i ) : SV_Target0
	{
		float2 worldUv = i.vTextureCoords.xy;

		float3 weights = ApplyTextureBlendWeights(
			saturate( i.vBlendValues.rgb ),
			g_flTextureBlendSoftness,
			g_flGrassTextureWeight,
			g_flSandTextureWeight,
			g_flRockTextureWeight );

		#if S_PARALLAX_OCCLUSION && !S_MODE_DEPTH
			float pomFade = PomDistanceFade( i.vPositionWs );
			worldUv = ParallaxOcclusionWorldUv( i, worldUv, weights, pomFade );
		#endif

		LayerSample grass = SampleBiomeLayer(
			g_tGrass, g_tRoughGrass, g_tGlossGrass, g_tSpecGrass, g_tAoGrass, g_tNormalGrass, g_tBumpGrass, g_tCavityGrass,
			worldUv, g_vScaleGrass, g_flRotationGrass, g_vOffsetGrass,
			17.3, g_flUvWarpStrengthGrass, g_flNormalStrengthGrass, g_flBumpStrengthGrass, g_flGlossBlendGrass, g_bRandomRotationGrass );

		LayerSample sand = SampleBiomeLayer(
			g_tSand, g_tRoughSand, g_tGlossSand, g_tSpecSand, g_tAoSand, g_tNormalSand, g_tBumpSand, g_tCavitySand,
			worldUv, g_vScaleSand, g_flRotationSand, g_vOffsetSand,
			41.9, g_flUvWarpStrengthSand, g_flNormalStrengthSand, g_flBumpStrengthSand, g_flGlossBlendSand, g_bRandomRotationSand );

		LayerSample rock = SampleBiomeLayer(
			g_tRock, g_tRoughRock, g_tGlossRock, g_tSpecRock, g_tAoRock, g_tNormalRock, g_tBumpRock, g_tCavityRock,
			worldUv, g_vScaleRock, g_flRotationRock, g_vOffsetRock,
			93.7, g_flUvWarpStrengthRock, g_flNormalStrengthRock, g_flBumpStrengthRock, g_flGlossBlendRock, g_bRandomRotationRock );

		float3 albedo = grass.albedo * weights.r + sand.albedo * weights.g + rock.albedo * weights.b;
		albedo = ApplyHueSaturationNoise( albedo, worldUv );
		albedo *= i.vPaintValues.rgb;

		float roughness = grass.roughness * weights.r + sand.roughness * weights.g + rock.roughness * weights.b;
		roughness = saturate( roughness * g_flRoughnessScale );

		float specularMap = grass.specular * weights.r + sand.specular * weights.g + rock.specular * weights.b;
		float specular = ( g_flSpecularGrass * weights.r + g_flSpecularSand * weights.g + g_flSpecularRock * weights.b )
			* specularMap
			* g_flSpecularScale;

		float metalness = g_flMetalnessGrass * weights.r + g_flMetalnessSand * weights.g + g_flMetalnessRock * weights.b;
		metalness = saturate( metalness * g_flMetalnessScale );

		float3 normalTs = grass.normalTs * weights.r + sand.normalTs * weights.g + rock.normalTs * weights.b;
		normalTs = normalize( normalTs );
		float3 worldNormal = TransformNormal( normalTs, i.vNormalWs, i.vTangentUWs, i.vTangentVWs );

		float cavityMap = grass.cavity * weights.r + sand.cavity * weights.g + rock.cavity * weights.b;
		float cavityLayer = g_flCavityGrass * weights.r + g_flCavitySand * weights.g + g_flCavityRock * weights.b;
		float cavity = saturate( cavityMap * cavityLayer * g_flCavityMapStrength );

		float aoMap = grass.ao * weights.r + sand.ao * weights.g + rock.ao * weights.b;
		float aoLayer = g_flAmbientOcclusionGrass * weights.r + g_flAmbientOcclusionSand * weights.g + g_flAmbientOcclusionRock * weights.b;
		float ao = saturate( aoMap * aoLayer * g_flAmbientOcclusionScale );

		// Procedural fallback cavity from detail normals + soft darkening on steep slopes.
		float normalCavity = saturate( 0.35 + 0.65 * saturate( normalTs.z ) );
		float slopeAo = saturate( 0.55 + 0.45 * saturate( worldNormal.z ) );
		ao *= lerp( 1.0, normalCavity, g_flCavityAoStrength );
		ao *= lerp( 1.0, slopeAo, g_flSlopeAoStrength );
		ao *= cavity;
		ao = lerp( 1.0, ao, g_flAmbientOcclusionStrength );
		ao = saturate( ao );

		// Darken albedo / mute specular in cavities (classic cavity map usage).
		albedo *= lerp( 1.0, cavity, g_flCavityAlbedoDarken );
		specular *= lerp( 1.0, cavity, g_flCavitySpecularDarken );
		roughness = ApplySpecularToRoughness( roughness, specular );

		Material m = Material::Init( i );
		m.Albedo = albedo;
		m.Roughness = roughness;
		m.Metalness = metalness;
		m.AmbientOcclusion = ao;
		m.Opacity = 1.0;
		m.Normal = worldNormal;

		return ShadingModelStandard::Shade( i, m );
	}
}
