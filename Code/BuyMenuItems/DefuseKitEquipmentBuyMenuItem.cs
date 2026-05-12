using Sandbox.Components.PawnComponents;

namespace Sandbox.BuyMenuItems;

public class DefuseKitEquipmentBuyMenuItem : BuyMenuItem
{
	public DefuseKitEquipmentBuyMenuItem( string id, string name, string icon )
	{
		Id = id;
		Name = name;
		Icon = icon;
	}

	public override int GetPrice( PlayerPawnComponent player ) => 400;

	protected override void OnPurchase( PlayerPawnComponent player )
	{
		player.Inventory.HasDefuseKit = true;
	}

	public override bool IsVisible( PlayerPawnComponent player ) => player.Team == Team.CounterTerrorist;

	public override bool IsOwned( PlayerPawnComponent player ) => player.Inventory.HasDefuseKit;
}