extends KinematicBody2D

export var speed := 700.0
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

# Read user input to move the sprite
func _physics_process(_delta: float) -> void:
	var input_vector := Vector2(
		# Get input from 0 to 1, 
		# and if you use controller it will based on how hard you move the controller
		Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'),
		Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
	)
	
	# To normalize the diagonal movement or else it will be too fast
	var move_direction := input_vector.normalized()
	move_and_slide(speed * move_direction)

# Make sure the sprite did not leave the screen
func _process(_delta: float) -> void:
	var input_vector := Vector2()
	if Input.get_action_strength('ui_right'):
		input_vector.x += float(Input.get_action_strength('ui_right'))
	if Input.get_action_strength('ui_left'):
		input_vector.x -= float(Input.get_action_strength('ui_left'))
	if Input.get_action_strength('ui_up'):
		input_vector.y -= float(Input.get_action_strength('ui_up'))
	if Input.get_action_strength('ui_down'):
		input_vector.y += float(Input.get_action_strength('ui_down'))
	
	position += input_vector * _delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
