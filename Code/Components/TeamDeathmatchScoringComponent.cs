using Sandbox;
using Sandbox.GameEvents;
using Sandbox.Attributes;
using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

public sealed class TeamDeathmatchScoringComponent : Component,
	IGameEventHandler<KillEvent>
{
	void IGameEventHandler<KillEvent>.OnGameEvent( KillEvent eventArgs )
	{
		if ( !Networking.IsHost )
			return;

		var damageInfo = eventArgs.DamageInfo;

		if ( GameUtils.GetPlayerFromComponent( damageInfo.Attacker ) is not { } killerPlayer )
			return;

		if ( GameUtils.GetPlayerFromComponent( damageInfo.Victim ) is not { } victimPlayer )
			return;

		if ( killerPlayer.IsFriendly( victimPlayer ) )
			return;

		if ( killerPlayer.Team == Team.Unassigned )
			return;

		if ( victimPlayer.Team == Team.Unassigned )
			return;

		GameModeSingletonComponent.Instance.Get<TeamScoringComponent>()?.IncrementScore( killerPlayer.Team );
	}
}
