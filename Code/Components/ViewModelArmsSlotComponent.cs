using Sandbox;

namespace Sandbox.Components;

/// <summary>
/// Glove slot on an arms rig. Assign options in the inspector or as child objects.
/// </summary>
[Title( "Arms Slot" ), Group( "Viewmodel" )]
public sealed class ViewModelArmsSlotComponent : Component, Component.ExecuteInEditor
{
	[Property, Title( "Slot" )]
	public ViewModelArmsSlotCategory Category { get; set; }

	[Property, Title( "Default option" )]
	public ViewModelArmsOptionComponent DefaultOption { get; set; }

	[Property, Group( "Options" )]
	public List<ViewModelArmsOptionComponent> Options { get; set; } = new();

	public IEnumerable<ViewModelArmsOptionComponent> GetOptionComponents()
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
			var option = child.Components.Get<ViewModelArmsOptionComponent>();
			if ( option.IsValid() )
				yield return option;
		}
	}

	public ViewModelArmsSlotDefinition ToDefinition()
	{
		var options = GetOptionComponents()
			.Where( o => !string.IsNullOrWhiteSpace( o.OptionId ) )
			.Select( o => o.ToDefinition() )
			.ToList();

		return new ViewModelArmsSlotDefinition
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

			if ( ViewModelArmsSlotCategoryExtensions.TryParseCategoryId( id, out var parsed ) )
				Category = parsed;
		}
		else if ( ViewModelArmsSlotCategoryExtensions.TryParseCategoryId( GameObject.Name, out var fromName ) )
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

	string ResolveDefaultOptionId( List<ViewModelArmsOptionDefinition> options )
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

		Options ??= new List<ViewModelArmsOptionComponent>();
		Options.Clear();

		foreach ( var child in GameObject.Children )
		{
			var option = child.Components.Get<ViewModelArmsOptionComponent>();
			if ( option.IsValid() )
				Options.Add( option );
		}
	}
}
