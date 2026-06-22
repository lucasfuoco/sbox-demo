using Sandbox.GameEvents;

namespace Sandbox.Components.SingletonComponents;

/// <summary>
/// A singleton component which manages world-level state and cleanup.
/// </summary>
[Title( "World Manager" ), Category( "Game Loop" )]
public sealed class WorldManagerSingletonComponent : SingletonComponent<WorldManagerSingletonComponent>,
	IGameEventHandler<BetweenRoundCleanupEvent>, Component.ExecuteInEditor
{
	[Property, Group( "World" ), Title( "World Seed" ), Change( nameof( OnWorldSeedChanged ) )]
	public int WorldSeed { get; set; } = 12345;

	[Property, Group( "World" ), Title( "Use World Bounds" ), Change( nameof( OnWorldBoundsChanged ) )]
	public bool UseWorldBounds { get; set; } = true;

	[Property, Group( "World" ), Title( "World Size" ), Change( nameof( OnWorldBoundsChanged ) )]
	public Vector2 WorldSize { get; set; } = new( 24576f, 24576f );

	[Property, Group( "World" ), Title( "Editor Rebuild Delay" ), Range( 0.1f, 3f ), Change( nameof( OnEditorRebuildDelayChanged ) )]
	public float EditorRebuildDelay { get; set; } = 0.5f;

	[Property, Group( "Falloff" ), Title( "Use Falloff" ), Description( "Fade terrain height toward the world edges. Requires Use World Bounds." ), Change( nameof( OnFalloffSettingsChanged ) )]
	public bool UseFalloff { get; set; } = true;

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

	[Property, Group( "Height Noise" ), Title( "Frequency" ), Description( "Lower = larger landforms. First-octave feature width is roughly 1 / frequency in world units." ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public float HeightNoiseFrequency { get; set; } = 0.003f;

	[Property, Group( "Height Noise" ), Title( "Feature Width (~units)" ), ReadOnly]
	public float HeightNoiseFeatureWidth => HeightNoiseFrequency > 0.0000001f ? 1f / HeightNoiseFrequency : 0f;

	[Property, Group( "Height Noise" ), Title( "Features Across World" ), ReadOnly]
	public float HeightNoiseFeaturesAcrossWorld => HeightNoiseFrequency * MathF.Max( WorldSize.x, WorldSize.y );

	[Hide, Property] public int HeightNoiseFrequencyMicro { get; set; } = 100;

	const float DefaultHeightNoiseFrequency = 0.003f;
	const int DefaultHeightNoiseFrequencyMicro = 100;
	const int FrequencyMicroScale = 1_000_000;
	const float MinHeightNoiseFrequency = 0.0000001f;

	[Property, Group( "Height Noise" ), Title( "Octaves" ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public int HeightNoiseOctaves { get; set; } = 2;

	[Property, Group( "Height Noise" ), Title( "Lacunarity" ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public float HeightNoiseLacunarity { get; set; } = 2f;

	[Property, Group( "Height Noise" ), Title( "Gain" ), Description( "Amplitude multiplier for each octave. Lower = smoother, higher = rougher detail." ), Range( 0f, 2f ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public float HeightNoiseGain { get; set; } = 0.5f;

	[Property, Group( "Height Noise" ), Title( "Weighted Strength" ), Description( "How much each octave's amplitude is weighted by the previous octave. 0 = off." ), Range( 0f, 1f ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public float HeightNoiseWeightedStrength { get; set; } = 0f;

	[Property, Group( "Height Noise" ), Title( "Amplitude" ), Change( nameof( OnHeightNoiseSettingsChanged ) )]
	public float HeightNoiseAmplitude { get; set; } = 500f;

	[Property, Group( "Terrain" ), Title( "Bottom Height" ), Change( nameof( OnTerrainMeshSettingsChanged ) )]
	public float TerrainBottomHeight { get; set; } = -200f;

	[Property, Group( "Terrain" ), Title( "Texture Tile Size" ), Description( "World units covered by one texture repeat. Larger = fewer visible tiles." ), Range( 64f, 2048f ), Change( nameof( OnTerrainMeshSettingsChanged ) )]
	public float TerrainTextureTileSize { get; set; } = 384f;

	[Property, Group( "Terrain" ), Title( "Macro Variation" ), Description( "Low-frequency brightness variation to break up repeating texture patches." ), Range( 0f, 0.35f ), Change( nameof( OnTerrainMeshSettingsChanged ) )]
	public float TerrainMacroVariation { get; set; } = 0.12f;

	[Property, Group( "Terrain" ), Title( "Macro Variation Scale" ), Description( "World units across one macro variation patch." ), Range( 128f, 4096f ), Change( nameof( OnTerrainMeshSettingsChanged ) )]
	public float TerrainMacroVariationScale { get; set; } = 768f;

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

	[Property, Group( "Hydrology" ), Title( "Enable Hydrology" ), Description( "Build a coarse ocean water grid for terrain tinting." ), Change( nameof( OnHydrologySettingsChanged ) )]
	public bool EnableHydrology { get; set; } = true;

	[Property, Group( "Hydrology" ), Title( "Cell Size" ), Description( "World units per hydrology grid cell." ), Range( 32, 512 ), Change( nameof( OnHydrologySettingsChanged ) )]
	public float HydrologyCellSize { get; set; } = 128f;

	[Property, Group( "Hydrology" ), Title( "Ocean Falloff Threshold" ), Description( "Land falloff at or below this is treated as ocean." ), Range( 0f, 1f ), Change( nameof( OnHydrologySettingsChanged ) )]
	public float OceanFalloffThreshold { get; set; } = 0.05f;

	[Property, Group( "Hydrology" ), Title( "Ocean Height Padding" ), Description( "Raw heights within this distance of water level count as ocean." ), Range( 0f, 128f ), Change( nameof( OnHydrologySettingsChanged ) )]
	public float OceanHeightPadding { get; set; } = 2f;

	public int NoiseSettingsVersion { get; private set; }

	public int TerrainSettingsVersion { get; private set; }

	public IEnumerable<DroppedEquipmentComponent> DroppedEquipment =>
		Scene.GetAllComponents<DroppedEquipmentComponent>();

	public IEnumerable<WorldPingComponent> WorldPings =>
		Scene.GetAllComponents<WorldPingComponent>();

	public WorldNoise Noise { get; private set; }

	public WorldHydrology Hydrology { get; private set; }

	bool _hydrologyDirty = true;

	protected override void OnAwake()
	{
		base.OnAwake();
		RefreshNoiseImmediate();
		ScheduleTerrainRebuild( refreshNoise: true, delay: 0f );
	}

	protected override void OnStart()
	{
		RefreshNoiseImmediate();
		RebuildTerrainChunks();
	}

	protected override void OnValidate()
	{
		SyncFrequencyFromStorage();
	}

	void OnWorldSeedChanged( int oldValue, int newValue )
	{
		BumpTerrainSettings();
		ScheduleTerrainRebuild( refreshNoise: true );
	}

	void OnWorldBoundsChanged()
	{
		BumpTerrainSettings();
		ScheduleTerrainRebuild();
	}

	void OnFalloffSettingsChanged()
	{
		BumpTerrainSettings();
		ScheduleTerrainRebuild();
	}

	void OnHeightNoiseSettingsChanged()
	{
		SyncFrequencyFromEditor();
		RefreshNoiseImmediate();
		ScheduleTerrainRebuild( refreshNoise: true );
	}

	void OnTerrainMeshSettingsChanged()
	{
		BumpTerrainSettings();
		ScheduleTerrainRebuild();
	}

	void OnBiomeSettingsChanged()
	{
		BumpTerrainSettings();
		ScheduleTerrainRebuild();
	}

	void OnHydrologySettingsChanged()
	{
		RefreshNoiseImmediate();
		ScheduleTerrainRebuild( refreshNoise: true );
	}

	void OnEditorRebuildDelayChanged() => ScheduleTerrainRebuild();

	void BumpTerrainSettings() => TerrainSettingsVersion++;

	void SyncFrequencyFromStorage()
	{
		if ( HeightNoiseFrequencyMicro <= 0 )
			HeightNoiseFrequencyMicro = FloatToMicro( HeightNoiseFrequency );

		if ( HeightNoiseFrequencyMicro <= 0 )
			HeightNoiseFrequencyMicro = DefaultHeightNoiseFrequencyMicro;

		HeightNoiseFrequencyMicro = Math.Max( HeightNoiseFrequencyMicro, 1 );
		HeightNoiseFrequency = MicroToFloat( HeightNoiseFrequencyMicro );
	}

	void SyncFrequencyFromEditor()
	{
		var frequency = HeightNoiseFrequency <= 0f ? DefaultHeightNoiseFrequency : HeightNoiseFrequency;
		HeightNoiseFrequencyMicro = Math.Max( FloatToMicro( frequency ), 1 );
		HeightNoiseFrequency = MicroToFloat( HeightNoiseFrequencyMicro );
	}

	static int FloatToMicro( float value ) => (int)MathF.Round( Math.Max( value, MinHeightNoiseFrequency ) * FrequencyMicroScale );

	static float MicroToFloat( int micro ) => Math.Max( micro, 1 ) / (float)FrequencyMicroScale;

	public void RefreshNoiseImmediate()
	{
		SyncFrequencyFromStorage();

		Noise = new WorldNoise(
			WorldSeed,
			HeightNoiseFrequency,
			HeightNoiseOctaves,
			HeightNoiseLacunarity,
			HeightNoiseGain,
			HeightNoiseWeightedStrength );
		NoiseSettingsVersion++;

		Hydrology = null;
		_hydrologyDirty = true;
		TerrainSettingsVersion++;
	}

	void EnsureHydrology()
	{
		if ( !_hydrologyDirty && Hydrology is not null )
			return;

		if ( !EnableHydrology || !UseWorldBounds || Noise is null )
		{
			Hydrology = null;
			_hydrologyDirty = false;
			return;
		}

		Hydrology = WorldHydrology.Build( this );
		_hydrologyDirty = false;
	}

	public void EnsureHydrologyBuilt() => EnsureHydrology();

	public void ScheduleTerrainRebuild( bool refreshNoise = false, float? delay = null )
	{
		var rebuildDelay = delay ?? EditorRebuildDelay;

		foreach ( var streamer in Scene.GetAllComponents<ChunkStreamerComponent>() )
		{
			if ( !streamer.IsValid() )
				continue;

			streamer.ScheduleTerrainRebuild( refreshNoise, rebuildDelay, fullReload: true );
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

	public float GetHeight( float worldX, float worldY ) => GetRawNoiseHeight( worldX, worldY );

	public float GetRawNoiseHeight( float worldX, float worldY )
	{
		if ( Noise is null )
			return WaterLevel;

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

	public float GetBiomeSampleFromHeight( float height )
	{
		if ( HeightNoiseAmplitude <= 0.0001f )
			return -1f;

		var normalized = (height - WaterLevel) / HeightNoiseAmplitude;
		return MathX.Clamp( normalized * 2f - 1f, -1f, 1f );
	}

	public bool IsWaterAt( float worldX, float worldY )
	{
		EnsureHydrology();

		if ( Hydrology is not null && Hydrology.IsBuilt )
			return Hydrology.IsWater( worldX, worldY );

		return GetRawNoiseHeight( worldX, worldY ) <= WaterLevel + OceanHeightPadding;
	}

	public bool IsWaterCell( int gridX, int gridY ) => Hydrology?.IsWaterCell( gridX, gridY ) ?? false;

	public WaterCellFlags GetWaterFlagsAt( float worldX, float worldY )
	{
		EnsureHydrology();
		return Hydrology?.GetWaterFlags( worldX, worldY ) ?? WaterCellFlags.None;
	}

	public float GetBiomeSample( float worldX, float worldY )
	{
		if ( HeightNoiseAmplitude <= 0.0001f )
			return -1f;

		var height = GetHeight( worldX, worldY );
		return GetBiomeSampleFromHeight( height );
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

	public bool TryGetWorldUv( float worldX, float worldY, out float u, out float v )
	{
		u = (worldX - WorldMin.x) / WorldSize.x;
		v = (worldY - WorldMin.y) / WorldSize.y;
		return u >= 0f && u <= 1f && v >= 0f && v <= 1f;
	}

	public float GetLandFalloff( float u, float v )
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
