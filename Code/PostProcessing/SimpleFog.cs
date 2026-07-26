using Sandbox.Rendering;

namespace Sandbox.PostProcessing;

[Title( "Simple Fog" ), Category( "Post Processing" ), Icon( "foggy" )]
public sealed class SimpleFog : BasePostProcess<SimpleFog>
{
	[Property] public Color Color { get; set; } = Color.White;
	[Property, Range( 0, 1 )] public float Intensity { get; set; } = 0.01f;
	[Property, Range( 0, 1 )] public float Opacity { get; set; } = 0.5f;

	Material _material;

	public override void Render()
	{
		var opacity = GetWeighted( x => x.Opacity );
		if ( opacity.AlmostEqual( 0f ) )
			opacity = Opacity;
		if ( opacity.AlmostEqual( 0f ) )
			return;

		var color = GetWeighted( x => x.Color );
		var intensity = GetWeighted( x => x.Intensity );
		if ( intensity.AlmostEqual( 0f ) )
			intensity = Intensity;

		Attributes.Set( "Color", color.a.AlmostEqual( 0f ) && color.r.AlmostEqual( 0f ) ? Color : color );
		Attributes.Set( "Intensity", intensity );
		Attributes.Set( "Opacity", opacity );

		_material ??= Material.FromShader( "pp_simplefog" );
		var blit = BlitMode.WithBackbuffer( _material, Stage.BeforePostProcess, 60 );
		Blit( blit, "Simple Fog" );
	}
}
