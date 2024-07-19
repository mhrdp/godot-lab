extends Node2D


func _ready():
# Called when the node enters the scene tree for the first time.
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("accept"):
		DialogueManager.show_example_dialogue_balloon(load("res://modules/Dialogue_DialogueManager/test_dialogue.dialogue"), "test")