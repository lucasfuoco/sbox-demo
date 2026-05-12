using Sandbox.GameEvents;
using Sandbox.GameResources;

namespace Sandbox.Components;

/// <summary>
/// If added to a gamemode, we'll record weapon stats while in this state.
/// </summary>
public sealed class WeaponStatsRuleComponent : Component,
	IGameEventHandler<KillEvent>
{
	void IGameEventHandler<KillEvent>.OnGameEvent( KillEvent eventArgs )
	{
		var player = GameUtils.GetPlayerFromComponent( eventArgs.DamageInfo.Attacker );
		if ( !player.IsValid() )
			return;

		var inflictor = eventArgs.DamageInfo.Inflictor;
		if ( inflictor is EquipmentComponent wpn && wpn.IsValid() )
		{
			using ( Rpc.FilterInclude( player.Network.Owner ) )
			{
				SendKillStat( wpn.Resource.ResourcePath, eventArgs.DamageInfo.Hitbox, eventArgs.DamageInfo.Flags );
			}
		}
	}

	[Rpc.Broadcast( NetFlags.HostOnly )]
	private void SendKillStat( string resourcePath, HitboxTags hitbox = default, DamageFlags flags = default )
	{
		var resource = ResourceLibrary.Get<EquipmentResource>( resourcePath );
		if ( resource is not null )
		{
			if ( hitbox == HitboxTags.Head )
			{
				WeaponStats.Increment( "kills-headshots", resource, flags );
			}

			WeaponStats.Increment( "kills", resource, flags );
		}
	}
}
