using Sandbox.Components;
using Sandbox.Components.SingletonComponents;

namespace Sandbox;

/// <summary>
/// Blended atmospheric values at a world position.
/// Global weather comes from <see cref="WorldManagerComponent"/>; volumes add localized overrides.
/// </summary>
public struct WeatherSample
{
	public float RainAmount;
	public float SnowAmount;
	public float FogAmount;
	public float WindStrength;
	public Vector3 WindDirection;
	public float CloudDensity;
	public float StormAmount;
	public float VisibilityMultiplier;
	public float AudioMuffleAmount;
	public float TemperatureModifier;

	public static WeatherSample FromGlobal( WorldManagerComponent world )
	{
		if ( !world.IsValid() )
			return DefaultClear;

		var rain = MathX.Clamp( world.RainAmount, 0f, 1f );
		var storm = MathX.Clamp(
			rain * 0.65f + world.WindStrength * 0.45f + (world.CurrentWeather == WeatherType.Storm ? 0.35f : 0f),
			0f,
			1f );

		return new WeatherSample
		{
			RainAmount = rain,
			SnowAmount = MathX.Clamp( world.SnowAmount, 0f, 1f ),
			FogAmount = MathX.Clamp( world.FogAmount, 0f, 1f ),
			WindStrength = MathX.Clamp( world.WindStrength, 0f, 1f ),
			WindDirection = NormalizeWindDirection( world.WindDirection ),
			CloudDensity = MathX.Clamp( world.OvercastAmount, 0f, 1f ),
			StormAmount = storm,
			VisibilityMultiplier = 1f,
			AudioMuffleAmount = 0f,
			TemperatureModifier = 0f,
		};
	}

	public static WeatherSample FromProfile( WeatherProfile profile )
	{
		var rain = MathX.Clamp( profile.RainAmount, 0f, 1f );
		var storm = MathX.Clamp(
			rain * 0.65f + profile.WindStrength * 0.45f + (profile.Type == WeatherType.Storm ? 0.35f : 0f),
			0f,
			1f );

		return new WeatherSample
		{
			RainAmount = rain,
			SnowAmount = MathX.Clamp( profile.SnowAmount, 0f, 1f ),
			FogAmount = MathX.Clamp( profile.FogAmount, 0f, 1f ),
			WindStrength = MathX.Clamp( profile.WindStrength, 0f, 1f ),
			WindDirection = NormalizeWindDirection( profile.WindDirection ),
			CloudDensity = MathX.Clamp( profile.OvercastAmount, 0f, 1f ),
			StormAmount = storm,
			VisibilityMultiplier = 1f,
			AudioMuffleAmount = 0f,
			TemperatureModifier = 0f,
		};
	}

	public static WeatherSample FromWeatherManager( WeatherManagerComponent weather )
	{
		if ( !weather.IsValid() )
			return DefaultClear;

		var rain = MathX.Clamp( weather.RainAmount, 0f, 1f );
		var storm = MathX.Clamp(
			rain * 0.65f + weather.WindStrength * 0.45f + (weather.CurrentWeather == WeatherType.Storm ? 0.35f : 0f),
			0f,
			1f );

		return new WeatherSample
		{
			RainAmount = rain,
			SnowAmount = MathX.Clamp( weather.SnowAmount, 0f, 1f ),
			FogAmount = MathX.Clamp( weather.FogAmount, 0f, 1f ),
			WindStrength = MathX.Clamp( weather.WindStrength, 0f, 1f ),
			WindDirection = NormalizeWindDirection( weather.WindDirection ),
			CloudDensity = MathX.Clamp( weather.OvercastAmount, 0f, 1f ),
			StormAmount = storm,
			VisibilityMultiplier = 1f,
			AudioMuffleAmount = 0f,
			TemperatureModifier = 0f,
		};
	}

	public static WeatherSample DefaultClear => new()
	{
		WindDirection = Vector3.Forward,
		VisibilityMultiplier = 1f,
	};

	public static WeatherSample FromVolumeType( WeatherVolumeType type )
	{
		return type switch
		{
			WeatherVolumeType.RainCloud => new WeatherSample
			{
				RainAmount = 0.65f,
				CloudDensity = 0.75f,
				WindStrength = 0.35f,
				WindDirection = new Vector3( 0.9f, 0.1f, 0f ).Normal,
				VisibilityMultiplier = 0.92f,
			},
			WeatherVolumeType.StormCloud => new WeatherSample
			{
				RainAmount = 0.95f,
				FogAmount = 0.35f,
				WindStrength = 0.9f,
				WindDirection = new Vector3( 0.7f, 0.7f, 0f ).Normal,
				CloudDensity = 1f,
				StormAmount = 1f,
				VisibilityMultiplier = 0.55f,
				AudioMuffleAmount = 0.08f,
			},
			WeatherVolumeType.FogBank => new WeatherSample
			{
				FogAmount = 0.95f,
				CloudDensity = 0.45f,
				WindStrength = 0.08f,
				WindDirection = Vector3.Forward,
				VisibilityMultiplier = 0.35f,
				AudioMuffleAmount = 0.18f,
			},
			WeatherVolumeType.SnowCloud => new WeatherSample
			{
				SnowAmount = 0.85f,
				CloudDensity = 0.9f,
				WindStrength = 0.4f,
				WindDirection = new Vector3( 0.2f, 0.9f, 0f ).Normal,
				TemperatureModifier = -6f,
				VisibilityMultiplier = 0.7f,
			},
			WeatherVolumeType.DustStorm => new WeatherSample
			{
				FogAmount = 0.25f,
				WindStrength = 0.85f,
				WindDirection = new Vector3( 1f, 0.2f, 0f ).Normal,
				CloudDensity = 0.55f,
				VisibilityMultiplier = 0.4f,
				AudioMuffleAmount = 0.12f,
			},
			WeatherVolumeType.ToxicGas => new WeatherSample
			{
				FogAmount = 0.55f,
				CloudDensity = 0.35f,
				WindStrength = 0.05f,
				WindDirection = Vector3.Forward,
				VisibilityMultiplier = 0.45f,
				AudioMuffleAmount = 0.22f,
			},
			WeatherVolumeType.AshCloud => new WeatherSample
			{
				FogAmount = 0.7f,
				CloudDensity = 0.65f,
				WindStrength = 0.2f,
				WindDirection = new Vector3( 0.5f, 0.5f, 0f ).Normal,
				VisibilityMultiplier = 0.5f,
				AudioMuffleAmount = 0.1f,
			},
			WeatherVolumeType.ClearCloud => new WeatherSample
			{
				CloudDensity = 0.55f,
				WindStrength = 0.2f,
				WindDirection = new Vector3( 0.85f, 0.15f, 0f ).Normal,
				VisibilityMultiplier = 1f,
			},
			_ => DefaultClear,
		};
	}

	public static WeatherSample BlendWithVolume( WeatherSample global, WeatherSample local, float blend, WeatherVolumeType type )
	{
		if ( blend <= 0.001f )
			return global;

		blend = MathX.Clamp( blend, 0f, 1f );

		// Dominant effects win at high blend — use max-weighted merge so overlapping volumes stay stable.
		return new WeatherSample
		{
			RainAmount = DominantBlend( global.RainAmount, local.RainAmount, blend ),
			SnowAmount = DominantBlend( global.SnowAmount, local.SnowAmount, blend ),
			FogAmount = DominantBlend( global.FogAmount, local.FogAmount, blend ),
			WindStrength = DominantBlend( global.WindStrength, local.WindStrength, blend ),
			WindDirection = BlendWindDirection( global.WindDirection, local.WindDirection, blend ),
			CloudDensity = DominantBlend( global.CloudDensity, local.CloudDensity, blend ),
			StormAmount = DominantBlend( global.StormAmount, local.StormAmount, blend ),
			VisibilityMultiplier = VisibilityBlend( global.VisibilityMultiplier, local.VisibilityMultiplier, blend ),
			AudioMuffleAmount = DominantBlend( global.AudioMuffleAmount, local.AudioMuffleAmount, blend ),
			TemperatureModifier = MathX.Lerp( global.TemperatureModifier, local.TemperatureModifier, blend ),
		};
	}

	static float DominantBlend( float globalValue, float localValue, float blend )
	{
		var target = MathF.Max( globalValue, localValue );
		return MathX.Lerp( globalValue, target, blend );
	}

	static float VisibilityBlend( float globalValue, float localValue, float blend )
	{
		var target = MathF.Min( globalValue, localValue );
		return MathX.Lerp( globalValue, target, blend );
	}

	public static Vector3 NormalizeWindDirection( Vector3 direction )
	{
		direction = direction.WithZ( 0f );
		return direction.LengthSquared > 0.0001f ? direction.Normal : Vector3.Forward;
	}

	static Vector3 BlendWindDirection( Vector3 globalDirection, Vector3 localDirection, float blend )
	{
		globalDirection = NormalizeWindDirection( globalDirection );
		localDirection = NormalizeWindDirection( localDirection );

		if ( blend <= 0.001f )
			return globalDirection;

		var blended = Vector3.Lerp( globalDirection, localDirection, blend );
		return NormalizeWindDirection( blended );
	}

	public static float GetCompassDegrees( Vector3 windDirection )
	{
		var flat = windDirection.WithZ( 0f );
		if ( flat.LengthSquared <= 0.0001f )
			return 0f;

		flat = flat.Normal;
		var degrees = MathF.Atan2( flat.y, flat.x ) * 180f / MathF.PI;
		return (degrees + 360f) % 360f;
	}

	public static string GetCompassLabel( Vector3 windDirection )
	{
		var degrees = GetCompassDegrees( windDirection );
		var index = (int)MathF.Round( degrees / 45f ) % 8;
		return index switch
		{
			0 => "E",
			1 => "NE",
			2 => "N",
			3 => "NW",
			4 => "W",
			5 => "SW",
			6 => "S",
			_ => "SE",
		};
	}

	public float GetToxicExposure() =>
		MathX.Clamp( (1f - VisibilityMultiplier) * AudioMuffleAmount, 0f, 1f );
}
