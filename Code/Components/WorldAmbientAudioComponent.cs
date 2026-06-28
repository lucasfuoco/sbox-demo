using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

/// <summary>
/// Terrain-placed ambient layers — wind on open ground, leaves in grass, rain under cloud patches, water on lakes.
/// </summary>
[Title( "World Ambient Audio" ), Category( "World Simulation" )]
public sealed class WorldAmbientAudioComponent : Component
{
	[RequireComponent]
	public WorldManagerComponent World { get; private set; }

	[Property, Group( "Setup" )]
	public CameraComponent FollowCamera { get; set; }

	[Property, Group( "Setup" ), Title( "Terrain" )]
	public WorldManagerSingletonComponent Terrain { get; set; }

	[Property, Group( "Wind" )]
	public SoundEvent Wind { get; set; }

	[Property, Group( "Wind" ), Range( 0f, 1f )]
	public float MaxWindVolume { get; set; } = 0.45f;

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
		var conditions = WorldAmbientConditions.FromWorld( World, _timeSeconds );
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

		_field.Update( listenerPosition, Terrain, conditions, sounds, volumes );
		TryThunder( conditions, listenerPosition );
	}

	void EnsureReferences()
	{
		World ??= WorldManagerComponent.Instance;
		World ??= Components.Get<WorldManagerComponent>();

		Terrain ??= WorldManagerSingletonComponent.Instance;
		Terrain ??= Components.Get<WorldManagerSingletonComponent>();

		if ( FollowCamera.IsValid() )
			return;

		FollowCamera = Scene.Camera;
	}

	void TryThunder( WorldAmbientConditions conditions, Vector3 listenerPosition )
	{
		if ( Thunder is null || MaxThunderVolume <= 0.01f )
			return;

		if ( conditions.ThunderChance < 0.55f || _sinceThunder < _nextThunderDelay )
			return;

		var cloudOffset = Game.Random.Float( -2800f, 2800f );
		var cloudX = listenerPosition.x + cloudOffset;
		var cloudY = listenerPosition.y + Game.Random.Float( -2800f, 2800f );
		var coverage = WorldAmbientCloudCoverage.Sample(
			cloudX,
			cloudY,
			conditions.TimeSeconds,
			conditions.WindDirection,
			conditions.CloudAmount );

		if ( coverage < 0.35f )
			return;

		var terrainHeight = Terrain.IsValid() ? Terrain.GetHeight( cloudX, cloudY ) : listenerPosition.z;
		var thunderPosition = new Vector3( cloudX, cloudY, terrainHeight + 900f );

		if ( Sound.Play( Thunder, thunderPosition ) is { } handle )
		{
			handle.Volume = MaxThunderVolume * conditions.ThunderChance * coverage;
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
}
