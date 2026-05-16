using System;
using System.Linq;
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
		Filter = Scene?.GetAllComponents<IVoiceFilter>().FirstOrDefault();
		TargetMixer = ResolveVoiceMixer();
	}

	static Mixer ResolveVoiceMixer()
	{
		foreach ( var name in new[] { "voice", "Voice" } )
		{
			var byName = Mixer.FindMixerByName( name );
			if ( byName is not null )
				return byName;
		}

		var children = Mixer.Master?.GetChildren();
		if ( children is not null )
		{
			foreach ( var c in children )
			{
				if ( c?.Name is { } n && n.Equals( "voice", StringComparison.OrdinalIgnoreCase ) )
					return c;
			}

			if ( children.Length > 4 )
				return children[4];
		}

		return Mixer.Master;
	}

	protected override IEnumerable<Connection> ExcludeFilter()
	{
		if ( Filter is null ) return base.ExcludeFilter();
		return Filter.GetExcludeFilter();
	}
}
