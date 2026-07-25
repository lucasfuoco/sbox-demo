using Sandbox.Components.SingletonComponents;
using Sandbox.Controllers;
using Sandbox.Renderers;

namespace Sandbox.Components;

/// <summary>
/// Aligns the ocean surface to the terrain biome shoreline / water level.
/// </summary>
[Title( "Ocean Water Volume Controller" ), Category( "World Simulation" ), Icon( "straighten" )]
public sealed class OceanWaterVolumeControllerComponent : Component, Component.ExecuteInEditor
{
	public enum SurfaceAlignMode
	{
		BiomeShoreline,
		WaterLevel
	}

	[Property, Group( "Setup" )] public OceanSurfaceController Ocean { get; set; }
	[Property, Group( "Setup" )] public OceanSurfaceRenderer OceanRenderer { get; set; }
	[Property, Group( "Setup" )] public WorldManagerSingletonComponent TerrainWorld { get; set; }

	[Property, Group( "Alignment" )] public SurfaceAlignMode AlignTo { get; set; } = SurfaceAlignMode.BiomeShoreline;
	[Property, Group( "Alignment" )] public bool AutoAlignZ { get; set; } = true;

	[Property, Group( "Size" ), Range( 1000f, 5_000_000f )] public float Width { get; set; } = 1_000_000f;
	[Property, Group( "Size" ), Range( 1000f, 5_000_000f )] public float Length { get; set; } = 1_000_000f;
	[Property, Group( "Size" ), Range( 100f, 100_000f )] public float Depth { get; set; } = 20_000f;
	[Property, Group( "Size" ), Range( 50f, 5000f )] public float VisualDepth { get; set; } = 450f;

	float _lastSurfaceZ = float.NaN;

	protected override void OnEnabled() => ApplyAll();
	protected override void OnStart() => ApplyAll();

	protected override void OnUpdate()
	{
		Resolve();

		if ( AutoAlignZ )
		{
			var targetZ = GetTargetSurfaceZ();
			if ( float.IsNaN( _lastSurfaceZ ) || MathF.Abs( targetZ - _lastSurfaceZ ) > 0.5f )
				ApplySurfaceHeight( targetZ );
		}

		ApplyBounds();
	}

	void Resolve()
	{
		Ocean ??= Components.Get<OceanSurfaceController>( FindMode.EverythingInSelfAndDescendants );
		OceanRenderer ??= Components.Get<OceanSurfaceRenderer>( FindMode.EverythingInSelfAndDescendants );
		TerrainWorld ??= Scene.GetAllComponents<WorldManagerSingletonComponent>().FirstOrDefault();
	}

	void ApplyAll()
	{
		Resolve();
		ApplySurfaceHeight( GetTargetSurfaceZ() );
		ApplyBounds();
	}

	public float GetTargetSurfaceZ()
	{
		Resolve();
		if ( !TerrainWorld.IsValid() )
			return WorldPosition.z;

		return AlignTo switch
		{
			SurfaceAlignMode.WaterLevel => TerrainWorld.WaterLevel,
			_ => BiomeSampleToHeight( TerrainWorld, TerrainWorld.WaterMaxThreshold )
		};
	}

	public static float BiomeSampleToHeight( WorldManagerSingletonComponent world, float sample )
	{
		var amp = MathF.Max( world.HeightNoiseAmplitude, 0.0001f );
		var normalized = (sample + 1f) * 0.5f;
		return world.WaterLevel + normalized * amp;
	}

	void ApplySurfaceHeight( float worldSurfaceZ )
	{
		var parent = GameObject.Parent;
		if ( parent.IsValid() )
		{
			GameObject.LocalPosition = new Vector3(
				GameObject.LocalPosition.x,
				GameObject.LocalPosition.y,
				worldSurfaceZ - parent.WorldPosition.z );
		}
		else
		{
			var pos = WorldPosition;
			pos.z = worldSurfaceZ;
			WorldPosition = pos;
		}

		_lastSurfaceZ = worldSurfaceZ;

		if ( OceanRenderer.IsValid() )
			OceanRenderer.GameObject.LocalPosition = Vector3.Zero;
	}

	public void ApplyBounds()
	{
		Resolve();

		if ( Ocean.IsValid() )
		{
			Ocean.Width = Width;
			Ocean.Length = Length;
			Ocean.Depth = Depth;
		}

		if ( OceanRenderer.IsValid() )
		{
			OceanRenderer.GameObject.LocalPosition = Vector3.Zero;
			OceanRenderer.Width = Width;
			OceanRenderer.Length = Length;
			OceanRenderer.Depth = VisualDepth;
		}
	}
}
