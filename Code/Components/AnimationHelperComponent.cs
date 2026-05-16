namespace Sandbox.Components;

public sealed class AnimationHelperComponent : Component
{
	[Property] public SkinnedModelRenderer Target { get; set; }

	[Property] public GameObject EyeSource { get; set; }

	bool AnimTargetOk => Target is not null && Target.IsValid();


	[Property, Range( 0.5f, 1.5f )] public float Height { get; set; } = 1.0f;

	[Property] public GameObject IkLeftHand { get; set; }
	[Property] public GameObject IkRightHand { get; set; }
	[Property] public GameObject IkLeftFoot { get; set; }
	[Property] public GameObject IkRightFoot { get; set; }

	public void ProceduralHitReaction( float damageScale = 1.0f, Vector3 force = default )
	{
		if ( !AnimTargetOk )
			return;

		var boneId = 0;
		var tx = Target.GetBoneObject( boneId );

		if ( !tx.IsValid() ) return;

		var localToBone = tx.Transform.Local.Position;
		if ( localToBone == Vector3.Zero ) localToBone = Vector3.One;

		Target.Set( "hit", true );
		Target.Set( "hit_bone", boneId );
		Target.Set( "hit_offset", localToBone );
		Target.Set( "hit_direction", force.Normal );
		Target.Set( "hit_strength", (force.Length / 1000.0f) * damageScale );
	}

	protected override void OnUpdate()
	{
		if ( !AnimTargetOk )
			return;

		Target.Set( "scale_height", Height );

		// SetIk( "left_hand", ... );
		// SetIk( "right_hand", ... );

		if ( IkLeftHand is not null && IkLeftHand.IsValid() && IkLeftHand.Active ) SetIk( "hand_left", IkLeftHand.Transform.World );
		else ClearIk( "hand_left" );

		if ( IkRightHand is not null && IkRightHand.IsValid() && IkRightHand.Active ) SetIk( "hand_right", IkRightHand.Transform.World );
		else ClearIk( "hand_right" );

		if ( IkLeftFoot is not null && IkLeftFoot.IsValid() && IkLeftFoot.Active ) SetIk( "foot_left", IkLeftFoot.Transform.World );
		else ClearIk( "foot_left" );

		if ( IkRightFoot is not null && IkRightFoot.IsValid() && IkRightFoot.Active ) SetIk( "foot_right", IkRightFoot.Transform.World );
		else ClearIk( "foot_right" );
	}

	public void SetIk( string name, Transform tx )
	{
		if ( !AnimTargetOk )
			return;

		// convert local to model
		tx = Target.Transform.World.ToLocal( tx );

		Target.Set( $"ik.{name}.enabled", true );
		Target.Set( $"ik.{name}.position", tx.Position );
		Target.Set( $"ik.{name}.rotation", tx.Rotation );
	}

	public void ClearIk( string name )
	{
		if ( !AnimTargetOk )
			return;

		Target.Set( $"ik.{name}.enabled", false );
	}

	public Transform GetEyeWorldTransform
	{
		get
		{
			if ( EyeSource is not null && EyeSource.IsValid() ) return EyeSource.Transform.World;

			return Transform.World;
		}
	}


	/// <summary>
	/// Have the player look at this point in the world
	/// </summary>
	public void WithLook( Vector3 lookDirection )
	{
		if ( !AnimTargetOk )
			return;

		Target.SetLookDirection( "aim_body", lookDirection );
		Target.Set( "aim_body_weight", 1f );
	}

	public void WithVelocity( Vector3 Velocity )
	{
		if ( !AnimTargetOk )
			return;

		var dir = Velocity;
		var forward = Target.WorldRotation.Forward.Dot( dir );
		var sideward = Target.WorldRotation.Right.Dot( dir );

		var angle = MathF.Atan2( sideward, forward ).RadianToDegree().NormalizeDegrees();

		Target.Set( "move_direction", angle );
		Target.Set( "move_speed", Velocity.Length );
		Target.Set( "move_groundspeed", Velocity.WithZ( 0 ).Length );
		Target.Set( "move_y", sideward );
		Target.Set( "move_x", forward );
		Target.Set( "move_z", Velocity.z );
	}

	public void WithWishVelocity( Vector3 Velocity )
	{
		if ( !AnimTargetOk )
			return;

		var dir = Velocity;
		var forward = Target.WorldRotation.Forward.Dot( dir );
		var sideward = Target.WorldRotation.Right.Dot( dir );

		var angle = MathF.Atan2( sideward, forward ).RadianToDegree().NormalizeDegrees();

		Target.Set( "wish_direction", angle );
		Target.Set( "wish_speed", Velocity.Length );
		Target.Set( "wish_groundspeed", Velocity.WithZ( 0 ).Length );
		Target.Set( "wish_y", sideward );
		Target.Set( "wish_x", forward );
		Target.Set( "wish_z", Velocity.z );
	}

	public Rotation AimAngle
	{
		set
		{
			if ( !AnimTargetOk )
				return;

			value = Target.WorldRotation.Inverse * value;
			var ang = value.Angles();

			Target.Set( "aim_body_pitch", ang.pitch );
			Target.Set( "aim_body_yaw", ang.yaw );
		}
	}


	public float FootShuffle
	{
		get => AnimTargetOk ? Target.GetFloat( "move_shuffle" ) : 0f;
		set
		{
			if ( !AnimTargetOk )
				return;
			Target.Set( "move_shuffle", value );
		}
	}

	public float DuckLevel
	{
		get => AnimTargetOk ? Target.GetFloat( "duck" ) : 0f;
		set
		{
			if ( !AnimTargetOk )
				return;
			Target.Set( "duck", value );
		}
	}

	public float VoiceLevel
	{
		get => AnimTargetOk ? Target.GetFloat( "voice" ) : 0f;
		set
		{
			if ( !AnimTargetOk )
				return;
			Target.Set( "voice", value );
		}
	}

	public bool IsSitting
	{
		get => AnimTargetOk && Target.GetBool( "b_sit" );
		set
		{
			if ( !AnimTargetOk )
				return;
			Target.Set( "b_sit", value );
		}
	}

	public bool IsGrounded
	{
		get => AnimTargetOk && Target.GetBool( "b_grounded" );
		set
		{
			if ( !AnimTargetOk )
				return;
			Target.Set( "b_grounded", value );
		}
	}

	public bool IsSwimming
	{
		get => AnimTargetOk && Target.GetBool( "b_swim" );
		set
		{
			if ( !AnimTargetOk )
				return;
			Target.Set( "b_swim", value );
		}
	}

	public float SkidAmount
	{
		get => AnimTargetOk ? Target.GetFloat( "skid" ) : 0f;
		set
		{
			if ( !AnimTargetOk )
				return;
			Target.Set( "skid", value );
		}
	}

	public bool IsClimbing
	{
		get => AnimTargetOk && Target.GetBool( "b_climbing" );
		set
		{
			if ( !AnimTargetOk )
				return;
			Target.Set( "b_climbing", value );
		}
	}

	public bool IsNoclipping
	{
		get => AnimTargetOk && Target.GetBool( "b_noclip" );
		set
		{
			if ( !AnimTargetOk )
				return;
			Target.Set( "b_noclip", value );
		}
	}

	public bool IsWeaponLowered
	{
		get => AnimTargetOk && Target.GetBool( "b_weapon_lower" );
		set
		{
			if ( !AnimTargetOk )
				return;
			Target.Set( "b_weapon_lower", value );
		}
	}

	public enum HoldTypes
	{
		None,
		Pistol,
		Rifle,
		Shotgun,
		HoldItem,
		Punch,
		Swing,
		RPG
	}

	public HoldTypes HoldType
	{
		get => !AnimTargetOk ? HoldTypes.None : (HoldTypes)Target.GetInt( "holdtype" );
		set
		{
			if ( !AnimTargetOk )
				return;
			Target.Set( "holdtype", (int)value );
		}
	}

	public enum Hand
	{
		Both,
		Right,
		Left
	}

	public Hand Handedness
	{
		get => !AnimTargetOk ? Hand.Both : (Hand)Target.GetInt( "holdtype_handedness" );
		set
		{
			if ( !AnimTargetOk )
				return;
			Target.Set( "holdtype_handedness", (int)value );
		}
	}

	public void TriggerJump()
	{
		if ( !AnimTargetOk )
			return;

		Target.Set( "b_jump", true );
	}

	public void TriggerDeploy()
	{
		if ( !AnimTargetOk )
			return;

		Target.Set( "b_deploy", true );
	}

	public enum MoveStyles
	{
		Auto,
		Walk,
		Run
	}

	/// <summary>
	/// We can force the model to walk or run, or let it decide based on the speed.
	/// </summary>
	public MoveStyles MoveStyle
	{
		get => !AnimTargetOk ? MoveStyles.Auto : (MoveStyles)Target.GetInt( "move_style" );
		set
		{
			if ( !AnimTargetOk )
				return;
			Target.Set( "move_style", (int)value );
		}
	}
}
