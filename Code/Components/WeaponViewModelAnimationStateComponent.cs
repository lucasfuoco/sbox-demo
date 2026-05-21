using Sandbox.Attributes;
using Sandbox.GameResources;

namespace Sandbox.Components;

/// <summary>
/// One viewmodel animation state. Reference from <see cref="WeaponViewModelAnimationProfileComponent.States"/>.
/// </summary>
[Title( "Animation State" ), Group( "Weapon Components" )]
public sealed class WeaponViewModelAnimationStateComponent : Component, Component.ExecuteInEditor
{
	[Property, Title( "State" )] public string StateId { get; set; } = "Idle";

	[Property] public string[] Sequences { get; set; } = { "idle" };

	[Property] public float Fps { get; set; } = 30f;

	/// <summary>Override duration in seconds. When 0, uses the active sequence duration.</summary>
	[Property] public float Length { get; set; }

	/// <summary>State to enter when this clip finishes (e.g. Idle). Ignored when <see cref="Loop"/> is true.</summary>
	[Property] public string NextStateId { get; set; } = "Idle";

	[Property] public bool Loop { get; set; }

	[Property, InlineEditor] public List<WeaponViewModelAnimationEvent> Events { get; set; } = new();

	public WeaponViewModelAnimationState ToState()
	{
		return new WeaponViewModelAnimationState
		{
			Id = StateId,
			Sequences = Sequences,
			Fps = Fps,
			Length = Length,
			NextStateId = NextStateId,
			Loop = Loop,
			Events = Events,
		};
	}

	public void CopyFrom( WeaponViewModelAnimationState state )
	{
		if ( state is null )
			return;

		StateId = state.Id;
		Sequences = state.Sequences;
		Fps = state.Fps;
		Length = state.Length;
		NextStateId = state.NextStateId;
		Loop = state.Loop;
		Events = state.Events?.ToList() ?? new();
	}

	protected override void OnValidate()
	{
		if ( !string.IsNullOrWhiteSpace( StateId ) && GameObject.Name != StateId )
			GameObject.Name = StateId;
	}
}
