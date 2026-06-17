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

	[Property, Group( "Height Noise" ), Title( "Frequency" ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public float HeightNoiseFrequency { get; set; } = 0.00008f;

	[Property, Group( "Height Noise" ), Title( "Octaves" ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public int HeightNoiseOctaves { get; set; } = 2;

	[Property, Group( "Height Noise" ), Title( "Lacunarity" ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public float HeightNoiseLacunarity { get; set; } = 2f;

	[Property, Group( "Height Noise" ), Title( "Amplitude" ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public float HeightNoiseAmplitude { get; set; } = 500f;

	[Property, Group( "Terrain" ), Title( "Water Level" ), Change( nameof( OnTerrainMeshSettingsChanged ) )]
	public float WaterLevel { get; set; } = 0f;

	[Property, Group( "Terrain" ), Title( "Bottom Height" ), Change( nameof( OnTerrainMeshSettingsChanged ) )]
	public float TerrainBottomHeight { get; set; } = -200f;

	[Property, Group( "Biomes" ), Title( "Sand Height Above Water" ), Change( nameof( OnBiomeSettingsChanged ) )]
	public float SandHeightAboveWater { get; set; } = 40f;

	[Property, Group( "Biomes" ), Title( "Sharp Slope Threshold" ), Change( nameof( OnBiomeSettingsChanged ) )]
	public float SharpSlopeThreshold { get; set; } = 0.35f;

	[Property, Group( "Biomes" ), Title( "Mountain Height Above Water" ), Change( nameof( OnBiomeSettingsChanged ) )]
	public float MountainHeightAboveWater { get; set; } = 250f;

	[Property, Group( "Biomes" ), Title( "Water Color" ), Change( nameof( OnBiomeSettingsChanged ) )]
	public Color WaterColor { get; set; } = new Color( 0.18f, 0.45f, 0.82f );

	[Property, Group( "Biomes" ), Title( "Sand Color" ), Change( nameof( OnBiomeSettingsChanged ) )]
	public Color SandColor { get; set; } = new Color( 0.91f, 0.84f, 0.67f );

	[Property, Group( "Biomes" ), Title( "Grass Color" ), Change( nameof( OnBiomeSettingsChanged ) )]
	public Color GrassColor { get; set; } = new Color( 0.30f, 0.65f, 0.28f );

	[Property, Group( "Biomes" ), Title( "Mountain Color" ), Change( nameof( OnBiomeSettingsChanged ) )]
	public Color MountainColor { get; set; } = new Color( 0.55f, 0.55f, 0.58f );

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
		RefreshNoise();
	}

	protected override void OnValidate()
	{
		if ( Game.IsEditor )
			RefreshNoise();
	}

	void OnWorldSeedChanged( int oldValue, int newValue ) => RefreshNoise();

	void OnHeightNoiseSettingsChanged() => RefreshNoise();

	void OnTerrainMeshSettingsChanged()
	{
		NoiseSettingsVersion++;
		RebuildTerrainChunks();
	}

	void OnBiomeSettingsChanged() => RebuildTerrainChunks();

	void EnsureNoise()
	{
		if ( Noise is not null )
			return;

		Noise = new WorldNoise( WorldSeed, HeightNoiseFrequency, HeightNoiseOctaves, HeightNoiseLacunarity );
	}

	void RefreshNoise()
	{
		Noise = new WorldNoise( WorldSeed, HeightNoiseFrequency, HeightNoiseOctaves, HeightNoiseLacunarity );
		NoiseSettingsVersion++;
		RebuildTerrainChunks();
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

		return WaterLevel + Noise.GetHeight( worldX, worldY, HeightNoiseAmplitude );
	}
}
