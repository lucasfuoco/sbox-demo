using Sandbox.Engine.Settings;

namespace Sandbox.Video;

/// <summary>
/// Static budgets for each video quality tier. Controllers/managers own runtime state;
/// the applicator copies these values onto live components when settings change.
/// </summary>
public sealed class GraphicsQualityProfile
{
	public VideoQualityTier Tier { get; init; }

	// Terrain
	public int TerrainResolution { get; init; }
	public int TerrainViewDistance { get; init; }
	public int TerrainMaxConcurrentBuilds { get; init; }
	public int TerrainChunksPerFrame { get; init; }

	// Ocean
	public int OceanMapSize { get; init; }
	public float OceanUpdatesPerSecond { get; init; }
	public bool OceanSeaSpray { get; init; }
	public float OceanBaseCellSize { get; init; }
	public int OceanCellsPerRing { get; init; }

	// Weather
	public float CloudAmount { get; init; }
	public float RainIntensity { get; init; }
	public bool RainSplashes { get; init; }
	public WeatherRainStrength RainStrength { get; init; }

	// Engine RenderSettings (standalone only)
	public bool VSync { get; init; }
	public int MaxFrameRate { get; init; }
	public ShadowQuality ShadowQuality { get; init; }
	public TextureQuality TextureQuality { get; init; }
	public PostProcessQuality PostProcessQuality { get; init; }
	public VolumetricFogQuality VolumetricFogQuality { get; init; }

	public static GraphicsQualityProfile For( VideoQualityTier tier ) => tier switch
	{
		VideoQualityTier.Low => Low,
		VideoQualityTier.High => High,
		VideoQualityTier.Ultra => Ultra,
		_ => Medium,
	};

	public static readonly GraphicsQualityProfile Low = new()
	{
		Tier = VideoQualityTier.Low,
		TerrainResolution = 48,
		TerrainViewDistance = 4,
		TerrainMaxConcurrentBuilds = 3,
		TerrainChunksPerFrame = 2,
		OceanMapSize = 128,
		OceanUpdatesPerSecond = 15f,
		OceanSeaSpray = false,
		OceanBaseCellSize = 24f,
		OceanCellsPerRing = 48,
		CloudAmount = 1.0f,
		RainIntensity = 0.7f,
		RainSplashes = false,
		RainStrength = WeatherRainStrength.Light,
		VSync = true,
		MaxFrameRate = 60,
		ShadowQuality = ShadowQuality.Low,
		TextureQuality = TextureQuality.Low,
		PostProcessQuality = PostProcessQuality.Low,
		VolumetricFogQuality = VolumetricFogQuality.Low,
	};

	public static readonly GraphicsQualityProfile Medium = new()
	{
		Tier = VideoQualityTier.Medium,
		TerrainResolution = 64,
		TerrainViewDistance = 5,
		TerrainMaxConcurrentBuilds = 4,
		TerrainChunksPerFrame = 3,
		OceanMapSize = 256,
		OceanUpdatesPerSecond = 15f,
		OceanSeaSpray = true,
		OceanBaseCellSize = 16f,
		OceanCellsPerRing = 64,
		CloudAmount = 1.4f,
		RainIntensity = 1.0f,
		RainSplashes = true,
		RainStrength = WeatherRainStrength.Medium,
		VSync = true,
		MaxFrameRate = 120,
		ShadowQuality = ShadowQuality.Medium,
		TextureQuality = TextureQuality.Medium,
		PostProcessQuality = PostProcessQuality.Medium,
		VolumetricFogQuality = VolumetricFogQuality.Medium,
	};

	public static readonly GraphicsQualityProfile High = new()
	{
		Tier = VideoQualityTier.High,
		TerrainResolution = 64,
		TerrainViewDistance = 6,
		TerrainMaxConcurrentBuilds = 6,
		TerrainChunksPerFrame = 4,
		OceanMapSize = 256,
		OceanUpdatesPerSecond = 30f,
		OceanSeaSpray = true,
		OceanBaseCellSize = 16f,
		OceanCellsPerRing = 64,
		CloudAmount = 2.0f,
		RainIntensity = 1.2f,
		RainSplashes = true,
		RainStrength = WeatherRainStrength.Strong,
		VSync = false,
		MaxFrameRate = 144,
		ShadowQuality = ShadowQuality.High,
		TextureQuality = TextureQuality.High,
		PostProcessQuality = PostProcessQuality.High,
		VolumetricFogQuality = VolumetricFogQuality.High,
	};

	public static readonly GraphicsQualityProfile Ultra = new()
	{
		Tier = VideoQualityTier.Ultra,
		TerrainResolution = 96,
		TerrainViewDistance = 7,
		TerrainMaxConcurrentBuilds = 8,
		TerrainChunksPerFrame = 4,
		OceanMapSize = 256,
		OceanUpdatesPerSecond = 45f,
		OceanSeaSpray = true,
		OceanBaseCellSize = 12f,
		OceanCellsPerRing = 80,
		CloudAmount = 2.5f,
		RainIntensity = 1.45f,
		RainSplashes = true,
		RainStrength = WeatherRainStrength.Strong,
		VSync = false,
		MaxFrameRate = 240,
		ShadowQuality = ShadowQuality.High,
		TextureQuality = TextureQuality.High,
		PostProcessQuality = PostProcessQuality.High,
		VolumetricFogQuality = VolumetricFogQuality.High,
	};
}
