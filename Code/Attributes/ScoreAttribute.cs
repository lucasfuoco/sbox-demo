namespace Sandbox.Attributes;

[AttributeUsage( AttributeTargets.Property, AllowMultiple = false )]
public class ScoreAttribute : System.Attribute
{
	public string Name { get; set; }
	public string Format { get; set; } = "{0}";
	public string ShowIf { get; set; } = null;
	public bool ShowTeamOnly { get; set; } = false;

	public ScoreAttribute( string name )
	{
		Name = name;
	}
}