using System;
using Sandbox.Ocean;
using Sandbox.Components;
using Sandbox.Renderers;

namespace Sandbox.GameObjectSystems;

/// <summary>
/// GodotOceanWaves FFT simulation owner. Binds displacement/normal atlases onto OceanSurfaceRenderer.
/// </summary>
[Title( "Ocean FFT Manager" )]
public sealed class OceanFftManager : GameObjectSystem<OceanFftManager>
{
	[Property( Title = "Enable Ocean FFT" ), Group( "Ocean FFT" )]
	public bool EnableOceanFft { get; set; } = true;

	[Property( Title = "Ocean FFT Profile" ), Group( "Ocean FFT" )]
	public OceanFftDefinition OceanFftProfile { get; set; }

	[Property( Title = "Enable Sea Spray" ), Group( "Ocean FFT" )]
	public bool EnableSeaSpray { get; set; } = true;

	OceanFftGenerator _generator;
	OceanFftDefinition _runtimeProfile;
	bool _loggedMissing;
	GameObject _seaSprayObject;
	OceanFftSeaSprayRendererComponent _seaSpray;

	public bool IsOceanFftActive => EnableOceanFft && _generator is { IsReady: true } && ResolveProfile() is not null;
	public OceanFftGenerator Generator => _generator;

	public float SeaSprayIntensity
	{
		get
		{
			if ( !IsOceanFftActive )
				return 0f;

			var profile = ResolveProfile();
			if ( profile?.Cascades is null || profile.Cascades.Count == 0 )
				return 0f;

			var foam = 0f;
			foreach ( var c in profile.Cascades )
				foam += c.FoamAmount;

			return MathX.Clamp( foam / (profile.Cascades.Count * 8f), 0f, 1f );
		}
	}

	public OceanFftManager( Scene scene ) : base( scene )
	{
		Listen( Stage.StartUpdate, 0, OnUpdate, "OceanFftManagerUpdate" );
	}

	public override void Dispose()
	{
		DestroySeaSpray();
		_generator?.Dispose();
		_generator = null;
		base.Dispose();
	}

	public OceanFftDefinition ResolveProfile()
	{
		if ( OceanFftProfile is not null && OceanFftProfile.HasCascades )
			return OceanFftProfile;

		var loaded = TryLoadProfile( "resources/water/ocean.fftwater" )
			?? TryLoadProfile( "resources/ocean.fftwater" );

		if ( loaded is not null && loaded.HasCascades )
		{
			OceanFftProfile = loaded;
			return loaded;
		}

		_runtimeProfile ??= OceanFftDefinition.CreateRuntimeDefault();
		if ( !_loggedMissing )
		{
			_loggedMissing = true;
			Log.Warning( "[OceanFft] Profile missing — using GodotOceanWaves defaults." );
		}

		return _runtimeProfile;
	}

	public void BindToRenderer( OceanSurfaceRenderer renderer )
	{
		if ( !renderer.IsValid() )
			return;

		var profile = ResolveProfile();
		var ready = EnableOceanFft && _generator is { IsReady: true } && profile is { HasCascades: true };

		if ( ready )
			_generator.ApplyTo( renderer.DrawAttributes, profile );
		else
			renderer.DrawAttributes.Set( "UseOceanFft", 0 );

		if ( renderer.Material.IsValid() )
		{
			if ( ready )
				_generator.ApplyTo( renderer.Material, profile );
			else
				renderer.Material.Attributes.Set( "UseOceanFft", 0 );
		}
	}

	static OceanFftDefinition TryLoadProfile( string path )
	{
		var fromLibrary = ResourceLibrary.Get<OceanFftDefinition>( path );
		if ( fromLibrary is not null )
		{
			if ( fromLibrary.Cascades is null || fromLibrary.Cascades.Count == 0 )
				fromLibrary.Cascades = OceanFftDefinition.CreateDefaultCascades();
			return fromLibrary;
		}

		if ( !FileSystem.Mounted.FileExists( path ) )
			return null;

		try
		{
			var json = FileSystem.Mounted.ReadAllText( path );
			var def = new OceanFftDefinition();
			def.Deserialize( Json.ParseToJsonObject( json ) );
			if ( def.Cascades is null || def.Cascades.Count == 0 )
				def.Cascades = OceanFftDefinition.CreateDefaultCascades();
			return def.HasCascades ? def : null;
		}
		catch ( Exception e )
		{
			Log.Warning( $"[OceanFft] Failed to read '{path}': {e.Message}" );
			return null;
		}
	}

	void OnUpdate()
	{
		if ( Application.IsDedicatedServer )
			return;

		if ( !EnableOceanFft )
		{
			DestroySeaSpray();
			return;
		}

		var profile = ResolveProfile();
		if ( profile is null || !profile.HasCascades )
			return;

		try
		{
			_generator ??= new OceanFftGenerator();
			_generator.Update( Time.Delta, profile );
		}
		catch ( Exception e )
		{
			if ( !_loggedMissing )
			{
				_loggedMissing = true;
				Log.Warning( $"[OceanFft] Update failed: {e.Message}" );
			}
		}

		UpdateSeaSpray();
	}

	void UpdateSeaSpray()
	{
		if ( !EnableSeaSpray || !IsOceanFftActive )
		{
			DestroySeaSpray();
			return;
		}

		if ( !_seaSpray.IsValid() )
		{
			_seaSprayObject = new GameObject( true, "Ocean FFT Sea Spray" );
			_seaSprayObject.Flags |= GameObjectFlags.NotSaved;
			_seaSprayObject.Tags.Add( "particles" );
			_seaSpray = _seaSprayObject.Components.Create<OceanFftSeaSprayRendererComponent>();
		}

		var camera = Scene.Camera;
		var camPos = camera.IsValid()
			? camera.WorldPosition
			: (Application.IsEditor && Application.Editor.Camera.IsValid()
				? Application.Editor.Camera.WorldPosition
				: Vector3.Zero);

		_seaSpray.UpdateSpray( camPos, SeaSprayIntensity );
	}

	void DestroySeaSpray()
	{
		_seaSpray = null;
		if ( _seaSprayObject.IsValid() )
			_seaSprayObject.Destroy();
		_seaSprayObject = null;
	}
}
