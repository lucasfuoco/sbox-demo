using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

public readonly record struct ChunkCoord(
    int X,
    int Y
);

public sealed class ChunkStreamerComponent : Component, Component.ExecuteInEditor
{
    [Property, Group( "Chunk Streamer" ), Title( "World Manager" )]
    public WorldManagerSingletonComponent WorldManager { get; set; }

    [Property, Group( "Chunk Streamer" ), Title( "Camera" )]
    public CameraComponent Camera { get; set; }

	[Property, Group( "Chunk Streamer" ), Title( "Chunk Size" ), Change( nameof( OnLayoutChanged ) )]
    public int ChunkSize { get; set; } = 2048;

    [Property, Group( "Chunk Streamer" ), Title( "View Distance" ), Change( nameof( OnLayoutChanged ) )]
	public int ViewDistance { get; set; } = 4;

	[Property, Group( "Chunk Streamer" ), Title( "Resolution" ), Change( nameof( OnMeshSettingsChanged ) )]
	public int Resolution { get; set; } = 64;

	const string TerrainFolderName = "Terrain";

	Dictionary<ChunkCoord, GameObject> LoadedChunks = new();
	GameObject _terrainFolder;
	int _lastSeed = int.MinValue;
	int _lastNoiseSettingsVersion = -1;
	int _lastChunkSize;
	int _lastViewDistance;
	int _lastResolution;
	bool _settingsInitialized;

	protected override void OnAwake()
	{
		GetTerrainFolder();
		SyncTrackedSettings();
		_settingsInitialized = true;
	}

	protected override void OnStart()
	{
		EnsureTerrain();
	}

	protected override void OnValidate()
	{
		if ( !Game.IsEditor )
			return;

		GetTerrainFolder();

		if ( _settingsInitialized )
			ApplySettingChanges();
		else
			EnsureTerrain();
	}

    protected override void OnUpdate()
    {
		if ( ApplySettingChanges() )
			return;

		UpdateStreamedChunks();
    }

	void OnLayoutChanged() => ApplySettingChanges( force: true );

	void OnMeshSettingsChanged() => ApplySettingChanges( force: true );

	public void RequestLayoutRebuild()
	{
		SyncTrackedSettings();
		ClearAllChunks();
		EnsureTerrain();
	}

	public void RequestRebuild()
	{
		EnsureTerrain();
	}

	public void EnsureTerrain()
	{
		SyncTrackedSettings();
		UpdateStreamedChunks();
		RebuildLoadedChunks();
	}

	bool ApplySettingChanges( bool force = false )
	{
		var worldManager = GetWorldManager();
		if ( !worldManager.IsValid() )
			return false;

		var layoutChanged = ChunkSize != _lastChunkSize || ViewDistance != _lastViewDistance;
		var meshChanged = Resolution != _lastResolution;
		var noiseChanged = worldManager.WorldSeed != _lastSeed
			|| worldManager.NoiseSettingsVersion != _lastNoiseSettingsVersion;

		if ( !force && !layoutChanged && !meshChanged && !noiseChanged )
			return false;

		if ( layoutChanged )
			ClearAllChunks();

		SyncTrackedSettings();
		UpdateStreamedChunks();

		if ( meshChanged || noiseChanged || layoutChanged )
			RebuildLoadedChunks();

		return true;
	}

	void SyncTrackedSettings()
	{
		var worldManager = GetWorldManager();
		if ( worldManager.IsValid() )
		{
			_lastSeed = worldManager.WorldSeed;
			_lastNoiseSettingsVersion = worldManager.NoiseSettingsVersion;
		}

		_lastChunkSize = ChunkSize;
		_lastViewDistance = ViewDistance;
		_lastResolution = Resolution;
	}

	void ClearAllChunks()
	{
		foreach ( var go in LoadedChunks.Values )
			go?.Destroy();

		LoadedChunks.Clear();

		if ( !_terrainFolder.IsValid() )
			_terrainFolder = null;
	}

    void CreateChunk( ChunkCoord coord )
    {
        var worldManager = GetWorldManager();
        if ( !worldManager.IsValid() )
            return;

		var terrainFolder = GetTerrainFolder();
		if ( !terrainFolder.IsValid() )
			return;

        var go = Scene.CreateObject();
        go.Name = $"Chunk ({coord.X}, {coord.Y})";
        go.Parent = terrainFolder;
        go.WorldPosition = new Vector3( coord.X * ChunkSize, coord.Y * ChunkSize, 0 );

        var terrain = go.Components.Create<TerrainChunkComponent>();
        terrain.ChunkStreamer = this;
        terrain.WorldManager = worldManager;
        terrain.Coord = coord;
        terrain.Build();

        LoadedChunks[coord] = go;
	}

	void UpdateStreamedChunks()
	{
		var worldManager = GetWorldManager();
		if ( !worldManager.IsValid() )
			return;

		GetTerrainFolder();

		if ( !TryGetStreamPosition( out var streamPosition ) )
			return;

		var center = WorldToChunk( streamPosition );

		for ( int x = -ViewDistance; x <= ViewDistance; x++ )
		{
			for ( int y = -ViewDistance; y <= ViewDistance; y++ )
			{
				var coord = new ChunkCoord( center.X + x, center.Y + y );
				if ( !LoadedChunks.ContainsKey( coord ) )
					CreateChunk( coord );
			}
		}

		foreach ( var entry in LoadedChunks.ToArray() )
		{
			var coord = entry.Key;
			if ( Math.Abs( coord.X - center.X ) > ViewDistance || Math.Abs( coord.Y - center.Y ) > ViewDistance )
			{
				entry.Value?.Destroy();
				LoadedChunks.Remove( coord );
			}
		}
	}

	void RebuildLoadedChunks()
	{
		foreach ( var go in LoadedChunks.Values.ToArray() )
		{
			if ( !go.IsValid() )
				continue;

			go.GetComponent<TerrainChunkComponent>()?.Build();
		}
	}

	WorldManagerSingletonComponent GetWorldManager()
	{
		if ( WorldManager.IsValid() )
			return WorldManager;

		return WorldManagerSingletonComponent.Instance;
	}

	GameObject GetTerrainFolder()
	{
		if ( _terrainFolder.IsValid() )
			return _terrainFolder;

		foreach ( var child in GameObject.Children )
		{
			if ( child.IsValid() && child.Name == TerrainFolderName )
			{
				_terrainFolder = child;
				return _terrainFolder;
			}
		}

		_terrainFolder = Scene.CreateObject();
		_terrainFolder.Name = TerrainFolderName;
		_terrainFolder.Parent = GameObject;

		return _terrainFolder;
	}

	bool TryGetStreamPosition( out Vector3 position )
	{
		if ( Camera.IsValid() )
		{
			position = Camera.WorldPosition;
			return true;
		}

		if ( Scene.Camera.IsValid() )
		{
			position = Scene.Camera.WorldPosition;
			return true;
		}

		if ( Game.IsEditor )
		{
			position = Gizmo.CameraTransform.Position;
			return true;
		}

		position = WorldPosition;
		return true;
	}

	ChunkCoord WorldToChunk( Vector3 worldPos )
	{
		return new ChunkCoord(
			(int)MathF.Floor( worldPos.x / ChunkSize ),
			(int)MathF.Floor( worldPos.y / ChunkSize )
		);
	}
}
