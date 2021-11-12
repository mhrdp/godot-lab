extends Area2D

func _input(event: InputEvent) -> void:
	if get_overlapping_bodies().size() > 0:
		if event.is_action_pressed("ui_accept"):
			load_dialogues()

func load_dialogues() -> void:
	var loader = get_node("/root/Node2D/Area2D/DialogueBox")
	
	if loader:
		loader.load_dialogue()
