using Godot;
using System;

public partial class TimerProgressBar : Godot.TextureProgressBar
{
	private Godot.TextureProgressBar timerProgressBar;
	private Godot.Timer countdownTimer;
	private Godot.Tween timerAnimation;

	public override void _Ready()
	{
		timerProgressBar = GetNode<Godot.TextureProgressBar>("/root/TimerForChoices/TimerProgressBar");
		countdownTimer = GetNode<Godot.Timer>("/root/TimerForChoices/CountdownTimer");
		
		SetTimerProgressBarMinMaxValue();
		SetTimerProgressBarCurrentValue();
		SetCountdownSettings(autostart: true);
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

	private void SetCountdownSettings(float waitTime=1.0f, bool repeatable=false, bool autostart=false)
	{
		countdownTimer.WaitTime = waitTime;
		countdownTimer.OneShot = repeatable;
		countdownTimer.Autostart = autostart;
	}


	// GODOT'S SIGNAL AREA
	private void _OnCountdownTimerTimeout()
	{
		// Replace with function body.
		if(timerProgressBar.Value > 0)
		{
			timerAnimation = GetTree().CreateTween();
			timerProgressBar.Value -= 20.0f;

			timerAnimation.TweenProperty(timerProgressBar, "value", timerProgressBar.Value, 0.2);
			timerAnimation.SetTrans(Tween.TransitionType.Linear);
			timerAnimation.SetEase(Tween.EaseType.InOut);
		}
	}
}