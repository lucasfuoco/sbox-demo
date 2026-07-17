using Sandbox;
using Sandbox.Rendering;

namespace RedSnail.WaterTool;

[Title("Simple Fog")]
[Category("Post Processing")]
[Icon("foggy")]
public sealed class SimpleFog : BasePostProcess<SimpleFog>
{
	[Property] public Color Color { get; set; } = Color.White;
	[Property, Range(0, 1)] public float Intensity { get; set; } = 0.01f;
	[Property, Range(0, 1)] public float Opacity { get; set; } = 0.5f;



	public override void Render()
	{
		float opacity = GetWeighted(x => x.Opacity);

		// Fall back to local values when volume weighting returns zero.
		if (opacity.AlmostEqual(0.0f))
			opacity = Opacity;

		if (opacity.AlmostEqual(0.0f))
			return;

		var color = GetWeighted(x => x.Color);
		var intensity = GetWeighted(x => x.Intensity);
		if (intensity.AlmostEqual(0.0f))
			intensity = Intensity;

		Attributes.Set("Color", color.a.AlmostEqual(0.0f) && color.r.AlmostEqual(0.0f) ? Color : color);
		Attributes.Set("Intensity", intensity);
		Attributes.Set("Opacity", opacity);

		Material shader = Material.FromShader("pp_simplefog");
		BlitMode blit = BlitMode.WithBackbuffer(shader, Stage.BeforePostProcess, 60);
		Blit(blit, "Simple Fog");
	}
}
