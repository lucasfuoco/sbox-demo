namespace Sandbox.Components;

using Sandbox.Components.SingletonComponents;

/// <summary>
/// Point-light + bolt sprite presentation for storm-cloud lightning flashes.
/// Bolt runs from the cloud flash (light source) down to terrain.
/// </summary>
[Title( "Weather Volume Lightning Renderer" ), Category( "World Simulation" ), Icon( "lightbulb" )]
public sealed class WeatherVolumeLightningRendererComponent : Component, Component.ExecuteInEditor
{
	const int MaxLights = 4;
	const string DefaultBoltSprite = "sprites/lightning_bolt.sprite";

	[Property, Group( "Light" ), Title( "Peak Radius" ), Range( 500f, 80000f )]
	public float PeakRadius { get; set; } = 24000f;

	[Property, Group( "Light" ), Title( "Peak Brightness" ), Range( 1f, 400f ), Description( "RGB scale baked into LightColor (s&box lights use color for intensity)." )]
	public float PeakBrightness { get; set; } = 160f;

	[Property, Group( "Light" ), Title( "Flash Color" )]
	public Color FlashColor { get; set; } = new Color( 0.45f, 0.7f, 1.6f );

	[Property, Group( "Light" ), Title( "Attenuation" ), Range( 0.5f, 8f )]
	public float Attenuation { get; set; } = 0.75f;

	[Property, Group( "Light" ), Title( "Fog Strength" ), Range( 0f, 2f )]
	public float FogStrength { get; set; } = 1.5f;

	[Property, Group( "Sprite" ), Title( "Enable Bolt Sprite" )]
	public bool EnableBoltSprite { get; set; } = true;

	[Property, Group( "Sprite" ), Title( "Bolt Sprite" )]
	public Sprite BoltSprite { get; set; }

	[Property, Group( "Sprite" ), Title( "Bolt Width" ), Range( 200f, 40000f ), Description( "World-unit width of the bolt sprite." )]
	public float BoltWidth { get; set; } = 12000f;

	[Property, Group( "Sprite" ), Title( "Bolt Brightness" ), Range( 1f, 80f ), Description( "Color multiplier for the bolt sprite." )]
	public float BoltBrightness { get; set; } = 28f;

	[Property, Group( "Sprite" ), Title( "Fallback Bolt Length" ), Range( 1000f, 80000f ), Description( "Used when terrain height cannot be resolved." )]
	public float BoltLength { get; set; } = 32000f;

	readonly List<GameObject> _lightObjects = new( MaxLights );
	readonly List<PointLight> _lights = new( MaxLights );
	readonly List<GameObject> _boltObjects = new( MaxLights );
	readonly List<SpriteRenderer> _bolts = new( MaxLights );
	readonly int[] _boltFrames = new int[MaxLights];
	readonly int[] _boltFlashIds = new int[MaxLights];
	WorldManagerSingletonComponent _terrain;
	bool _poolsBuilt;

	protected override void OnAwake()
	{
		RebuildPools();
	}

	protected override void OnDestroy()
	{
		DestroyOwnedLightningChildren();
		_lightObjects.Clear();
		_lights.Clear();
		_boltObjects.Clear();
		_bolts.Clear();
		_poolsBuilt = false;
	}

	protected override void OnDisabled()
	{
		SetFlashes( Array.Empty<WeatherLightningFlash>() );
	}

	public void SetFlashes( IReadOnlyList<WeatherLightningFlash> flashes )
	{
		EnsurePools();

		var count = flashes?.Count ?? 0;
		for ( var i = 0; i < MaxLights; i++ )
		{
			UpdateLightSlot( i, count, flashes );
			UpdateBoltSlot( i, count, flashes );
		}
	}

	void EnsurePools()
	{
		if ( !_poolsBuilt || _lightObjects.Count == 0 || (EnableBoltSprite && _boltObjects.Count == 0) )
			RebuildPools();
	}

	void RebuildPools()
	{
		DestroyOwnedLightningChildren();
		_lightObjects.Clear();
		_lights.Clear();
		_boltObjects.Clear();
		_bolts.Clear();
		Array.Clear( _boltFlashIds );
		Array.Clear( _boltFrames );

		EnsureLightPool();
		if ( EnableBoltSprite )
			EnsureBoltPool();

		_poolsBuilt = _lightObjects.Count > 0;
	}

	void DestroyOwnedLightningChildren()
	{
		foreach ( var child in GameObject.Children.ToArray() )
		{
			if ( !child.IsValid() )
				continue;

			if ( child.Name.StartsWith( "StormLightningBolt_", StringComparison.Ordinal )
				|| child.Name.StartsWith( "StormLightningLight_", StringComparison.Ordinal ) )
			{
				child.Destroy();
			}
		}
	}

	void UpdateLightSlot( int i, int count, IReadOnlyList<WeatherLightningFlash> flashes )
	{
		if ( i >= _lightObjects.Count )
			return;

		var lightObject = _lightObjects[i];
		var light = _lights[i];
		if ( !lightObject.IsValid() || !light.IsValid() )
			return;

		if ( i >= count || flashes[i].Intensity <= 0.01f )
		{
			light.LightColor = Color.Black;
			light.Enabled = false;
			lightObject.Enabled = false;
			return;
		}

		var flash = flashes[i];
		var intensity = MathX.Clamp( flash.Intensity, 0f, 1.5f );
		ResolveStrikeSpan( flash.Position, out var source, out _, out var length );

		var listener = ResolveListenerPosition();
		var radius = MathF.Max( PeakRadius, length * 1.15f );
		radius = MathF.Max( radius, (listener - source).Length * 1.1f );
		radius *= MathX.Lerp( 0.85f, 1.2f, MathX.Clamp( intensity, 0f, 1f ) );

		// Place the light closer to the listener so the flash reads on the ground in play mode.
		var lightPos = Vector3.Lerp( source, listener + Vector3.Up * 200f, 0.35f );
		lightObject.Enabled = true;
		lightObject.WorldPosition = lightPos;
		light.Enabled = true;
		light.Radius = radius;
		light.Attenuation = MathF.Min( Attenuation, 0.85f );
		light.FogStrength = MathF.Max( FogStrength, 1.25f );
		light.FogMode = Light.FogInfluence.Enabled;
		light.Shadows = false;
		var brightness = PeakBrightness * intensity * (Game.IsPlaying ? 1.35f : 1f);
		light.LightColor = (FlashColor * brightness).WithAlpha( 1f );
	}

	void UpdateBoltSlot( int i, int count, IReadOnlyList<WeatherLightningFlash> flashes )
	{
		if ( i >= _boltObjects.Count )
			return;

		var boltObject = _boltObjects[i];
		var bolt = _bolts[i];
		if ( !boltObject.IsValid() || !bolt.IsValid() )
			return;

		if ( !EnableBoltSprite || i >= count || flashes[i].Intensity <= 0.01f )
		{
			ClearBoltSlot( i );
			return;
		}

		var flash = flashes[i];
		var intensity = MathX.Clamp( flash.Intensity, 0f, 1.5f );
		var sprite = BoltSprite.IsValid() ? BoltSprite : ResourceLibrary.Get<Sprite>( DefaultBoltSprite );
		if ( !sprite.IsValid() )
		{
			ClearBoltSlot( i );
			return;
		}

		if ( _boltFlashIds[i] != flash.Id )
		{
			var frameCount = GetSpriteFrameCount( sprite );
			_boltFrames[i] = frameCount > 1 ? Game.Random.Int( 0, frameCount - 1 ) : 0;
			_boltFlashIds[i] = flash.Id;
		}

		ResolveStrikeSpan( flash.Position, out var source, out var ground, out var length );
		var width = BoltWidth * MathX.Lerp( 0.95f, 1.35f, MathX.Clamp( intensity, 0f, 1f ) );
		var brightness = BoltBrightness * MathX.Lerp( 0.7f, 1.45f, MathX.Clamp( intensity, 0f, 1f ) );
		var alpha = MathX.Clamp( intensity, 0f, 1f );
		// Billboard is centered on the transform — place mid-span so the bolt reaches the ground.
		var mid = (source + ground) * 0.5f;

		bolt.Sprite = sprite;
		bolt.CurrentFrameIndex = _boltFrames[i];
		bolt.PlaybackSpeed = 0f;
		bolt.Billboard = SpriteRenderer.BillboardMode.YOnly;
		bolt.Lighting = false;
		bolt.Shadows = false;
		bolt.Additive = true;
		bolt.Opaque = false;
		bolt.FogStrength = 0f;
		bolt.Size = new Vector2( width, length );
		bolt.Color = new Color(
			FlashColor.r * brightness,
			FlashColor.g * brightness,
			FlashColor.b * brightness,
			alpha );

		boltObject.Enabled = true;
		boltObject.WorldPosition = mid;
		boltObject.WorldRotation = Rotation.Identity;
	}

	void ClearBoltSlot( int i )
	{
		if ( i < 0 || i >= _boltObjects.Count )
			return;

		var boltObject = _boltObjects[i];
		var bolt = _bolts[i];
		_boltFlashIds[i] = 0;

		if ( bolt.IsValid() )
		{
			bolt.Color = Color.Transparent;
			bolt.Size = Vector2.Zero;
		}

		if ( boltObject.IsValid() )
			boltObject.Enabled = false;
	}

	void ResolveStrikeSpan( Vector3 flashPosition, out Vector3 source, out Vector3 ground, out float length )
	{
		source = flashPosition;
		var groundZ = ResolveGroundZ( flashPosition.x, flashPosition.y, flashPosition.z );
		ground = new Vector3( flashPosition.x, flashPosition.y, groundZ );
		length = MathF.Max( source.z - groundZ, 500f );
	}

	float ResolveGroundZ( float x, float y, float sourceZ )
	{
		EnsureTerrain();
		if ( _terrain.IsValid() )
			return _terrain.GetHeight( x, y );

		var listener = ResolveListenerPosition();
		if ( (listener.WithZ( 0f ) - new Vector3( x, y, 0f )).Length < 8000f )
			return listener.z - 32f;

		return sourceZ - MathF.Max( BoltLength, 1000f );
	}

	void EnsureTerrain()
	{
		if ( _terrain.IsValid() )
			return;

		var world = WorldManagerComponent.Instance;
		if ( world.IsValid() )
		{
			_terrain = world.GameObject.Components.Get<WorldManagerSingletonComponent>();
			if ( _terrain.IsValid() )
				return;
		}

		_terrain = Scene?.GetAllComponents<WorldManagerSingletonComponent>().FirstOrDefault();
	}

	Vector3 ResolveListenerPosition()
	{
		var camera = Scene?.Camera;
		if ( camera.IsValid() )
			return camera.WorldPosition;

		return WorldPosition;
	}

	void EnsureLightPool()
	{
		while ( _lightObjects.Count < MaxLights )
		{
			var lightObject = new GameObject( true, $"StormLightningLight_{_lightObjects.Count}" );
			lightObject.Tags.Add( "light", "light_point" );
			lightObject.Flags |= GameObjectFlags.NotSaved;
			lightObject.SetParent( GameObject );
			lightObject.Enabled = false;

			var light = lightObject.Components.Create<PointLight>();
			light.Shadows = false;
			light.FogMode = Light.FogInfluence.Enabled;
			light.FogStrength = FogStrength;
			light.Attenuation = Attenuation;
			light.Radius = PeakRadius;
			light.LightColor = Color.Black;
			light.Enabled = false;

			_lightObjects.Add( lightObject );
			_lights.Add( light );
		}
	}

	void EnsureBoltPool()
	{
		BoltSprite ??= ResourceLibrary.Get<Sprite>( DefaultBoltSprite );
		if ( !BoltSprite.IsValid() )
			return;

		while ( _boltObjects.Count < MaxLights )
		{
			var index = _boltObjects.Count;
			var boltObject = new GameObject( true, $"StormLightningBolt_{index}" );
			boltObject.Flags |= GameObjectFlags.NotSaved;
			boltObject.SetParent( GameObject );
			boltObject.Enabled = false;

			var bolt = boltObject.Components.Create<SpriteRenderer>();
			bolt.Sprite = BoltSprite;
			bolt.Billboard = SpriteRenderer.BillboardMode.YOnly;
			bolt.Lighting = false;
			bolt.Shadows = false;
			bolt.Additive = true;
			bolt.Opaque = false;
			bolt.FogStrength = 0f;
			bolt.PlaybackSpeed = 0f;
			bolt.Color = Color.Transparent;
			bolt.Size = Vector2.Zero;

			_boltObjects.Add( boltObject );
			_bolts.Add( bolt );
			_boltFlashIds[index] = 0;
		}
	}

	static int GetSpriteFrameCount( Sprite sprite )
	{
		if ( !sprite.IsValid() || sprite.Animations.Count == 0 )
			return 1;

		var animation = sprite.GetAnimation( 0 );
		if ( animation is null )
			return 1;

		return Math.Max( animation.Frames.Count, 1 );
	}
}
