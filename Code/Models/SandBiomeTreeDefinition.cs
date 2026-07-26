namespace Sandbox.Models;

[GameResource(
	"Sand Biome Tree Definition",
	"sandtree",
	"Deterministic placement rules for trees growing in the sand biome." )]
public sealed class SandBiomeTreeDefinition : GameResource
{
	[Property, Group( "Asset" ), Description( "Prefab cloned for each procedural tree." )]
	public GameObject TreePrefab { get; set; }

	[Property, Group( "Asset" )]
	public Model TreeModel { get; set; }

	[Property, Group( "Asset" )]
	public Model BillboardModel { get; set; }

	[Property, Group( "Asset" ), Range( 1000f, 100000f )]
	public float BillboardDistance { get; set; } = 14000f;

	[Property, Group( "Debug" ), Description( "Always show the billboard LOD, even up close." )]
	public bool ForceBillboard { get; set; }

	[Property, Group( "Distribution" ), Range( 1, 32 )]
	public int MaxTreesPerChunk { get; set; } = 8;

	[Property, Group( "Distribution" ), Range( 64f, 8192f )]
	public float MinimumSpacing { get; set; } = 1400f;

	[Property, Group( "Distribution" ), Range( 0f, 1f )]
	public float BaseSpawnChance { get; set; } = 0.38f;

	[Property, Group( "Distribution" ), Range( 128f, 65536f )]
	public float ClusterScale { get; set; } = 9000f;

	[Property, Group( "Ecology" ), Range( 0f, 1f ), Description( "Minimum sand blend weight. This world's sand band is narrow, so keep this modest." )]
	public float MinSandWeight { get; set; } = 0.28f;

	[Property, Group( "Ecology" ), Range( 0f, 64f ), Description( "Max height gradient (rise / run). Large worlds need higher values." )]
	public float MaxSlope { get; set; } = 12f;

	[Property, Group( "Ecology" ), Range( 1f, 65536f ), Description( "Heights within this distance of water are treated as moist sand." )]
	public float MoistureHeightRange { get; set; } = 12000f;

	[Property, Group( "Variation" ), Range( 1f, 512f ), Description( "Minimum uniform world scale. Source mesh is ~1.5 units tall." )]
	public float ScaleMin { get; set; } = 72f;

	[Property, Group( "Variation" ), Range( 1f, 512f ), Description( "Maximum uniform world scale." )]
	public float ScaleMax { get; set; } = 110f;

	[Property, Group( "Physics" )]
	public bool EnableCollision { get; set; } = true;
}
