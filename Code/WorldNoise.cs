namespace Sandbox;

public sealed class WorldNoise
{
	public FastNoiseLite HeightNoise { get; }

	public WorldNoise( int seed, float frequency, int octaves, float lacunarity )
	{
		HeightNoise = new FastNoiseLite();

		HeightNoise.SetSeed( seed );
		HeightNoise.SetNoiseType( FastNoiseLite.NoiseType.OpenSimplex2 );
		HeightNoise.SetFrequency( frequency );
		HeightNoise.SetFractalType( FastNoiseLite.FractalType.FBm );
		HeightNoise.SetFractalOctaves( octaves );
		HeightNoise.SetFractalLacunarity( lacunarity );
	}

	public float GetHeight( float x, float y, float amplitude )
	{
		return HeightNoise.GetNoise( x, y ) * amplitude;
	}
}
