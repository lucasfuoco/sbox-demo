using Sandbox.GameEvents;

namespace Sandbox.Components.SingletonComponents;

/// <summary>
/// A singleton component which manages world-level state and cleanup.
/// </summary>
[Title( "World Manager" ), Category( "Game Loop" )]
public sealed class WorldManagerSingletonComponent : SingletonComponent<WorldManagerSingletonComponent>,
	IGameEventHandler<BetweenRoundCleanupEvent>
{
	[Property, Group( "World" ), Title( "World Seed" ), Change( nameof( OnWorldSeedChanged ) )]
	public int WorldSeed { get; set; } = 12345;

	[Property, Group( "World" ), Title( "Use World Bounds" ), Change( nameof( OnWorldBoundsChanged ) )]
	public bool UseWorldBounds { get; set; } = true;

	[Property, Group( "World" ), Title( "World Size" ), Change( nameof( OnWorldBoundsChanged ) )]
	public Vector2 WorldSize { get; set; } = new( 24576f, 24576f );

	[Property, Group( "World" ), Title( "Editor Rebuild Delay" ), Range( 0.1f, 3f ), Change( nameof( OnEditorRebuildDelayChanged ) )]
	public float EditorRebuildDelay { get; set; } = 0.5f;

	[Property, Group( "Falloff" ), Title( "Falloff Min" ), Range( 0f, 1f ), Change( nameof( OnFalloffSettingsChanged ) )]
	public float FalloffMin { get; set; } = 0f;

	[Property, Group( "Falloff" ), Title( "Falloff Max" ), Range( 0f, 1f ), Change( nameof( OnFalloffSettingsChanged ) )]
	public float FalloffMax { get; set; } = 1f;

	[Property, Group( "Falloff" ), Title( "Inner Margin" ), Range( 0.01f, 0.5f ), Change( nameof( OnFalloffSettingsChanged ) )]
	public float FalloffInnerMargin { get; set; } = 0.2f;

	[Property, Group( "Falloff" ), Title( "Outer Margin" ), Range( 0f, 0.49f ), Change( nameof( OnFalloffSettingsChanged ) )]
	public float FalloffOuterMargin { get; set; } = 0f;

	[Property, Group( "Falloff" ), Title( "Power" ), Range( 0.25f, 4f ), Change( nameof( OnFalloffSettingsChanged ) )]
	public float FalloffPower { get; set; } = 1f;

	[Property, Group( "Falloff" ), Title( "Use Radial Falloff" ), Change( nameof( OnFalloffSettingsChanged ) )]
	public bool UseRadialFalloff { get; set; } = false;

	[Property, Group( "Falloff" ), Title( "Falloff Center" ), Change( nameof( OnFalloffSettingsChanged ) )]
	public Vector2 FalloffCenter { get; set; } = new( 0.5f, 0.5f );

	[Property, Group( "Height Noise" ), Title( "Frequency" ), Description( "Noise frequency" ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public float HeightNoiseFrequency { get; set; } = 0.0001f;

	[Property, Group( "Height Noise" ), Title( "Octaves" ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public int HeightNoiseOctaves { get; set; } = 2;

	[Property, Group( "Height Noise" ), Title( "Lacunarity" ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public float HeightNoiseLacunarity { get; set; } = 2f;

	[Property, Group( "Height Noise" ), Title( "Amplitude" ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public float HeightNoiseAmplitude { get; set; } = 500f;

	[Property, Group( "Terrain" ), Title( "Bottom Height" ), Change( nameof( OnTerrainMeshSettingsChanged ) )]
	public float TerrainBottomHeight { get; set; } = -200f;

	[Property, Group( "Biomes" ), Title( "Water Level" ), Change( nameof( OnBiomeSettingsChanged ) )]
	public float WaterLevel { get; set; } = 0f;

	[Property, Group( "Biomes" ), Title( "Water Color" ), Change( nameof( OnBiomeSettingsChanged ) )]
	public Color WaterColor { get; set; } = new Color( 0.18f, 0.45f, 0.82f );

	[Property, Group( "Biomes" ), Title( "Water Min Threshold" ), Range( -1f, 1f ), Change( nameof( OnBiomeSettingsChanged ) )]
	public float WaterMinThreshold { get; set; } = -1f;

	[Property, Group( "Biomes" ), Title( "Water Max Threshold" ), Range( -1f, 1f ), Change( nameof( OnBiomeSettingsChanged ) )]
	public float WaterMaxThreshold { get; set; } = -0.9f;

	[Property, Group( "Biomes" ), Title( "Sand Color" ), Change( nameof( OnBiomeSettingsChanged ) )]
	public Color SandColor { get; set; } = new Color( 0.91f, 0.84f, 0.67f );

	[Property, Group( "Biomes" ), Title( "Sand Min Threshold" ), Range( -1f, 1f ), Change( nameof( OnBiomeSettingsChanged ) )]
	public float SandMinThreshold { get; set; } = -0.9f;

	[Property, Group( "Biomes" ), Title( "Sand Max Threshold" ), Range( -1f, 1f ), Change( nameof( OnBiomeSettingsChanged ) )]
	public float SandMaxThreshold { get; set; } = -0.6f;

	[Property, Group( "Biomes" ), Title( "Grass Color" ), Change( nameof( OnBiomeSettingsChanged ) )]
	public Color GrassColor { get; set; } = new Color( 0.30f, 0.65f, 0.28f );

	[Property, Group( "Biomes" ), Title( "Grass Min Threshold" ), Range( -1f, 1f ), Change( nameof( OnBiomeSettingsChanged ) )]
	public float GrassMinThreshold { get; set; } = -0.6f;

	[Property, Group( "Biomes" ), Title( "Grass Max Threshold" ), Range( -1f, 1f ), Change( nameof( OnBiomeSettingsChanged ) )]
	public float GrassMaxThreshold { get; set; } = 0.35f;

	[Property, Group( "Biomes" ), Title( "Sharp Slope Threshold" ), Change( nameof( OnBiomeSettingsChanged ) )]
	public float SharpSlopeThreshold { get; set; } = 0.35f;

	[Property, Group( "Biomes" ), Title( "Mountain Color" ), Change( nameof( OnBiomeSettingsChanged ) )]
	public Color MountainColor { get; set; } = new Color( 0.55f, 0.55f, 0.58f );

	[Property, Group( "Biomes" ), Title( "Mountain Min Threshold" ), Range( -1f, 1f ), Change( nameof( OnBiomeSettingsChanged ) )]
	public float MountainMinThreshold { get; set; } = 0.35f;

	[Property, Group( "Biomes" ), Title( "Mountain Max Threshold" ), Range( -1f, 1f ), Change( nameof( OnBiomeSettingsChanged ) )]
	public float MountainMaxThreshold { get; set; } = 1f;

	public int NoiseSettingsVersion { get; private set; }

	public IEnumerable<DroppedEquipmentComponent> DroppedEquipment =>
		Scene.GetAllComponents<DroppedEquipmentComponent>();

	public IEnumerable<WorldPingComponent> WorldPings =>
		Scene.GetAllComponents<WorldPingComponent>();

	public WorldNoise Noise { get; private set; }

	protected override void OnAwake()
	{
		base.OnAwake();
		EnsureNoise();
	}

	protected override void OnStart()
	{
		RefreshNoiseImmediate();
		RebuildTerrainChunks();
	}

	protected override void OnValidate()
	{
	
	}

	void OnWorldSeedChanged( int oldValue, int newValue ) => ScheduleTerrainRebuild( refreshNoise: true );

	void OnWorldBoundsChanged() => ScheduleTerrainRebuild();

	void OnFalloffSettingsChanged() => ScheduleTerrainRebuild();

	void OnHeightNoiseSettingsChanged() => ScheduleTerrainRebuild( refreshNoise: true );

	void OnTerrainMeshSettingsChanged() => ScheduleTerrainRebuild();

	void OnBiomeSettingsChanged() => ScheduleTerrainRebuild();

	void OnEditorRebuildDelayChanged() => ScheduleTerrainRebuild();

	void EnsureNoise()
	{
		if ( Noise is not null )
			return;

		Noise = new WorldNoise(
			WorldSeed,
			HeightNoiseFrequency,
			HeightNoiseOctaves,
			HeightNoiseLacunarity );
	}

	public void RefreshNoiseImmediate()
	{
		Noise = new WorldNoise(
			WorldSeed,
			HeightNoiseFrequency,
			HeightNoiseOctaves,
			HeightNoiseLacunarity );
		NoiseSettingsVersion++;
	}

	public void ScheduleTerrainRebuild( bool refreshNoise = false )
	{
		foreach ( var streamer in Scene.GetAllComponents<ChunkStreamerComponent>() )
		{
			if ( !streamer.IsValid() )
				continue;

			streamer.ScheduleTerrainRebuild( refreshNoise, EditorRebuildDelay );
		}
	}

	void RebuildTerrainChunks()
	{
		foreach ( var streamer in Scene.GetAllComponents<ChunkStreamerComponent>() )
		{
			if ( !streamer.IsValid() )
				continue;

			streamer.EnsureTerrain();
		}
	}

	void IGameEventHandler<BetweenRoundCleanupEvent>.OnGameEvent( BetweenRoundCleanupEvent eventArgs )
	{
		CleanupTransientObjects();
	}

	public void CleanupTransientObjects()
	{
		if ( !Networking.IsHost )
			return;

		foreach ( var ping in WorldPings )
		{
			ping?.GameObject?.Destroy();
		}
	}

	public float GetHeight( float worldX, float worldY )
	{
		if ( Noise is null )
			return WaterLevel;

		var falloff = 1f;

		if ( UseWorldBounds )
		{
			if ( !TryGetWorldUv( worldX, worldY, out var worldU, out var worldV ) )
				return WaterLevel;

			falloff = GetLandFalloff( worldU, worldV );
		}

		return WaterLevel + Noise.GetHeight( worldX, worldY, HeightNoiseAmplitude, falloff );
	}

	public float GetBiomeSample( float worldX, float worldY )
	{
		if ( HeightNoiseAmplitude <= 0.0001f )
			return -1f;

		var height = GetHeight( worldX, worldY );
		var normalized = (height - WaterLevel) / HeightNoiseAmplitude;
		return MathX.Clamp( normalized * 2f - 1f, -1f, 1f );
	}

	public Vector2 WorldMin => new( GameObject.WorldPosition.x, GameObject.WorldPosition.y );

	public Vector2 WorldMax => WorldMin + WorldSize;

	public bool ChunkIntersectsWorld( ChunkCoord coord, int chunkSize )
	{
		if ( !UseWorldBounds )
			return true;

		var chunkMinX = coord.X * chunkSize;
		var chunkMinY = coord.Y * chunkSize;
		var chunkMaxX = chunkMinX + chunkSize;
		var chunkMaxY = chunkMinY + chunkSize;
		var worldMin = WorldMin;
		var worldMax = WorldMax;

		return chunkMaxX > worldMin.x
			&& chunkMinX < worldMax.x
			&& chunkMaxY > worldMin.y
			&& chunkMinY < worldMax.y;
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
