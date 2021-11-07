extends KinematicBody2D

const UP_DIR := Vector2.UP

export var speed := 300.0
export var jump_strength := 750.0
export var maximum_jumps := 2
export var double_jump_strength := 500.0
export var gravity := 2000.0

var _jump_made := 0
var _velocity := Vector2.ZERO

onready var _pivot: Node2D = $Node
onready var _animated_skin: AnimatedSprite = $Node/AnimatedSprite
onready var _start_scale: Vector2 = _pivot.scale

var vector_position := Vector2()
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

# Because the the body needs to collide with physics object, we use _physics_process
func _physics_process(delta: float) -> void:
	# prevent the sprite going out of frame
	position += vector_position * delta
	position.x = clamp(position.x, 10, screen_size.x - 10)
	position.y = clamp(position.y, 10, screen_size.y - 10)
	
	var _horizontal_dir = (
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	)
	
	# Calculate _velocity.x for left-right movement and _velocity.y for gravity and jump
	_velocity.x = _horizontal_dir * speed
	_velocity.y += gravity * delta
	
	# All of the conditionals
	var is_falling := _velocity.y > 0.0 and not is_on_floor()
	var is_jumping := Input.is_action_just_pressed("JUMP") and is_on_floor()
	var is_double_jumping := Input.is_action_just_pressed("JUMP") and is_falling
	var is_jump_cacelled := Input.is_action_just_released("JUMP") and _velocity.y < 0.0 # when release jump button, cancels the jump
	var is_idling := is_on_floor() and is_zero_approx(_velocity.x)
	var is_running := is_on_floor() and not is_zero_approx(_velocity.x)
	
	if is_jumping:
		_jump_made += 1
		_velocity.y = -jump_strength
	elif is_double_jumping:
		_jump_made += 1
		if _jump_made <= maximum_jumps:
			_velocity.y = -double_jump_strength
	elif is_jump_cacelled:
		_velocity.y = 0.0 # cut the jump short the moment player release the jump button
	elif is_idling or is_running:
		_jump_made = 0 # reset the jump made
			
	_velocity = move_and_slide(_velocity, UP_DIR)
	
	# flip the sprite if the direction is to the left
	if not is_zero_approx(_velocity.x):
		_pivot.scale.x = sign(_velocity.x) * _start_scale.x
	
	# play the animations
	if is_jumping or is_double_jumping:
		_animated_skin.animation = "jump"
	elif is_running:
		_animated_skin.animation = "walk"
	else:
		_animated_skin.animation = "idle"
