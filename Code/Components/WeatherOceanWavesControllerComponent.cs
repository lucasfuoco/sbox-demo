using RedSnail.WaterTool;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

/// <summary>
/// Scales ocean Gerstner waves from the assigned WaterDefinition using global / volume weather.
/// Keeps GPU waves and CPU buoyancy in sync by updating Water Manager's OceanWaveProfile each frame.
/// </summary>
[Title( "Weather Ocean Waves Controller" ), Category( "World Simulation" ), Icon( "tsunami" )]
public sealed class WeatherOceanWavesControllerComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Setup" ), Title( "Volume Manager" )]
	public WeatherVolumeManagerComponent VolumeManager { get; set; }

	[Property, Group( "Setup" ), Title( "Base Ocean Profile" ), Description( "Storm / reference profile. Leave empty to use Water Manager Ocean profile or resources/water/ocean.wtdef." )]
	public WaterDefinition BaseProfile { get; set; }

	[Property, Group( "Response" ), Title( "Calm Scale" ), Range( 0.05f, 1.5f ), Description( "Wave intensity multiplier in clear weather." )]
	public float CalmScale { get; set; } = 1.05f;

	[Property, Group( "Response" ), Title( "Storm Scale" ), Range( 0.5f, 2.5f ), Description( "Wave intensity multiplier at full storm." )]
	public float StormScale { get; set; } = 1.6f;

	[Property, Group( "Response" ), Title( "Wind Weight" ), Range( 0f, 1f ), Description( "How much wind alone can push sea state without rain." )]
	public float WindWeight { get; set; } = 0.55f;

	[Property, Group( "Response" ), Title( "Blend Speed" ), Range( 0.05f, 3f ), Description( "How quickly waves ease toward the weather target." )]
	public float BlendSpeed { get; set; } = 0.45f;

	[Property, Group( "Response" ), Title( "Align To Wind" ), Description( "Steer detail / swell wave directions toward wind." )]
	public bool AlignToWind { get; set; } = true;

	[Property, Group( "Response" ), Title( "Wind Direction Strength" ), Range( 0f, 1f )]
	public float WindDirectionStrength { get; set; } = 0.85f;

	WaveBaseline _baseline;
	WaterDefinition _profile;
	float _seaState;
	bool _captured;

	protected override void OnEnabled()
	{
		TryCaptureBaseline();
	}

	protected override void OnStart()
	{
		TryCaptureBaseline();
	}

	protected override void OnUpdate()
	{
		if ( !TryCaptureBaseline() || !_profile.IsValid() )
			return;

		if ( WaterManager.Current is not null )
			WaterManager.Current.OceanWaveProfile = _profile;

		var sample = SampleWeather();
		var targetSea = EvaluateSeaState( sample );
		var blend = MathX.Clamp( BlendSpeed * Time.Delta, 0f, 1f );
		_seaState = MathX.Lerp( _seaState, targetSea, blend );

		ApplySeaState( sample, _seaState );
	}

	protected override void OnDisabled()
	{
		if ( _captured && _profile.IsValid() )
			_baseline.WriteTo( _profile );
	}

	WeatherSample SampleWeather()
	{
		VolumeManager ??= Components.Get<WeatherVolumeManagerComponent>( FindMode.EverythingInSelfAndAncestors )
			?? Scene.GetAllComponents<WeatherVolumeManagerComponent>().FirstOrDefault();

		if ( VolumeManager.IsValid() )
			return VolumeManager.GetPlayerWeather();

		var world = WorldManagerComponent.Instance;
		if ( world.IsValid() )
			return WeatherSample.FromGlobal( world );

		var weather = Scene.GetAllComponents<WeatherManagerComponent>().FirstOrDefault();
		return weather.IsValid()
			? WeatherSample.FromWeatherManager( weather )
			: WeatherSample.DefaultClear;
	}

	static float EvaluateSeaState( WeatherSample sample )
	{
		var storm = MathX.Clamp( sample.StormAmount, 0f, 1f );
		var wind = MathX.Clamp( sample.WindStrength, 0f, 1f );
		var rain = MathX.Clamp( sample.RainAmount, 0f, 1f );

		var fromWind = wind * 0.75f;
		var fromWeather = MathF.Max( storm, rain * 0.85f );
		return MathX.Clamp( MathF.Max( fromWeather, fromWind ), 0f, 1f );
	}

	bool TryCaptureBaseline()
	{
		if ( _captured && _profile.IsValid() )
			return true;

		_profile = ResolveProfile();
		if ( !_profile.IsValid() )
			return false;

		_baseline = WaveBaseline.From( _profile );
		_seaState = 0f;
		_captured = true;

		if ( WaterManager.Current is not null )
			WaterManager.Current.OceanWaveProfile = _profile;

		return true;
	}

	WaterDefinition ResolveProfile()
	{
		if ( BaseProfile.IsValid() )
			return BaseProfile;

		if ( WaterManager.Current?.OceanWaveProfile is { } assigned && assigned.IsValid() )
			return assigned;

		return ResourceLibrary.Get<WaterDefinition>( "resources/water/ocean.wtdef" )
			?? ResourceLibrary.Get<WaterDefinition>( "resources/ocean.wtdef" );
	}

	void ApplySeaState( WeatherSample sample, float seaState )
	{
		var intensityScale = MathX.Lerp( CalmScale, StormScale, seaState );
		var steepScale = MathX.Lerp( 0.75f, 1.2f, seaState );
		var speedScale = MathX.Lerp( 0.85f, 1.35f, seaState );
		var windMix = MathX.Clamp( sample.WindStrength * WindWeight, 0f, 1f );

		_profile.WavesIntensity = _baseline.WavesIntensity * intensityScale;
		_profile.SwellIntensity = _baseline.SwellIntensity * MathX.Lerp( CalmScale, StormScale, MathF.Max( seaState, windMix * 0.85f ) );

		_profile.WavesSpeed = _baseline.WavesSpeed * speedScale;
		_profile.SwellSpeed = _baseline.SwellSpeed * MathX.Lerp( 0.7f, 1.2f, seaState );

		_profile.WavesSteepness = MathX.Clamp( _baseline.WavesSteepness * steepScale, 0.05f, 1f );
		_profile.SwellSteepness = MathX.Clamp( _baseline.SwellSteepness * steepScale, 0.05f, 1f );

		_profile.WavesPersistence = MathX.Clamp(
			MathX.Lerp( _baseline.WavesPersistence * 0.85f, _baseline.WavesPersistence, seaState ),
			0.05f,
			1f );
		_profile.SwellPersistence = MathX.Clamp(
			MathX.Lerp( _baseline.SwellPersistence * 0.85f, _baseline.SwellPersistence, seaState ),
			0.05f,
			1f );

		_profile.WavesScale = _baseline.WavesScale;
		_profile.SwellScale = _baseline.SwellScale;
		_profile.WavesOctaves = _baseline.WavesOctaves;
		_profile.SwellOctaves = _baseline.SwellOctaves;
		_profile.WavesLacunarity = _baseline.WavesLacunarity;
		_profile.SwellLacunarity = _baseline.SwellLacunarity;

		if ( AlignToWind )
		{
			var windDir = WeatherSample.NormalizeWindDirection( sample.WindDirection );
			var wind2 = Normalize2( new Vector2( windDir.x, windDir.y ) );
			var strength = WindDirectionStrength * MathX.Lerp( 0.35f, 1f, MathF.Max( seaState, windMix ) );

			_profile.WavesDirection = Lerp2( _baseline.WavesDirection, wind2, strength );

			var cross = Normalize2( new Vector2( wind2.y, -wind2.x ) );
			var swellTarget = Normalize2( Lerp2( wind2, cross, 0.2f ) );
			_profile.SwellDirection = Lerp2( _baseline.SwellDirection, swellTarget, strength * 0.85f );
		}
		else
		{
			_profile.WavesDirection = _baseline.WavesDirection;
			_profile.SwellDirection = _baseline.SwellDirection;
		}
	}

	static Vector2 Normalize2( Vector2 value )
	{
		var length = value.Length;
		return length > 0.0001f ? value / length : new Vector2( 1f, 0f );
	}

	static Vector2 Lerp2( Vector2 a, Vector2 b, float t )
	{
		return new Vector2( MathX.Lerp( a.x, b.x, t ), MathX.Lerp( a.y, b.y, t ) );
	}

	struct WaveBaseline
	{
		public float WavesIntensity;
		public float WavesSpeed;
		public float WavesScale;
		public Vector2 WavesDirection;
		public int WavesOctaves;
		public float WavesLacunarity;
		public float WavesPersistence;
		public float WavesSteepness;

		public float SwellIntensity;
		public float SwellSpeed;
		public float SwellScale;
		public Vector2 SwellDirection;
		public int SwellOctaves;
		public float SwellLacunarity;
		public float SwellPersistence;
		public float SwellSteepness;

		public static WaveBaseline From( WaterDefinition profile ) => new()
		{
			WavesIntensity = profile.WavesIntensity,
			WavesSpeed = profile.WavesSpeed,
			WavesScale = profile.WavesScale,
			WavesDirection = profile.WavesDirection,
			WavesOctaves = profile.WavesOctaves,
			WavesLacunarity = profile.WavesLacunarity,
			WavesPersistence = profile.WavesPersistence,
			WavesSteepness = profile.WavesSteepness,
			SwellIntensity = profile.SwellIntensity,
			SwellSpeed = profile.SwellSpeed,
			SwellScale = profile.SwellScale,
			SwellDirection = profile.SwellDirection,
			SwellOctaves = profile.SwellOctaves,
			SwellLacunarity = profile.SwellLacunarity,
			SwellPersistence = profile.SwellPersistence,
			SwellSteepness = profile.SwellSteepness,
		};

		public void WriteTo( WaterDefinition profile )
		{
			profile.WavesIntensity = WavesIntensity;
			profile.WavesSpeed = WavesSpeed;
			profile.WavesScale = WavesScale;
			profile.WavesDirection = WavesDirection;
			profile.WavesOctaves = WavesOctaves;
			profile.WavesLacunarity = WavesLacunarity;
			profile.WavesPersistence = WavesPersistence;
			profile.WavesSteepness = WavesSteepness;
			profile.SwellIntensity = SwellIntensity;
			profile.SwellSpeed = SwellSpeed;
			profile.SwellScale = SwellScale;
			profile.SwellDirection = SwellDirection;
			profile.SwellOctaves = SwellOctaves;
			profile.SwellLacunarity = SwellLacunarity;
			profile.SwellPersistence = SwellPersistence;
			profile.SwellSteepness = SwellSteepness;
		}
	}
}
