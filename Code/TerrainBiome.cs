using Sandbox.Components.SingletonComponents;

namespace Sandbox;

public static class TerrainBiome
{
	public static Color GetColor(
		WorldManagerSingletonComponent worldManager,
		float worldX,
		float worldY,
		float slopeStep )
	{
		var height = worldManager.GetHeight( worldX, worldY );
		var waterLevel = worldManager.WaterLevel;

		if ( height <= waterLevel )
			return worldManager.WaterColor;

		var slope = SampleSlope( worldManager, worldX, worldY, slopeStep );
		if ( slope >= worldManager.SharpSlopeThreshold || height >= waterLevel + worldManager.MountainHeightAboveWater )
			return worldManager.MountainColor;

		if ( height <= waterLevel + worldManager.SandHeightAboveWater )
			return worldManager.SandColor;

		return worldManager.GrassColor;
	}

	public static Color32 GetSideColor( Color32 topColor )
	{
		var color = topColor.ToColor();
		return (color * 0.65f).WithAlpha( 1f ).ToColor32();
	}

	static float SampleSlope( WorldManagerSingletonComponent worldManager, float worldX, float worldY, float step )
	{
		var left = worldManager.GetHeight( worldX - step, worldY );
		var right = worldManager.GetHeight( worldX + step, worldY );
		var down = worldManager.GetHeight( worldX, worldY - step );
		var up = worldManager.GetHeight( worldX, worldY + step );

		var dx = (right - left) / (2f * step);
		var dy = (up - down) / (2f * step);
		return MathF.Sqrt( dx * dx + dy * dy );
	}
}
