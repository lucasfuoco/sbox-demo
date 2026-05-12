using Sandbox;
using Sandbox.BuyMenuItems;
using Sandbox.Components.PawnComponents;

namespace Sandbox;

public abstract class BuyMenuItem
{
	public string Id { get; protected init; }
	public string Name { get; protected init; }
	public string Icon { get; protected init; }
	public virtual int GetPrice( PlayerPawnComponent player ) => 0;
	public virtual bool IsOwned( PlayerPawnComponent player ) => true;
	public virtual bool IsVisible( PlayerPawnComponent player ) => true;

	protected virtual void OnPurchase( PlayerPawnComponent player ) { }

	public void Purchase( PlayerPawnComponent player )
	{
		if ( IsOwned( player ) ) return;

		var price = GetPrice( player );
		player.Client.GiveCash( -price );
		OnPurchase( player );
	}

	public static IEnumerable<BuyMenuItem> GetAll()
	{
		return new List<BuyMenuItem>
		{
			new ArmorEquipmentBuyMenuItem( "kevlar", "Kevlar", "/ui/equipment/armor.png" ),
			new ArmorWithHelmetEquipmentBuyMenuItem( "kevlar_helmet", "Kevlar + Helmet", "/ui/equipment/helmet.png" ),
			new DefuseKitEquipmentBuyMenuItem( "defuse_kit", "Defuse Kit", "/ui/equipment/defusekit.png" )
		};
	}

	public static BuyMenuItem GetById( string id )
	{
		return GetAll().FirstOrDefault( x => x.Id == id );
	}
}