using System.Collections.Generic;

namespace Sandbox.Ocean;

/// <summary>
/// FFT ocean spectrum settings (cascades + map resolution).
/// Based on GodotOceanWaves (MIT).
/// </summary>
[AssetType( Name = "Ocean FFT Definition", Extension = "fftwater", Category = "Water" )]
public sealed class OceanFftDefinition : GameResource
{
	public const int MaxCascades = 4;

	/// <summary>
	/// Source/S&box worlds are typically inches. Spectrum math stays in meters;
	/// this converts tile size + displacement into world units (39.37 ≈ inches/meter).
	/// </summary>
	[Property, Title( "Units Per Meter" ), Description( "World units per spectrum meter. ~39.37 = Source inches (Godot uses meters)." )]
	public float UnitsPerMeter { get; set; } = 39.3700787f;

	[Property, Title( "Map Size" ), Description( "Power-of-two spectrum resolution. 128 is the performance default; 256 looks sharper." )]
	public int MapSize { get; set; } = 128;

	[Property, Title( "Updates Per Second" ), Range( 0f, 60f ), Description( "Wave sim rate. Cascades are load-balanced (one cascade per tick)." )]
	public float UpdatesPerSecond { get; set; } = 15f;

	[Property, Title( "Cascades" )]
	public List<OceanFftCascadeParameters> Cascades { get; set; } = CreateDefaultCascades();

	public int ResolvedMapSize
	{
		get
		{
			var size = MapSize;
			if ( size < 64 ) size = 64;
			if ( size > 256 ) size = 256;
			var pot = 64;
			while ( pot * 2 <= size )
				pot *= 2;
			return pot;
		}
	}

	public bool HasCascades => Cascades is { Count: > 0 };

	/// <summary>Matches GodotOceanWaves main.tscn (3 layered cascades).</summary>
	public static List<OceanFftCascadeParameters> CreateDefaultCascades() => new()
	{
		OceanFftCascadeParameters.CreateDefaultLarge(),
		OceanFftCascadeParameters.CreateDefaultMedium(),
		OceanFftCascadeParameters.CreateDefaultDetail(),
	};

	/// <summary>In-memory profile when no .fftwater asset is assigned/loaded.</summary>
	public static OceanFftDefinition CreateRuntimeDefault()
	{
		return new OceanFftDefinition
		{
			MapSize = 256,
			UpdatesPerSecond = 30f,
			UnitsPerMeter = 39.3700787f,
			Cascades = CreateDefaultCascades(),
		};
	}

	protected override void PostLoad()
	{
		base.PostLoad();
		if ( Cascades is null || Cascades.Count == 0 )
			Cascades = CreateDefaultCascades();
	}

	protected override void PostReload()
	{
		base.PostReload();
		if ( Cascades is null || Cascades.Count == 0 )
			Cascades = CreateDefaultCascades();
	}

	protected override Bitmap CreateAssetTypeIcon( int width, int height )
	{
		return CreateSimpleAssetTypeIcon( "water", width, height, "#1e88e5", "white" );
	}
}
