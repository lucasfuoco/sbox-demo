using RedSnail.WaterTool;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

/// <summary>
/// Keeps the ocean WaterBody / WaterBodyRenderer aligned to the terrain ocean biome shoreline
/// (or hydrology water level), and prevents the volume from collapsing to zero size.
/// </summary>
[Title( "Ocean Water Volume Controller" ), Category( "World Simulation" ), Icon( "straighten" )]
public sealed class OceanWaterVolumeControllerComponent : Component, Component.ExecuteInEditor
{
	public enum SurfaceAlignMode
	{
		/// <summary>Match the top of the water biome band (WaterMaxThreshold → world height).</summary>
		BiomeShoreline,
		/// <summary>Match WorldManager.WaterLevel (hydrology ocean plane).</summary>
		WaterLevel
	}

	[Property, Group( "Setup" ), Title( "Water Body" )]
	public WaterBody WaterBody { get; set; }

	[Property, Group( "Setup" ), Title( "Water Renderer" )]
	public WaterBodyRenderer WaterRenderer { get; set; }

	[Property, Group( "Setup" ), Title( "World Manager" )]
	public WorldManagerSingletonComponent TerrainWorld { get; set; }

	[Property, Group( "Alignment" ), Title( "Align Surface To" )]
	public SurfaceAlignMode AlignTo { get; set; } = SurfaceAlignMode.BiomeShoreline;

	[Property, Group( "Alignment" ), Title( "Auto Align Z" )]
	public bool AutoAlignZ { get; set; } = true;

	[Property, Group( "Size" ), Title( "Width" ), Range( 1000f, 5_000_000f )]
	public float Width { get; set; } = 1_000_000f;

	[Property, Group( "Size" ), Title( "Length" ), Range( 1000f, 5_000_000f )]
	public float Length { get; set; } = 1_000_000f;

	[Property, Group( "Size" ), Title( "Depth" ), Range( 100f, 100_000f )]
	public float Depth { get; set; } = 20_000f;

	[Property, Group( "Size" ), Title( "Visual Depth" ), Range( 50f, 5000f )]
	public float VisualDepth { get; set; } = 450f;

	float _lastSurfaceZ = float.NaN;

	protected override void OnEnabled()
	{
		ApplyAll();
	}

	protected override void OnStart()
	{
		ApplyAll();
	}

	protected override void OnUpdate()
	{
		Resolve();

		if ( AutoAlignZ )
		{
			var targetZ = GetTargetSurfaceZ();
			if ( float.IsNaN( _lastSurfaceZ ) || MathF.Abs( targetZ - _lastSurfaceZ ) > 0.5f )
				ApplySurfaceHeight( targetZ );
		}

		if ( Game.IsEditor && !Game.IsPlaying && WaterBody.IsValid()
		     && WaterBody.SceneVolume.GetBounds().Size.Length < 1f )
		{
			ApplyBounds();
		}
	}

	protected override void DrawGizmos()
	{
		if ( !Gizmo.IsSelected )
			return;

		var half = new Vector3( Width, Length, Depth ) * 0.5f;
		var localBox = new BBox( -half, half );
		var offset = new Vector3( 0f, 0f, -Depth * 0.5f );
		var world = WorldTransform;

		Gizmo.Draw.Color = Color.Cyan.WithAlpha( 0.9f );
		Gizmo.Draw.LineBBox( new BBox(
			world.PointToWorld( localBox.Mins + offset ),
			world.PointToWorld( localBox.Maxs + offset ) ) );

		// Surface marker at the biome / water-level plane.
		Gizmo.Draw.Color = Color.Yellow;
		var surface = WorldPosition;
		Gizmo.Draw.Line( surface + new Vector3( -512, 0, 0 ), surface + new Vector3( 512, 0, 0 ) );
		Gizmo.Draw.Line( surface + new Vector3( 0, -512, 0 ), surface + new Vector3( 0, 512, 0 ) );
	}

	void Resolve()
	{
		WaterBody ??= Components.Get<WaterBody>( FindMode.EverythingInSelfAndDescendants );
		WaterRenderer ??= Components.Get<WaterBodyRenderer>( FindMode.EverythingInSelfAndDescendants );
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

	/// <summary>
	/// Inverse of <see cref="WorldManagerSingletonComponent.GetBiomeSampleFromHeight"/>.
	/// </summary>
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
			var local = WorldPosition;
			local.z = worldSurfaceZ;
			// Convert desired world Z into local Z under Map (or whatever parent).
			var parentWorld = parent.WorldPosition;
			GameObject.LocalPosition = new Vector3(
				GameObject.LocalPosition.x,
				GameObject.LocalPosition.y,
				worldSurfaceZ - parentWorld.z );
		}
		else
		{
			var pos = WorldPosition;
			pos.z = worldSurfaceZ;
			WorldPosition = pos;
		}

		_lastSurfaceZ = worldSurfaceZ;

		if ( WaterRenderer.IsValid() )
			WaterRenderer.GameObject.LocalPosition = Vector3.Zero;
	}

	public void ApplyBounds()
	{
		Resolve();

		if ( !WaterBody.IsValid() )
			return;

		var half = new Vector3( Width, Length, Depth ) * 0.5f;
		var bounds = new BBox( -half, half );

		// Top face of the volume = Ocean world Z (water surface / biome shoreline).
		WaterBody.GameObject.LocalPosition = new Vector3( 0f, 0f, -Depth * 0.5f );
		WaterBody.SetBounds( bounds );
		WaterBody.WaterType = WaterBodyType.Ocean;

		if ( WaterRenderer.IsValid() )
		{
			WaterRenderer.GameObject.LocalPosition = Vector3.Zero;
			WaterRenderer.Width = Width;
			WaterRenderer.Length = Length;
			WaterRenderer.Depth = VisualDepth;
			WaterRenderer.WaterType = WaterBodyType.Ocean;
			WaterRenderer.UseHybridInclusionBounds = true;
		}
	}
}
