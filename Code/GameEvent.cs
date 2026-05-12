using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using Sandbox.Components;
using Sandbox.Attributes;

namespace Sandbox;

/// <summary>
/// Interface for event payloads that can be listened for by <see cref="IGameEventHandler{T}"/>s.
/// </summary>
public interface IGameEvent { }

/// <summary>
/// Interface for components that handle game events with a payload of type <see cref="T"/>.
/// </summary>
/// <typeparam name="T">Event payload type.</typeparam>
public interface IGameEventHandler<in T>
	where T : IGameEvent
{
	/// <summary>
	/// Called when an event with payload of type <see cref="T"/> is dispatched on a <see cref="GameObject"/>
	/// that contains this component, including on a descendant.
	/// </summary>
	/// <param name="eventArgs">Event payload.</param>
	void OnGameEvent( T eventArgs );
}

/// <summary>
/// Helper for dispatching game events in a scene.
/// </summary>
public static class GameEvent
{
	private static Dictionary<Type, IReadOnlyDictionary<Type, int>> HandlerOrderingCache { get; } = new();

	/// <summary>
	/// Notifies all <see cref="IGameEventHandler{T}"/> components that are within <paramref name="root"/>,
	/// with a payload of type <typeparamref name="T"/>.
	/// </summary>
	public static void Dispatch<T>( this GameObject root, T eventArgs )
		where T : IGameEvent
	{
		if ( !root.IsValid() )
			return;

		var handlers = (root is Scene scene
			? scene.GetAllComponents<IGameEventHandler<T>>() // I think this is more efficient?
			: root.Components.GetAll<IGameEventHandler<T>>())
			.ToArray();

		if ( !HandlerOrderingCache.TryGetValue( typeof(T), out var ordering ) || handlers.Any( x => !ordering.ContainsKey( x.GetType() ) ) )
		{
			ordering = HandlerOrderingCache[typeof(T)] = GetHandlerOrdering<T>();
		}

		List<Exception>? exceptions = null;

		foreach ( var handler in handlers.OrderBy( x => ordering[x.GetType()] ) )
		{
			try
			{
				handler.OnGameEvent( eventArgs );
			}
			catch ( Exception e )
			{
				exceptions ??= new();
				exceptions.Add( e );
			}
		}

		switch ( exceptions?.Count )
		{
			case 1:
				Log.Error( exceptions[0] );
				break;

			case > 1:
				Log.Error( new AggregateException( exceptions ) );
				break;
		}
	}

	private static bool IsImplementingMethodName( string methodName )
	{
		if ( methodName == nameof(IGameEventHandler<IGameEvent>.OnGameEvent) )
		{
			return true;
		}

		return methodName.StartsWith( "Sandbox.Events.IGameEventHandler<" ) && methodName.EndsWith( ">.OnGameEvent" );
	}

	private static MethodDescription? GetImplementation<T>( TypeDescription type )
	{
		foreach ( var method in type.Methods )
		{
			if ( method.IsStatic ) continue;
			if ( method.Parameters.Length != 1 ) continue;
			if ( method.Parameters[0].ParameterType != typeof( T ) ) continue;

			if ( !IsImplementingMethodName( method.Name ) ) continue;

			return method;
		}

		return null;
	}

	private static IReadOnlyDictionary<Type, int> GetHandlerOrdering<T>()
		where T : IGameEvent
	{
		var types = TypeLibrary.GetTypes<IGameEventHandler<T>>().ToArray();

		// Stable registration order. Full constraint sorting previously relied on engine-internal helpers.
		return Enumerable.Range( 0, types.Length )
			.ToImmutableDictionary( i => types[i].TargetType, i => i );
	}
}

public delegate void GameEventAction<in T>( T eventArgs )
	where T : IGameEvent;

/// <summary>
/// Base class for components that expose game events to Action Graph.
/// </summary>
public abstract class GameEventComponent<T> : Component, IGameEventHandler<T>
	where T : IGameEvent
{
	/// <summary>
	/// Action invoked when the <typeparamref name="T"/> event is dispatched.
	/// </summary>
	[Property]
	public GameEventAction<T>? OnEvent { get; set; }

	/// <summary>
	/// If this component is within a state machine, optional state to transition
	/// to when this event is dispatched.
	/// </summary>
	[Property]
	public StateComponent? NextState { get; set; }

	void IGameEventHandler<T>.OnGameEvent( T eventArgs )
	{
		OnEvent?.Invoke( eventArgs );

		if ( NextState is not null )
		{
			Components.GetInAncestorsOrSelf<StateMachineComponent>()?.Transition( NextState );
		}
	}
}
