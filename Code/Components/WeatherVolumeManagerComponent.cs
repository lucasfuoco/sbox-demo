using Sandbox.Components.PawnComponents;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

/// <summary>
/// Samples global weather from <see cref="WorldManagerComponent"/> and blends active
/// <see cref="WeatherVolumeComponent"/> components at any world position.
/// </summary>
/// <remarks>
/// Scene setup:
/// 1. Add this component next to <see cref="WeatherManagerComponent"/> on the World object.
/// 2. Place <see cref="WeatherVolumeComponent"/> prefabs in the scene or spawn them with chunk streaming.
/// 3. Read <see cref="GetPlayerWeather"/> from gameplay controllers (rain, fog, audio, storm).
///
/// Other systems should not read volume components directly — always sample through this manager
/// so global weather and overlapping volumes stay consistently blended.
/// </remarks>
[Title( "Weather Volume Manager" ), Category( "World Simulation" ), Icon( "cloud_queue" )]
public sealed class WeatherVolumeManagerComponent : Component
{
	[RequireComponent]
	public WorldManagerComponent World { get; private set; }

	[Property, Group( "Setup" ), Title( "Follow Camera" )]
	public CameraComponent FollowCamera { get; set; }

	[Property, Group( "Setup" ), Title( "Volume Refresh Interval" ), Range( 0.05f, 2f )]
	public float VolumeRefreshInterval { get; set; } = 0.35f;

	[Property, Group( "Gameplay Hooks" ), Title( "Enable Toxic Gas Hook" )]
	public bool EnableToxicGasHook { get; set; } = true;

	[Property, Group( "Gameplay Hooks" ), Title( "Enable Screen Tint Hook" )]
	public bool EnableScreenTintHook { get; set; } = true;

	readonly List<WeatherVolumeComponent> _volumes = new();
	readonly List<(WeatherVolumeComponent volume, float blend)> _contributionsScratch = new();
	RealTimeSince _sinceVolumeRefresh;
	WeatherSample _cachedPlayerWeather;
	Vector3 _cachedPlayerPosition;
	bool _hasCachedPlayerWeather;

	/// <summary>
	/// Fired when the listener is inside a toxic gas volume. Parameter is exposure 0-1.
	/// Wire gameplay damage systems here.
	/// </summary>
	public event Action<float> OnToxicGasExposure;

	/// <summary>
	/// Fired when localized weather reduces visibility. Parameter is tint strength 0-1.
	/// Wire post-process / screen tint here.
	/// </summary>
	public event Action<float> OnWeatherScreenTint;

	public WeatherSample CachedPlayerWeather => _cachedPlayerWeather;

	protected override void OnStart()
	{
		EnsureReferences();
		RefreshVolumes( force: true );
	}

	protected override void OnUpdate()
	{
		EnsureReferences();

		if ( _sinceVolumeRefresh >= VolumeRefreshInterval )
			RefreshVolumes( force: true );

		var playerPosition = ResolveListenerPosition();
		_cachedPlayerPosition = playerPosition;
		_cachedPlayerWeather = GetWeatherAt( playerPosition );
		_hasCachedPlayerWeather = true;

		InvokeGameplayHooks( _cachedPlayerWeather, playerPosition );
	}

	public void RefreshVolumes( bool force = false )
	{
		if ( !force && _sinceVolumeRefresh < VolumeRefreshInterval )
			return;

		_volumes.Clear();

		foreach ( var volume in Scene.GetAllComponents<WeatherVolumeComponent>() )
		{
			if ( !volume.IsValid() || !volume.Enabled || !volume.GameObject.Enabled )
				continue;

			_volumes.Add( volume );
		}

		_sinceVolumeRefresh = 0;
	}

	/// <summary>
	/// Blends global weather with all overlapping volumes at <paramref name="position"/>.
	/// Safe to call when no volumes exist — returns global weather only.
	/// </summary>
	public WeatherSample GetWeatherAt( Vector3 position )
	{
		var result = WeatherSample.FromGlobal( World );

		if ( _volumes.Count == 0 )
			return result;

		_contributionsScratch.Clear();

		foreach ( var volume in _volumes )
		{
			if ( !volume.IsValid() )
				continue;

			var blend = volume.GetBlend( position );
			if ( blend <= 0.001f )
				continue;

			_contributionsScratch.Add( (volume, blend) );
		}

		if ( _contributionsScratch.Count == 0 )
			return result;

		_contributionsScratch.Sort( static ( a, b ) => b.blend.CompareTo( a.blend ) );

		foreach ( var (volume, blend) in _contributionsScratch )
		{
			var localSample = volume.GetWeatherSample();
			result = WeatherSample.BlendWithVolume( result, localSample, blend, volume.VolumeType );
		}

		return result;
	}

	/// <summary>
	/// Returns weather at the active listener (camera / pawn). Falls back to global weather.
	/// </summary>
	public WeatherSample GetPlayerWeather()
	{
		if ( _hasCachedPlayerWeather )
			return _cachedPlayerWeather;

		return GetWeatherAt( ResolveListenerPosition() );
	}

	public Vector3 GetPlayerPosition() => _hasCachedPlayerWeather ? _cachedPlayerPosition : ResolveListenerPosition();

	void EnsureReferences()
	{
		World ??= WorldManagerComponent.Instance;
		World ??= Components.Get<WorldManagerComponent>();

		if ( FollowCamera.IsValid() )
			return;

		FollowCamera = Scene.Camera;

		if ( FollowCamera.IsValid() )
			return;

		foreach ( var camera in Scene.GetAllComponents<CameraComponent>() )
		{
			if ( !camera.IsValid() || !camera.Enabled )
				continue;

			FollowCamera = camera;
			break;
		}
	}

	Vector3 ResolveListenerPosition()
	{
		if ( FollowCamera.IsValid() )
			return FollowCamera.WorldPosition;

		var pawn = Scene.GetAllComponents<PlayerPawnComponent>().FirstOrDefault( x => x.IsValid() && x.Enabled );
		if ( pawn.IsValid() )
			return pawn.WorldPosition;

		return World.IsValid() ? World.WorldPosition : WorldPosition;
	}

	void InvokeGameplayHooks( WeatherSample sample, Vector3 position )
	{
		var toxicBlend = 0f;

		foreach ( var volume in _volumes )
		{
			if ( !volume.IsValid() || volume.VolumeType != WeatherVolumeType.ToxicGas )
				continue;

			var blend = volume.GetBlend( position );
			if ( blend > toxicBlend )
				toxicBlend = blend;
		}

		if ( EnableToxicGasHook && toxicBlend > 0.01f )
			OnToxicGasExposure?.Invoke( toxicBlend * sample.GetToxicExposure() );

		if ( EnableScreenTintHook )
		{
			var tintStrength = MathX.Clamp( (1f - sample.VisibilityMultiplier) * 0.85f + sample.AudioMuffleAmount * 0.25f, 0f, 1f );
			if ( tintStrength > 0.02f )
				OnWeatherScreenTint?.Invoke( tintStrength );
		}
	}
}
