using Sandbox.Attributes;

namespace Sandbox.Components;

/// <summary>
/// One selectable attachment option. Add as a child of a GameObject with <see cref="WeaponAttachmentSlotComponent"/>.
/// <see cref="OptionId"/> must match a viewmodel child: slot_{category}_{optionId}.
/// </summary>
[Title( "Attachment Option" ), Group( "Weapon Components" )]
public sealed class WeaponAttachmentOptionComponent : Component, Component.ExecuteInEditor
{
	[Property] public string OptionId { get; set; }

	[Property, InlineEditor] public WeaponAttachmentOptionModifiers Modifiers { get; set; } = new();

	public WeaponAttachmentOptionDefinition ToDefinition()
	{
		return new WeaponAttachmentOptionDefinition
		{
			Id = OptionId,
			Modifiers = Modifiers
		};
	}

	protected override void OnValidate()
	{
		if ( !Game.IsEditor )
			return;

		if ( !string.IsNullOrWhiteSpace( OptionId ) )
			return;

		if ( GameObject.Name.StartsWith( "option_", StringComparison.OrdinalIgnoreCase ) )
		{
			OptionId = GameObject.Name["option_".Length..];
			return;
		}

		if ( GameObject.Name.StartsWith( "slot_", StringComparison.OrdinalIgnoreCase ) )
		{
			var parts = GameObject.Name.Split( '_' );
			if ( parts.Length >= 3 )
				OptionId = parts[^1];
		}
	}
}
