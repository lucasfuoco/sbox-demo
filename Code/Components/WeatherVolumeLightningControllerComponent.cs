namespace Sandbox.Components;

/// <summary>
/// Schedules lightning strikes for <see cref="WeatherVolumeType.StormCloud"/> volumes.
/// Supports multiple concurrent flashes across the cloud deck.
/// </summary>
[Title( "Weather Volume Lightning Controller" ), Category( "World Simulation" ), Icon( "bolt" )]
public sealed class WeatherVolumeLightningControllerComponent : Component, Component.ExecuteInEditor
{
	const int MaxActiveFlashes = 4;

	struct ActiveFlash
	{
		public int Id;
		public Vector3 Position;
		public float Peak;
		public float Duration;
		public float SecondaryPulseAt;
		public bool HasSecondaryPulse;
		public float InfluenceRadius;
		public RealTimeSince Started;
	}

	[RequireComponent]
	public WeatherVolumeComponent Volume { get; private set; }

	[Property, Group( "Lightning" ), Title( "Enable Lightning" )]
	public bool EnableLightning { get; set; } = true;

	[Property, Group( "Lightning" ), Title( "Editor Preview" ), Description( "Play lightning flashes in the editor viewport." )]
	public bool EditorPreview { get; set; } = true;

	[Property, Group( "Lightning" ), Title( "Min Interval (seconds)" ), Range( 0.5f, 120f )]
	public float MinInterval { get; set; } = 10f;

	[Property, Group( "Lightning" ), Title( "Max Interval (seconds)" ), Range( 0.5f, 180f )]
	public float MaxInterval { get; set; } = 22f;

	[Property, Group( "Lightning" ), Title( "Listener Blend Threshold" ), Range( 0.05f, 1f ), Description( "When the listener is at least this blended into the storm, prefer near-camera strikes." )]
	public float ListenerBlendThreshold { get; set; } = 0.15f;

	[Property, Group( "Lightning" ), Title( "Near Listener Chance" ), Range( 0f, 1f ), Description( "Optional chance a strike spawns near the camera when inside the storm. Leave at 0 for fully random volume strikes." )]
	public float NearListenerChance { get; set; } = 0f;

	[Property, Group( "Lightning" ), Title( "Near Strike Distance Min" ), Range( 100f, 4000f )]
	public float NearStrikeDistanceMin { get; set; } = 500f;

	[Property, Group( "Lightning" ), Title( "Near Strike Distance Max" ), Range( 200f, 8000f )]
	public float NearStrikeDistanceMax { get; set; } = 2200f;

	[Property, Group( "Lightning" ), Title( "Deck Height Jitter" ), Range( 0f, 4000f )]
	public float DeckHeightJitter { get; set; } = 800f;

	[Property, Group( "Lightning" ), Title( "Cloud Influence Radius" ), Range( 2000f, 40000f ), Description( "How far surrounding cloud sprites pick up the flash color." )]
	public float CloudInfluenceRadius { get; set; } = 14000f;

	[Property, Group( "Lightning" ), Title( "Max Concurrent Flashes" ), Range( 1, 4 )]
	public int MaxConcurrentFlashes { get; set; } = 1;

	WeatherVolumeManagerComponent _volumeManager;
	WeatherVolumeLightningRendererComponent _renderer;
	WeatherVolumeCloudRendererComponent _cloudRenderer;
	readonly List<ActiveFlash> _flashes = new( MaxActiveFlashes );
	readonly List<WeatherLightningFlash> _publicFlashes = new( MaxActiveFlashes );
	RealTimeSince _sinceStrike;
	float _nextStrikeDelay = 0.5f;
	bool _scheduled;
	int _nextFlashId = 1;

	/// <summary>Peak intensity across all active flashes (sky / audio hooks).</summary>
	public float CurrentFlashIntensity
	{
		get
		{
			var peak = 0f;
			foreach ( var flash in _publicFlashes )
				peak = MathF.Max( peak, flash.Intensity );
			return peak;
		}
	}

	/// <summary>Active flash samples for local cloud tinting.</summary>
	public IReadOnlyList<WeatherLightningFlash> ActiveFlashes => _publicFlashes;

	bool IsEditMode => Game.IsEditor && !Game.IsPlaying;

	bool SupportsLightning => Volume.IsValid() && Volume.VolumeType == WeatherVolumeType.StormCloud;

	bool ShouldPreview => EnableLightning && SupportsLightning && Enabled
		&& (Game.IsPlaying || (IsEditMode && EditorPreview));

	protected override void OnAwake() => Tick();

	protected override void OnStart() => Tick();

	protected override void OnValidate() => Tick();

	protected override void OnUpdate() => Tick();

	protected override void DrawGizmos()
	{
		if ( !ShouldPreview || _publicFlashes.Count == 0 )
			return;

		Gizmo.Draw.IgnoreDepth = true;
		foreach ( var flash in _publicFlashes )
		{
			if ( flash.Intensity <= 0.05f )
				continue;

			Gizmo.Draw.Color = new Color( 0.35f, 0.6f, 1f, MathX.Clamp( flash.Intensity, 0.2f, 1f ) );
			Gizmo.Draw.LineSphere( flash.Position, 140f + flash.Intensity * 260f, 10 );
			Gizmo.Draw.Color = new Color( 0.25f, 0.45f, 1f, 0.14f * flash.Intensity );
			Gizmo.Draw.LineSphere( flash.Position, flash.InfluenceRadius * 0.35f, 8 );
		}

		Gizmo.Draw.IgnoreDepth = false;
	}

	void Tick()
	{
		if ( !ShouldPreview )
		{
			ClearAllFlashes();
			_scheduled = false;
			return;
		}

		EnsureRenderer();

		if ( !_scheduled )
		{
			// First strike soon so play-mode flashes are obvious; later strikes use Min/Max interval.
			_nextStrikeDelay = IsEditMode ? 0.35f : Game.Random.Float( 1.25f, 3.5f );
			_sinceStrike = 0f;
			_scheduled = true;
		}

		UpdateActiveFlashes();

		var listener = ResolveListenerPosition();
		var maxFlashes = Math.Clamp( MaxConcurrentFlashes, 1, MaxActiveFlashes );
		if ( _flashes.Count >= maxFlashes )
			return;

		if ( _sinceStrike < _nextStrikeDelay )
			return;

		BeginStrike( listener, maxFlashes );
	}

	void BeginStrike( Vector3 listener, int maxFlashes )
	{
		while ( _flashes.Count >= maxFlashes )
			_flashes.RemoveAt( 0 );

		var flash = new ActiveFlash
		{
			Id = _nextFlashId++,
			Position = SampleStrikePosition( listener ),
			Peak = Game.Random.Float( 0.85f, 1.25f ),
			Duration = Game.Random.Float( 0.55f, 0.95f ),
			HasSecondaryPulse = Game.Random.Float( 0f, 1f ) > 0.35f,
			SecondaryPulseAt = Game.Random.Float( 0.12f, 0.28f ),
			InfluenceRadius = CloudInfluenceRadius * Game.Random.Float( 0.85f, 1.15f ),
			Started = 0f,
		};

		_flashes.Add( flash );
		_sinceStrike = 0f;
		RebuildPublicFlashes();
		_renderer?.SetFlashes( _publicFlashes );
		ScheduleNextStrike();
	}

	Vector3 SampleStrikePosition( Vector3 listener )
	{
		var world = Volume.Transform.World;
		var half = Volume.Size * 0.5f;
		var deckLocalZ = ResolveCloudDeckLocalZ();

		float localX;
		float localY;

		var blend = GetHorizontalBlend( listener );
		var preferNear = NearListenerChance > 0f
			&& blend >= ListenerBlendThreshold
			&& Game.Random.Float( 0f, 1f ) < NearListenerChance;

		if ( preferNear )
		{
			var localListener = world.PointToLocal( listener );
			var angle = Game.Random.Float( 0f, MathF.PI * 2f );
			var distance = Game.Random.Float(
				MathF.Min( NearStrikeDistanceMin, NearStrikeDistanceMax ),
				MathF.Max( NearStrikeDistanceMin, NearStrikeDistanceMax ) );
			localX = MathX.Clamp( localListener.x + MathF.Cos( angle ) * distance, -half.x * 0.92f, half.x * 0.92f );
			localY = MathX.Clamp( localListener.y + MathF.Sin( angle ) * distance, -half.y * 0.92f, half.y * 0.92f );
		}
		else
		{
			localX = Game.Random.Float( -half.x * 0.9f, half.x * 0.9f );
			localY = Game.Random.Float( -half.y * 0.9f, half.y * 0.9f );
		}

		var jitter = Game.Random.Float( -DeckHeightJitter, DeckHeightJitter );
		var local = new Vector3( localX, localY, deckLocalZ + jitter );
		return world.PointToWorld( local );
	}

	float ResolveCloudDeckLocalZ()
	{
		var halfZ = Volume.Size.z * 0.5f;
		var topBandFraction = 0.06f;
		var topBandMaxHeight = 6000f;
		var useTopBand = true;

		EnsureCloudRenderer();
		if ( _cloudRenderer.IsValid() )
		{
			useTopBand = _cloudRenderer.UseTopCloudBand;
			topBandFraction = _cloudRenderer.TopBandFraction;
			topBandMaxHeight = _cloudRenderer.TopBandMaxHeight;
		}

		if ( !useTopBand )
			return halfZ * 0.35f;

		var bandHeight = MathF.Max( Volume.Size.z * topBandFraction, 512f );
		bandHeight = MathF.Min( bandHeight, MathF.Min( Volume.Size.z, topBandMaxHeight ) );
		return halfZ - bandHeight * 0.5f;
	}

	void EnsureCloudRenderer()
	{
		if ( _cloudRenderer.IsValid() )
			return;

		_cloudRenderer = Components.Get<WeatherVolumeCloudRendererComponent>();
	}

	void UpdateActiveFlashes()
	{
		for ( var i = _flashes.Count - 1; i >= 0; i-- )
		{
			var flash = _flashes[i];
			if ( (float)flash.Started >= flash.Duration )
				_flashes.RemoveAt( i );
		}

		RebuildPublicFlashes();
		_renderer?.SetFlashes( _publicFlashes );
	}

	void RebuildPublicFlashes()
	{
		_publicFlashes.Clear();
		foreach ( var flash in _flashes )
		{
			var intensity = EvaluateEnvelope( flash );
			if ( intensity <= 0.01f )
				continue;

			_publicFlashes.Add( new WeatherLightningFlash
			{
				Id = flash.Id,
				Position = flash.Position,
				Intensity = intensity,
				InfluenceRadius = flash.InfluenceRadius,
			} );
		}
	}

	static float EvaluateEnvelope( ActiveFlash flash )
	{
		var age = (float)flash.Started;
		var t = age / MathF.Max( flash.Duration, 0.001f );
		var envelope = 0f;

		// Sharp strike: bright hold, then a fast die-off so bolts don't linger.
		if ( t < 0.18f )
			envelope = 1f;
		else if ( t < 0.45f )
			envelope = MathX.Lerp( 1f, 0.35f, (t - 0.18f) / 0.27f );
		else
			envelope = MathF.Max( 0f, 0.35f * (1f - (t - 0.45f) / 0.55f) );

		if ( flash.HasSecondaryPulse )
		{
			var pulseT = (age - flash.SecondaryPulseAt) / 0.08f;
			if ( pulseT is >= 0f and <= 1f )
				envelope = MathF.Max( envelope, (1f - pulseT) * 1f );
		}

		return envelope * flash.Peak;
	}

	void ClearAllFlashes()
	{
		_flashes.Clear();
		_publicFlashes.Clear();
		_renderer?.SetFlashes( _publicFlashes );
	}

	void ScheduleNextStrike()
	{
		var min = MathF.Min( MinInterval, MaxInterval );
		var max = MathF.Max( MinInterval, MaxInterval );

		if ( IsEditMode )
		{
			// Keep editor preview slower than before, but still faster than play mode.
			min = MathF.Max( min * 0.45f, 4f );
			max = MathF.Max( max * 0.45f, 8f );
		}

		_nextStrikeDelay = Game.Random.Float( min, max );
		_sinceStrike = 0f;
	}

	void EnsureRenderer()
	{
		if ( _renderer.IsValid() )
			return;

		var renderers = Components.GetAll<WeatherVolumeLightningRendererComponent>().ToArray();
		for ( var i = 1; i < renderers.Length; i++ )
		{
			if ( renderers[i].IsValid() )
				renderers[i].Destroy();
		}

		_renderer = Components.Get<WeatherVolumeLightningRendererComponent>();
		if ( !_renderer.IsValid() )
			_renderer = Components.Create<WeatherVolumeLightningRendererComponent>();
	}

	Vector3 ResolveListenerPosition()
	{
		if ( !IsEditMode )
		{
			EnsureVolumeManager();
			if ( _volumeManager.IsValid() )
			{
				var playerPosition = _volumeManager.GetPlayerPosition();
				if ( playerPosition.LengthSquared > 0.01f || _volumeManager.FollowCamera.IsValid() )
					return playerPosition;
			}
		}

		var camera = Scene?.Camera;
		if ( camera.IsValid() )
			return camera.WorldPosition;

		return Volume.IsValid() ? Volume.Transform.World.Position : WorldPosition;
	}

	void EnsureVolumeManager()
	{
		if ( _volumeManager.IsValid() )
			return;

		_volumeManager = Scene?.GetAllComponents<WeatherVolumeManagerComponent>().FirstOrDefault();
	}

	float GetHorizontalBlend( Vector3 worldPosition )
	{
		var local = Volume.Transform.World.ToLocal( new Transform( worldPosition, Rotation.Identity ) ).Position;
		var half = Volume.Size * 0.5f;
		var blendDistance = MathF.Max( Volume.BlendDistance, 20000f );

		var blendX = AxisBlend( MathF.Abs( local.x ), half.x, blendDistance );
		var blendY = AxisBlend( MathF.Abs( local.y ), half.y, blendDistance );
		return MathF.Min( blendX, blendY );
	}

	static float AxisBlend( float distance, float halfExtent, float blendDistance )
	{
		if ( distance <= halfExtent - blendDistance )
			return 1f;

		if ( distance >= halfExtent )
			return 0f;

		return 1f - (distance - (halfExtent - blendDistance)) / blendDistance;
	}
}
