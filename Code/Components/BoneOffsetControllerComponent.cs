using Sandbox.Attributes;

namespace Sandbox.Components;

/// <summary>
/// Optional central applier for bone overrides listed in <see cref="GlobalBoneOffsets"/>.
/// <see cref="BoneOffsetComponent"/> instances also apply themselves in <c>OnPreRender</c>.
/// </summary>
[Title( "Bone Offset Controller" ), Group( "Animation" )]
public sealed class BoneOffsetControllerComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Setup" )]
	public SkinnedModelRenderer TargetRenderer { get; set; }

	[Property, Group( "Setup" )]
	public List<BoneOffsetEntry> GlobalBoneOffsets { get; set; } = new();

	protected override void OnPreRender()
	{
		ApplyBoneOffsets();
	}

	public void ApplyBoneOffsets()
	{
		var renderer = ResolveTargetRenderer();
		if ( !renderer.IsValid() )
			return;

		foreach ( var entry in GlobalBoneOffsets )
			BoneOffsetUtility.ApplyEntry( renderer, entry );
	}

	SkinnedModelRenderer ResolveTargetRenderer()
	{
		if ( TargetRenderer.IsValid() )
			return TargetRenderer;

		return GetComponent<SkinnedModelRenderer>()
			?? GetComponentInChildren<SkinnedModelRenderer>();
	}
}

static class BoneOffsetUtility
{
	public static void ApplyEntry( SkinnedModelRenderer renderer, BoneOffsetEntry entry )
	{
		if ( entry == null )
			return;

		var boneName = ResolveBoneName( entry );
		if ( string.IsNullOrWhiteSpace( boneName ) )
			return;

		if ( !TryFindBone( renderer, boneName, out var bone ) )
			return;

		EnsureAnimationUpdated( renderer );

		if ( !TryGetAnimatedLocalTransform( renderer, bone, out var localTransform ) )
			return;

		var positionOffset = entry.PositionOffset;
		var angleOffset = entry.AngleOffset;

		if ( TryGetReferenceLocalTransform( entry.ReferenceBone, boneName, out var referenceTransform ) )
		{
			positionOffset += referenceTransform.Position;
			angleOffset += referenceTransform.Rotation.Angles();
		}

		localTransform = entry.Mode switch
		{
			BoneOffsetMode.Replace => BuildReplaceTransform( localTransform, positionOffset, angleOffset ),
			_ => BuildAdditiveTransform( localTransform, positionOffset, angleOffset )
		};

		renderer.SetBoneTransform( bone, localTransform );
	}

	static string ResolveBoneName( BoneOffsetEntry entry )
	{
		if ( entry.TargetBone.IsValid() )
			return entry.TargetBone.Name;

		return entry.BoneName;
	}

	static void EnsureAnimationUpdated( SkinnedModelRenderer renderer )
	{
		if ( !renderer.IsValid() )
			return;

#pragma warning disable CS0612
		renderer.PostAnimationUpdate();
#pragma warning restore CS0612
	}

	static bool TryGetAnimatedLocalTransform( SkinnedModelRenderer renderer, BoneCollection.Bone bone, out Transform localTransform )
	{
		localTransform = default;

		if ( !renderer.IsValid() )
			return false;

		if ( renderer.TryGetBoneTransformAnimation( bone, out localTransform ) )
			return true;

		return renderer.TryGetBoneTransformLocal( bone, out localTransform );
	}

	static Transform BuildReplaceTransform( Transform animatedTransform, Vector3 positionOffset, Angles angleOffset )
	{
		var rotation = angleOffset != Angles.Zero
			? animatedTransform.Rotation * angleOffset.ToRotation()
			: animatedTransform.Rotation;

		var position = positionOffset != Vector3.Zero
			? ApplyPositionOffset( animatedTransform.Position, rotation, positionOffset )
			: animatedTransform.Position;

		return new Transform( position, rotation, animatedTransform.Scale );
	}

	static Transform BuildAdditiveTransform( Transform animatedTransform, Vector3 positionOffset, Angles angleOffset )
	{
		var rotation = animatedTransform.Rotation;

		if ( angleOffset != Angles.Zero )
			rotation *= angleOffset.ToRotation();

		var position = animatedTransform.Position;

		if ( positionOffset != Vector3.Zero )
			position = ApplyPositionOffset( position, rotation, positionOffset );

		return animatedTransform.WithRotation( rotation ).WithPosition( position );
	}

	static bool TryGetReferenceLocalTransform(
		GameObject referenceBone,
		string targetBoneName,
		out Transform localTransform )
	{
		localTransform = default;

		if ( !referenceBone.IsValid() || !referenceBone.Enabled )
			return false;

		if ( referenceBone.Name.Equals( targetBoneName, StringComparison.OrdinalIgnoreCase ) )
			return false;

		if ( !referenceBone.Parent.IsValid()
			|| !referenceBone.Parent.Name.Equals( targetBoneName, StringComparison.OrdinalIgnoreCase ) )
			return false;

		localTransform = referenceBone.LocalTransform;
		return true;
	}

	static Vector3 ApplyPositionOffset( Vector3 position, Rotation rotation, Vector3 offset )
	{
		if ( offset == Vector3.Zero )
			return position;

		return position
			+ rotation.Right * offset.x
			+ rotation.Forward * offset.y
			+ rotation.Up * offset.z;
	}

	static bool TryFindBone( SkinnedModelRenderer renderer, string boneName, out BoneCollection.Bone bone )
	{
		bone = default;

		if ( !renderer.IsValid() || !renderer.Model.IsValid() || string.IsNullOrWhiteSpace( boneName ) )
			return false;

		foreach ( var candidate in renderer.Model.Bones.AllBones )
		{
			if ( !candidate.Name.Equals( boneName, StringComparison.OrdinalIgnoreCase ) )
				continue;

			bone = candidate;
			return true;
		}

		return false;
	}
}
