using Sandbox.Components.SingletonComponents;

namespace Sandbox.Components;

[Title( "World Map Preview" ), Category( "Terrain" ), Icon( "map" )]
public sealed class WorldMapPreviewComponent : Component, Component.ExecuteInEditor
{
	[Property, Group( "Map" ), Title( "World Manager" )]
	public WorldManagerSingletonComponent WorldManager { get; set; }

	[Property, Group( "Map" ), Title( "Resolution" ), Range( 128, 2048 )]
	public int MapResolution { get; set; } = 512;

	[Property, Group( "Map" ), Title( "Panel Size" ), Range( 128, 1024 )]
	public float PanelSize { get; set; } = 360f;

	[Property, Group( "Map" ), Title( "Panel Margin" ), Range( 0, 128 )]
	public float PanelMargin { get; set; } = 16f;

	[Property, Group( "Map" ), Title( "Show Camera Marker" )]
	public bool ShowCameraMarker { get; set; } = true;

	Texture MapTexture { get; set; }

	int _settingsHash = -1;
	TimeUntil _rebuildDelay;
	Vector2 _cameraUv = new( -1f, -1f );

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

		var settingsHash = ComputeSettingsHash();
		if ( settingsHash != _settingsHash )
		{
			_settingsHash = settingsHash;
			ScheduleRebuild( WorldManager.EditorRebuildDelay );
		}

		if ( _rebuildDelay )
			RebuildMap();

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

	Rect GetPanelRect()
	{
		var size = PanelSize.Clamp( 128f, 1024f );
		var margin = PanelMargin.Clamp( 0f, 128f );
		var left = Screen.Size.x - margin - size;
		var top = Screen.Size.y - margin - size;
		return new Rect( left, top, size, size );
	}

	void ResolveWorldManager()
	{
		if ( WorldManager.IsValid() )
			return;

		WorldManager = WorldManagerSingletonComponent.Instance;
	}

	void ScheduleRebuild( float delay )
	{
		_rebuildDelay = Math.Max( delay, 0.05f );
	}

	int ComputeSettingsHash()
	{
		var worldManager = WorldManager;
		if ( !worldManager.IsValid() )
			return 0;

		var noiseHash = HashCode.Combine(
			worldManager.NoiseSettingsVersion,
			MapResolution,
			worldManager.WorldSeed,
			worldManager.WorldSize,
			worldManager.GameObject.WorldPosition );

		var terrainHash = HashCode.Combine(
			worldManager.WaterLevel,
			worldManager.HeightNoiseAmplitude,
			worldManager.UseWorldBounds,
			worldManager.UseRadialFalloff,
			worldManager.FalloffMin,
			worldManager.FalloffMax,
			worldManager.FalloffInnerMargin,
			worldManager.FalloffOuterMargin );

		var falloffHash = HashCode.Combine(
			worldManager.FalloffPower,
			worldManager.FalloffCenter,
			worldManager.WaterMinThreshold,
			worldManager.WaterMaxThreshold,
			worldManager.SandMinThreshold,
			worldManager.SandMaxThreshold,
			worldManager.GrassMinThreshold,
			worldManager.GrassMaxThreshold );

		var biomeHash = HashCode.Combine(
			worldManager.MountainMinThreshold,
			worldManager.MountainMaxThreshold,
			worldManager.SharpSlopeThreshold,
			worldManager.WaterColor,
			worldManager.SandColor,
			worldManager.GrassColor,
			worldManager.MountainColor );

		var panelHash = HashCode.Combine( PanelSize, PanelMargin, ShowCameraMarker );

		return HashCode.Combine( noiseHash, terrainHash, falloffHash, biomeHash, panelHash );
	}

	void RebuildMap()
	{
		if ( !WorldManager.IsValid() )
			return;

		var size = Math.Clamp( MapResolution, 128, 2048 );
		var data = new byte[size * size * 4];
		var worldMin = WorldManager.WorldMin;
		var worldSize = WorldManager.WorldSize;
		var stepX = worldSize.x / Math.Max( size - 1, 1 );
		var stepY = worldSize.y / Math.Max( size - 1, 1 );
		var heights = new float[size, size];

		for ( int y = 0; y < size; y++ )
		{
			for ( int x = 0; x < size; x++ )
			{
				var worldX = worldMin.x + x * stepX;
				var worldY = worldMin.y + y * stepY;
				heights[x, y] = WorldManager.GetHeight( worldX, worldY );
			}
		}

		for ( int y = 0; y < size; y++ )
		{
			for ( int x = 0; x < size; x++ )
			{
				var slope = SampleSlope( heights, x, y, size, stepX, stepY );
				var color = TerrainBiome.GetColorFromHeight( WorldManager, heights[x, y], slope );
				SetPixel( data, x, y, size, color );
			}
		}

		MapTexture = Texture.Create( size, size )
			.WithStaticUsage()
			.WithData( data )
			.Finish();
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
