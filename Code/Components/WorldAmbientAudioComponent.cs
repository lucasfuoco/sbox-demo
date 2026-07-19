using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

/// <summary>
/// Terrain-placed ambient layers — wind on open ground, leaves in grass, rain, water on lakes.
/// </summary>
[Title( "World Ambient Audio" ), Category( "World Simulation" )]
public sealed class WorldAmbientAudioComponent : Component
{
	[RequireComponent]
	public WorldManagerComponent World { get; private set; }

	[Property, Group( "Setup" )]
	public WeatherVolumeManagerComponent VolumeManager { get; set; }

	[Property, Group( "Setup" )]
	public WeatherAudioControllerComponent WeatherAudio { get; set; }

	[Property, Group( "Setup" )]
	public CameraComponent FollowCamera { get; set; }

	[Property, Group( "Setup" ), Title( "Terrain" )]
	public WorldManagerSingletonComponent Terrain { get; set; }

	[Property, Group( "Wind" )]
	public SoundEvent Wind { get; set; }

	[Property, Group( "Wind" ), Title( "Sand Wind" ), Description( "Wind loop for beaches and deserts. Uses Wind when unset." )]
	public SoundEvent SandWind { get; set; }

	[Property, Group( "Wind" ), Title( "Grass Wind" ), Description( "Wind loop for open meadows. Uses Wind when unset." )]
	public SoundEvent GrassWind { get; set; }

	[Property, Group( "Wind" ), Title( "Forest Wind" ), Description( "Wind loop for wooded areas. Uses Grass Wind, then Wind when unset." )]
	public SoundEvent ForestWind { get; set; }

	[Property, Group( "Wind" ), Title( "Mountain Wind" ), Description( "Wind loop for peaks and exposed rock. Uses Wind when unset." )]
	public SoundEvent MountainWind { get; set; }

	[Property, Group( "Wind" ), Range( 0f, 1f )]
	public float MaxWindVolume { get; set; } = 0.45f;

	[Property, Group( "Wind" ), Title( "Directional Wind Bed" ), Description( "Plays a looping wind source upwind of the listener for clear left/right direction." )]
	public bool EnableDirectionalWindBed { get; set; } = true;

	[Property, Group( "Wind" ), Title( "Directional Wind Sound" ), Description( "Uses Wind when unset." )]
	public SoundEvent DirectionalWind { get; set; }

	[Property, Group( "Wind" ), Title( "Directional Distance" ), Range( 500f, 8000f )]
	public float DirectionalWindDistance { get; set; } = 2800f;

	[Property, Group( "Wind" ), Title( "Directional Height" ), Range( 50f, 2000f )]
	public float DirectionalWindHeight { get; set; } = 450f;

	[Property, Group( "Wind" ), Title( "Directional Volume" ), Range( 0f, 1f )]
	public float DirectionalWindVolume { get; set; } = 0.4f;

	[Property, Group( "Crickets" )]
	public SoundEvent Crickets { get; set; }

	[Property, Group( "Crickets" ), Range( 0f, 1f )]
	public float MaxCricketsVolume { get; set; } = 0.3f;

	[Property, Group( "Owls" )]
	public SoundEvent Owls { get; set; }

	[Property, Group( "Owls" ), Range( 0f, 1f )]
	public float MaxOwlsVolume { get; set; } = 0.22f;

	[Property, Group( "Frogs" )]
	public SoundEvent Frogs { get; set; }

	[Property, Group( "Frogs" ), Range( 0f, 1f )]
	public float MaxFrogsVolume { get; set; } = 0.28f;

	[Property, Group( "Leaves" )]
	public SoundEvent Leaves { get; set; }

	[Property, Group( "Leaves" ), Range( 0f, 1f )]
	public float MaxLeavesVolume { get; set; } = 0.32f;

	[Property, Group( "Water" )]
	public SoundEvent Water { get; set; }

	[Property, Group( "Water" ), Range( 0f, 1f )]
	public float MaxWaterVolume { get; set; } = 0.35f;

	[Property, Group( "Rain" ), Title( "Light Rain" ), Description( "Player-following rain bed while under light rain." )]
	public SoundEvent LightRain { get; set; }

	[Property, Group( "Rain" ), Title( "Medium Rain" ), Description( "Player-following rain bed while under medium rain." )]
	public SoundEvent MediumRain { get; set; }

	[Property, Group( "Rain" ), Title( "Strong Rain" ), Description( "Player-following rain bed while under strong rain / storms." )]
	public SoundEvent StrongRain { get; set; }

	[Property, Group( "Rain" ), Title( "Rain (Fallback)" ), Description( "Used when a strength-specific sound is unset." )]
	public SoundEvent Rain { get; set; }

	[Property, Group( "Rain" ), Range( 0f, 1f )]
	public float MaxRainVolume { get; set; } = 0.7f;

	[Property, Group( "Thunder" )]
	public SoundEvent Thunder { get; set; }

	[Property, Group( "Thunder" ), Range( 0f, 1f )]
	public float MaxThunderVolume { get; set; } = 0.95f;

	[Property, Group( "Thunder" ), Title( "Min Interval (seconds)" ), Range( 5f, 120f )]
	public float ThunderMinInterval { get; set; } = 12f;

	[Property, Group( "Thunder" ), Title( "Max Interval (seconds)" ), Range( 5f, 180f )]
	public float ThunderMaxInterval { get; set; } = 45f;

	readonly WorldAmbientSpatialField _field = new();
	float _timeSeconds;
	float _nextThunderDelay;
	RealTimeSince _sinceThunder;
	SoundHandle _directionalWindHandle;
	SoundEvent _directionalWindSound;
	SoundHandle _rainBedHandle;
	string _rainBedSoundPath;
	float _rainBedVolume;
	float _rainBedHold;
	WeatherRainStrength _rainBedStrength = WeatherRainStrength.Medium;
	bool _rainSoundsResolved;
	readonly HashSet<int> _heardLightningFlashIds = new();

	protected override void OnStart()
	{
		EnsureReferences();
		EnsureDefaultRainSounds();
		EnsureDefaultThunderSound();
		ScheduleThunder();
	}

	protected override void OnDestroy()
	{
		StopRainBed();
		SilenceDirectionalWind();
	}

	protected override void OnUpdate()
	{
		EnsureReferences();
		if ( !World.IsValid() )
			return;

		EnsureDefaultRainSounds();
		EnsureDefaultThunderSound();
		_timeSeconds += Time.Delta;

		var listenerPosition = ResolveListenerPosition();
		var localWeather = ResolveLocalWeather();
		var conditions = WorldAmbientConditions.FromWorld( World, _timeSeconds, localWeather );
		var windSounds = GetWindSounds();
		var sounds = new WorldAmbientSoundSet
		{
			Wind = Wind,
			Crickets = Crickets,
			Owls = Owls,
			Frogs = Frogs,
			Leaves = Leaves,
			Water = Water,
			Rain = Rain,
			LightRain = LightRain,
			MediumRain = MediumRain,
			StrongRain = StrongRain,
		};

		// Rain bed follows the player (volume or global). Spatial rain field stays off to avoid doubling.
		var rainBedActive = UpdateRainBed( listenerPosition, conditions );
		var volumes = new WorldAmbientVolumeSet
		{
			Wind = MaxWindVolume,
			Crickets = MaxCricketsVolume,
			Owls = MaxOwlsVolume,
			Frogs = MaxFrogsVolume,
			Leaves = MaxLeavesVolume,
			Water = MaxWaterVolume,
			Rain = rainBedActive ? 0f : MaxRainVolume,
		};

		_field.Update( listenerPosition, Terrain, conditions, sounds, volumes, windSounds );
		UpdateDirectionalWindBed( listenerPosition, conditions );
		PlayLightningStrikeThunder( listenerPosition, conditions );
	}

	void EnsureReferences()
	{
		World ??= WorldManagerComponent.Instance;
		World ??= Components.Get<WorldManagerComponent>();

		VolumeManager ??= Components.Get<WeatherVolumeManagerComponent>();
		VolumeManager ??= Scene.GetAllComponents<WeatherVolumeManagerComponent>().FirstOrDefault();

		WeatherAudio ??= Components.Get<WeatherAudioControllerComponent>();
		WeatherAudio ??= Scene.GetAllComponents<WeatherAudioControllerComponent>().FirstOrDefault();

		Terrain ??= WorldManagerSingletonComponent.Instance;
		Terrain ??= Components.Get<WorldManagerSingletonComponent>();

		if ( FollowCamera.IsValid() )
			return;

		FollowCamera = Scene.Camera;
	}

	void EnsureDefaultRainSounds()
	{
		if ( _rainSoundsResolved )
			return;

		// Local beds: no distance/occlusion so the loop stays glued to the player.
		LightRain ??= ResourceLibrary.Get<SoundEvent>( "sound/ambient/rain_light_bed.sound" )
			?? ResourceLibrary.Get<SoundEvent>( "sound/ambient/rain_light.sound" );
		MediumRain ??= ResourceLibrary.Get<SoundEvent>( "sound/ambient/rain_medium_bed.sound" )
			?? ResourceLibrary.Get<SoundEvent>( "sound/ambient/rain_medium.sound" );
		StrongRain ??= ResourceLibrary.Get<SoundEvent>( "sound/ambient/rain_strong_bed.sound" )
			?? ResourceLibrary.Get<SoundEvent>( "sound/ambient/rain_strong.sound" );
		Rain ??= MediumRain ?? LightRain ?? StrongRain;
		_rainSoundsResolved = LightRain is not null || MediumRain is not null || StrongRain is not null || Rain is not null;
	}

	Vector3 ResolveListenerPosition()
	{
		// Match weather volumes / rain splashes — follow the player, not a detached editor camera.
		if ( VolumeManager.IsValid() )
		{
			var player = VolumeManager.GetPlayerPosition();
			if ( player.LengthSquared > 0.01f || VolumeManager.FollowCamera.IsValid() )
				return player;
		}

		if ( FollowCamera.IsValid() )
			return FollowCamera.WorldPosition;

		if ( Scene.Camera.IsValid() )
			return Scene.Camera.WorldPosition;

		return WorldPosition;
	}

	WeatherSample? ResolveLocalWeather()
	{
		if ( VolumeManager.IsValid() )
			return VolumeManager.GetPlayerWeather();

		return null;
	}

	bool UpdateRainBed( Vector3 listenerPosition, WorldAmbientConditions conditions )
	{
		if ( MaxRainVolume <= 0.01f )
		{
			StopRainBed();
			return false;
		}

		var strength = WeatherRainStrength.None;
		var blend = 0f;
		var outdoor = 1f;
		var fromVolume = TrySampleVolumeRain( listenerPosition, out strength, out blend, out outdoor );

		if ( !fromVolume )
		{
			strength = WeatherRainStrengthUtil.FromAmount( conditions.Rain );
			blend = conditions.Rain > 0.08f ? MathX.Clamp( conditions.Rain, 0.35f, 1f ) : 0f;
			outdoor = 1f - conditions.AudioMuffleAmount;
		}

		var raining = strength != WeatherRainStrength.None && blend > 0.02f;
		if ( raining )
		{
			_rainBedHold = 1.25f;
			_rainBedStrength = strength;
		}
		else
		{
			_rainBedHold = MathF.Max( 0f, _rainBedHold - Time.Delta );
			if ( _rainBedHold <= 0f )
			{
				StopRainBed();
				return false;
			}

			// Keep the last bed while briefly leaving the footprint / shelter flicker.
			strength = _rainBedStrength;
			blend = MathF.Max( blend, 0.45f );
			outdoor = MathF.Max( outdoor, 0.5f );
		}

		var sound = ResolveRainSound( strength );
		if ( sound is null )
		{
			StopRainBed();
			return false;
		}

		var targetVolume = MathX.Clamp(
			MaxRainVolume
			* WeatherRainStrengthUtil.ToAudioVolume( strength )
			* blend
			* MathX.Lerp( 0.45f, 1f, outdoor ),
			0.12f,
			1f );

		_rainBedVolume = _rainBedVolume.LerpTo( targetVolume, 1f - MathF.Exp( -Time.Delta * 6f ) );

		var soundPosition = listenerPosition + Vector3.Up * 64f;
		var soundPath = sound.ResourcePath ?? string.Empty;
		var needsNewHandle = !_rainBedHandle.IsValid()
			|| _rainBedHandle.Finished
			|| !string.Equals( _rainBedSoundPath, soundPath, StringComparison.OrdinalIgnoreCase );

		if ( needsNewHandle )
		{
			// Don't Stop() first — that causes audible gaps while moving.
			_rainBedHandle = Sound.Play( sound, soundPosition );
			_rainBedSoundPath = soundPath;
		}

		if ( !_rainBedHandle.IsValid() )
		{
			_rainBedSoundPath = null;
			return _rainBedHold > 0f;
		}

		_rainBedHandle.Position = soundPosition;
		_rainBedHandle.Volume = _rainBedVolume;
		_rainBedHandle.Pitch = strength switch
		{
			WeatherRainStrength.Light => 1.04f,
			WeatherRainStrength.Strong => 0.94f,
			_ => 1f,
		};

		return true;
	}

	bool TrySampleVolumeRain(
		Vector3 listenerPosition,
		out WeatherRainStrength strength,
		out float blend,
		out float outdoor )
	{
		strength = WeatherRainStrength.None;
		blend = 0f;
		outdoor = 1f;

		var bestBlend = 0f;
		var found = false;

		foreach ( var rain in Scene.GetAllComponents<WeatherVolumeRainComponent>() )
		{
			if ( !rain.IsValid() )
				continue;

			if ( !rain.TrySampleListenerAudio( listenerPosition, out var sampleStrength, out var sampleBlend, out var sampleOutdoor ) )
				continue;

			if ( sampleBlend < bestBlend )
				continue;

			bestBlend = sampleBlend;
			strength = sampleStrength;
			blend = sampleBlend;
			outdoor = sampleOutdoor;
			found = true;
		}

		return found;
	}

	SoundEvent ResolveRainSound( WeatherRainStrength strength ) => strength switch
	{
		WeatherRainStrength.Light => LightRain ?? MediumRain ?? Rain ?? StrongRain,
		WeatherRainStrength.Strong => StrongRain ?? MediumRain ?? Rain ?? LightRain,
		_ => MediumRain ?? Rain ?? LightRain ?? StrongRain,
	};

	void StopRainBed()
	{
		if ( _rainBedHandle.IsValid() )
		{
			_rainBedHandle.Volume = 0f;
			_rainBedHandle.Stop();
		}

		_rainBedHandle = default;
		_rainBedSoundPath = null;
		_rainBedVolume = 0f;
		_rainBedHold = 0f;
	}

	void UpdateDirectionalWindBed( Vector3 listenerPosition, WorldAmbientConditions conditions )
	{
		var windSounds = GetWindSounds();
		var sound = DirectionalWind ?? Wind;

		if ( Terrain.IsValid() )
		{
			var sample = WorldAmbientTerrainSample.Sample( Terrain, listenerPosition.x, listenerPosition.y );
			sound = DirectionalWind ?? windSounds.Resolve( sample, Wind );
		}

		if ( !EnableDirectionalWindBed || sound is null || DirectionalWindVolume <= 0.01f )
		{
			SilenceDirectionalWind();
			return;
		}

		if ( conditions.Wind <= 0.02f )
		{
			SilenceDirectionalWind();
			return;
		}

		var wind = conditions.WindDirection.WithZ( 0f );
		if ( wind.LengthSquared <= 0.0001f )
			wind = Vector3.Forward;
		else
			wind = wind.Normal;

		// Place the bed upwind so the 3D listener hears wind arriving from that side.
		var sourcePosition = listenerPosition - wind * DirectionalWindDistance + Vector3.Up * DirectionalWindHeight;

		if ( Terrain.IsValid() )
		{
			var groundHeight = Terrain.GetHeight( sourcePosition.x, sourcePosition.y );
			sourcePosition = sourcePosition.WithZ( MathF.Max( sourcePosition.z, groundHeight + DirectionalWindHeight * 0.35f ) );
		}

		if ( !_directionalWindHandle.IsValid()
			|| _directionalWindHandle.Finished
			|| _directionalWindSound != sound )
		{
			_directionalWindHandle = Sound.Play( sound, sourcePosition );
			_directionalWindSound = sound;
		}

		if ( !_directionalWindHandle.IsValid() )
		{
			SilenceDirectionalWind();
			return;
		}

		var muffle = 1f - conditions.AudioMuffleAmount * 0.35f;
		_directionalWindHandle.Position = sourcePosition;
		_directionalWindHandle.Volume = DirectionalWindVolume * conditions.Wind * muffle;
		_directionalWindHandle.Pitch = 0.85f + conditions.Wind * 0.3f;
	}

	void SilenceDirectionalWind()
	{
		if ( _directionalWindHandle.IsValid() )
			_directionalWindHandle.Volume = 0f;

		_directionalWindSound = null;
	}

	void EnsureDefaultThunderSound()
	{
		Thunder ??= ResourceLibrary.Get<SoundEvent>( "sound/ambient/thunder_strike.sound" );
	}

	/// <summary>
	/// Play thunder from World Ambient Audio when a storm-volume lightning flash starts.
	/// </summary>
	void PlayLightningStrikeThunder( Vector3 listenerPosition, WorldAmbientConditions conditions )
	{
		EnsureDefaultThunderSound();
		if ( Thunder is null || MaxThunderVolume <= 0.01f )
			return;

		var activeIds = new HashSet<int>();
		var played = false;

		foreach ( var lightning in Scene.GetAllComponents<WeatherVolumeLightningControllerComponent>() )
		{
			if ( !lightning.IsValid() || !lightning.Enabled )
				continue;

			foreach ( var flash in lightning.ActiveFlashes )
			{
				activeIds.Add( flash.Id );
				if ( !_heardLightningFlashIds.Add( flash.Id ) )
					continue;

				PlayThunderAt( flash.Position, flash.Intensity, listenerPosition );
				played = true;
			}
		}

		// Drop IDs for flashes that have ended so the set doesn't grow forever.
		_heardLightningFlashIds.RemoveWhere( id => !activeIds.Contains( id ) );

		// Fallback: ambient thunder when there's storm weather but no lightning controllers firing.
		if ( !played && activeIds.Count == 0 )
			TryAmbientThunderFallback( conditions, listenerPosition );
	}

	void PlayThunderAt( Vector3 strikePosition, float flashIntensity, Vector3 listenerPosition )
	{
		// Keep XY at the bolt so direction reads as the strike, but drop Z near the listener
		// so occlusion / huge vertical distance don't silence the event.
		var source = new Vector3(
			strikePosition.x,
			strikePosition.y,
			listenerPosition.z + 700f );
		source = Vector3.Lerp( source, listenerPosition + Vector3.Up * 350f, 0.12f );

		var planar = (source - listenerPosition).WithZ( 0f ).Length;
		var proximity = MathX.Clamp( 1f - planar / 14000f, 0.4f, 1f );
		var intensity = MathX.Clamp( flashIntensity, 0.45f, 1.35f );
		var volume = MathX.Clamp( MaxThunderVolume * intensity * proximity, 0.35f, 1f );

		var handle = Sound.Play( Thunder, source );
		if ( !handle.IsValid() )
			return;

		handle.Position = source;
		handle.Volume = volume;
		handle.Pitch = Game.Random.Float( 0.9f, 1.08f );
		_sinceThunder = 0;
	}

	void TryAmbientThunderFallback( WorldAmbientConditions conditions, Vector3 listenerPosition )
	{
		var stormAmount = conditions.StormAmount;
		if ( conditions.ThunderChance < 0.55f && stormAmount < 0.45f )
			return;

		if ( _sinceThunder < _nextThunderDelay )
			return;

		var rainAmount = WeatherAudio.IsValid() ? WeatherAudio.RainAmount : conditions.Rain;
		if ( rainAmount < 0.35f && stormAmount < 0.45f )
			return;

		var thunderOffset = Game.Random.Float( -2800f, 2800f );
		var thunderX = listenerPosition.x + thunderOffset;
		var thunderY = listenerPosition.y + Game.Random.Float( -2800f, 2800f );
		var intensity = MathX.Clamp( MathF.Max( rainAmount, stormAmount ), 0.35f, 1f );
		var terrainHeight = Terrain.IsValid() ? Terrain.GetHeight( thunderX, thunderY ) : listenerPosition.z;
		var thunderPosition = new Vector3( thunderX, thunderY, terrainHeight + 900f );

		PlayThunderAt( thunderPosition, intensity, listenerPosition );
		ScheduleThunder();
	}

	void ScheduleThunder()
	{
		var min = Math.Min( ThunderMinInterval, ThunderMaxInterval );
		var max = Math.Max( ThunderMinInterval, ThunderMaxInterval );
		_nextThunderDelay = Game.Random.Float( min, max );
		_sinceThunder = 0;
	}

	public WorldAmbientWindSoundSet GetWindSounds() => new()
	{
		Sand = SandWind,
		Grass = GrassWind,
		Forest = ForestWind,
		Mountain = MountainWind,
	};
}
