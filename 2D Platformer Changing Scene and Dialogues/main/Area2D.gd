extends Area2D

onready var player: KinematicBody2D = get_node("../../Sprite")
# Called when the node enters the scene tree for the first time.
func _ready():
	ChangeScene._set_current_map("Map_1")
	if ChangeScene.prev_map == "Second Map":
		player.position.x = 1000

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ENTER"):
		if get_overlapping_bodies().size() > 0:
			ChangeScene._change_scene("res://main/main_2.tscn")
			ChangeScene._set_next_map("Map_2")
