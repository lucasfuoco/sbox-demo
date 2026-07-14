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

	[Property, Group( "Rain" )]
	public SoundEvent Rain { get; set; }

	[Property, Group( "Rain" ), Range( 0f, 1f )]
	public float MaxRainVolume { get; set; } = 0.55f;

	[Property, Group( "Thunder" )]
	public SoundEvent Thunder { get; set; }

	[Property, Group( "Thunder" ), Range( 0f, 1f )]
	public float MaxThunderVolume { get; set; } = 0.7f;

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

	protected override void OnStart()
	{
		EnsureReferences();
		ScheduleThunder();
	}

	protected override void OnUpdate()
	{
		EnsureReferences();
		_timeSeconds += Time.Delta;

		var listenerPosition = FollowCamera.IsValid() ? FollowCamera.WorldPosition : WorldPosition;
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
		};
		var volumes = new WorldAmbientVolumeSet
		{
			Wind = MaxWindVolume,
			Crickets = MaxCricketsVolume,
			Owls = MaxOwlsVolume,
			Frogs = MaxFrogsVolume,
			Leaves = MaxLeavesVolume,
			Water = MaxWaterVolume,
			Rain = MaxRainVolume,
		};

		_field.Update( listenerPosition, Terrain, conditions, sounds, volumes, windSounds );
		UpdateDirectionalWindBed( listenerPosition, conditions );
		TryThunder( conditions, listenerPosition );
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

	WeatherSample? ResolveLocalWeather()
	{
		if ( VolumeManager.IsValid() )
			return VolumeManager.GetPlayerWeather();

		return null;
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
			_directionalWindHandle = Sound.Play( sound );
			_directionalWindSound = sound;
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

	void TryThunder( WorldAmbientConditions conditions, Vector3 listenerPosition )
	{
		if ( Thunder is null || MaxThunderVolume <= 0.01f )
			return;

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

		if ( Sound.Play( Thunder, thunderPosition ) is { } handle )
		{
			var muffle = WeatherAudio.IsValid() ? 1f - WeatherAudio.AudioMuffleAmount * 0.35f : 1f;
			handle.Volume = MaxThunderVolume * MathF.Max( conditions.ThunderChance, stormAmount ) * intensity * muffle;
			handle.Pitch = Game.Random.Float( 0.9f, 1.05f );
		}

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
