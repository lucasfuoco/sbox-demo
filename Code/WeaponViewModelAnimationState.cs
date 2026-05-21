using Sandbox.Attributes;
using Sandbox.GameResources;

namespace Sandbox;

/// <summary>
/// Runtime viewmodel animation state (built from <see cref="Components.WeaponViewModelAnimationStateComponent"/>).
/// </summary>
public sealed class WeaponViewModelAnimationState
{
	public string Id { get; set; } = "Idle";

	public string[] Sequences { get; set; } = { "idle" };

	public float Fps { get; set; } = 30f;

	/// <summary>Override duration in seconds. When 0, uses the active sequence duration.</summary>
	public float Length { get; set; }

	/// <summary>State to enter when this clip finishes (e.g. Idle). Ignored when <see cref="Loop"/> is true.</summary>
	public string NextStateId { get; set; } = "Idle";

	public bool Loop { get; set; }

	public List<WeaponViewModelAnimationEvent> Events { get; set; } = new();
}

public sealed class WeaponViewModelAnimationEvent
{
	[Property] public float Time { get; set; }

	[Property] public WeaponViewModelAnimationAction Action { get; set; }

	[Property] public SoundEvent Sound { get; set; }

	/// <summary>QC attachment name for particles / ejection (e.g. muzzle, shell_eject).</summary>
	[Property] public string AttachmentPoint { get; set; }
}
