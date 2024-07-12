using Godot;
using System;

public partial class TimerProgressBar : Godot.TextureProgressBar
{
	[Export]
	public float timerDuration = 10.0f;
	[Export]
	public float dangerTimePercentage = 0.50f;

	private Godot.TextureProgressBar timerProgressBar;
	private Godot.Timer countdownTimer;
	private Godot.Tween timerAnimation;
	private Godot.Tween dangerTimeAnimation;
	private Godot.Node2D progressBarParentNode;

	public override void _Ready()
	{
		timerProgressBar = GetNode<Godot.TextureProgressBar>("/root/TimerForChoices/TimerProgressBar");
		countdownTimer = GetNode<Godot.Timer>("/root/TimerForChoices/CountdownTimer");
		progressBarParentNode = GetNode<Godot.Node2D>("/root/TimerForChoices");
		
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
		var dangerTime = (timerDuration * dangerTimePercentage) * timerDuration;

		if(timerProgressBar.Value > 0)
		{
			var time = timerProgressBar.Value - (timerProgressBar.MaxValue/timerDuration);

			timerAnimation = GetTree().CreateTween();
			timerAnimation.TweenProperty(timerProgressBar, "value", time, 0.5);

			if(time <= dangerTime)
			{
				dangerTimeAnimation = GetTree().CreateTween();
				dangerTimeAnimation.TweenProperty(progressBarParentNode, "scale", new Vector2(0.75f, 0.75f), 0.25);
				dangerTimeAnimation.TweenProperty(progressBarParentNode, "scale", new Vector2(1.0f, 1.0f), 0.25);
			}
		}
	}
}