namespace Sandbox.Components;

/// <summary>
/// Interface for pawns that can be controlled by bots
/// </summary>
public interface IBotController
{
	/// <summary>
	/// Enable this component
	/// </summary>
	public bool Enabled { set; }

	/// <summary>
	/// Update bot control logic for this pawn
	/// </summary>
	/// <param name="bot">The bot controller driving this pawn</param>
	void OnControl( BotControllerComponent bot );
}

public class BotControllerComponent : Component
{
	[RequireComponent]
	public ClientComponent Client { get; private set; }

	protected override void OnFixedUpdate()
	{
		if ( IsProxy )
			return;

		var currentPawn = Client?.Pawn;
		if ( !currentPawn.IsValid() )
			return;

		var controller = currentPawn.GetComponentInChildren<IBotController>( true );

		if ( controller is null )
			return;

		controller.Enabled = true;
		controller.OnControl( this );
	}
}
