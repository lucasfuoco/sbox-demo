using Sandbox.Components;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Controllers;

/// <summary>
/// Builds two terrain-aware team spawn formations for procedural worlds.
/// </summary>
[Title( "Terrain Spawn Points" ), Category( "Gameplay" )]
public sealed class TerrainSpawnPointController : Component, Component.ExecuteInEditor
{
	const string SpawnRootName = "Generated Team Spawn Points";
	const float GoldenAngle = 2.39996323f;

	[Property, Group( "References" )]
	public WorldManagerSingletonComponent WorldManager { get; set; }

	[Property, Group( "Layout" )]
	public Vector2 Center { get; set; } = Vector2.Zero;

	[Property, Group( "Layout" ), Range( 2, 16 )]
	public int PointsPerTeam { get; set; } = 8;

	[Property, Group( "Layout" )]
	public float TeamSeparation { get; set; } = 24000f;

	[Property, Group( "Layout" )]
	public float FormationRadius { get; set; } = 3000f;

	[Property, Group( "Placement" )]
	public float SearchStep { get; set; } = 1200f;

	[Property, Group( "Placement" ), Range( 1, 24 )]
	public int MaxSearchRings { get; set; } = 12;

	[Property, Group( "Placement" )]
	public float MinimumHeightAboveWater { get; set; } = 96f;

	[Property, Group( "Placement" )]
	public float MaxSlope { get; set; } = 1.25f;

	GameObject _spawnRoot;

	protected override void OnStart()
	{
		RebuildSpawnPoints();
	}

	protected override void OnDisabled()
	{
		ClearSpawnPoints();
	}

	public void RebuildSpawnPoints()
	{
		ClearSpawnPoints();

		if ( !WorldManager.IsValid() )
			WorldManager = Scene.GetAllComponents<WorldManagerSingletonComponent>().FirstOrDefault();

		if ( !WorldManager.IsValid() )
			return;

		_spawnRoot = Scene.CreateObject();
		_spawnRoot.Name = SpawnRootName;
		_spawnRoot.Flags |= GameObjectFlags.NotSaved | GameObjectFlags.NotNetworked;
		_spawnRoot.Parent = GameObject;

		var halfSeparation = MathF.Max( TeamSeparation, 0f ) * 0.5f;
		var terroristCenter = Center + new Vector2( -halfSeparation, 0f );
		var counterTerroristCenter = Center + new Vector2( halfSeparation, 0f );

		CreateFormation( Team.Terrorist, terroristCenter, counterTerroristCenter );
		CreateFormation( Team.CounterTerrorist, counterTerroristCenter, terroristCenter );
	}

	void CreateFormation( Team team, Vector2 formationCenter, Vector2 facingCenter )
	{
		var count = Math.Clamp( PointsPerTeam, 2, 16 );

		for ( var index = 0; index < count; index++ )
		{
			var angle = MathF.PI * 2f * index / count;
			var target = formationCenter + new Vector2( MathF.Cos( angle ), MathF.Sin( angle ) )
				* MathF.Max( FormationRadius, 0f );

			if ( !TryFindPlacement( target, index, out var position ) )
			{
				Log.Warning( $"Unable to place {team} terrain spawn point {index + 1}." );
				continue;
			}

			var spawnObject = Scene.CreateObject();
			spawnObject.Name = $"{team} Spawn {index + 1}";
			spawnObject.Flags |= GameObjectFlags.NotSaved | GameObjectFlags.NotNetworked;
			spawnObject.Parent = _spawnRoot;
			spawnObject.WorldPosition = position;

			var facing = new Vector3(
				facingCenter.x - position.x,
				facingCenter.y - position.y,
				0f );
			spawnObject.WorldRotation = facing.LengthSquared > 0.001f
				? Rotation.LookAt( facing.Normal, Vector3.Up )
				: Rotation.Identity;

			spawnObject.Components.Create<TeamSpawnPointComponent>().Team = team;
		}
	}

	bool TryFindPlacement( Vector2 target, int pointIndex, out Vector3 position )
	{
		var sampleRadius = MathF.Max( SearchStep * 0.2f, 128f );
		var maxAttempts = Math.Max( MaxSearchRings, 1 ) * 8;

		for ( var attempt = 0; attempt <= maxAttempts; attempt++ )
		{
			var radius = attempt == 0
				? 0f
				: MathF.Ceiling( attempt / 8f ) * MathF.Max( SearchStep, 128f );
			var angle = (attempt + pointIndex * 3) * GoldenAngle;
			var x = target.x + MathF.Cos( angle ) * radius;
			var y = target.y + MathF.Sin( angle ) * radius;

			if ( !WorldManager.TryGetWorldUv( x, y, out _, out _ ) )
				continue;

			var height = WorldManager.GetHeight( x, y );
			if ( height < WorldManager.WaterLevel + MinimumHeightAboveWater )
				continue;

			var slopeX = MathF.Abs( WorldManager.GetHeight( x + sampleRadius, y ) - height ) / sampleRadius;
			var slopeY = MathF.Abs( WorldManager.GetHeight( x, y + sampleRadius ) - height ) / sampleRadius;
			if ( MathF.Max( slopeX, slopeY ) > MaxSlope )
				continue;

			// Keep feet clearly above the heightfield so spawn doesn't start solid / tunnel.
			position = new Vector3( x, y, height + 32f );
			return true;
		}

		position = default;
		return false;
	}

	void ClearSpawnPoints()
	{
		if ( _spawnRoot.IsValid() )
			_spawnRoot.Destroy();

		_spawnRoot = null;
	}
}
