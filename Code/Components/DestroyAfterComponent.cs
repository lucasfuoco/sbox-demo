namespace Sandbox.Components;

/// <summary>
/// A simple component that destroys its GameObject.
/// </summary>
public sealed class DestroyAfterComponent : Component
{
	/// <summary>
	/// How long until we destroy the GameObject.
	/// </summary>
	[Property] public float Time { get; set; } = 1f;

	/// <summary>
	/// The real time until we destroy the GameObject.
	/// </summary>
	[Property, ReadOnly] TimeUntil TimeUntilDestroy { get; set; } = 0;

	[Property]
	public bool WaitForChildEffects = false;

	protected override void OnStart()
	{
		TimeUntilDestroy = Time;
	}

	bool HasActiveEffects()
	{
		foreach ( var pe in GetComponentsInChildren<ITemporaryEffect>() )
		{
			if ( pe.IsActive )
				return true;
		}

		return false;
	}

	protected override void OnUpdate()
	{
		if ( WaitForChildEffects && HasActiveEffects() )
		{
			return;
		}

		if ( TimeUntilDestroy )
		{
			GameObject.Destroy();
		}
	}
}