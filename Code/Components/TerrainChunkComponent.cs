using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

public sealed class TerrainChunkComponent : Component
{
    [Property, Group( "Terrain" ), Title( "World Manager" )]
    public WorldManagerSingletonComponent WorldManager { get; set; }

	[Property, Group( "Terrain" ), Title( "Chunk Streamer" )]
    public ChunkStreamerComponent ChunkStreamer { get; set; }

	public ChunkCoord Coord;

	static Material _terrainMaterial;

	public void Build()
	{
		if ( !ChunkStreamer.IsValid() || !WorldManager.IsValid() )
			return;

		GenerateTerrain();
	}

    private void GenerateTerrain()
    {
        var vertices = new List<Vertex>();
		var indices = new List<int>();

		int resolution = ChunkStreamer.Resolution;
		int width = resolution + 1;
		float step = ChunkStreamer.ChunkSize / (float)resolution;
		float bottomHeight = WorldManager.TerrainBottomHeight;
		float slopeStep = MathF.Max( step, 16f );
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
				colors[x, y] = TerrainBiome.GetColor( WorldManager, worldX, worldY, slopeStep ).ToColor32();
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

		var model = new ModelBuilder()
			.AddMesh( mesh )
			.Create();

		var renderer = GameObject.GetOrAddComponent<ModelRenderer>();
		renderer.Model = model;
		renderer.MaterialOverride = GetTerrainMaterial();
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
		float left = heights[Math.Max( x - 1, 0 ), y];
		float right = heights[Math.Min( x + 1, resolution ), y];
		float down = heights[x, Math.Max( y - 1, 0 )];
		float up = heights[x, Math.Min( y + 1, resolution )];

		return new Vector3( left - right, down - up, 2f * step ).Normal;
	}
}
