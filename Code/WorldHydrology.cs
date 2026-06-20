using Sandbox.Components.SingletonComponents;

namespace Sandbox;

[Flags]
public enum WaterCellFlags : byte
{
	None = 0,
	Ocean = 1
}

/// <summary>
/// Coarse ocean water grid for terrain tinting.
/// </summary>
public sealed class WorldHydrology
{
	const int MaxGridDimension = 512;

	readonly WaterCellFlags[,] _water;
	readonly int _gridWidth;
	readonly int _gridHeight;
	readonly float _cellSize;
	readonly Vector2 _worldMin;

	public int GridWidth => _gridWidth;
	public int GridHeight => _gridHeight;
	public float CellSize => _cellSize;
	public Vector2 WorldMin => _worldMin;
	public bool IsBuilt { get; private set; }

	WorldHydrology( WaterCellFlags[,] water, float cellSize, Vector2 worldMin )
	{
		_water = water;
		_gridWidth = water.GetLength( 0 );
		_gridHeight = water.GetLength( 1 );
		_cellSize = cellSize;
		_worldMin = worldMin;
		IsBuilt = true;
	}

	public static float GetEffectiveCellSize( WorldManagerSingletonComponent world )
	{
		var cellSize = Math.Max( world.HydrologyCellSize, 32f );
		var minCellX = world.WorldSize.x / MaxGridDimension;
		var minCellY = world.WorldSize.y / MaxGridDimension;
		return Math.Max( cellSize, Math.Max( minCellX, minCellY ) );
	}

	public static WorldHydrology Build( WorldManagerSingletonComponent world )
	{
		if ( !world.IsValid() || world.Noise is null || !world.EnableHydrology || !world.UseWorldBounds )
			return null;

		try
		{
			return BuildInternal( world );
		}
		catch ( Exception exception )
		{
			Log.Warning( $"Hydrology build failed: {exception.Message}" );
			return null;
		}
	}

	static WorldHydrology BuildInternal( WorldManagerSingletonComponent world )
	{
		var cellSize = GetEffectiveCellSize( world );
		var worldMin = world.WorldMin;
		var worldSize = world.WorldSize;
		var gridWidth = Math.Max( (int)MathF.Ceiling( worldSize.x / cellSize ) + 1, 2 );
		var gridHeight = Math.Max( (int)MathF.Ceiling( worldSize.y / cellSize ) + 1, 2 );

		if ( cellSize > world.HydrologyCellSize + 0.01f )
		{
			Log.Info( $"Hydrology cell size raised to {cellSize:0} for {worldSize.x:0}x{worldSize.y:0} world ({gridWidth}x{gridHeight} grid)." );
		}

		var water = new WaterCellFlags[gridWidth, gridHeight];
		var oceanCells = 0;

		for ( var gy = 0; gy < gridHeight; gy++ )
		{
			for ( var gx = 0; gx < gridWidth; gx++ )
			{
				var worldX = worldMin.x + gx * cellSize;
				var worldY = worldMin.y + gy * cellSize;
				var rawHeight = world.GetRawNoiseHeight( worldX, worldY );
				var rawBiome = world.GetBiomeSampleFromHeight( rawHeight );

				if ( !IsOceanCandidate( world, worldX, worldY, rawHeight, rawBiome ) )
					continue;

				water[gx, gy] = WaterCellFlags.Ocean;
				oceanCells++;
			}
		}

		Log.Info( $"Hydrology built: {oceanCells} ocean cells ({gridWidth}x{gridHeight} @ {cellSize:0} cell size)." );

		return new WorldHydrology( water, cellSize, worldMin );
	}

	public bool IsWater( float worldX, float worldY )
	{
		if ( !TryGetCell( worldX, worldY, out var gx, out var gy ) )
			return false;

		return _water[gx, gy] != WaterCellFlags.None;
	}

	public WaterCellFlags GetWaterFlags( float worldX, float worldY )
	{
		if ( !TryGetCell( worldX, worldY, out var gx, out var gy ) )
			return WaterCellFlags.None;

		return _water[gx, gy];
	}

	public bool TryGetCell( float worldX, float worldY, out int gridX, out int gridY )
	{
		gridX = (int)MathF.Floor( (worldX - _worldMin.x) / _cellSize );
		gridY = (int)MathF.Floor( (worldY - _worldMin.y) / _cellSize );
		return gridX >= 0 && gridY >= 0 && gridX < _gridWidth && gridY < _gridHeight;
	}

	public bool IsWaterCell( int gridX, int gridY )
	{
		if ( gridX < 0 || gridY < 0 || gridX >= _gridWidth || gridY >= _gridHeight )
			return false;

		return _water[gridX, gridY] != WaterCellFlags.None;
	}

	public WaterCellFlags GetWaterCellFlags( int gridX, int gridY )
	{
		if ( gridX < 0 || gridY < 0 || gridX >= _gridWidth || gridY >= _gridHeight )
			return WaterCellFlags.None;

		return _water[gridX, gridY];
	}

	static bool IsOceanCandidate(
		WorldManagerSingletonComponent world,
		float worldX,
		float worldY,
		float rawHeight,
		float rawBiome )
	{
		if ( !world.TryGetWorldUv( worldX, worldY, out var worldU, out var worldV ) )
			return true;

		if ( world.UseFalloff && world.GetLandFalloff( worldU, worldV ) <= world.OceanFalloffThreshold )
			return true;

		return rawBiome <= world.WaterMaxThreshold + 0.02f
			|| rawHeight <= world.WaterLevel + world.OceanHeightPadding;
	}
}
