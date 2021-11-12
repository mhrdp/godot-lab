extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	ChangeScene._set_current_map("Map_2")

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ENTER"):
		if get_overlapping_bodies().size():
			ChangeScene._change_scene("res://main/main_1.tscn")
			ChangeScene._set_prev_map("Map_2")
