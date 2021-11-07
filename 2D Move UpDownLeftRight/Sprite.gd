extends Sprite

# Attach dictionary to handle the change in character sprite according to its movement
const SPRITE_MAP := {
	Vector2.RIGHT: preload("res://icon.png"), # Right
	Vector2.LEFT: preload("res://icon.png"), # Left
	Vector2.DOWN: preload("res://icon.png"), # Down
	Vector2.UP: preload("res://icon.png"), # Up
	
	Vector2(1.0, 1.0): preload("res://icon.png"), # Bottom Right
	Vector2(1.0, -1.0): preload("res://icon.png"), # Up Right
	Vector2(-1.0, -1.0): preload("res://icon.png"), # Up Left
	Vector2(-1.0, 1.0): preload("res://icon.png"), # Bottom Left
}

# Default look direction
var look_direction := Vector2.RIGHT

func _process(_delta: float) -> void:
	var input_vector := Vector2(
		float(Input.is_action_pressed("ui_right")) - float(Input.is_action_pressed("ui_left")),
		float(Input.is_action_pressed("ui_down")) - float(Input.is_action_pressed("ui_up"))
	)
	
	if input_vector.length() > 0.0 and input_vector != look_direction:
		# Load the texture based on player input
		texture = SPRITE_MAP[input_vector]
		look_direction = input_vector
		
		# To flip the sprite horizontally if you don't have an approprite sprite for the
		# LEFT and RIGHT actions
		flip_h = sign(look_direction.x) == -1.0
	
	# Simulate the hover by grabbing how much time passes in miliseconds
	# This will make the sprite move UP and DOWN continuously
	position.y = sin(OS.get_ticks_msec() / 200.0) * 8.0
