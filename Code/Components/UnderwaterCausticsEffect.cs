using Sandbox.Rendering;

namespace Sandbox.Components;

/// <summary>
/// Underwater post-process: blue fog fill, caustics, and light shafts.
/// Uses local property values when volume weighting returns zero so the fill
/// still works if PostProcessVolume blending fails.
/// </summary>
[Title( "Underwater Caustics" ), Category( "Post Processing" ), Icon( "water_drop" )]
public sealed class UnderwaterCausticsEffect : BasePostProcess<UnderwaterCausticsEffect>
{
	[Property] public Color WaterColor { get; set; } = new Color( 0.28f, 0.72f, 0.88f );
	[Property] public Color DeepWaterColor { get; set; } = new Color( 0.08f, 0.28f, 0.48f );
	[Property] public Color CausticsColor { get; set; } = new Color( 0.85f, 0.98f, 1.0f );
	[Property, Range( 0.001f, 0.08f )] public float FogDensity { get; set; } = 0.018f;
	[Property, Range( 0f, 1f )] public float FogOpacity { get; set; } = 0.55f;
	[Property, Range( 0f, 3f )] public float CausticsIntensity { get; set; } = 1.5f;
	[Property, Range( 0.001f, 0.05f )] public float CausticsScale { get; set; } = 0.007f;
	[Property, Range( 0f, 2f )] public float CausticsSpeed { get; set; } = 0.4f;
	[Property, Range( 50f, 12000f )] public float MaxFogDepth { get; set; } = 4500f;
	[Property, Range( 0f, 2f )] public float GodRayIntensity { get; set; } = 0.55f;
	[Property, Hide] public float SurfaceZ { get; set; }

	/// <summary>When true, always blit using this component's values (camera-local / forced fill).</summary>
	public bool ForceLocalValues { get; set; }

	Material _material;

	public override void Render()
	{
		var opacity = ForceLocalValues ? FogOpacity : GetWeighted( x => x.FogOpacity );
		if ( opacity.AlmostEqual( 0f ) )
			opacity = FogOpacity;
		if ( opacity.AlmostEqual( 0f ) )
			return;

		Color waterColor = ForceLocalValues ? WaterColor : GetWeighted( x => x.WaterColor );
		if ( waterColor.a.AlmostEqual( 0f ) && waterColor.r.AlmostEqual( 0f ) )
			waterColor = WaterColor;

		Attributes.Set( "WaterColor", waterColor );
		Attributes.Set( "DeepWaterColor", ForceLocalValues ? DeepWaterColor : GetWeighted( x => x.DeepWaterColor ) );
		Attributes.Set( "CausticsColor", ForceLocalValues ? CausticsColor : GetWeighted( x => x.CausticsColor ) );
		Attributes.Set( "FogDensity", ForceLocalValues ? FogDensity : MathF.Max( GetWeighted( x => x.FogDensity ), FogDensity * 0.5f ) );
		Attributes.Set( "FogOpacity", opacity );
		Attributes.Set( "CausticsIntensity", ForceLocalValues ? CausticsIntensity : GetWeighted( x => x.CausticsIntensity ) );
		Attributes.Set( "CausticsScale", ForceLocalValues ? CausticsScale : GetWeighted( x => x.CausticsScale ) );
		Attributes.Set( "CausticsSpeed", ForceLocalValues ? CausticsSpeed : GetWeighted( x => x.CausticsSpeed ) );
		Attributes.Set( "SurfaceZ", SurfaceZ );
		Attributes.Set( "MaxFogDepth", ForceLocalValues ? MaxFogDepth : GetWeighted( x => x.MaxFogDepth ) );
		Attributes.Set( "GodRayIntensity", ForceLocalValues ? GodRayIntensity : GetWeighted( x => x.GodRayIntensity ) );

		_material ??= Material.FromShader( "shaders/pp_underwater" );
		Blit( BlitMode.WithBackbuffer( _material, Stage.AfterPostProcess, 50, false ), "Underwater Caustics" );
	}
}
