namespace Sandbox.Components.WeaponModelComponents;

public partial class WorldWeaponModelComponent : WeaponModelComponent
{
	/// <summary>
	/// Subtree holding <c>slot_{category}_{option}</c> meshes. When unset, uses a child named <c>attachments</c> or the world model root.
	/// </summary>
	[Property] public GameObject AttachmentSlotsRoot { get; set; }

	protected override void OnStart()
	{
		ResolveAttachmentSlotsRoot();
	}

	protected override void OnValidate()
	{
		ResolveAttachmentSlotsRoot();
	}

	void ResolveAttachmentSlotsRoot()
	{
		if ( AttachmentSlotsRoot.IsValid() )
			return;

		AttachmentSlotsRoot = GameObject.Children.FirstOrDefault( c => c.Name == "attachments" );
	}

	public override GameObject GetSlotRoot( string category ) =>
		AttachmentSlotsRoot.IsValid() ? AttachmentSlotsRoot : GameObject;
}
