namespace Sandbox;

/// <summary>
/// Stat modifiers applied when an attachment option is selected.
/// </summary>
public class WeaponAttachmentOptionModifiers
{
	[Property] public int? MaxAmmo { get; set; }
	[Property] public float? FireRate { get; set; }
	[Property] public float ReloadTimeMultiplier { get; set; } = 1f;
	[Property] public float EmptyReloadTimeMultiplier { get; set; } = 1f;
	[Property] public float ReloadSpeedMultiplier { get; set; } = 1f;
	[Property] public float VerticalRecoilMultiplier { get; set; } = 1f;
	[Property] public float HorizontalRecoilMultiplier { get; set; } = 1f;
	[Property] public bool ForceAutomatic { get; set; }
	[Property] public Vector3 AimOffsetDelta { get; set; }
	[Property] public bool SuppressesSound { get; set; }

	public void ApplyTo( ref AggregatedAttachmentModifiers aggregate )
	{
		if ( MaxAmmo.HasValue )
			aggregate.MaxAmmo = MaxAmmo.Value;

		if ( FireRate.HasValue )
			aggregate.FireRate = FireRate.Value;

		aggregate.ReloadTimeMultiplier *= ReloadTimeMultiplier;
		aggregate.EmptyReloadTimeMultiplier *= EmptyReloadTimeMultiplier;
		aggregate.ReloadSpeedMultiplier *= ReloadSpeedMultiplier;
		aggregate.VerticalRecoilMultiplier *= VerticalRecoilMultiplier;
		aggregate.HorizontalRecoilMultiplier *= HorizontalRecoilMultiplier;
		aggregate.ForceAutomatic |= ForceAutomatic;
		aggregate.AimOffsetDelta += AimOffsetDelta;
		aggregate.SuppressesSound |= SuppressesSound;
	}
}

public struct AggregatedAttachmentModifiers
{
	public int? MaxAmmo;
	public float? FireRate;
	public float ReloadTimeMultiplier;
	public float EmptyReloadTimeMultiplier;
	public float ReloadSpeedMultiplier;
	public float VerticalRecoilMultiplier;
	public float HorizontalRecoilMultiplier;
	public bool ForceAutomatic;
	public Vector3 AimOffsetDelta;
	public bool SuppressesSound;
}

public class WeaponAttachmentOptionDefinition
{
	[Property] public string Id { get; set; }
	[Property] public WeaponAttachmentOptionModifiers Modifiers { get; set; } = new();
}

public class WeaponAttachmentSlotDefinition
{
	[Property] public string Category { get; set; }
	[Property] public string DefaultOption { get; set; }
	[Property] public List<WeaponAttachmentOptionDefinition> Options { get; set; } = new();

	public WeaponAttachmentOptionDefinition FindOption( string optionId )
	{
		return Options.FirstOrDefault( o => o.Id.Equals( optionId, StringComparison.OrdinalIgnoreCase ) );
	}

	public IEnumerable<string> GetOptionIds() => Options.Select( o => o.Id );
}

/// <summary>
/// Attachment slot/options for a weapon. Built from editor slot/option components or a code profile fallback.
/// </summary>
public class WeaponAttachmentProfile
{
	[Property] public List<WeaponAttachmentSlotDefinition> Slots { get; set; } = new();
	[Property] public SoundEvent SuppressedShootSound { get; set; }
	[Property] public SoundEvent StandardShootSound { get; set; }

	public WeaponAttachmentSlotDefinition GetSlot( string category )
	{
		return Slots.FirstOrDefault( s => s.Category.Equals( category, StringComparison.OrdinalIgnoreCase ) );
	}

	public string GetDefaultOption( string category )
	{
		return GetSlot( category )?.DefaultOption ?? "none";
	}

	public IEnumerable<string> GetCategories() => Slots.Select( s => s.Category );
}
