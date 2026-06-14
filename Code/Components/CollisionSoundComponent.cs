using Sandbox.Attributes;

namespace Sandbox.Components;

/// <summary>
/// Plays bullet casing bounce sounds based on the collided surface's audio type.
/// </summary>
[Title( "Collision Sound" ), Category( "Effects" )]
public sealed class CollisionSoundComponent : Component, Component.ICollisionListener
{
	[Property] public float MinImpactSpeed { get; set; } = 20f;
	[Property] public float MinTimeBetweenImpacts { get; set; } = 0.05f;
	[Property] public bool DisableBuiltInCollisionSounds { get; set; } = true;

	[Property, Group( "Fallback" )] public SoundEvent GenericSound { get; set; } = null;
	[Property, Group( "Fallback" )] public bool UseSurfaceImpactHardFallback { get; set; } = true;

	[Property, Group( "Surface Sounds" )] public SoundEvent BrickSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent ConcreteSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent CeramicSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent GravelSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent CarpetSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent GlassSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent PlasterSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent WoodSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent MetalSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent RockSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent FabricSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent FoamSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent SandSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent SnowSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent SoilSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent CurtainSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent SteelSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent AcousticTileSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent LeatherSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent LinoleumSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent AsphaltSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent WaterSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent MarbleSound { get; set; } = null;
	[Property, Group( "Surface Sounds" )] public SoundEvent PaperSound { get; set; } = null;

	private TimeSince _timeSinceLastImpact;

	protected override void OnStart()
	{
		if ( !DisableBuiltInCollisionSounds )
			return;

		foreach ( var body in GetComponents<Rigidbody>() )
		{
			if ( body.PhysicsBody.IsValid() )
				body.PhysicsBody.EnableCollisionSounds = false;
		}
	}

	void ICollisionListener.OnCollisionStart( Collision collision )
	{
		var impactSpeed = MathF.Abs( collision.Contact.NormalSpeed );
		if ( impactSpeed < MinImpactSpeed )
			return;

		if ( _timeSinceLastImpact < MinTimeBetweenImpacts )
			return;

		_timeSinceLastImpact = 0f;

		var surface = collision.Other.Surface ?? collision.Self.Surface;
		var sound = ResolveSound( surface );

		if ( sound is null )
			return;

		Sound.Play( sound, collision.Contact.Point );
	}

	private SoundEvent ResolveSound( Surface surface )
	{
		if ( surface is null )
			return GenericSound;

		var mapped = ResolveByAudioSurface( surface.AudioSurface );
		if ( mapped is not null )
			return mapped;

		if ( UseSurfaceImpactHardFallback )
			return surface.SoundCollection.ImpactHard ?? GenericSound;

		return GenericSound;
	}

	private SoundEvent ResolveByAudioSurface( AudioSurface audioSurface ) => audioSurface switch
	{
		AudioSurface.Brick => BrickSound,
		AudioSurface.Concrete => ConcreteSound,
		AudioSurface.Ceramic => CeramicSound,
		AudioSurface.Gravel => GravelSound,
		AudioSurface.Carpet => CarpetSound,
		AudioSurface.Glass => GlassSound,
		AudioSurface.Plaster => PlasterSound,
		AudioSurface.Wood => WoodSound,
		AudioSurface.Metal => MetalSound,
		AudioSurface.Rock => RockSound,
		AudioSurface.Fabric => FabricSound,
		AudioSurface.Foam => FoamSound,
		AudioSurface.Sand => SandSound,
		AudioSurface.Snow => SnowSound,
		AudioSurface.Soil => SoilSound,
		AudioSurface.Curtain => CurtainSound,
		AudioSurface.Steel => SteelSound,
		AudioSurface.AcousticTile => AcousticTileSound,
		AudioSurface.Leather => LeatherSound,
		AudioSurface.Linoleum => LinoleumSound,
		AudioSurface.Asphalt => AsphaltSound,
		AudioSurface.Water => WaterSound,
		AudioSurface.Marble => MarbleSound,
		AudioSurface.Paper => PaperSound,
		_ => GenericSound
	};
}
