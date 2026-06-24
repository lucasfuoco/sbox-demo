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

	float BlendDisplacement( float2 worldUv, float3 weights )
	{
		float grass = ( SampleLayerDisplacement( g_tDispGrass, worldUv, g_vScaleGrass, g_flRotationGrass, g_vOffsetGrass, 17.3, g_flUvWarpStrengthGrass, g_bRandomRotationGrass ) - 0.5 ) * 2.0 * g_flDisplacementScaleGrass;
		float sand = ( SampleLayerDisplacement( g_tDispSand, worldUv, g_vScaleSand, g_flRotationSand, g_vOffsetSand, 41.9, g_flUvWarpStrengthSand, g_bRandomRotationSand ) - 0.5 ) * 2.0 * g_flDisplacementScaleSand;
		float rock = ( SampleLayerDisplacement( g_tDispRock, worldUv, g_vScaleRock, g_flRotationRock, g_vOffsetRock, 93.7, g_flUvWarpStrengthRock, g_bRandomRotationRock ) - 0.5 ) * 2.0 * g_flDisplacementScaleRock;

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
			float3 weights = ApplyTextureBlendWeights(
				saturate( o.vBlendValues.rgb ),
				g_flTextureBlendSoftness,
				g_flGrassTextureWeight,
				g_flSandTextureWeight,
				g_flRockTextureWeight );
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
	CreateInputTexture2D( TextureNormalGrass, Linear, 8, "NormalizeNormals", "_normal", "Grass,10/15", Default3( 0.5, 0.5, 1.0 ) );
	CreateInputTexture2D( TextureRoughnessGrass, Linear, 8, "", "_rough", "Grass,10/20", Default( 0.85 ) );

	CreateInputTexture2D( TextureSand, Srgb, 8, "", "_color", "Sand,10/10", Default3( 0.78, 0.72, 0.45 ) );
	CreateInputTexture2D( TextureNormalSand, Linear, 8, "NormalizeNormals", "_normal", "Sand,10/15", Default3( 0.5, 0.5, 1.0 ) );
	CreateInputTexture2D( TextureRoughnessSand, Linear, 8, "", "_rough", "Sand,10/20", Default( 0.75 ) );

	CreateInputTexture2D( TextureRock, Srgb, 8, "", "_color", "Rock,10/10", Default3( 0.45, 0.42, 0.38 ) );
	CreateInputTexture2D( TextureNormalRock, Linear, 8, "NormalizeNormals", "_normal", "Rock,10/15", Default3( 0.5, 0.5, 1.0 ) );
	CreateInputTexture2D( TextureRoughnessRock, Linear, 8, "", "_rough", "Rock,10/20", Default( 0.9 ) );

	CreateInputTexture2D( TextureHueSatNoise, Linear, 8, "", "_color", "Color Noise,10/10", Default3( 0.5, 0.5, 0.5 ) );

	Texture2D g_tGrass < Channel( RGB, Box( TextureGrass ), Srgb ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tNormalGrass < Channel( RGB, Box( TextureNormalGrass ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tRoughGrass < Channel( R, Box( TextureRoughnessGrass ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;

	Texture2D g_tSand < Channel( RGB, Box( TextureSand ), Srgb ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tNormalSand < Channel( RGB, Box( TextureNormalSand ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tRoughSand < Channel( R, Box( TextureRoughnessSand ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;

	Texture2D g_tRock < Channel( RGB, Box( TextureRock ), Srgb ); OutputFormat( BC7 ); SrgbRead( true ); >;
	Texture2D g_tNormalRock < Channel( RGB, Box( TextureNormalRock ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tRoughRock < Channel( R, Box( TextureRoughnessRock ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;
	Texture2D g_tHueSatNoise < Channel( RG, Box( TextureHueSatNoise ), Linear ); OutputFormat( BC7 ); SrgbRead( false ); >;

	float g_flRoughnessScale < Default( 1.0 ); Range( 0.0, 2.0 ); UiGroup( "Material,10/10" ); >;
	float g_flMetalnessScale < Default( 1.0 ); Range( 0.0, 1.0 ); UiGroup( "Material,10/20" ); >;

	float2 g_vScaleGrass < Default2( 1.0, 1.0 ); Range2( 0.1, 0.1, 4.0, 4.0 ); UiGroup( "Grass,10/30" ); >;
	float g_flRotationGrass < Default( 0.0 ); Range( 0.0, 360.0 ); UiGroup( "Grass,10/40" ); >;
	float2 g_vOffsetGrass < Default2( 0.0, 0.0 ); UiGroup( "Grass,10/50" ); >;
	float g_flNormalStrengthGrass < Default( 1.5 ); Range( 0.0, 8.0 ); UiGroup( "Grass,10/55" ); >;
	float g_flMetalnessGrass < Default( 0.0 ); Range( 0.0, 1.0 ); UiGroup( "Grass,10/56" ); >;

	float2 g_vScaleSand < Default2( 0.87, 0.93 ); Range2( 0.1, 0.1, 4.0, 4.0 ); UiGroup( "Sand,10/30" ); >;
	float g_flRotationSand < Default( 47.0 ); Range( 0.0, 360.0 ); UiGroup( "Sand,10/40" ); >;
	float2 g_vOffsetSand < Default2( 0.31, 0.67 ); UiGroup( "Sand,10/50" ); >;
	float g_flNormalStrengthSand < Default( 1.0 ); Range( 0.0, 8.0 ); UiGroup( "Sand,10/55" ); >;
	float g_flMetalnessSand < Default( 0.0 ); Range( 0.0, 1.0 ); UiGroup( "Sand,10/56" ); >;

	float2 g_vScaleRock < Default2( 1.14, 0.82 ); Range2( 0.1, 0.1, 4.0, 4.0 ); UiGroup( "Rock,10/30" ); >;
	float g_flRotationRock < Default( 103.0 ); Range( 0.0, 360.0 ); UiGroup( "Rock,10/40" ); >;
	float2 g_vOffsetRock < Default2( 0.79, 0.23 ); UiGroup( "Rock,10/50" ); >;
	float g_flNormalStrengthRock < Default( 2.5 ); Range( 0.0, 8.0 ); UiGroup( "Rock,10/55" ); >;
	float g_flMetalnessRock < Default( 0.0 ); Range( 0.0, 1.0 ); UiGroup( "Rock,10/56" ); >;

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

	struct LayerSample
	{
		float3 albedo;
		float roughness;
		float3 normalTs;
	};

	LayerSample SampleLayer(
		Texture2D colorMap,
		Texture2D roughMap,
		Texture2D normalMap,
		float2 uv,
		float normalStrength )
	{
		LayerSample layer;
		layer.albedo = colorMap.Sample( g_sAniso, uv ).rgb;
		layer.roughness = roughMap.Sample( g_sAniso, uv ).r;
		layer.normalTs = SampleNormalTs( normalMap, uv, normalStrength );
		return layer;
	}

	LayerSample SampleLayerBlended(
		Texture2D colorMap,
		Texture2D roughMap,
		Texture2D normalMap,
		RotatedUvPair uvs,
		float normalStrength )
	{
		LayerSample sampleA = SampleLayer( colorMap, roughMap, normalMap, uvs.primary, normalStrength );
		if ( uvs.primaryWeight >= 0.999 )
			return sampleA;

		LayerSample sampleB = SampleLayer( colorMap, roughMap, normalMap, uvs.secondary, normalStrength );
		LayerSample result;
		result.albedo = lerp( sampleB.albedo, sampleA.albedo, uvs.primaryWeight );
		result.roughness = lerp( sampleB.roughness, sampleA.roughness, uvs.primaryWeight );
		result.normalTs = normalize( lerp( sampleB.normalTs, sampleA.normalTs, uvs.primaryWeight ) );
		return result;
	}

	LayerSample SampleBiomeLayer(
		Texture2D colorMap,
		Texture2D roughMap,
		Texture2D normalMap,
		float2 worldUv,
		float2 scale,
		float rotation,
		float2 layerOffset,
		float layerSeed,
		float warpStrength,
		float normalStrength,
		bool randomizeRotation )
	{
		RotatedUvPair uvs = LayerAntiTileUvPair(
			worldUv, scale, rotation, layerOffset, layerSeed, warpStrength,
			g_flRotationTileSize, randomizeRotation,
			g_flRotationSquiggleStrength, g_flRotationSquiggleScale, g_flRotationEdgeBlend );
		return SampleLayerBlended( colorMap, roughMap, normalMap, uvs, normalStrength );
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

	float4 MainPs( PixelInput i ) : SV_Target0
	{
		float2 worldUv = i.vTextureCoords.xy;

		LayerSample grass = SampleBiomeLayer(
			g_tGrass, g_tRoughGrass, g_tNormalGrass,
			worldUv, g_vScaleGrass, g_flRotationGrass, g_vOffsetGrass,
			17.3, g_flUvWarpStrengthGrass, g_flNormalStrengthGrass, g_bRandomRotationGrass );

		LayerSample sand = SampleBiomeLayer(
			g_tSand, g_tRoughSand, g_tNormalSand,
			worldUv, g_vScaleSand, g_flRotationSand, g_vOffsetSand,
			41.9, g_flUvWarpStrengthSand, g_flNormalStrengthSand, g_bRandomRotationSand );

		LayerSample rock = SampleBiomeLayer(
			g_tRock, g_tRoughRock, g_tNormalRock,
			worldUv, g_vScaleRock, g_flRotationRock, g_vOffsetRock,
			93.7, g_flUvWarpStrengthRock, g_flNormalStrengthRock, g_bRandomRotationRock );

		float3 weights = ApplyTextureBlendWeights(
			saturate( i.vBlendValues.rgb ),
			g_flTextureBlendSoftness,
			g_flGrassTextureWeight,
			g_flSandTextureWeight,
			g_flRockTextureWeight );

		float3 albedo = grass.albedo * weights.r + sand.albedo * weights.g + rock.albedo * weights.b;
		albedo = ApplyHueSaturationNoise( albedo, worldUv );
		albedo *= i.vPaintValues.rgb;

		float roughness = grass.roughness * weights.r + sand.roughness * weights.g + rock.roughness * weights.b;
		roughness = saturate( roughness * g_flRoughnessScale );

		float metalness = g_flMetalnessGrass * weights.r + g_flMetalnessSand * weights.g + g_flMetalnessRock * weights.b;
		metalness = saturate( metalness * g_flMetalnessScale );

		float3 normalTs = grass.normalTs * weights.r + sand.normalTs * weights.g + rock.normalTs * weights.b;
		normalTs = normalize( normalTs );

		Material m = Material::Init( i );
		m.Albedo = albedo;
		m.Roughness = roughness;
		m.Metalness = metalness;
		m.AmbientOcclusion = 1.0;
		m.Opacity = 1.0;
		m.Normal = TransformNormal( normalTs, i.vNormalWs, i.vTangentUWs, i.vTangentVWs );

		return ShadingModelStandard::Shade( i, m );
	}
}
