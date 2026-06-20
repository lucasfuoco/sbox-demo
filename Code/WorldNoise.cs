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

	public float GetHeight( float x, float y, float amplitude, float falloff = 1f )
	{
		var detail = (HeightNoise.GetNoise( x, y ) + 1f) * 0.5f;
		return detail * amplitude * falloff;
	}
}
