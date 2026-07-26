using Sandbox.Rendering;

namespace Sandbox.PostProcessing;

[Title( "Wobble Effect" ), Category( "Post Processing" ), Icon( "waves" )]
public sealed class WobbleEffect : BasePostProcess<WobbleEffect>
{
	[Property, Range( 0.1f, 100f )] public float Frequency { get; set; } = 20f;
	[Property, Range( 0.1f, 10f )] public float Amplitude { get; set; } = 1f;
	[Property, Range( 0.1f, 10f )] public float Speed { get; set; } = 1f;

	Material _material;

	public override void Render()
	{
		var amplitude = GetWeighted( x => x.Amplitude );
		if ( amplitude.AlmostEqual( 0f ) )
			return;

		Attributes.Set( "Frequency", Frequency );
		Attributes.Set( "Amplitude", amplitude );
		Attributes.Set( "Speed", Speed );

		_material ??= Material.FromShader( "pp_wobble" );
		var blit = BlitMode.WithBackbuffer( _material, Stage.BeforePostProcess, 70 );
		Blit( blit, "Wobble Effect" );
	}
}
