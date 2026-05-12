namespace Sandbox.Components.SingletonComponents;

partial class GameModeSingletonComponent
{
	/// <summary>
	/// Gets all game modes referenced by a scene.
	/// </summary>
	public static IEnumerable<GameModeSingletonComponent> GetAll( SceneFile scene )
	{
		return GetGameModesForScene( scene );
	}

	private static IEnumerable<GameModeSingletonComponent> GetGameModesForScene( SceneFile scene )
	{
		var list = new HashSet<GameModeSingletonComponent>();
		var meta = scene.GetMetadata( "GameModes", "" );

		if ( !string.IsNullOrEmpty( meta ) )
		{
			var files = meta.Split( ", " );

			foreach ( var file in files )
			{
				var prefab = GameObject.GetPrefab( file );
				if ( prefab.IsValid() )
				{
					list.Add( prefab.GetComponent<GameModeSingletonComponent>() );
				}
			}
		}
		return list;
	}

	public static IReadOnlyList<GameModeSingletonComponent> AllUnique
	{
		get
		{
			var list = new HashSet<GameModeSingletonComponent>();
			var scenes = GameUtils.GetAvailableMaps();

			foreach ( var scene in scenes )
			{
				var modes = GetAll( scene );
				foreach ( var mode in modes )
				{
					list.Add( mode );
				}
			}

			return list.ToList()
				.AsReadOnly();
		}
	}
}
