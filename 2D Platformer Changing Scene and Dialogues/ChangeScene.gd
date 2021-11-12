extends CanvasLayer

signal scene_changed()

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var black: ColorRect = $Control/Black

var maps: Dictionary = {
	"Map_1": "First Map",
	"Map_2": "Second Map"
}

var current_map: String
var next_map: String
var prev_map: String

# Called when the node enters the scene tree for the first time.
func _change_scene(path: String, delay=0.5) -> void:
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("fade_out")
	
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	
	animation_player.play_backwards("fade_out")
	yield(animation_player, "animation_finished")
	
	emit_signal("scene_changed")

func _set_current_map(map_name: String) -> void:
	current_map = maps[map_name]
	
func _set_next_map(map_name: String) -> void:
	next_map = maps[map_name]

func _set_prev_map(map_name: String) -> void:
	prev_map = maps[map_name]
