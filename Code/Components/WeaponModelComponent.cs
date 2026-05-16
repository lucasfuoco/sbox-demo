namespace Sandbox.Components;

public abstract class WeaponModelComponent : Component
{
	[Property] public SkinnedModelRenderer ModelRenderer { get; set; }

	[Property]
	public GameObject Muzzle { get; set; }

	[Property]
	public GameObject EjectionPort { get; set; }

	/// <summary>
	/// Weapon mesh on this root. Viewmodels also have a bone-merged arms child on <see cref="ModelRenderer"/>.
	/// </summary>
	protected SkinnedModelRenderer WeaponMeshRenderer =>
		GameObject.IsValid() ? GameObject.Components.Get<SkinnedModelRenderer>() : null;

	/// <summary>
	/// Every anim-graph renderer on this weapon model hierarchy (gun mesh + bone-merged arms, etc.).
	/// </summary>
	protected IEnumerable<SkinnedModelRenderer> GetAnimGraphRenderers()
	{
		if ( !GameObject.IsValid() )
			yield break;

		foreach ( var renderer in GameObject.Components.GetAll<SkinnedModelRenderer>( FindMode.EverythingInSelfAndDescendants ) )
		{
			if ( renderer.IsValid() && renderer.UseAnimGraph )
				yield return renderer;
		}
	}

	public void SetOnAnimGraphRenderers( string param, bool value )
	{
		foreach ( var renderer in GetAnimGraphRenderers() )
			renderer.Set( param, value );
	}

	public void SetOnAnimGraphRenderers( string param, float value )
	{
		foreach ( var renderer in GetAnimGraphRenderers() )
			renderer.Set( param, value );
	}

	public void SetOnAnimGraphRenderers( string param, int value )
	{
		foreach ( var renderer in GetAnimGraphRenderers() )
			renderer.Set( param, value );
	}

	/// <summary>
	/// Push an anim-graph parameter to the equipped viewmodel and world weapon meshes.
	/// </summary>
	public static void SetOnEquipmentAnimGraphRenderers( EquipmentComponent equipment, string param, bool value )
	{
		if ( !equipment.IsValid() )
			return;

		equipment.ViewWeaponModel?.SetOnAnimGraphRenderers( param, value );
		equipment.WorldWeaponModel?.SetOnAnimGraphRenderers( param, value );
	}

	public static void SetOnEquipmentAnimGraphRenderers( EquipmentComponent equipment, string param, float value )
	{
		if ( !equipment.IsValid() )
			return;

		equipment.ViewWeaponModel?.SetOnAnimGraphRenderers( param, value );
		equipment.WorldWeaponModel?.SetOnAnimGraphRenderers( param, value );
	}

	public static void SetOnEquipmentAnimGraphRenderers( EquipmentComponent equipment, string param, int value )
	{
		if ( !equipment.IsValid() )
			return;

		equipment.ViewWeaponModel?.SetOnAnimGraphRenderers( param, value );
		equipment.WorldWeaponModel?.SetOnAnimGraphRenderers( param, value );
	}

	public void Deploy()
	{
		SetOnAnimGraphRenderers( "b_deploy", true );
	}
}
