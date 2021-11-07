extends KinematicBody2D

const UP_DIR := Vector2.UP

export var speed := 300.0
export var jump_strength := 750.0
export var gravity := 2000.0

var _velocity = Vector2.ZERO

onready var _pivot: Node2D = $Sprite
onready var _start_scale: Vector2 = _pivot.scale
onready var _animated_skin: AnimatedSprite = $Sprite/AnimatedSprite
onready var _sprite_collition: CollisionShape2D = $Sprite/CollisionShape2D

var screen_size
var vector_pos = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	_animated_skin.playing = true

func _physics_process(delta: float) -> void:
	position += vector_pos * delta
	position.x = clamp(position.x, 20, screen_size.x - 20)
	position.y = clamp(position.y, 20, screen_size.y - 20)
	
	var _horizontal_dir = (
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	)
	
	_velocity.x = _horizontal_dir * speed
	_velocity.y += gravity * delta
	
	var is_jumping = Input.is_action_just_pressed("JUMP") and is_on_floor()
	var is_jump_cacelled = Input.is_action_just_released("JUMP") and _velocity.y < 0.0
	var is_running = is_on_floor() and not is_zero_approx(_velocity.x)
	var is_idling = is_on_floor() and is_zero_approx(_velocity.x)
	var is_attacking = Input.is_action_just_pressed("ui_accept")
	var is_not_attacking = Input.is_action_just_released("ui_accept")
		
	# Jumping logic
	if is_jumping:
		_velocity.y = -1 * (jump_strength)
	elif is_jump_cacelled:
		_velocity.y = 0.0
	
	_velocity = move_and_slide(_velocity, UP_DIR)
	
	if is_attacking:
		_animated_skin.animation = "attack_1"
		_sprite_collition.disabled = false
	elif is_not_attacking:
		_sprite_collition.disabled = true
	elif is_idling:
		_animated_skin.animation = "idle"
		
	
	# flip sprite horizontally when moving direction change to left
	if not is_zero_approx(_velocity.x):
		_pivot.scale.x = sign(_velocity.x) * _start_scale.x
