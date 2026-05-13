using Sandbox.Components.PawnComponents;
using Sandbox.Components.WeaponEquipmentComponents.WeaponInputActionEquipmentComponents;

namespace Sandbox;

public static class DefuseExtensions
{
	/// <summary>
	/// Helper to check if a player is planting, useful for UI.
	/// </summary>
	public static bool IsPlanting( this PlayerPawnComponent player, out C4DefuseWeaponInputActionEquipmentComponent DefuseC4 )
	{
		if ( !player.CurrentEquipment.IsValid() )
		{
			DefuseC4 = null;
			return false;
		}

		DefuseC4 = player.CurrentEquipment?.GetComponentInChildren<C4DefuseWeaponInputActionEquipmentComponent>();
		return DefuseC4 is { Active: true, IsPlanting: true };
	}

	/// <summary>
	/// Helper to check if a player is defusing, useful for UI.
	/// </summary>
	public static bool IsDefusing( this PlayerPawnComponent player, out TimedExplosiveComponent bomb )
	{
		if ( player.LastUsedObject?.GetComponentInChildren<TimedExplosiveComponent>() is { DefusingPlayer: { } defuser } match && defuser == player )
		{
			bomb = match;
			return true;
		}

		bomb = null;
		return false;
	}
}
