using Sandbox.Diagnostics;

namespace Sandbox.Components;

/// <summary>
/// A component that is placed on any created Pawn that we want to unpossess and depossess, like a drone.
/// </summary>
public partial class DeployedPawnHandlerComponent : Component
{
	[RequireComponent] 
	ClientComponent Client { get; set; }

	[Sync] 
	public PawnComponent Pawn { get; set; }

	public void PossessPlayerPawn()
	{
		Client?.PlayerPawn?.Possess();
	}

	public void PossessDeployedPawn()
	{
		Pawn?.Possess();
	}

	public static DeployedPawnHandlerComponent Create( PawnComponent pawn, ClientComponent client )
	{
		Assert.True( Networking.IsHost );
		Assert.True( client.IsValid() );

		var handler = client.GetOrAddComponent<DeployedPawnHandlerComponent>();
		handler.Pawn = pawn;

		return handler;
	}

	protected override void OnFixedUpdate()
	{
		if ( Client.IsLocalPlayer )
		{
			if ( !Pawn.IsValid() )
				return;

			if ( Input.Pressed( "Use" ) )
			{
				if ( Client.Pawn == Pawn )
				{
					PossessPlayerPawn();
				}
				else
				{
					PossessDeployedPawn();
				}
			}
		}
	}
}
