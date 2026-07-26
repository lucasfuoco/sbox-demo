namespace Sandbox.Components;

using Sandbox.Components.SingletonComponents;

public enum WeatherRainPlacement
{
	/// <summary>Single rain shaft that follows the camera under the cloud footprint.</summary>
	FollowCamera = 0,
	/// <summary>One rain emitter that fills the whole cloud volume footprint.</summary>
	FillVolume = 1,
	/// <summary>Legacy name for <see cref="FillVolume"/>.</summary>
	FixedCells = FillVolume,
}

/// <summary>
/// Rain under rain/storm cloud volumes.
/// Defaults to one emitter filling the cloud footprint.
/// </summary>
[Title( "Weather Volume Rain" ), Category( "World Simulation" ), Icon( "umbrella" )]
public sealed class WeatherVolumeRainComponent : Component, Component.ExecuteInEditor
{
	const float CloudBandFraction = 0.06f;
	const float CloudBandMaxHeight = 6000f;

	[RequireComponent]
	public WeatherVolumeComponent Volume { get; private set; }

	[Property, Group( "Rain" ), Title( "Enable Rain" )]
	public bool EnableRain { get; set; } = true;

	[Property, Group( "Rain" ), Title( "Editor Preview" )]
	public bool EditorPreview { get; set; } = true;

	[Property, Group( "Rain" ), Title( "Strength" ), Description( "None = follow weather rain amount. Light / Medium / Strong set a fixed particle intensity (audio comes from World Ambient Audio)." )]
	public WeatherRainStrength Strength { get; set; } = WeatherRainStrength.None;

	[Property, Group( "Rain" ), Title( "Rain Intensity" ), Description( "Extra multiplier on top of Strength." ), Range( 0.1f, 2f )]
	public float RainIntensity { get; set; } = 1f;

	[Property, Group( "Rain" ), Title( "Placement" ), Description( "Fill Volume = one emitter covering the cloud. Follow Camera = shaft that tracks the player." )]
	public WeatherRainPlacement Placement { get; set; } = WeatherRainPlacement.FillVolume;

	[Property, Group( "Rain" ), Title( "Column Width" ), Description( "Width of the follow-camera rain shaft." ), Range( 800f, 24000f )]
	public float ColumnWidth { get; set; } = 14000f;

	[Property, Group( "Rain" ), Title( "Visible Height" ), Description( "Fallback column height when terrain cannot be sampled. Fill Volume otherwise stretches from the cloud deck to the ground." ), Range( 1200f, 80000f )]
	public float VisibleHeight { get; set; } = 20000f;

	[Property, Group( "Rain" ), Title( "Always Preview Under Volume" )]
	public bool AlwaysPreviewUnderVolume { get; set; } = true;

	[Property, Group( "Physics" ), Title( "Collide With World" ), Description( "Rain disappears on terrain, water, and roofs via a cheap height grid (no per-drop physics)." )]
	public bool CollideWithWorld { get; set; } = true;

	[Property, Group( "Physics" ), Title( "Block Indoors" ), Description( "Disables rain when a ceiling is detected above the camera." )]
	public bool BlockIndoors { get; set; } = true;

	[Property, Group( "Physics" ), Title( "Shelter Trace Distance" )]
	public float ShelterTraceDistance { get; set; } = 4500f;

	[Property, Group( "Ground" ), Title( "Enable Splashes" )]
	public bool EnableSplashes { get; set; } = true;

	[Property, Group( "Ground" ), Title( "Splash Radius" )]
	public float SplashRadius { get; set; } = 4200f;

	[Property, Group( "Ground" ), Title( "Enable Impact Audio" )]
	public bool EnableImpactAudio { get; set; } = true;

	[Property, Group( "Ground" ), Title( "Impact Audio Volume" ), Range( 0f, 1f ), Description( "Primary rain audio — spatters when rain hits the ground." )]
	public float ImpactAudioVolume { get; set; } = 0.2f;

	WorldPrecipitationEffect _rain;

	WorldRainGroundEffect _ground;
	WeatherVolumeManagerComponent _volumeManager;
	WorldManagerSingletonComponent _terrain;
	TimeSince _sinceShelterCheck;
	bool _sheltered;
	float _shelterBlend;
	bool _legacyEffectsPurged;

	bool IsEditMode => Game.IsEditor && !Game.IsPlaying;

	bool SupportsRain => Volume.IsValid() && Volume.VolumeType is WeatherVolumeType.RainCloud or WeatherVolumeType.StormCloud;

	bool ShouldPreview => EnableRain && SupportsRain && Enabled && (Game.IsPlaying || (IsEditMode && EditorPreview));

	bool UsesFillVolume => Placement == WeatherRainPlacement.FillVolume
		|| Volume.VolumeType is WeatherVolumeType.StormCloud or WeatherVolumeType.RainCloud;

	protected override void OnAwake() => Tick();

	protected override void OnStart() => Tick();

	protected override void OnValidate() => Tick();

	protected override void OnUpdate() => Tick();

	protected override void OnDestroy()
	{
		DestroyRain();
		if ( _ground.IsValid() )
			_ground.Root.Destroy();

		_ground = null;
	}

	void Tick()
	{
		if ( !_legacyEffectsPurged )
		{
			PurgeLegacyEffectChildren();
			_legacyEffectsPurged = true;
		}

		if ( !ShouldPreview )
		{
			DisableEffects();
			return;
		}

		EnsureRain();
		EnsureGround();

		var listener = ResolveListenerPosition();
		var blend = GetHorizontalBlend( listener );
		var previewOutside = IsEditMode && AlwaysPreviewUnderVolume && blend <= 0.01f;
		var insideVolume = blend > 0.01f || previewOutside;

		if ( !insideVolume )
		{
			DisableEffects();
			return;
		}

		if ( !previewOutside && !IsDominantRainVolume( listener, blend ) )
		{
			DisableEffects();
			return;
		}

		UpdateShelter( listener, previewOutside );
		var outdoor = 1f - _shelterBlend;
		var sample = Volume.GetWeatherSample();
		var strength = ResolveStrength( sample );
		var volumeBlend = MathX.Clamp( blend <= 0f ? 1f : blend, 0.35f, 1f );
		var amount = ResolveAmount( sample, strength ) * MathF.Max( outdoor, 0.15f ) * volumeBlend;
		var windDirection = sample.WindDirection;
		var windStrength = sample.WindStrength;

		var world = WorldManagerComponent.Instance;
		if ( world.IsValid() && world.Weather.IsValid() )
		{
			windDirection = world.Weather.WindDirection;
			windStrength = MathF.Max( windStrength, world.Weather.WindStrength );
		}

		// Visuals mute under shelter; World Ambient Audio keeps the rain bed while inside the volume.
		if ( outdoor <= 0.02f )
		{
			DisableEffects();
			return;
		}

		if ( !_rain.IsValid() )
			return;

		if ( UsesFillVolume )
			UpdateFillVolume( listener, previewOutside, amount, windDirection, windStrength );
		else
			UpdateFollowCamera( listener, previewOutside, amount, windDirection, windStrength );

		if ( _ground.IsValid() )
		{
			_ground.Update(
				listener,
				amount,
				SplashRadius,
				enableSplashes: EnableSplashes && !previewOutside && outdoor > 0.2f,
				enableAudio: EnableImpactAudio && Game.IsPlaying && outdoor > 0.2f,
				audioVolume: ImpactAudioVolume * outdoor * WeatherRainStrengthUtil.ToAudioVolume( strength ) );
		}
	}

	/// <summary>
	/// Sample used by <see cref="WorldAmbientAudioComponent"/> so rain audio can follow the player
	/// until they leave this volume footprint.
	/// </summary>
	public bool TrySampleListenerAudio( Vector3 listener, out WeatherRainStrength strength, out float blend, out float outdoor )
	{
		strength = WeatherRainStrength.None;
		blend = 0f;
		outdoor = 1f;

		// Audio should keep working even when particle preview is off.
		if ( !EnableRain || !Enabled || !SupportsRain || !Volume.IsValid() )
			return false;

		blend = GetHorizontalBlend( listener );
		if ( blend <= 0.01f )
			return false;

		UpdateShelter( listener, previewOutside: false );
		outdoor = MathF.Max( 1f - _shelterBlend, 0.35f );
		strength = ResolveStrength( Volume.GetWeatherSample() );
		if ( strength == WeatherRainStrength.None )
			strength = Volume.VolumeType == WeatherVolumeType.StormCloud
				? WeatherRainStrength.Strong
				: WeatherRainStrength.Medium;

		blend = MathX.Clamp( blend, 0.35f, 1f );
		return true;
	}

	void UpdateFollowCamera(
		Vector3 listener,
		bool previewOutside,
		float amount,
		Vector3 windDirection,
		float windStrength )
	{
		_ = previewOutside;
		GetRainColumn( listener, useVolumeCenter: false, followListener: true, fillVolume: false, out var spawnCenter, out var emitterSize );
		UpdateSlot( spawnCenter, emitterSize, amount, windDirection, windStrength, listener );
	}

	void UpdateFillVolume(
		Vector3 listener,
		bool previewOutside,
		float amount,
		Vector3 windDirection,
		float windStrength )
	{
		_ = previewOutside;

		// Dense shaft under the listener from cloud deck → ground.
		// A single box over the full cloud footprint is too sparse to see.
		GetRainColumn(
			listener,
			useVolumeCenter: false,
			followListener: true,
			fillVolume: true,
			out var spawnCenter,
			out var emitterSize );
		UpdateSlot( spawnCenter, emitterSize, amount, windDirection, windStrength, listener );
	}

	void UpdateSlot(
		Vector3 spawnCenter,
		Vector3 emitterSize,
		float amount,
		Vector3 windDirection,
		float windStrength,
		Vector3 listener )
	{
		if ( !_rain.IsValid() )
			return;

		var fallSpeed = MathX.Lerp( 1800f, 3200f, MathX.Clamp( amount, 0f, 1f ) );
		var lifetime = MathX.Clamp( emitterSize.z / fallSpeed, 0.75f, 18f );
		_rain.SetEmitterSize( emitterSize );
		_rain.Update(
			spawnCenter,
			amount,
			windDirection,
			windStrength,
			temperature: 12f,
			lifetimeSeconds: lifetime,
			fallSpeedOverride: fallSpeed,
			enableCollision: CollideWithWorld && !IsEditMode,
			rateMultiplier: 1f,
			clipListener: listener );
	}

	void DisableEffects()
	{
		if ( _rain.IsValid() )
			_rain.Root.Enabled = false;

		if ( _ground.IsValid() )
			_ground.Root.Enabled = false;
	}

	void UpdateShelter( Vector3 listener, bool previewOutside )
	{
		if ( !BlockIndoors || previewOutside || IsEditMode )
		{
			_sheltered = false;
			_shelterBlend = _shelterBlend.LerpTo( 0f, 1f - MathF.Exp( -Time.Delta * 8f ) );
			return;
		}

		if ( _sinceShelterCheck > 0.12f )
		{
			_sinceShelterCheck = 0f;
			_sheltered = TraceSheltered( listener );
		}

		_shelterBlend = _shelterBlend.LerpTo( _sheltered ? 1f : 0f, 1f - MathF.Exp( -Time.Delta * 6f ) );
	}

	bool TraceSheltered( Vector3 listener )
	{
		var eye = listener + Vector3.Up * 72f;
		var tr = Scene.Trace.Ray( eye, eye + Vector3.Up * MathF.Max( ShelterTraceDistance, 500f ) )
			.WithoutTags( "trigger", "player", "ragdoll", "particles", "water", "weather_volume" )
			.IgnoreGameObjectHierarchy( GameObject )
			.Run();

		if ( !tr.Hit )
			return false;

		return tr.Normal.z < 0.25f || tr.Distance < ShelterTraceDistance * 0.98f;
	}

	void GetRainColumn(
		Vector3 listener,
		bool useVolumeCenter,
		bool followListener,
		bool fillVolume,
		out Vector3 spawnCenter,
		out Vector3 emitterSize )
	{
		var world = Volume.Transform.World;
		var half = Volume.Size * 0.5f;
		var bandHeight = MathF.Max( Volume.Size.z * CloudBandFraction, 512f );
		bandHeight = MathF.Min( bandHeight, MathF.Min( Volume.Size.z, CloudBandMaxHeight ) );

		// Cloud deck = top band of the volume (same band the cloud sprites use).
		var cloudUndersideLocalZ = half.z - bandHeight;
		var cloudUndersideZ = (world.Position + world.Rotation * new Vector3( 0f, 0f, cloudUndersideLocalZ )).z;

		Vector3 columnXy;
		if ( followListener || fillVolume )
		{
			var local = world.PointToLocal( listener );
			local.x = MathX.Clamp( local.x, -half.x * 0.95f, half.x * 0.95f );
			local.y = MathX.Clamp( local.y, -half.y * 0.95f, half.y * 0.95f );
			local.z = 0f;
			columnXy = world.PointToWorld( local );
		}
		else if ( useVolumeCenter )
		{
			columnXy = world.Position;
		}
		else
		{
			columnXy = world.Position;
		}

		// Always span cloud underside → terrain under the column.
		var topZ = cloudUndersideZ;
		var bottomZ = ResolveGroundZ( columnXy.x, columnXy.y, topZ - MathF.Max( VisibleHeight, 1600f ) );
		if ( topZ - bottomZ < 1600f )
			bottomZ = topZ - 1600f;

		// Keep the shaft from ending above the camera when terrain is missing.
		bottomZ = MathF.Min( bottomZ, listener.z - 120f );

		var height = MathF.Max( topZ - bottomZ, 1200f );
		spawnCenter = new Vector3( columnXy.x, columnXy.y, bottomZ + height * 0.5f );

		var width = fillVolume
			? MathF.Max( ColumnWidth, Volume.VolumeType == WeatherVolumeType.StormCloud ? 16000f : 14000f )
			: ColumnWidth;
		emitterSize = new Vector3( width, width, height );
	}

	float ResolveGroundZ( float worldX, float worldY, float fallbackZ )
	{
		EnsureTerrain();
		if ( _terrain.IsValid() )
			return _terrain.GetHeight( worldX, worldY ) - 24f;

		return fallbackZ;
	}

	void EnsureTerrain()
	{
		if ( _terrain.IsValid() )
			return;

		var world = WorldManagerComponent.Instance;
		if ( world.IsValid() )
		{
			_terrain = world.GameObject.Components.Get<WorldManagerSingletonComponent>();
			if ( _terrain.IsValid() )
				return;
		}

		_terrain = Scene?.GetAllComponents<WorldManagerSingletonComponent>().FirstOrDefault();
	}

	float GetHorizontalBlend( Vector3 worldPosition )
	{
		var local = Volume.Transform.World.PointToLocal( worldPosition );
		var half = Volume.Size * 0.5f;
		var blendDistance = MathF.Max( Volume.BlendDistance, 20000f );

		var blendX = AxisBlend( MathF.Abs( local.x ), half.x, blendDistance );
		var blendY = AxisBlend( MathF.Abs( local.y ), half.y, blendDistance );
		return MathF.Min( blendX, blendY );
	}

	bool IsDominantRainVolume( Vector3 listener, float myBlend )
	{
		foreach ( var other in Scene.GetAllComponents<WeatherVolumeRainComponent>() )
		{
			if ( !other.IsValid() || other == this || !other.ShouldPreview )
				continue;

			var otherBlend = other.GetHorizontalBlend( listener );
			if ( otherBlend <= 0.02f )
				continue;

			// Storm shafts win over plain rain clouds when both overlap.
			if ( Volume.VolumeType == WeatherVolumeType.RainCloud
				&& other.Volume.IsValid()
				&& other.Volume.VolumeType == WeatherVolumeType.StormCloud
				&& otherBlend > 0.05f )
				return false;

			if ( Volume.VolumeType == WeatherVolumeType.StormCloud
				&& other.Volume.IsValid()
				&& other.Volume.VolumeType == WeatherVolumeType.RainCloud )
				continue;

			if ( otherBlend > myBlend + 0.02f )
				return false;

			if ( MathF.Abs( otherBlend - myBlend ) <= 0.02f
				&& other.GameObject.Id.CompareTo( GameObject.Id ) < 0 )
				return false;
		}

		return true;
	}

	static float AxisBlend( float distance, float halfExtent, float blendDistance )
	{
		if ( distance <= halfExtent - blendDistance )
			return 1f;

		if ( distance >= halfExtent )
			return 0f;

		return 1f - (distance - (halfExtent - blendDistance)) / blendDistance;
	}

	WeatherRainStrength ResolveStrength( WeatherSample sample )
	{
		if ( Strength is WeatherRainStrength.Light or WeatherRainStrength.Medium or WeatherRainStrength.Strong )
			return Strength;

		if ( Volume.VolumeType == WeatherVolumeType.StormCloud )
			return WeatherRainStrength.Strong;

		return WeatherRainStrengthUtil.FromAmount( sample.RainAmount );
	}

	float ResolveAmount( WeatherSample sample, WeatherRainStrength strength )
	{
		var baseAmount = WeatherRainStrengthUtil.ToAmount( strength );
		var fromSample = MathX.Clamp( sample.RainAmount, 0f, 1.5f );
		var amount = MathF.Max( baseAmount, fromSample ) * WeatherRainStrengthUtil.ToVisualMultiplier( strength );
		return MathX.Clamp( amount * RainIntensity, 0.2f, 1.75f );
	}

	void EnsureRain()
	{
		if ( _rain.IsValid() )
			return;

		// Clear leftover multi-cell emitters from older versions.
		foreach ( var child in GameObject.Children.ToArray() )
		{
			if ( !child.IsValid() )
				continue;

			var name = child.Name ?? string.Empty;
			if ( name.StartsWith( "RainCell_", StringComparison.OrdinalIgnoreCase )
				|| name.Equals( "RainVolume", StringComparison.OrdinalIgnoreCase ) )
			{
				child.Destroy();
			}
		}

		_rain = WorldPrecipitationEffect.Create( GameObject, snow: false, name: "RainVolume" );
	}

	void DestroyRain()
	{
		if ( _rain.IsValid() )
			_rain.Root.Destroy();

		_rain = null;
	}

	void PurgeLegacyEffectChildren()
	{
		if ( !GameObject.IsValid() )
			return;

		// Always clear curtain leftovers so hotloads don't leave sheets behind.
		foreach ( var child in GameObject.Children.ToArray() )
			DestroyLegacyEffectSubtree( child );
	}

	static void DestroyLegacyEffectSubtree( GameObject go )
	{
		if ( !go.IsValid() )
			return;

		foreach ( var child in go.Children.ToArray() )
			DestroyLegacyEffectSubtree( child );

		var name = go.Name ?? string.Empty;
		if ( name.StartsWith( "RainDistCurtain", StringComparison.OrdinalIgnoreCase )
			|| name.StartsWith( "RainCurtain", StringComparison.OrdinalIgnoreCase )
			|| name.StartsWith( "RainDistant", StringComparison.OrdinalIgnoreCase )
			|| name.StartsWith( "RainFogCell", StringComparison.OrdinalIgnoreCase )
			|| name.StartsWith( "RainCellFog", StringComparison.OrdinalIgnoreCase )
			|| name.StartsWith( "RainVolumetricFog", StringComparison.OrdinalIgnoreCase ) )
		{
			go.Destroy();
			return;
		}

		if ( go.Components.Get<VolumetricFogVolume>().IsValid() )
		{
			go.Destroy();
			return;
		}

		var sprite = go.Components.Get<SpriteRenderer>();
		if ( !sprite.IsValid() || !sprite.Sprite.IsValid() )
			return;

		var resourcePath = sprite.Sprite.ResourcePath ?? string.Empty;
		if ( resourcePath.Contains( "rain_curtain", StringComparison.OrdinalIgnoreCase ) )
			go.Destroy();
	}

	void EnsureGround()
	{
		if ( _ground.IsValid() )
			return;

		if ( !EnableSplashes && !EnableImpactAudio )
			return;

		_ground = WorldRainGroundEffect.Create( GameObject, Scene );
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
}
