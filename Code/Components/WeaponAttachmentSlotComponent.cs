using Sandbox;

namespace Sandbox.Components;

/// <summary>
/// An attachment category (mag, barrel, muzzle, …). Add option children with <see cref="WeaponAttachmentOptionComponent"/>.
/// </summary>
[Title( "Attachment Slot" ), Group( "Weapon Components" )]
public sealed class WeaponAttachmentSlotComponent : Component, Component.ExecuteInEditor
{
	[Property, Title( "Slot" )]
	public WeaponAttachmentSlotCategory Category { get; set; }

	[Property, Title( "Default option" )]
	public WeaponAttachmentOptionComponent DefaultOption { get; set; }

	/// <summary>
	/// All options for this slot. When empty, direct children with <see cref="WeaponAttachmentOptionComponent"/> are used.
	/// </summary>
	[Property, Group( "Options" )]
	public List<WeaponAttachmentOptionComponent> Options { get; set; } = new();

	public IEnumerable<WeaponAttachmentOptionComponent> GetOptionComponents()
	{
		if ( Options is { Count: > 0 } )
		{
			foreach ( var option in Options )
			{
				if ( option.IsValid() )
					yield return option;
			}

			yield break;
		}

		foreach ( var child in GameObject.Children )
		{
			var option = child.Components.Get<WeaponAttachmentOptionComponent>();
			if ( option.IsValid() )
				yield return option;
		}
	}

	public WeaponAttachmentSlotDefinition ToDefinition()
	{
		var options = GetOptionComponents()
			.Where( o => !string.IsNullOrWhiteSpace( o.OptionId ) )
			.Select( o => o.ToDefinition() )
			.ToList();

		return new WeaponAttachmentSlotDefinition
		{
			Category = Category.ToCategoryId(),
			DefaultOption = ResolveDefaultOptionId( options ),
			Options = options
		};
	}

	protected override void OnValidate()
	{
		if ( !Game.IsEditor )
			return;

		if ( GameObject.Name.StartsWith( "slot_", StringComparison.OrdinalIgnoreCase ) )
		{
			var id = GameObject.Name["slot_".Length..];
			var underscore = id.IndexOf( '_' );
			if ( underscore > 0 )
				id = id[..underscore];

			if ( WeaponAttachmentSlotCategoryExtensions.TryParseCategoryId( id, out var parsed ) )
				Category = parsed;
		}
		else if ( WeaponAttachmentSlotCategoryExtensions.TryParseCategoryId( GameObject.Name, out var fromName ) )
		{
			Category = fromName;
		}

		SyncOptionsFromChildrenIfEmpty();

		if ( !DefaultOption.IsValid() )
		{
			DefaultOption = Options.FirstOrDefault( o => o.IsValid() )
				?? GetOptionComponents().FirstOrDefault();
		}
	}

	string ResolveDefaultOptionId( List<WeaponAttachmentOptionDefinition> options )
	{
		if ( DefaultOption.IsValid() && !string.IsNullOrWhiteSpace( DefaultOption.OptionId ) )
			return DefaultOption.OptionId;

		if ( options.Count > 0 )
			return options[0].Id;

		return "none";
	}

	void SyncOptionsFromChildrenIfEmpty()
	{
		if ( Options is { Count: > 0 } )
			return;

		Options ??= new List<WeaponAttachmentOptionComponent>();
		Options.Clear();

		foreach ( var child in GameObject.Children )
		{
			var option = child.Components.Get<WeaponAttachmentOptionComponent>();
			if ( option.IsValid() )
				Options.Add( option );
		}
	}
}
