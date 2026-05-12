using Sandbox.Components.PawnCameraControllerComponents;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components.PawnComponents;

public partial class PlayerPawnComponent
{
	/// <summary>
	/// Is this player the currently possessed controller
	/// </summary>
	public bool IsViewer => IsPossessed;

	/// <summary>
	/// What are we called?
	/// </summary>
	public override string DisplayName => Client.IsValid() ? Client.DisplayName : "Invalid Player";

	/// <summary>
	/// Is the player controlled by us?
	/// </summary>
	public override bool IsLocallyControlled => base.IsLocallyControlled && !Client.IsBot;

	/// <summary>
	/// Called when possessed.
	/// </summary>
	public override void OnPossess()
	{
		CameraController.SetActive( true );

		// if we're spectating a remote player, use the camera mode preference
		// otherwise: first person for now
		var spectateSystemSingletonComponent = SpectateSystemSingletonComponent.Instance;
		if ( spectateSystemSingletonComponent.IsValid() && ( IsProxy || ( Client.IsValid() && Client.IsBot ) ) )
		{
			CameraController.Mode = spectateSystemSingletonComponent.CameraMode;
		}
		else
		{
			CameraController.Mode = CameraMode.FirstPerson;
		}
	}

	public override void OnDePossess()
	{
		CameraController.SetActive( false );
	}
}
