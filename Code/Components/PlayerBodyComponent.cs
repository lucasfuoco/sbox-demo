using Sandbox.Components.PawnComponents;
using Sandbox.Components.PawnCameraControllerComponents;

namespace Sandbox.Components;

public partial class PlayerBodyComponent : Component
{
	[Property] public SkinnedModelRenderer Renderer { get; set; }
	[Property] public ModelPhysics Physics { get; set; }
	[Property] public PlayerPawnComponent Player { get; set; }
	[Property] public GameObject FirstPersonBody { get; set; }
	[Property] public List<AnimationHelperComponent> AnimationHelpers { get; set; } = new();

	public Vector3 DamageTakenPosition { get; set; }
	public Vector3 DamageTakenForce { get; set; }

	private bool IsFirstPerson;
	public bool IsRagdoll => Physics.Enabled;

	internal void SetRagdoll( bool ragdoll )
	{
		if ( Physics.IsValid() )
			Physics.Enabled = ragdoll;

		if ( Renderer.IsValid() )
			Renderer.UseAnimGraph = !ragdoll;

		GameObject.Tags.Set( "ragdoll", ragdoll );

		if ( !ragdoll )
		{
			GameObject.LocalPosition = Vector3.Zero;
			GameObject.LocalRotation = Rotation.Identity;
		}

		SetFirstPersonView( !ragdoll );

		if ( ragdoll && DamageTakenForce.LengthSquared > 0f )
			ApplyRagdollImpulses( DamageTakenPosition, DamageTakenForce );

		Transform.ClearInterpolation();
	}

	internal void ApplyRagdollImpulses( Vector3 position, Vector3 force )
	{
		if ( !Physics.IsValid() || !Physics.PhysicsGroup.IsValid() )
			return;

		foreach ( var body in Physics.PhysicsGroup.Bodies )
		{
			body.ApplyImpulseAt( position, force );
		}
	}

	public void Refresh()
	{
		SetFirstPersonView( IsFirstPerson );
	}

	public void SetFirstPersonView( bool firstPerson )
	{
		IsFirstPerson = firstPerson;

		if ( Player is { } pl && pl.CurrentEquipment.IsValid() )
		{
			pl.CurrentEquipment.UpdateRenderMode();
		}

		if ( FirstPersonBody.IsValid() )
			FirstPersonBody.Enabled = IsFirstPerson;
	}

	protected override void OnUpdate()
	{
		if ( !Player.IsValid() )
			return;

		if ( !Player.CameraController.IsValid() )
			return;

		var isWatchingThisPlayer = ClientComponent.Viewer.IsValid() && ClientComponent.Viewer.Pawn == Player;
		Tags.Set( "viewer", isWatchingThisPlayer && Player.CameraController.Mode == CameraMode.FirstPerson );
	}

	internal void UpdateRotation( Rotation rotation )
	{
		WorldRotation = rotation;

		if ( FirstPersonBody.IsValid() )
			FirstPersonBody.WorldRotation = rotation;
	}
}
