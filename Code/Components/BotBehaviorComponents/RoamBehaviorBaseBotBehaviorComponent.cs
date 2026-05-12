using Sandbox.BehaviorNodes;
using Sandbox.Components;

namespace Sandbox.Components.BotBehaviorComponents;

public class RoamBotBehaviorComponent : BaseBotBehaviorComponent
{
	private IBehaviorNode _behavior;

	public override float Score( BotContext ctx )
	{
		return 10f;
	}

	protected override void OnInitialize()
	{
		// Build behavior tree
		_behavior = new SequenceBehaviorNode(
			new GetRandomPointBehaviorNode(),
			new MoveToBehaviorNode( 50, true )
		);
	}

	public override NodeResult Update( BotContext ctx )
	{
		return _behavior.Evaluate( ctx );
	}
}
