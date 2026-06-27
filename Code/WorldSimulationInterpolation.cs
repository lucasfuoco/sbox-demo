namespace Sandbox;

static class WorldSimulationInterpolation
{
	public static float NetworkLerp( float current, float target, float deltaTime, float networkRate )
	{
		var t = deltaTime / Math.Max( networkRate, 0.0001f );
		return current.LerpTo( target, t );
	}

	public static Vector3 NetworkLerp( Vector3 current, Vector3 target, float deltaTime, float networkRate )
	{
		var t = deltaTime / Math.Max( networkRate, 0.0001f );
		return current.LerpTo( target, t );
	}

	public static float NetworkLerpTimeOfDay( float current, float target, float deltaTime, float networkRate )
	{
		var t = deltaTime / Math.Max( networkRate, 0.0001f );
		return LerpTimeOfDay( current, target, t );
	}

	public static float LerpTimeOfDay( float from, float to, float t )
	{
		var delta = ((to - from) % 24f + 24f) % 24f;
		if ( delta > 12f )
			delta -= 24f;

		return (from + delta * t + 24f) % 24f;
	}
}
