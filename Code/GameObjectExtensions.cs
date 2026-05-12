using Sandbox.Diagnostics;
using Scene = Sandbox.Scene;
using Sandbox.Components;

namespace Sandbox;

public static partial class GameObjectExtensions
{
	/// <summary>
	/// Take damage. Only the host can call this.
	/// </summary>
	/// <param name="go"></param>
	/// <param name="damageInfo"></param>
	public static void TakeDamage( this GameObject go, DamageInfo damageInfo )
	{
		if ( !Networking.IsHost )
		{
			Log.Warning( $"Tried to run TakeDamage on {go}, but we're not the host." );
			return;
		}

		foreach ( var damageable in go.Root.GetComponents<HealthComponent>() )
		{
			damageable.TakeDamage( damageInfo );
		}
	}

	public static void CopyPropertiesTo( this Component src, Component dst )
	{
		var json = src.Serialize().AsObject();
		json.Remove( "__guid" );
		dst.DeserializeImmediately( json );
	}

	public static string GetScenePath( this GameObject go )
	{
		return go is Scene ? "" : $"{go.Parent.GetScenePath()}/{go.Name}";
	}

		/// <summary>
	/// Creates a <see cref="DestroyAfterComponent"/> which will deferred delete the <see cref="GameObject"/>.
	/// </summary>
	/// <param name="self"></param>
	/// <param name="seconds"></param>
	public static void DestroyAsync( this GameObject self, float seconds = 1.0f )
	{
		var component = self.Components.Create<DestroyAfterComponent>();
		component.Time = seconds;
	}
}
