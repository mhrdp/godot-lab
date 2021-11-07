extends KinematicBody2D

export var speed := 200

var screen_size
var input_vector := Vector2(0, 0)
var can_double_jump = false

const UP := Vector2(0, -1)
const GRAVITY := 30
const JUMPFORCE := -450

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	# Limit area of movement inside the size of the screen
	position += input_vector * delta
	position.x = clamp(position.x, 40, screen_size.x - 40)
	position.y = clamp(position.y, 40, screen_size.y - 40)

	# Take an right and left input
	if Input.is_action_pressed("ui_right"):
		input_vector.x = speed
	if Input.is_action_pressed("ui_left"):
		input_vector.x = -speed

	# Jump and double jump
	input_vector.y = input_vector.y + GRAVITY # gravity pull
	if Input.is_action_just_pressed("ui_up") and is_on_floor(): # first jump
		input_vector.y = JUMPFORCE
		can_double_jump = true
	if !is_on_floor() and can_double_jump and Input.is_action_just_pressed("ui_up"): # second jump
		input_vector.y = JUMPFORCE
		can_double_jump = false
	
	# Normalize movement speed, usually applied during movement such as diagonal movement
	var move_direction := input_vector.normalized()
	input_vector = move_and_slide(input_vector, Vector2.UP)
	
	# To stop the left and right movement so that the character stop moving after button release
	input_vector.x = lerp(input_vector.x, 0, 0.2)
