using Godot;
using System;
using System.Numerics;

public partial class Character : Area2D
{
	private Sprite2D characterSprite;
	private int Speed{get; set;} = 200;
	private Godot.Vector2 screenSize;

	public override void _Ready()
	{
		screenSize = GetViewportRect().Size;
		characterSprite = GetNode<Sprite2D>("/root/Area2D/Character");
	}

	public override void _Process(double delta)
	{
		var velocity = Godot.Vector2.Zero;

		if(Input.IsActionPressed("ui_right"))
		{
			velocity.X += 1;
		}
		if(Input.IsActionPressed("ui_left"))
		{
			velocity.X -= 1;
		}
		if(Input.IsActionPressed("ui_up"))
		{
			velocity.Y -= 1;
		}
		if(Input.IsActionPressed("ui_down"))
		{
			velocity.Y += 1;
		}
			
		if(velocity.Length()>0)
		{
			velocity = velocity.Normalized() * Speed;
		}

		Position += velocity * (float) delta;
		Position = new Godot.Vector2(
			x: Mathf.Clamp(Position.X, 0, screenSize.X),
			y: Mathf.Clamp(Position.Y, 0, screenSize.Y)
		);
		
	}
}
