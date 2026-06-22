using Sandbox.Components.SingletonComponents;

namespace Sandbox;

/// <summary>
/// Immutable terrain settings captured on the main thread for off-thread mesh generation.
/// </summary>
public readonly struct TerrainBuildSnapshot
{
	public WorldNoise Noise { get; init; }
	public float WaterLevel { get; init; }
	public float HeightNoiseAmplitude { get; init; }
	public float TerrainBottomHeight { get; init; }
	public bool UseWorldBounds { get; init; }
	public Vector2 WorldMin { get; init; }
	public Vector2 WorldSize { get; init; }
	public bool UseFalloff { get; init; }
	public float FalloffMin { get; init; }
	public float FalloffMax { get; init; }
	public float FalloffInnerMargin { get; init; }
	public float FalloffOuterMargin { get; init; }
	public float FalloffPower { get; init; }
	public bool UseRadialFalloff { get; init; }
	public Vector2 FalloffCenter { get; init; }
	public float SharpSlopeThreshold { get; init; }
	public Color WaterColor { get; init; }
	public float WaterMinThreshold { get; init; }
	public float WaterMaxThreshold { get; init; }
	public Color SandColor { get; init; }
	public float SandMinThreshold { get; init; }
	public float SandMaxThreshold { get; init; }
	public Color GrassColor { get; init; }
	public float GrassMinThreshold { get; init; }
	public float GrassMaxThreshold { get; init; }
	public Color MountainColor { get; init; }
	public float MountainMinThreshold { get; init; }
	public float MountainMaxThreshold { get; init; }
	public Vector3 ChunkOrigin { get; init; }
	public int ChunkSize { get; init; }
	public float TextureTileSize { get; init; }
	public float MacroVariation { get; init; }
	public float MacroVariationScale { get; init; }

	public static TerrainBuildSnapshot FromWorldManager(
		WorldManagerSingletonComponent worldManager,
		Vector3 chunkOrigin,
		int chunkSize )
	{
		return new TerrainBuildSnapshot
		{
			Noise = new WorldNoise(
				worldManager.WorldSeed,
				worldManager.HeightNoiseFrequency,
				worldManager.HeightNoiseOctaves,
				worldManager.HeightNoiseLacunarity,
				worldManager.HeightNoiseGain,
				worldManager.HeightNoiseWeightedStrength ),
			WaterLevel = worldManager.WaterLevel,
			HeightNoiseAmplitude = worldManager.HeightNoiseAmplitude,
			TerrainBottomHeight = worldManager.TerrainBottomHeight,
			UseWorldBounds = worldManager.UseWorldBounds,
			WorldMin = worldManager.WorldMin,
			WorldSize = worldManager.WorldSize,
			UseFalloff = worldManager.UseFalloff,
			FalloffMin = worldManager.FalloffMin,
			FalloffMax = worldManager.FalloffMax,
			FalloffInnerMargin = worldManager.FalloffInnerMargin,
			FalloffOuterMargin = worldManager.FalloffOuterMargin,
			FalloffPower = worldManager.FalloffPower,
			UseRadialFalloff = worldManager.UseRadialFalloff,
			FalloffCenter = worldManager.FalloffCenter,
			SharpSlopeThreshold = worldManager.SharpSlopeThreshold,
			WaterColor = worldManager.WaterColor,
			WaterMinThreshold = worldManager.WaterMinThreshold,
			WaterMaxThreshold = worldManager.WaterMaxThreshold,
			SandColor = worldManager.SandColor,
			SandMinThreshold = worldManager.SandMinThreshold,
			SandMaxThreshold = worldManager.SandMaxThreshold,
			GrassColor = worldManager.GrassColor,
			GrassMinThreshold = worldManager.GrassMinThreshold,
			GrassMaxThreshold = worldManager.GrassMaxThreshold,
			MountainColor = worldManager.MountainColor,
			MountainMinThreshold = worldManager.MountainMinThreshold,
			MountainMaxThreshold = worldManager.MountainMaxThreshold,
			ChunkOrigin = chunkOrigin,
			ChunkSize = Math.Max( chunkSize, 1 ),
			TextureTileSize = MathF.Max( worldManager.TerrainTextureTileSize, 1f ),
			MacroVariation = worldManager.TerrainMacroVariation,
			MacroVariationScale = MathF.Max( worldManager.TerrainMacroVariationScale, 1f )
		};
	}

	public float SampleHeight( float worldX, float worldY )
	{
		var falloff = 1f;

		if ( UseWorldBounds )
		{
			if ( !TryGetWorldUv( worldX, worldY, out var worldU, out var worldV ) )
				return WaterLevel;

			if ( UseFalloff )
				falloff = GetLandFalloff( worldU, worldV );
		}

		return WaterLevel + Noise.GetHeight( worldX, worldY, HeightNoiseAmplitude, falloff );
	}

	public (Color32 Blend, Color32 Tint) SampleBlendPaint( float worldX, float worldY, float height, float slope )
	{
		if ( HeightNoiseAmplitude <= 0.0001f )
			return (new Color( 1f, 0f, 0f, 1f ).ToColor32(), Color.White.ToColor32());

		var normalized = (height - WaterLevel) / HeightNoiseAmplitude;
		var sample = MathX.Clamp( normalized * 2f - 1f, -1f, 1f );

		var paint = TerrainBiome.GetBlendPaint(
			sample,
			slope,
			SharpSlopeThreshold,
			WaterMinThreshold,
			WaterMaxThreshold,
			SandMinThreshold,
			SandMaxThreshold,
			GrassMinThreshold,
			GrassMaxThreshold,
			MountainMinThreshold,
			MountainMaxThreshold,
			WaterColor );

		if ( MacroVariation <= 0.0001f )
			return paint;

		return (
			paint.Blend,
			TerrainBiome.ApplyMacroTint( paint.Tint, worldX, worldY, MacroVariationScale, MacroVariation ) );
	}

	public (Color32 Blend, Color32 Tint) SampleSideBlendPaint()
	{
		return TerrainBiome.GetSideBlendPaint();
	}

	bool TryGetWorldUv( float worldX, float worldY, out float u, out float v )
	{
		u = (worldX - WorldMin.x) / WorldSize.x;
		v = (worldY - WorldMin.y) / WorldSize.y;
		return u >= 0f && u <= 1f && v >= 0f && v <= 1f;
	}

	float GetLandFalloff( float u, float v )
	{
		var distToLand = UseRadialFalloff
			? GetRadialFalloffDistance( u, v )
			: GetEdgeFalloffDistance( u, v );

		var inner = MathF.Max( FalloffInnerMargin, FalloffOuterMargin + 0.001f );
		var outer = MathF.Min( FalloffOuterMargin, inner );
		var t = SmoothStep( outer, inner, distToLand );

		if ( MathF.Abs( FalloffPower - 1f ) > 0.001f )
			t = MathF.Pow( t, FalloffPower );

		var min = MathF.Min( FalloffMin, FalloffMax );
		var max = MathF.Max( FalloffMin, FalloffMax );
		return min + (max - min) * t;
	}

	static float GetEdgeFalloffDistance( float u, float v )
	{
		return MathF.Min(
			MathF.Min( u, 1f - u ),
			MathF.Min( v, 1f - v ) );
	}

	float GetRadialFalloffDistance( float u, float v )
	{
		var dx = u - FalloffCenter.x;
		var dy = v - FalloffCenter.y;
		var distFromCenter = MathF.Sqrt( dx * dx + dy * dy );
		return 0.5f - distFromCenter;
	}

	static float SmoothStep( float edge0, float edge1, float value )
	{
		var range = edge1 - edge0;
		if ( range <= 0.0001f )
			return value >= edge1 ? 1f : 0f;

		var t = MathX.Clamp( (value - edge0) / range, 0f, 1f );
		return t * t * (3f - 2f * t );
	}
}
