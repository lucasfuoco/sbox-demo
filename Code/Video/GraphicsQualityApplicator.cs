using Sandbox.Components;
using Sandbox.GameObjectSystems;
using Sandbox.Renderers;

namespace Sandbox.Video;

/// <summary>
/// Applies a <see cref="GraphicsQualityProfile"/> to engine RenderSettings and live game systems.
/// Controllers/managers remain authoritative for their own state; this only copies budgets.
/// </summary>
public static class GraphicsQualityApplicator
{
	public static void Apply( GraphicsQualityProfile profile, GameSettings settings )
	{
		if ( profile is null || settings is null )
			return;

		ApplyEngine( profile, settings );
		ApplyToScene( Game.ActiveScene, profile );
	}

	public static void ApplyEngine( GraphicsQualityProfile profile, GameSettings settings )
	{
		try
		{
			var rs = Application.RenderSettings;
			if ( rs is null )
				return;

			rs.VSync = settings.VSync;
			rs.MaxFrameRate = settings.MaxFrameRate;
			rs.ShadowQuality = settings.ShadowQuality;
			rs.TextureQuality = settings.TextureQuality;
			rs.PostProcessQuality = settings.PostProcessQuality;
			rs.VolumetricFogQuality = settings.VolumetricFogQuality;
			// RenderSettings is null in editor; setters push through when available in standalone.
		}
		catch ( Exception e )
		{
			Log.Warning( $"[Video] RenderSettings apply skipped: {e.Message}" );
		}
	}

	public static void ApplyToScene( Scene scene, GraphicsQualityProfile profile )
	{
		if ( scene is null || profile is null )
			return;

		ApplyTerrain( scene, profile );
		ApplyOcean( scene, profile );
		ApplyWeather( scene, profile );
	}

	static void ApplyTerrain( Scene scene, GraphicsQualityProfile profile )
	{
		foreach ( var streamer in scene.GetAllComponents<ChunkStreamerComponent>() )
		{
			if ( !streamer.IsValid() )
				continue;

			streamer.Resolution = profile.TerrainResolution;
			streamer.ViewDistance = profile.TerrainViewDistance;
			streamer.MaxConcurrentBuilds = profile.TerrainMaxConcurrentBuilds;
			streamer.ChunksPerFrame = profile.TerrainChunksPerFrame;
		}
	}

	static void ApplyOcean( Scene scene, GraphicsQualityProfile profile )
	{
		var ocean = scene.GetSystem<OceanFftManager>();
		ocean?.ApplyQualityBudget( profile.OceanMapSize, profile.OceanUpdatesPerSecond, profile.OceanSeaSpray );

		foreach ( var surface in scene.GetAllComponents<OceanSurfaceRenderer>() )
		{
			if ( !surface.IsValid() )
				continue;

			surface.BaseCellSize = profile.OceanBaseCellSize;
			surface.CellsPerRing = profile.OceanCellsPerRing;
		}
	}

	static void ApplyWeather( Scene scene, GraphicsQualityProfile profile )
	{
		foreach ( var clouds in scene.GetAllComponents<WeatherVolumeCloudRendererComponent>() )
		{
			if ( !clouds.IsValid() )
				continue;

			clouds.CloudAmount = profile.CloudAmount;
			clouds.CastShadows = false;
			clouds.ReceiveLighting = false;
		}

		foreach ( var rain in scene.GetAllComponents<WeatherVolumeRainComponent>() )
		{
			if ( !rain.IsValid() )
				continue;

			rain.RainIntensity = profile.RainIntensity;
			rain.EnableSplashes = profile.RainSplashes;
			rain.Strength = profile.RainStrength;
		}
	}
}
