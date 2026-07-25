using System;
using System.Collections.Generic;

namespace Sandbox.Ocean;

/// <summary>
/// GPU FFT ocean spectrum → displacement / normal / foam maps.
/// Pipeline ported from GodotOceanWaves WaveGenerator (MIT).
/// </summary>
public sealed class OceanFftGenerator : IDisposable
{
	public const int MaxMapSize = 256;
	public const int NumSpectra = 4;
	const float Gravity = 9.81f;
	const float Depth = 20f;

	readonly ComputeShader _spectrum;
	readonly ComputeShader _modulate;
	readonly ComputeShader _butterfly;
	readonly ComputeShader _fft;
	readonly ComputeShader _transpose;
	readonly ComputeShader _unpack;

	GpuBuffer<Vector4> _spectrumBuffer;
	GpuBuffer<Vector4> _butterflyBuffer;
	GpuBuffer<Vector4> _fftBuffer;
	GpuBuffer<Vector4> _foamBuffer;

	Texture _displacementAtlas;
	Texture _normalAtlas;

	int _mapSize;
	int _cascadeCapacity;
	int _allocatedCascades;
	bool _butterflyReady;
	bool _warmedUp;
	float _accumTime;
	float _nextUpdateTime;
	int _passRemaining;
	float _unitsPerMeter = 39.3700787f;
	List<OceanFftCascadeParameters> _passCascades = new();
	readonly Random _rng = new( 1234 );

	public bool IsReady => _displacementAtlas is not null && _normalAtlas is not null && _allocatedCascades > 0 && _warmedUp;
	public Texture DisplacementAtlas => _displacementAtlas;
	public Texture NormalAtlas => _normalAtlas;
	public int MapSize => _mapSize;
	public int CascadeCount => _allocatedCascades;

	public OceanFftGenerator()
	{
		_spectrum = new ComputeShader( "ocean_fft_spectrum_cs" );
		_modulate = new ComputeShader( "ocean_fft_modulate_cs" );
		_butterfly = new ComputeShader( "ocean_fft_butterfly_cs" );
		_fft = new ComputeShader( "ocean_fft_compute_cs" );
		_transpose = new ComputeShader( "ocean_fft_transpose_cs" );
		_unpack = new ComputeShader( "ocean_fft_unpack_cs" );
	}

	public void EnsureInitialized( OceanFftDefinition definition )
	{
		if ( definition is null || !definition.HasCascades )
			return;

		_unitsPerMeter = MathF.Max( 0.001f, definition.UnitsPerMeter );

		var mapSize = definition.ResolvedMapSize;
		var cascades = Math.Clamp( definition.Cascades.Count, 1, OceanFftDefinition.MaxCascades );

		if ( _mapSize == mapSize && _cascadeCapacity >= cascades && _displacementAtlas is not null )
		{
			_allocatedCascades = cascades;
			return;
		}

		DisposeGpu();

		_mapSize = mapSize;
		_cascadeCapacity = Math.Max( 2, cascades );
		_allocatedCascades = cascades;
		_warmedUp = false;

		var texels = _mapSize * _mapSize;
		var stages = Log2( _mapSize );

		_spectrumBuffer = new GpuBuffer<Vector4>( _cascadeCapacity * texels, GpuBuffer.UsageFlags.Structured );
		_butterflyBuffer = new GpuBuffer<Vector4>( stages * _mapSize, GpuBuffer.UsageFlags.Structured );
		_fftBuffer = new GpuBuffer<Vector4>( _cascadeCapacity * texels * NumSpectra * 2, GpuBuffer.UsageFlags.Structured );
		_foamBuffer = new GpuBuffer<Vector4>( _cascadeCapacity * texels, GpuBuffer.UsageFlags.Structured );
		_foamBuffer.Clear();

		_displacementAtlas = Texture.Create( _mapSize, _mapSize * _cascadeCapacity, ImageFormat.RGBA16161616F )
			.WithName( "OceanFftDisplacement" )
			.WithUAVBinding()
			.WithGPUOnlyUsage()
			.Finish();

		_normalAtlas = Texture.Create( _mapSize, _mapSize * _cascadeCapacity, ImageFormat.RGBA16161616F )
			.WithName( "OceanFftNormal" )
			.WithUAVBinding()
			.WithGPUOnlyUsage()
			.Finish();

		if ( _displacementAtlas is null || !_displacementAtlas.IsValid() || _normalAtlas is null || !_normalAtlas.IsValid() )
		{
			Log.Error( "[OceanFft] Failed to create UAV atlases — check GPU UAV support." );
			DisposeGpu();
			return;
		}

		_butterflyReady = false;
		_nextUpdateTime = 0f;
		_accumTime = 0f;
		_passRemaining = 0;

		DispatchButterfly();
		_butterflyReady = true;

		for ( var i = 0; i < definition.Cascades.Count && i < OceanFftDefinition.MaxCascades; i++ )
		{
			var c = definition.Cascades[i];
			c.EnsureSeed( _rng );
			c.Time = 120f + MathF.PI * i;
			c.ShouldGenerateSpectrum = true;
		}

		var dt = 1f / MathF.Max( definition.UpdatesPerSecond, 1f );
		for ( var i = 0; i < _allocatedCascades; i++ )
		{
			var p = definition.Cascades[i];
			p.Time += dt;
			p.FoamGrowRate = dt * p.FoamAmount * 7.5f;
			p.FoamDecayRate = dt * MathF.Max( 0.5f, 10f - p.FoamAmount ) * 1.15f;
			DispatchCascade( i, definition.Cascades );
		}

		_warmedUp = true;
		Log.Info( $"[OceanFft] Ready — map {_mapSize}, cascades {_allocatedCascades}, units/m {_unitsPerMeter:0.##}" );
	}

	public void Update( float delta, OceanFftDefinition definition )
	{
		if ( definition is null || !definition.HasCascades )
			return;

		EnsureInitialized( definition );
		if ( _displacementAtlas is null || !_butterflyReady )
			return;

		_unitsPerMeter = MathF.Max( 0.001f, definition.UnitsPerMeter );
		var cascades = definition.Cascades;
		_allocatedCascades = Math.Clamp( cascades.Count, 1, _cascadeCapacity );

		var updatesPerSecond = definition.UpdatesPerSecond;
		_accumTime += delta;

		if ( updatesPerSecond <= 0f || _accumTime >= _nextUpdateTime )
		{
			var targetDelta = updatesPerSecond <= 0f ? delta : 1f / updatesPerSecond;
			var updateDelta = updatesPerSecond <= 0f ? delta : targetDelta + ( _accumTime - _nextUpdateTime );
			_nextUpdateTime = _accumTime + targetDelta;
			BeginPass( updateDelta, cascades );
		}

		if ( _passRemaining <= 0 )
			return;

		_passRemaining--;
		DispatchCascade( _passRemaining, _passCascades );
	}

	void BeginPass( float delta, List<OceanFftCascadeParameters> cascades )
	{
		if ( _passRemaining > 0 )
		{
			for ( var i = 0; i < _passRemaining; i++ )
				DispatchCascade( i, _passCascades );
		}

		var count = Math.Min( cascades.Count, _allocatedCascades );
		for ( var i = 0; i < count; i++ )
		{
			var p = cascades[i];
			p.EnsureSeed( _rng );
			p.Time += delta;
			p.FoamGrowRate = delta * p.FoamAmount * 7.5f;
			p.FoamDecayRate = delta * MathF.Max( 0.5f, 10f - p.FoamAmount ) * 1.15f;
		}

		_passCascades = cascades;
		_passRemaining = count;
	}

	void DispatchButterfly()
	{
		var stages = Log2( _mapSize );
		_butterfly.Attributes.Set( "Butterfly", _butterflyBuffer );
		_butterfly.Attributes.Set( "MapSize", _mapSize );
		_butterfly.Dispatch( _mapSize / 2, stages, 1 );
	}

	void DispatchCascade( int cascadeIndex, List<OceanFftCascadeParameters> cascades )
	{
		if ( cascadeIndex < 0 || cascadeIndex >= cascades.Count || cascadeIndex >= _allocatedCascades )
			return;

		var p = cascades[cascadeIndex];
		var tile = p.TileLength;
		var windSpeed = MathF.Max( 0.0001f, p.WindSpeed );
		var fetch = MathF.Max( 0.0001f, p.FetchLength ) * 1000f;
		var alpha = JonswapAlpha( windSpeed, fetch );
		var peakOmega = JonswapPeakAngularFrequency( windSpeed, fetch );
		var windAngle = p.WindDirectionDegrees * ( MathF.PI / 180f );

		if ( p.ShouldGenerateSpectrum )
		{
			_spectrum.Attributes.Set( "Spectrum", _spectrumBuffer );
			_spectrum.Attributes.Set( "MapSize", _mapSize );
			_spectrum.Attributes.Set( "CascadeIndex", cascadeIndex );
			_spectrum.Attributes.Set( "Seed", p.SpectrumSeed );
			_spectrum.Attributes.Set( "TileLength", tile );
			_spectrum.Attributes.Set( "Alpha", alpha );
			_spectrum.Attributes.Set( "PeakFrequency", peakOmega );
			_spectrum.Attributes.Set( "WindSpeed", windSpeed );
			_spectrum.Attributes.Set( "WindAngle", windAngle );
			_spectrum.Attributes.Set( "Depth", Depth );
			_spectrum.Attributes.Set( "Swell", p.Swell );
			_spectrum.Attributes.Set( "Detail", p.Detail );
			_spectrum.Attributes.Set( "Spread", p.Spread );
			_spectrum.Dispatch( _mapSize, _mapSize, 1 );
			p.ShouldGenerateSpectrum = false;
		}

		_modulate.Attributes.Set( "Spectrum", _spectrumBuffer );
		_modulate.Attributes.Set( "FFTBuffer", _fftBuffer );
		_modulate.Attributes.Set( "MapSize", _mapSize );
		_modulate.Attributes.Set( "CascadeIndex", cascadeIndex );
		_modulate.Attributes.Set( "TileLength", tile );
		_modulate.Attributes.Set( "Depth", Depth );
		_modulate.Attributes.Set( "Time", p.Time );
		_modulate.Dispatch( _mapSize, _mapSize, 1 );

		_fft.Attributes.Set( "Butterfly", _butterflyBuffer );
		_fft.Attributes.Set( "FFTBuffer", _fftBuffer );
		_fft.Attributes.Set( "MapSize", _mapSize );
		_fft.Attributes.Set( "CascadeIndex", cascadeIndex );
		_fft.Dispatch( MaxMapSize, _mapSize, NumSpectra );

		_transpose.Attributes.Set( "FFTBuffer", _fftBuffer );
		_transpose.Attributes.Set( "MapSize", _mapSize );
		_transpose.Attributes.Set( "CascadeIndex", cascadeIndex );
		_transpose.Dispatch( _mapSize, _mapSize, NumSpectra );

		_fft.Attributes.Set( "Butterfly", _butterflyBuffer );
		_fft.Attributes.Set( "FFTBuffer", _fftBuffer );
		_fft.Attributes.Set( "MapSize", _mapSize );
		_fft.Attributes.Set( "CascadeIndex", cascadeIndex );
		_fft.Dispatch( MaxMapSize, _mapSize, NumSpectra );

		_unpack.Attributes.Set( "FFTBuffer", _fftBuffer );
		_unpack.Attributes.Set( "FoamBuffer", _foamBuffer );
		_unpack.Attributes.Set( "DisplacementAtlas", _displacementAtlas );
		_unpack.Attributes.Set( "NormalAtlas", _normalAtlas );
		_unpack.Attributes.Set( "MapSize", _mapSize );
		_unpack.Attributes.Set( "CascadeCapacity", _cascadeCapacity );
		_unpack.Attributes.Set( "CascadeIndex", cascadeIndex );
		_unpack.Attributes.Set( "Whitecap", p.Whitecap );
		_unpack.Attributes.Set( "FoamGrowRate", p.FoamGrowRate );
		_unpack.Attributes.Set( "FoamDecayRate", p.FoamDecayRate );
		_unpack.Dispatch( _mapSize, _mapSize, 2 );
	}

	/// <summary>
	/// Bind FFT maps onto the ocean material attributes.
	/// Bind onto OceanSurfaceRenderer draw attributes / material.
	/// </summary>
	public void ApplyTo( Material material, OceanFftDefinition definition )
	{
		if ( !material.IsValid() )
			return;

		ApplyTo( material.Attributes, definition );
	}

	public void ApplyTo( RenderAttributes attributes, OceanFftDefinition definition )
	{
		if ( attributes is null )
			return;

		if ( !IsReady || definition is null || !definition.HasCascades )
		{
			attributes.Set( "UseOceanFft", 0 );
			return;
		}

		var cascades = definition.Cascades;
		var count = Math.Min( cascades.Count, _allocatedCascades );
		var units = MathF.Max( 0.001f, definition.UnitsPerMeter );

		attributes.Set( "UseOceanFft", 1 );
		attributes.Set( "OceanFftCascades", count );
		attributes.Set( "OceanFftCascadeCapacity", _cascadeCapacity );
		attributes.Set( "OceanFftFadeStart", 150f * units );
		attributes.Set( "OceanFftFadeRate", 0.007f / units );
		attributes.Set( "OceanFftDetailFade", 600f * units );
		attributes.Set( "OceanFftDisplacement", _displacementAtlas );
		attributes.Set( "OceanFftNormal", _normalAtlas );

		for ( var i = 0; i < OceanFftDefinition.MaxCascades; i++ )
		{
			var scale = i < count ? cascades[i].GetMapScale( units ) : Vector4.Zero;
			attributes.Set( $"OceanFftScale{i}", scale );
		}
	}

	static float JonswapAlpha( float windSpeed, float fetchLength )
		=> 0.076f * MathF.Pow( windSpeed * windSpeed / ( fetchLength * Gravity ), 0.22f );

	static float JonswapPeakAngularFrequency( float windSpeed, float fetchLength )
		=> 22f * MathF.Pow( Gravity * Gravity / ( windSpeed * fetchLength ), 1f / 3f );

	static int Log2( int value )
	{
		var n = 0;
		while ( ( 1 << n ) < value )
			n++;
		return n;
	}

	void DisposeGpu()
	{
		_spectrumBuffer?.Dispose();
		_butterflyBuffer?.Dispose();
		_fftBuffer?.Dispose();
		_foamBuffer?.Dispose();
		_displacementAtlas?.Dispose();
		_normalAtlas?.Dispose();

		_spectrumBuffer = null;
		_butterflyBuffer = null;
		_fftBuffer = null;
		_foamBuffer = null;
		_displacementAtlas = null;
		_normalAtlas = null;
		_butterflyReady = false;
		_warmedUp = false;
		_mapSize = 0;
		_cascadeCapacity = 0;
		_allocatedCascades = 0;
	}

	public void Dispose()
	{
		DisposeGpu();
	}
}
