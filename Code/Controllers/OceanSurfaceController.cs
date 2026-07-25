namespace Sandbox.Controllers;

/// <summary>
/// Ocean gameplay state: calm surface height, horizontal extent, containment queries.
/// Presentation is handled by <see cref="Renderers.OceanSurfaceRenderer"/>.
/// </summary>
[Title( "Ocean Surface Controller" ), Category( "Water" ), Icon( "water" )]
public sealed class OceanSurfaceController : Component, Component.ExecuteInEditor
{
	[Property, Group( "Size" ), Range( 1000f, 5_000_000f )]
	public float Width { get; set; } = 1_000_000f;

	[Property, Group( "Size" ), Range( 1000f, 5_000_000f )]
	public float Length { get; set; } = 1_000_000f;

	[Property, Group( "Size" ), Range( 100f, 100_000f )]
	public float Depth { get; set; } = 20_000f;

	/// <summary>Calm ocean plane Z (world). Wave displacement is visual-only unless sampled later.</summary>
	public float SurfaceHeight => WorldPosition.z;

	public static OceanSurfaceController FindOcean( Scene scene )
		=> scene?.GetAllComponents<OceanSurfaceController>().FirstOrDefault();

	public bool ContainsPointXY( Vector3 position )
	{
		var halfW = Width * 0.5f;
		var halfL = Length * 0.5f;
		var local = WorldTransform.PointToLocal( position );
		return local.x >= -halfW && local.x <= halfW && local.y >= -halfL && local.y <= halfL;
	}

	public bool ContainsPointInVolume( Vector3 position )
	{
		if ( !ContainsPointXY( position ) )
			return false;

		var surface = SurfaceHeight;
		return position.z <= surface && position.z >= surface - Depth;
	}

	/// <summary>Calm surface height. FFT displacement is GPU-only for now (matches prior Gerstner-physics split).</summary>
	public float GetCalmSurfaceHeight() => SurfaceHeight;

	public float GetWaveHeightAt( Vector3 position ) => SurfaceHeight;

	public static float GetWaterHeightAt( Scene scene, Vector3 position )
	{
		var ocean = FindOcean( scene );
		if ( ocean is null || !ocean.IsValid() )
			return float.MinValue;

		if ( !ocean.ContainsPointXY( position ) )
			return float.MinValue;

		return ocean.GetWaveHeightAt( position );
	}

	public static bool IsPositionInsideAny( Scene scene, Vector3 position )
	{
		var ocean = FindOcean( scene );
		return ocean.IsValid() && ocean.ContainsPointInVolume( position );
	}
}
