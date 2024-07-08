using Godot;
using System;

public partial class TimerProgressBar : Godot.TextureProgressBar
{
	private Godot.TextureProgressBar timerProgressBar;
	private Godot.Timer countdownTimer;

	public override void _Ready()
	{
		timerProgressBar = GetNode<Godot.TextureProgressBar>("/root/TimerForChoices/TimerProgressBar");
		countdownTimer = GetNode<Godot.Timer>("/root/TimerForChoices/CountdownTimer");

		ChangeTimerProgressBarCurrentValue(val:90.0f);
	}

	public override void _Process(double delta)
	{
	}


	// MY CUSTOM FUNCTIONS
	private void ChangeTimerProgressBarMinMaxValue(float min=0.0f, float max=100.0f)
	{
		timerProgressBar.MinValue = min;
		timerProgressBar.MaxValue = max;
	}

	private void ChangeTimerProgressBarCurrentValue(float val=100.0f)
	{
		timerProgressBar.Value = val;
	}


	// GODOT'S SIGNAL AREA
	private void _OnCountdownTimerTimeout()
	{
		// Replace with function body.
	}
}