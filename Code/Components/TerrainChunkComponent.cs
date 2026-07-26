using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

public sealed class TerrainChunkComponent : Component
{
    [Property, Group( "Terrain" ), Title( "World Manager" )]
    public WorldManagerSingletonComponent WorldManager { get; set; }

	[Property, Group( "Terrain" ), Title( "Chunk Streamer" )]
    public ChunkStreamerComponent ChunkStreamer { get; set; }

	public ChunkCoord Coord;

	public int CurrentResolution { get; private set; }

	public bool IsBuilding { get; private set; }

	[Property, Group( "Terrain" ), Title( "Enable Collision" )]
	public bool EnableCollision { get; set; } = true;

	[Property, Group( "Terrain" ), Title( "Collision Resolution" ), Description( "Collision mesh detail. Independent of visual LOD so distant chunks stay walkable." ), Range( 4, 128 )]
	public int CollisionResolution { get; set; } = 48;

	static Material _terrainMaterial;

	public void SetBuilding( bool building ) => IsBuilding = building;

	public void Build( int resolution )
	{
		if ( !ChunkStreamer.IsValid() || !WorldManager.IsValid() )
			return;

		CurrentResolution = Math.Max( resolution, 4 );
		GenerateTerrain( CurrentResolution );
	}

	public void Build()
	{
		if ( !ChunkStreamer.IsValid() )
			return;

		Build( ChunkStreamer.Resolution );
	}

    private void GenerateTerrain( int resolution )
    {
		try
		{
			var snapshot = TerrainBuildSnapshot.FromWorldManager(
				WorldManager,
				GameObject.WorldPosition,
				ChunkStreamer.EffectiveChunkSize );
			var meshData = TerrainChunkMeshBuilder.Build(
				snapshot,
				resolution,
				EnableCollision,
				CollisionResolution );
			ApplyMeshData( meshData );
		}
		catch ( Exception exception )
		{
			Log.Error( $"Terrain build failed for {GameObject.Name}: {exception.Message}" );
		}
    }

	public void ApplyMeshData( TerrainChunkMeshData meshData )
	{
		var position = GameObject.WorldPosition;
		GameObject.WorldPosition = new Vector3( position.x, position.y, meshData.HeightOrigin );

		var mesh = new Mesh();
		mesh.CreateVertexBuffer( meshData.Vertices.Length, meshData.Vertices );
		mesh.CreateIndexBuffer( meshData.Indices.Length, meshData.Indices );
		mesh.Material = GetTerrainMaterial();
		mesh.Bounds = meshData.Bounds;

		var modelBuilder = new ModelBuilder().AddMesh( mesh );
		var model = TryCreateModel( modelBuilder, mesh );

		var renderer = GameObject.GetOrAddComponent<ModelRenderer>();
		renderer.Model = model;
		renderer.MaterialOverride = GetTerrainMaterial();

		if ( meshData.HasCollision )
			TryApplyTerrainCollision( meshData.CollisionVertices, meshData.CollisionIndices );
		else
			RemoveTerrainCollision();
	}

	bool TryAddCollisionMesh(
		ModelBuilder modelBuilder,
		Vector3[] collisionVertices,
		int[] collisionIndices )
	{
		try
		{
			if ( collisionVertices is null || collisionIndices is null )
				return false;

			modelBuilder.AddCollisionMesh( collisionVertices, collisionIndices );
			return true;
		}
		catch ( Exception exception )
		{
			Log.Warning( $"Terrain collision mesh skipped for {GameObject.Name}: {exception.Message}" );
			return false;
		}
	}

	static Model TryCreateModel( ModelBuilder modelBuilder, Mesh mesh )
	{
		try
		{
			return modelBuilder.Create();
		}
		catch ( Exception exception )
		{
			Log.Warning( $"Terrain model build failed, retrying without collision: {exception.Message}" );
			return new ModelBuilder().AddMesh( mesh ).Create();
		}
	}

	static Material GetTerrainMaterial()
	{
		_terrainMaterial ??= Material.Load( "materials/terrain/terrain_biome.vmat" );
		return _terrainMaterial;
	}

	void TryApplyTerrainCollision( Vector3[] collisionVertices, int[] collisionIndices )
	{
		try
		{
			if ( collisionVertices is null || collisionIndices is null || collisionIndices.Length < 3 )
			{
				RemoveTerrainCollision();
				return;
			}

			GameObject.Tags.Set( "world", true );
			GameObject.Tags.Set( "solid", true );

			// Build a collision-only model so render skirts can't invalidate physics cooking.
			var collisionMesh = new Mesh();
			var collisionVerts = new TerrainVertex[collisionVertices.Length];
			for ( var i = 0; i < collisionVertices.Length; i++ )
			{
				collisionVerts[i] = new TerrainVertex(
					collisionVertices[i],
					Vector3.Up,
					new Vector4( Vector3.Forward, 1f ),
					Vector2.Zero,
					new Color32( 255, 0, 0, 255 ),
					new Color32( 255, 255, 255, 255 ) );
			}

			collisionMesh.CreateVertexBuffer( collisionVerts.Length, collisionVerts );
			collisionMesh.CreateIndexBuffer( collisionIndices.Length, collisionIndices );
			collisionMesh.Material = GetTerrainMaterial();
			collisionMesh.Bounds = BBox.FromPoints( collisionVertices );

			var builder = new ModelBuilder().AddMesh( collisionMesh );
			builder.AddCollisionMesh( collisionVertices, collisionIndices );
			var collisionModel = builder.Create();

			var collider = GameObject.GetOrAddComponent<ModelCollider>();
			collider.Static = true;
			collider.IsTrigger = false;
			collider.Model = collisionModel;
		}
		catch ( Exception exception )
		{
			Log.Warning( $"Terrain collision failed for {GameObject.Name}: {exception.Message}" );
			RemoveTerrainCollision();
		}
	}

	void RemoveTerrainCollision()
	{
		var collider = GameObject.GetComponent<ModelCollider>();
		if ( !collider.IsValid() )
			return;

		collider.Destroy();
	}
}
