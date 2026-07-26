using Sandbox.Components;
using Sandbox.Components.PawnComponents;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Controllers;

/// <summary>
/// Safety net only: if a hitch tunnels the CharacterController below the heightfield,
/// snap back up. Does not drive normal walking — that uses ModelCollider + CharacterController.
/// </summary>
[Title( "Terrain Grounding" ), Category( "Gameplay" )]
public sealed class TerrainGroundingController : Component
{
	[Property, Group( "References" )]
	public WorldManagerSingletonComponent WorldManager { get; set; }

	[Property, Group( "Clamp" ), Description( "Extra height above the sampled surface when recovering." )]
	public float SkinWidth { get; set; } = 2f;

	[Property, Group( "Clamp" ), Description( "Only recover if this far below the heightfield (avoids fighting normal movement)." )]
	public float MaxRecoverDistance { get; set; } = 512f;

	protected override void OnFixedUpdate()
	{
		if ( !WorldManager.IsValid() )
			WorldManager = Scene.GetAllComponents<WorldManagerSingletonComponent>().FirstOrDefault();

		if ( !WorldManager.IsValid() )
			return;

		foreach ( var pawn in Scene.GetAllComponents<PlayerPawnComponent>() )
		{
			if ( !pawn.IsValid() || pawn.IsProxy )
				continue;

			if ( pawn.HealthComponent.IsValid() && pawn.HealthComponent.State != LifeState.Alive )
				continue;

			RecoverIfTunneled( pawn );
		}
	}

	void RecoverIfTunneled( PlayerPawnComponent pawn )
	{
		var cc = pawn.CharacterController;
		if ( !cc.IsValid() )
			return;

		var position = pawn.WorldPosition;
		if ( !WorldManager.TryGetWorldUv( position.x, position.y, out _, out _ ) )
			return;

		var groundZ = WorldManager.GetHeight( position.x, position.y ) + SkinWidth;
		var below = groundZ - position.z;
		if ( below <= 0f || below > MaxRecoverDistance )
			return;

		pawn.WorldPosition = position.WithZ( groundZ );
		cc.Velocity = cc.Velocity.WithZ( MathF.Max( cc.Velocity.z, 0f ) );
		cc.IsOnGround = true;
	}
}
