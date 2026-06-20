using Sandbox.Components.SingletonComponents;

namespace Sandbox;

public static class TerrainBiome
{
	public static Color GetColorFromHeight(
		WorldManagerSingletonComponent worldManager,
		float height,
		float slope,
		bool isWater = false )
	{
		if ( isWater )
			return worldManager.WaterColor;

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

	public static Color GetSoftPreviewColorFromHeight(
		WorldManagerSingletonComponent worldManager,
		float height,
		float slope,
		bool isWater = false )
	{
		if ( isWater )
			return worldManager.WaterColor;

		var sample = GetBiomeSampleFromHeight( worldManager, height );
		const float soft = 0.12f;

		var waterWeight = WeightInRange( sample, worldManager.WaterMinThreshold, worldManager.WaterMaxThreshold, soft );
		var sandWeight = WeightInRange( sample, worldManager.SandMinThreshold, worldManager.SandMaxThreshold, soft );
		var grassWeight = WeightInRange( sample, worldManager.GrassMinThreshold, worldManager.GrassMaxThreshold, soft );
		var mountainWeight = WeightInRange( sample, worldManager.MountainMinThreshold, worldManager.MountainMaxThreshold, soft );

		var color = BlendWeightedColors(
			(worldManager.WaterColor, waterWeight),
			(worldManager.SandColor, sandWeight),
			(worldManager.GrassColor, grassWeight),
			(worldManager.MountainColor, mountainWeight) );

		if ( slope >= worldManager.SharpSlopeThreshold )
		{
			var slopeBlend = MathX.Clamp( (slope - worldManager.SharpSlopeThreshold) / worldManager.SharpSlopeThreshold, 0f, 1f );
			color = Color.Lerp( color, worldManager.MountainColor, slopeBlend );
		}
		else if ( slope >= worldManager.SharpSlopeThreshold * 0.5f )
		{
			var slopeBlend = MathX.Clamp(
				(slope - worldManager.SharpSlopeThreshold * 0.5f) / (worldManager.SharpSlopeThreshold * 0.5f),
				0f,
				1f ) * 0.5f;
			color = Color.Lerp( color, worldManager.MountainColor, slopeBlend );
		}

		return color;
	}

	public static Color32 GetSideColor( Color32 topColor )
	{
		var color = topColor.ToColor();
		return (color * 0.65f).WithAlpha( 1f ).ToColor32();
	}

	static Color BlendWeightedColors( params (Color color, float weight)[] layers )
	{
		var red = 0f;
		var green = 0f;
		var blue = 0f;
		var total = 0f;

		foreach ( var (color, weight) in layers )
		{
			if ( weight <= 0f )
				continue;

			red += color.r * weight;
			green += color.g * weight;
			blue += color.b * weight;
			total += weight;
		}

		if ( total <= 0.0001f )
			return Color.White;

		return new Color( red / total, green / total, blue / total );
	}

	static float WeightInRange( float sample, float min, float max, float soft )
	{
		var low = MathF.Min( min, max );
		var high = MathF.Max( min, max );
		var enter = SmoothStep( low - soft, low + soft, sample );
		var exit = 1f - SmoothStep( high - soft, high + soft, sample );
		return enter * exit;
	}

	static float SmoothStep( float edge0, float edge1, float value )
	{
		var range = edge1 - edge0;
		if ( range <= 0.0001f )
			return value >= edge1 ? 1f : 0f;

		var t = MathX.Clamp( (value - edge0) / range, 0f, 1f );
		return t * t * (3f - 2f * t);
	}

	static bool InRange( float sample, float min, float max )
	{
		var low = MathF.Min( min, max );
		var high = MathF.Max( min, max );
		return sample >= low && sample <= high;
	}
}
