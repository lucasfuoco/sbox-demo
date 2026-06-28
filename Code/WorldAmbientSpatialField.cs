using Sandbox.Components.SingletonComponents;

namespace Sandbox;

public enum WorldAmbientLayer
{
	Wind,
	Crickets,
	Owls,
	Frogs,
	Leaves,
	Water,
	Rain,
}

/// <summary>
/// Places looping ambient sounds on a terrain-following grid around the listener.
/// </summary>
public sealed class WorldAmbientSpatialField
{
	readonly struct CellKey : IEquatable<CellKey>
	{
		public WorldAmbientLayer Layer { get; }
		public int CellX { get; }
		public int CellY { get; }

		public CellKey( WorldAmbientLayer layer, int cellX, int cellY )
		{
			Layer = layer;
			CellX = cellX;
			CellY = cellY;
		}

		public bool Equals( CellKey other ) => Layer == other.Layer && CellX == other.CellX && CellY == other.CellY;
		public override bool Equals( object obj ) => obj is CellKey other && Equals( other );
		public override int GetHashCode() => HashCode.Combine( Layer, CellX, CellY );
	}

	readonly struct LayerConfig
	{
		public WorldAmbientLayer Layer { get; }
		public int Radius { get; }
		public float CellSize { get; }
		public float HeightOffset { get; }

		public LayerConfig( WorldAmbientLayer layer, int radius, float cellSize, float heightOffset )
		{
			Layer = layer;
			Radius = radius;
			CellSize = cellSize;
			HeightOffset = heightOffset;
		}
	}

	readonly Dictionary<CellKey, SoundHandle> _handles = new();
	readonly HashSet<CellKey> _activeKeys = new();

	static readonly LayerConfig[] LayerConfigs =
	[
		new( WorldAmbientLayer.Rain, 2, 2200f, 650f ),
		new( WorldAmbientLayer.Wind, 2, 1800f, 120f ),
		new( WorldAmbientLayer.Leaves, 3, 900f, 8f ),
		new( WorldAmbientLayer.Water, 2, 1400f, 0f ),
		new( WorldAmbientLayer.Crickets, 2, 1200f, 4f ),
		new( WorldAmbientLayer.Owls, 1, 2400f, 12f ),
		new( WorldAmbientLayer.Frogs, 2, 1000f, 2f ),
	];

	public void Update(
		Vector3 listenerPosition,
		WorldManagerSingletonComponent terrain,
		WorldAmbientConditions conditions,
		WorldAmbientSoundSet sounds,
		WorldAmbientVolumeSet volumes )
	{
		_activeKeys.Clear();

		foreach ( var config in LayerConfigs )
			UpdateLayer( config, listenerPosition, terrain, conditions, sounds, volumes );

		PruneInactive();
	}

	void UpdateLayer(
		LayerConfig config,
		Vector3 listenerPosition,
		WorldManagerSingletonComponent terrain,
		WorldAmbientConditions conditions,
		WorldAmbientSoundSet sounds,
		WorldAmbientVolumeSet volumes )
	{
		var soundEvent = sounds.Get( config.Layer );
		if ( soundEvent is null )
			return;

		var centerCellX = (int)MathF.Floor( listenerPosition.x / config.CellSize );
		var centerCellY = (int)MathF.Floor( listenerPosition.y / config.CellSize );

		for ( var offsetY = -config.Radius; offsetY <= config.Radius; offsetY++ )
		{
			for ( var offsetX = -config.Radius; offsetX <= config.Radius; offsetX++ )
			{
				var cellX = centerCellX + offsetX;
				var cellY = centerCellY + offsetY;
				var anchor = GetCellAnchor( config.Layer, cellX, cellY, config.CellSize );
				var sample = WorldAmbientTerrainSample.Sample( terrain, anchor.x, anchor.y );
				var position = sample.GroundPosition.WithZ( sample.GroundPosition.z + config.HeightOffset );
				var volume = GetLayerVolume( config.Layer, sample, conditions, volumes, anchor.x, anchor.y );
				var pitch = GetLayerPitch( config.Layer, conditions );

				var key = new CellKey( config.Layer, cellX, cellY );
				_activeKeys.Add( key );
				UpdateEmitter( key, soundEvent, position, volume, pitch );
			}
		}
	}

	static Vector2 GetCellAnchor( WorldAmbientLayer layer, int cellX, int cellY, float cellSize )
	{
		var hash = Hash( cellX, cellY, (int)layer );
		var offsetX = (hash & 0xff) / 255f * cellSize * 0.72f;
		var offsetY = ((hash >> 8) & 0xff) / 255f * cellSize * 0.72f;
		return new Vector2( cellX * cellSize + offsetX, cellY * cellSize + offsetY );
	}

	static float GetLayerVolume(
		WorldAmbientLayer layer,
		WorldAmbientTerrainSample sample,
		WorldAmbientConditions conditions,
		WorldAmbientVolumeSet volumes,
		float worldX,
		float worldY )
	{
		var rainAttenuation = 1f - conditions.Rain * 0.75f;
		var windAttenuation = 1f - conditions.Wind * 0.45f;

		return layer switch
		{
			WorldAmbientLayer.Wind => conditions.Wind * sample.OpenExposure * volumes.Wind,
			WorldAmbientLayer.Leaves => conditions.Wind * sample.TreeDensity * (1f - conditions.Rain * 0.55f) * volumes.Leaves,
			WorldAmbientLayer.Water => sample.Water * (1f - conditions.Rain * 0.25f) * volumes.Water,
			WorldAmbientLayer.Rain => conditions.Rain * WorldAmbientCloudCoverage.Sample(
				worldX,
				worldY,
				conditions.TimeSeconds,
				conditions.WindDirection,
				conditions.CloudAmount ) * volumes.Rain,
			WorldAmbientLayer.Crickets => conditions.Night * sample.Grass * rainAttenuation * windAttenuation * volumes.Crickets,
			WorldAmbientLayer.Owls => conditions.DeepNight * sample.TreeDensity * (1f - conditions.Rain * 0.85f) * volumes.Owls,
			WorldAmbientLayer.Frogs => conditions.Evening * sample.Shore * (1f - conditions.Rain * 0.35f) * volumes.Frogs,
			_ => 0f,
		};
	}

	static float GetLayerPitch( WorldAmbientLayer layer, WorldAmbientConditions conditions ) =>
		layer switch
		{
			WorldAmbientLayer.Wind => 0.85f + conditions.Wind * 0.25f,
			WorldAmbientLayer.Leaves => 0.9f + conditions.Wind * 0.2f,
			_ => 1f,
		};

	void UpdateEmitter( CellKey key, SoundEvent soundEvent, Vector3 position, float volume, float pitch )
	{
		const float epsilon = 0.01f;

		if ( volume <= epsilon )
		{
			if ( _handles.TryGetValue( key, out var silent ) && silent.IsValid() )
				silent.Volume = 0f;

			return;
		}

		if ( !_handles.TryGetValue( key, out var handle ) || !handle.IsValid() || handle.Finished )
			handle = Sound.Play( soundEvent );

		handle.Position = position;
		handle.Volume = volume;
		handle.Pitch = pitch;
		_handles[key] = handle;
	}

	void PruneInactive()
	{
		var stale = new List<CellKey>();

		foreach ( var (key, handle) in _handles )
		{
			if ( _activeKeys.Contains( key ) )
				continue;

			if ( handle.IsValid() )
				handle.Volume = 0f;

			stale.Add( key );
		}

		foreach ( var key in stale )
			_handles.Remove( key );
	}

	static int Hash( int cellX, int cellY, int salt )
	{
		unchecked
		{
			var hash = 17;
			hash = hash * 31 + cellX;
			hash = hash * 31 + cellY;
			hash = hash * 31 + salt;
			return hash;
		}
	}
}

public readonly struct WorldAmbientSoundSet
{
	public SoundEvent Wind { get; init; }
	public SoundEvent Crickets { get; init; }
	public SoundEvent Owls { get; init; }
	public SoundEvent Frogs { get; init; }
	public SoundEvent Leaves { get; init; }
	public SoundEvent Water { get; init; }
	public SoundEvent Rain { get; init; }

	public SoundEvent Get( WorldAmbientLayer layer ) => layer switch
	{
		WorldAmbientLayer.Wind => Wind,
		WorldAmbientLayer.Crickets => Crickets,
		WorldAmbientLayer.Owls => Owls,
		WorldAmbientLayer.Frogs => Frogs,
		WorldAmbientLayer.Leaves => Leaves,
		WorldAmbientLayer.Water => Water,
		WorldAmbientLayer.Rain => Rain,
		_ => null,
	};
}

public readonly struct WorldAmbientVolumeSet
{
	public float Wind { get; init; }
	public float Crickets { get; init; }
	public float Owls { get; init; }
	public float Frogs { get; init; }
	public float Leaves { get; init; }
	public float Water { get; init; }
	public float Rain { get; init; }
}
