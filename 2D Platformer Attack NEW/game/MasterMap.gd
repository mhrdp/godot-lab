extends Node2D

const STARTING_MAP: int = 1

var current_map
var map: Dictionary = {
	1: "res://game/map/1_Entrance.tscn",
	2: "res://game/map/2_Forest.tscn"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	_load_map(STARTING_MAP)

func _load_map(map_name):
	if current_map:
		current_map.queue_free()
	
	current_map = load(map[map_name]).instance()
	current_map.z_index = -1 # Draw under the player
	add_child(current_map)
