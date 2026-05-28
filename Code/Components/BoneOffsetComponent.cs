using Sandbox.Attributes;

namespace Sandbox.Components;

/// <summary>
/// Overrides a single skeleton bone after animation.
/// Add directly to a bone object, or assign <see cref="TargetBone"/> from elsewhere.
/// </summary>
[Title( "Bone Offset" ), Group( "Animation" )]
public sealed class BoneOffsetComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Setup" )]
	public SkinnedModelRenderer TargetRenderer { get; set; }

	/// <summary>
	/// The skeleton bone to override. Required when this component is not on the bone object itself.
	/// </summary>
	[Property, Group( "Setup" )]
	public GameObject TargetBone { get; set; }

	/// <summary>
	/// Optional name override. Used when <see cref="TargetBone"/> is not set.
	/// </summary>
	[Property, Group( "Setup" )]
	public string BoneName { get; set; }

	[Property, Group( "Offset" )]
	public Vector3 PositionOffset { get; set; }

	[Property, Group( "Offset" )]
	public Angles AngleOffset { get; set; }

	[Property, Group( "Offset" )]
	public BoneOffsetMode Mode { get; set; } = BoneOffsetMode.Additive;

	/// <summary>
	/// Optional child object under the target bone whose local transform is added when enabled.
	/// </summary>
	[Property, Group( "Reference" )]
	public GameObject ReferenceBone { get; set; }

	[Property, Group( "Setup" )]
	public bool ApplyOffsets { get; set; } = true;

	protected override void OnPreRender()
	{
		if ( !ShouldApply )
			return;

		var renderer = ResolveTargetRenderer();
		if ( !renderer.IsValid() )
			return;

		BoneOffsetUtility.ApplyEntry( renderer, BuildEntry() );
	}

	public SkinnedModelRenderer ResolveTargetRenderer()
	{
		if ( TargetRenderer.IsValid() )
			return TargetRenderer;

		return GetComponentInParent<SkinnedModelRenderer>();
	}

	internal bool ShouldApply => ApplyOffsets && GameObject.Enabled;

	internal BoneOffsetEntry BuildEntry()
	{
		return new BoneOffsetEntry
		{
			TargetBone = TargetBone,
			BoneName = ResolveBoneName(),
			PositionOffset = PositionOffset,
			AngleOffset = AngleOffset,
			Mode = Mode,
			ReferenceBone = ReferenceBone
		};
	}

	string ResolveBoneName()
	{
		if ( TargetBone.IsValid() )
			return TargetBone.Name;

		if ( !string.IsNullOrWhiteSpace( BoneName ) )
			return BoneName;

		return GameObject.Name;
	}
}
