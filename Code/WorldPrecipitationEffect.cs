namespace Sandbox;

sealed class WorldPrecipitationEffect
{
	enum Kind
	{
		Rain,
		Snow,
	}

	readonly Kind _kind;
	readonly ParticleEffect _effect;
	readonly ParticleBoxEmitter _emitter;

	public GameObject Root { get; }

	WorldPrecipitationEffect( GameObject root, ParticleEffect effect, ParticleBoxEmitter emitter, Kind kind )
	{
		Root = root;
		_effect = effect;
		_emitter = emitter;
		_kind = kind;
	}

	public static WorldPrecipitationEffect Create( GameObject parent, bool snow )
	{
		var root = new GameObject( true, snow ? "Snow" : "Rain" );
		root.Tags.Add( "particles" );
		root.SetParent( parent );

		var effect = root.Components.Create<ParticleEffect>();
		var emitter = root.Components.Create<ParticleBoxEmitter>();

		var kind = snow ? Kind.Snow : Kind.Rain;
		ConfigureEffect( effect, kind );
		ConfigureEmitter( emitter );

		return new WorldPrecipitationEffect( root, effect, emitter, kind );
	}

	public void Update( Vector3 center, float amount, Vector3 windDirection, float windStrength, float temperature )
	{
		var active = amount > 0.01f;
		Root.Enabled = active;

		if ( !active )
		{
			_emitter.Rate = 0f;
			return;
		}

		Root.WorldPosition = center;

		var wind = windDirection.WithZ( 0f );
		if ( wind.LengthSquared <= 0.0001f )
			wind = Vector3.Forward;

		wind = wind.Normal;

		var fallSpeed = _kind == Kind.Rain
			? MathX.Lerp( 350f, 900f, amount ) + windStrength * 250f
			: MathX.Lerp( 40f, 120f, amount ) + windStrength * 40f;

		var windPush = wind * windStrength * (_kind == Kind.Rain ? 500f : 120f);
		_effect.ForceDirection = (Vector3.Down * fallSpeed + windPush).Normal;
		_effect.ForceScale = MakeConstant( fallSpeed );
		_effect.ConstantMovement = new ParticleVector3
		{
			X = MakeRange( -windPush.x * 0.15f, windPush.x * 0.15f ),
			Y = MakeRange( -windPush.y * 0.15f, windPush.y * 0.15f ),
			Z = MakeRange( -20f, 20f ),
		};

		if ( _kind == Kind.Snow && temperature > 2f )
		{
			_emitter.Rate = amount * 1200f * 0.35f;
		}
		else
		{
			_emitter.Rate = amount * (_kind == Kind.Rain ? 2500f : 1200f);
		}

		_effect.Gradient = _kind == Kind.Rain
			? MakeColor( new Color( 0.72f, 0.8f, 0.92f, 0.55f ) )
			: MakeColor( Color.White.WithAlpha( 0.85f ) );
	}

	static void ConfigureEffect( ParticleEffect effect, Kind kind )
	{
		effect.MaxParticles = kind == Kind.Rain ? 6000 : 4500;
		effect.PreWarm = 1.5f;
		effect.Lifetime = MakeRange( kind == Kind.Rain ? 0.8f : 2.5f, kind == Kind.Rain ? 1.6f : 5f );
		effect.ApplyAlpha = true;
		effect.ApplyColor = true;
		effect.ApplyShape = true;
		effect.ApplyRotation = kind == Kind.Snow;
		effect.Force = true;
		effect.ForceSpace = ParticleEffect.SimulationSpace.World;
		effect.Damping = MakeConstant( 0f );
		effect.Scale = MakeRange( kind == Kind.Rain ? 0.04f : 0.08f, kind == Kind.Rain ? 0.12f : 0.22f );
		effect.StartVelocity = MakeRange( kind == Kind.Rain ? 0f : 10f, kind == Kind.Rain ? 30f : 40f );
		effect.Brightness = kind == Kind.Rain ? 1.1f : 1.25f;
		effect.Gradient = MakeColor( kind == Kind.Rain
			? new Color( 0.72f, 0.8f, 0.92f, 0.55f )
			: Color.White.WithAlpha( 0.85f ) );
	}

	static void ConfigureEmitter( ParticleBoxEmitter emitter )
	{
		emitter.Loop = true;
		emitter.Duration = 99999f;
		emitter.Delay = 0f;
		emitter.Rate = 0f;
		emitter.Size = new Vector3( 2200f, 2200f, 900f );
	}

	static ParticleFloat MakeRange( float min, float max ) => new( min, max );

	static ParticleFloat MakeConstant( float value ) => new( value, value );

	static ParticleGradient MakeColor( Color color ) => new()
	{
		Type = ParticleGradient.ValueType.Constant,
		ConstantValue = color,
	};
}
