using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

public enum WorldMapPreviewDisplayMode
{
	[Title( "Height" )]
	Height,

	[Title( "Biomes" )]
	Biomes
}

[Title( "World Map Preview" ), Category( "Terrain" ), Icon( "map" )]
public sealed class WorldMapPreviewComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Map" ), Title( "World Manager" )]
	public WorldManagerSingletonComponent WorldManager { get; set; }

	[Property, Group( "Map" ), Title( "Chunk Streamer" ), Description( "Used to size the local sample area when Follow Viewer is on." )]
	public ChunkStreamerComponent ChunkStreamer { get; set; }

	[Property, Group( "Map" ), Title( "Follow Viewer" ), Description( "Off = full-world noise map. On = zoomed local patch around the editor camera." )]
	public bool FollowViewer { get; set; } = false;

	[Property, Group( "Map" ), Title( "Display Mode" ), Description( "Height shows continuous elevation. Biomes uses terrain colors; large full-world maps use soft blending." )]
	public WorldMapPreviewDisplayMode DisplayMode { get; set; } = WorldMapPreviewDisplayMode.Height;

	[Property, Group( "Map" ), Title( "Sample Area Size" ), Description( "World units sampled when Follow Viewer is on. 0 uses Chunk Size x 2." ), Range( 0, 65536 )]
	public float SampleAreaSize { get; set; } = 0f;

	[Property, Group( "Map" ), Title( "Resolution" ), Description( "Preview texture size. Lower is faster." ), Range( 128, 1024 )]
	public int MapResolution { get; set; } = 512;

	[Property, Group( "Map" ), Title( "Rows Per Frame" ), Description( "Height rows generated per editor frame while rebuilding." ), Range( 4, 128 )]
	public int RowsPerFrame { get; set; } = 48;

	[Property, Group( "Map" ), Title( "Color Rows Per Frame" ), Description( "Biome color rows generated per editor frame while rebuilding." ), Range( 4, 128 )]
	public int ColorRowsPerFrame { get; set; } = 48;

	[Property, Group( "Map" ), Title( "Panel Size" ), Range( 128, 1024 )]
	public float PanelSize { get; set; } = 360f;

	[Property, Group( "Map" ), Title( "Panel Margin" ), Range( 0, 128 )]
	public float PanelMargin { get; set; } = 16f;

	[Property, Group( "Map" ), Title( "Show Camera Marker" )]
	public bool ShowCameraMarker { get; set; } = true;

	[Property, Group( "Map" ), Title( "Show View Direction" ), Description( "Draw an arrow on the map showing which way the camera is looking." )]
	public bool ShowViewDirection { get; set; } = true;

	[Property, Group( "Map" ), Title( "View Direction Arrow (Chunks)" ), Description( "Arrow length in chunk sizes on the map preview." ), Range( 0.25f, 6f )]
	public float ViewDirectionArrowChunks { get; set; } = 1.5f;

	[Property, Group( "Map" ), Title( "Show Loaded Chunks" ), Description( "Highlight loaded terrain with one border around the whole loaded region." )]
	public bool ShowLoadedChunks { get; set; } = true;

	[Property, Group( "Map" ), Title( "Show Pending Chunks" ), Description( "Fill terrain tiles queued for loading. No per-chunk borders." )]
	public bool ShowPendingChunks { get; set; } = true;

	[Property, Group( "Map" ), Title( "Show View Distance" ), Description( "Draw the chunk streamer's view-distance bounds around the viewer." )]
	public bool ShowViewDistance { get; set; } = true;

	[Property, Group( "Map" ), Title( "Show Stream Overlay Legend" )]
	public bool ShowStreamLegend { get; set; } = true;

	[Property, Group( "Map" ), Title( "Display Cells" ), Description( "Screen cells used while the map is building. The finished map uses one texture draw." ), Range( 32, 256 )]
	public int DisplayCells { get; set; } = 96;

	Texture MapTexture { get; set; }

	byte[] _mapPixelData;
	int _mapPixelSize;
	Color[] _displayColors;
	int _displayCells;
	int _displayCacheVersion;
	int _mapDataVersion;

	int _terrainSettingsVersion = -1;
	int _noiseSettingsVersion = -1;
	int _mapResolution = -1;
	bool _lastFollowViewer;
	WorldMapPreviewDisplayMode _lastDisplayMode;
	float _lastSampleAreaSize = -1f;
	Vector2 _lastSampleCenter = new( float.NaN, float.NaN );
	bool _rebuildQueued;
	bool _awaitingRebuild;
	TimeUntil _rebuildDelay;
	Vector2 _cameraMapUv = new( -1f, -1f );
	bool _cameraOnMap;
	Vector3 _cachedCameraPosition;
	bool _hasCachedCameraPosition;

	bool _rebuildActive;
	bool _rebuildColorPass;
	int _rebuildSize;
	int _rebuildRow;
	int _rebuildColorRow;
	float _rebuildStepX;
	float _rebuildStepY;
	Vector2 _rebuildWorldMin;
	Vector2 _sampleWorldSize;
	byte[] _rebuildData;
	float[,] _rebuildHeights;
	float _rebuildHeightMin = float.MaxValue;
	float _rebuildHeightMax = float.MinValue;

	readonly List<ChunkCoord> _loadedChunkCoords = new();
	readonly List<ChunkCoord> _pendingChunkCoords = new();

	protected override void OnAwake()
	{
		ResolveWorldManager();
		ScheduleRebuild( 0f );
	}

	protected override void OnUpdate()
	{
		if ( Game.IsPlaying )
			return;

		try
		{
			TickPreview();
		}
		catch ( Exception exception )
		{
			Log.Warning( $"World Map Preview update failed: {exception.Message}" );
			_rebuildActive = false;
			_rebuildQueued = false;
			_awaitingRebuild = false;
			_rebuildDelay = 0f;
		}
	}

	void TickPreview()
	{
		ResolveWorldManager();

		if ( !WorldManager.IsValid() )
			return;

		if ( NeedsRebuild() )
		{
			if ( _rebuildActive )
				_rebuildQueued = true;
			else if ( !_awaitingRebuild )
				ScheduleRebuild( GetRebuildDelay() );
		}

		if ( _rebuildActive )
			ContinueRebuild();
		else if ( _awaitingRebuild && _rebuildDelay )
			BeginRebuild();
	}

	protected override void OnValidate()
	{
		if ( !Game.IsEditor || Game.IsPlaying )
			return;

		ResolveWorldManager();

		if ( !WorldManager.IsValid() )
			return;

		if ( !_rebuildActive && !_awaitingRebuild )
			ScheduleRebuild( GetRebuildDelay() );
	}

	protected override void DrawGizmos()
	{
		if ( Game.IsPlaying )
			return;

		CacheEditorCameraPosition();
		UpdateCameraMarker();

		using ( Gizmo.Scope( "world-map-preview" ) )
		{
			Gizmo.Transform = global::Transform.Zero;
			Gizmo.Draw.IgnoreDepth = true;

			var rect = GetPanelRect();
			var borderColor = Color.White.WithAlpha( 0.25f );
			var borderSize = new Vector4( 1f, 1f, 1f, 1f );

			Gizmo.Draw.ScreenRect(
				rect,
				Color.Black.WithAlpha( 0.65f ),
				Vector4.Zero,
				borderColor,
				borderSize,
				BlendMode.Normal );

			if ( !TryDrawFinishedMap( rect ) )
			{
				if ( TryGetMapPixelData( out var pixelData, out var pixelSize ) )
					DrawBuildingMapImage( rect, pixelData, pixelSize );
				else if ( _rebuildActive || _awaitingRebuild )
				{
					var textPos = new Vector2( rect.Left + rect.Width * 0.5f, rect.Top + rect.Height * 0.5f );
					Gizmo.Draw.ScreenText( GetBuildStatusText(), textPos, "Inter", 14f, TextFlag.Center );
				}
			}

			DrawStreamOverlay( rect );

			if ( ShowStreamLegend )
				DrawStreamLegend( rect );

			if ( ShowCameraMarker && _cameraOnMap )
				DrawCameraMarker( rect );
		}
	}

	bool NeedsRebuild()
	{
		if ( !WorldManager.IsValid() )
			return false;

		if ( WorldManager.TerrainSettingsVersion != _terrainSettingsVersion
			|| WorldManager.NoiseSettingsVersion != _noiseSettingsVersion
			|| GetEffectiveResolution() != _mapResolution
			|| FollowViewer != _lastFollowViewer
			|| DisplayMode != _lastDisplayMode
			|| MathF.Abs( SampleAreaSize - _lastSampleAreaSize ) > 1f )
			return true;

		if ( !FollowViewer )
			return false;

		if ( !TryGetCachedCameraPosition( out var center ) )
			return false;

		if ( float.IsNaN( _lastSampleCenter.x ) )
			return true;

		return _lastSampleCenter.Distance( center ) > GetSampleMoveThreshold();
	}

	void BeginRebuild()
	{
		_awaitingRebuild = false;
		_rebuildDelay = 0f;
		_rebuildQueued = false;

		if ( !WorldManager.IsValid() )
			return;

		_mapResolution = GetEffectiveResolution();
		_lastFollowViewer = FollowViewer;
		_lastDisplayMode = DisplayMode;
		_lastSampleAreaSize = SampleAreaSize;
		_rebuildHeightMin = float.MaxValue;
		_rebuildHeightMax = float.MinValue;

		if ( !TryGetSampleBounds( out _rebuildWorldMin, out _sampleWorldSize ) )
		{
			_rebuildWorldMin = WorldManager.WorldMin;
			_sampleWorldSize = WorldManager.WorldSize;
		}

		_lastSampleCenter = _rebuildWorldMin + _sampleWorldSize * 0.5f;

		_rebuildSize = _mapResolution;
		_rebuildRow = 0;
		_rebuildColorRow = 0;
		_rebuildColorPass = false;
		_rebuildStepX = _sampleWorldSize.x / Math.Max( _rebuildSize - 1, 1 );
		_rebuildStepY = _sampleWorldSize.y / Math.Max( _rebuildSize - 1, 1 );
		_rebuildData = new byte[_rebuildSize * _rebuildSize * 4];
		_rebuildHeights = new float[_rebuildSize, _rebuildSize];
		_rebuildActive = true;

		ContinueRebuild();
	}

	void ContinueRebuild()
	{
		if ( !WorldManager.IsValid() || !_rebuildActive || _rebuildHeights is null || _rebuildData is null || _rebuildSize <= 0 )
			return;

		if ( !_rebuildColorPass )
		{
			var rowsPerFrame = Math.Clamp( RowsPerFrame, 4, 128 );
			var endRow = Math.Min( _rebuildRow + rowsPerFrame, _rebuildSize );

			for ( int y = _rebuildRow; y < endRow; y++ )
			{
				for ( int x = 0; x < _rebuildSize; x++ )
				{
					var worldX = _rebuildWorldMin.x + x * _rebuildStepX;
					var worldY = _rebuildWorldMin.y + y * _rebuildStepY;
					var height = WorldManager.GetHeight( worldX, worldY );
					_rebuildHeights[x, y] = height;
					_rebuildHeightMin = MathF.Min( _rebuildHeightMin, height );
					_rebuildHeightMax = MathF.Max( _rebuildHeightMax, height );
				}
			}

			_rebuildRow = endRow;

			if ( _rebuildRow < _rebuildSize )
				return;

			_rebuildColorPass = true;
			_rebuildColorRow = 0;
		}

		var colorRowsPerFrame = Math.Clamp( ColorRowsPerFrame, 4, 128 );
		var colorEndRow = Math.Min( _rebuildColorRow + colorRowsPerFrame, _rebuildSize );

		for ( int y = _rebuildColorRow; y < colorEndRow; y++ )
		{
			for ( int x = 0; x < _rebuildSize; x++ )
			{
				var slope = ShouldUseSlopeColoring()
					? SampleSlope( _rebuildHeights, x, y, _rebuildSize, _rebuildStepX, _rebuildStepY )
					: 0f;
				var color = GetPreviewColor( _rebuildHeights[x, y], slope );
				SetPixel( _rebuildData, x, y, _rebuildSize, color );
			}
		}

		_rebuildColorRow = colorEndRow;

		if ( _rebuildColorRow < _rebuildSize )
			return;

		try
		{
			MapTexture = Texture.Create( _rebuildSize, _rebuildSize )
				.WithStaticUsage()
				.WithData( _rebuildData )
				.Finish();
		}
		catch ( Exception exception )
		{
			Log.Warning( $"World Map Preview texture upload failed: {exception.Message}" );
		}

		_mapPixelData = _rebuildData;
		_mapPixelSize = _rebuildSize;
		_mapDataVersion++;
		_displayCacheVersion = -1;
		_terrainSettingsVersion = WorldManager.TerrainSettingsVersion;
		_noiseSettingsVersion = WorldManager.NoiseSettingsVersion;
		_rebuildActive = false;
		_rebuildColorPass = false;
		_rebuildData = null;
		_rebuildHeights = null;

		if ( _rebuildQueued || NeedsRebuild() )
		{
			_rebuildQueued = false;
			ScheduleRebuild( GetRebuildDelay() );
		}
	}

	float GetRebuildDelay()
	{
		if ( _mapPixelData is null )
			return 0f;

		if ( !WorldManager.IsValid() )
			return 0.05f;

		return WorldManager.EditorRebuildDelay;
	}

	string GetBuildStatusText()
	{
		if ( !_rebuildActive || _rebuildSize <= 0 )
			return "Building map...";

		if ( !_rebuildColorPass )
		{
			var progress = _rebuildRow / (float)_rebuildSize;
			return $"Sampling height {(progress * 100f):0}%";
		}

		var colorProgress = _rebuildColorRow / (float)_rebuildSize;
		return $"Coloring map {(colorProgress * 100f):0}%";
	}

	bool TryGetMapPixelData( out byte[] pixelData, out int pixelSize )
	{
		if ( _rebuildActive && _rebuildColorPass && _rebuildData is not null && _rebuildSize > 0 )
		{
			pixelData = _rebuildData;
			pixelSize = _rebuildSize;
			return true;
		}

		if ( _mapPixelData is not null && _mapPixelSize > 0 )
		{
			pixelData = _mapPixelData;
			pixelSize = _mapPixelSize;
			return true;
		}

		pixelData = null;
		pixelSize = 0;
		return false;
	}

	bool TryDrawFinishedMap( Rect rect )
	{
		if ( _rebuildActive || _mapPixelData is null )
			return false;

		DrawCachedMapImage( rect );
		return true;
	}

	void DrawCachedMapImage( Rect rect )
	{
		EnsureDisplayCache( _mapPixelData, _mapPixelSize );
		DrawDisplayCache( rect );
	}

	void DrawBuildingMapImage( Rect rect, byte[] pixelData, int pixelSize )
	{
		EnsureDisplayCache( pixelData, pixelSize, _rebuildActive ? _rebuildColorRow : -1 );
		DrawDisplayCache( rect );
	}

	void DrawDisplayCache( Rect rect )
	{
		if ( _displayColors is null || _displayCells <= 0 )
			return;

		var cellW = rect.Width / _displayCells;
		var cellH = rect.Height / _displayCells;

		for ( int y = 0; y < _displayCells; y++ )
		{
			for ( int x = 0; x < _displayCells; x++ )
			{
				var color = _displayColors[(y * _displayCells) + x];
				var pixelRect = new Rect(
					rect.Left + (_displayCells - 1 - x) * cellW,
					rect.Top + y * cellH,
					MathF.Ceiling( cellW ),
					MathF.Ceiling( cellH ) );

				Gizmo.Draw.ScreenRect(
					pixelRect,
					color,
					Vector4.Zero,
					Color.Transparent,
					Vector4.Zero,
					BlendMode.Normal );
			}
		}
	}

	void EnsureDisplayCache( byte[] pixelData, int pixelSize, int buildProgressRow = -1 )
	{
		var cells = Math.Clamp( DisplayCells, 32, 256 );
		cells = Math.Min( cells, pixelSize );
		var cacheVersion = buildProgressRow >= 0
			? HashCode.Combine( _mapDataVersion, buildProgressRow, cells )
			: HashCode.Combine( _mapDataVersion, cells );

		if ( _displayColors is not null
			&& _displayCells == cells
			&& _displayCacheVersion == cacheVersion )
			return;

		_displayCells = cells;
		_displayColors = new Color[cells * cells];
		_displayCacheVersion = cacheVersion;

		for ( int y = 0; y < cells; y++ )
		{
			for ( int x = 0; x < cells; x++ )
			{
				var srcX = x * (pixelSize - 1) / Math.Max( cells - 1, 1 );
				var srcY = y * (pixelSize - 1) / Math.Max( cells - 1, 1 );
				_displayColors[(y * cells) + x] = ReadPixel( pixelData, srcX, srcY, pixelSize );
			}
		}
	}

	static Color ReadPixel( byte[] data, int x, int y, int size )
	{
		var row = size - 1 - y;
		var index = (x + (row * size)) * 4;
		return new Color(
			data[index] / 255f,
			data[index + 1] / 255f,
			data[index + 2] / 255f,
			1f );
	}

	int GetEffectiveResolution()
	{
		var requested = Math.Clamp( MapResolution, 128, 1024 );

		if ( FollowViewer || !WorldManager.IsValid() )
			return requested;

		var maxDim = MathF.Max( WorldManager.WorldSize.x, WorldManager.WorldSize.y );
		var maxCap = maxDim > 100_000f ? 512 : maxDim > 10_000f ? 384 : 1024;
		requested = Math.Min( requested, maxCap );

		var frequency = WorldManager.HeightNoiseFrequency;
		if ( frequency > 0.0000001f )
		{
			// Keep at least ~2 samples per first-octave feature so macro landforms stay visible.
			var minResolution = (int)MathX.Clamp( MathF.Ceiling( maxDim * frequency * 2f ) + 1, 128, maxCap );
			requested = (int)MathX.Clamp( Math.Max( requested, minResolution ), 128, maxCap );
		}

		return requested;
	}

	Rect GetPanelRect()
	{
		var size = PanelSize.Clamp( 128f, 1024f );
		var margin = PanelMargin.Clamp( 0f, 128f );
		var viewport = GetViewportRect();
		var left = viewport.Width - margin - size;
		var top = viewport.Height - margin - size;
		return new Rect( left, top, size, size );
	}

	Rect GetViewportRect()
	{
		// Gizmo screen draws use viewport-local pixels (0..Camera.Size), not full window coords.
		var cameraSize = Gizmo.Camera.Size;
		if ( cameraSize.x > 1f && cameraSize.y > 1f )
			return new Rect( 0f, 0f, cameraSize.x, cameraSize.y );

		if ( Scene.Camera.IsValid() && Scene.Camera.ScreenRect.Width > 1f && Scene.Camera.ScreenRect.Height > 1f )
			return Scene.Camera.ScreenRect;

		return new Rect( 0f, 0f, Screen.Size.x, Screen.Size.y );
	}

	void ResolveWorldManager()
	{
		if ( WorldManager.IsValid() )
			return;

		WorldManager = WorldManagerSingletonComponent.Instance;
	}

	void ResolveChunkStreamer()
	{
		if ( ChunkStreamer.IsValid() || Scene is null )
			return;

		ChunkStreamer = Scene.GetAllComponents<ChunkStreamerComponent>().FirstOrDefault();
	}

	void CacheEditorCameraPosition()
	{
		ResolveChunkStreamer();

		if ( ChunkStreamer.IsValid() && ChunkStreamer.TryGetStreamWorldPosition( out var streamPosition ) )
		{
			_cachedCameraPosition = streamPosition;
			_hasCachedCameraPosition = true;
			return;
		}

		if ( !TryGetEditorCameraPosition( out var position ) )
		{
			_hasCachedCameraPosition = false;
			return;
		}

		_cachedCameraPosition = position;
		_hasCachedCameraPosition = true;
	}

	bool TryGetCachedCameraPosition( out Vector2 center )
	{
		if ( !_hasCachedCameraPosition )
		{
			center = default;
			return false;
		}

		center = new Vector2( _cachedCameraPosition.x, _cachedCameraPosition.y );
		return true;
	}

	float GetSampleAreaSize()
	{
		if ( SampleAreaSize > 1f )
			return SampleAreaSize;

		ResolveChunkStreamer();

		if ( ChunkStreamer.IsValid() )
			return ChunkStreamer.ChunkSize * 2f;

		return 4096f;
	}

	float GetSampleMoveThreshold()
	{
		var area = GetSampleAreaSize();
		var resolution = Math.Clamp( MapResolution, 128, 1024 );
		return MathF.Max( area / resolution * 0.5f, 8f );
	}

	bool TryGetSampleCenter( out Vector2 center )
	{
		return TryGetCachedCameraPosition( out center );
	}

	bool TryGetSampleBounds( out Vector2 worldMin, out Vector2 worldSize )
	{
		if ( !FollowViewer )
		{
			worldMin = WorldManager.WorldMin;
			worldSize = WorldManager.WorldSize;
			return true;
		}

		if ( !TryGetSampleCenter( out var center ) )
		{
			worldMin = default;
			worldSize = default;
			return false;
		}

		var size = GetSampleAreaSize();
		var half = size * 0.5f;
		worldMin = center - new Vector2( half, half );
		worldSize = new Vector2( size, size );
		return true;
	}

	bool ShouldUseSlopeColoring()
	{
		if ( FollowViewer )
			return true;

		return MathF.Min( _rebuildStepX, _rebuildStepY ) <= 128f;
	}

	bool UseSoftBiomePreview()
	{
		if ( DisplayMode != WorldMapPreviewDisplayMode.Biomes || FollowViewer )
			return false;

		return MathF.Max( _sampleWorldSize.x, _sampleWorldSize.y ) > 10_000f
			|| MathF.Min( _rebuildStepX, _rebuildStepY ) > 250f;
	}

	Color GetPreviewColor( float height, float slope )
	{
		if ( DisplayMode == WorldMapPreviewDisplayMode.Height )
			return GetHeightPreviewColor( height );

		if ( UseSoftBiomePreview() )
			return TerrainBiome.GetSoftPreviewColorFromHeight( WorldManager, height, slope );

		return TerrainBiome.GetColorFromHeight( WorldManager, height, slope );
	}

	Color GetHeightPreviewColor( float height )
	{
		var range = MathF.Max( _rebuildHeightMax - _rebuildHeightMin, 1f );
		var waterLevel = WorldManager.WaterLevel;

		if ( height < waterLevel )
		{
			var depth = MathX.Clamp( (waterLevel - height) / range, 0f, 1f );
			return Color.Lerp( new Color( 0.04f, 0.08f, 0.18f ), WorldManager.WaterColor, 1f - depth * 0.6f );
		}

		var landT = MathX.Clamp( (height - waterLevel) / range, 0f, 1f );
		var lowland = new Color( 0.12f, 0.32f, 0.14f );
		var highland = new Color( 0.52f, 0.44f, 0.30f );
		var peak = new Color( 0.92f, 0.90f, 0.88f );

		if ( landT < 0.55f )
			return Color.Lerp( lowland, highland, landT / 0.55f );

		return Color.Lerp( highland, peak, (landT - 0.55f) / 0.45f );
	}

	void ScheduleRebuild( float delay )
	{
		_awaitingRebuild = true;
		_rebuildActive = false;
		_rebuildColorPass = false;
		_rebuildDelay = Math.Max( delay, 0f );
	}

	void UpdateCameraMarker()
	{
		_cameraOnMap = false;
		_cameraMapUv = new Vector2( -1f, -1f );

		if ( !ShowCameraMarker || !WorldManager.IsValid() || !_hasCachedCameraPosition )
			return;

		if ( !TryGetMapWorldBounds( out var worldMin, out var worldSize ) )
			return;

		_cameraMapUv = WorldToMapUvExact( _cachedCameraPosition.x, _cachedCameraPosition.y, worldMin, worldSize );
		_cameraOnMap = _cameraMapUv.x >= 0f
			&& _cameraMapUv.x <= 1f
			&& _cameraMapUv.y >= 0f
			&& _cameraMapUv.y <= 1f;
	}

	void DrawStreamOverlay( Rect rect )
	{
		if ( !TryGetMapWorldBounds( out var worldMin, out var worldSize ) )
			return;

		ResolveChunkStreamer();

		if ( ChunkStreamer.IsValid() )
		{
			if ( ShowViewDistance && ChunkStreamer.TryGetStreamChunkCenter( out var streamCenter ) )
			{
				var viewDistance = Math.Max( ChunkStreamer.ViewDistance, 0 );
				var chunkSize = Math.Max( ChunkStreamer.ChunkSize, 1 );
				var ringMinX = (streamCenter.X - viewDistance) * chunkSize;
				var ringMinY = (streamCenter.Y - viewDistance) * chunkSize;
				var ringMaxX = (streamCenter.X + viewDistance + 1) * chunkSize;
				var ringMaxY = (streamCenter.Y + viewDistance + 1) * chunkSize;

				DrawWorldRectOutline(
					rect,
					worldMin,
					worldSize,
					ringMinX,
					ringMinY,
					ringMaxX,
					ringMaxY,
					Color.Cyan.WithAlpha( 0.9f ),
					2f,
					fill: Color.Cyan.WithAlpha( 0.04f ) );
			}

			if ( ShowPendingChunks )
			{
				ChunkStreamer.CopyPendingChunkCoords( _pendingChunkCoords );

				foreach ( var coord in _pendingChunkCoords )
				{
					DrawChunkFill(
						rect,
						worldMin,
						worldSize,
						coord,
						ChunkStreamer.ChunkSize,
						Color.Orange.WithAlpha( 0.18f ) );
				}
			}

			if ( ShowLoadedChunks )
			{
				ChunkStreamer.CopyLoadedChunkCoords( _loadedChunkCoords );

				if ( TryGetChunkRegionBounds(
					_loadedChunkCoords,
					ChunkStreamer.ChunkSize,
					out var loadedMinX,
					out var loadedMinY,
					out var loadedMaxX,
					out var loadedMaxY ) )
				{
					DrawWorldRectOutline(
						rect,
						worldMin,
						worldSize,
						loadedMinX,
						loadedMinY,
						loadedMaxX,
						loadedMaxY,
						Color.Yellow.WithAlpha( 0.9f ),
						2f,
						fill: Color.Yellow.WithAlpha( 0.12f ) );
				}
			}
		}
	}

	void DrawCameraMarker( Rect rect )
	{
		if ( !TryGetMapWorldBounds( out var worldMin, out var worldSize ) )
			return;

		var screenPos = MapUvToScreen( _cameraMapUv, rect );
		const float dotRadius = 4f;
		const float ringRadius = 7f;

		Gizmo.Draw.ScreenRect(
			new Rect( screenPos.x - ringRadius, screenPos.y - ringRadius, ringRadius * 2f, ringRadius * 2f ),
			Color.Transparent,
			Vector4.Zero,
			Color.White.WithAlpha( 0.95f ),
			new Vector4( 2f ),
			BlendMode.Normal );

		Gizmo.Draw.ScreenRect(
			new Rect( screenPos.x - dotRadius, screenPos.y - dotRadius, dotRadius * 2f, dotRadius * 2f ),
			Color.White,
			new Vector4( dotRadius ),
			Color.Black.WithAlpha( 0.9f ),
			new Vector4( 1.5f ),
			BlendMode.Normal );

		if ( ShowViewDirection )
			DrawViewDirectionArrow( rect, worldMin, worldSize, screenPos );
	}

	void DrawViewDirectionArrow( Rect rect, Vector2 worldMin, Vector2 worldSize, Vector2 screenStart )
	{
		if ( !TryGetViewDirectionWorldEnd( out var worldEnd, out _ ) )
			return;

		var screenEnd = MapUvToScreen( WorldToMapUvExact( worldEnd.x, worldEnd.y, worldMin, worldSize ), rect );
		var arrowColor = Color.Cyan.WithAlpha( 0.95f );

		DrawScreenLine( screenStart, screenEnd, 2.5f, arrowColor );

		var screenForward = screenEnd - screenStart;
		if ( screenForward.LengthSquared <= 1f )
			return;

		screenForward = screenForward.Normal;
		var headLength = 10f;
		var headWidth = 6f;
		var left = new Vector2(
			screenForward.x * -headLength + screenForward.y * headWidth,
			screenForward.y * -headLength + screenForward.x * -headWidth );
		var right = new Vector2(
			screenForward.x * -headLength + screenForward.y * -headWidth,
			screenForward.y * -headLength + screenForward.x * headWidth );

		DrawScreenLine( screenEnd, screenEnd + left, 2.5f, arrowColor );
		DrawScreenLine( screenEnd, screenEnd + right, 2.5f, arrowColor );
	}

	bool TryGetViewDirectionWorldEnd( out Vector2 worldEnd, out Vector2 worldForward )
	{
		worldEnd = default;
		worldForward = default;

		if ( !_hasCachedCameraPosition )
			return false;

		ResolveChunkStreamer();

		if ( ChunkStreamer.IsValid() && ChunkStreamer.TryGetStreamViewForward( out worldForward ) )
		{
			var arrowLength = Math.Max( ChunkStreamer.ChunkSize, 1 ) * ViewDirectionArrowChunks.Clamp( 0.25f, 6f );
			worldEnd = new Vector2(
				_cachedCameraPosition.x + worldForward.x * arrowLength,
				_cachedCameraPosition.y + worldForward.y * arrowLength );
			return true;
		}

		if ( TryGetEditorCameraForward( out var forward3D ) )
		{
			worldForward = new Vector2( forward3D.x, forward3D.y );
			if ( worldForward.LengthSquared <= 0.0001f )
				return false;

			worldForward = worldForward.Normal;
			var arrowLength = 2048f * ViewDirectionArrowChunks.Clamp( 0.25f, 6f );
			worldEnd = new Vector2(
				_cachedCameraPosition.x + worldForward.x * arrowLength,
				_cachedCameraPosition.y + worldForward.y * arrowLength );
			return true;
		}

		return false;
	}

	bool TryGetEditorCameraForward( out Vector3 forward )
	{
		forward = default;

		if ( ChunkStreamerComponent.TryGetEditorViewportRotation( out var rotation ) )
		{
			forward = rotation.Forward;
			return true;
		}

		ResolveChunkStreamer();

		if ( ChunkStreamer.IsValid() && ChunkStreamer.TryGetStreamViewForward( out var streamForward ) )
		{
			forward = new Vector3( streamForward.x, streamForward.y, 0f );
			return true;
		}

		if ( Scene is not null && Scene.Camera.IsValid() )
		{
			forward = Scene.Camera.WorldRotation.Forward;
			return true;
		}

		return false;
	}

	static void DrawScreenLine( Vector2 from, Vector2 to, float thickness, Color color )
	{
		var delta = to - from;
		var length = delta.Length;
		if ( length <= 0.5f )
			return;

		var direction = delta / length;
		var steps = Math.Max( (int)(length / 2f), 1 );

		for ( int i = 0; i <= steps; i++ )
		{
			var t = i / (float)steps;
			var point = Vector2.Lerp( from, to, t );
			Gizmo.Draw.ScreenRect(
				new Rect( point.x - thickness * 0.5f, point.y - thickness * 0.5f, thickness, thickness ),
				color,
				new Vector4( thickness * 0.5f ),
				Color.Transparent,
				Vector4.Zero,
				BlendMode.Normal );
		}
	}

	static Vector2 MapUvToScreen( Vector2 mapUv, Rect panelRect )
	{
		return new Vector2(
			panelRect.Left + mapUv.x * panelRect.Width,
			panelRect.Top + mapUv.y * panelRect.Height );
	}

	void DrawStreamLegend( Rect rect )
	{
		ResolveChunkStreamer();

		var loaded = ChunkStreamer.IsValid() ? ChunkStreamer.LoadedChunkCount : 0;
		var pending = ChunkStreamer.IsValid() ? ChunkStreamer.PendingChunkCount : 0;
		var lines = new List<string> { "Viewer +" };

		if ( ShowLoadedChunks )
			lines.Add( $"Loaded {loaded}" );

		if ( ShowPendingChunks )
			lines.Add( $"Pending {pending}" );

		if ( ShowViewDistance && ChunkStreamer.IsValid() )
			lines.Add( $"View D{ChunkStreamer.ViewDistance}" );

		var text = string.Join( "  ", lines );
		var textPos = new Vector2( rect.Left + 8f, rect.Top + 8f );
		Gizmo.Draw.ScreenText( text, textPos, "Inter", 11f, TextFlag.Left );
	}

	static bool TryGetChunkRegionBounds(
		IReadOnlyList<ChunkCoord> coords,
		int chunkSize,
		out float worldMinX,
		out float worldMinY,
		out float worldMaxX,
		out float worldMaxY )
	{
		worldMinX = 0f;
		worldMinY = 0f;
		worldMaxX = 0f;
		worldMaxY = 0f;

		if ( coords.Count == 0 || chunkSize <= 0 )
			return false;

		var minX = coords[0].X;
		var maxX = coords[0].X;
		var minY = coords[0].Y;
		var maxY = coords[0].Y;

		for ( var i = 1; i < coords.Count; i++ )
		{
			var coord = coords[i];
			minX = Math.Min( minX, coord.X );
			maxX = Math.Max( maxX, coord.X );
			minY = Math.Min( minY, coord.Y );
			maxY = Math.Max( maxY, coord.Y );
		}

		worldMinX = minX * chunkSize;
		worldMinY = minY * chunkSize;
		worldMaxX = (maxX + 1) * chunkSize;
		worldMaxY = (maxY + 1) * chunkSize;
		return true;
	}

	void DrawChunkFill(
		Rect panelRect,
		Vector2 mapWorldMin,
		Vector2 mapWorldSize,
		ChunkCoord coord,
		int chunkSize,
		Color fill )
	{
		var worldMinX = coord.X * chunkSize;
		var worldMinY = coord.Y * chunkSize;
		var worldMaxX = worldMinX + chunkSize;
		var worldMaxY = worldMinY + chunkSize;

		DrawWorldRectOutline(
			panelRect,
			mapWorldMin,
			mapWorldSize,
			worldMinX,
			worldMinY,
			worldMaxX,
			worldMaxY,
			Color.Transparent,
			0f,
			fill );
	}

	void DrawWorldRectOutline(
		Rect panelRect,
		Vector2 mapWorldMin,
		Vector2 mapWorldSize,
		float worldMinX,
		float worldMinY,
		float worldMaxX,
		float worldMaxY,
		Color border,
		float borderWidth,
		Color? fill = null )
	{
		if ( !TryWorldRectToScreenRect(
			panelRect,
			mapWorldMin,
			mapWorldSize,
			worldMinX,
			worldMinY,
			worldMaxX,
			worldMaxY,
			out var screenRect ) )
		{
			return;
		}

		if ( fill.HasValue && screenRect.Width >= 1f && screenRect.Height >= 1f )
		{
			Gizmo.Draw.ScreenRect(
				screenRect,
				fill.Value,
				Vector4.Zero,
				Color.Transparent,
				Vector4.Zero,
				BlendMode.Normal );
		}

		if ( borderWidth > 0f )
		{
			Gizmo.Draw.ScreenRect(
				screenRect,
				Color.Transparent,
				Vector4.Zero,
				border,
				new Vector4( borderWidth ),
				BlendMode.Normal );
		}
	}

	bool TryWorldRectToScreenRect(
		Rect panelRect,
		Vector2 mapWorldMin,
		Vector2 mapWorldSize,
		float worldMinX,
		float worldMinY,
		float worldMaxX,
		float worldMaxY,
		out Rect screenRect )
	{
		screenRect = default;

		if ( mapWorldSize.x <= 0f || mapWorldSize.y <= 0f )
			return false;

		var clippedMinX = MathF.Max( worldMinX, mapWorldMin.x );
		var clippedMinY = MathF.Max( worldMinY, mapWorldMin.y );
		var clippedMaxX = MathF.Min( worldMaxX, mapWorldMin.x + mapWorldSize.x );
		var clippedMaxY = MathF.Min( worldMaxY, mapWorldMin.y + mapWorldSize.y );

		if ( clippedMaxX <= clippedMinX || clippedMaxY <= clippedMinY )
			return false;

		var bottomLeft = WorldToMapUv( clippedMinX, clippedMinY, mapWorldMin, mapWorldSize );
		var topRight = WorldToMapUv( clippedMaxX, clippedMaxY, mapWorldMin, mapWorldSize );

		var left = panelRect.Left + MathF.Min( bottomLeft.x, topRight.x ) * panelRect.Width;
		var right = panelRect.Left + MathF.Max( bottomLeft.x, topRight.x ) * panelRect.Width;
		var top = panelRect.Top + MathF.Min( bottomLeft.y, topRight.y ) * panelRect.Height;
		var bottom = panelRect.Top + MathF.Max( bottomLeft.y, topRight.y ) * panelRect.Height;

		screenRect = Rect.FromPoints( new Vector2( left, top ), new Vector2( right, bottom ) );
		return screenRect.Width >= 0.5f && screenRect.Height >= 0.5f;
	}

	bool TryGetMapWorldBounds( out Vector2 worldMin, out Vector2 worldSize )
	{
		if ( _sampleWorldSize.x > 0f && _sampleWorldSize.y > 0f )
		{
			worldMin = _rebuildWorldMin;
			worldSize = _sampleWorldSize;
			return true;
		}

		if ( WorldManager.IsValid() )
		{
			worldMin = WorldManager.WorldMin;
			worldSize = WorldManager.WorldSize;
			return worldSize.x > 0f && worldSize.y > 0f;
		}

		worldMin = default;
		worldSize = default;
		return false;
	}

	static Vector2 WorldToMapUv( float worldX, float worldY, Vector2 mapWorldMin, Vector2 mapWorldSize )
	{
		var uv = WorldToMapUvExact( worldX, worldY, mapWorldMin, mapWorldSize );
		return new Vector2( uv.x.Clamp( 0f, 1f ), uv.y.Clamp( 0f, 1f ) );
	}

	static Vector2 WorldToMapUvExact( float worldX, float worldY, Vector2 mapWorldMin, Vector2 mapWorldSize )
	{
		return new Vector2(
			1f - (worldX - mapWorldMin.x) / mapWorldSize.x,
			(worldY - mapWorldMin.y) / mapWorldSize.y );
	}

	bool TryGetEditorCameraPosition( out Vector3 position )
	{
		if ( ChunkStreamerComponent.TryGetEditorViewportPosition( out position ) )
			return true;

		ResolveChunkStreamer();

		if ( ChunkStreamer.IsValid() && ChunkStreamer.TryGetStreamWorldPosition( out position ) )
			return true;

		if ( Scene is not null && Scene.Camera.IsValid() )
		{
			position = Scene.Camera.WorldPosition;
			return true;
		}

		position = default;
		return false;
	}

	static void SetPixel( byte[] data, int x, int y, int size, Color color )
	{
		var row = size - 1 - y;
		var index = (x + (row * size)) * 4;
		data[index] = GetByte( color.r );
		data[index + 1] = GetByte( color.g );
		data[index + 2] = GetByte( color.b );
		data[index + 3] = byte.MaxValue;
	}

	static byte GetByte( float value )
	{
		return (byte)MathF.Floor( value >= 1f ? 255f : value * 256f );
	}

	static float SampleSlope( float[,] heights, int x, int y, int size, float stepX, float stepY )
	{
		var left = heights[Math.Max( x - 1, 0 ), y];
		var right = heights[Math.Min( x + 1, size - 1 ), y];
		var down = heights[x, Math.Max( y - 1, 0 )];
		var up = heights[x, Math.Min( y + 1, size - 1 )];
		var dx = (right - left) / (2f * stepX );
		var dy = (up - down) / (2f * stepY );
		return MathF.Sqrt( dx * dx + dy * dy );
	}
}
