namespace Sandbox.Components;

/// <summary>
/// GodotOceanWaves-style sea spray: billboarded splash particles near the camera.
/// Density driven by foam intensity from Ocean FFT Manager (presentation only).
/// </summary>
[Title( "Ocean FFT Sea Spray Renderer" ), Category( "Water" ), Icon( "water_drop" )]
public sealed class OceanFftSeaSprayRendererComponent : Component
{
	const float EmitterWidth = 4200f;
	const float EmitterDepth = 4200f;
	const float EmitterHeight = 160f;

	ParticleEffect _effect;
	ParticleBoxEmitter _emitter;
	ParticleSpriteRenderer _renderer;
	ParticleGradient _sprayGradient = new()
	{
		Type = ParticleGradient.ValueType.Constant,
	};
	bool _configured;

	public void UpdateSpray( Vector3 cameraPosition, float intensity )
	{
		EnsureConfigured();

		intensity = MathX.Clamp( intensity, 0f, 1f );
		WorldPosition = new Vector3( cameraPosition.x, cameraPosition.y, cameraPosition.z - 40f );

		if ( intensity < 0.02f )
		{
			GameObject.Enabled = false;
			_emitter.Rate = MakeConstant( 0f );
			return;
		}

		GameObject.Enabled = true;
		_emitter.Rate = MakeConstant( MathX.Lerp( 10f, 100f, intensity ) );
		_effect.Scale = MakeRange(
			MathX.Lerp( 10f, 18f, intensity ),
			MathX.Lerp( 22f, 48f, intensity ) );
		_sprayGradient.ConstantValue = new Color( 0.9f, 0.95f, 1f, MathX.Lerp( 0.2f, 0.65f, intensity ) );
		_effect.Gradient = _sprayGradient;
	}

	void EnsureConfigured()
	{
		if ( _configured )
			return;

		_effect = Components.Get<ParticleEffect>( true ) ?? Components.Create<ParticleEffect>();
		_emitter = Components.Get<ParticleBoxEmitter>( true ) ?? Components.Create<ParticleBoxEmitter>();
		_renderer = Components.Get<ParticleSpriteRenderer>( true ) ?? Components.Create<ParticleSpriteRenderer>();

		_renderer.Sprite = ResourceLibrary.Get<Sprite>( "sprites/rain_splash.sprite" );
		_renderer.Additive = true;
		_renderer.Lighting = false;
		_renderer.Shadows = false;
		_renderer.FaceVelocity = false;
		_renderer.Opaque = false;
		_renderer.Scale = 1f;
		_renderer.FogStrength = 0.15f;

		_effect.MaxParticles = 220;
		_effect.PreWarm = 0.2f;
		_effect.Lifetime = MakeRange( 0.4f, 1.0f );
		_effect.ApplyAlpha = true;
		_effect.ApplyColor = true;
		_effect.ApplyShape = true;
		_effect.Force = true;
		_effect.ForceDirection = Vector3.Down;
		_effect.ForceScale = MakeConstant( 180f );
		_effect.ForceSpace = ParticleEffect.SimulationSpace.World;
		_effect.Damping = MakeConstant( 1.2f );
		_effect.Scale = MakeRange( 14f, 36f );
		_effect.StartVelocity = MakeConstant( 0f );
		_effect.ConstantMovement = new ParticleVector3
		{
			X = MakeRange( -30f, 30f ),
			Y = MakeRange( -30f, 30f ),
			Z = MakeRange( 60f, 180f ),
		};
		_effect.Brightness = 1.4f;
		_effect.Collision = false;
		_effect.Gradient = new ParticleGradient
		{
			Type = ParticleGradient.ValueType.Constant,
			ConstantValue = new Color( 0.9f, 0.95f, 1f, 0.4f ),
		};

		_emitter.Loop = true;
		_emitter.Duration = 99999f;
		_emitter.Delay = 0f;
		_emitter.Rate = MakeConstant( 0f );
		_emitter.Size = new Vector3( EmitterWidth, EmitterDepth, EmitterHeight );

		_configured = true;
	}

	static ParticleFloat MakeRange( float min, float max ) => new( min, max );
	static ParticleFloat MakeConstant( float value ) => new( value, value );
}
