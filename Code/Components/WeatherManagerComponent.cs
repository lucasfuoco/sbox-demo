namespace Sandbox.Components;

/// <summary>
/// Server-authoritative weather simulation. Clients interpolate atmospheric values for rendering.
/// </summary>
[Title( "Weather Manager" ), Category( "World Simulation" )]
public sealed class WeatherManagerComponent : Component
{
	const float AmountEpsilon = 0.01f;
	const float TemperatureEpsilon = 0.1f;
	const float WindDirectionEpsilon = 0.01f;

	[Property, Group( "Weather" ), Title( "Starting Weather" )]
	public WeatherType StartingWeather { get; set; } = WeatherType.Clear;

	[Property, Group( "Weather" ), Title( "Transition Speed" ), Description( "How quickly the server blends toward the target weather profile." ), Range( 0.05f, 2f )]
	public float WeatherTransitionSpeed { get; set; } = 0.35f;

	[Sync( SyncFlags.FromHost )]
	public WeatherType CurrentWeather { get; private set; }

	[Sync( SyncFlags.FromHost )]
	public WeatherType TargetWeather { get; private set; }

	[Sync( SyncFlags.FromHost )]
	float SyncedRainAmount { get; set; }

	[Sync( SyncFlags.FromHost )]
	float SyncedSnowAmount { get; set; }

	[Sync( SyncFlags.FromHost )]
	float SyncedFogAmount { get; set; }

	[Sync( SyncFlags.FromHost )]
	float SyncedCloudAmount { get; set; }

	[Sync( SyncFlags.FromHost )]
	float SyncedWindStrength { get; set; }

	[Sync( SyncFlags.FromHost )]
	Vector3 SyncedWindDirection { get; set; } = Vector3.Forward;

	[Sync( SyncFlags.FromHost )]
	float SyncedTemperature { get; set; } = 20f;

	float _displayRainAmount;
	float _displaySnowAmount;
	float _displayFogAmount;
	float _displayCloudAmount;
	float _displayWindStrength;
	Vector3 _displayWindDirection = Vector3.Forward;
	float _displayTemperature = 20f;

	public float RainAmount => _displayRainAmount;
	public float SnowAmount => _displaySnowAmount;
	public float FogAmount => _displayFogAmount;
	public float CloudAmount => _displayCloudAmount;
	public float WindStrength => _displayWindStrength;
	public Vector3 WindDirection => _displayWindDirection;
	public float Temperature => _displayTemperature;

	bool IsWeatherAuthority =>
		Networking.IsHost
		|| !Networking.IsActive;

	protected override void OnStart()
	{
		if ( IsWeatherAuthority )
			ApplyProfileImmediate( WeatherProfile.GetPreset( StartingWeather ) );
		else
			CopySyncedToDisplay();
	}

	protected override void OnFixedUpdate()
	{
		if ( !IsWeatherAuthority )
			return;

		var profile = WeatherProfile.GetPreset( TargetWeather );

		SyncedRainAmount = SyncedRainAmount.MoveToLinear( profile.RainAmount, WeatherTransitionSpeed );
		SyncedSnowAmount = SyncedSnowAmount.MoveToLinear( profile.SnowAmount, WeatherTransitionSpeed );
		SyncedFogAmount = SyncedFogAmount.MoveToLinear( profile.FogAmount, WeatherTransitionSpeed );
		SyncedCloudAmount = SyncedCloudAmount.MoveToLinear( profile.CloudAmount, WeatherTransitionSpeed );
		SyncedWindStrength = SyncedWindStrength.MoveToLinear( profile.WindStrength, WeatherTransitionSpeed );
		SyncedTemperature = SyncedTemperature.MoveToLinear( profile.Temperature, WeatherTransitionSpeed );
		SyncedWindDirection = MoveWindDirectionToward( SyncedWindDirection, profile.WindDirection, WeatherTransitionSpeed );

		if ( HasReachedProfile( profile ) )
			CurrentWeather = TargetWeather;
	}

	protected override void OnUpdate()
	{
		var networkRate = Scene.NetworkRate;

		if ( IsWeatherAuthority )
		{
			CopySyncedToDisplay();
			return;
		}

		_displayRainAmount = WorldSimulationInterpolation.NetworkLerp( _displayRainAmount, SyncedRainAmount, Time.Delta, networkRate );
		_displaySnowAmount = WorldSimulationInterpolation.NetworkLerp( _displaySnowAmount, SyncedSnowAmount, Time.Delta, networkRate );
		_displayFogAmount = WorldSimulationInterpolation.NetworkLerp( _displayFogAmount, SyncedFogAmount, Time.Delta, networkRate );
		_displayCloudAmount = WorldSimulationInterpolation.NetworkLerp( _displayCloudAmount, SyncedCloudAmount, Time.Delta, networkRate );
		_displayWindStrength = WorldSimulationInterpolation.NetworkLerp( _displayWindStrength, SyncedWindStrength, Time.Delta, networkRate );
		_displayTemperature = WorldSimulationInterpolation.NetworkLerp( _displayTemperature, SyncedTemperature, Time.Delta, networkRate );
		_displayWindDirection = WorldSimulationInterpolation.NetworkLerp( _displayWindDirection, SyncedWindDirection.Normal, Time.Delta, networkRate );

		if ( _displayWindDirection.LengthSquared > 0.0001f )
			_displayWindDirection = _displayWindDirection.Normal;
	}

	/// <summary>
	/// Queue a weather transition on the host.
	/// </summary>
	public void SetTargetWeather( WeatherType weatherType )
	{
		if ( !IsWeatherAuthority )
			return;

		TargetWeather = weatherType;
	}

	void ApplyProfileImmediate( WeatherProfile profile )
	{
		CurrentWeather = profile.Type;
		TargetWeather = profile.Type;
		SyncedRainAmount = profile.RainAmount;
		SyncedSnowAmount = profile.SnowAmount;
		SyncedFogAmount = profile.FogAmount;
		SyncedCloudAmount = profile.CloudAmount;
		SyncedWindStrength = profile.WindStrength;
		SyncedWindDirection = profile.WindDirection.Normal;
		SyncedTemperature = profile.Temperature;
		CopySyncedToDisplay();
	}

	void CopySyncedToDisplay()
	{
		_displayRainAmount = SyncedRainAmount;
		_displaySnowAmount = SyncedSnowAmount;
		_displayFogAmount = SyncedFogAmount;
		_displayCloudAmount = SyncedCloudAmount;
		_displayWindStrength = SyncedWindStrength;
		_displayWindDirection = SyncedWindDirection.Normal;
		_displayTemperature = SyncedTemperature;
	}

	bool HasReachedProfile( WeatherProfile profile )
	{
		return MathF.Abs( SyncedRainAmount - profile.RainAmount ) <= AmountEpsilon
			&& MathF.Abs( SyncedSnowAmount - profile.SnowAmount ) <= AmountEpsilon
			&& MathF.Abs( SyncedFogAmount - profile.FogAmount ) <= AmountEpsilon
			&& MathF.Abs( SyncedCloudAmount - profile.CloudAmount ) <= AmountEpsilon
			&& MathF.Abs( SyncedWindStrength - profile.WindStrength ) <= AmountEpsilon
			&& MathF.Abs( SyncedTemperature - profile.Temperature ) <= TemperatureEpsilon
			&& (SyncedWindDirection.Normal - profile.WindDirection.Normal).Length <= WindDirectionEpsilon;
	}

	static Vector3 MoveWindDirectionToward( Vector3 current, Vector3 target, float speed )
	{
		var from = current.LengthSquared > 0.0001f ? current.Normal : Vector3.Forward;
		var to = target.LengthSquared > 0.0001f ? target.Normal : Vector3.Forward;
		var moved = from.LerpTo( to, Math.Min( speed * Time.Delta, 1f ) );

		return moved.LengthSquared > 0.0001f ? moved.Normal : to;
	}
}
