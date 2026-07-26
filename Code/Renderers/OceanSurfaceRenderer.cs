using System;
using Sandbox.GameObjectSystems;
using Sandbox.Rendering;
using RenderStage = Sandbox.Rendering.Stage;

namespace Sandbox.Renderers;

/// <summary>
/// GodotOceanWaves-style ocean surface: camera clipmap + FFT displacement via realistic_water.
/// Fully owned by the game — no WaterTool dependency.
/// </summary>
[Title( "Ocean Surface Renderer" ), Category( "Water" ), Icon( "waves" )]
public sealed class OceanSurfaceRenderer : Component, Component.ExecuteInEditor, Component.DontExecuteOnServer
{
	struct OceanVertex
	{
		[VertexLayout.Position] public Vector3 Position;
		[VertexLayout.Normal] public Vector3 Normal;
		[VertexLayout.Tangent] public Vector4 Tangent;
		[VertexLayout.TexCoord] public Vector2 TexCoord;
		[VertexLayout.Color] public Color Color;
	}

	const float BaseTileSize = 100f;
	const int MaxRings = 8;

	[Property, Group( "General" )] public Material Material { get; set; }
	[Property, Group( "General" )] public float Width { get; set; } = 1_000_000f;
	[Property, Group( "General" )] public float Length { get; set; } = 1_000_000f;
	[Property, Group( "General" )] public float Depth { get; set; } = 450f;
	[Property, Group( "Clipmap" )] public float BaseCellSize { get; set; } = 8f;
	[Property, Group( "Clipmap" ), Range( 16, 256 )] public int CellsPerRing { get; set; } = 64;
	[Property, Group( "Clipmap" )] public bool FollowCameraForClipmap { get; set; } = true;
	[Property, Group( "Texture" ), Range( 0.1f, 2f )] public float TextureTilingMultiplier { get; set; } = 1f;

	readonly RenderAttributes _drawAttributes = new();
	readonly ComputeShader _clipmapShader = new( "water_clipmap_cs" );
	readonly int[] _snapCellsX = new int[MaxRings];
	readonly int[] _snapCellsY = new int[MaxRings];

	// Double-buffered command lists (WaterManager pattern): build into the disabled back
	// list on the main thread; the camera executes the enabled front list on the render thread.
	CommandList _front = new( "Ocean Surface A" ) { Enabled = true };
	CommandList _back = new( "Ocean Surface B" ) { Enabled = false };
	CameraComponent _boundSceneCamera;
	CameraComponent _boundEditorCamera;

	GpuBuffer<OceanVertex> _vertexBuffer;
	GpuBuffer<uint> _indexBuffer;
	uint[] _indexScratch = Array.Empty<uint>();
	int _totalIndexCount;
	int _lastConfigHash;
	int _lastStaticAttributeHash;
	int _lastSnapHash;
	int _lastBoundsHash;
	BBox _cachedBounds;
	bool _commandListDirty = true;
	bool _loggedReady;

	int VerticesPerRing => (CellsPerRing + 1) * (CellsPerRing + 1);
	float OuterExtent => CellsPerRing * BaseCellSize * (1 << (ComputeRingCount() - 1));
	bool CanRender => Active && Material.IsValid();

	public RenderAttributes DrawAttributes => _drawAttributes;

	protected override void OnEnabled()
	{
		_commandListDirty = true;
		_lastStaticAttributeHash = 0;
		_lastSnapHash = 0;
		_lastBoundsHash = 0;
		if ( CanRender )
			CreateBuffers();
	}

	protected override void OnDisabled()
	{
		UnbindCameras();
		_vertexBuffer = default;
		_indexBuffer = default;
		_commandListDirty = true;
	}

	protected override void OnDestroy()
	{
		UnbindCameras();
	}

	protected override void OnUpdate()
	{
		if ( !CanRender )
			return;

		var hash = HashCode.Combine( Width, Length, BaseCellSize, CellsPerRing );
		if ( !_vertexBuffer.IsValid() || hash != _lastConfigHash )
		{
			CreateBuffers();
			_lastConfigHash = hash;
			_commandListDirty = true;
			_lastStaticAttributeHash = 0;
			_lastSnapHash = 0;
		}

		UpdateStaticDrawAttributes();
		UpdateDynamicDrawAttributes();
		OceanFftManager.Current?.BindToRenderer( this );

		var cameraPos = GetClipmapCameraPosition();
		var snapHash = HashCode.Combine( ComputeSnapHash( cameraPos ), WorldPosition.z.GetHashCode(), _lastBoundsHash );
		if ( snapHash != _lastSnapHash )
		{
			_lastSnapHash = snapHash;
			_commandListDirty = true;
		}

		BindCameras();
		if ( _commandListDirty )
			BuildCommandList( cameraPos );
	}

	/// <summary>
	/// Clipmap snap follows the view you're looking through — editor free-cam when not playing.
	/// </summary>
	Vector3 GetClipmapCameraPosition()
	{
		if ( Game.IsPlaying && Scene.Camera.IsValid() )
			return Scene.Camera.WorldPosition;

		if ( Application.IsEditor && Application.Editor.Camera.IsValid() )
			return Application.Editor.Camera.WorldPosition;

		return Scene.Camera.IsValid() ? Scene.Camera.WorldPosition : WorldPosition;
	}

	/// <summary>
	/// Attach to both the scene camera (play) and editor camera (viewport). WaterTool only
	/// used Scene.Camera; binding only that one leaves the editor viewport empty.
	/// </summary>
	void BindCameras()
	{
		AttachToCamera( Scene.Camera, ref _boundSceneCamera );

		if ( Application.IsEditor && Application.Editor.Camera.IsValid()
			&& Application.Editor.Camera != Scene.Camera )
		{
			AttachToCamera( Application.Editor.Camera, ref _boundEditorCamera );
		}
		else if ( _boundEditorCamera.IsValid() && _boundEditorCamera != _boundSceneCamera )
		{
			_boundEditorCamera.RemoveCommandList( _front );
			_boundEditorCamera.RemoveCommandList( _back );
			_boundEditorCamera = null;
		}
	}

	void AttachToCamera( CameraComponent camera, ref CameraComponent bound )
	{
		if ( camera == bound )
			return;

		if ( bound.IsValid() )
		{
			bound.RemoveCommandList( _front );
			bound.RemoveCommandList( _back );
		}

		bound = null;
		if ( !camera.IsValid() )
			return;

		camera.AddCommandList( _front, RenderStage.AfterTransparent );
		camera.AddCommandList( _back, RenderStage.AfterTransparent );
		bound = camera;
		_commandListDirty = true;
	}

	void UnbindCameras()
	{
		if ( _boundSceneCamera.IsValid() )
		{
			_boundSceneCamera.RemoveCommandList( _front );
			_boundSceneCamera.RemoveCommandList( _back );
		}

		if ( _boundEditorCamera.IsValid() && _boundEditorCamera != _boundSceneCamera )
		{
			_boundEditorCamera.RemoveCommandList( _front );
			_boundEditorCamera.RemoveCommandList( _back );
		}

		_boundSceneCamera = null;
		_boundEditorCamera = null;
	}

	void UpdateStaticDrawAttributes()
	{
		var bounds = GetWorldBounds2D();
		var staticHash = HashCode.Combine(
			HashCode.Combine( bounds.Mins.x, bounds.Mins.y, bounds.Maxs.x, bounds.Maxs.y ),
			HashCode.Combine( Depth, OuterExtent, TextureTilingMultiplier, CellsPerRing ),
			BaseCellSize );
		if ( staticHash == _lastStaticAttributeHash )
			return;

		_lastStaticAttributeHash = staticHash;

		// Infinite ocean without WaterBody inclusion volumes: clip to world OBB only.
		_drawAttributes.Set( "RequireWaterInclusionVolumes", 0 );
		_drawAttributes.Set( "UseHybridInclusionBounds", 1 );
		_drawAttributes.Set( "HybridInclusionBoundsMin", new Vector2( bounds.Mins.x, bounds.Mins.y ) );
		_drawAttributes.Set( "HybridInclusionBoundsMax", new Vector2( bounds.Maxs.x, bounds.Maxs.y ) );
		_drawAttributes.Set( "WaterInclusionVolumeCount", 0 );
		_drawAttributes.Set( "WaterExclusionVolumeCount", 0 );
		_drawAttributes.Set( "WaterHullExclusionCount", 0 );
		_drawAttributes.Set( "DepthMax", Depth );
		_drawAttributes.Set( "RippleCount", 0 );

		var tiling = (OuterExtent / BaseTileSize) * TextureTilingMultiplier;
		_drawAttributes.Set( "NormalTiling", new Vector2( tiling, tiling ) );
		_drawAttributes.Set( "WaveNormalEpsScale", 3f / CellsPerRing );
		_drawAttributes.Set( "WaveNormalEpsMin", BaseCellSize );

		// Zero Gerstner — FFT owns displacement when Ocean FFT Manager binds UseOceanFft.
		_drawAttributes.Set( "WavesIntensity", 0f );
		_drawAttributes.Set( "SwellIntensity", 0f );

		if ( Material.IsValid() )
		{
			Material.Attributes.Set( "RequireWaterInclusionVolumes", 0 );
			Material.Attributes.Set( "WaterInclusionVolumeCount", 0 );
			Material.Attributes.Set( "WaterExclusionVolumeCount", 0 );
			Material.Attributes.Set( "WaterHullExclusionCount", 0 );
		}
	}

	void UpdateDynamicDrawAttributes()
	{
		_drawAttributes.Set( "WaterTime", Time.Now );
	}

	int ComputeSnapHash( Vector3 cameraPosition )
	{
		var rings = ComputeRingCount();
		var hash = rings;
		var anchor = FollowCameraForClipmap ? cameraPosition : WorldPosition;

		for ( var ring = 0; ring < rings; ring++ )
		{
			var cellSize = BaseCellSize * (1 << ring);
			var cellX = (int)MathF.Floor( anchor.x / cellSize );
			var cellY = (int)MathF.Floor( anchor.y / cellSize );
			_snapCellsX[ring] = cellX;
			_snapCellsY[ring] = cellY;
			hash = HashCode.Combine( hash, cellX, cellY );
		}

		return hash;
	}

	void BuildCommandList( Vector3 cameraPosition )
	{
		var cl = _back;
		cl.Reset();

		if ( !_vertexBuffer.IsValid() || !_indexBuffer.IsValid() || _totalIndexCount <= 0 )
			return;

		var rings = ComputeRingCount();
		var vertsPerRing = VerticesPerRing;
		var bounds = GetWorldBounds2D();

		for ( var ring = 0; ring < rings; ring++ )
		{
			var cellSize = BaseCellSize * (1 << ring);
			var snapX = _snapCellsX[ring] * cellSize;
			var snapY = _snapCellsY[ring] * cellSize;

			cl.Attributes.Set( "VertexBuffer", _vertexBuffer );
			cl.Attributes.Set( "VertexOffset", ring * vertsPerRing );
			cl.Attributes.Set( "GridWidth", CellsPerRing );
			cl.Attributes.Set( "CellSize", cellSize );
			cl.Attributes.Set( "SnapPosition", new Vector2( snapX, snapY ) );
			cl.Attributes.Set( "WaterZ", WorldPosition.z );
			cl.Attributes.Set( "TilingScale", 1f / OuterExtent );
			cl.Attributes.Set( "ClampToBounds", false );
			cl.Attributes.Set( "BoundsMin", new Vector2( bounds.Mins.x, bounds.Mins.y ) );
			cl.Attributes.Set( "BoundsMax", new Vector2( bounds.Maxs.x, bounds.Maxs.y ) );
			cl.DispatchCompute( _clipmapShader, vertsPerRing, 1, 1 );
		}

		cl.ResourceBarrierTransition( _vertexBuffer, ResourceState.UnorderedAccess, ResourceState.VertexOrIndexBuffer );
		cl.Attributes.GrabFrameTexture( "FrameBufferCopyTexture" );
		cl.DrawIndexed( _vertexBuffer, _indexBuffer, Material, 0, _totalIndexCount, _drawAttributes );

		// Enable new list before disabling old — avoid a one-frame gap (WaterManager).
		_back.Enabled = true;
		_front.Enabled = false;
		(_front, _back) = (_back, _front);
		_commandListDirty = false;

		if ( !_loggedReady )
		{
			_loggedReady = true;
			Log.Info( $"[OceanSurface] Drawing clipmap rings={rings} indices={_totalIndexCount} z={WorldPosition.z:F0} material={Material.Name}" );
		}
	}

	BBox GetWorldBounds2D()
	{
		var boundsHash = HashCode.Combine(
			WorldPosition,
			WorldRotation,
			HashCode.Combine( Width, Length, Depth ) );
		if ( boundsHash == _lastBoundsHash )
			return _cachedBounds;

		_lastBoundsHash = boundsHash;

		var right = WorldRotation.Right * (Length * 0.5f);
		var forward = WorldRotation.Forward * (Width * 0.5f);
		var c0 = WorldPosition + right + forward;
		var c1 = WorldPosition - right + forward;
		var c2 = WorldPosition + right - forward;
		var c3 = WorldPosition - right - forward;

		var minX = MathF.Min( MathF.Min( c0.x, c1.x ), MathF.Min( c2.x, c3.x ) );
		var maxX = MathF.Max( MathF.Max( c0.x, c1.x ), MathF.Max( c2.x, c3.x ) );
		var minY = MathF.Min( MathF.Min( c0.y, c1.y ), MathF.Min( c2.y, c3.y ) );
		var maxY = MathF.Max( MathF.Max( c0.y, c1.y ), MathF.Max( c2.y, c3.y ) );

		_cachedBounds = new BBox(
			new Vector3( minX, minY, WorldPosition.z - Depth ),
			new Vector3( maxX, maxY, WorldPosition.z ) );
		return _cachedBounds;
	}

	int ComputeRingCount()
	{
		var maxDim = MathF.Max( Length, Width );
		var inner = CellsPerRing * BaseCellSize;
		var required = maxDim * 2f;
		if ( required <= inner )
			return 1;

		var rings = (int)MathF.Ceiling( MathF.Log2( required / inner ) ) + 1;
		return Math.Clamp( rings, 1, MaxRings );
	}

	void CreateBuffers()
	{
		var ringCount = ComputeRingCount();
		var n = CellsPerRing;
		var verticesPerRing = VerticesPerRing;
		var innerStart = n / 4 + 1;
		var innerEnd = n * 3 / 4 - 1;
		var innerBlock = innerEnd - innerStart;
		var filled = n * n;
		var hollow = filled - innerBlock * innerBlock;
		var totalIndices = filled * 6 + (ringCount - 1) * hollow * 6;

		_vertexBuffer = new GpuBuffer<OceanVertex>( ringCount * verticesPerRing, GpuBuffer.UsageFlags.Vertex | GpuBuffer.UsageFlags.Structured );
		_indexBuffer = new GpuBuffer<uint>( totalIndices, GpuBuffer.UsageFlags.Index | GpuBuffer.UsageFlags.Structured );

		if ( _indexScratch.Length < totalIndices )
			_indexScratch = new uint[totalIndices];

		var write = 0;
		for ( var ring = 0; ring < ringCount; ring++ )
		{
			var baseVertex = (uint)(ring * verticesPerRing);
			for ( var y = 0; y < n; y++ )
			for ( var x = 0; x < n; x++ )
			{
				if ( ring > 0 && x >= innerStart && x < innerEnd && y >= innerStart && y < innerEnd )
					continue;

				var i0 = baseVertex + (uint)(y * (n + 1) + x);
				var i1 = i0 + 1;
				var i2 = i0 + (uint)(n + 1);
				var i3 = i2 + 1;
				_indexScratch[write++] = i0;
				_indexScratch[write++] = i1;
				_indexScratch[write++] = i2;
				_indexScratch[write++] = i1;
				_indexScratch[write++] = i3;
				_indexScratch[write++] = i2;
			}
		}

		_indexBuffer.SetData( _indexScratch.AsSpan( 0, write ) );
		_totalIndexCount = write;
	}
}
