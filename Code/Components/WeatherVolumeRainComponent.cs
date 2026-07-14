namespace Sandbox.Components;

using Sandbox.Components.SingletonComponents;

public enum WeatherRainPlacement
{
	/// <summary>Single rain shaft that follows the camera under the cloud footprint.</summary>
	FollowCamera,
	/// <summary>Multiple fixed shafts anchored in the volume; nearest ones are simulated.</summary>
	FixedCells,
}

/// <summary>
/// Rain shafts under rain/storm cloud volumes.
/// Storm volumes default to fixed cells in the volume; rain clouds can follow the camera.
/// </summary>
[Title( "Weather Volume Rain" ), Category( "World Simulation" ), Icon( "umbrella" )]
public sealed class WeatherVolumeRainComponent : Component, Component.ExecuteInEditor
{
	const float CloudBandFraction = 0.06f;
	const float CloudBandMaxHeight = 6000f;
	const int MaxRainSlots = 8;

	[RequireComponent]
	public WeatherVolumeComponent Volume { get; private set; }

	[Property, Group( "Rain" ), Title( "Enable Rain" )]
	public bool EnableRain { get; set; } = true;

	[Property, Group( "Rain" ), Title( "Editor Preview" )]
	public bool EditorPreview { get; set; } = true;

	[Property, Group( "Rain" ), Title( "Rain Intensity" ), Range( 0.1f, 2f )]
	public float RainIntensity { get; set; } = 1f;

	[Property, Group( "Rain" ), Title( "Placement" ), Description( "Follow Camera = one shaft on the player. Fixed Cells = multiple shafts anchored in the volume." )]
	public WeatherRainPlacement Placement { get; set; } = WeatherRainPlacement.FixedCells;

	[Property, Group( "Rain" ), Title( "Column Width" ), Description( "Width of each rain shaft." ), Range( 800f, 24000f )]
	public float ColumnWidth { get; set; } = 14000f;

	[Property, Group( "Rain" ), Title( "Visible Height" ), Description( "Fallback column height when terrain cannot be sampled. Fixed cells otherwise stretch from the cloud deck to the ground." ), Range( 1200f, 80000f )]
	public float VisibleHeight { get; set; } = 20000f;

	[Property, Group( "Rain" ), Title( "Cell Spacing" ), Description( "Distance between fixed rain cells in the volume." ), Range( 2000f, 80000f )]
	public float CellSpacing { get; set; } = 30000f;

	[Property, Group( "Rain" ), Title( "Active Cell Count" ), Description( "How many nearest fixed cells simulate at once." ), Range( 1, MaxRainSlots )]
	public int ActiveCellCount { get; set; } = 6;

	[Property, Group( "Rain" ), Title( "Always Preview Under Volume" )]
	public bool AlwaysPreviewUnderVolume { get; set; } = true;

	[Property, Group( "Physics" ), Title( "Collide With World" ), Description( "Rain disappears on terrain, water, and roofs via a cheap height grid (no per-drop physics)." )]
	public bool CollideWithWorld { get; set; } = true;

	[Property, Group( "Physics" ), Title( "Block Indoors" ), Description( "Disables rain when a ceiling is detected above the camera." )]
	public bool BlockIndoors { get; set; } = true;

	[Property, Group( "Physics" ), Title( "Shelter Trace Distance" )]
	public float ShelterTraceDistance { get; set; } = 4500f;

	[Property, Group( "Ground" ), Title( "Enable Splashes" )]
	public bool EnableSplashes { get; set; } = true;

	[Property, Group( "Ground" ), Title( "Splash Radius" )]
	public float SplashRadius { get; set; } = 4200f;

	[Property, Group( "Ground" ), Title( "Enable Impact Audio" )]
	public bool EnableImpactAudio { get; set; } = true;

	[Property, Group( "Ground" ), Title( "Impact Audio Volume" ), Range( 0f, 1f )]
	public float ImpactAudioVolume { get; set; } = 0.55f;

	readonly List<WorldPrecipitationEffect> _rainSlots = new( MaxRainSlots );
	readonly List<Vector2> _cellLocals = new();
	readonly int[] _nearestScratch = new int[MaxRainSlots];

	WorldRainGroundEffect _ground;
	WeatherVolumeManagerComponent _volumeManager;
	WorldManagerSingletonComponent _terrain;
	TimeSince _sinceShelterCheck;
	bool _sheltered;
	float _shelterBlend;
	float _cachedSpacing = -1f;
	float _cachedColumnWidth = -1f;
	Vector3 _cachedVolumeSize;

	bool IsEditMode => Game.IsEditor && !Game.IsPlaying;

	bool SupportsRain => Volume.IsValid() && Volume.VolumeType is WeatherVolumeType.RainCloud or WeatherVolumeType.StormCloud;

	bool ShouldPreview => EnableRain && SupportsRain && Enabled && (Game.IsPlaying || (IsEditMode && EditorPreview));

	bool UsesFixedCells => Placement == WeatherRainPlacement.FixedCells
		|| Volume.VolumeType is WeatherVolumeType.StormCloud or WeatherVolumeType.RainCloud;

	protected override void OnAwake() => Tick();

	protected override void OnStart() => Tick();

	protected override void OnValidate() => Tick();

	protected override void OnUpdate() => Tick();

	protected override void OnDestroy()
	{
		DestroyRainSlots();
		if ( _ground.IsValid() )
			_ground.Root.Destroy();

		_ground = null;
	}

	void Tick()
	{
		PurgeLegacyEffectChildren();

		if ( !ShouldPreview )
		{
			DisableEffects();
			return;
		}

		EnsureRainSlots();
		EnsureGround();
		if ( _rainSlots.Count == 0 )
			return;

		var listener = ResolveListenerPosition();
		var blend = GetHorizontalBlend( listener );
		var previewOutside = IsEditMode && AlwaysPreviewUnderVolume && blend <= 0.01f;

		if ( blend <= 0.01f && !previewOutside )
		{
			DisableEffects();
			return;
		}

		if ( !previewOutside && !IsDominantRainVolume( listener, blend ) )
		{
			DisableEffects();
			return;
		}

		UpdateShelter( listener, previewOutside );
		var outdoor = 1f - _shelterBlend;
		if ( outdoor <= 0.02f )
		{
			DisableEffects();
			return;
		}

		var sample = Volume.GetWeatherSample();
		var amount = ResolveAmount( sample ) * outdoor * MathX.Clamp( blend <= 0f ? 1f : blend, 0.35f, 1f );
		var windDirection = sample.WindDirection;
		var windStrength = sample.WindStrength;

		var world = WorldManagerComponent.Instance;
		if ( world.IsValid() && world.Weather.IsValid() )
		{
			windDirection = world.Weather.WindDirection;
			windStrength = MathF.Max( windStrength, world.Weather.WindStrength );
		}

		if ( UsesFixedCells )
			UpdateFixedCells( listener, amount, windDirection, windStrength, previewOutside );
		else
			UpdateFollowCamera( listener, previewOutside, amount, windDirection, windStrength );

		if ( _ground.IsValid() )
		{
			_ground.Update(
				listener,
				amount,
				SplashRadius,
				enableSplashes: EnableSplashes && !previewOutside && outdoor > 0.2f,
				enableAudio: EnableImpactAudio && Game.IsPlaying && outdoor > 0.2f,
				audioVolume: ImpactAudioVolume * outdoor );
		}
	}

	void UpdateFollowCamera(
		Vector3 listener,
		bool previewOutside,
		float amount,
		Vector3 windDirection,
		float windStrength )
	{
		GetRainColumn( listener, previewOutside, Vector2.Zero, followListener: true, out var spawnCenter, out var emitterSize );
		UpdateSlot( _rainSlots[0], spawnCenter, emitterSize, amount, windDirection, windStrength, listener, rateMultiplier: 1f );

		for ( var i = 1; i < _rainSlots.Count; i++ )
		{
			if ( _rainSlots[i].IsValid() )
				_rainSlots[i].Root.Enabled = false;
		}
	}

	void UpdateFixedCells(
		Vector3 listener,
		float amount,
		Vector3 windDirection,
		float windStrength,
		bool previewOutside )
	{
		EnsureRainSlots();
		EnsureCellLayout();

		var activeCount = Math.Clamp( ActiveCellCount, 1, Math.Min( MaxRainSlots, _rainSlots.Count ) );
		var rateMul = MathX.Clamp( 1.75f / MathF.Sqrt( activeCount ), 0.65f, 1.25f );

		if ( _cellLocals.Count == 0 )
		{
			UpdateFollowCamera( listener, previewOutside, amount, windDirection, windStrength );
			return;
		}

		PickNearestDistinctCells( listener, activeCount, previewOutside );

		for ( var slot = 0; slot < _rainSlots.Count; slot++ )
		{
			var rain = _rainSlots[slot];
			if ( !rain.IsValid() )
				continue;

			if ( slot >= activeCount || _nearestScratch[slot] < 0 )
			{
				rain.Root.Enabled = false;
				continue;
			}

			var localXy = _cellLocals[_nearestScratch[slot]];
			GetRainColumn( listener, false, localXy, followListener: false, out var spawnCenter, out var emitterSize );
			UpdateSlot( rain, spawnCenter, emitterSize, amount, windDirection, windStrength, listener, rateMul );
		}
	}

	void PickNearestDistinctCells( Vector3 listener, int activeCount, bool previewOutside )
	{
		var world = Volume.Transform.World;
		var localListener = previewOutside ? Vector3.Zero : world.PointToLocal( listener );
		// Keep active shafts well separated across the storm footprint.
		var minSeparation = MathF.Max( CellSpacing * 0.95f, ColumnWidth * 1.25f );
		var minSeparationSq = minSeparation * minSeparation;

		for ( var i = 0; i < activeCount; i++ )
			_nearestScratch[i] = -1;

		// Prefer a ring of targets around the listener so cells fan out instead of clustering.
		var ringRadius = MathF.Max( CellSpacing, ColumnWidth * 1.5f );
		var filled = 0;
		for ( var slot = 0; slot < activeCount && _cellLocals.Count > 0; slot++ )
		{
			var angle = slot * (MathF.PI * 2f / activeCount) + 0.4f;
			var target = new Vector2(
				localListener.x + MathF.Cos( angle ) * ringRadius,
				localListener.y + MathF.Sin( angle ) * ringRadius );

			var bestIndex = -1;
			var bestDist = float.MaxValue;
			for ( var i = 0; i < _cellLocals.Count; i++ )
			{
				var used = false;
				for ( var p = 0; p < filled; p++ )
				{
					if ( _nearestScratch[p] == i )
					{
						used = true;
						break;
					}
				}

				if ( used )
					continue;

				var cell = _cellLocals[i];
				var tooClose = false;
				for ( var p = 0; p < filled; p++ )
				{
					var picked = _cellLocals[_nearestScratch[p]];
					var sx = cell.x - picked.x;
					var sy = cell.y - picked.y;
					if ( sx * sx + sy * sy < minSeparationSq )
					{
						tooClose = true;
						break;
					}
				}

				if ( tooClose )
					continue;

				var dx = cell.x - target.x;
				var dy = cell.y - target.y;
				var distSq = dx * dx + dy * dy;
				if ( distSq >= bestDist )
					continue;

				bestDist = distSq;
				bestIndex = i;
			}

			if ( bestIndex < 0 )
				break;

			_nearestScratch[filled++] = bestIndex;
		}

		// Fill any remaining slots with farthest-from-cluster picks near the listener.
		while ( filled < activeCount )
		{
			var bestIndex = -1;
			var bestScore = float.MaxValue;
			for ( var i = 0; i < _cellLocals.Count; i++ )
			{
				var used = false;
				for ( var p = 0; p < filled; p++ )
				{
					if ( _nearestScratch[p] == i )
					{
						used = true;
						break;
					}
				}

				if ( used )
					continue;

				var cell = _cellLocals[i];
				var tooClose = false;
				for ( var p = 0; p < filled; p++ )
				{
					var picked = _cellLocals[_nearestScratch[p]];
					var sx = cell.x - picked.x;
					var sy = cell.y - picked.y;
					if ( sx * sx + sy * sy < minSeparationSq * 0.65f )
					{
						tooClose = true;
						break;
					}
				}

				if ( tooClose )
					continue;

				var dx = cell.x - localListener.x;
				var dy = cell.y - localListener.y;
				var distSq = dx * dx + dy * dy;
				if ( distSq >= bestScore )
					continue;

				bestScore = distSq;
				bestIndex = i;
			}

			if ( bestIndex < 0 )
				break;

			_nearestScratch[filled++] = bestIndex;
		}
	}

	void UpdateSlot(
		WorldPrecipitationEffect rain,
		Vector3 spawnCenter,
		Vector3 emitterSize,
		float amount,
		Vector3 windDirection,
		float windStrength,
		Vector3 listener,
		float rateMultiplier )
	{
		var fallSpeed = MathX.Lerp( 1800f, 3200f, MathX.Clamp( amount, 0f, 1f ) );
		var lifetime = MathX.Clamp( emitterSize.z / fallSpeed, 0.75f, 18f );
		rain.SetEmitterSize( emitterSize );
		rain.Update(
			spawnCenter,
			amount,
			windDirection,
			windStrength,
			temperature: 12f,
			lifetimeSeconds: lifetime,
			fallSpeedOverride: fallSpeed,
			enableCollision: CollideWithWorld && !IsEditMode,
			rateMultiplier: rateMultiplier,
			clipListener: listener );
	}

	void EnsureCellLayout()
	{
		// Keep grid spacing at least a bit larger than the shaft so cells stay visually distinct.
		var spacing = MathF.Max( CellSpacing, ColumnWidth * 1.35f );
		if ( _cellLocals.Count > 0
			&& MathF.Abs( spacing - _cachedSpacing ) < 1f
			&& MathF.Abs( ColumnWidth - _cachedColumnWidth ) < 1f
			&& (_cachedVolumeSize - Volume.Size).Length < 1f )
			return;

		_cellLocals.Clear();
		_cachedSpacing = spacing;
		_cachedColumnWidth = ColumnWidth;
		_cachedVolumeSize = Volume.Size;

		var half = Volume.Size * 0.5f;
		var margin = MathF.Max( ColumnWidth * 0.55f, spacing * 0.35f );
		var minX = -half.x + margin;
		var maxX = half.x - margin;
		var minY = -half.y + margin;
		var maxY = half.y - margin;
		if ( maxX <= minX || maxY <= minY )
		{
			_cellLocals.Add( Vector2.Zero );
			return;
		}

		// Deterministic grid anchored in volume local space — moves with the storm, not the camera.
		for ( var y = minY; y <= maxY + 1f; y += spacing )
		for ( var x = minX; x <= maxX + 1f; x += spacing )
		{
			_cellLocals.Add( new Vector2(
				MathX.Clamp( x, minX, maxX ),
				MathX.Clamp( y, minY, maxY ) ) );
		}

		if ( _cellLocals.Count == 0 )
			_cellLocals.Add( Vector2.Zero );
	}

	void DisableEffects()
	{
		foreach ( var rain in _rainSlots )
		{
			if ( rain.IsValid() )
				rain.Root.Enabled = false;
		}

		if ( _ground.IsValid() )
			_ground.Root.Enabled = false;
	}

	void UpdateShelter( Vector3 listener, bool previewOutside )
	{
		if ( !BlockIndoors || previewOutside || IsEditMode )
		{
			_sheltered = false;
			_shelterBlend = _shelterBlend.LerpTo( 0f, 1f - MathF.Exp( -Time.Delta * 8f ) );
			return;
		}

		if ( _sinceShelterCheck > 0.12f )
		{
			_sinceShelterCheck = 0f;
			_sheltered = TraceSheltered( listener );
		}

		_shelterBlend = _shelterBlend.LerpTo( _sheltered ? 1f : 0f, 1f - MathF.Exp( -Time.Delta * 6f ) );
	}

	bool TraceSheltered( Vector3 listener )
	{
		var eye = listener + Vector3.Up * 72f;
		var tr = Scene.Trace.Ray( eye, eye + Vector3.Up * MathF.Max( ShelterTraceDistance, 500f ) )
			.WithoutTags( "trigger", "player", "ragdoll", "particles", "water", "weather_volume" )
			.IgnoreGameObjectHierarchy( GameObject )
			.Run();

		if ( !tr.Hit )
			return false;

		return tr.Normal.z < 0.25f || tr.Distance < ShelterTraceDistance * 0.98f;
	}

	void GetRainColumn(
		Vector3 listener,
		bool useVolumeCenter,
		Vector2 localXy,
		bool followListener,
		out Vector3 spawnCenter,
		out Vector3 emitterSize )
	{
		var world = Volume.Transform.World;
		var half = Volume.Size * 0.5f;
		var bandHeight = MathF.Max( Volume.Size.z * CloudBandFraction, 512f );
		bandHeight = MathF.Min( bandHeight, MathF.Min( Volume.Size.z, CloudBandMaxHeight ) );

		var cloudUndersideLocalZ = half.z - bandHeight;
		var cloudUndersideZ = (world.Position + world.Rotation * new Vector3( 0f, 0f, cloudUndersideLocalZ )).z;

		Vector3 columnXy;
		if ( useVolumeCenter )
		{
			columnXy = world.Position;
		}
		else if ( followListener )
		{
			var local = world.PointToLocal( listener );
			local.x = MathX.Clamp( local.x, -half.x * 0.95f, half.x * 0.95f );
			local.y = MathX.Clamp( local.y, -half.y * 0.95f, half.y * 0.95f );
			local.z = 0f;
			columnXy = world.PointToWorld( local );
		}
		else
		{
			columnXy = world.PointToWorld( new Vector3( localXy.x, localXy.y, 0f ) );
		}

		float bottomZ;
		float topZ;
		if ( followListener || useVolumeCenter )
		{
			bottomZ = useVolumeCenter
				? ResolveGroundZ( columnXy.x, columnXy.y, listener.z - 180f )
				: listener.z - 180f;
			var desiredTop = useVolumeCenter
				? cloudUndersideZ
				: MathF.Min( cloudUndersideZ, listener.z + MathF.Max( VisibleHeight, 1200f ) );
			// Prefer full cloud-to-ground when under a storm/rain deck.
			if ( !useVolumeCenter )
				desiredTop = cloudUndersideZ;
			topZ = MathF.Max( desiredTop, bottomZ + 1200f );
			bottomZ = MathF.Min( bottomZ, topZ - 1200f );
		}
		else
		{
			// Fixed cells: full shaft from cloud underside down to terrain.
			topZ = cloudUndersideZ;
			bottomZ = ResolveGroundZ( columnXy.x, columnXy.y, topZ - MathF.Max( VisibleHeight, 1600f ) );
			if ( topZ - bottomZ < 1600f )
				bottomZ = topZ - 1600f;
		}

		var height = MathF.Max( topZ - bottomZ, 1200f );
		spawnCenter = new Vector3( columnXy.x, columnXy.y, bottomZ + height * 0.5f );
		emitterSize = new Vector3( ColumnWidth, ColumnWidth, height );
	}

	float ResolveGroundZ( float worldX, float worldY, float fallbackZ )
	{
		EnsureTerrain();
		if ( _terrain.IsValid() )
			return _terrain.GetHeight( worldX, worldY ) - 24f;

		return fallbackZ;
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

	float GetHorizontalBlend( Vector3 worldPosition )
	{
		var local = Volume.Transform.World.PointToLocal( worldPosition );
		var half = Volume.Size * 0.5f;
		var blendDistance = MathF.Max( Volume.BlendDistance, 20000f );

		var blendX = AxisBlend( MathF.Abs( local.x ), half.x, blendDistance );
		var blendY = AxisBlend( MathF.Abs( local.y ), half.y, blendDistance );
		return MathF.Min( blendX, blendY );
	}

	bool IsDominantRainVolume( Vector3 listener, float myBlend )
	{
		foreach ( var other in Scene.GetAllComponents<WeatherVolumeRainComponent>() )
		{
			if ( !other.IsValid() || other == this || !other.ShouldPreview )
				continue;

			var otherBlend = other.GetHorizontalBlend( listener );
			if ( otherBlend <= 0.02f )
				continue;

			// Storm shafts win over plain rain clouds when both overlap.
			if ( Volume.VolumeType == WeatherVolumeType.RainCloud
				&& other.Volume.IsValid()
				&& other.Volume.VolumeType == WeatherVolumeType.StormCloud
				&& otherBlend > 0.05f )
				return false;

			if ( Volume.VolumeType == WeatherVolumeType.StormCloud
				&& other.Volume.IsValid()
				&& other.Volume.VolumeType == WeatherVolumeType.RainCloud )
				continue;

			if ( otherBlend > myBlend + 0.02f )
				return false;

			if ( MathF.Abs( otherBlend - myBlend ) <= 0.02f
				&& string.CompareOrdinal( other.GameObject.Id.ToString(), GameObject.Id.ToString() ) < 0 )
				return false;
		}

		return true;
	}

	static float AxisBlend( float distance, float halfExtent, float blendDistance )
	{
		if ( distance <= halfExtent - blendDistance )
			return 1f;

		if ( distance >= halfExtent )
			return 0f;

		return 1f - (distance - (halfExtent - blendDistance)) / blendDistance;
	}

	float ResolveAmount( WeatherSample sample )
	{
		var amount = MathX.Clamp( sample.RainAmount * RainIntensity, 0.55f, 1.5f );
		if ( Volume.VolumeType == WeatherVolumeType.StormCloud )
			amount = MathF.Max( amount, RainIntensity );

		return amount;
	}

	void EnsureRainSlots()
	{
		var wanted = UsesFixedCells ? Math.Clamp( ActiveCellCount, 1, MaxRainSlots ) : 1;
		while ( _rainSlots.Count < wanted )
		{
			var index = _rainSlots.Count;
			_rainSlots.Add( WorldPrecipitationEffect.Create( GameObject, snow: false, name: $"RainCell_{index}" ) );
		}

		while ( _rainSlots.Count > wanted )
		{
			var last = _rainSlots[^1];
			_rainSlots.RemoveAt( _rainSlots.Count - 1 );
			if ( last.IsValid() )
				last.Root.Destroy();
		}
	}

	void DestroyRainSlots()
	{
		foreach ( var rain in _rainSlots )
		{
			if ( rain.IsValid() )
				rain.Root.Destroy();
		}

		_rainSlots.Clear();
	}

	void PurgeLegacyEffectChildren()
	{
		if ( !GameObject.IsValid() )
			return;

		// Always clear curtain leftovers so hotloads don't leave sheets behind.
		foreach ( var child in GameObject.Children.ToArray() )
			DestroyLegacyEffectSubtree( child );
	}

	static void DestroyLegacyEffectSubtree( GameObject go )
	{
		if ( !go.IsValid() )
			return;

		foreach ( var child in go.Children.ToArray() )
			DestroyLegacyEffectSubtree( child );

		var name = go.Name ?? string.Empty;
		if ( name.StartsWith( "RainDistCurtain", StringComparison.OrdinalIgnoreCase )
			|| name.StartsWith( "RainCurtain", StringComparison.OrdinalIgnoreCase )
			|| name.StartsWith( "RainDistant", StringComparison.OrdinalIgnoreCase )
			|| name.StartsWith( "RainFogCell", StringComparison.OrdinalIgnoreCase )
			|| name.StartsWith( "RainCellFog", StringComparison.OrdinalIgnoreCase )
			|| name.StartsWith( "RainVolumetricFog", StringComparison.OrdinalIgnoreCase ) )
		{
			go.Destroy();
			return;
		}

		if ( go.Components.Get<VolumetricFogVolume>().IsValid() )
		{
			go.Destroy();
			return;
		}

		var sprite = go.Components.Get<SpriteRenderer>();
		if ( !sprite.IsValid() || !sprite.Sprite.IsValid() )
			return;

		var resourcePath = sprite.Sprite.ResourcePath ?? string.Empty;
		if ( resourcePath.Contains( "rain_curtain", StringComparison.OrdinalIgnoreCase ) )
			go.Destroy();
	}

	void EnsureGround()
	{
		if ( _ground.IsValid() )
			return;

		if ( !EnableSplashes && !EnableImpactAudio )
			return;

		_ground = WorldRainGroundEffect.Create( GameObject, Scene );
	}

	Vector3 ResolveListenerPosition()
	{
		if ( IsEditMode )
		{
			var editorCamera = Scene.Camera;
			if ( editorCamera.IsValid() )
				return editorCamera.WorldPosition;
		}

		EnsureVolumeManager();
		if ( _volumeManager.IsValid() )
			return _volumeManager.GetPlayerPosition();

		var camera = Scene.Camera;
		if ( camera.IsValid() )
			return camera.WorldPosition;

		return Volume.Transform.World.Position;
	}

	void EnsureVolumeManager()
	{
		if ( _volumeManager.IsValid() )
			return;

		_volumeManager = Scene.GetAllComponents<WeatherVolumeManagerComponent>().FirstOrDefault();
	}
}
