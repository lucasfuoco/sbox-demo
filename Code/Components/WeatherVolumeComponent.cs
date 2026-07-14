namespace Sandbox.Components;

/// <summary>
/// Localized weather volume for open-world scenes.
/// Place on a GameObject, set <see cref="Size"/> and <see cref="VolumeType"/>, then tune
/// <see cref="Sample"/> or leave defaults from the type preset.
/// </summary>
[Title( "Weather Volume" ), Category( "World Simulation" ), Icon( "cloud" )]
public sealed class WeatherVolumeComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Volume" )]
	public Vector3 Size { get; set; } = new( 4096f, 1200f, 4096f );

	[Property, Group( "Volume" ), Range( 0f, 131072f )]
	public float BlendDistance { get; set; } = 512f;

	[Property, Group( "Volume" ), Title( "Horizontal Blend Only" ), Description( "Ignore height when sampling this volume. Use for sky weather patches so rain triggers under the cloud footprint." )]
	public bool HorizontalBlendOnly { get; set; }

	[Property, Group( "Volume" )]
	public WeatherVolumeType VolumeType { get; set; } = WeatherVolumeType.RainCloud;

	[Property, Group( "Weather" ), Title( "Use Type Defaults" )]
	public bool UseTypeDefaults { get; set; } = true;

	[Property, Group( "Weather" )]
	public WeatherSample Sample { get; set; }

	[Property, Group( "Weather" ), Title( "Align Wind To Transform" ), Description( "Use this object's forward axis as the volume wind direction." )]
	public bool AlignWindToTransform { get; set; }

	[Property, Group( "Movement" ), Title( "Drift With Wind" ), Description( "Move this volume horizontally with global wind." )]
	public bool DriftWithWind { get; set; }

	[Property, Group( "Debug" )]
	public Color GizmoColor { get; set; } = new Color( 0.35f, 0.65f, 1f, 0.35f );

	[Property, Group( "Debug" )]
	public bool DrawBlendShell { get; set; } = true;

	[Property, Group( "Debug" ), Title( "Draw Cloud Preview" ), Description( "Soft fill inside the volume box in the editor." )]
	public bool DrawCloudPreview { get; set; } = true;

	protected override void OnValidate()
	{
		if ( UseTypeDefaults )
			Sample = WeatherSample.FromVolumeType( VolumeType );

		Size = new Vector3(
			MathF.Max( Size.x, 1f ),
			MathF.Max( Size.y, 1f ),
			MathF.Max( Size.z, 1f ) );

		BlendDistance = MathF.Max( BlendDistance, 0f );

		EnsureCloudRenderer();
		EnsureWindDrift();
		EnsureRain();
		EnsureLightning();
	}

	protected override void OnAwake()
	{
		EnsureCloudRenderer();
		EnsureWindDrift();
		EnsureRain();
		EnsureLightning();
	}

	protected override void OnStart()
	{
		EnsureWindDrift();
		EnsureLightning();
	}

	void EnsureWindDrift()
	{
		var drift = Components.Get<WeatherVolumeWindDriftComponent>();
		if ( !DriftWithWind )
		{
			if ( drift.IsValid() )
				drift.Enabled = false;

			return;
		}

		if ( !drift.IsValid() )
			drift = Components.Create<WeatherVolumeWindDriftComponent>();

		if ( drift.IsValid() )
			drift.Enabled = true;
	}

	void EnsureCloudRenderer()
	{
		if ( Components.Get<WeatherVolumeCloudRendererComponent>().IsValid() )
			return;

		Components.Create<WeatherVolumeCloudRendererComponent>();
	}

	void EnsureRain()
	{
		var wantsRain = VolumeType is WeatherVolumeType.RainCloud or WeatherVolumeType.StormCloud;
		var rain = Components.Get<WeatherVolumeRainComponent>();

		if ( !wantsRain )
		{
			if ( rain.IsValid() )
				rain.Enabled = false;

			return;
		}

		if ( !rain.IsValid() )
			rain = Components.Create<WeatherVolumeRainComponent>();

		rain.EnableRain = true;
		rain.EditorPreview = true;
		rain.Enabled = true;
	}

	void EnsureLightning()
	{
		var wantsLightning = VolumeType == WeatherVolumeType.StormCloud;
		DeduplicateLightningComponents();

		var controller = Components.Get<WeatherVolumeLightningControllerComponent>();
		var renderer = Components.Get<WeatherVolumeLightningRendererComponent>();

		if ( !wantsLightning )
		{
			if ( controller.IsValid() )
				controller.Enabled = false;

			if ( renderer.IsValid() )
				renderer.Enabled = false;

			return;
		}

		if ( !renderer.IsValid() )
			renderer = Components.Create<WeatherVolumeLightningRendererComponent>();

		if ( !controller.IsValid() )
			controller = Components.Create<WeatherVolumeLightningControllerComponent>();

		renderer.Enabled = true;
		controller.Enabled = true;
		controller.EnableLightning = true;
		controller.EditorPreview = true;
	}

	void DeduplicateLightningComponents()
	{
		var renderers = Components.GetAll<WeatherVolumeLightningRendererComponent>().ToArray();
		for ( var i = 1; i < renderers.Length; i++ )
		{
			if ( renderers[i].IsValid() )
				renderers[i].Destroy();
		}

		var controllers = Components.GetAll<WeatherVolumeLightningControllerComponent>().ToArray();
		for ( var i = 1; i < controllers.Length; i++ )
		{
			if ( controllers[i].IsValid() )
				controllers[i].Destroy();
		}
	}

	/// <summary>
	/// Returns the effective sample for this volume (type preset plus manual overrides).
	/// </summary>
	public WeatherSample GetWeatherSample()
	{
		var sample = UseTypeDefaults
			? WeatherSample.FromVolumeType( VolumeType )
			: Sample;

		if ( AlignWindToTransform )
		{
			var forward = Transform.World.Rotation.Forward.WithZ( 0f );
			sample.WindDirection = forward.LengthSquared > 0.0001f ? forward.Normal : Vector3.Forward;
		}

		return sample;
	}

	/// <summary>
	/// True when <paramref name="worldPosition"/> is inside the box bounds (ignoring edge blend).
	/// </summary>
	public bool Contains( Vector3 worldPosition )
	{
		var local = WorldToLocal( worldPosition );
		var half = GetHalfExtents();
		return MathF.Abs( local.x ) <= half.x
			&& MathF.Abs( local.y ) <= half.y
			&& MathF.Abs( local.z ) <= half.z;
	}

	/// <summary>
	/// 0 outside the volume, 1 in the core, smooth falloff in the outer <see cref="BlendDistance"/> shell.
	/// </summary>
	public float GetBlend( Vector3 worldPosition )
	{
		var local = WorldToLocal( worldPosition );
		var half = GetHalfExtents();
		var blendDistance = MathF.Max( BlendDistance, 0.01f );

		var blendX = GetAxisBlend( MathF.Abs( local.x ), half.x, blendDistance );
		var blendY = GetAxisBlend( MathF.Abs( local.y ), half.y, blendDistance );
		if ( HorizontalBlendOnly )
			return MathF.Min( blendX, blendY );

		var blendZ = GetAxisBlend( MathF.Abs( local.z ), half.z, blendDistance );
		return MathF.Min( blendX, MathF.Min( blendY, blendZ ) );
	}

	public BBox GetWorldBounds() => BBox.FromPositionAndSize( Transform.World.Position, Size );

	Vector3 GetHalfExtents() => Size * 0.5f;

	Vector3 WorldToLocal( Vector3 worldPosition ) =>
		Transform.World.ToLocal( new Transform( worldPosition, Rotation.Identity ) ).Position;

	static float GetAxisBlend( float distance, float halfExtent, float blendDistance )
	{
		if ( distance <= halfExtent - blendDistance )
			return 1f;

		if ( distance >= halfExtent )
			return 0f;

		return 1f - (distance - (halfExtent - blendDistance)) / blendDistance;
	}

	protected override void DrawGizmos()
	{
		if ( !Sandbox.Preferences.ShowVolumes && !Gizmo.IsSelected )
			return;

		if ( Game.IsEditor && !Game.IsPlaying )
			EnsureCloudRenderer();

		Gizmo.Transform = Transform.World;

		var alpha = Gizmo.IsSelected ? 0.55f : 0.28f;
		Gizmo.Draw.Color = GizmoColor.WithAlpha( alpha );
		Gizmo.Draw.LineBBox( BBox.FromPositionAndSize( Vector3.Zero, Size ) );

		DrawCloudPreviewGizmo();

		DrawWindDirectionGizmo();

		if ( !DrawBlendShell || BlendDistance <= 0.01f )
			return;

		var innerSize = Size - new Vector3( BlendDistance, BlendDistance, BlendDistance ) * 2f;
		if ( innerSize.x <= 1f || innerSize.y <= 1f || innerSize.z <= 1f )
			return;

		Gizmo.Draw.Color = GizmoColor.WithAlpha( alpha * 0.45f );
		Gizmo.Draw.LineBBox( BBox.FromPositionAndSize( Vector3.Zero, innerSize ) );
	}

	void DrawCloudPreviewGizmo()
	{
		if ( !DrawCloudPreview )
			return;

		var cloudRenderer = Components.Get<WeatherVolumeCloudRendererComponent>();
		if ( cloudRenderer.IsValid() )
		{
			if ( !cloudRenderer.EnableClouds || !cloudRenderer.EditorGizmoPreview )
				return;
		}

		var sample = GetWeatherSample();
		if ( sample.CloudDensity <= 0.01f )
			return;

		var fillAlpha = Gizmo.IsSelected ? 0.38f : 0.16f;
		fillAlpha *= MathF.Max( sample.CloudDensity, 0.35f );

		Gizmo.Draw.IgnoreDepth = true;
		Gizmo.Draw.Color = GizmoColor.WithAlpha( fillAlpha );
		Gizmo.Draw.SolidBox( BBox.FromPositionAndSize( Vector3.Zero, Size ) );

		var bandAlpha = Gizmo.IsSelected ? 0.5f : 0.28f;
		Gizmo.Draw.Color = GizmoColor.WithAlpha( bandAlpha );
		const int bandCount = 5;
		for ( var i = 0; i < bandCount; i++ )
		{
			var t = (i + 1f) / (bandCount + 1f);
			var centerY = (t - 0.5f) * Size.y;
			var bandHeight = Size.y * 0.1f;
			Gizmo.Draw.LineBBox( BBox.FromPositionAndSize(
				new Vector3( 0f, centerY, 0f ),
				new Vector3( Size.x, bandHeight, Size.z ) ) );
		}

		Gizmo.Draw.IgnoreDepth = false;
	}

	void DrawWindDirectionGizmo()
	{
		var sample = GetWeatherSample();
		if ( sample.WindStrength <= 0.02f )
			return;

		var forward = sample.WindDirection.WithZ( 0f );
		if ( forward.LengthSquared <= 0.0001f )
			return;

		forward = forward.Normal;
		var arrowLength = MathF.Min( Size.x, Size.z ) * 0.35f;
		var start = Vector3.Up * Size.y * 0.1f;
		var end = start + forward * arrowLength;

		Gizmo.Draw.Color = Color.White.WithAlpha( Gizmo.IsSelected ? 0.9f : 0.55f );
		Gizmo.Draw.Line( start, end );
		Gizmo.Draw.LineSphere( end, 24f, 4 );
	}
}
