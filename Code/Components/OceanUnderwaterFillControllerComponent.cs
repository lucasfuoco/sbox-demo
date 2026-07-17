using RedSnail.WaterTool;
using Sandbox.Components.SingletonComponents;
using Sandbox.Rendering;
using Sandbox.Volumes;
using RenderStage = Sandbox.Rendering.Stage;

namespace Sandbox.Components;

/// <summary>
/// Underwater swim look in play and in the editor viewport.
/// Requires PostProcessVolume.EditorPreview so effects show while editing.
/// </summary>
[Title( "Ocean Underwater Fill Controller" ), Category( "World Simulation" ), Icon( "water" )]
public sealed class OceanUnderwaterFillControllerComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Setup" ), Title( "Water Body" )]
	public WaterBody WaterBody { get; set; }

	[Property, Group( "Setup" ), Title( "World Manager" )]
	public WorldManagerSingletonComponent TerrainWorld { get; set; }

	[Property, Group( "Look" ), Title( "Shallow Color" )]
	public Color WaterColor { get; set; } = new Color( 0.28f, 0.72f, 0.88f );

	[Property, Group( "Look" ), Title( "Deep Color" )]
	public Color DeepWaterColor { get; set; } = new Color( 0.08f, 0.28f, 0.48f );

	[Property, Group( "Depth" ), Title( "Full Effect Depth" ), Range( 50f, 12000f )]
	public float FullEffectDepth { get; set; } = 4500f;

	[Property, Group( "Detection" ), Title( "Buried Tolerance" ), Range( 0f, 128f )]
	public float BuriedTolerance { get; set; } = 16f;

	[Property, Group( "Debug" ), Title( "Log Enter / Exit" )]
	public bool LogTransitions { get; set; } = true;

	[Property, Group( "Debug" ), Title( "Editor Screen Hint" )]
	public bool EditorScreenHint { get; set; } = true;

	PostProcessVolume _volume;
	UnderwaterCausticsEffect _caustics;
	SimpleFog _fog;
	WobbleEffect _wobble;
	ColorAdjustments _color;
	Vignette _vignette;
	Blur _blur;
	CommandList _commandList;
	CameraComponent _boundCamera;
	Material _underwaterMaterial;
	bool _wasUnderwater;
	bool _legacyOverlayRemoved;

	bool IsEditMode => Game.IsEditor && !Game.IsPlaying;

	protected override void OnStart()
	{
		EnsureEffects();
		SetEffectsActive( false, 0f, 0f );
	}

	protected override void OnDisabled()
	{
		UnbindCamera();
		SetEffectsActive( false, 0f, 0f );
	}

	protected override void OnDestroy()
	{
		UnbindCamera();
	}

	protected override void OnUpdate()
	{
		EnsureEffects();

		var viewPosition = GetViewPosition();
		var renderCamera = ResolveRenderCamera();

		if ( renderCamera.IsValid() )
			BindCamera( renderCamera );

		if ( !TryGetSubmersion( viewPosition, out var surface, out var depth ) )
		{
			if ( _wasUnderwater && LogTransitions )
				Log.Info( "[OceanUnderwater] exited water" );
			_wasUnderwater = false;
			SetEffectsActive( false, surface, 0f );
			return;
		}

		if ( !_wasUnderwater && LogTransitions )
			Log.Info( $"[OceanUnderwater] entered water surfaceZ={surface:F0} depth={depth:F0} edit={IsEditMode}" );
		_wasUnderwater = true;

		var t = DepthFactor( depth );
		SetEffectsActive( true, surface, t );
		UpdateCommandList( true, surface, t );
	}

	/// <summary>0 at surface → 1 at FullEffectDepth. Stays shallow through the upper band, then darkens.</summary>
	float DepthFactor( float depth )
	{
		var linear = MathX.Clamp( depth / MathF.Max( FullEffectDepth, 1f ), 0f, 1f );
		// Hold bright shallow look through ~55% of the depth range before darkening.
		var delayed = MathX.Clamp( (linear - 0.55f) / 0.45f, 0f, 1f );
		return delayed * delayed * ( 3f - 2f * delayed );
	}

	Color SampleWaterColor( float t ) => Color.Lerp( WaterColor, DeepWaterColor, t );

	protected override void DrawGizmos()
	{
		if ( !EditorScreenHint || !_wasUnderwater )
			return;

		Gizmo.Draw.Color = WaterColor.WithAlpha( 0.35f );
		Gizmo.Draw.SolidBox( new BBox( GetViewPosition() - 64f, GetViewPosition() + 64f ) );
		Gizmo.Draw.Color = Color.White;
		Gizmo.Draw.Text( $"UNDERWATER", new Transform( GetViewPosition() + Vector3.Up * 120f ) );
	}

	Vector3 GetViewPosition()
	{
		// Match WaterManager: editor uses the editor camera position, not Scene.Camera.
		if ( IsEditMode && Application.Editor.Camera.IsValid() )
			return Application.Editor.Camera.WorldPosition;

		var cam = ResolveRenderCamera();
		return cam.IsValid() ? cam.WorldPosition : WorldPosition;
	}

	void SetEffectsActive( bool active, float surface, float t )
	{
		if ( _volume.IsValid() )
		{
			_volume.Enabled = true;
			_volume.BlendWeight = 1f;
			_volume.EditorPreview = true;
		}

		var tint = SampleWaterColor( t );

		if ( _caustics.IsValid() )
		{
			_caustics.Enabled = active;
			_caustics.ForceLocalValues = true;
			_caustics.SurfaceZ = surface;
			_caustics.WaterColor = WaterColor;
			_caustics.DeepWaterColor = DeepWaterColor;
			_caustics.MaxFogDepth = FullEffectDepth;
			_caustics.FogOpacity = MathX.Lerp( 0.2f, 0.4f, t );
			_caustics.FogDensity = MathX.Lerp( 0.004f, 0.012f, t );
			_caustics.CausticsIntensity = MathX.Lerp( 2.0f, 0.4f, t );
			_caustics.GodRayIntensity = MathX.Lerp( 1.0f, 0.25f, t );
		}

		if ( _fog.IsValid() )
		{
			// Keep SimpleFog light — heavy fog was wiping the scene at depth.
			_fog.Enabled = active;
			_fog.Color = tint;
			_fog.Intensity = MathX.Lerp( 0.05f, 0.18f, t );
			_fog.Opacity = MathX.Lerp( 0.1f, 0.28f, t );
		}

		if ( _wobble.IsValid() )
		{
			_wobble.Enabled = active;
			_wobble.Amplitude = MathX.Lerp( 0.4f, 0.75f, t );
			_wobble.Frequency = 14f;
			_wobble.Speed = 2.0f;
		}

		if ( _color.IsValid() )
		{
			_color.Enabled = active;
			_color.Brightness = MathX.Lerp( 1.15f, 0.88f, t );
			_color.Saturation = MathX.Lerp( 1.15f, 1.05f, t );
			_color.Contrast = MathX.Lerp( 1.0f, 1.04f, t );
			_color.HueRotate = MathX.Lerp( 6f, 12f, t );
		}

		if ( _vignette.IsValid() )
		{
			_vignette.Enabled = active;
			_vignette.Intensity = MathX.Lerp( 0.05f, 0.16f, t );
			_vignette.Color = tint.WithAlpha( 1f );
		}

		if ( _blur.IsValid() )
		{
			_blur.Enabled = active;
			_blur.Size = MathX.Lerp( 0.015f, 0.05f, t );
		}

		if ( !active )
			UpdateCommandList( false, surface, 0f );
	}

	bool TryGetSubmersion( Vector3 position, out float surface, out float depth )
	{
		surface = 0f;
		depth = 0f;

		ResolveWaterBody();

		if ( WaterBody.IsValid() )
		{
			if ( !WaterBody.ContainsPointInVolume( position ) )
				return false;

			surface = WaterBody.GetWaveHeightAt( position );
		}
		else if ( WaterManager.Current is not null && WaterManager.IsPositionInsideAny( position ) )
		{
			surface = WaterManager.GetWaterHeightAt( position );
		}
		else
		{
			surface = WorldPosition.z;
			var local = WorldTransform.PointToLocal( position );
			var halfW = 500_000f;
			var halfL = 500_000f;
			var depthLimit = 20_000f;

			var volumeCtrl = Components.Get<OceanWaterVolumeControllerComponent>();
			if ( volumeCtrl.IsValid() )
			{
				halfW = volumeCtrl.Width * 0.5f;
				halfL = volumeCtrl.Length * 0.5f;
				depthLimit = volumeCtrl.Depth;
			}

			if ( MathF.Abs( local.x ) > halfW || MathF.Abs( local.y ) > halfL )
				return false;
			if ( local.z > 0f || local.z < -depthLimit )
				return false;
		}

		if ( surface <= float.MinValue * 0.5f )
			return false;

		if ( position.z >= surface - 2f )
			return false;

		TerrainWorld ??= Scene.GetAllComponents<WorldManagerSingletonComponent>().FirstOrDefault();
		if ( TerrainWorld.IsValid() )
		{
			var terrain = TerrainWorld.GetHeight( position.x, position.y );
			if ( position.z < terrain - BuriedTolerance )
				return false;
		}

		depth = surface - position.z;
		return true;
	}

	void ResolveWaterBody()
	{
		WaterBody ??= Components.Get<WaterBody>( FindMode.EverythingInSelfAndDescendants );
		WaterBody ??= Scene.GetAllComponents<WaterBody>().FirstOrDefault( b => b.WaterType == WaterBodyType.Ocean );
	}

	void EnsureEffects()
	{
		EnsurePostProcess();
		RemoveLegacyOverlay();
		EnsureCommandList();
	}

	void EnsurePostProcess()
	{
		if ( _volume.IsValid() )
		{
			_volume.EditorPreview = true;
			_volume.Enabled = true;
			return;
		}

		_volume = Components.Get<PostProcessVolume>( FindMode.EverythingInSelfAndDescendants );
		if ( _volume.IsValid() )
		{
			Cache( _volume.GameObject );
			ForceInfiniteVolume();
			_volume.Enabled = true;
			_volume.EditorPreview = true;
			return;
		}

		var go = new GameObject( true, "Underwater Effects" );
		go.Parent = GameObject;
		go.LocalPosition = Vector3.Zero;

		_volume = go.Components.Create<PostProcessVolume>();
		_volume.Enabled = true;
		_volume.EditorPreview = true;
		_volume.BlendWeight = 1f;
		_volume.Priority = 10;
		ForceInfiniteVolume();

		_caustics = go.Components.Create<UnderwaterCausticsEffect>();
		_caustics.ForceLocalValues = true;
		_caustics.Enabled = false;

		_fog = go.Components.Create<SimpleFog>();
		_fog.Enabled = false;

		_wobble = go.Components.Create<WobbleEffect>();
		_wobble.Enabled = false;

		_color = go.Components.Create<ColorAdjustments>();
		_color.Enabled = false;

		_vignette = go.Components.Create<Vignette>();
		_vignette.Enabled = false;

		_blur = go.Components.Create<Blur>();
		_blur.Enabled = false;
	}

	void ForceInfiniteVolume()
	{
		if ( !_volume.IsValid() )
			return;

		_volume.SceneVolume = new SceneVolume
		{
			Type = SceneVolume.VolumeTypes.Infinite,
			Box = new BBox( new Vector3( -1e7f ), new Vector3( 1e7f ) )
		};
		_volume.EditorPreview = true;
	}

	void RemoveLegacyOverlay()
	{
		if ( _legacyOverlayRemoved )
			return;

		_legacyOverlayRemoved = true;
		foreach ( var child in GameObject.Children )
		{
			if ( child.Name == "Underwater Overlay" )
				child.Destroy();
		}
	}

	void EnsureCommandList()
	{
		_commandList ??= new CommandList( "Ocean Underwater Fill" ) { Enabled = false };
		_underwaterMaterial ??= Material.FromShader( "shaders/pp_underwater" );
	}

	void BindCamera( CameraComponent camera )
	{
		if ( !camera.IsValid() || _boundCamera == camera )
			return;

		UnbindCamera();
		EnsureCommandList();

		_boundCamera = camera;
		_boundCamera.AddCommandList( _commandList, RenderStage.AfterPostProcess, 40 );

		// Editor viewport inherits lists from the scene camera — also attach to editor cam when available.
		if ( IsEditMode && Application.Editor.Camera.IsValid() && Application.Editor.Camera != camera )
			Application.Editor.Camera.AddCommandList( _commandList, RenderStage.AfterPostProcess, 40 );
	}

	void UnbindCamera()
	{
		if ( _commandList is null )
		{
			_boundCamera = null;
			return;
		}

		if ( _boundCamera.IsValid() )
			_boundCamera.RemoveCommandList( _commandList );

		if ( Application.Editor.Camera.IsValid() )
			Application.Editor.Camera.RemoveCommandList( _commandList );

		_boundCamera = null;
	}

	void UpdateCommandList( bool active, float surface, float t )
	{
		EnsureCommandList();

		if ( _commandList is null || _underwaterMaterial is null )
			return;

		_commandList.Reset();
		_commandList.Enabled = active;

		if ( !active )
			return;

		_commandList.GrabFrameTexture( "ColorBuffer" );
		_commandList.Attributes.Set( "WaterColor", WaterColor );
		_commandList.Attributes.Set( "DeepWaterColor", DeepWaterColor );
		_commandList.Attributes.Set( "CausticsColor", new Color( 0.85f, 0.98f, 1f ) );
		_commandList.Attributes.Set( "FogDensity", MathX.Lerp( 0.004f, 0.012f, t ) );
		_commandList.Attributes.Set( "FogOpacity", MathX.Lerp( 0.2f, 0.4f, t ) );
		_commandList.Attributes.Set( "CausticsIntensity", MathX.Lerp( 2.0f, 0.35f, t ) );
		_commandList.Attributes.Set( "CausticsScale", 0.007f );
		_commandList.Attributes.Set( "CausticsSpeed", 0.4f );
		_commandList.Attributes.Set( "SurfaceZ", surface );
		_commandList.Attributes.Set( "MaxFogDepth", FullEffectDepth );
		_commandList.Attributes.Set( "GodRayIntensity", MathX.Lerp( 1.0f, 0.2f, t ) );
		_commandList.Blit( _underwaterMaterial );
	}

	void Cache( GameObject go )
	{
		_caustics ??= go.Components.Get<UnderwaterCausticsEffect>( FindMode.EverythingInSelfAndDescendants );
		_fog ??= go.Components.Get<SimpleFog>( FindMode.EverythingInSelfAndDescendants );
		_wobble ??= go.Components.Get<WobbleEffect>( FindMode.EverythingInSelfAndDescendants );
		_color ??= go.Components.Get<ColorAdjustments>( FindMode.EverythingInSelfAndDescendants );
		_vignette ??= go.Components.Get<Vignette>( FindMode.EverythingInSelfAndDescendants );
		_blur ??= go.Components.Get<Blur>( FindMode.EverythingInSelfAndDescendants );

		if ( _caustics.IsValid() )
			_caustics.ForceLocalValues = true;
	}

	CameraComponent ResolveRenderCamera()
	{
		// In the editor, prefer the editor camera for command lists / preview.
		if ( IsEditMode && Application.Editor.Camera.IsValid() )
			return Application.Editor.Camera;

		try
		{
			if ( Scene.Camera.IsValid() )
				return Scene.Camera;
		}
		catch
		{
			// ignored
		}

		foreach ( var candidate in Scene.GetAllComponents<CameraComponent>() )
		{
			if ( candidate.IsValid() && candidate.Enabled )
				return candidate;
		}

		return null;
	}
}
