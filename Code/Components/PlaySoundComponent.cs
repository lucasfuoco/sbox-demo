using Sandbox.Audio;
using Sandbox.GameEvents;
using Sandbox.GameResources;
using Sandbox;

namespace Sandbox.Components;

/// <summary>
/// Play a sound at the start of this state.
/// </summary>
public sealed class PlaySoundComponent : Component,
	IGameEventHandler<EnterStateEvent>
{
	[Property]
	public SoundEvent SoundEvent { get; set; }

	[Rpc.Broadcast]
	private void Play()
	{
		if ( SoundEvent is null )
		{
			return;
		}

		var x = Sound.Play( SoundEvent );
		x.TargetMixer = Mixer.FindMixerByName( "Music" );
	}

	void IGameEventHandler<EnterStateEvent>.OnGameEvent( EnterStateEvent eventArgs )
	{
		Play();
	}
}
