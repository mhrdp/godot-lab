extends Area2D

var facing_right: bool = true
var facing_left: bool = false

func _ready() -> void:
	pass

# Movement status so that the enemy node know where the attack coming from
func _process(_delta) -> void:
	var moving_right = Input.is_action_just_pressed("ui_right")
	var moving_left = Input.is_action_just_pressed("ui_left")
	
	if moving_right:
		facing_right = true
		facing_left = false
	elif moving_left:
		facing_right = false
		facing_left = true
