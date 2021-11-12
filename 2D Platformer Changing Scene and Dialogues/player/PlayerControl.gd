extends KinematicBody2D

const SPEED: float = 200.0
const GRAVITY: float = 100.0
const JUMP_STR: float = 400.0

onready var label: Label = $Label

var _velocity: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	label.text = (
		"prev_map: " + str(ChangeScene.prev_map) + "\n" +
		"next_map: " + str(ChangeScene.next_map) + "\n" +
		"curr_map: " + str(ChangeScene.current_map)
	)

	var movement_control: float
	
	var is_jumping: bool = Input.is_action_just_pressed("ui_up")
	var is_jumping_canceled: bool = Input.is_action_just_released("ui_up")
	
	movement_control = (
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	)
	
	_velocity.x = movement_control * SPEED
	_velocity.y += delta * GRAVITY
	
	if is_jumping:
		_velocity.y = -1 * JUMP_STR
	if is_jumping_canceled:
		_velocity.y = 0.0
	
	_velocity = move_and_slide(_velocity, Vector2.UP)

func set_active(active: bool) -> void:
	set_physics_process(active)
	set_process(active)
	set_process_input(active)
