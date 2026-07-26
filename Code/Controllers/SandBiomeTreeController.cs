using Sandbox.Components;
using Sandbox.Components.SingletonComponents;
using Sandbox.Models;
using Sandbox.Renderers;

namespace Sandbox.Controllers;

/// <summary>
/// Streams deterministic tree placements alongside terrain chunks.
/// Trees only grow on gentle, dry sand, with higher density near the shoreline.
/// </summary>
[Title( "Sand Biome Tree Controller" ), Category( "World" ), Icon( "forest" )]
public sealed class SandBiomeTreeController : Component, Component.ExecuteInEditor
{
	const string DefaultModelPath = "models/foliage/quiver_tree_02/quiver_tree_02.vmdl";
	const string DefaultBillboardModelPath = "models/foliage/quiver_tree_02/quiver_tree_02_billboard.vmdl";
	const string TreeFolderPrefix = "Sand Biome Trees";

	[Property, Group( "References" )]
	public WorldManagerSingletonComponent WorldManager { get; set; }

	[Property, Group( "References" )]
	public ChunkStreamerComponent ChunkStreamer { get; set; }

	[Property, Group( "Configuration" ), Change( nameof( RequestRebuild ) )]
	public SandBiomeTreeDefinition Definition { get; set; }

	readonly Dictionary<ChunkCoord, GameObject> _chunkRoots = new();
	readonly List<ChunkCoord> _loadedChunks = new();
	readonly HashSet<ChunkCoord> _loadedChunkSet = new();

	GameObject _treeFolder;
	Model _fallbackModel;
	Model _fallbackBillboardModel;
	FastNoiseLite _clusterNoise;
	int _lastWorldSeed = int.MinValue;
	int _lastTerrainVersion = -1;
	int _lastConfigHash;
	bool _rebuildRequested = true;

	int MaxTreesPerChunk => Math.Max( Definition?.MaxTreesPerChunk ?? 8, 1 );
	float MinimumSpacing => Math.Max( Definition?.MinimumSpacing ?? 1400f, 64f );
	float BaseSpawnChance => MathX.Clamp( Definition?.BaseSpawnChance ?? 0.38f, 0f, 1f );
	float ClusterScale => Math.Max( Definition?.ClusterScale ?? 9000f, 128f );
	float MinSandWeight => MathX.Clamp( Definition?.MinSandWeight ?? 0.28f, 0f, 1f );
	float MaxSlope => Math.Max( Definition?.MaxSlope ?? 12f, 0f );
	float MoistureHeightRange => Math.Max( Definition?.MoistureHeightRange ?? 12000f, 1f );
	float ScaleMin => Math.Max( Definition?.ScaleMin ?? 72f, 0.01f );
	float ScaleMax => Math.Max( Definition?.ScaleMax ?? 110f, 0.01f );
	bool EnableCollision => Definition?.EnableCollision ?? true;
	GameObject TreePrefab => Definition?.TreePrefab;
	Model TreeModel => Definition?.TreeModel ?? (_fallbackModel ??= Model.Load( DefaultModelPath ));
	Model BillboardModel => Definition?.BillboardModel
		?? (_fallbackBillboardModel ??= Model.Load( DefaultBillboardModelPath ));
	float BillboardDistance => Math.Max( Definition?.BillboardDistance ?? 14000f, 1000f );
	bool ForceBillboard => Definition?.ForceBillboard ?? false;
	int DefinitionSeed => StableHash( Definition?.ResourceName ?? "default" );
	string TreeFolderName => $"{TreeFolderPrefix} ({Definition?.ResourceName ?? "Default"})";

	protected override void OnAwake()
	{
		ResolveReferences();
		RequestRebuild();
	}

	protected override void OnEnabled() => RequestRebuild();

	protected override void OnDisabled() => ClearTrees();

	protected override void OnDestroy() => ClearTrees();

	protected override void OnValidate() => RequestRebuild();

	protected override void OnUpdate()
	{
		ResolveReferences();
		if ( !WorldManager.IsValid() || !ChunkStreamer.IsValid() )
			return;

		var configHash = HashCode.Combine(
			HashCode.Combine( MaxTreesPerChunk, MinimumSpacing, BaseSpawnChance, ClusterScale ),
			HashCode.Combine( MinSandWeight, MaxSlope, MoistureHeightRange, ScaleMin ),
			HashCode.Combine( ScaleMax, EnableCollision, BillboardDistance, ForceBillboard, TreePrefab ) );

		if ( _lastWorldSeed != WorldManager.WorldSeed
			|| _lastTerrainVersion != WorldManager.TerrainSettingsVersion
			|| _lastConfigHash != configHash )
		{
			_rebuildRequested = true;
		}

		if ( _rebuildRequested )
			RebuildAll();

		SyncLoadedChunks();
	}

	void ResolveReferences()
	{
		if ( !WorldManager.IsValid() )
			WorldManager = WorldManagerSingletonComponent.Instance;

		if ( !ChunkStreamer.IsValid() )
			ChunkStreamer = GameObject.GetComponent<ChunkStreamerComponent>();
	}

	void RequestRebuild()
	{
		_rebuildRequested = true;
	}

	void RebuildAll()
	{
		ClearTrees();

		_lastWorldSeed = WorldManager.WorldSeed;
		_lastTerrainVersion = WorldManager.TerrainSettingsVersion;
		_lastConfigHash = HashCode.Combine(
			HashCode.Combine( MaxTreesPerChunk, MinimumSpacing, BaseSpawnChance, ClusterScale ),
			HashCode.Combine( MinSandWeight, MaxSlope, MoistureHeightRange, ScaleMin ),
			HashCode.Combine( ScaleMax, EnableCollision, BillboardDistance, ForceBillboard, TreePrefab ) );

		_clusterNoise = new FastNoiseLite();
		_clusterNoise.SetSeed( WorldManager.WorldSeed ^ DefinitionSeed ^ 0x4A39B70D );
		_clusterNoise.SetNoiseType( FastNoiseLite.NoiseType.OpenSimplex2 );
		_clusterNoise.SetFrequency( 1f / ClusterScale );

		_rebuildRequested = false;
	}

	void SyncLoadedChunks()
	{
		ChunkStreamer.CopyLoadedChunkCoords( _loadedChunks );
		_loadedChunkSet.Clear();

		foreach ( var coord in _loadedChunks )
		{
			_loadedChunkSet.Add( coord );
			if ( !_chunkRoots.ContainsKey( coord ) )
				BuildChunkTrees( coord );
		}

		foreach ( var entry in _chunkRoots.ToArray() )
		{
			if ( _loadedChunkSet.Contains( entry.Key ) )
				continue;

			entry.Value?.Destroy();
			_chunkRoots.Remove( entry.Key );
		}
	}

	void BuildChunkTrees( ChunkCoord coord )
	{
		var chunkRoot = Scene.CreateObject();
		if ( !chunkRoot.IsValid() )
			return;

		chunkRoot.Name = $"Sand Trees ({coord.X}, {coord.Y})";
		chunkRoot.Flags |= GameObjectFlags.NotSaved | GameObjectFlags.NotNetworked;
		chunkRoot.Parent = GetTreeFolder();
		_chunkRoots[coord] = chunkRoot;

		var model = TreeModel;
		if ( !model.IsValid() )
			return;

		var chunkSize = ChunkStreamer.EffectiveChunkSize;
		var minX = coord.X * chunkSize;
		var minY = coord.Y * chunkSize;
		var maxX = minX + chunkSize;
		var maxY = minY + chunkSize;
		var cellSize = MinimumSpacing / MathF.Sqrt( 2f );
		var minCellX = (int)MathF.Floor( minX / cellSize ) - 1;
		var maxCellX = (int)MathF.Ceiling( maxX / cellSize ) + 1;
		var minCellY = (int)MathF.Floor( minY / cellSize ) - 1;
		var maxCellY = (int)MathF.Ceiling( maxY / cellSize ) + 1;
		var spawned = 0;

		for ( var cellX = minCellX; cellX <= maxCellX && spawned < MaxTreesPerChunk; cellX++ )
		{
			for ( var cellY = minCellY; cellY <= maxCellY && spawned < MaxTreesPerChunk; cellY++ )
			{
				var candidate = GetCandidate( cellX, cellY, cellSize );
				if ( candidate.X < minX || candidate.X >= maxX || candidate.Y < minY || candidate.Y >= maxY )
					continue;

				if ( !WinsSpacingTest( candidate, cellX, cellY, cellSize ) )
					continue;

				if ( !TryGetPlacement( candidate, out var position ) )
					continue;

				SpawnTree( chunkRoot, model, position, candidate );
				spawned++;
			}
		}
	}

	bool TryGetPlacement( Candidate candidate, out Vector3 position )
	{
		position = default;
		if ( !WorldManager.TryGetWorldUv( candidate.X, candidate.Y, out _, out _ ) )
			return false;

		var terrain = WorldAmbientTerrainSample.Sample( WorldManager, candidate.X, candidate.Y );
		if ( terrain.Water > 0f )
			return false;

		// This world's sand band is very thin, so accept soft sand OR the height sample band.
		var biome = WorldManager.GetBiomeSample( candidate.X, candidate.Y );
		var sandMin = MathF.Min( WorldManager.SandMinThreshold, WorldManager.SandMaxThreshold );
		var sandMax = MathF.Max( WorldManager.SandMinThreshold, WorldManager.SandMaxThreshold );
		var inSandBand = biome >= sandMin - 0.04f && biome <= sandMax + 0.08f;
		var sandDominant = terrain.Sand >= MinSandWeight
			&& terrain.Sand + 0.02f >= terrain.Grass
			&& terrain.Sand + 0.02f >= terrain.Rock;
		if ( !inSandBand && !sandDominant )
			return false;

		if ( terrain.Rock >= 0.65f )
			return false;

		var sampleRadius = MathF.Max( MinimumSpacing * 0.05f, 96f );
		var dx = MathF.Abs( WorldManager.GetHeight( candidate.X + sampleRadius, candidate.Y ) - terrain.Height ) / sampleRadius;
		var dy = MathF.Abs( WorldManager.GetHeight( candidate.X, candidate.Y + sampleRadius ) - terrain.Height ) / sampleRadius;
		var slope = MathF.Max( dx, dy );
		if ( slope > MaxSlope )
			return false;

		var heightMoisture = 1f - MathX.Clamp(
			(terrain.Height - WorldManager.WaterLevel) / MoistureHeightRange,
			0f,
			1f );
		var moisture = MathF.Max( terrain.Shore, heightMoisture );
		var cluster = MathX.Clamp(
			(_clusterNoise?.GetNoise( candidate.X, candidate.Y ) ?? 0f) * 0.5f + 0.5f,
			0f,
			1f );
		var ecology = MathX.Lerp( 0.45f, 1.8f, moisture ) * MathX.Lerp( 0.35f, 1.35f, cluster );
		var chance = MathX.Clamp( BaseSpawnChance * ecology, 0f, 1f );
		if ( candidate.SpawnRoll > chance )
			return false;

		position = terrain.GroundPosition;
		return true;
	}

	void SpawnTree( GameObject parent, Model model, Vector3 position, Candidate candidate )
	{
		var tree = TreePrefab.IsValid()
			? TreePrefab.Clone( new CloneConfig
			{
				Parent = parent,
				StartEnabled = false,
				Transform = new(),
				Name = "Sand Biome Tree"
			} )
			: Scene.CreateObject();

		if ( !tree.IsValid() )
			return;

		tree.Name = "Sand Biome Tree";
		tree.Flags |= GameObjectFlags.NotSaved | GameObjectFlags.NotNetworked;
		tree.Parent = parent;
		tree.WorldPosition = position;
		tree.WorldRotation = Rotation.FromYaw( candidate.Yaw );

		var lowScale = MathF.Min( ScaleMin, ScaleMax );
		var highScale = MathF.Max( ScaleMin, ScaleMax );
		var scale = MathX.Lerp( lowScale, highScale, candidate.ScaleRoll );
		tree.WorldScale = new Vector3( scale );
		tree.Tags.Set( "world", true );

		var presentation = tree.GetOrAddComponent<SandBiomeTreeRenderer>();
		presentation.Configure( model, BillboardModel, BillboardDistance, ForceBillboard );

		var collider = tree.GetOrAddComponent<ModelCollider>();
		collider.Enabled = EnableCollision;
		collider.Static = true;
		collider.Model = model;

		// The collider remains enabled while the renderer swaps between the
		// detailed mesh and billboard, so distant trees keep physical presence.
		tree.Enabled = true;
	}

	bool WinsSpacingTest( Candidate candidate, int cellX, int cellY, float cellSize )
	{
		var radiusSquared = MinimumSpacing * MinimumSpacing;

		for ( var offsetX = -2; offsetX <= 2; offsetX++ )
		{
			for ( var offsetY = -2; offsetY <= 2; offsetY++ )
			{
				if ( offsetX == 0 && offsetY == 0 )
					continue;

				var other = GetCandidate( cellX + offsetX, cellY + offsetY, cellSize );
				var dx = candidate.X - other.X;
				var dy = candidate.Y - other.Y;
				if ( dx * dx + dy * dy >= radiusSquared )
					continue;

				if ( other.Priority < candidate.Priority )
					return false;
			}
		}

		return true;
	}

	Candidate GetCandidate( int cellX, int cellY, float cellSize )
	{
		var random = new DeterministicRandom(
			HashCell( cellX, cellY, WorldManager.WorldSeed ^ DefinitionSeed ) );
		var jitterX = MathX.Lerp( 0.12f, 0.88f, random.NextFloat() );
		var jitterY = MathX.Lerp( 0.12f, 0.88f, random.NextFloat() );

		return new Candidate(
			(cellX + jitterX) * cellSize,
			(cellY + jitterY) * cellSize,
			random.NextUInt(),
			random.NextFloat(),
			random.NextFloat() * 360f,
			random.NextFloat() );
	}

	static uint HashCell( int x, int y, int seed )
	{
		unchecked
		{
			var hash = (uint)seed ^ 0x9E3779B9u;
			hash = (hash ^ (uint)x) * 0x85EBCA6Bu;
			hash = (hash ^ (uint)y) * 0xC2B2AE35u;
			hash ^= hash >> 16;
			return hash == 0 ? 0xA341316Cu : hash;
		}
	}

	static int StableHash( string value )
	{
		unchecked
		{
			var hash = 17;
			foreach ( var character in value )
				hash = hash * 31 + character;

			return hash;
		}
	}

	GameObject GetTreeFolder()
	{
		if ( _treeFolder.IsValid() )
			return _treeFolder;

		foreach ( var child in GameObject.Children )
		{
			if ( !child.IsValid() || child.Name != TreeFolderName )
				continue;

			_treeFolder = child;
			_treeFolder.Flags |= GameObjectFlags.NotSaved | GameObjectFlags.NotNetworked;
			return _treeFolder;
		}

		_treeFolder = Scene.CreateObject();
		_treeFolder.Name = TreeFolderName;
		_treeFolder.Flags |= GameObjectFlags.NotSaved | GameObjectFlags.NotNetworked;
		_treeFolder.Parent = GameObject;
		return _treeFolder;
	}

	void ClearTrees()
	{
		foreach ( var root in _chunkRoots.Values )
			root?.Destroy();

		_chunkRoots.Clear();
		_loadedChunks.Clear();
		_loadedChunkSet.Clear();

		if ( _treeFolder.IsValid() )
			_treeFolder.Destroy();

		_treeFolder = null;
	}

	readonly record struct Candidate(
		float X,
		float Y,
		uint Priority,
		float SpawnRoll,
		float Yaw,
		float ScaleRoll );

	struct DeterministicRandom
	{
		uint _state;

		public DeterministicRandom( uint seed )
		{
			_state = seed == 0 ? 0xA341316Cu : seed;
		}

		public uint NextUInt()
		{
			var value = _state;
			value ^= value << 13;
			value ^= value >> 17;
			value ^= value << 5;
			_state = value;
			return value;
		}

		public float NextFloat() => (NextUInt() & 0x00FFFFFFu) / 16777216f;
	}
}
