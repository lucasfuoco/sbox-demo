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

	public static (Color32 Blend, Color32 Tint) GetBlendPaint(
		float sample,
		float slope,
		float sharpSlopeThreshold,
		float waterMin,
		float waterMax,
		float sandMin,
		float sandMax,
		float grassMin,
		float grassMax,
		float mountainMin,
		float mountainMax,
		Color waterColor,
		float soft = 0.12f )
	{
		var waterWeight = WeightInRange( sample, waterMin, waterMax, soft );
		var sandWeight = WeightInRange( sample, sandMin, sandMax, soft );
		var grassWeight = WeightInRange( sample, grassMin, grassMax, soft );
		var rockWeight = WeightInRange( sample, mountainMin, mountainMax, soft );

		if ( slope >= sharpSlopeThreshold )
		{
			var slopeBlend = MathX.Clamp( (slope - sharpSlopeThreshold) / sharpSlopeThreshold, 0f, 1f );
			rockWeight = MathF.Max( rockWeight, slopeBlend );
			grassWeight *= 1f - slopeBlend;
			sandWeight *= 1f - slopeBlend * 0.5f;
		}
		else if ( slope >= sharpSlopeThreshold * 0.5f )
		{
			var slopeBlend = MathX.Clamp(
				(slope - sharpSlopeThreshold * 0.5f) / (sharpSlopeThreshold * 0.5f),
				0f,
				1f ) * 0.5f;
			rockWeight = MathF.Max( rockWeight, slopeBlend );
			grassWeight *= 1f - slopeBlend;
		}

		var landTotal = grassWeight + sandWeight + rockWeight;
		if ( landTotal <= 0.0001f )
		{
			grassWeight = 1f;
			landTotal = 1f;
		}

		grassWeight /= landTotal;
		sandWeight /= landTotal;
		rockWeight /= landTotal;

		var blend = new Color(
			MathX.Clamp( grassWeight, 0f, 1f ),
			MathX.Clamp( sandWeight, 0f, 1f ),
			MathX.Clamp( rockWeight, 0f, 1f ),
			1f );

		var tint = Color.White;
		if ( waterWeight > 0.01f )
			tint = Color.Lerp( Color.White, waterColor, MathX.Clamp( waterWeight, 0f, 1f ) );

		return (blend.ToColor32(), tint.ToColor32());
	}

	public static (Color32 Blend, Color32 Tint) GetSideBlendPaint()
	{
		return (
			new Color( 0.05f, 0.05f, 0.9f, 1f ).ToColor32(),
			new Color( 0.65f, 0.65f, 0.65f, 1f ).ToColor32() );
	}

	public static Color32 ApplyMacroTint( Color32 tint, float worldX, float worldY, float variationScale, float strength )
	{
		var color = tint.ToColor();
		var macro = GetMacroTintFactor( worldX, worldY, variationScale, strength );
		return (color * macro).WithAlpha( color.a ).ToColor32();
	}

	static Color GetMacroTintFactor( float worldX, float worldY, float variationScale, float strength )
	{
		var scale = 1f / MathF.Max( variationScale, 1f );
		var patch = Hash01( worldX * scale, worldY * scale );
		var detail = Hash01( worldX * scale * 2.17f + 17.3f, worldY * scale * 1.91f - 9.7f );
		var combined = patch * 0.65f + detail * 0.35f;
		var offset = (combined - 0.5f) * 2f * strength;
		var factor = 1f + offset;
		return new Color( factor, factor, factor );
	}

	static float Hash01( float x, float y )
	{
		var value = MathF.Sin( x * 12.9898f + y * 78.233f ) * 43758.5453f;
		return value - MathF.Floor( value );
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
