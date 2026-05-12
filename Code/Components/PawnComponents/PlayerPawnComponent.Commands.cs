using Sandbox.UI.Panels;
using Sandbox.Attributes;
using Sandbox.GameEvents;

namespace Sandbox.Components.PawnComponents;

public partial class PlayerPawnComponent
{
	/// <summary>
	/// Development: should bots follow the player's input?
	/// </summary>
	[ConVar( "hc1_bot_follow" )] public static bool BotFollowHostInput { get; set; }

	[DeveloperCommand( "-10 HP (head)", "Player" )]
	private static void Command_HurtTenHead()
	{
		var player = ClientComponent.Local.PlayerPawn;
		if ( player is null ) return;
		player.HealthComponent.TakeDamage( new DamageInfo( player as Component, 10, Hitbox: HitboxTags.Head ) );
	}


	[DeveloperCommand( "Toggle God", "Player" )]
	private static void Command_Add_Bot()
	{
		var player = ClientComponent.Local.PlayerPawn;
		if ( player is null ) return;

		player.HealthComponent.IsGodMode = !player.HealthComponent.IsGodMode;
	}


	[DeveloperCommand( "-10 HP (chest)", "Player" )]
	private static void Command_HurtTenChest()
	{
		var player = ClientComponent.Local.PlayerPawn;
		if ( player is null ) return;
		player.HealthComponent.TakeDamage( new DamageInfo( player as Component, 10, Hitbox: HitboxTags.Chest ) );
	}

	[DeveloperCommand( "Heal", "Player" )]
	private static void Command_Heal()
	{
		var player = ClientComponent.Local.PlayerPawn;
		if ( player is null ) return;
		player.HealthComponent.Health = player.HealthComponent.MaxHealth;
	}

	[DeveloperCommand( "Suicide", "Player" ), ConCmd( "kill" )]
	private static void Command_Suicide()
	{
		var player = ClientComponent.Local.PlayerPawn;
		if ( player is null ) return;
		Host_Suicide( player );
	}

	[DeveloperCommand( "Give $1k", "Player" )]
	private static void Command_GiveGrand()
	{
		var player = ClientComponent.Local.PlayerPawn;
		if ( player is null ) return;
		player.Client.GiveCash( 1000 );
	}


	[DeveloperCommand( "Give Scores", "Player" )]
	private static void Command_Scores()
	{
		var player = ClientComponent.Local.PlayerPawn;
		if ( player is null ) return;
		player.Client.GetComponent<PlayerScoreComponent>().AddScore( 25, "Killed a player" );
	}

	[Rpc.Owner]
	private static void Host_Suicide( PlayerPawnComponent pawn )
	{
		if ( !pawn.IsValid() )
			return;

		pawn.HealthComponent.TakeDamage( new( pawn, float.MaxValue ) );
	}
}
