namespace Sandbox.Video;

/// <summary>
/// Snapshot of machine capabilities used to recommend a starting video quality tier.
/// Hardware cannot predict exact FPS — this only estimates a safe budget.
/// </summary>
public readonly record struct GraphicsCapabilitySnapshot(
	string GpuName,
	ulong GpuMemoryBytes,
	ulong SystemMemoryBytes,
	int ProcessorCount,
	float ProcessorFrequencyGhz,
	VideoQualityTier RecommendedTier,
	string Summary )
{
	public float GpuMemoryGb => GpuMemoryBytes / (1024f * 1024f * 1024f);
	public float SystemMemoryGb => SystemMemoryBytes / (1024f * 1024f * 1024f);
}

/// <summary>
/// Scores a Low–Ultra recommendation from whitelisted runtime hardware hints.
/// Game assemblies cannot access <c>Sandbox.Engine.SystemInfo</c> (whitelist), so detection
/// uses <see cref="Graphics.VideoMemoryBudget"/> as the primary signal.
/// </summary>
public static class GraphicsCapabilityDetector
{
	public static GraphicsCapabilitySnapshot Detect()
	{
		const string gpuName = "Detected GPU";
		ulong gpuMemory = 0;
		try
		{
			gpuMemory = Graphics.VideoMemoryBudget;
		}
		catch
		{
			// May throw outside a render context.
		}

		var tier = ScoreTier( gpuMemory );
		var summary =
			$"{gpuName} | VRAM {gpuMemory / (1024f * 1024f * 1024f):0.0} GB | Recommended {tier}";

		return new GraphicsCapabilitySnapshot(
			gpuName,
			gpuMemory,
			0,
			0,
			0f,
			tier,
			summary );
	}

	static VideoQualityTier ScoreTier( ulong gpuMemoryBytes )
	{
		var vramGb = gpuMemoryBytes / (1024.0 * 1024.0 * 1024.0);

		// Unknown VRAM — conservative Medium starting point.
		if ( vramGb <= 0 )
			return VideoQualityTier.Medium;

		if ( vramGb >= 16 )
			return VideoQualityTier.Ultra;
		if ( vramGb >= 10 )
			return VideoQualityTier.High;
		if ( vramGb >= 6 )
			return VideoQualityTier.Medium;

		return VideoQualityTier.Low;
	}
}
