using Sandbox.Components;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

/// <summary>
/// Moves a <see cref="WeatherVolumeComponent"/> horizontally with global wind and wraps inside the map bounds.
/// </summary>
[Title( "Weather Volume Wind Drift" ), Category( "World Simulation" ), Icon( "air" )]
public sealed class WeatherVolumeWindDriftComponent : Component, Component.ExecuteInEditor
{
	const float MinDriftSpeed = 90f;
	const float MaxDriftSpeed = 420f;

	[RequireComponent]
	public WeatherVolumeComponent Volume { get; private set; }

	[Property, Group( "Drift" ), Title( "Enabled" )]
	public bool Enabled { get; set; } = true;

	[Property, Group( "Drift" ), Title( "Drift In Editor" ), Description( "Preview wind movement while editing the scene." )]
	public bool DriftInEditor { get; set; } = true;

	[Property, Group( "Drift" ), Title( "Speed Multiplier" ), Range( 0.1f, 4f )]
	public float SpeedMultiplier { get; set; } = 1f;

	[Property, Group( "Drift" ), Title( "Wrap In World Bounds" ), Description( "When enabled, the volume wraps inside the world manager bounds." )]
	public bool WrapInWorldBounds { get; set; } = true;

	[Property, Group( "Drift" ), Title( "Use Custom Wrap Region" )]
	public bool UseCustomWrapRegion { get; set; }

	[Property, Group( "Drift" ), Title( "Custom Wrap Region Size" ), Description( "Horizontal wrap region centered on this object's starting position." )]
	public Vector3 WrapRegionSize { get; set; } = new( 1000000f, 1000000f, 90000f );

	[Property, Group( "Drift" ), Title( "Wrap Region" ), Description( "Optional cloud layer controller used for wrapping / group lanes." )]
	public WeatherCloudLayerControllerComponent WrapRegion { get; set; }

	[Property, Group( "Lanes" ), Title( "Lane Offset" ), Description( "Perpendicular offset from the shared wind axis. Set by the cloud layer controller." )]
	public float LaneOffset { get; set; }

	[Property, Group( "Lanes" ), Title( "Phase Offset" ), Range( 0f, 1f ), Description( "Stagger along the wind axis so volumes do not overlap head-on." )]
	public float PhaseOffset { get; set; }

	[Property, Group( "Lanes" ), Title( "Base Height" ), Description( "Vertical offset from the layer controller. Cloud layer sets this to Ocean Level." )]
	public float BaseHeight { get; set; } = 0f;

	/// <summary>
	/// When true, <see cref="WeatherCloudLayerControllerComponent"/> sets world position each frame.
	/// </summary>
	public bool GroupManaged { get; set; }

	[Property, Group( "Drift" ), Title( "Wrap Horizontally" )]
	public bool WrapHorizontally { get; set; } = true;

	Vector3 _wrapCenter;

	bool ShouldDrift => Enabled && Volume.IsValid() && !GroupManaged && (Game.IsPlaying || (Game.IsEditor && DriftInEditor));

	bool IsEditMode => Game.IsEditor && !Game.IsPlaying;

	protected override void OnAwake()
	{
		_wrapCenter = Transform.World.Position;
	}

	protected override void OnStart()
	{
		if ( _wrapCenter == default )
			_wrapCenter = Transform.World.Position;
	}

	protected override void OnUpdate()
	{
		if ( !ShouldDrift )
			return;

		EnsureWrapRegion();

		var sample = ResolveWeather();
		var wind = GetFlatWind( sample.WindDirection );
		var speed = MathX.Lerp( MinDriftSpeed, MaxDriftSpeed, sample.WindStrength ) * SpeedMultiplier;

		GameObject.WorldPosition += wind * speed * Time.Delta;

		if ( WrapHorizontally && (WrapInWorldBounds || UseCustomWrapRegion || WrapRegion.IsValid()) )
			WrapInsideRegion( GetWrapBounds() );
	}

	internal void ApplyLanePosition( Vector3 worldPosition )
	{
		if ( !Enabled || !Volume.IsValid() )
			return;

		GameObject.WorldPosition = worldPosition;
	}

	void EnsureWrapRegion()
	{
		if ( WrapRegion.IsValid() )
			return;

		WrapRegion = GameObject.Parent?.Components.Get<WeatherCloudLayerControllerComponent>();
	}

	internal static Vector3 GetFlatWind( Vector3 windDirection )
	{
		var wind = windDirection.WithZ( 0f );
		if ( wind.LengthSquared <= 0.0001f )
			return Vector3.Forward;

		return wind.Normal;
	}

	internal static Vector3 GetWindPerpendicular( Vector3 flatWind ) =>
		new( -flatWind.y, flatWind.x, 0f );

	BBox GetWrapBounds()
	{
		if ( WrapRegion.IsValid() )
			return WrapRegion.GetWrapBounds();

		if ( UseCustomWrapRegion && WrapRegionSize.x > 1f && WrapRegionSize.y > 1f )
			return BBox.FromPositionAndSize( _wrapCenter, WrapRegionSize );

		var world = ResolveWorldManager();
		if ( !world.IsValid() )
			return BBox.FromPositionAndSize( _wrapCenter, WrapRegionSize );

		var center = new Vector3( world.WorldCenter.x, world.WorldCenter.y, _wrapCenter.z );
		var size = new Vector3( world.WorldSize.x, world.WorldSize.y, Volume.Size.z );
		return BBox.FromPositionAndSize( center, size );
	}

	void WrapInsideRegion( BBox bounds )
	{
		var position = GameObject.WorldPosition;
		var half = Volume.Size * 0.5f;
		var wrapped = false;

		if ( position.x - half.x > bounds.Maxs.x )
		{
			position.x = bounds.Mins.x + half.x;
			wrapped = true;
		}
		else if ( position.x + half.x < bounds.Mins.x )
		{
			position.x = bounds.Maxs.x - half.x;
			wrapped = true;
		}

		if ( position.y - half.y > bounds.Maxs.y )
		{
			position.y = bounds.Mins.y + half.y;
			wrapped = true;
		}
		else if ( position.y + half.y < bounds.Mins.y )
		{
			position.y = bounds.Maxs.y - half.y;
			wrapped = true;
		}

		if ( wrapped )
			GameObject.WorldPosition = position;
	}

	WeatherSample ResolveWeather()
	{
		var world = WorldManagerComponent.Instance;
		if ( world.IsValid() && world.Weather.IsValid() )
		{
			if ( IsEditMode )
				return WeatherSample.FromProfile( WeatherProfile.GetPreset( world.Weather.StartingWeather ) );

			return WeatherSample.FromWeatherManager( world.Weather );
		}

		if ( Scene is null )
			return WeatherSample.DefaultClear;

		var weatherManager = Scene.GetAllComponents<WeatherManagerComponent>().FirstOrDefault();
		if ( weatherManager.IsValid() )
		{
			if ( IsEditMode )
				return WeatherSample.FromProfile( WeatherProfile.GetPreset( weatherManager.StartingWeather ) );

			return WeatherSample.FromWeatherManager( weatherManager );
		}

		return WeatherSample.DefaultClear;
	}

	WorldManagerSingletonComponent ResolveWorldManager()
	{
		var world = WorldManagerComponent.Instance;
		if ( world.IsValid() )
		{
			var singleton = world.GameObject.Components.Get<WorldManagerSingletonComponent>();
			if ( singleton.IsValid() )
				return singleton;
		}

		return Scene?.GetAllComponents<WorldManagerSingletonComponent>().FirstOrDefault();
	}
}
