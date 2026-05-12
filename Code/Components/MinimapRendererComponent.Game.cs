namespace Sandbox.Components;

public partial class MinimapRendererComponent
{
    [Property, ImageAssetPath, Group( "This Map" )] public string CurrentMinimapPath { get; set; }
}