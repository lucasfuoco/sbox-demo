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
	public int Resolution { get; set; } = 124;

	[Property, Group( "LOD" ), Title( "Use LOD" ), Change( nameof( OnLodSettingsChanged ) )]
	public bool UseLod { get; set; } = true;

	[Property, Group( "LOD" ), Title( "LOD 0 Distance" ), Description( "Max chunk distance (Chebyshev) from the camera chunk for full detail. The camera chunk is distance 0." ), Change( nameof( OnLodSettingsChanged ) )]
	public int Lod0Distance { get; set; } = 1;

	[Property, Group( "LOD" ), Title( "LOD 1 Distance" ), Description( "Max chunk distance for half detail. Must be greater than LOD 0 Distance." ), Change( nameof( OnLodSettingsChanged ) )]
	public int Lod1Distance { get; set; } = 2;

	[Property, Group( "LOD" ), Title( "LOD 2 Distance" ), Description( "Max chunk distance for quarter detail. Set close to View Distance so the lowest detail band appears before chunks unload." ), Change( nameof( OnLodSettingsChanged ) )]
	public int Lod2Distance { get; set; } = 5;

	[Property, Group( "LOD" ), Title( "Min LOD Resolution" ), Change( nameof( OnLodSettingsChanged ) )]
	public int MinLodResolution { get; set; } = 8;

	[Property, Group( "LOD" ), Title( "Use Height LOD" ), Description( "Factor camera altitude above terrain into LOD. Useful when viewing terrain from high up." ), Change( nameof( OnLodSettingsChanged ) )]
	public bool UseHeightBasedLod { get; set; } = true;

	[Property, Group( "LOD" ), Title( "Height LOD Scale" ), Description( "How strongly altitude above terrain affects LOD. 1 = one chunk size of height counts as one LOD distance step." ), Range( 0f, 4f ), Change( nameof( OnLodSettingsChanged ) )]
	public float HeightLodScale { get; set; } = 1f;

	[Property, Group( "Chunk Streamer" ), Title( "Chunks Per Frame" ), Change( nameof( OnLayoutChanged ) )]
	public int ChunksPerFrame { get; set; } = 1;

	const string TerrainFolderName = "Terrain";

	Dictionary<ChunkCoord, GameObject> LoadedChunks = new();
	Dictionary<ChunkCoord, int> _chunkResolutions = new();
	HashSet<ChunkCoord> _pendingChunks = new();
	ChunkCoord _lastLodCenter = new( int.MinValue, int.MinValue );
	Vector3 _lastLodStreamPosition = new( float.MaxValue, float.MaxValue, float.MaxValue );
	GameObject _terrainFolder;
	RealTimeUntil _rebuildDue;
	bool _rebuildPending;
	bool _refreshNoisePending;
	int _lastSeed = int.MinValue;
	int _lastNoiseSettingsVersion = -1;
	int _lastChunkSize;
	int _lastViewDistance;
	int _lastResolution;
	bool _lastUseLod;
	int _lastLod0Distance;
	int _lastLod1Distance;
	int _lastLod2Distance;
	int _lastMinLodResolution;
	bool _lastUseHeightBasedLod;
	float _lastHeightLodScale;
	int _lastChunksPerFrame;
	int[] _lodResolutions;
	int _cachedLodResolution;
	int _cachedMinLodResolution;
	bool _lastUseWorldBounds;
	Vector2 _lastWorldSize;
	Vector3 _lastWorldOrigin;
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
		NormalizeLodDistances();

		if ( !Game.IsEditor )
			return;

		GetTerrainFolder();

		if ( _settingsInitialized )
			ScheduleTerrainRebuild();
		else
			EnsureTerrain();
	}

	void NormalizeLodDistances()
	{
		Lod0Distance = Math.Max( Lod0Distance, 0 );
		Lod1Distance = Math.Max( Lod1Distance, Lod0Distance );
		Lod2Distance = Math.Max( Lod2Distance, Lod1Distance );

		if ( ViewDistance > 0 )
			Lod2Distance = Math.Min( Lod2Distance, ViewDistance );
	}

    protected override void OnUpdate()
    {
		ProcessPendingTerrainRebuild();

		if ( ApplySettingChanges() )
			return;

		UpdateStreamedChunks();
		ProcessPendingChunks();
		UpdateChunkLods();
    }

	void OnLayoutChanged()
	{
		NormalizeLodDistances();
		ScheduleTerrainRebuild();
	}

	void OnMeshSettingsChanged() => ScheduleTerrainRebuild();

	void OnLodSettingsChanged()
	{
		NormalizeLodDistances();
		ScheduleTerrainRebuild();
	}

	public void ScheduleTerrainRebuild( bool refreshNoise = false, float delay = 0.5f )
	{
		if ( refreshNoise )
			_refreshNoisePending = true;

		if ( !Game.IsEditor )
		{
			ProcessPendingTerrainRebuild( force: true );
			return;
		}

		_rebuildPending = true;
		_rebuildDue = delay;
	}

	void ProcessPendingTerrainRebuild( bool force = false )
	{
		if ( !force )
		{
			if ( !_rebuildPending || !_rebuildDue )
				return;
		}

		_rebuildPending = false;

		var worldManager = GetWorldManager();
		if ( _refreshNoisePending && worldManager.IsValid() )
		{
			worldManager.RefreshNoiseImmediate();
			_refreshNoisePending = false;
		}

		ApplySettingChanges( force: true );
	}

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
		UpdateChunkLods( force: true );
		RebuildLoadedChunks();
	}

	bool ApplySettingChanges( bool force = false )
	{
		var worldManager = GetWorldManager();
		if ( !worldManager.IsValid() )
			return false;

		var layoutChanged = ChunkSize != _lastChunkSize || ViewDistance != _lastViewDistance
			|| ChunksPerFrame != _lastChunksPerFrame;
		var meshChanged = Resolution != _lastResolution;
		var lodChanged = UseLod != _lastUseLod
			|| Lod0Distance != _lastLod0Distance
			|| Lod1Distance != _lastLod1Distance
			|| Lod2Distance != _lastLod2Distance
			|| MinLodResolution != _lastMinLodResolution
			|| UseHeightBasedLod != _lastUseHeightBasedLod
			|| HeightLodScale != _lastHeightLodScale;
		var noiseChanged = worldManager.WorldSeed != _lastSeed
			|| worldManager.NoiseSettingsVersion != _lastNoiseSettingsVersion;
		var boundsChanged = worldManager.UseWorldBounds != _lastUseWorldBounds
			|| worldManager.WorldSize != _lastWorldSize
			|| worldManager.WorldMin != new Vector2( _lastWorldOrigin.x, _lastWorldOrigin.y );

		if ( !force && !layoutChanged && !meshChanged && !lodChanged && !noiseChanged && !boundsChanged )
			return false;

		if ( layoutChanged || boundsChanged )
			ClearAllChunks();

		SyncTrackedSettings();
		UpdateStreamedChunks();
		UpdateChunkLods( force: true );

		if ( meshChanged || lodChanged || noiseChanged || layoutChanged || boundsChanged )
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
			_lastUseWorldBounds = worldManager.UseWorldBounds;
			_lastWorldSize = worldManager.WorldSize;
			_lastWorldOrigin = worldManager.GameObject.WorldPosition;
		}

		_lastChunkSize = ChunkSize;
		_lastViewDistance = ViewDistance;
		_lastResolution = Resolution;
		_lastUseLod = UseLod;
		_lastLod0Distance = Lod0Distance;
		_lastLod1Distance = Lod1Distance;
		_lastLod2Distance = Lod2Distance;
		_lastMinLodResolution = MinLodResolution;
		_lastUseHeightBasedLod = UseHeightBasedLod;
		_lastHeightLodScale = HeightLodScale;
		_lastChunksPerFrame = ChunksPerFrame;
	}

	void ClearAllChunks()
	{
		foreach ( var go in LoadedChunks.Values )
			go?.Destroy();

		LoadedChunks.Clear();
		_chunkResolutions.Clear();
		_pendingChunks.Clear();
		_lastLodCenter = new ChunkCoord( int.MinValue, int.MinValue );
		_lastLodStreamPosition = new Vector3( float.MaxValue, float.MaxValue, float.MaxValue );

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

		if ( !TryGetStreamPosition( out var streamPosition ) )
			return;

		var center = WorldToChunk( streamPosition );
		var lodLevel = GetChunkLodLevel( coord, center, streamPosition );
		var chunkResolution = GetResolutionForLodLevel( lodLevel );

        var go = Scene.CreateObject();
        go.Name = $"Chunk ({coord.X}, {coord.Y}) L{lodLevel} r{chunkResolution}";
        go.Flags |= GameObjectFlags.NotSaved;
        go.Parent = terrainFolder;
        go.WorldPosition = new Vector3( coord.X * ChunkSize, coord.Y * ChunkSize, 0 );

        var terrain = go.Components.Create<TerrainChunkComponent>();
        terrain.ChunkStreamer = this;
        terrain.WorldManager = worldManager;
        terrain.Coord = coord;

		terrain.Build( chunkResolution );
		_chunkResolutions[coord] = chunkResolution;

        LoadedChunks[coord] = go;
	}

	public float GetChunkLodDistance( ChunkCoord coord, ChunkCoord center, Vector3 streamPosition )
	{
		var horizontal = Math.Max( Math.Abs( coord.X - center.X ), Math.Abs( coord.Y - center.Y ) );

		if ( !UseHeightBasedLod || HeightLodScale <= 0f )
			return horizontal;

		var worldManager = GetWorldManager();
		if ( !worldManager.IsValid() )
			return horizontal;

		var chunkCenterX = coord.X * ChunkSize + ChunkSize * 0.5f;
		var chunkCenterY = coord.Y * ChunkSize + ChunkSize * 0.5f;
		var terrainHeight = worldManager.GetHeight( chunkCenterX, chunkCenterY );

		var offset = new Vector3(
			streamPosition.x - chunkCenterX,
			streamPosition.y - chunkCenterY,
			streamPosition.z - terrainHeight );

		var distanceInChunks = offset.Length / ChunkSize * HeightLodScale;

		return MathF.Max( horizontal, distanceInChunks );
	}

	public int GetChunkLodLevel( ChunkCoord coord, ChunkCoord center, Vector3 streamPosition )
	{
		var distance = GetChunkLodDistance( coord, center, streamPosition );

		if ( distance <= Lod0Distance )
			return 0;

		if ( distance <= Lod1Distance )
			return 1;

		if ( distance <= Lod2Distance )
			return 2;

		return 3;
	}

	public int GetChunkResolution( ChunkCoord coord, ChunkCoord center, Vector3 streamPosition )
	{
		if ( !UseLod )
			return Resolution;

		return GetResolutionForLodLevel( GetChunkLodLevel( coord, center, streamPosition ) );
	}

	int GetResolutionForLodLevel( int lodLevel )
	{
		EnsureLodResolutionTable();

		return _lodResolutions[Math.Clamp( lodLevel, 0, _lodResolutions.Length - 1 )];
	}

	void EnsureLodResolutionTable()
	{
		if ( _lodResolutions is not null
			&& _cachedLodResolution == Resolution
			&& _cachedMinLodResolution == MinLodResolution )
		{
			return;
		}

		_cachedLodResolution = Resolution;
		_cachedMinLodResolution = MinLodResolution;

		_lodResolutions = new int[4];
		_lodResolutions[0] = Resolution;

		for ( var i = 1; i < 3; i++ )
		{
			var halved = Resolution >> i;
			var previous = _lodResolutions[i - 1];
			_lodResolutions[i] = Math.Max( Math.Min( halved, previous - 1 ), MinLodResolution );
		}

		_lodResolutions[3] = MinLodResolution;

		for ( var i = 2; i >= 0; i-- )
		{
			if ( _lodResolutions[i] <= _lodResolutions[i + 1] )
				_lodResolutions[i] = Math.Min( Resolution, _lodResolutions[i + 1] + 1 );
		}
	}

	bool AnyChunkNeedsLodUpdate( ChunkCoord center, Vector3 streamPosition )
	{
		foreach ( var entry in LoadedChunks )
		{
			var targetResolution = GetChunkResolution( entry.Key, center, streamPosition );
			if ( !_chunkResolutions.TryGetValue( entry.Key, out var currentResolution ) || currentResolution != targetResolution )
				return true;
		}

		return false;
	}

	void UpdateChunkLod( GameObject chunkObject, ChunkCoord coord, int lodLevel, int targetResolution )
	{
		if ( !chunkObject.IsValid() )
			return;

		var terrain = chunkObject.GetComponent<TerrainChunkComponent>();
		if ( !terrain.IsValid() )
			return;

		terrain.Build( targetResolution );
		_chunkResolutions[coord] = targetResolution;
		chunkObject.Name = $"Chunk ({coord.X}, {coord.Y}) L{lodLevel} r{targetResolution}";
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
				if ( !worldManager.ChunkIntersectsWorld( coord, ChunkSize ) )
					continue;

				if ( !LoadedChunks.ContainsKey( coord ) )
					_pendingChunks.Add( coord );
			}
		}

		foreach ( var entry in LoadedChunks.ToArray() )
		{
			var coord = entry.Key;
			if ( Math.Abs( coord.X - center.X ) > ViewDistance || Math.Abs( coord.Y - center.Y ) > ViewDistance )
			{
				entry.Value?.Destroy();
				LoadedChunks.Remove( coord );
				_chunkResolutions.Remove( coord );
				_pendingChunks.Remove( coord );
				continue;
			}

			if ( !worldManager.ChunkIntersectsWorld( coord, ChunkSize ) )
			{
				entry.Value?.Destroy();
				LoadedChunks.Remove( coord );
				_chunkResolutions.Remove( coord );
				_pendingChunks.Remove( coord );
			}
		}
	}

	void ProcessPendingChunks()
	{
		if ( _pendingChunks.Count == 0 )
			return;

		var budget = Math.Max( ChunksPerFrame, 1 );
		var created = 0;

		foreach ( var coord in _pendingChunks.ToArray() )
		{
			if ( created >= budget )
				break;

			if ( LoadedChunks.ContainsKey( coord ) )
			{
				_pendingChunks.Remove( coord );
				continue;
			}

			CreateChunk( coord );
			_pendingChunks.Remove( coord );
			created++;
		}
	}

	void UpdateChunkLods( bool force = false )
	{
		if ( !UseLod && !force )
			return;

		if ( !TryGetStreamPosition( out var streamPosition ) )
			return;

		var center = WorldToChunk( streamPosition );
		var movedChunk = center != _lastLodCenter;
		var movedWorld = (streamPosition - _lastLodStreamPosition).Length > ChunkSize * 0.25f;
		var needsUpdate = force || movedChunk || movedWorld || AnyChunkNeedsLodUpdate( center, streamPosition );

		if ( !needsUpdate )
			return;

		_lastLodCenter = center;
		_lastLodStreamPosition = streamPosition;

		foreach ( var entry in LoadedChunks.ToArray() )
		{
			var coord = entry.Key;
			var lodLevel = GetChunkLodLevel( coord, center, streamPosition );
			var targetResolution = GetResolutionForLodLevel( lodLevel );

			if ( _chunkResolutions.TryGetValue( coord, out var currentResolution ) && currentResolution == targetResolution )
				continue;

			UpdateChunkLod( entry.Value, coord, lodLevel, targetResolution );
		}
	}

	void RebuildLoadedChunks()
	{
		if ( !TryGetStreamPosition( out var streamPosition ) )
			return;

		var center = WorldToChunk( streamPosition );

		foreach ( var entry in LoadedChunks.ToArray() )
		{
			if ( !entry.Value.IsValid() )
				continue;

			var terrain = entry.Value.GetComponent<TerrainChunkComponent>();
			if ( !terrain.IsValid() )
				continue;

			var lodLevel = GetChunkLodLevel( terrain.Coord, center, streamPosition );
			var resolution = GetResolutionForLodLevel( lodLevel );
			UpdateChunkLod( entry.Value, terrain.Coord, lodLevel, resolution );
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
				_terrainFolder.Flags |= GameObjectFlags.NotSaved;
				return _terrainFolder;
			}
		}

		_terrainFolder = Scene.CreateObject();
		_terrainFolder.Name = TerrainFolderName;
		_terrainFolder.Flags |= GameObjectFlags.NotSaved;
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
