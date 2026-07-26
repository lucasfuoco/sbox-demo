using Sandbox.Audio;
using Sandbox.Engine.Settings;
using Sandbox.Video;

namespace Sandbox;

public class GameSettings
{
	[Title( "Quality" ), Description( "Overall graphics preset. Auto-detected once from your hardware, then yours to change." ), Group( "Video" ), Icon( "high_quality" )]
	public VideoQualityTier VideoQuality { get; set; } = VideoQualityTier.Medium;

	[Title( "VSync" ), Description( "Limit frame rate to the display refresh rate." ), Group( "Video" ), Icon( "tv" )]
	public bool VSync { get; set; } = true;

	[Title( "Max Frame Rate" ), Description( "0 = uncapped (still respects VSync when enabled)." ), Group( "Video" ), Icon( "speed" ), Range( 0, 360, 1 )]
	public int MaxFrameRate { get; set; } = 120;

	[Title( "Shadows" ), Group( "Video" ), Icon( "wb_shade" )]
	public ShadowQuality ShadowQuality { get; set; } = ShadowQuality.Medium;

	[Title( "Textures" ), Group( "Video" ), Icon( "texture" )]
	public TextureQuality TextureQuality { get; set; } = TextureQuality.Medium;

	[Title( "Post Processing" ), Group( "Video" ), Icon( "auto_awesome" )]
	public PostProcessQuality PostProcessQuality { get; set; } = PostProcessQuality.Medium;

	[Title( "Volumetric Fog" ), Group( "Video" ), Icon( "foggy" )]
	public VolumetricFogQuality VolumetricFogQuality { get; set; } = VolumetricFogQuality.Medium;

	/// <summary>True after the first auto-detect or after the player saves a Video choice. Not shown in UI.</summary>
	public bool HasChosenVideoQuality { get; set; }

	[Title( "Field Of View" ), Description( "Effects the camera's vision." ), Group( "Game" ), Icon( "grid_view" ), Range( 65, 110, 1 )]
	public float FieldOfView { get; set; } = 85;

	[Title( "Master" ), Description( "The overall volume" ), Group( "Volume" ), Icon( "grid_view" ), Range( 0, 100, 5 )]
	public float MasterVolume { get; set; } = 100;

	[Title( "Music" ), Description( "How loud any music will play" ), Group( "Volume" ), Icon( "grid_view" ), Range( 0, 100, 5 )]
	public float MusicVolume { get; set; } = 100;

	[Title( "SFX" ), Description( "Most effects in the game" ), Group( "Volume" ), Icon( "grid_view" ), Range( 0, 100, 5 )]
	public float SFXVolume { get; set; } = 100;

	[Title( "UI" ), Description( "interface sounds" ), Group( "Volume" ), Icon( "grid_view" ), Range( 0, 100, 5 )]
	public float UIVolume { get; set; } = 100;

	[Title( "Radio" ), Description( "" ), Group( "Volume" ), Icon( "grid_view" ), Range( 0, 100, 5 )]
	public float RadioVolume { get; set; } = 100;

	[Title( "Voice" ), Description( "" ), Group( "Volume" ), Icon( "grid_view" ), Range( 0, 100, 5 )]
	public float VoiceVolume { get; set; } = 100;

	[Title( "View Bob" ), Group( "Game" ), Range( 0, 100, 5f )]
	public float ViewBob { get; set; } = 100f;

	[Title( "Show Dot" ), Group( "Crosshair" )]
	public bool ShowCrosshairDot { get; set; } = true;

	[Title( "Dynamic" ), Group( "Crosshair" )]
	public bool DynamicCrosshair { get; set; } = true;

	[Title( "Length" ), Group( "Crosshair" ), Range( 2, 50, 1 )]
	public float CrosshairLength { get; set; } = 10;

	[Title( "Width" ), Group( "Crosshair" ), Range( 1, 10, 1 )]
	public float CrosshairWidth { get; set; } = 2;

	[Title( "Distance" ), Group( "Crosshair" ), Range( -5, 50, 0.1f )]
	public float CrosshairDistance { get; set; } = 15;

	[Title( "Color" ), Group( "Crosshair" )]
	public Color CrosshairColor { get; set; } = Color.White;
}

public partial class GameSettingsSystem
{
	private static GameSettings current { get; set; }
	static GraphicsCapabilitySnapshot? _cachedCapabilities;

	public static GameSettings Current
	{
		get
		{
			if ( current is null ) Load();
			return current;
		}
		set
		{
			current = value;
		}
	}

	public static string FilePath => "gamesettings.json";


	public static GraphicsCapabilitySnapshot Capabilities
	{
		get
		{
			_cachedCapabilities ??= GraphicsCapabilityDetector.Detect();
			return _cachedCapabilities.Value;
		}
	}

	public static VideoQualityTier RecommendedVideoQuality => Capabilities.RecommendedTier;

	public static void Save()
	{
		Current.HasChosenVideoQuality = true;
		ApplyVolumes();
		ApplyVideo();
		FileSystem.Data.WriteJson( FilePath, Current );
	}

	public static void Load()
	{
		Current = FileSystem.Data.ReadJson<GameSettings>( FilePath, new() );
		EnsureVideoQualityChosen();
		ApplyVolumes();
		ApplyVideo();
	}

	/// <summary>
	/// Copy a quality profile into Video settings and apply it.
	/// </summary>
	public static void ApplyRecommendedVideoQuality( bool persist = true )
	{
		ApplyVideoPreset( RecommendedVideoQuality, persist );
	}

	public static void ApplyVideoPreset( VideoQualityTier tier, bool persist = true )
	{
		_ = Current;
		CopyPresetToSettings( tier );
		Current.HasChosenVideoQuality = true;
		ApplyVideo();

		if ( persist )
			FileSystem.Data.WriteJson( FilePath, Current );
	}

	public static void ApplyVideo()
	{
		var settings = Current;
		var profile = GraphicsQualityProfile.For( settings.VideoQuality );
		GraphicsQualityApplicator.Apply( profile, settings );

		var caps = Capabilities;
		Log.Info(
			$"[Video] {caps.GpuName} | VRAM {caps.GpuMemoryGb:0.0}GB | " +
			$"recommended {caps.RecommendedTier} | chosen {settings.VideoQuality}" );
	}

	static void EnsureVideoQualityChosen()
	{
		if ( Current.HasChosenVideoQuality )
			return;

		CopyPresetToSettings( RecommendedVideoQuality );
		Current.HasChosenVideoQuality = true;
		FileSystem.Data.WriteJson( FilePath, Current );
	}

	static void CopyPresetToSettings( VideoQualityTier tier )
	{
		var profile = GraphicsQualityProfile.For( tier );
		Current.VideoQuality = tier;
		Current.VSync = profile.VSync;
		Current.MaxFrameRate = profile.MaxFrameRate;
		Current.ShadowQuality = profile.ShadowQuality;
		Current.TextureQuality = profile.TextureQuality;
		Current.PostProcessQuality = profile.PostProcessQuality;
		Current.VolumetricFogQuality = profile.VolumetricFogQuality;
	}

	static void ApplyVolumes()
	{
		if ( Mixer.Master is not null )
			Mixer.Master.Volume = Current.MasterVolume / 100;

		SetMixerVolume( "Music", Current.MusicVolume );
		SetMixerVolume( "Game", Current.SFXVolume );
		SetMixerVolume( "SFX", Current.SFXVolume );
		SetMixerVolume( "ui", Current.UIVolume );
		SetMixerVolume( "UI", Current.UIVolume );
		SetMixerVolume( "Radio", Current.RadioVolume );
		SetMixerVolume( "voice", Current.VoiceVolume );
		SetMixerVolume( "Voice", Current.VoiceVolume );
	}

	static void SetMixerVolume( string name, float volumePercent )
	{
		var mixer = Mixer.FindMixerByName( name );
		if ( mixer is not null )
			mixer.Volume = volumePercent / 100;
	}
}
