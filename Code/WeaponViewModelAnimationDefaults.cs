namespace Sandbox;

/// <summary>
/// Optional starter templates for <see cref="Components.WeaponViewModelAnimationProfileComponent"/>.
/// Each weapon configures child <see cref="Components.WeaponViewModelAnimationStateComponent"/> objects in the editor.
/// </summary>
public static class WeaponViewModelAnimationDefaults
{
	/// <summary>
	/// Common MW pistol viewmodel state set (idle, draw, fire, reload, ADS, sprint).
	/// Sequence names must exist on that weapon's <c>.vmdl</c> — adjust per asset.
	/// </summary>
	public static List<WeaponViewModelAnimationState> CreateCorePistolTemplate()
	{
		return new List<WeaponViewModelAnimationState>
		{
			State( "Idle", "idle", loop: true ),
			State( "Draw", "draw", length: 0.3f, next: "Idle" ),
			State( "Holster", "holster", length: 0.4f ),
			State( "Equip", "draw_First", length: 1f, next: "Idle" ),
			FireState( "Fire", "fire", fps: 60f ),
			FireState( "Fire_Last", "fire_last", fps: 60f ),
			State( "Reload", "reload", length: 1.66f, next: "Idle" ),
			State( "Reload_Empty", "reload_empty", length: 2.26f, next: "Idle" ),
			State( "Ads_In", "ads_in", length: 0.3f, fps: 45f, next: "Idle" ),
			State( "Ads_Out", "ads_out", length: 0.3f, fps: 45f, next: "Idle" ),
			State( "Sprint_In", "sprint_in" ),
			State( "Sprint_Loop", "sprint_loop", loop: true, next: "Sprint_Loop" ),
			State( "Sprint_Out", "sprint_out", length: 0.2f, next: "Idle" ),
			State( "Inspect", "inspect", length: 5f, next: "Idle" ),
		};
	}

	static WeaponViewModelAnimationState State(
		string id,
		string sequence,
		float length = 0f,
		float fps = 30f,
		string next = null,
		bool loop = false )
	{
		return new WeaponViewModelAnimationState
		{
			Id = id,
			Sequences = new[] { sequence },
			Length = length,
			Fps = fps,
			NextStateId = next ?? "",
			Loop = loop,
		};
	}

	static WeaponViewModelAnimationState FireState( string id, string sequence, float fps )
	{
		return new WeaponViewModelAnimationState
		{
			Id = id,
			Sequences = new[] { sequence },
			Fps = fps,
			NextStateId = "Idle",
			Events = new List<WeaponViewModelAnimationEvent>
			{
				new()
				{
					Time = 0f,
					Action = WeaponViewModelAnimationAction.MuzzleFlash,
					AttachmentPoint = "muzzle",
				},
				new()
				{
					Time = 0f,
					Action = WeaponViewModelAnimationAction.ShellEject,
					AttachmentPoint = "shell_eject",
				},
			},
		};
	}
}
