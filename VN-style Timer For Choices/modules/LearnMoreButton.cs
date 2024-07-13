using Godot;
using System;

public partial class LearnMoreButton : Button
{
	private PopupPanel popupModal;
	private Button hardModeButton;
	
	private bool view = false;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		popupModal = GetNode<PopupPanel>("/root/DifficultiesSelect/PopupControlNode/EZModoDetails");
		hardModeButton = GetNode<Button>("/root/DifficultiesSelect/ChoicesText/HardModoButton");
			
		Global.GlobalManager.difficultyChoice = "hard";
		GD.Print(Global.GlobalManager.difficultyChoice);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}


	// GODOT SIGNAL AREA
	private void _OnLearnMoreButtonPressed()
	{
		popupModal.Visible = true;
		view = true;
	}
}
