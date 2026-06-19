using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

[Title( "World Map Preview" ), Category( "Terrain" ), Icon( "map" )]
public sealed class WorldMapPreviewComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Map" ), Title( "World Manager" )]
	public WorldManagerSingletonComponent WorldManager { get; set; }

	[Property, Group( "Map" ), Title( "Resolution" ), Description( "Preview texture size. Lower is faster." ), Range( 128, 1024 )]
	public int MapResolution { get; set; } = 256;

	[Property, Group( "Map" ), Title( "Rows Per Frame" ), Description( "How many map rows to generate per editor frame while rebuilding." ), Range( 4, 128 )]
	public int RowsPerFrame { get; set; } = 24;

	[Property, Group( "Map" ), Title( "Panel Size" ), Range( 128, 1024 )]
	public float PanelSize { get; set; } = 360f;

	[Property, Group( "Map" ), Title( "Panel Margin" ), Range( 0, 128 )]
	public float PanelMargin { get; set; } = 16f;

	[Property, Group( "Map" ), Title( "Show Camera Marker" )]
	public bool ShowCameraMarker { get; set; } = true;

	Texture MapTexture { get; set; }

	int _terrainSettingsVersion = -1;
	int _mapResolution = -1;
	TimeUntil _rebuildDelay;
	Vector2 _cameraUv = new( -1f, -1f );

	bool _rebuildActive;
	int _rebuildSize;
	int _rebuildRow;
	float _rebuildStepX;
	float _rebuildStepY;
	Vector2 _rebuildWorldMin;
	byte[] _rebuildData;
	float[,] _rebuildHeights;

	protected override void OnAwake()
	{
		ResolveWorldManager();
		ScheduleRebuild( 0f );
	}

	protected override void OnUpdate()
	{
		if ( Game.IsPlaying )
			return;

		ResolveWorldManager();

		if ( !WorldManager.IsValid() )
			return;

		if ( NeedsRebuild() )
			ScheduleRebuild( WorldManager.EditorRebuildDelay );

		if ( _rebuildActive )
			ContinueRebuild();
		else if ( _rebuildDelay )
			BeginRebuild();

		UpdateCameraMarker();
	}

	protected override void DrawGizmos()
	{
		if ( Game.IsPlaying || !MapTexture.IsValid() )
			return;

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

			var center = new Vector3( rect.Left + rect.Width * 0.5f, rect.Top + rect.Height * 0.5f, 0f );
			Gizmo.Draw.Sprite( center, new Vector2( rect.Width, rect.Height ), MapTexture, worldspace: false );

			if ( ShowCameraMarker && _cameraUv.x >= 0f )
			{
				var markerSize = 10f;
				var markerX = rect.Left + _cameraUv.x * rect.Width - markerSize * 0.5f;
				var markerY = rect.Top + (1f - _cameraUv.y) * rect.Height - markerSize * 0.5f;
				var markerRect = new Rect( markerX, markerY, markerSize, markerSize );

				Gizmo.Draw.ScreenRect(
					markerRect,
					Color.White,
					new Vector4( markerSize * 0.5f ),
					Color.Black.WithAlpha( 0.8f ),
					new Vector4( 2f ),
					BlendMode.Normal );
			}
		}
	}

	bool NeedsRebuild()
	{
		return WorldManager.TerrainSettingsVersion != _terrainSettingsVersion
			|| MapResolution != _mapResolution;
	}

	void BeginRebuild()
	{
		_rebuildDelay = 0f;

		if ( !WorldManager.IsValid() )
			return;

		_terrainSettingsVersion = WorldManager.TerrainSettingsVersion;
		_mapResolution = MapResolution;

		_rebuildSize = Math.Clamp( MapResolution, 128, 1024 );
		_rebuildRow = 0;
		_rebuildWorldMin = WorldManager.WorldMin;
		var worldSize = WorldManager.WorldSize;
		_rebuildStepX = worldSize.x / Math.Max( _rebuildSize - 1, 1 );
		_rebuildStepY = worldSize.y / Math.Max( _rebuildSize - 1, 1 );
		_rebuildData = new byte[_rebuildSize * _rebuildSize * 4];
		_rebuildHeights = new float[_rebuildSize, _rebuildSize];
		_rebuildActive = true;

		ContinueRebuild();
	}

	void ContinueRebuild()
	{
		if ( !WorldManager.IsValid() || !_rebuildActive )
			return;

		var rowsPerFrame = Math.Clamp( RowsPerFrame, 4, 128 );
		var endRow = Math.Min( _rebuildRow + rowsPerFrame, _rebuildSize );

		for ( int y = _rebuildRow; y < endRow; y++ )
		{
			for ( int x = 0; x < _rebuildSize; x++ )
			{
				var worldX = _rebuildWorldMin.x + x * _rebuildStepX;
				var worldY = _rebuildWorldMin.y + y * _rebuildStepY;
				_rebuildHeights[x, y] = WorldManager.GetHeight( worldX, worldY );
			}
		}

		_rebuildRow = endRow;

		if ( _rebuildRow < _rebuildSize )
			return;

		for ( int y = 0; y < _rebuildSize; y++ )
		{
			for ( int x = 0; x < _rebuildSize; x++ )
			{
				var slope = SampleSlope( _rebuildHeights, x, y, _rebuildSize, _rebuildStepX, _rebuildStepY );
				var color = TerrainBiome.GetColorFromHeight( WorldManager, _rebuildHeights[x, y], slope );
				SetPixel( _rebuildData, x, y, _rebuildSize, color );
			}
		}

		MapTexture = Texture.Create( _rebuildSize, _rebuildSize )
			.WithStaticUsage()
			.WithData( _rebuildData )
			.Finish();

		_rebuildActive = false;
		_rebuildData = null;
		_rebuildHeights = null;
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

	void ScheduleRebuild( float delay )
	{
		_rebuildActive = false;
		_rebuildDelay = Math.Max( delay, 0.05f );
	}

	void UpdateCameraMarker()
	{
		if ( !ShowCameraMarker || !TryGetEditorCameraPosition( out var position ) || !WorldManager.IsValid() )
		{
			_cameraUv = new Vector2( -1f, -1f );
			return;
		}

		var worldMin = WorldManager.WorldMin;
		var worldSize = WorldManager.WorldSize;
		_cameraUv = new Vector2(
			((position.x - worldMin.x) / worldSize.x).Clamp( 0f, 1f ),
			((position.y - worldMin.y) / worldSize.y).Clamp( 0f, 1f ) );
	}

	bool TryGetEditorCameraPosition( out Vector3 position )
	{
		if ( Game.IsEditor )
		{
			position = Gizmo.CameraTransform.Position;
			return true;
		}

		if ( Scene.Camera.IsValid() )
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
