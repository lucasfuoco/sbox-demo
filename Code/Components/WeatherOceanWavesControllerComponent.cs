using System.Collections.Generic;
using Sandbox.Components.SingletonComponents;
using Sandbox.GameObjectSystems;
using Sandbox.Ocean;

namespace Sandbox.Components;

/// <summary>
/// Scales GodotOceanWaves FFT cascade wind/foam from weather.
/// </summary>
[Title( "Weather Ocean Waves Controller" ), Category( "World Simulation" ), Icon( "tsunami" )]
public sealed class WeatherOceanWavesControllerComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Setup" )] public WeatherVolumeManagerComponent VolumeManager { get; set; }
	[Property, Group( "Setup" )] public OceanFftDefinition BaseFftProfile { get; set; }

	[Property, Group( "Response" ), Range( 0.05f, 1.5f )] public float CalmScale { get; set; } = 1.05f;
	[Property, Group( "Response" ), Range( 0.5f, 2.5f )] public float StormScale { get; set; } = 1.6f;
	[Property, Group( "Response" ), Range( 0f, 1f )] public float WindWeight { get; set; } = 0.55f;
	[Property, Group( "Response" ), Range( 0.05f, 3f )] public float BlendSpeed { get; set; } = 0.45f;
	[Property, Group( "Response" )] public bool AlignToWind { get; set; } = true;
	[Property, Group( "Response" ), Range( 0f, 1f )] public float WindDirectionStrength { get; set; } = 0.85f;

	OceanFftDefinition _fftProfile;
	List<FftCascadeBaseline> _fftBaselines = new();
	float _seaState;
	bool _fftCaptured;

	protected override void OnEnabled() => TryCaptureFftBaseline();
	protected override void OnStart() => TryCaptureFftBaseline();

	protected override void OnUpdate()
	{
		if ( !TryCaptureFftBaseline() )
			return;

		var sample = SampleWeather();
		var targetSea = EvaluateSeaState( sample );
		var blend = MathX.Clamp( BlendSpeed * Time.Delta, 0f, 1f );
		_seaState = MathX.Lerp( _seaState, targetSea, blend );
		ApplyFftSeaState( sample, _seaState );
	}

	protected override void OnDisabled() => RestoreFftBaseline();

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
		return MathX.Clamp( MathF.Max( MathF.Max( storm, rain * 0.85f ), wind * 0.75f ), 0f, 1f );
	}

	void ApplyFftSeaState( WeatherSample sample, float seaState )
	{
		if ( !TryCaptureFftBaseline() || _fftProfile?.Cascades is null )
			return;

		if ( OceanFftManager.Current is not null )
			OceanFftManager.Current.OceanFftProfile = _fftProfile;

		var windMix = MathX.Clamp( sample.WindStrength * WindWeight, 0f, 1f );
		var intensity = MathX.Lerp( CalmScale, StormScale, MathF.Max( seaState, windMix * 0.85f ) );
		var windDir = WeatherSample.NormalizeWindDirection( sample.WindDirection );
		var windDirDeg = MathF.Atan2( windDir.y, windDir.x ) * (180f / MathF.PI);

		for ( var i = 0; i < _fftProfile.Cascades.Count && i < _fftBaselines.Count; i++ )
		{
			var cascade = _fftProfile.Cascades[i];
			var baseline = _fftBaselines[i];

			var newWind = MathF.Max( 0.0001f, baseline.WindSpeed * intensity );
			var newFoam = baseline.FoamAmount * MathX.Lerp( 0.35f, 1.4f, seaState );
			var newFetch = baseline.FetchLength * MathX.Lerp( 0.85f, 1.25f, seaState );

			if ( MathF.Abs( cascade.WindSpeed - newWind ) > 0.01f
				|| MathF.Abs( cascade.FetchLength - newFetch ) > 0.01f
				|| (AlignToWind && MathF.Abs( cascade.WindDirectionDegrees - windDirDeg ) > 0.5f) )
			{
				cascade.MarkSpectrumDirty();
			}

			cascade.WindSpeed = newWind;
			cascade.FetchLength = newFetch;
			cascade.FoamAmount = newFoam;
			cascade.Whitecap = MathX.Clamp( baseline.Whitecap * MathX.Lerp( 1.1f, 0.75f, seaState ), 0.05f, 2f );
			cascade.DisplacementScale = baseline.DisplacementScale * MathX.Lerp( 0.85f, 1.15f, seaState );

			if ( AlignToWind )
			{
				var strength = WindDirectionStrength * MathX.Lerp( 0.35f, 1f, MathF.Max( seaState, windMix ) );
				cascade.WindDirectionDegrees = MathX.Lerp( baseline.WindDirectionDegrees, windDirDeg, strength );
			}
			else
			{
				cascade.WindDirectionDegrees = baseline.WindDirectionDegrees;
			}
		}
	}

	bool TryCaptureFftBaseline()
	{
		if ( _fftCaptured && _fftProfile is not null && _fftProfile.HasCascades )
			return true;

		_fftProfile = ResolveFftProfile();
		if ( _fftProfile is null || !_fftProfile.HasCascades )
			return false;

		_fftBaselines.Clear();
		foreach ( var cascade in _fftProfile.Cascades )
			_fftBaselines.Add( FftCascadeBaseline.From( cascade ) );

		_fftCaptured = true;
		if ( OceanFftManager.Current is not null )
			OceanFftManager.Current.OceanFftProfile = _fftProfile;

		return true;
	}

	OceanFftDefinition ResolveFftProfile()
	{
		if ( BaseFftProfile is not null && BaseFftProfile.HasCascades )
			return BaseFftProfile;

		if ( OceanFftManager.Current?.OceanFftProfile is { HasCascades: true } assigned )
			return assigned;

		return ResourceLibrary.Get<OceanFftDefinition>( "resources/water/ocean.fftwater" )
			?? ResourceLibrary.Get<OceanFftDefinition>( "resources/ocean.fftwater" );
	}

	void RestoreFftBaseline()
	{
		if ( !_fftCaptured || _fftProfile?.Cascades is null )
			return;

		for ( var i = 0; i < _fftProfile.Cascades.Count && i < _fftBaselines.Count; i++ )
			_fftBaselines[i].WriteTo( _fftProfile.Cascades[i] );
	}

	struct FftCascadeBaseline
	{
		public float WindSpeed;
		public float WindDirectionDegrees;
		public float FetchLength;
		public float FoamAmount;
		public float Whitecap;
		public float DisplacementScale;

		public static FftCascadeBaseline From( OceanFftCascadeParameters cascade ) => new()
		{
			WindSpeed = cascade.WindSpeed,
			WindDirectionDegrees = cascade.WindDirectionDegrees,
			FetchLength = cascade.FetchLength,
			FoamAmount = cascade.FoamAmount,
			Whitecap = cascade.Whitecap,
			DisplacementScale = cascade.DisplacementScale,
		};

		public void WriteTo( OceanFftCascadeParameters cascade )
		{
			cascade.WindSpeed = WindSpeed;
			cascade.WindDirectionDegrees = WindDirectionDegrees;
			cascade.FetchLength = FetchLength;
			cascade.FoamAmount = FoamAmount;
			cascade.Whitecap = Whitecap;
			cascade.DisplacementScale = DisplacementScale;
			cascade.MarkSpectrumDirty();
		}
	}
}
