namespace Sandbox;

using Sandbox.Components.SingletonComponents;

/// <summary>
/// Single soft ground blob that fakes cloud shadows without per-sprite shadow maps.
/// </summary>
sealed class WorldCloudGroundShadow
{
	readonly SpriteRenderer _sprite;
	WorldManagerSingletonComponent _terrain;

	public GameObject Root { get; }

	WorldCloudGroundShadow( GameObject root, SpriteRenderer sprite )
	{
		Root = root;
		_sprite = sprite;
	}

	public static WorldCloudGroundShadow Create( GameObject parent )
	{
		var root = new GameObject( true, "CloudGroundShadow" );
		root.Tags.Add( "particles" );
		root.Flags |= GameObjectFlags.NotSaved;
		root.SetParent( parent );

		var sprite = root.Components.Create<SpriteRenderer>();
		sprite.Sprite = ResourceLibrary.Get<Sprite>( "sprites/cloud_mist.sprite" );
		sprite.Billboard = SpriteRenderer.BillboardMode.None;
		sprite.Lighting = false;
		sprite.Shadows = false;
		sprite.Additive = false;
		sprite.Opaque = false;
		sprite.Color = Color.Black.WithAlpha( 0f );

		return new WorldCloudGroundShadow( root, sprite );
	}

	public void Update(
		Vector3 listener,
		float cloudDensity,
		float footprintWidth,
		bool enabled )
	{
		cloudDensity = MathX.Clamp( cloudDensity, 0f, 1.5f );
		var time = WorldManagerComponent.Instance is { IsValid: true } world
			? world.TimeOfDay
			: 12f;
		var sun = WorldAtmospherePalette.GetSunLightIntensity( time );
		var strength = cloudDensity * sun;

		if ( !enabled || strength < 0.04f )
		{
			Root.Enabled = false;
			return;
		}

		Root.Enabled = true;
		EnsureTerrain();

		var sunDir = WorldAtmospherePalette.GetSunSkyDirection( time ).WithZ( 0f );
		var sunHorizontal = sunDir.LengthSquared > 0.0001f ? sunDir.Normal : Vector3.Forward;
		// Shadow falls opposite the sun on the ground.
		var shadowCenter = listener - sunHorizontal * MathX.Lerp( 400f, 1600f, sun );

		var groundZ = _terrain.IsValid()
			? _terrain.GetHeight( shadowCenter.x, shadowCenter.y )
			: listener.z - 64f;

		Root.WorldPosition = new Vector3( shadowCenter.x, shadowCenter.y, groundZ + 24f );
		// Flat on the ground plane.
		Root.WorldRotation = Rotation.FromPitch( 90f );

		var size = MathX.Clamp( footprintWidth * 0.55f, 1800f, 14000f );
		size *= MathX.Lerp( 0.75f, 1.15f, MathX.Clamp( cloudDensity, 0f, 1f ) );
		_sprite.Size = new Vector2( size, size );
		_sprite.Color = new Color( 0.02f, 0.03f, 0.05f, MathX.Clamp( strength * 0.22f, 0f, 0.28f ) );
	}

	void EnsureTerrain()
	{
		if ( _terrain.IsValid() )
			return;

		_terrain = Root.Scene?.GetAllComponents<WorldManagerSingletonComponent>().FirstOrDefault();
	}
}

static class WorldCloudGroundShadowValidation
{
	public static bool IsValid( this WorldCloudGroundShadow shadow ) => shadow?.Root.IsValid() == true;
}
