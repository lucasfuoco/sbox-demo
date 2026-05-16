namespace Sandbox.Components.WeaponEquipmentComponents;

[Title( "Recoil" ), Group( "Weapon Components" )]
public partial class ShootRecoilEquipmentComponent : WeaponEquipmentComponent
{
	[Property] public float ResetTime { get; set; } = 0.3f;

	// Recoil Patterns
	[Property, FeatureEnabled( "Recoil Pattern" )] public bool UseRecoilPattern { get; set; } = false;
	[Property, Category( "UseRecoilPattern" ), Feature( "Recoil Pattern" )] public Vector2 Scale { get; set; } = new Vector2( 2f, 5f );
	[Property, Category( "UseRecoilPattern" ), Feature( "Recoil Pattern" ) ] public RecoilPattern RecoilPattern { get; set; } = new();
	[Property, Group( "Standard Recoil" ), Feature( "Standard Recoil" )] public RangedFloat HorizontalSpread { get; set; } 
	[Property, Group( "Standard Recoil" ), Feature( "Standard Recoil" )] public RangedFloat VerticalSpread { get; set; }

	internal Angles Current { get; private set; }

	TimeSince TimeSinceLastShot;
	int currentFrame = 0;

	internal void Shoot()
	{
		if ( TimeSinceLastShot > ResetTime )
			currentFrame = 0;

		TimeSinceLastShot = 0;

		// Per-shot kick in degrees. Do not use Time.Delta here: Shoot() is invoked from FixedUpdate where Delta is often zero.
		if ( UseRecoilPattern )
		{
			var point = RecoilPattern.GetPoint( ref currentFrame );

			var newAngles = new Angles( -point.y * Scale.y, -point.x * Scale.x, 0 );
			Current = Current + newAngles;
			currentFrame++;
		}
		else
		{
			var newAngles = new Angles( -VerticalSpread.GetValue(), HorizontalSpread.GetValue(), 0 );
			Current = Current + newAngles;
		}

	}

	protected override void OnUpdate()
	{
		if ( !Player.IsValid() )
			return;

		if ( !Player.IsLocallyControlled )
			return;

		Current = Current.LerpTo( Angles.Zero, Time.Delta * 10f );
	}
}
