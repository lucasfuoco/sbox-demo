using Sandbox.Components.SingletonComponents;

namespace Sandbox;

/// <summary>
/// Terrain and biome weights at a world X/Y sample used to place ambient emitters.
/// </summary>
public readonly struct WorldAmbientTerrainSample
{
	public float Grass { get; init; }
	public float Sand { get; init; }
	public float Rock { get; init; }
	public float Water { get; init; }
	public float Shore { get; init; }
	public float TreeDensity { get; init; }
	public float OpenExposure { get; init; }
	public float Height { get; init; }

	public Vector3 GroundPosition { get; init; }

	public static WorldAmbientTerrainSample Sample( WorldManagerSingletonComponent terrain, float worldX, float worldY )
	{
		if ( !terrain.IsValid() )
		{
			return new WorldAmbientTerrainSample
			{
				GroundPosition = new Vector3( worldX, worldY, 0f ),
			};
		}

		var height = terrain.GetHeight( worldX, worldY );
		var isWater = terrain.IsWaterAt( worldX, worldY );
		var sample = terrain.GetBiomeSample( worldX, worldY );

		var slope = EstimateSlope( terrain, worldX, worldY, height );
		var paint = TerrainBiome.GetBlendPaint(
			sample,
			slope,
			terrain.SharpSlopeThreshold,
			terrain.WaterMinThreshold,
			terrain.WaterMaxThreshold,
			terrain.SandMinThreshold,
			terrain.SandMaxThreshold,
			terrain.GrassMinThreshold,
			terrain.GrassMaxThreshold,
			terrain.MountainMinThreshold,
			terrain.MountainMaxThreshold,
			terrain.WaterColor,
			terrain.TerrainBiomeBlendWidth );

		var blend = paint.Blend.ToColor();
		var grass = blend.r;
		var sand = blend.g;
		var rock = blend.b;
		var water = isWater ? 1f : 0f;
		var shore = isWater ? 0f : GetShoreWeight( terrain, worldX, worldY );
		var treeNoise = Hash01( worldX * 0.0047f + terrain.WorldSeed, worldY * 0.0047f );
		var treeDensity = isWater ? 0f : grass * treeNoise;
		var openExposure = MathX.Clamp( sand * 0.85f + rock * 0.65f + (1f - grass) * 0.25f, 0f, 1f );

		return new WorldAmbientTerrainSample
		{
			Grass = grass,
			Sand = sand,
			Rock = rock,
			Water = water,
			Shore = shore,
			TreeDensity = treeDensity,
			OpenExposure = openExposure,
			Height = height,
			GroundPosition = new Vector3( worldX, worldY, height ),
		};
	}

	static float EstimateSlope( WorldManagerSingletonComponent terrain, float worldX, float worldY, float height )
	{
		const float delta = 48f;
		var dx = MathF.Abs( terrain.GetHeight( worldX + delta, worldY ) - height ) / delta;
		var dy = MathF.Abs( terrain.GetHeight( worldX, worldY + delta ) - height ) / delta;
		return MathF.Max( dx, dy );
	}

	static float GetShoreWeight( WorldManagerSingletonComponent terrain, float worldX, float worldY )
	{
		const float radius = 160f;
		var steps = new (float X, float Y)[]
		{
			(radius, 0f),
			(-radius, 0f),
			(0f, radius),
			(0f, -radius),
			(radius * 0.7f, radius * 0.7f),
			(-radius * 0.7f, radius * 0.7f),
		};

		foreach ( var (offsetX, offsetY) in steps )
		{
			if ( terrain.IsWaterAt( worldX + offsetX, worldY + offsetY ) )
				return 1f;
		}

		return 0f;
	}

	static float Hash01( float x, float y )
	{
		var value = MathF.Sin( x * 12.9898f + y * 78.233f ) * 43758.5453f;
		return value - MathF.Floor( value );
	}
}
