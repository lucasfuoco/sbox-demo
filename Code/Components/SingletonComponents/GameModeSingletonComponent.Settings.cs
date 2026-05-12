namespace Sandbox.Components.SingletonComponents;

partial class GameModeSingletonComponent
{
	[Property, Sync( SyncFlags.FromHost )] public bool UnlimitedMoney { get; set; }
	[Property, Sync( SyncFlags.FromHost )] public int MaxBalance { get; set; } = 16000;
}
