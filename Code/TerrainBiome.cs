using Sandbox.Components.SingletonComponents;

namespace Sandbox;

public static class TerrainBiome
{
	public static Color GetColorFromHeight(
		WorldManagerSingletonComponent worldManager,
		float height,
		float slope )
	{
		var sample = GetBiomeSampleFromHeight( worldManager, height );

		if ( InRange( sample, worldManager.WaterMinThreshold, worldManager.WaterMaxThreshold ) )
			return worldManager.WaterColor;

		if ( slope >= worldManager.SharpSlopeThreshold )
			return worldManager.MountainColor;

		if ( InRange( sample, worldManager.SandMinThreshold, worldManager.SandMaxThreshold ) )
			return worldManager.SandColor;

		if ( InRange( sample, worldManager.GrassMinThreshold, worldManager.GrassMaxThreshold ) )
			return worldManager.GrassColor;

		if ( InRange( sample, worldManager.MountainMinThreshold, worldManager.MountainMaxThreshold ) )
			return worldManager.MountainColor;

		return worldManager.GrassColor;
	}

	public static float GetBiomeSampleFromHeight( WorldManagerSingletonComponent worldManager, float height )
	{
		if ( worldManager.HeightNoiseAmplitude <= 0.0001f )
			return -1f;

		var normalized = (height - worldManager.WaterLevel) / worldManager.HeightNoiseAmplitude;
		return MathX.Clamp( normalized * 2f - 1f, -1f, 1f );
	}

	public static Color32 GetSideColor( Color32 topColor )
	{
		var color = topColor.ToColor();
		return (color * 0.65f).WithAlpha( 1f ).ToColor32();
	}

	static bool InRange( float sample, float min, float max )
	{
		var low = MathF.Min( min, max );
		var high = MathF.Max( min, max );
		return sample >= low && sample <= high;
	}
}
