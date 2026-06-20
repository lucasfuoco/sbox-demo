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

	[Property, Group( "Terrain" ), Title( "Enable Collision" )]
	public bool EnableCollision { get; set; } = true;

	[Property, Group( "Terrain" ), Title( "Collision Resolution" ), Description( "Collision mesh detail. Lower is faster and more stable on large chunks." ), Range( 4, 128 )]
	public int CollisionResolution { get; set; } = 32;

	const int MaxCollisionTriangles = 12_000;

	static Material _terrainMaterial;

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
			GenerateTerrainInternal( resolution );
		}
		catch ( Exception exception )
		{
			Log.Error( $"Terrain build failed for {GameObject.Name}: {exception.Message}" );
		}
    }

	void GenerateTerrainInternal( int resolution )
    {
        var vertices = new List<Vertex>();
		var indices = new List<int>();

		int width = resolution + 1;
		float step = ChunkStreamer.EffectiveChunkSize / (float)resolution;
		float bottomHeight = WorldManager.TerrainBottomHeight;
		var chunkOrigin = GameObject.WorldPosition;
		var heights = new float[width, width];
		var colors = new Color32[width, width];

		for ( int y = 0; y <= resolution; y++ )
		{
			for ( int x = 0; x <= resolution; x++ )
			{
				float worldX = chunkOrigin.x + x * step;
				float worldY = chunkOrigin.y + y * step;
				heights[x, y] = GetHeight( worldX, worldY );
			}
		}

		for ( int y = 0; y <= resolution; y++ )
		{
			for ( int x = 0; x <= resolution; x++ )
			{
				float worldX = chunkOrigin.x + x * step;
				float worldY = chunkOrigin.y + y * step;
				var slope = SampleSlope( heights, x, y, resolution, step );
				var isWater = WorldManager.IsWaterAt( worldX, worldY );
				colors[x, y] = TerrainBiome.GetColorFromHeight( WorldManager, heights[x, y], slope, isWater ).ToColor32();
			}
		}

		var bottomColor = TerrainBiome.GetSideColor( WorldManager.MountainColor.ToColor32() );

		for ( int y = 0; y <= resolution; y++ )
		{
			for ( int x = 0; x <= resolution; x++ )
			{
				var normal = SampleNormal( heights, x, y, resolution, step );
				vertices.Add( MakeVertex(
					x * step,
					y * step,
					heights[x, y],
					normal,
					colors[x, y],
					x,
					y,
					resolution ) );
			}
		}

		int topVertexCount = vertices.Count;

		for ( int y = 0; y <= resolution; y++ )
		{
			for ( int x = 0; x <= resolution; x++ )
			{
				vertices.Add( MakeVertex(
					x * step,
					y * step,
					bottomHeight,
					Vector3.Down,
					bottomColor,
					x,
					y,
					resolution ) );
			}
		}

		for ( int y = 0; y < resolution; y++ )
		{
			for ( int x = 0; x < resolution; x++ )
			{
				int i = y * width + x;

				indices.Add( i );
				indices.Add( i + 1 );
				indices.Add( i + width );

				indices.Add( i + 1 );
				indices.Add( i + width + 1 );
				indices.Add( i + width );
			}
		}

		for ( int y = 0; y < resolution; y++ )
		{
			for ( int x = 0; x < resolution; x++ )
			{
				int i = topVertexCount + y * width + x;

				indices.Add( i );
				indices.Add( i + width );
				indices.Add( i + 1 );

				indices.Add( i + 1 );
				indices.Add( i + width );
				indices.Add( i + width + 1 );
			}
		}

		for ( int y = 0; y < resolution; y++ )
		{
			int top0 = y * width;
			int top1 = (y + 1) * width;
			int bot0 = topVertexCount + top0;
			int bot1 = topVertexCount + top1;

			indices.Add( top0 );
			indices.Add( top1 );
			indices.Add( bot1 );
			indices.Add( top0 );
			indices.Add( bot1 );
			indices.Add( bot0 );
		}

		for ( int y = 0; y < resolution; y++ )
		{
			int top0 = y * width + resolution;
			int top1 = (y + 1) * width + resolution;
			int bot0 = topVertexCount + top0;
			int bot1 = topVertexCount + top1;

			indices.Add( top0 );
			indices.Add( bot0 );
			indices.Add( bot1 );
			indices.Add( top0 );
			indices.Add( bot1 );
			indices.Add( top1 );
		}

		for ( int x = 0; x < resolution; x++ )
		{
			int top0 = x;
			int top1 = x + 1;
			int bot0 = topVertexCount + x;
			int bot1 = topVertexCount + x + 1;

			indices.Add( top0 );
			indices.Add( bot0 );
			indices.Add( bot1 );
			indices.Add( top0 );
			indices.Add( bot1 );
			indices.Add( top1 );
		}

		for ( int x = 0; x < resolution; x++ )
		{
			int top0 = resolution * width + x;
			int top1 = resolution * width + x + 1;
			int bot0 = topVertexCount + top0;
			int bot1 = topVertexCount + top1;

			indices.Add( top0 );
			indices.Add( top1 );
			indices.Add( bot1 );
			indices.Add( top0 );
			indices.Add( bot1 );
			indices.Add( bot0 );
		}

		var mesh = new Mesh();
		mesh.CreateVertexBuffer<Vertex>( vertices.Count, Vertex.Layout, vertices.ToArray() );
		mesh.CreateIndexBuffer( indices.Count, indices.ToArray() );
		mesh.Material = GetTerrainMaterial();
		mesh.Bounds = CalculateMeshBounds( vertices );

		var modelBuilder = new ModelBuilder().AddMesh( mesh );
		var collisionEnabled = EnableCollision && TryAddCollisionMesh(
			modelBuilder,
			chunkOrigin,
			resolution );

		var model = TryCreateModel( modelBuilder, mesh );

		var renderer = GameObject.GetOrAddComponent<ModelRenderer>();
		renderer.Model = model;
		renderer.MaterialOverride = GetTerrainMaterial();

		if ( collisionEnabled )
			TryApplyTerrainCollision( model );
		else
			RemoveTerrainCollision();
	}

	bool TryAddCollisionMesh(
		ModelBuilder modelBuilder,
		Vector3 chunkOrigin,
		int resolution )
	{
		try
		{
			var collisionResolution = GetCollisionResolution( resolution );
			if ( !TryBuildCollisionMesh(
				chunkOrigin,
				collisionResolution,
				out var collisionVertices,
				out var collisionIndices ) )
			{
				return false;
			}

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

	int GetCollisionResolution( int visualResolution )
	{
		var target = Math.Clamp( CollisionResolution, 4, visualResolution );
		var triangleBudget = MaxCollisionTriangles;
		while ( target > 4 && target * target * 2 > triangleBudget )
			target >>= 1;

		return target;
	}

	bool TryBuildCollisionMesh(
		Vector3 chunkOrigin,
		int collisionResolution,
		out List<Vector3> collisionVertices,
		out List<int> collisionIndices )
	{
		collisionVertices = new List<Vector3>();
		collisionIndices = new List<int>();

		if ( collisionResolution <= 0 )
			return false;

		var collisionStep = ChunkStreamer.EffectiveChunkSize / (float)collisionResolution;
		var width = collisionResolution + 1;

		for ( var y = 0; y <= collisionResolution; y++ )
		{
			for ( var x = 0; x <= collisionResolution; x++ )
			{
				var localX = x * collisionStep;
				var localY = y * collisionStep;
				var worldX = chunkOrigin.x + localX;
				var worldY = chunkOrigin.y + localY;
				var height = GetHeight( worldX, worldY );
				collisionVertices.Add( new Vector3( localX, localY, height ) );
			}
		}

		for ( var y = 0; y < collisionResolution; y++ )
		{
			for ( var x = 0; x < collisionResolution; x++ )
			{
				var i = y * width + x;

				collisionIndices.Add( i );
				collisionIndices.Add( i + 1 );
				collisionIndices.Add( i + width );

				collisionIndices.Add( i + 1 );
				collisionIndices.Add( i + width + 1 );
				collisionIndices.Add( i + width );
			}
		}

		return collisionVertices.Count > 0 && collisionIndices.Count > 0;
	}

	void TryApplyTerrainCollision( Model model )
	{
		try
		{
			GameObject.Tags.Set( "world", true );

			var collider = GameObject.GetOrAddComponent<ModelCollider>();
			collider.Static = true;
			collider.Model = model;
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

	static BBox CalculateMeshBounds( List<Vertex> vertices )
	{
		if ( vertices.Count == 0 )
			return new BBox( Vector3.Zero, Vector3.Zero );

		var min = vertices[0].Position;
		var max = vertices[0].Position;

		for ( var i = 1; i < vertices.Count; i++ )
		{
			var position = vertices[i].Position;
			min = min.ComponentMin( position );
			max = max.ComponentMax( position );
		}

		return new BBox( min, max );
	}

	static Material GetTerrainMaterial()
	{
		_terrainMaterial ??= Material.Load( "materials/terrain/terrain_biome.vmat" );
		return _terrainMaterial;
	}

	private float GetHeight( float x, float y ) => WorldManager.GetHeight( x, y );

	static Vertex MakeVertex(
		float x,
		float y,
		float z,
		Vector3 normal,
		Color32 color,
		int gridX,
		int gridY,
		int resolution )
	{
		var tangent = Vector3.Cross( Vector3.Up, normal ).Normal;
		if ( tangent.LengthSquared < 0.001f )
			tangent = Vector3.Cross( Vector3.Forward, normal ).Normal;

		return new Vertex(
			new Vector3( x, y, z ),
			normal,
			tangent,
			new Vector2( gridX / (float)resolution, gridY / (float)resolution ) )
		{
			Color = color
		};
	}

	static Vector3 SampleNormal( float[,] heights, int x, int y, int resolution, float step )
	{
		var left = heights[Math.Max( x - 1, 0 ), y];
		var right = heights[Math.Min( x + 1, resolution ), y];
		var down = heights[x, Math.Max( y - 1, 0 )];
		var up = heights[x, Math.Min( y + 1, resolution )];

		return new Vector3( left - right, down - up, 2f * step ).Normal;
	}

	static float SampleSlope( float[,] heights, int x, int y, int resolution, float step )
	{
		var left = heights[Math.Max( x - 1, 0 ), y];
		var right = heights[Math.Min( x + 1, resolution ), y];
		var down = heights[x, Math.Max( y - 1, 0 )];
		var up = heights[x, Math.Min( y + 1, resolution )];

		var dx = (right - left) / (2f * step);
		var dy = (up - down) / (2f * step);
		return MathF.Sqrt( dx * dx + dy * dy );
	}
}
