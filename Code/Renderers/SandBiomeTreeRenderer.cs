using Sandbox.Components;
using Sandbox.Components.PawnComponents;

namespace Sandbox.Renderers;

/// <summary>
/// Presentation for one procedurally placed sand-biome tree.
/// Placement and physical state are owned by SandBiomeTreeController.
/// </summary>
[Title( "Sand Biome Tree Renderer" ), Category( "World" ), Icon( "park" )]
public sealed class SandBiomeTreeRenderer : Component,
	Component.ExecuteInEditor,
	Component.DontExecuteOnServer
{
	[Property, Group( "Rendering" ), Change( nameof( ApplyModel ) )]
	public Model Model { get; set; }

	[Property, Group( "Rendering" ), Change( nameof( ApplyModel ) )]
	public Model BillboardModel { get; set; }

	[Property, Group( "Rendering" ), Range( 1000f, 100000f )]
	public float BillboardDistance { get; set; } = 14000f;

	[Property, Group( "Rendering" ), Range( 0f, 5000f )]
	public float LodHysteresis { get; set; } = 800f;

	[Property, Group( "Debug" ), Description( "Always show the billboard LOD, even up close." )]
	public bool ForceBillboard { get; set; }

	GameObject _billboardObject;
	SkinnedModelRenderer _renderer;
	ModelRenderer _billboardRenderer;
	bool _usingBillboard;
	bool _lodInitialized;

	bool IsEditMode => Game.IsEditor && !Game.IsPlaying;

	protected override void OnEnabled() => ApplyModel();

	protected override void OnValidate() => ApplyModel();

	protected override void OnUpdate()
	{
		if ( !_renderer.IsValid() || !Model.IsValid() )
			return;

		var camera = ResolveCamera();
		var distance = camera.IsValid()
			? (camera.WorldPosition - WorldPosition).Length
			: 0f;

		UpdateLod( camera, distance );
	}

	public void Configure( Model model, Model billboardModel, float billboardDistance, bool forceBillboard = false )
	{
		Model = model;
		BillboardModel = billboardModel;
		BillboardDistance = Math.Max( billboardDistance, 1000f );
		ForceBillboard = forceBillboard;
		ApplyModel();
	}

	void ApplyModel()
	{
		if ( !GameObject.IsValid() )
			return;

		_renderer = GameObject.GetOrAddComponent<SkinnedModelRenderer>();
		_renderer.Model = Model;
		_renderer.UseAnimGraph = false;
		// Do not call SetBoneTransform — incorrect bone space collapses the skeleton onto the ground.

		EnsureBillboardObject();
		if ( _billboardRenderer.IsValid() )
			_billboardRenderer.Model = BillboardModel;

		_lodInitialized = false;
	}

	void EnsureBillboardObject()
	{
		if ( _billboardObject.IsValid() && _billboardRenderer.IsValid() )
			return;

		_billboardObject = Scene.CreateObject();
		_billboardObject.Name = "Tree Billboard Visual";
		_billboardObject.Flags |= GameObjectFlags.NotSaved | GameObjectFlags.NotNetworked;
		_billboardObject.Parent = GameObject;
		_billboardObject.LocalPosition = Vector3.Zero;
		_billboardObject.LocalRotation = Rotation.Identity;
		_billboardObject.LocalScale = Vector3.One;
		_billboardRenderer = _billboardObject.Components.Create<ModelRenderer>();
		_billboardRenderer.Enabled = false;
	}

	void UpdateLod( CameraComponent camera, float distance )
	{
		var canUseBillboard = BillboardModel.IsValid() && _billboardRenderer.IsValid();
		var enterDistance = BillboardDistance + LodHysteresis * 0.5f;
		var exitDistance = Math.Max( BillboardDistance - LodHysteresis * 0.5f, 0f );
		var shouldUseBillboard = canUseBillboard && (ForceBillboard
			|| (_usingBillboard ? distance >= exitDistance : distance >= enterDistance));

		if ( !_lodInitialized || shouldUseBillboard != _usingBillboard )
		{
			_usingBillboard = shouldUseBillboard;
			_renderer.Enabled = !_usingBillboard;
			if ( _billboardRenderer.IsValid() )
				_billboardRenderer.Enabled = _usingBillboard;
			_lodInitialized = true;
		}

		if ( _usingBillboard && camera.IsValid() )
			FaceBillboardToward( camera.WorldPosition );
	}

	void FaceBillboardToward( Vector3 cameraPosition )
	{
		if ( !_billboardObject.IsValid() )
			return;

		var toCamera = (cameraPosition - _billboardObject.WorldPosition).WithZ( 0f );
		if ( toCamera.LengthSquared <= 0.0001f )
			return;

		// Imported billboard is a vertical YZ card whose face points along local +X.
		// LookAt aims +X at the camera, so no extra yaw offset.
		_billboardObject.WorldRotation = Rotation.LookAt( toCamera.Normal, Vector3.Up );
	}

	CameraComponent ResolveCamera()
	{
		if ( IsEditMode && Application.Editor.Camera.IsValid() )
			return Application.Editor.Camera;

		// Prefer the camera the local viewer is looking through — Scene.Camera can
		// stay on the spectator/default camera while the pawn camera is active.
		if ( Game.IsPlaying )
		{
			var pawn = ClientComponent.Viewer.IsValid()
				? ClientComponent.Viewer.PlayerPawn
				: null;
			if ( pawn.IsValid() && pawn.Camera.IsValid() )
				return pawn.Camera;
		}

		if ( Scene?.Camera.IsValid() == true )
			return Scene.Camera;

		if ( Application.IsEditor && Application.Editor.Camera.IsValid() )
			return Application.Editor.Camera;

		return null;
	}
}
