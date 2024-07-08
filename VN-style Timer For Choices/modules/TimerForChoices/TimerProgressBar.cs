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

		SetTimerProgressBarMinMaxValue();
		SetTimerProgressBarCurrentValue();
	}

	public override void _Process(double delta)
	{
	}


	// MY CUSTOM FUNCTIONS
	private void SetTimerProgressBarMinMaxValue(float min=0.0f, float max=100.0f)
	{
		timerProgressBar.MinValue = min;
		timerProgressBar.MaxValue = max;
	}

	private void SetTimerProgressBarCurrentValue(float val=100.0f)
	{
		timerProgressBar.Value = val;
	}

	private void CountdownSettings(float waitTime=1.0f, bool repeatable=false, bool autostart=false)
	{
		countdownTimer.WaitTime = waitTime;
		countdownTimer.OneShot = repeatable;
		countdownTimer.Autostart = autostart;
	}


	// GODOT'S SIGNAL AREA
	private void _OnCountdownTimerTimeout()
	{
		// Replace with function body.
		SetTimerProgressBarCurrentValue(val:100.0f-20.0f);
	}
}