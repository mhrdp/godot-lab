using Godot;
using System;

public partial class EZModoDetails : PopupPanel
{
	private Vector2 viewportSize;
	private Node2D rootNode;

	public override void _Ready()
	{
		rootNode = GetNode<Node2D>("/root/DifficultiesSelect");
		viewportSize = rootNode.GetViewport().GetVisibleRect().Size;
		this.Size = (Vector2I) viewportSize;
	}

	public override void _Process(double delta)
	{
	}
}
