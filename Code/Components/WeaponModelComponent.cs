namespace Sandbox.Components;

public abstract class WeaponModelComponent : Component
{
	[Property] public SkinnedModelRenderer ModelRenderer { get; set; }

	[Property]
	public GameObject Muzzle { get; set; }

	[Property]
	public GameObject EjectionPort { get; set; }

	public void Deploy()
	{
		ModelRenderer.Set( "b_deploy", true );
	}

}
