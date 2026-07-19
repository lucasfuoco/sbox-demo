using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

public enum WeatherCloudLayerMovement
{
	/// <summary>Volumes travel in a single line along the wind and wrap when they leave the map.</summary>
	Chain,
	/// <summary>Volumes stay in separate lanes perpendicular to wind.</summary>
	ParallelLanes,
}

/// <summary>
/// One drifting cloud patch managed by <see cref="WeatherCloudLayerControllerComponent"/>.
/// </summary>
public sealed class WeatherCloudLayerSlot
{
	[Property, Title( "Volume Type" )]
	public WeatherVolumeType Type { get; set; } = WeatherVolumeType.ClearCloud;

	[Property, Title( "Lane Offset" ), Description( "Perpendicular offset from the shared wind axis. Ignored in chain mode unless Chain Lane Spread is used." )]
	public float LaneOffset { get; set; }

	[Property, Title( "Phase Offset" ), Range( 0f, 1f ), Description( "0–1 position along the wrap loop. In chain mode this is assigned evenly." )]
	public float PhaseOffset { get; set; }

	[Property, Title( "Base Height" ), Description( "Unused when the cloud layer pins Z to Ocean Level." )]
	public float BaseHeight { get; set; } = 0f;

	[Property, Title( "Size" )]
	public Vector3 Size { get; set; } = new( 220000f, 220000f, 70000f );

	[Property, Title( "Gizmo Color" )]
	public Color GizmoColor { get; set; } = new( 0.9f, 0.92f, 0.98f, 0.35f );
}

/// <summary>
/// Manages multiple typed cloud volumes across the map.
/// Default chain mode keeps them in a looping train along the wind.
/// </summary>
[Title( "Weather Cloud Layer Controller" ), Category( "World Simulation" ), Icon( "cloud_queue" )]
public sealed class WeatherCloudLayerControllerComponent : Component, Component.ExecuteInEditor
{
	const string GeneratedTag = "weather_cloud_layer_generated";
	const float DefaultLaneSpacing = 140000f;

	[Property, Group( "Region" ), Title( "Wrap Region Size" ), Description( "Volumes wrap inside this box centered on this object." )]
	public Vector3 RegionSize { get; set; } = new( 1000000f, 1000000f, 90000f );

	[Property, Group( "Region" ), Title( "Ocean Level" ), Description( "Volume Z relative to this object. 0 = ocean / world origin height." )]
	public float OceanLevel { get; set; } = 0f;

	[Property, Group( "Drift" ), Title( "Movement Mode" ), Description( "Chain = one looping train along the wind. Parallel Lanes = separate side-by-side paths." )]
	public WeatherCloudLayerMovement MovementMode { get; set; } = WeatherCloudLayerMovement.Chain;

	[Property, Group( "Drift" ), Title( "Lane Spacing" ), Range( 50000f, 400000f ), Description( "Used by Parallel Lanes mode." )]
	public float LaneSpacing { get; set; } = DefaultLaneSpacing;

	[Property, Group( "Drift" ), Title( "Chain Gap" ), Range( 0f, 200000f ), Description( "Extra empty space between chain patches along the wind." )]
	public float ChainGap { get; set; } = 40000f;

	[Property, Group( "Drift" ), Title( "Drift Speed Multiplier" ), Range( 0.1f, 4f )]
	public float DriftSpeedMultiplier { get; set; } = 1f;

	[Property, Group( "Drift" ), Title( "Drift In Editor" ), Description( "Preview chain/lane drift while editing." )]
	public bool DriftInEditor { get; set; } = true;

	[Property, Group( "Volumes" ), Title( "Cloud Volumes" )]
	public List<WeatherCloudLayerSlot> Volumes { get; set; } = new();

	[Property, Group( "Volumes" ), Title( "Use Default Layout" ), Description( "When the list is empty, creates clear, rain, storm, and fog patches." )]
	public bool UseDefaultLayout { get; set; } = true;

	bool _isSyncing;
	bool _playVolumesSpawned;
	bool _lanesInitialized;
	float _alongWindProgress;

	bool ShouldDrift => Game.IsPlaying || (Game.IsEditor && DriftInEditor);

	protected override void OnAwake()
	{
		EnsureVolumesPresent();
	}

	protected override void OnStart()
	{
		EnsureVolumesPresent();
		ResetManagedVolumeTransforms();
		InitializeLaneProgress();
		ApplyGroupDrift();
	}

	protected override void OnValidate()
	{
		if ( !HasVolumeChildren() && UseDefaultLayout )
			SyncVolumes();
	}

	void EnsureVolumesPresent()
	{
		if ( !HasVolumeChildren() )
		{
			if ( UseDefaultLayout )
				SyncVolumes();
		}
		else
		{
			ConfigureExistingVolumes();
		}
	}

	protected override void OnUpdate()
	{
		// Re-apply lightning wiring while editing so hotloads pick it up without a scene rebuild.
		if ( Game.IsEditor && !Game.IsPlaying )
			ConfigureLightningOnChildren();

		if ( !ShouldDrift )
			return;

		ApplyGroupDrift();
	}

	void ConfigureLightningOnChildren()
	{
		foreach ( var child in GameObject.Children )
		{
			var volume = child.Components.Get<WeatherVolumeComponent>();
			if ( !volume.IsValid() )
				continue;

			ConfigureLightning( child, volume );
		}
	}

	void InitializeLaneProgress()
	{
		if ( _lanesInitialized )
			return;

		var wind = WeatherVolumeWindDriftComponent.GetFlatWind( ResolveGlobalWeather().WindDirection );
		var travelExtent = GetTravelExtent( wind );
		var managed = CollectManagedDrifts();
		var chainSpacing = GetChainSpacing( managed, travelExtent );

		// Start with a raining patch over the map so precipitation is visible immediately.
		var rainIndex = 0;
		for ( var i = 0; i < managed.Count; i++ )
		{
			var volume = managed[i].Volume;
			if ( !volume.IsValid() )
				continue;

			if ( volume.VolumeType is WeatherVolumeType.RainCloud or WeatherVolumeType.StormCloud )
			{
				rainIndex = i;
				break;
			}
		}

		_alongWindProgress = WrapAlongAxis( travelExtent * 0.5f - rainIndex * chainSpacing, travelExtent );
		_lanesInitialized = true;
	}

	void ResetManagedVolumeTransforms()
	{
		foreach ( var child in GameObject.Children )
		{
			var drift = child.Components.Get<WeatherVolumeWindDriftComponent>();
			if ( !drift.IsValid() || !drift.GroupManaged )
				continue;

			child.LocalPosition = Vector3.Zero;
			child.LocalRotation = Rotation.Identity;
		}
	}

	void ApplyGroupDrift()
	{
		var managed = CollectManagedDrifts();
		if ( managed.Count == 0 )
			return;

		var sample = ResolveGlobalWeather();
		var wind = WeatherVolumeWindDriftComponent.GetFlatWind( sample.WindDirection );
		var perp = WeatherVolumeWindDriftComponent.GetWindPerpendicular( wind );

		var speed = MathX.Lerp( 90f, 420f, sample.WindStrength ) * DriftSpeedMultiplier;
		_alongWindProgress += speed * Time.Delta;

		var center = Transform.World.Position;
		var travelExtent = GetTravelExtent( wind );
		if ( travelExtent <= 1f )
			return;

		// Keep progress in range so wrap restarts cleanly.
		_alongWindProgress = WrapAlongAxis( _alongWindProgress, travelExtent );

		var axisOrigin = center - wind * travelExtent * 0.5f;
		var chainSpacing = GetChainSpacing( managed, travelExtent );

		for ( var i = 0; i < managed.Count; i++ )
		{
			var drift = managed[i];
			float along;
			float lane;

			if ( MovementMode == WeatherCloudLayerMovement.Chain )
			{
				along = WrapAlongAxis( _alongWindProgress + i * chainSpacing, travelExtent );
				lane = drift.LaneOffset;
			}
			else
			{
				along = WrapAlongAxis( _alongWindProgress + drift.PhaseOffset * travelExtent, travelExtent );
				lane = drift.LaneOffset;
			}

			var position = axisOrigin + wind * along + perp * lane;
			position.z = center.z + OceanLevel;
			drift.ApplyLanePosition( position );
		}
	}

	float GetChainSpacing( List<WeatherVolumeWindDriftComponent> managed, float travelExtent )
	{
		if ( managed.Count <= 0 )
			return travelExtent;

		// Evenly space patches around the wrap loop so exiting the map teleports to the start of the chain.
		return travelExtent / managed.Count;
	}

	List<WeatherVolumeWindDriftComponent> CollectManagedDrifts()
	{
		var list = new List<WeatherVolumeWindDriftComponent>();
		foreach ( var child in GameObject.Children )
		{
			var drift = child.Components.Get<WeatherVolumeWindDriftComponent>();
			if ( !drift.IsValid() || !drift.Enabled || !drift.GroupManaged )
				continue;

			list.Add( drift );
		}

		return list;
	}

	static float WrapAlongAxis( float distance, float extent )
	{
		if ( extent <= 1f )
			return distance;

		distance %= extent;
		if ( distance < 0f )
			distance += extent;

		return distance;
	}

	float GetTravelExtent( Vector3 flatWind )
	{
		var absX = MathF.Abs( flatWind.x );
		var absY = MathF.Abs( flatWind.y );
		var length = MathF.Max( absX * RegionSize.x + absY * RegionSize.y, 1f );

		// Ensure the loop is at least long enough for the largest patch plus gap.
		var maxPatch = 0f;
		foreach ( var child in GameObject.Children )
		{
			var volume = child.Components.Get<WeatherVolumeComponent>();
			if ( !volume.IsValid() )
				continue;

			maxPatch = MathF.Max( maxPatch, MathF.Max( volume.Size.x, volume.Size.y ) );
		}

		return MathF.Max( length, maxPatch + ChainGap );
	}

	void ConfigureExistingVolumes()
	{
		var laneIndex = 0;
		var laneCount = CountVolumeChildren();

		foreach ( var child in GameObject.Children )
		{
			var volume = child.Components.Get<WeatherVolumeComponent>();
			if ( !volume.IsValid() )
				continue;

			AssignLayout( volume.VolumeType, laneIndex, laneCount, out var laneOffset, out var phaseOffset, out var baseHeight );
			volume.HorizontalBlendOnly = true;
			volume.BlendDistance = MathF.Max( volume.BlendDistance, 20000f );
			volume.DriftWithWind = true;
			if ( TryGetSlotForType( volume.VolumeType, out var slot ) )
			{
				volume.Size = slot.Size;
				volume.GizmoColor = slot.GizmoColor;
			}

			laneIndex++;
			ConfigureVolumeComponents( child, volume, laneOffset, phaseOffset, baseHeight );
		}
	}

	int CountVolumeChildren()
	{
		var count = 0;
		foreach ( var child in GameObject.Children )
		{
			if ( child.Components.Get<WeatherVolumeComponent>().IsValid() )
				count++;
		}

		return count;
	}

	void AssignLayout(
		WeatherVolumeType type,
		int laneIndex,
		int laneCount,
		out float laneOffset,
		out float phaseOffset,
		out float baseHeight )
	{
		phaseOffset = laneCount > 0 ? laneIndex / (float)laneCount : 0f;
		baseHeight = OceanLevel;
		laneOffset = 0f;

		if ( MovementMode == WeatherCloudLayerMovement.Chain )
			return;

		if ( TryGetTypeLaneLayout( type, out laneOffset, out var typedPhase, out _ ) )
		{
			phaseOffset = typedPhase;
			baseHeight = OceanLevel;
			return;
		}

		var centerIndex = (laneCount - 1) * 0.5f;
		laneOffset = (laneIndex - centerIndex) * LaneSpacing;
	}

	static bool TryGetTypeLaneLayout(
		WeatherVolumeType type,
		out float laneOffset,
		out float phaseOffset,
		out float baseHeight )
	{
		baseHeight = 0f;

		switch ( type )
		{
			case WeatherVolumeType.ClearCloud:
				laneOffset = 0f;
				phaseOffset = 0f;
				return true;
			case WeatherVolumeType.RainCloud:
				laneOffset = -DefaultLaneSpacing;
				phaseOffset = 0.25f;
				return true;
			case WeatherVolumeType.StormCloud:
				laneOffset = DefaultLaneSpacing;
				phaseOffset = 0.5f;
				return true;
			case WeatherVolumeType.SnowCloud:
				laneOffset = DefaultLaneSpacing * 2f;
				phaseOffset = 0.75f;
				return true;
			case WeatherVolumeType.FogBank:
				laneOffset = -DefaultLaneSpacing * 2f;
				phaseOffset = 0.125f;
				return true;
			default:
				laneOffset = 0f;
				phaseOffset = 0f;
				return false;
		}
	}

	bool TryGetSlotForType( WeatherVolumeType type, out WeatherCloudLayerSlot slot )
	{
		foreach ( var candidate in GetEffectiveSlots() )
		{
			if ( candidate.Type != type )
				continue;

			slot = candidate;
			return true;
		}

		slot = null;
		return false;
	}

	bool HasVolumeChildren()
	{
		foreach ( var child in GameObject.Children )
		{
			if ( child.Components.Get<WeatherVolumeComponent>().IsValid() )
				return true;
		}

		return false;
	}

	[Button( "Rebuild Volumes" ), Group( "Volumes" ), Title( "Rebuild Volumes" ), Description( "Destroy generated cloud volumes and recreate the default/custom layout." )]
	public void RebuildVolumes()
	{
		if ( Game.IsPlaying )
			return;

		_playVolumesSpawned = false;
		DestroyGeneratedVolumes();

		// Also clear leftover empty scene children that have no volume component.
		foreach ( var child in GameObject.Children.ToArray() )
		{
			if ( child.Components.Get<WeatherVolumeComponent>().IsValid() )
				child.Destroy();
		}

		SyncVolumes();
		ResetManagedVolumeTransforms();
		_lanesInitialized = false;
		InitializeLaneProgress();
		ApplyGroupDrift();
	}

	[Button( "Spawn Missing Defaults" ), Group( "Volumes" ), Title( "Spawn Missing Defaults" ), Description( "Add any default cloud types not already present as children." )]
	public void SpawnMissingDefaults()
	{
		if ( Game.IsPlaying )
			return;

		var existing = new HashSet<WeatherVolumeType>();
		foreach ( var child in GameObject.Children )
		{
			var volume = child.Components.Get<WeatherVolumeComponent>();
			if ( volume.IsValid() )
				existing.Add( volume.VolumeType );
		}

		foreach ( var slot in GetEffectiveSlots() )
		{
			if ( existing.Contains( slot.Type ) )
				continue;

			CreateVolume( slot );
			existing.Add( slot.Type );
		}

		ConfigureExistingVolumes();
		ResetManagedVolumeTransforms();
		_lanesInitialized = false;
		InitializeLaneProgress();
		ApplyGroupDrift();
	}

	public BBox GetWrapBounds() => BBox.FromPositionAndSize( Transform.World.Position, RegionSize );

	protected override void DrawGizmos()
	{
		Gizmo.Transform = Transform.World;

		var alpha = Gizmo.IsSelected ? 0.45f : 0.18f;
		Gizmo.Draw.Color = Color.Cyan.WithAlpha( alpha );
		Gizmo.Draw.LineBBox( BBox.FromPositionAndSize( Vector3.Zero, RegionSize ) );

		var slots = GetEffectiveSlots();
		var wind = Vector3.Forward;
		var perp = WeatherVolumeWindDriftComponent.GetWindPerpendicular( wind );
		var travelExtent = GetTravelExtent( wind );
		var count = Math.Max( slots.Count, 1 );
		var chainSpacing = travelExtent / count;

		for ( var i = 0; i < slots.Count; i++ )
		{
			var slot = slots[i];
			Vector3 previewPos;
			if ( MovementMode == WeatherCloudLayerMovement.Chain )
			{
				previewPos = wind * (i * chainSpacing - travelExtent * 0.5f);
				previewPos.z = OceanLevel;
			}
			else
			{
				previewPos = wind * (slot.PhaseOffset * travelExtent - travelExtent * 0.5f) + perp * slot.LaneOffset;
				previewPos.z = OceanLevel;
			}

			Gizmo.Draw.Color = slot.GizmoColor.WithAlpha( Gizmo.IsSelected ? 0.55f : 0.28f );
			Gizmo.Draw.LineBBox( BBox.FromPositionAndSize( previewPos, slot.Size ) );
		}
	}

	public void SyncVolumes()
	{
		if ( _isSyncing )
			return;

		if ( Game.IsPlaying && _playVolumesSpawned && HasVolumeChildren() )
			return;

		_isSyncing = true;

		try
		{
			DestroyGeneratedVolumes();

			var slots = GetEffectiveSlots();
			if ( slots.Count == 0 )
				return;

			foreach ( var slot in slots )
				CreateVolume( slot );

			ConfigureExistingVolumes();
			_playVolumesSpawned = Game.IsPlaying;
		}
		finally
		{
			_isSyncing = false;
		}
	}

	List<WeatherCloudLayerSlot> GetEffectiveSlots()
	{
		if ( Volumes is { Count: > 0 } )
			return Volumes;

		if ( !UseDefaultLayout )
			return [];

		return
		[
			new WeatherCloudLayerSlot
			{
				Type = WeatherVolumeType.RainCloud,
				LaneOffset = 0f,
				PhaseOffset = 0f,
				BaseHeight = 0f,
				Size = new Vector3( 200000f, 200000f, 70000f ),
				GizmoColor = new Color( 0.45f, 0.5f, 0.58f, 0.4f ),
			},
			new WeatherCloudLayerSlot
			{
				Type = WeatherVolumeType.StormCloud,
				LaneOffset = 0f,
				PhaseOffset = 0.25f,
				BaseHeight = 0f,
				Size = new Vector3( 200000f, 200000f, 76000f ),
				GizmoColor = new Color( 0.32f, 0.34f, 0.4f, 0.4f ),
			},
			new WeatherCloudLayerSlot
			{
				Type = WeatherVolumeType.ClearCloud,
				LaneOffset = 0f,
				PhaseOffset = 0.5f,
				BaseHeight = 0f,
				Size = new Vector3( 220000f, 220000f, 70000f ),
				GizmoColor = new Color( 0.92f, 0.94f, 0.98f, 0.4f ),
			},
			new WeatherCloudLayerSlot
			{
				Type = WeatherVolumeType.FogBank,
				LaneOffset = 0f,
				PhaseOffset = 0.75f,
				BaseHeight = 0f,
				Size = new Vector3( 180000f, 180000f, 40000f ),
				GizmoColor = new Color( 0.7f, 0.74f, 0.78f, 0.35f ),
			},
		];
	}

	void DestroyGeneratedVolumes()
	{
		foreach ( var child in GameObject.Children.ToArray() )
		{
			if ( !child.Tags.Has( GeneratedTag ) )
				continue;

			child.Destroy();
		}
	}

	void CreateVolume( WeatherCloudLayerSlot slot )
	{
		var go = new GameObject( true, $"{slot.Type}" );
		go.Tags.Add( "weather_volume" );
		go.Tags.Add( GeneratedTag );
		go.SetParent( GameObject );

		var volume = go.Components.Create<WeatherVolumeComponent>();
		volume.VolumeType = slot.Type;
		volume.Size = slot.Size;
		volume.UseTypeDefaults = true;
		volume.GizmoColor = slot.GizmoColor;
		volume.DrawCloudPreview = false;
		volume.DriftWithWind = true;
		volume.HorizontalBlendOnly = true;
		volume.BlendDistance = 20000f;

		ConfigureVolumeComponents( go, volume, slot.LaneOffset, slot.PhaseOffset, slot.BaseHeight );
	}

	void ConfigureVolumeComponents(
		GameObject go,
		WeatherVolumeComponent volume,
		float laneOffset,
		float phaseOffset,
		float baseHeight )
	{
		var renderer = go.Components.Get<WeatherVolumeCloudRendererComponent>();
		if ( !renderer.IsValid() )
			renderer = go.Components.Create<WeatherVolumeCloudRendererComponent>();

		renderer.EnableClouds = true;
		renderer.UseTopCloudBand = true;
		renderer.TopBandFraction = 0.06f;
		renderer.TopBandMaxHeight = 6000f;
		renderer.UseVolumeCloudTint = true;
		renderer.VolumeTintStrength = 1f;
		renderer.CastShadows = false;
		renderer.ReceiveLighting = false;
		renderer.ScaleCloudsByGlobalWeather = false;
		renderer.RequireListenerInsideVolume = false;
		renderer.CloudAmount = 1.4f;
		renderer.CloudSize = 3.2f;
		renderer.CloudFadeInSeconds = 6f;

		ConfigureRain( go, volume );
		ConfigureLightning( go, volume );

		var drift = go.Components.Get<WeatherVolumeWindDriftComponent>();
		if ( !drift.IsValid() )
			drift = go.Components.Create<WeatherVolumeWindDriftComponent>();

		drift.WrapRegion = this;
		drift.WrapHorizontally = false;
		drift.WrapInWorldBounds = false;
		drift.UseCustomWrapRegion = false;
		drift.LaneOffset = MovementMode == WeatherCloudLayerMovement.Chain ? 0f : laneOffset;
		drift.PhaseOffset = phaseOffset;
		drift.BaseHeight = OceanLevel;
		drift.SpeedMultiplier = 1f;
		drift.GroupManaged = true;
		drift.DriftInEditor = DriftInEditor;
		drift.Enabled = volume.DriftWithWind;
	}

	void ConfigureLightning( GameObject go, WeatherVolumeComponent volume )
	{
		var wantsLightning = volume.VolumeType == WeatherVolumeType.StormCloud;

		var renderers = go.Components.GetAll<WeatherVolumeLightningRendererComponent>().ToArray();
		for ( var i = 1; i < renderers.Length; i++ )
		{
			if ( renderers[i].IsValid() )
				renderers[i].Destroy();
		}

		var controllers = go.Components.GetAll<WeatherVolumeLightningControllerComponent>().ToArray();
		for ( var i = 1; i < controllers.Length; i++ )
		{
			if ( controllers[i].IsValid() )
				controllers[i].Destroy();
		}

		var controller = go.Components.Get<WeatherVolumeLightningControllerComponent>();
		var renderer = go.Components.Get<WeatherVolumeLightningRendererComponent>();

		if ( !wantsLightning )
		{
			if ( controller.IsValid() )
				controller.Enabled = false;

			if ( renderer.IsValid() )
				renderer.Enabled = false;

			return;
		}

		if ( !renderer.IsValid() )
			renderer = go.Components.Create<WeatherVolumeLightningRendererComponent>();

		if ( !controller.IsValid() )
			controller = go.Components.Create<WeatherVolumeLightningControllerComponent>();

		renderer.Enabled = true;
		renderer.PeakRadius = 24000f;
		renderer.PeakBrightness = 160f;
		renderer.FlashColor = new Color( 0.45f, 0.7f, 1.6f );
		renderer.Attenuation = 0.75f;
		renderer.FogStrength = 1.5f;
		renderer.EnableBoltSprite = true;
		renderer.BoltWidth = 12000f;
		renderer.BoltBrightness = 28f;
		renderer.BoltLength = 32000f;
		controller.Enabled = true;
		controller.EnableLightning = true;
		controller.EditorPreview = true;
		controller.MinInterval = 10f;
		controller.MaxInterval = 22f;
		controller.MaxConcurrentFlashes = 1;
		controller.CloudInfluenceRadius = 14000f;
	}

	void ConfigureRain( GameObject go, WeatherVolumeComponent volume )
	{
		var wantsRain = volume.VolumeType is WeatherVolumeType.RainCloud or WeatherVolumeType.StormCloud;
		var rain = go.Components.Get<WeatherVolumeRainComponent>();

		if ( !wantsRain )
		{
			if ( rain.IsValid() )
				rain.Enabled = false;

			return;
		}

		if ( !rain.IsValid() )
			rain = go.Components.Create<WeatherVolumeRainComponent>();

		rain.EnableRain = true;
		rain.Enabled = true;
		rain.EditorPreview = true;
		rain.AlwaysPreviewUnderVolume = true;
		rain.Strength = volume.VolumeType == WeatherVolumeType.StormCloud
			? WeatherRainStrength.Strong
			: WeatherRainStrength.None;
		rain.RainIntensity = 1f;
		rain.Placement = WeatherRainPlacement.FillVolume;
		rain.ColumnWidth = volume.VolumeType == WeatherVolumeType.StormCloud ? 15000f : 14000f;
		rain.VisibleHeight = volume.VolumeType == WeatherVolumeType.StormCloud ? 45000f : 40000f;
		rain.SplashRadius = volume.VolumeType == WeatherVolumeType.StormCloud ? 4800f : 4200f;
		rain.CollideWithWorld = true;
		rain.BlockIndoors = true;
		rain.EnableSplashes = true;
		rain.EnableImpactAudio = true;
	}

	WeatherSample ResolveGlobalWeather()
	{
		var world = WorldManagerComponent.Instance;
		if ( world.IsValid() && world.Weather.IsValid() )
		{
			if ( Game.IsEditor && !Game.IsPlaying )
				return WeatherSample.FromProfile( WeatherProfile.GetPreset( world.Weather.StartingWeather ) );

			return WeatherSample.FromWeatherManager( world.Weather );
		}

		if ( Scene is null )
			return WeatherSample.DefaultClear;

		var weatherManager = Scene.GetAllComponents<WeatherManagerComponent>().FirstOrDefault();
		if ( weatherManager.IsValid() )
		{
			if ( Game.IsEditor && !Game.IsPlaying )
				return WeatherSample.FromProfile( WeatherProfile.GetPreset( weatherManager.StartingWeather ) );

			return WeatherSample.FromWeatherManager( weatherManager );
		}

		return WeatherSample.DefaultClear;
	}
}
