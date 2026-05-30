using Sandbox.Components;

namespace Sandbox;

/// <summary>
/// Toggles viewmodel attachment children named slot_{category}_{option}.
/// </summary>
public static class AttachmentSlotUtility
{
	public static void SetSlotVisible( GameObject root, string category, string activeOption )
	{
		if ( !root.IsValid() )
			return;

		var prefix = $"slot_{category}_";
		var foundAny = false;

		foreach ( var child in root.GetAllObjects( true ) )
		{
			if ( !child.Name.StartsWith( prefix, StringComparison.OrdinalIgnoreCase ) )
				continue;

			foundAny = true;
			var slotOption = child.Name[prefix.Length..];
			var optionId = child.Components.Get<WeaponAttachmentOptionComponent>()?.OptionId;

			if ( string.IsNullOrWhiteSpace( optionId ) )
				optionId = slotOption;

			var isActive = optionId.Equals( activeOption, StringComparison.OrdinalIgnoreCase )
				|| slotOption.Equals( activeOption, StringComparison.OrdinalIgnoreCase )
				|| $"{category}_{slotOption}".Equals( activeOption, StringComparison.OrdinalIgnoreCase );

			child.Enabled = isActive;

			foreach ( var renderer in child.Components.GetAll<SkinnedModelRenderer>( FindMode.EverythingInSelf ) )
				renderer.Enabled = isActive;
		}

		if ( !foundAny )
			Log.Warning( $"AttachmentSlotUtility: no objects matching '{prefix}*' under {root.Name}" );
	}
}
