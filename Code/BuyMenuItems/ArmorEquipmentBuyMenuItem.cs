using Sandbox.Components.PawnComponents;

namespace Sandbox.BuyMenuItems;

public class ArmorEquipmentBuyMenuItem : BuyMenuItem
{
	public ArmorEquipmentBuyMenuItem( string id, string name, string icon )
	{
		Id = id;
		Name = name;
		Icon = icon;
	}

	public override int GetPrice( PlayerPawnComponent player ) => 650;

	protected override void OnPurchase( PlayerPawnComponent player )
	{
		player.ArmorComponent.Armor = player.ArmorComponent.MaxArmor;
	}

	public override bool IsOwned( PlayerPawnComponent player ) => player.ArmorComponent.Armor == player.ArmorComponent.MaxArmor;
}