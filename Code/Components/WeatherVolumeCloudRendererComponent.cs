using Sandbox.Components;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

/// <summary>
/// Renders soft cloud particles inside a <see cref="WeatherVolumeComponent"/>.
/// </summary>
[Title( "Weather Volume Cloud Renderer" ), Category( "World Simulation" ), Icon( "cloud" )]
public sealed class WeatherVolumeCloudRendererComponent : Component, Component.ExecuteInEditor
{
	[RequireComponent]
	public WeatherVolumeComponent Volume { get; private set; }

	[Property, Group( "Clouds" ), Title( "Enable Cloud Particles" )]
	public bool EnableClouds { get; set; } = true;

	[Property, Group( "Clouds" ), Title( "Cloud Sprite" ), Description( "Defaults to sprites/cloud_mist.sprite when unset." )]
	public Sprite CloudSprite { get; set; }

	[Property, Group( "Clouds" ), Title( "Cloud Amount" ), Range( 0.25f, 5f ), Description( "Multiplier for particle count and spawn rate." )]
	public float CloudAmount { get; set; } = 1.6f;

	[Property, Group( "Clouds" ), Title( "Top Cloud Band" ), Description( "Spawn clouds in a thin slab at the top of the volume instead of filling the full height." )]
	public bool UseTopCloudBand { get; set; } = true;

	[Property, Group( "Clouds" ), Title( "Top Band Fraction" ), Range( 0.02f, 0.35f ), Description( "Fraction of volume height used for the cloud slab (anchored to the top face)." )]
	public float TopBandFraction { get; set; } = 0.08f;

	[Property, Group( "Clouds" ), Title( "Top Band Max Height" ), Range( 512f, 20000f ), Description( "Caps the cloud slab thickness so tall volumes stay a flat deck." )]
	public float TopBandMaxHeight { get; set; } = 4500f;

	[Property, Group( "Clouds" ), Title( "Require Listener Inside Volume" )]
	public bool RequireListenerInsideVolume { get; set; }

	[Property, Group( "Clouds" ), Title( "Editor Gizmo Preview" ), Description( "Draw a soft fill in the editor when particles are not simulating." )]
	public bool EditorGizmoPreview { get; set; } = true;

	[Property, Group( "Clouds" ), Title( "Cloud Size" ), Range( 0.25f, 10f ), Description( "Overall cloud puff size multiplier." )]
	public float CloudSize { get; set; } = 4f;

	[Property, Group( "Clouds" ), Title( "Sprite Scale Min" ), Range( 0.1f, 2f )]
	public float SpriteScaleMin { get; set; } = 0.65f;

	[Property, Group( "Clouds" ), Title( "Sprite Scale Max" ), Range( 1f, 5f )]
	public float SpriteScaleMax { get; set; } = 3.5f;

	[Property, Group( "Clouds" ), Title( "Fade In Duration" ), Range( 5f, 120f ), Description( "Seconds for clouds to reach full opacity when spawning or turning on." )]
	public float CloudFadeInSeconds { get; set; } = 30f;

	[Property, Group( "Clouds" ), Title( "Scale By Global Weather" ), Description( "Multiply this volume's cloud density by global weather overcast. Disable for always-on localized cloud volumes." )]
	public bool ScaleCloudsByGlobalWeather { get; set; } = true;

	[Property, Group( "Clouds" ), Title( "Color Transition Duration" ), Range( 2f, 60f ), Description( "Seconds to blend cloud tint when global weather changes." )]
	public float CloudColorTransitionSeconds { get; set; } = 15f;

	[Property, Group( "Clouds" ), Title( "Use Volume Cloud Tint" ), Description( "Tint particles from this volume's WeatherVolumeType instead of only global weather." )]
	public bool UseVolumeCloudTint { get; set; }

	[Property, Group( "Clouds" ), Title( "Volume Tint Strength" ), Range( 0f, 1f )]
	public float VolumeTintStrength { get; set; } = 1f;

	[Property, Group( "Clouds" ), Title( "Cast Shadows" ), Description( "Very expensive on large cloud decks. Prefer Projected Ground Shadow instead." )]
	public bool CastShadows { get; set; }

	[Property, Group( "Clouds" ), Title( "Receive Lighting" ), Description( "Per-sprite scene lighting is costly. Prefer baked sun-side tint." )]
	public bool ReceiveLighting { get; set; }

	[Property, Group( "Lighting" ), Title( "Sun Side Shading" ), Range( 0f, 1f ), Description( "Fake lit/dark cloud sides from the sun direction. Cheap baked shading." )]
	public float SunSideShading { get; set; } = 0.4f;

	[Property, Group( "Lighting" ), Title( "Projected Ground Shadow" ), Description( "One soft ground blob under the camera. Cheap stand-in for cloud shadows." )]
	public bool ProjectedGroundShadow { get; set; } = true;

	[Property, Group( "Lighting" ), Title( "Shadow Footprint Scale" ), Range( 0.25f, 2f )]
	public float ShadowFootprintScale { get; set; } = 1f;

	WeatherVolumeManagerComponent _volumeManager;
	WorldCloudEffect _effect;
	WorldCloudGroundShadow _groundShadow;
	float _timeSeconds;

	bool IsEditMode => Game.IsEditor && !Game.IsPlaying;

	protected override void OnAwake()
	{
		EnsureEffect();
		TickClouds();
	}

	protected override void OnStart()
	{
		EnsureEffect();
		TickClouds();
	}

	protected override void OnValidate()
	{
		EnsureEffect();
		TickClouds();
	}

	protected override void OnUpdate()
	{
		TickClouds();
	}

	protected override void DrawGizmos()
	{
		if ( !IsEditMode || !EditorGizmoPreview )
			return;

		// Cloud particles tick from OnUpdate; only draw the volume preview here.
	}

	void TickClouds()
	{
		if ( !Volume.IsValid() || !EnableClouds )
		{
			if ( _effect.IsValid() )
				_effect.Root.Enabled = false;

			if ( _groundShadow.IsValid() )
				_groundShadow.Root.Enabled = false;

			return;
		}

		EnsureEffect();
		if ( !_effect.IsValid() )
			return;

		_timeSeconds += Time.Delta;

		var volumeSample = Volume.GetWeatherSample();
		var effectiveDensity = GetEffectiveCloudDensity( volumeSample );

		var listener = ResolveListenerPosition();
		if ( RequireListenerInsideVolume && !Volume.Contains( listener ) )
		{
			_effect.Root.Enabled = false;
			if ( _groundShadow.IsValid() )
				_groundShadow.Root.Enabled = false;
			return;
		}

		GetEmissionRegion( listener, out var emissionCenter, out var emissionSize, out var localEmissionCenter, out var showFog );
		if ( Volume.VolumeType == WeatherVolumeType.FogBank && !showFog )
		{
			_effect.Root.Enabled = false;
			if ( _groundShadow.IsValid() )
				_groundShadow.Root.Enabled = false;
			return;
		}

		var cloudTint = ResolveCloudTint( listener );
		var globalWeather = ResolveCloudWeatherSample();
		var lightningFlash = ResolveLightningFlash();
		var lightningFlashes = ResolveLightningFlashes();

		// Ground fog needs denser local particles than a sky deck of the same footprint.
		var cloudAmount = CloudAmount;
		if ( Volume.VolumeType == WeatherVolumeType.FogBank )
			cloudAmount = MathF.Max( cloudAmount, IsEditMode ? 3.2f : 2.6f );

		_effect.Update(
			emissionCenter,
			emissionSize,
			localEmissionCenter,
			emissionCenter,
			effectiveDensity,
			globalWeather.WindDirection,
			globalWeather.WindStrength,
			_timeSeconds,
			SpriteScaleMin,
			SpriteScaleMax,
			CloudSize,
			cloudAmount,
			Time.Delta,
			CloudFadeInSeconds,
			cloudTint,
			CloudColorTransitionSeconds,
			moveWithVolume: true,
			CastShadows,
			ReceiveLighting,
			SunSideShading,
			lightningFlash,
			lightningFlashes );

		UpdateGroundShadow( listener, effectiveDensity, emissionSize );
	}

	float ResolveLightningFlash()
	{
		if ( Volume.VolumeType != WeatherVolumeType.StormCloud )
			return 0f;

		var lightning = Components.Get<WeatherVolumeLightningControllerComponent>();
		return lightning.IsValid() && lightning.Enabled ? lightning.CurrentFlashIntensity : 0f;
	}

	IReadOnlyList<WeatherLightningFlash> ResolveLightningFlashes()
	{
		if ( Volume.VolumeType != WeatherVolumeType.StormCloud )
			return Array.Empty<WeatherLightningFlash>();

		var lightning = Components.Get<WeatherVolumeLightningControllerComponent>();
		return lightning.IsValid() && lightning.Enabled
			? lightning.ActiveFlashes
			: Array.Empty<WeatherLightningFlash>();
	}

	void UpdateGroundShadow( Vector3 listener, float density, Vector3 emissionSize )
	{
		if ( !ProjectedGroundShadow )
		{
			if ( _groundShadow.IsValid() )
				_groundShadow.Root.Enabled = false;
			return;
		}

		EnsureGroundShadow();
		if ( !_groundShadow.IsValid() )
			return;

		var footprint = MathF.Max( emissionSize.x, emissionSize.y ) * MathF.Max( ShadowFootprintScale, 0.1f );
		// Keep the blob camera-local so one soft shadow covers what you see.
		footprint = MathF.Min( footprint, 10000f );
		var blend = Volume.GetBlend( listener );
		var shadowDensity = density * blend;
		_groundShadow.Update( listener, shadowDensity, footprint, enabled: shadowDensity > 0.05f && Game.IsPlaying );
	}

	Color ResolveCloudTint( Vector3 listener )
	{
		var globalTint = !Game.IsPlaying
			? WeatherCloudPalette.GetCloudTintForWeatherType( ResolveStartingWeather() )
			: WeatherCloudPalette.GetCloudTint( ResolveCloudWeatherSample() );

		var tint = globalTint;

		if ( UseVolumeCloudTint )
		{
			var volumeTint = WeatherCloudPalette.GetCloudTint( Volume.VolumeType );
			tint = Color.Lerp( globalTint, volumeTint, VolumeTintStrength );
		}
		else if ( WeatherCloudPalette.IsExoticVolumeType( Volume.VolumeType ) )
		{
			var blend = Volume.GetBlend( listener );
			tint = Color.Lerp(
				globalTint,
				WeatherCloudPalette.GetCloudTint( Volume.VolumeType ),
				blend );
		}

		return tint.WithAlpha( 1f );
	}

	WeatherType ResolveStartingWeather()
	{
		EnsureVolumeManager();

		var world = _volumeManager.IsValid() ? _volumeManager.World : null;
		world ??= WorldManagerComponent.Instance;

		if ( world.IsValid() && world.Weather.IsValid() )
			return world.Weather.StartingWeather;

		if ( TryGetWeatherManager( out var weatherManager ) )
			return weatherManager.StartingWeather;

		return WeatherType.Clear;
	}

	float GetEffectiveCloudDensity( WeatherSample volumeSample )
	{
		var density = volumeSample.CloudDensity;

		if ( Volume.VolumeType == WeatherVolumeType.FogBank )
		{
			// Fog banks are thin ground slabs — keep density high enough to read in editor/play.
			density = MathF.Max( density, IsEditMode ? 0.95f : 0.75f );
		}

		if ( !ScaleCloudsByGlobalWeather )
			return density;

		var global = ResolveCloudWeatherSample();
		var weatherScale = global.CloudDensity;

		// Editor: keep clouds visible for placement preview; tint still follows Starting Weather.
		if ( !Game.IsPlaying && weatherScale <= 0.001f )
			weatherScale = 1f;

		return density * weatherScale;
	}

	WeatherSample ResolveCloudWeatherSample()
	{
		EnsureVolumeManager();

		var world = _volumeManager.IsValid() ? _volumeManager.World : null;
		world ??= WorldManagerComponent.Instance;

		if ( world.IsValid() && world.Weather.IsValid() )
		{
			if ( IsEditMode )
				return WeatherSample.FromProfile( WeatherProfile.GetPreset( world.Weather.StartingWeather ) );

			return WeatherSample.FromWeatherManager( world.Weather );
		}

		if ( TryGetWeatherManager( out var weatherManager ) )
		{
			if ( IsEditMode )
				return WeatherSample.FromProfile( WeatherProfile.GetPreset( weatherManager.StartingWeather ) );

			return WeatherSample.FromWeatherManager( weatherManager );
		}

		return WeatherSample.DefaultClear;
	}

	bool TryGetWeatherManager( out WeatherManagerComponent weatherManager )
	{
		weatherManager = null;

		if ( Scene is null )
			return false;

		weatherManager = Scene.GetAllComponents<WeatherManagerComponent>().FirstOrDefault();
		return weatherManager.IsValid();
	}

	void GetEmissionRegion(
		Vector3 listener,
		out Vector3 emissionCenter,
		out Vector3 emissionSize,
		out Vector3 localEmissionCenter,
		out bool showFog )
	{
		showFog = true;
		var volumeSize = Volume.Size;
		var half = volumeSize * 0.5f;
		var world = Volume.Transform.World;

		if ( Volume.VolumeType == WeatherVolumeType.FogBank )
		{
			// Huge fog footprints are too sparse if particles fill the whole box.
			// Keep a camera-local ground pocket so fog is visible in editor and play.
			var blend = GetHorizontalBlend( listener );
			showFog = IsEditMode || blend > 0.02f;
			if ( !showFog )
			{
				emissionCenter = world.Position;
				emissionSize = Vector3.Zero;
				localEmissionCenter = Vector3.Zero;
				return;
			}

			var height = MathF.Max( volumeSize.z, 1200f );
			var pocket = MathX.Clamp( MathF.Max( volumeSize.x, volumeSize.y ) * 0.05f, 7000f, 14000f );
			var groundZ = ResolveTerrainHeight( listener.x, listener.y );
			emissionCenter = new Vector3( listener.x, listener.y, groundZ + height * 0.45f );
			emissionSize = new Vector3( pocket, pocket, height );
			localEmissionCenter = world.PointToLocal( emissionCenter );
			return;
		}

		if ( !UseTopCloudBand )
		{
			emissionCenter = world.Position;
			emissionSize = volumeSize;
			localEmissionCenter = Vector3.Zero;
			return;
		}

		var bandHeight = MathF.Max( volumeSize.z * TopBandFraction, 512f );
		bandHeight = MathF.Min( bandHeight, MathF.Min( volumeSize.z, TopBandMaxHeight ) );

		// Flush to the top face of the volume (local +Z).
		localEmissionCenter = new Vector3( 0f, 0f, half.z - bandHeight * 0.5f );
		emissionSize = new Vector3( volumeSize.x, volumeSize.y, bandHeight );
		emissionCenter = world.Position + world.Rotation * localEmissionCenter;
	}

	float GetHorizontalBlend( Vector3 worldPosition )
	{
		var local = Volume.Transform.World.ToLocal( new Transform( worldPosition, Rotation.Identity ) ).Position;
		var half = Volume.Size * 0.5f;
		var blendDistance = MathF.Max( Volume.BlendDistance, 20000f );

		var blendX = AxisBlend( MathF.Abs( local.x ), half.x, blendDistance );
		var blendY = AxisBlend( MathF.Abs( local.y ), half.y, blendDistance );
		return MathF.Min( blendX, blendY );
	}

	static float AxisBlend( float distance, float halfExtent, float blendDistance )
	{
		if ( distance <= halfExtent - blendDistance )
			return 1f;

		if ( distance >= halfExtent )
			return 0f;

		return 1f - (distance - (halfExtent - blendDistance)) / blendDistance;
	}

	float ResolveTerrainHeight( float worldX, float worldY )
	{
		var world = WorldManagerComponent.Instance;
		if ( world.IsValid() )
		{
			var terrain = world.GameObject.Components.Get<WorldManagerSingletonComponent>();
			if ( terrain.IsValid() )
				return terrain.GetHeight( worldX, worldY );
		}

		var singleton = Scene?.GetAllComponents<WorldManagerSingletonComponent>().FirstOrDefault();
		if ( singleton.IsValid() )
			return singleton.GetHeight( worldX, worldY );

		return Volume.Transform.World.Position.z - Volume.Size.z * 0.5f;
	}

	Vector3 ResolveListenerPosition()
	{
		if ( IsEditMode )
		{
			var editorCamera = Scene.Camera;
			if ( editorCamera.IsValid() )
				return editorCamera.WorldPosition;
		}

		EnsureVolumeManager();
		if ( _volumeManager.IsValid() )
			return _volumeManager.GetPlayerPosition();

		var camera = Scene.Camera;
		if ( camera.IsValid() )
			return camera.WorldPosition;

		return Volume.Transform.World.Position;
	}

	void EnsureVolumeManager()
	{
		if ( _volumeManager.IsValid() )
			return;

		_volumeManager = Scene.GetAllComponents<WeatherVolumeManagerComponent>().FirstOrDefault();
	}

	void EnsureEffect()
	{
		if ( _effect.IsValid() )
			return;

		CloudSprite ??= ResourceLibrary.Get<Sprite>( "sprites/cloud_mist.sprite" );
		_effect = WorldCloudEffect.Create( GameObject, CloudSprite );
	}

	void EnsureGroundShadow()
	{
		if ( _groundShadow.IsValid() )
			return;

		_groundShadow = WorldCloudGroundShadow.Create( GameObject );
	}
}
