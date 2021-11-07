extends KinematicBody2D

# For better management, it should be on new file that dedicated in storing a global variable
# This will load all variables and functions inside the Player.gd file
var global := preload("res://game/player/Player.gd")

const SPEED: float = 100.0

onready var area_range_monitorable: Area2D = $AreaRange
onready var sprite_global_pos: Node2D = $Position
onready var tween: Tween = $Tween

onready var player: KinematicBody2D = get_node("../Player")

var _move: Vector2 = Vector2.ZERO
var _player: KinematicBody2D = null
var _stop_enemy_movement: Vector2
var _velocity: Vector2 = Vector2.ZERO
var _vector_pos: Vector2 = Vector2(0, 0)

var original_pos: Vector2
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	original_pos = sprite_global_pos.global_position
	print(original_pos)
	
	# Make the Area2D for enemy view range not interactable by other Area2D
	area_range_monitorable.monitorable = false

# If you use _physics_process() for whatever reason the enemy will moving back
# every time you turn your back, most likely this was due to move_and_slide()
# You can't really disable move_and_slide() so we will use _process() here instead
func _process(delta: float) -> void:
	_limit_frame(delta)
	
	$Label2.text = (
		"POS_X: " + str(sprite_global_pos.global_position.x) + "\n" +
		"POS_Y: " + str(sprite_global_pos.global_position.y) + "\n" +
		"VEL_Y: " + str(position.y)
	)
	
	_velocity.y += global.GRAVITY * delta
	_velocity = move_and_slide(_velocity, global.UP_DIR)
	
	_move = Vector2.ZERO
	if _player:
		_move = sprite_global_pos.global_position.direction_to(player.global_position)
	else:
		_move = sprite_global_pos.global_position.direction_to(original_pos)
	
	_move = _move.normalized() * SPEED
	move_and_collide(_move * delta)

func _limit_frame(_delta: float) -> void:
	position += _vector_pos * _delta
	position.x = clamp(position.x, -380, screen_size.x - 40)
	position.y = clamp(position.y, 0, screen_size.y - 40)

func _on_Area2D_area_entered(area: Area2D) -> void:
	# For enemy knockback on attack
	if area.facing_right:
		_velocity.x = 30
	if area.facing_left:
		_velocity.x = -1 * 30

func _on_AreaRange_body_entered(body):
	if body != self:
		_player = body

func _on_AreaRange_body_exited(_body):
	_player = null
