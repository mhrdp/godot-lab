using Godot;
using System;

public partial class DifficultiesSelect : Node2D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	private void GoToScene(string path)
	{
		Viewport root = GetTree().Root;
		Node currentScene = root.GetChild(root.GetChildCount()-1);
		GD.Print(currentScene);

		currentScene.Free();
		Node nextScene = ResourceLoader.Load<PackedScene>(path).Instantiate();
		currentScene = nextScene;

		GetTree().Root.AddChild(currentScene);
	}

	private void _OnHardModeButtonPressed()
	{
		var path = "res://modules/TimerForChoices/TimerForChoices.tscn";
		GoToScene(path);
	}
}
