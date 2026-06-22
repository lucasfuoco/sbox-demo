using System.Runtime.InteropServices;

namespace Sandbox;

[StructLayout( LayoutKind.Sequential )]
public struct TerrainVertex(
	Vector3 position,
	Vector3 normal,
	Vector4 tangent,
	Vector2 texCoord,
	Color32 blend,
	Color32 tint )
{
	[VertexLayout.Position] public Vector3 Position = position;
	[VertexLayout.Normal] public Vector3 Normal = normal;
	[VertexLayout.Tangent] public Vector4 Tangent = tangent;
	[VertexLayout.TexCoord] public Vector2 TexCoord = texCoord;
	[VertexLayout.TexCoord( 4 )] public Color32 Blend = blend;
	[VertexLayout.TexCoord( 5 )] public Color32 Tint = tint;
}
