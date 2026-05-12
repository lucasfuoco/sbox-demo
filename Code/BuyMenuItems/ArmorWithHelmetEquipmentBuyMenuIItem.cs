using Sandbox.Components.PawnComponents;

namespace Sandbox.BuyMenuItems;

public class ArmorWithHelmetEquipmentBuyMenuItem : BuyMenuItem
{
	public ArmorWithHelmetEquipmentBuyMenuItem( string id, string name, string icon )
	{
		Id = id;
		Name = name;
		Icon = icon;
	}

	public override int GetPrice( PlayerPawnComponent player )
	{
		if ( player.ArmorComponent.Armor == player.ArmorComponent.MaxArmor )
			return 350;

		return 1000;
	}

	protected override void OnPurchase( PlayerPawnComponent player )
	{
		player.ArmorComponent.Armor = player.ArmorComponent.MaxArmor;
		player.ArmorComponent.HasHelmet = true;
	}

	public override bool IsOwned( PlayerPawnComponent player )
	{
		return player.ArmorComponent.Armor == player.ArmorComponent.MaxArmor && player.ArmorComponent.HasHelmet;
	}
}