using Sandbox.Components;

namespace Sandbox.Valids;

public interface IAreaDamageReceiverValid : IValid
{
	Guid Id { get; }
	GameObject GameObject { get; }
	void ApplyAreaDamage( AreaDamageComponent component );
}