using System;

namespace Sandbox.Ocean;

/// <summary>
/// One Tessendorf/FFT wave cascade (tile size + spectrum knobs).
/// Spectrum math uses meters (GodotOceanWaves); world sampling converts via UnitsPerMeter.
/// </summary>
public sealed class OceanFftCascadeParameters
{
	/// <summary>Physical tile length for the spectrum (meters).</summary>
	[Property] public Vector2 TileLength { get; set; } = new( 88f, 88f );

	[Property, Range( 0f, 8f )] public float DisplacementScale { get; set; } = 1f;
	[Property, Range( 0f, 2f )] public float NormalScale { get; set; } = 1f;

	/// <summary>Average wind speed above the water (m/s).</summary>
	[Property] public float WindSpeed { get; set; } = 10f;

	[Property, Range( -360f, 360f )] public float WindDirectionDegrees { get; set; } = 20f;

	/// <summary>Distance from shoreline (km).</summary>
	[Property] public float FetchLength { get; set; } = 150f;

	[Property, Range( 0f, 2f )] public float Swell { get; set; } = 0.8f;
	[Property, Range( 0f, 1f )] public float Spread { get; set; } = 0.2f;
	[Property, Range( 0f, 1f )] public float Detail { get; set; } = 1f;
	[Property, Range( 0f, 2f )] public float Whitecap { get; set; } = 0.5f;
	[Property, Range( 0f, 10f )] public float FoamAmount { get; set; } = 5f;

	public Vector2 SpectrumSeed { get; set; }
	public bool ShouldGenerateSpectrum { get; set; } = true;
	public float Time { get; set; }
	public float FoamGrowRate { get; set; }
	public float FoamDecayRate { get; set; }

	public void EnsureSeed( Random random )
	{
		if ( SpectrumSeed == Vector2.Zero )
			SpectrumSeed = new Vector2( random.Next( -10000, 10000 ), random.Next( -10000, 10000 ) );
	}

	public void MarkSpectrumDirty() => ShouldGenerateSpectrum = true;

	/// <summary>
	/// xy = UV scale in world units, z = displacement scale in world units, w = normal scale.
	/// </summary>
	public Vector4 GetMapScale( float unitsPerMeter )
	{
		var units = MathF.Max( unitsPerMeter, 0.001f );
		var tileX = MathF.Max( TileLength.x, 0.001f ) * units;
		var tileY = MathF.Max( TileLength.y, 0.001f ) * units;
		return new Vector4( 1f / tileX, 1f / tileY, DisplacementScale * units, NormalScale );
	}

	/// <summary>GodotOceanWaves main.tscn cascade 0 (large swell).</summary>
	public static OceanFftCascadeParameters CreateDefaultLarge() => new()
	{
		TileLength = new Vector2( 88f, 88f ),
		DisplacementScale = 1f,
		NormalScale = 1f,
		WindSpeed = 10f,
		WindDirectionDegrees = 20f,
		FetchLength = 150f,
		Swell = 0.8f,
		Spread = 0.2f,
		Detail = 1f,
		Whitecap = 0.5f,
		FoamAmount = 8f,
	};

	/// <summary>GodotOceanWaves main.tscn cascade 1 (mid chop).</summary>
	public static OceanFftCascadeParameters CreateDefaultMedium() => new()
	{
		TileLength = new Vector2( 57f, 57f ),
		DisplacementScale = 0.75f,
		NormalScale = 1f,
		WindSpeed = 5f,
		WindDirectionDegrees = 15f,
		FetchLength = 150f,
		Swell = 0.8f,
		Spread = 0.4f,
		Detail = 1f,
		Whitecap = 0.5f,
		FoamAmount = 0f,
	};

	/// <summary>GodotOceanWaves main.tscn cascade 2 (high-frequency normals / foam detail).</summary>
	public static OceanFftCascadeParameters CreateDefaultDetail() => new()
	{
		TileLength = new Vector2( 16f, 16f ),
		DisplacementScale = 0f,
		NormalScale = 0.25f,
		WindSpeed = 20f,
		WindDirectionDegrees = 20f,
		FetchLength = 550f,
		Swell = 0.8f,
		Spread = 0.4f,
		Detail = 1f,
		Whitecap = 0.25f,
		FoamAmount = 3f,
	};
}
