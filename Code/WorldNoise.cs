namespace Sandbox;

public sealed class WorldNoise
{
	public FastNoiseLite HeightNoise { get; }

	public WorldNoise(
		int seed,
		float heightFrequency,
		int heightOctaves,
		float lacunarity,
		float gain,
		float weightedStrength )
	{
		HeightNoise = new FastNoiseLite();
		HeightNoise.SetSeed( seed );
		HeightNoise.SetNoiseType( FastNoiseLite.NoiseType.OpenSimplex2 );
		HeightNoise.SetFrequency( heightFrequency );
		HeightNoise.SetFractalType( FastNoiseLite.FractalType.FBm );
		HeightNoise.SetFractalOctaves( heightOctaves );
		HeightNoise.SetFractalLacunarity( lacunarity );
		HeightNoise.SetFractalGain( gain );
		HeightNoise.SetFractalWeightedStrength( weightedStrength );
	}

	/// <summary>
	/// Continental profile: low noise = ocean, mid = flat land, high (land centers) = mountain peaks.
	/// </summary>
	/// <param name="plainsLevel">Fraction of amplitude for the flat land shelf (0-1).</param>
	/// <param name="mountainStart">Continent value where mountains begin; higher = peaks only inland.</param>
	/// <param name="peakPower">Shapes the mountain ramp above mountainStart. Higher = sharper peaks.</param>
	public float GetHeight(
		float x,
		float y,
		float amplitude,
		float falloff = 1f,
		float plainsLevel = 0.4f,
		float mountainStart = 0.65f,
		float peakPower = 1.6f )
	{
		var continent = MathX.Clamp( (HeightNoise.GetNoise( x, y ) + 1f) * 0.5f, 0f, 1f );
		plainsLevel = MathX.Clamp( plainsLevel, 0.05f, 0.85f );
		mountainStart = MathX.Clamp( mountainStart, 0.2f, 0.95f );
		peakPower = MathF.Max( peakPower, 1f );

		// Soft rise out of the ocean into a flat coastal / inland shelf.
		var landEdge = MathF.Max( mountainStart * 0.42f, 0.18f );
		float plains;
		if ( continent <= landEdge )
		{
			var oceanT = continent / MathF.Max( landEdge, 0.0001f );
			plains = oceanT * plainsLevel * 0.45f;
		}
		else
		{
			var shelfEnd = mountainStart;
			var plainsT = MathX.Clamp( (continent - landEdge) / MathF.Max( shelfEnd - landEdge, 0.0001f ), 0f, 1f );
			// Smoothstep then ease toward the plateau so mid-land stays flat.
			plainsT = plainsT * plainsT * (3f - 2f * plainsT);
			plainsT = MathF.Pow( plainsT, 0.65f );
			plains = MathX.Lerp( plainsLevel * 0.55f, plainsLevel, plainsT );
		}

		// Peaks only where continent is high = toward the center of each landmass.
		var mountain = 0f;
		if ( continent > mountainStart )
		{
			var m = (continent - mountainStart) / MathF.Max( 1f - mountainStart, 0.0001f );
			m = MathF.Pow( m, peakPower );
			mountain = m * (1f - plainsLevel);
		}

		return (plains + mountain) * amplitude * falloff;
	}
}
