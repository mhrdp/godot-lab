using Godot;
using System;

public partial class NPC : Area2D
{
	[Signal]
	// Reminder: delegate must end with EvenHandler
	public delegate void InteractionEventHandler();
	
	public override void _Ready()
	{
	}

	public override void _Process(double delta)
	{
	}

	private void _OnBodyEntered(Node2D body)
	{
		// Omit EventHandler when calling the signal, add SignalName
		EmitSignal(SignalName.Interaction);	
	}
}
