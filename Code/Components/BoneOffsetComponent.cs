using Sandbox.Attributes;
using Sandbox.Components.WeaponModelComponents;

namespace Sandbox.Components;

/// <summary>
/// Applies local bone corrections on a <see cref="SkinnedModelRenderer"/> after animation.
/// When apply is enabled: overrides the target bone local transform relative to <see cref="RelativeBone"/>.
/// </summary>
[Title( "Bone Offset" ), Group( "Animation" )]
public sealed class BoneOffsetComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Setup" )]
	public SkinnedModelRenderer TargetRenderer { get; set; }

	[Property, Group( "Setup" ), Change( nameof( OnTargetBoneChanged ) )]
	public GameObject TargetBone { get; set; }

	[Property, Group( "Setup" ), Change( nameof( OnRelativeBoneChanged ) )]
	public GameObject RelativeBone { get; set; }

	[Property, Group( "Offset" )]
	public Vector3 PositionOffset { get; set; }

	[Property, Group( "Offset" )]
	public Angles AngleOffset { get; set; }

	[Property, Group( "Offset" ), Change( nameof( OnModeChanged ) )]
	public BoneOffsetMode Mode { get; set; } = BoneOffsetMode.Additive;

	[Property, Group( "Setup" ), Change( nameof( OnApplyOffsetsChanged ) )]
	public bool ApplyOffsets { get; set; }

	[Property, Group( "Bone Transform Ref" ), ReadOnly, Title( "Position (target bone local)" )]
	public Vector3 BoneTransformRefPosition { get; private set; }

	[Property, Group( "Bone Transform Ref" ), ReadOnly, Title( "Rotation (target bone local)" )]
	public Angles BoneTransformRefRotation { get; private set; }

	[Property, Group( "Bone Transform Ref" ), ReadOnly, Title( "Scale (target bone local)" )]
	public Vector3 BoneTransformRefScale { get; private set; } = Vector3.One;

	[Property, Group( "Bone Transform Ref" ), ReadOnly, Title( "Revision" )]
	public int BoneTransformRefRevision { get; private set; }

	public bool LastShouldApply { get; set; } = false;
	public BoneOffsetMode LastMode { get; set; } = BoneOffsetMode.Additive;
	public bool ReferenceDirty { get; set; } = false;
	public bool BumpRevisionOnCapture { get; set; } = false;

	protected override void OnStart()
	{
		this.LastShouldApply = !ShouldApply;
		this.LastMode = this.Mode;
		MarkReferenceDirty();
	}

	protected override void OnEnabled()
	{
		MarkReferenceDirty();
		HandleApplyStateChanged();
	}

	protected override void OnDisabled()
	{
		MarkReferenceDirty();
		HandleApplyStateChanged();
	}

	protected override void OnValidate()
	{
		if ( !this.TargetBone.IsValid() )
			this.ClearTargetBoneState();

		if ( Game.IsEditor && ShouldApply )
			HandleApplyStateChanged();
	}

	protected override void OnPreRender()
	{
	}

	public SkinnedModelRenderer ResolveTargetRenderer()
	{
		if ( this.TargetRenderer.IsValid() )
			return TargetRenderer;

		return this.GetComponentInParent<SkinnedModelRenderer>();
	}

	public void HandleApplyStateChanged()
	{
		var applyRoot = this.GetBoneOffsetApplyRoot();
		if ( applyRoot.IsValid() )
			this.ApplyForRoot( applyRoot );

		this.ReferenceDirty = false;
		this.LastShouldApply = ShouldApply;
	}

	public void ApplyForRoot( GameObject root, bool prepareSkeleton = true )
	{
		if ( !root.IsValid() )
			return;

		var renderer = root.Components.Get<SkinnedModelRenderer>();
		if ( !renderer.IsValid() )
			return;

		var skeletonRenderer = this.GetSkeletonRenderer( renderer );
		if ( prepareSkeleton )
			this.PrepareAnimatedSkeleton( skeletonRenderer );

		if (this.TargetBone.IsValid())
		{
			this.BumpRevisionOnCapture = this.NeedsReferenceRefresh();
			this.ReferenceDirty = false;
			this.LastShouldApply = this.ShouldApply;
		}

		if (this.TargetBone.IsValid() && !this.ShouldApply)
		{
			if ( this.BumpRevisionOnCapture )
				this.ReleaseBoneOverride( skeletonRenderer );

			if (this.BumpRevisionOnCapture )
				this.CaptureBoneTransformRef( skeletonRenderer, bumpRevisionOnCapture: true );
			else
				this.CaptureBoneTransformRef( skeletonRenderer );
		}

		if (this.TargetBone.IsValid() && this.ShouldApply)
		{
			var modeChanged = this.LastMode != this.Mode;
			if ( modeChanged )
				this.ResetBoneToAnimated( skeletonRenderer );

			if ( this.BumpRevisionOnCapture || modeChanged )
			{
				// if ( this.Mode == BoneOffsetMode.Additive )
				// 	this.CaptureBoneTransformRefFromAnimatedSkeleton( skeletonRenderer, bumpRevisionOnCapture: true );
				// else
				// 	this.CaptureBoneTransformRef( skeletonRenderer, bumpRevisionOnCapture: true );
			}

			this.ApplyComponentInternal(skeletonRenderer);
		}


		if (this.TargetBone.IsValid())
		{
			this.BumpRevisionOnCapture = false;
			this.LastMode = this.Mode;
		}

		this.RefreshBoneMergedRenderers(skeletonRenderer);
	}

	internal bool ShouldApply => ApplyOffsets && Enabled && GameObject.Enabled;

	private bool NeedsReferenceRefresh() =>
		this.ReferenceDirty || this.LastShouldApply != ShouldApply || this.LastMode != this.Mode;

	private void MarkReferenceDirty() => this.ReferenceDirty = true;

	private void ClearBoneTransformRef()
	{
		BoneTransformRefPosition = default;
		BoneTransformRefRotation = default;
		BoneTransformRefScale = Vector3.One;
		BoneTransformRefRevision++;
	}

	private void ClearTargetBoneState()
	{
		var boneName = this.TargetBone.Name;
		this.ClearBoneTransformRef();
		this.RestoreBoneToAnimation( boneName );
	}

	private void CommitBoneTransformRef( Transform boneTransform, bool bumpRevisionOnCapture = false )
	{
		this.BoneTransformRefPosition = boneTransform.Position;
		this.BoneTransformRefRotation = boneTransform.Rotation.Angles();
		this.BoneTransformRefScale = boneTransform.Scale;

		if ( bumpRevisionOnCapture )
			this.BoneTransformRefRevision++;
	}

	private Transform GetBoneTransformRef() =>
		new Transform( this.BoneTransformRefPosition, this.BoneTransformRefRotation, this.BoneTransformRefScale );

	private void RefreshBoneTransformRefFromSkeleton( bool skipPrepare = false )
	{
		if ( !this.TargetBone.IsValid() )
		{
			this.ClearBoneTransformRef();
			return;
		}

		var renderer = this.ResolveTargetRenderer();
		if ( !renderer.IsValid() )
			return;

		var skeletonRenderer = this.GetSkeletonRenderer( renderer );

		if ( !skipPrepare )
			this.PrepareAnimatedSkeleton( skeletonRenderer );

		CaptureBoneTransformRef( skeletonRenderer, bumpRevisionOnCapture: true );
	}

	/// <summary>
	/// Snapshots the target bone GameObject local transform (matches the hierarchy inspector).
	/// </summary>
	private void CaptureBoneTransformRef( SkinnedModelRenderer skeletonRenderer, bool bumpRevisionOnCapture = false )
	{
		if ( !this.TargetBone.IsValid() )
			return;

		var boneName = this.ResolveBoneName();
		if ( string.IsNullOrWhiteSpace( boneName ) )
			return;

		if ( !this.TryReadTargetBoneTransform( skeletonRenderer, this.TargetBone, boneName, out var boneTransform ) )
			return;

		this.CommitBoneTransformRef( boneTransform, bumpRevisionOnCapture );
	}

	private void RefreshBoneTransformRefWhenOffsetsDisabled( SkinnedModelRenderer skeletonRenderer ) =>
		this.CaptureBoneTransformRef( skeletonRenderer );

	private void OnApplyOffsetsChanged( bool oldValue, bool newValue )
	{
		this.MarkReferenceDirty();
		this.HandleApplyStateChanged();
	}

	private void OnTargetBoneChanged( GameObject oldValue, GameObject newValue )
	{
		if ( !newValue.IsValid() )
		{
			this.ClearTargetBoneState();
			this.HandleApplyStateChanged();
			return;
		}

		this.MarkReferenceDirty();
		this.HandleApplyStateChanged();
	}

	private void OnRelativeBoneChanged( GameObject oldValue, GameObject newValue )
	{
		this.MarkReferenceDirty();
		this.HandleApplyStateChanged();
	}

	private void OnModeChanged( BoneOffsetMode oldValue, BoneOffsetMode newValue )
	{
		this.MarkReferenceDirty();
		this.HandleApplyStateChanged();
	}

	/// <summary>
	/// Clears a previously applied bone override when apply is turned off (once per toggle).
	/// </summary>
	private void ReleaseBoneOverride( SkinnedModelRenderer skeletonRenderer ) =>
		this.ResetBoneToAnimated( skeletonRenderer );

	private void ResetBoneToAnimated( SkinnedModelRenderer skeletonRenderer )
	{
		var boneName = this.ResolveBoneName();
		if ( string.IsNullOrWhiteSpace( boneName ) || !this.TryFindBone( skeletonRenderer, boneName, out var bone, out var runtimeIndex ) )
			return;

		if ( !TryGetAnimatedLocalTransform( skeletonRenderer, bone, out var animatedTransform ) )
			return;

		SetBoneOverride( skeletonRenderer, bone, runtimeIndex, animatedTransform );
	}

	private void CaptureBoneTransformRefFromAnimatedSkeleton(
		SkinnedModelRenderer skeletonRenderer,
		bool bumpRevisionOnCapture = false )
	{
		if ( !this.TargetBone.IsValid() )
			return;

		var boneName = this.ResolveBoneName();
		if ( string.IsNullOrWhiteSpace( boneName ) )
			return;

		if ( !this.TryFindBone( skeletonRenderer, boneName, out var bone, out var runtimeIndex ) )
			return;

		if ( !TryGetAnimatedLocalTransform( skeletonRenderer, bone, out var boneTransform ) )
			return;

		this.CommitBoneTransformRef( boneTransform, bumpRevisionOnCapture );
	}

	private void RestoreBoneToAnimation( string boneName )
	{
		if ( string.IsNullOrWhiteSpace( boneName ) )
			return;

		var renderer = this.ResolveTargetRenderer();
		if ( !renderer.IsValid() )
			return;

		var skeletonRenderer = this.GetSkeletonRenderer( renderer );
		this.PrepareAnimatedSkeleton( skeletonRenderer );

		if ( !this.TryFindBone( skeletonRenderer, boneName, out var bone, out var runtimeIndex ) )
			return;

		if ( !TryGetAnimatedLocalTransform( skeletonRenderer, bone, out var animatedTransform ) )
			return;

		SetBoneOverride( skeletonRenderer, bone, runtimeIndex, animatedTransform );

		this.RefreshBoneTransformRefWhenOffsetsDisabled( skeletonRenderer );
	}

	private GameObject GetBoneOffsetApplyRoot()
	{
		var renderer = this.ResolveTargetRenderer();
		if ( renderer.IsValid() )
			return renderer.GameObject;

		return GameObject.Root;
	}

	private string ResolveBoneName()
	{
		if ( this.TargetBone.IsValid() )
			return this.TargetBone.Name;

		return GameObject.Name;
	}

	/// <summary>
	/// Anim graph / skeleton owner. Bone-merged meshes read bones from this renderer.
	/// </summary>
	private SkinnedModelRenderer GetSkeletonRenderer( SkinnedModelRenderer renderer )
	{
		if ( renderer.BoneMergeTarget.IsValid() )
			return renderer.BoneMergeTarget;

		return renderer;
	}

	private void RefreshBoneMergedRenderers( SkinnedModelRenderer skeletonRenderer )
	{
	}

	private void PrepareAnimatedSkeleton( SkinnedModelRenderer skeletonRenderer )
	{
		this.ClearBoneOverrides( skeletonRenderer );
		this.EnsureAnimationUpdated( skeletonRenderer );
	}

	private void ClearBoneOverrides( SkinnedModelRenderer renderer )
	{
		if ( !renderer.IsValid() )
			return;

		renderer.SceneModel?.ClearBoneOverrides();
	}

	private void EnsureAnimationUpdated( SkinnedModelRenderer renderer )
	{
		if ( !renderer.IsValid() )
			return;

#pragma warning disable CS0612
		renderer.PostAnimationUpdate();
#pragma warning restore CS0612
	}

	private void ApplyComponentInternal( SkinnedModelRenderer skeletonRenderer )
	{
		var boneName = this.TargetBone.Name;
		if ( string.IsNullOrWhiteSpace( boneName ) )
			return;

		if ( !TryFindBone( skeletonRenderer, boneName, out var bone, out var runtimeIndex ) )
			return;

		if ( this.Mode == BoneOffsetMode.Replace )
		{
			var targetBoneTransform = new Transform(
				this.TargetBone.LocalPosition,
				this.TargetBone.LocalRotation,
				this.TargetBone.LocalScale );
			var offsetTransform = ApplyOffsetsToBase(
				targetBoneTransform,
				this.PositionOffset,
				this.AngleOffset);

			var transform = AddRelativeBoneTransform( offsetTransform, this.TargetBone, this.RelativeBone );
			transform = EnsureBoneScale( transform, GetBoneTransformRef().Scale );

			SetBoneOverride( skeletonRenderer, bone, runtimeIndex, transform );
		}
		else if ( this.Mode == BoneOffsetMode.Additive )
		{
			if ( !TryGetAnimatedLocalTransform( skeletonRenderer, bone, out var animatedLocal ) )
				return;

			var targetBoneTransform = new Transform( animatedLocal.Position, animatedLocal.Rotation, animatedLocal.Scale );
			var offsetTransform = ApplyOffsetsToBase(
				targetBoneTransform,
				this.PositionOffset,
				this.AngleOffset);
			var transform = AddRelativeBoneTransform( offsetTransform, this.TargetBone, this.RelativeBone );
			transform = EnsureBoneScale(
				transform,
				animatedLocal.Scale );

			SetBoneOverride( skeletonRenderer, bone, runtimeIndex, transform );
		}
	}

	private static Transform AddRelativeBoneTransform(
		Transform targetLocal,
		GameObject targetObject,
		GameObject relativeObject,
		bool applyRotation = true )
	{
		if ( !relativeObject.IsValid() || !targetObject.IsValid() )
			return targetLocal;

		var relativeTransform = relativeObject.LocalTransform;
		var parent = targetObject.Parent;
		while ( parent.IsValid() && parent.Id != relativeObject.Id )
		{
			var position = relativeTransform.Position;
			if ( parent.LocalPosition != Vector3.Zero )
				position = parent.LocalPosition + relativeTransform.Position;

			var rotation = relativeTransform.Rotation;
			if ( applyRotation && parent.LocalRotation != Rotation.Identity )
				rotation = parent.LocalRotation * relativeTransform.Rotation;

			var scale = relativeTransform.Scale;
			if ( parent.LocalScale != Vector3.One && parent.LocalScale != Vector3.Zero )
				scale = parent.LocalScale * relativeTransform.Scale;

			relativeTransform = new Transform( position, rotation, scale );
			parent = parent.Parent;
		}

		var finalPosition = relativeTransform.Position - targetLocal.Position;
		var finalRotation = targetLocal.Rotation * relativeTransform.Rotation;
		var finalScale = targetLocal.Scale * relativeTransform.Scale;

		return new Transform(
			finalPosition,
			finalRotation,
			finalScale );
	}

	private static Transform EnsureBoneScale( Transform transform, Vector3 fallbackScale )
	{
		if ( transform.Scale != Vector3.Zero && transform.Scale != default )
			return transform;

		var scale = fallbackScale != Vector3.Zero && fallbackScale != default ? fallbackScale : Vector3.One;
		return new Transform( transform.Position, transform.Rotation, scale );
	}

	private static void SetBoneOverride(
		SkinnedModelRenderer skeletonRenderer,
		BoneCollection.Bone bone,
		int runtimeIndex,
		Transform localTransform )
	{
		if ( skeletonRenderer.SceneModel.IsValid() && runtimeIndex >= 0 )
		{
			skeletonRenderer.SceneModel.SetBoneOverride( runtimeIndex, localTransform );
			return;
		}

		skeletonRenderer.SetBoneTransform( bone, localTransform );
	}

	private static bool TryGetAnimatedLocalTransform(
		SkinnedModelRenderer skeletonRenderer,
		BoneCollection.Bone bone,
		out Transform localTransform )
	{
		localTransform = default;
		return bone.Index >= 0 && skeletonRenderer.TryGetBoneTransformLocal( bone, out localTransform );
	}

	private static Transform ApplyOffsetsToBase(
		Transform baseTransform,
		Vector3 positionOffset,
		Angles angleOffset)
	{
		var position = positionOffset != Vector3.Zero ? positionOffset : baseTransform.Position;
		var rotation = angleOffset != Angles.Zero ? angleOffset.ToRotation() : baseTransform.Rotation;
		return new Transform( position, rotation, baseTransform.Scale );
	}

	/// <summary>
	/// Reads the target bone transform without modifying the skeleton (rig-driven when apply is off).
	/// </summary>
	private bool TryReadTargetBoneTransform(
		SkinnedModelRenderer skeletonRenderer,
		GameObject targetBone,
		string boneName,
		out Transform localTransform )
	{
		localTransform = default;

		if ( !skeletonRenderer.IsValid() || string.IsNullOrWhiteSpace( boneName ) )
			return false;

		var boneObject = skeletonRenderer.GetBoneObject( boneName );

		if ( targetBone.IsValid() )
		{
			if ( !boneObject.IsValid() || targetBone == boneObject )
			{
				localTransform = targetBone.LocalTransform;
				return true;
			}
		}

		if ( boneObject.IsValid() )
		{
			localTransform = boneObject.LocalTransform;
			return true;
		}

		if ( !TryFindBone( skeletonRenderer, boneName, out var bone, out var runtimeIndex ) )
			return false;

		return TryGetAnimatedLocalTransform( skeletonRenderer, bone, out localTransform )
			|| skeletonRenderer.TryGetBoneTransformLocal( bone, out localTransform );
	}

	private bool TryFindBone( SkinnedModelRenderer renderer, string boneName, out BoneCollection.Bone bone, out int runtimeIndex )
	{
		bone = default;
		runtimeIndex = -1;

		if ( !renderer.IsValid() || string.IsNullOrWhiteSpace( boneName ) )
			return false;

		if ( renderer.Model.IsValid() && renderer.Model.Bones.HasBone( boneName ) )
			bone = renderer.Model.Bones.GetBone( boneName );

		var transforms = renderer.GetBoneTransforms( false );
		if ( transforms is not null )
		{
			for ( var i = 0; i < transforms.Length; i++ )
			{
				var boneObject = renderer.GetBoneObject( i );
				if ( !boneObject.IsValid() || !boneObject.Name.Equals( boneName, StringComparison.OrdinalIgnoreCase ) )
					continue;

				runtimeIndex = i;
				if ( bone.Index < 0 && renderer.Model.IsValid() )
				{
					foreach ( var candidate in renderer.Model.Bones.AllBones )
					{
						if ( candidate.Index == i )
						{
							bone = candidate;
							break;
						}
					}
				}

				return true;
			}
		}

		return bone.Index >= 0 || !string.IsNullOrWhiteSpace( bone.Name );
	}
}
