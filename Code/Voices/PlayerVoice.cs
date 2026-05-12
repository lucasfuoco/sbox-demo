using Sandbox.Audio;
using Sandbox.Components;

namespace Sandbox.Voices;

/// <summary>
/// An implementation of <see cref="Voice"/>, which takes use of an active Component which implements <see cref="IVoiceFilter"/>.
/// </summary>
public partial class PlayerVoice : Voice
{
	/// <summary>
	/// The target <see cref="Client"/>
	/// </summary>
	[Property] public ClientComponent Client { get; set; }

	/// <summary>
	/// The cached <see cref="IVoiceFilter"/> which is grabbed on <see cref="OnStart"/>.
	/// </summary>
	IVoiceFilter Filter { get; set; }

	protected override void OnStart()
	{
		Filter = Scene.GetAllComponents<IVoiceFilter>().FirstOrDefault();
		TargetMixer = Mixer.FindMixerByName( "Voice" );
	}

	protected override IEnumerable<Connection> ExcludeFilter()
	{
		if ( Filter is null ) return base.ExcludeFilter();
		return Filter.GetExcludeFilter();
	}
}
