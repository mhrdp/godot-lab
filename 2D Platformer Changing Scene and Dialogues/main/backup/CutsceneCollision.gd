extends Area2D

func _input(event: InputEvent) -> void:
	if get_overlapping_bodies().size() > 0:
		if event.is_action_pressed("ENTER"):
			load_dialogue()
		
func load_dialogue() -> void:
	var loader = get_node("../Area2D/CanvasLayer")
	
	if loader:
		loader.play()
