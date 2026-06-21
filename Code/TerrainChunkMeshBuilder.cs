namespace Sandbox;

public sealed class TerrainChunkMeshData
{
	public Vertex[] Vertices { get; init; }
	public int[] Indices { get; init; }
	public Vector3[] CollisionVertices { get; init; }
	public int[] CollisionIndices { get; init; }
	public bool HasCollision { get; init; }
	public BBox Bounds { get; init; }
}

public static class TerrainChunkMeshBuilder
{
	const int MaxCollisionTriangles = 12_000;

	public static TerrainChunkMeshData Build(
		TerrainBuildSnapshot snapshot,
		int resolution,
		bool enableCollision,
		int collisionResolution )
	{
		resolution = Math.Max( resolution, 4 );
		var width = resolution + 1;
		var step = snapshot.ChunkSize / (float)resolution;
		var bottomHeight = snapshot.TerrainBottomHeight;
		var chunkOrigin = snapshot.ChunkOrigin;
		var heights = new float[width, width];
		var colors = new Color32[width, width];

		for ( var y = 0; y < width; y++ )
		{
			for ( var x = 0; x < width; x++ )
			{
				var worldX = chunkOrigin.x + x * step;
				var worldY = chunkOrigin.y + y * step;
				heights[x, y] = snapshot.SampleHeight( worldX, worldY );
			}
		}

		for ( var y = 0; y < width; y++ )
		{
			for ( var x = 0; x < width; x++ )
			{
				var slope = SampleSlope( heights, x, y, resolution, step );
				colors[x, y] = snapshot.SampleColor( heights[x, y], slope );
			}
		}

		var bottomColor = snapshot.SampleSideColor();
		var vertices = new List<Vertex>( width * width * 2 );
		var indices = new List<int>();

		for ( var y = 0; y <= resolution; y++ )
		{
			for ( var x = 0; x <= resolution; x++ )
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

		var topVertexCount = vertices.Count;

		for ( var y = 0; y <= resolution; y++ )
		{
			for ( var x = 0; x <= resolution; x++ )
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

		AddTopSurfaceIndices( indices, resolution, width );
		AddBottomSurfaceIndices( indices, resolution, width, topVertexCount );
		AddSideWallIndices( indices, resolution, width, topVertexCount );

		Vector3[] collisionVertices = null;
		int[] collisionIndices = null;
		var hasCollision = enableCollision && TryBuildCollisionMesh(
			snapshot,
			resolution,
			collisionResolution,
			out collisionVertices,
			out collisionIndices );

		return new TerrainChunkMeshData
		{
			Vertices = vertices.ToArray(),
			Indices = indices.ToArray(),
			CollisionVertices = collisionVertices,
			CollisionIndices = collisionIndices,
			HasCollision = hasCollision,
			Bounds = CalculateMeshBounds( vertices )
		};
	}

	static void AddTopSurfaceIndices( List<int> indices, int resolution, int width )
	{
		for ( var y = 0; y < resolution; y++ )
		{
			for ( var x = 0; x < resolution; x++ )
			{
				var i = y * width + x;

				indices.Add( i );
				indices.Add( i + 1 );
				indices.Add( i + width );

				indices.Add( i + 1 );
				indices.Add( i + width + 1 );
				indices.Add( i + width );
			}
		}
	}

	static void AddBottomSurfaceIndices( List<int> indices, int resolution, int width, int topVertexCount )
	{
		for ( var y = 0; y < resolution; y++ )
		{
			for ( var x = 0; x < resolution; x++ )
			{
				var i = topVertexCount + y * width + x;

				indices.Add( i );
				indices.Add( i + width );
				indices.Add( i + 1 );

				indices.Add( i + 1 );
				indices.Add( i + width );
				indices.Add( i + width + 1 );
			}
		}
	}

	static void AddSideWallIndices( List<int> indices, int resolution, int width, int topVertexCount )
	{
		for ( var y = 0; y < resolution; y++ )
		{
			var top0 = y * width;
			var top1 = (y + 1) * width;
			var bot0 = topVertexCount + top0;
			var bot1 = topVertexCount + top1;

			indices.Add( top0 );
			indices.Add( top1 );
			indices.Add( bot1 );
			indices.Add( top0 );
			indices.Add( bot1 );
			indices.Add( bot0 );
		}

		for ( var y = 0; y < resolution; y++ )
		{
			var top0 = y * width + resolution;
			var top1 = (y + 1) * width + resolution;
			var bot0 = topVertexCount + top0;
			var bot1 = topVertexCount + top1;

			indices.Add( top0 );
			indices.Add( bot0 );
			indices.Add( bot1 );
			indices.Add( top0 );
			indices.Add( bot1 );
			indices.Add( top1 );
		}

		for ( var x = 0; x < resolution; x++ )
		{
			var top0 = x;
			var top1 = x + 1;
			var bot0 = topVertexCount + x;
			var bot1 = topVertexCount + x + 1;

			indices.Add( top0 );
			indices.Add( bot0 );
			indices.Add( bot1 );
			indices.Add( top0 );
			indices.Add( bot1 );
			indices.Add( top1 );
		}

		for ( var x = 0; x < resolution; x++ )
		{
			var top0 = resolution * width + x;
			var top1 = resolution * width + x + 1;
			var bot0 = topVertexCount + top0;
			var bot1 = topVertexCount + top1;

			indices.Add( top0 );
			indices.Add( top1 );
			indices.Add( bot1 );
			indices.Add( top0 );
			indices.Add( bot1 );
			indices.Add( bot0 );
		}
	}

	static bool TryBuildCollisionMesh(
		TerrainBuildSnapshot snapshot,
		int visualResolution,
		int collisionResolution,
		out Vector3[] collisionVertices,
		out int[] collisionIndices )
	{
		collisionVertices = null;
		collisionIndices = null;

		var target = GetCollisionResolution( visualResolution, collisionResolution );
		if ( target <= 0 )
			return false;

		var collisionStep = snapshot.ChunkSize / (float)target;
		var width = target + 1;
		var chunkOrigin = snapshot.ChunkOrigin;
		var vertexList = new List<Vector3>( width * width );
		var indexList = new List<int>();

		for ( var y = 0; y <= target; y++ )
		{
			for ( var x = 0; x <= target; x++ )
			{
				var localX = x * collisionStep;
				var localY = y * collisionStep;
				var worldX = chunkOrigin.x + localX;
				var worldY = chunkOrigin.y + localY;
				var height = snapshot.SampleHeight( worldX, worldY );
				vertexList.Add( new Vector3( localX, localY, height ) );
			}
		}

		for ( var y = 0; y < target; y++ )
		{
			for ( var x = 0; x < target; x++ )
			{
				var i = y * width + x;

				indexList.Add( i );
				indexList.Add( i + 1 );
				indexList.Add( i + width );

				indexList.Add( i + 1 );
				indexList.Add( i + width + 1 );
				indexList.Add( i + width );
			}
		}

		if ( vertexList.Count == 0 || indexList.Count == 0 )
			return false;

		collisionVertices = vertexList.ToArray();
		collisionIndices = indexList.ToArray();
		return true;
	}

	static int GetCollisionResolution( int visualResolution, int collisionResolution )
	{
		var target = Math.Clamp( collisionResolution, 4, visualResolution );
		while ( target > 4 && target * target * 2 > MaxCollisionTriangles )
			target >>= 1;

		return target;
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
