using System.Threading.Tasks;
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

    [Property, Group( "Chunk Streamer" ), Title( "Camera" ), Description( "Optional play-mode camera. In the editor, the scene viewport is used when this is empty." )]
    public CameraComponent Camera { get; set; }

	[Property, Group( "Chunk Streamer" ), Title( "Chunk Size" ), Change( nameof( OnLayoutChanged ) )]
    public int ChunkSize { get; set; } = 2048;

	int SafeChunkSize => Math.Max( ChunkSize, 1 );

	public int EffectiveChunkSize => SafeChunkSize;

    [Property, Group( "Chunk Streamer" ), Title( "View Distance" ), Description( "Chunk radius around the camera. Total loaded chunks is roughly (2 x distance + 1)^2. Values above 8 can be heavy." ), Range( 1, 12 ), Change( nameof( OnLayoutChanged ) )]
	public int ViewDistance { get; set; } = 4;

	[Property, Group( "Chunk Streamer" ), Title( "Max Loaded Chunks" ), Description( "Safety cap for simultaneously loaded chunks." ), Range( 16, 512 ), Change( nameof( OnLayoutChanged ) )]
	public int MaxLoadedChunks { get; set; } = 256;

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

	[Property, Group( "Chunk Streamer" ), Title( "Chunks Per Frame" ), Description( "How many new chunk builds are started per update." ), Range( 1, 16 ), Change( nameof( OnLayoutChanged ) )]
	public int ChunksPerFrame { get; set; } = 4;

	[Property, Group( "Chunk Streamer" ), Title( "Max Concurrent Builds" ), Description( "How many chunks can generate mesh data on worker threads at once." ), Range( 1, 16 ), Change( nameof( OnLayoutChanged ) )]
	public int MaxConcurrentBuilds { get; set; } = 4;

	[Property, Group( "Chunk Streamer" ), Title( "Unloads Per Frame" ), Description( "How many chunks are destroyed per update when shrinking view distance." ), Range( 1, 32 ), Change( nameof( OnLayoutChanged ) )]
	public int UnloadsPerFrame { get; set; } = 8;

	[Property, Group( "Chunk Streamer" ), Title( "Lod Rebuilds Per Frame" ), Description( "How many chunk meshes can rebuild for LOD changes per update." ), Range( 1, 32 ), Change( nameof( OnLodSettingsChanged ) )]
	public int LodRebuildsPerFrame { get; set; } = 4;

	const string TerrainFolderName = "Terrain";

	Dictionary<ChunkCoord, GameObject> LoadedChunks = new();
	Dictionary<ChunkCoord, GameObject> _buildingChunkObjects = new();
	Dictionary<ChunkCoord, int> _chunkResolutions = new();
	HashSet<ChunkCoord> _pendingChunks = new();
	HashSet<ChunkCoord> _buildingChunks = new();
	HashSet<ChunkCoord> _pendingLodRebuilds = new();
	int _terrainBuildGeneration;
	int _activeWorkerBuilds;
	ChunkCoord _lastLodCenter = new( int.MinValue, int.MinValue );
	Vector3 _lastLodStreamPosition = new( float.MaxValue, float.MaxValue, float.MaxValue );
	GameObject _terrainFolder;
	RealTimeUntil _rebuildDue;
	bool _rebuildPending;
	bool _refreshNoisePending;
	int _lastSeed = int.MinValue;
	int _lastNoiseSettingsVersion = -1;
	int _lastTerrainSettingsVersion = -1;
	bool _fullReloadPending;
	bool _needsInitialTerrainRebuild = true;
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
	int _lastMaxConcurrentBuilds;
	int _lastMaxLoadedChunks;
	int _lastUnloadsPerFrame;
	int _lastLodRebuildsPerFrame;
	int[] _lodResolutions;
	int _cachedLodResolution;
	int _cachedMinLodResolution;
	bool _lastUseWorldBounds;
	Vector2 _lastWorldSize;
	Vector3 _lastWorldOrigin;
	bool _settingsInitialized;

	public int TerrainBuildGeneration => _terrainBuildGeneration;

	Vector3 _cachedEditorViewportPosition;
	Rotation _cachedEditorViewportRotation;
	bool _hasCachedEditorViewport;

	protected override void OnAwake()
	{
		GetTerrainFolder();
		_settingsInitialized = true;
	}

	protected override void OnStart()
	{
		EnsureTerrain();
	}

	protected override void OnValidate()
	{
		NormalizeLodDistances();

		if ( !Game.IsEditor || Game.IsPlaying || Scene is null || !GameObject.IsValid() )
			return;

		ScheduleTerrainRebuild();
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
		if ( Scene is null || !GameObject.IsValid() )
			return;

		if ( IsEditMode )
			return;

		try
		{
			RunUpdate();
		}
		catch ( Exception exception )
		{
			Log.Error( $"Chunk Streamer update failed: {exception.Message}\n{exception.StackTrace}" );
		}
    }

	protected override void DrawGizmos()
	{
		if ( !IsEditMode || Scene is null || !GameObject.IsValid() )
			return;

		if ( !TryGetEditorCameraTransform( out var viewportTransform ) )
			return;

		_cachedEditorViewportPosition = viewportTransform.Position;
		_cachedEditorViewportRotation = viewportTransform.Rotation;
		_hasCachedEditorViewport = true;

		try
		{
			RunUpdate();
		}
		catch ( Exception exception )
		{
			Log.Error( $"Chunk Streamer edit-mode update failed: {exception.Message}\n{exception.StackTrace}" );
		}
	}

	void RunUpdate()
	{
		var worldManager = GetWorldManager();
		if ( !worldManager.IsValid() || !worldManager.GameObject.IsValid() )
			return;

		if ( _needsInitialTerrainRebuild )
		{
			_needsInitialTerrainRebuild = false;
			worldManager.RefreshNoiseImmediate();
			ProcessPendingTerrainRebuild( force: true );
		}

		ProcessPendingTerrainRebuild();
		ApplySettingChanges();

		UpdateStreamedChunks();
		ProcessPendingChunks();
		ProcessPendingLodRebuilds();
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

	public void ScheduleTerrainRebuild( bool refreshNoise = false, float delay = 0.5f, bool fullReload = false )
	{
		if ( refreshNoise )
			_refreshNoisePending = true;

		if ( fullReload )
			_fullReloadPending = true;

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

		if ( _fullReloadPending )
		{
			_fullReloadPending = false;
			RequestLayoutRebuild();
			return;
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
		if ( Scene is null || !GameObject.IsValid() )
			return;

		SyncTrackedSettings();
		UpdateStreamedChunks();
		UpdateChunkLods( force: true );
		RebuildLoadedChunks();
	}

	bool ApplySettingChanges( bool force = false )
	{
		var worldManager = GetWorldManager();
		if ( !worldManager.IsValid() || !worldManager.GameObject.IsValid() )
			return false;

		var worldMin = worldManager.WorldMin;

		var chunkGridChanged = ChunkSize != _lastChunkSize;
		var viewRangeChanged = ViewDistance != _lastViewDistance
			|| ChunksPerFrame != _lastChunksPerFrame
			|| MaxConcurrentBuilds != _lastMaxConcurrentBuilds
			|| MaxLoadedChunks != _lastMaxLoadedChunks
			|| UnloadsPerFrame != _lastUnloadsPerFrame;
		var layoutChanged = chunkGridChanged || viewRangeChanged;
		var meshChanged = Resolution != _lastResolution;
		var lodChanged = UseLod != _lastUseLod
			|| Lod0Distance != _lastLod0Distance
			|| Lod1Distance != _lastLod1Distance
			|| Lod2Distance != _lastLod2Distance
			|| MinLodResolution != _lastMinLodResolution
			|| UseHeightBasedLod != _lastUseHeightBasedLod
			|| HeightLodScale != _lastHeightLodScale
			|| LodRebuildsPerFrame != _lastLodRebuildsPerFrame;
		var noiseChanged = worldManager.WorldSeed != _lastSeed
			|| worldManager.NoiseSettingsVersion != _lastNoiseSettingsVersion;
		var terrainSettingsChanged = worldManager.TerrainSettingsVersion != _lastTerrainSettingsVersion;
		var boundsChanged = worldManager.UseWorldBounds != _lastUseWorldBounds
			|| worldManager.WorldSize != _lastWorldSize
			|| worldMin != new Vector2( _lastWorldOrigin.x, _lastWorldOrigin.y );

		if ( !force && !layoutChanged && !meshChanged && !lodChanged && !noiseChanged && !terrainSettingsChanged && !boundsChanged )
			return false;

		if ( chunkGridChanged || boundsChanged )
			ClearAllChunks();

		SyncTrackedSettings();
		UpdateStreamedChunks();

		if ( meshChanged || lodChanged || noiseChanged )
			_terrainBuildGeneration++;

		if ( meshChanged || lodChanged || noiseChanged || chunkGridChanged || boundsChanged )
			QueueLodRebuilds( force: true );

		return true;
	}

	void SyncTrackedSettings()
	{
		var worldManager = GetWorldManager();
		if ( worldManager.IsValid() && worldManager.GameObject.IsValid() )
		{
			_lastSeed = worldManager.WorldSeed;
			_lastNoiseSettingsVersion = worldManager.NoiseSettingsVersion;
			_lastTerrainSettingsVersion = worldManager.TerrainSettingsVersion;
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
		_lastMaxConcurrentBuilds = MaxConcurrentBuilds;
		_lastMaxLoadedChunks = MaxLoadedChunks;
		_lastUnloadsPerFrame = UnloadsPerFrame;
		_lastLodRebuildsPerFrame = LodRebuildsPerFrame;
	}

	void ClearAllChunks()
	{
		_terrainBuildGeneration++;

		foreach ( var go in LoadedChunks.Values )
			go?.Destroy();

		foreach ( var go in _buildingChunkObjects.Values )
			go?.Destroy();

		LoadedChunks.Clear();
		_buildingChunkObjects.Clear();
		_chunkResolutions.Clear();
		_pendingChunks.Clear();
		_buildingChunks.Clear();
		_pendingLodRebuilds.Clear();
		_activeWorkerBuilds = 0;
		_lastLodCenter = new ChunkCoord( int.MinValue, int.MinValue );
		_lastLodStreamPosition = new Vector3( float.MaxValue, float.MaxValue, float.MaxValue );

		if ( !_terrainFolder.IsValid() )
			_terrainFolder = null;
	}

	void StartChunkBuild( ChunkCoord coord )
	{
		var worldManager = GetWorldManager();
		if ( !worldManager.IsValid() || !worldManager.GameObject.IsValid() || Scene is null )
			return;

		var terrainFolder = GetTerrainFolder();
		if ( !terrainFolder.IsValid() )
			return;

		if ( !TryGetStreamPosition( out var streamPosition ) )
			return;

		var center = WorldToChunk( streamPosition );
		var lodLevel = GetChunkLodLevel( coord, center, streamPosition );
		var chunkResolution = GetResolutionForLodLevel( lodLevel );
		var buildGeneration = _terrainBuildGeneration;

		var go = Scene.CreateObject();
		if ( !go.IsValid() )
			return;

		go.Name = $"Chunk ({coord.X}, {coord.Y}) L{lodLevel} r{chunkResolution}";
		go.Flags |= GameObjectFlags.NotSaved;
		go.Parent = terrainFolder;
		go.WorldPosition = new Vector3( coord.X * SafeChunkSize, coord.Y * SafeChunkSize, 0 );

		var terrain = go.Components.Create<TerrainChunkComponent>();
		terrain.ChunkStreamer = this;
		terrain.WorldManager = worldManager;
		terrain.Coord = coord;

		_buildingChunks.Add( coord );
		_buildingChunkObjects[coord] = go;

		var snapshot = TerrainBuildSnapshot.FromWorldManager(
			worldManager,
			go.WorldPosition,
			SafeChunkSize );

		QueueTerrainBuild(
			go,
			terrain,
			coord,
			snapshot,
			chunkResolution,
			lodLevel,
			buildGeneration,
			isNewChunk: true );
	}

	void QueueTerrainBuild(
		GameObject chunkObject,
		TerrainChunkComponent terrain,
		ChunkCoord coord,
		TerrainBuildSnapshot snapshot,
		int resolution,
		int lodLevel,
		int buildGeneration,
		bool isNewChunk )
	{
		terrain.SetBuilding( true );
		_activeWorkerBuilds++;

		_ = RunTerrainBuildAsync(
			chunkObject,
			terrain,
			coord,
			snapshot,
			resolution,
			lodLevel,
			buildGeneration,
			isNewChunk );
	}

	async Task RunTerrainBuildAsync(
		GameObject chunkObject,
		TerrainChunkComponent terrain,
		ChunkCoord coord,
		TerrainBuildSnapshot snapshot,
		int resolution,
		int lodLevel,
		int buildGeneration,
		bool isNewChunk )
	{
		try
		{
			var meshData = await GameTask.RunInThreadAsync( () => TerrainChunkMeshBuilder.Build(
				snapshot,
				resolution,
				terrain.EnableCollision,
				terrain.CollisionResolution ) );

			await GameTask.MainThread();

			if ( !chunkObject.IsValid() || !terrain.IsValid() || buildGeneration != _terrainBuildGeneration )
			{
				if ( isNewChunk )
					CancelBuildingChunk( coord );

				return;
			}

			if ( isNewChunk && !_buildingChunks.Contains( coord ) )
			{
				chunkObject.Destroy();
				return;
			}

			terrain.ApplyMeshData( meshData );

			if ( isNewChunk )
			{
				_buildingChunks.Remove( coord );
				_buildingChunkObjects.Remove( coord );
				LoadedChunks[coord] = chunkObject;
				_chunkResolutions[coord] = resolution;
				return;
			}

			_chunkResolutions[coord] = resolution;
			chunkObject.Name = $"Chunk ({coord.X}, {coord.Y}) L{lodLevel} r{resolution}";
		}
		catch ( Exception exception )
		{
			if ( chunkObject.IsValid() )
				Log.Error( $"Terrain build failed for {chunkObject.Name}: {exception.Message}" );

			if ( isNewChunk )
				CancelBuildingChunk( coord );
		}
		finally
		{
			if ( terrain.IsValid() )
				terrain.SetBuilding( false );

			_activeWorkerBuilds = Math.Max( 0, _activeWorkerBuilds - 1 );
		}
	}

	void CancelBuildingChunk( ChunkCoord coord )
	{
		_buildingChunks.Remove( coord );

		if ( _buildingChunkObjects.Remove( coord, out var chunkObject ) )
			chunkObject?.Destroy();
	}

	public float GetChunkLodDistance( ChunkCoord coord, ChunkCoord center, Vector3 streamPosition )
	{
		var horizontal = Math.Max( Math.Abs( coord.X - center.X ), Math.Abs( coord.Y - center.Y ) );

		if ( !UseHeightBasedLod || HeightLodScale <= 0f )
			return horizontal;

		var worldManager = GetWorldManager();
		if ( !worldManager.IsValid() || !worldManager.GameObject.IsValid() )
			return horizontal;

		var chunkCenterX = coord.X * SafeChunkSize + SafeChunkSize * 0.5f;
		var chunkCenterY = coord.Y * SafeChunkSize + SafeChunkSize * 0.5f;
		var terrainHeight = worldManager.GetHeight( chunkCenterX, chunkCenterY );

		var offset = new Vector3(
			streamPosition.x - chunkCenterX,
			streamPosition.y - chunkCenterY,
			streamPosition.z - terrainHeight );

		var distanceInChunks = offset.Length / SafeChunkSize * HeightLodScale;

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
		if ( !terrain.IsValid() || terrain.IsBuilding )
			return;

		var worldManager = GetWorldManager();
		if ( !worldManager.IsValid() || !worldManager.GameObject.IsValid() )
			return;

		var buildGeneration = _terrainBuildGeneration;
		var snapshot = TerrainBuildSnapshot.FromWorldManager(
			worldManager,
			chunkObject.WorldPosition,
			SafeChunkSize );

		QueueTerrainBuild(
			chunkObject,
			terrain,
			coord,
			snapshot,
			targetResolution,
			lodLevel,
			buildGeneration,
			isNewChunk: false );
	}

	void UpdateStreamedChunks()
	{
		var worldManager = GetWorldManager();
		if ( !worldManager.IsValid() || !worldManager.GameObject.IsValid() )
			return;

		GetTerrainFolder();

		if ( !TryGetStreamPosition( out var streamPosition ) )
			return;

		var center = WorldToChunk( streamPosition );
		var maxLoaded = Math.Max( MaxLoadedChunks, 16 );
		var unloadBudget = Math.Max( UnloadsPerFrame, 1 );
		var unloaded = 0;

		foreach ( var entry in LoadedChunks.ToArray() )
		{
			var coord = entry.Key;
			if ( !ShouldUnloadChunk( coord, center, worldManager ) )
				continue;

			if ( unloaded >= unloadBudget )
				continue;

			DestroyChunk( coord, entry.Value );
			unloaded++;
		}

		foreach ( var coord in _buildingChunks.ToArray() )
		{
			if ( !ShouldUnloadChunk( coord, center, worldManager ) )
				continue;

			if ( unloaded >= unloadBudget )
				continue;

			CancelBuildingChunk( coord );
			unloaded++;
		}

		for ( int x = -ViewDistance; x <= ViewDistance; x++ )
		{
			for ( int y = -ViewDistance; y <= ViewDistance; y++ )
			{
				if ( GetActiveChunkCount() >= maxLoaded )
					return;

				var coord = new ChunkCoord( center.X + x, center.Y + y );
				if ( !worldManager.ChunkIntersectsWorld( coord, ChunkSize ) )
					continue;

				if ( !LoadedChunks.ContainsKey( coord ) && !_buildingChunks.Contains( coord ) )
					_pendingChunks.Add( coord );
			}
		}
	}

	bool ShouldUnloadChunk( ChunkCoord coord, ChunkCoord center, WorldManagerSingletonComponent worldManager )
	{
		var outsideView = Math.Abs( coord.X - center.X ) > ViewDistance || Math.Abs( coord.Y - center.Y ) > ViewDistance;
		var outsideWorld = !worldManager.ChunkIntersectsWorld( coord, ChunkSize );
		return outsideView || outsideWorld;
	}

	int GetActiveChunkCount() => LoadedChunks.Count + _pendingChunks.Count + _buildingChunks.Count;

	void DestroyChunk( ChunkCoord coord, GameObject chunkObject )
	{
		chunkObject?.Destroy();
		LoadedChunks.Remove( coord );
		_chunkResolutions.Remove( coord );
		_pendingChunks.Remove( coord );
		_pendingLodRebuilds.Remove( coord );
	}

	void ProcessPendingChunks()
	{
		if ( _pendingChunks.Count == 0 )
			return;

		var maxLoaded = Math.Max( MaxLoadedChunks, 16 );
		var startBudget = Math.Max( ChunksPerFrame, 1 );
		var concurrentBudget = Math.Max( MaxConcurrentBuilds, 1 );
		var started = 0;

		foreach ( var coord in _pendingChunks.ToArray() )
		{
			if ( started >= startBudget || GetActiveChunkCount() >= maxLoaded )
				break;

			if ( _activeWorkerBuilds >= concurrentBudget )
				break;

			if ( LoadedChunks.ContainsKey( coord ) || _buildingChunks.Contains( coord ) )
			{
				_pendingChunks.Remove( coord );
				continue;
			}

			_pendingChunks.Remove( coord );
			StartChunkBuild( coord );
			started++;
		}
	}

	void QueueLodRebuilds( bool force = false )
	{
		if ( !TryGetStreamPosition( out var streamPosition ) )
			return;

		var center = WorldToChunk( streamPosition );

		foreach ( var entry in LoadedChunks )
		{
			var targetResolution = GetChunkResolution( entry.Key, center, streamPosition );
			if ( !_chunkResolutions.TryGetValue( entry.Key, out var currentResolution ) || currentResolution != targetResolution )
				_pendingLodRebuilds.Add( entry.Key );
		}

		if ( force )
			return;

		_lastLodCenter = center;
		_lastLodStreamPosition = streamPosition;
	}

	void ProcessPendingLodRebuilds()
	{
		if ( _pendingLodRebuilds.Count == 0 )
			return;

		if ( !TryGetStreamPosition( out var streamPosition ) )
			return;

		var center = WorldToChunk( streamPosition );
		var budget = Math.Max( LodRebuildsPerFrame, 1 );
		var rebuilt = 0;

		var concurrentBudget = Math.Max( MaxConcurrentBuilds, 1 );

		foreach ( var coord in _pendingLodRebuilds.ToArray() )
		{
			if ( rebuilt >= budget || _activeWorkerBuilds >= concurrentBudget )
				break;

			if ( !LoadedChunks.TryGetValue( coord, out var chunkObject ) || !chunkObject.IsValid() )
			{
				_pendingLodRebuilds.Remove( coord );
				continue;
			}

			var lodLevel = GetChunkLodLevel( coord, center, streamPosition );
			var targetResolution = GetResolutionForLodLevel( lodLevel );

			if ( _chunkResolutions.TryGetValue( coord, out var currentResolution ) && currentResolution == targetResolution )
			{
				_pendingLodRebuilds.Remove( coord );
				continue;
			}

			var terrain = chunkObject.GetComponent<TerrainChunkComponent>();
			if ( terrain.IsValid() && terrain.IsBuilding )
				continue;

			UpdateChunkLod( chunkObject, coord, lodLevel, targetResolution );
			_pendingLodRebuilds.Remove( coord );
			rebuilt++;
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
		var movedWorld = (streamPosition - _lastLodStreamPosition).Length > SafeChunkSize * 0.25f;
		var needsUpdate = force || movedChunk || movedWorld || AnyChunkNeedsLodUpdate( center, streamPosition );

		if ( !needsUpdate )
			return;

		_lastLodCenter = center;
		_lastLodStreamPosition = streamPosition;
		QueueLodRebuilds();
	}

	void RebuildLoadedChunks()
	{
		QueueLodRebuilds( force: true );
	}

	public bool TryGetStreamWorldPosition( out Vector3 position ) => TryGetStreamPosition( out position );

	public bool TryGetStreamChunkCenter( out ChunkCoord center )
	{
		center = default;

		if ( !TryGetStreamPosition( out var streamPosition ) )
			return false;

		center = WorldToChunk( streamPosition );
		return true;
	}

	public void CopyLoadedChunkCoords( List<ChunkCoord> coords )
	{
		coords.Clear();

		foreach ( var coord in LoadedChunks.Keys )
			coords.Add( coord );
	}

	public void CopyPendingChunkCoords( List<ChunkCoord> coords )
	{
		coords.Clear();

		foreach ( var coord in _pendingChunks )
			coords.Add( coord );

		foreach ( var coord in _buildingChunks )
			coords.Add( coord );
	}

	public int LoadedChunkCount => LoadedChunks.Count;

	public int PendingChunkCount => _pendingChunks.Count + _buildingChunks.Count;

	public bool IsViewLoaded()
	{
		var worldManager = GetWorldManager();
		if ( !worldManager.IsValid() || !worldManager.GameObject.IsValid() )
			return true;

		if ( !TryGetStreamPosition( out var streamPosition ) )
			return false;

		if ( _pendingChunks.Count > 0 || _buildingChunks.Count > 0 )
			return false;

		var center = WorldToChunk( streamPosition );
		var chunkSize = SafeChunkSize;

		for ( var x = -ViewDistance; x <= ViewDistance; x++ )
		{
			for ( var y = -ViewDistance; y <= ViewDistance; y++ )
			{
				var coord = new ChunkCoord( center.X + x, center.Y + y );
				if ( !worldManager.ChunkIntersectsWorld( coord, chunkSize ) )
					continue;

				if ( !LoadedChunks.ContainsKey( coord ) )
					return false;
			}
		}

		return true;
	}

	public bool TryGetStreamViewForward( out Vector2 forward )
	{
		forward = default;

		if ( !TryGetStreamViewRotation( out var rotation ) )
			return false;

		forward = new Vector2( rotation.Forward.x, rotation.Forward.y );
		if ( forward.LengthSquared <= 0.0001f )
			return false;

		forward = forward.Normal;
		return true;
	}

	bool IsEditMode => Game.IsEditor && !Game.IsPlaying;

	bool TryGetStreamViewRotation( out Rotation rotation )
	{
		rotation = Rotation.Identity;

		if ( IsEditMode )
			return TryGetEditModeViewportRotation( out rotation );

		if ( Camera.IsValid() )
		{
			rotation = Camera.WorldRotation;
			return true;
		}

		if ( TryGetActiveCamera( out var activeCamera ) )
		{
			rotation = activeCamera.WorldRotation;
			return true;
		}

		return false;
	}

	bool TryGetEditModeViewportRotation( out Rotation rotation )
	{
		rotation = Rotation.Identity;

		if ( TryGetEditorCameraTransform( out var transform ) )
		{
			rotation = transform.Rotation;
			return true;
		}

		if ( _hasCachedEditorViewport )
		{
			rotation = _cachedEditorViewportRotation;
			return true;
		}

		return false;
	}

	WorldManagerSingletonComponent GetWorldManager()
	{
		if ( WorldManager.IsValid() )
			return WorldManager;

		var instance = WorldManagerSingletonComponent.Instance;
		if ( instance.IsValid() )
			return instance;

		return null;
	}

	GameObject GetTerrainFolder()
	{
		if ( _terrainFolder.IsValid() )
			return _terrainFolder;

		if ( Scene is null || !GameObject.IsValid() )
			return null;

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
		if ( !_terrainFolder.IsValid() )
		{
			_terrainFolder = null;
			return null;
		}

		_terrainFolder.Name = TerrainFolderName;
		_terrainFolder.Flags |= GameObjectFlags.NotSaved;
		_terrainFolder.Parent = GameObject;

		return _terrainFolder;
	}

	bool TryGetStreamPosition( out Vector3 position )
	{
		position = WorldPosition;

		if ( IsEditMode )
		{
			if ( _hasCachedEditorViewport )
			{
				position = _cachedEditorViewportPosition;
				return true;
			}

			if ( TryGetEditorCameraTransform( out var transform ) )
			{
				position = transform.Position;
				return true;
			}

			return true;
		}

		if ( Camera.IsValid() )
		{
			position = Camera.WorldPosition;
			return true;
		}

		if ( TryGetActiveCamera( out var activeCamera ) )
		{
			position = activeCamera.WorldPosition;
			return true;
		}

		if ( TryGetPlayModeStreamPosition( out position ) )
			return true;

		return true;
	}

	bool TryGetActiveCamera( out CameraComponent camera )
	{
		camera = null;

		var scenes = new List<Scene>();
		if ( Game.ActiveScene.IsValid() )
			scenes.Add( Game.ActiveScene );
		if ( Scene is not null && Scene != Game.ActiveScene )
			scenes.Add( Scene );

		foreach ( var scene in scenes )
		{
			if ( TryGetSceneCamera( scene, out camera ) )
				return true;
		}

		return false;
	}

	static bool TryGetSceneCamera( Scene scene, out CameraComponent camera )
	{
		camera = null;
		if ( scene is null )
			return false;

		try
		{
			var sceneCamera = scene.Camera;
			if ( sceneCamera.IsValid() )
			{
				camera = sceneCamera;
				return true;
			}
		}
		catch ( Exception exception )
		{
			Log.Warning( $"Scene camera lookup failed: {exception.Message}" );
		}

		foreach ( var candidate in scene.GetAllComponents<CameraComponent>() )
		{
			if ( !candidate.IsValid() || !candidate.Enabled )
				continue;

			camera = candidate;
			return true;
		}

		return false;
	}

	bool TryGetPlayModeStreamPosition( out Vector3 position )
	{
		position = WorldPosition;

		if ( ClientComponent.Local.IsValid() && ClientComponent.Local.PlayerPawn.IsValid() )
		{
			position = ClientComponent.Local.PlayerPawn.WorldPosition;
			return true;
		}

		if ( Scene is null )
			return false;

		foreach ( var controller in Scene.GetAllComponents<PlayerController>() )
		{
			if ( !controller.IsValid() || !controller.GameObject.IsValid() )
				continue;

			position = controller.GameObject.WorldPosition;
			return true;
		}

		return false;
	}

	static bool TryGetEditorCameraTransform( out Transform transform )
	{
		transform = default;

		if ( !Game.IsEditor || Game.IsPlaying )
			return false;

		try
		{
			transform = Gizmo.CameraTransform;
			return true;
		}
		catch ( Exception exception )
		{
			Log.Warning( $"Editor viewport transform unavailable: {exception.Message}" );
			return false;
		}
	}

	public static bool TryGetEditorViewportPosition( out Vector3 position )
	{
		position = default;

		if ( !TryGetEditorCameraTransform( out var transform ) )
			return false;

		position = transform.Position;
		return true;
	}

	public static bool TryGetEditorViewportRotation( out Rotation rotation )
	{
		rotation = Rotation.Identity;

		if ( !TryGetEditorCameraTransform( out var transform ) )
			return false;

		rotation = transform.Rotation;
		return true;
	}

	ChunkCoord WorldToChunk( Vector3 worldPos )
	{
		var chunkSize = SafeChunkSize;
		return new ChunkCoord(
			(int)MathF.Floor( worldPos.x / chunkSize ),
			(int)MathF.Floor( worldPos.y / chunkSize )
		);
	}
}
