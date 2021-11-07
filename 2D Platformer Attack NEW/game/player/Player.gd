extends KinematicBody2D

signal health_updated(health)
signal killed()

# For better management, this should be on new file that dedicated in storing a global variable
const GRAVITY: float = 500.0
const JUMP_STR: float = 300.0
const MAX_JUMP: int = 1
const SPEED: float = 200.0
const UP_DIR: Vector2 = Vector2.UP

var _velocity: Vector2 = Vector2.ZERO

export var max_health: float = 100.0

onready var health: float = max_health setget _set_health
onready var _hitbox: Area2D = $PlayerSprite/Area2D
onready var _player_animation: AnimationTree = $AnimationTree
onready var _invulnerability_timer: Timer = $InvulnerabilityTimer

onready var _conditional_print: TextEdit = get_node("../TextEdit")
onready var _damage: Label = get_node("../Godot Enemy/Label")

var currently_attacking: bool = false
var currently_hitting: bool = false
var currently_idling: bool = false
var currently_jumping: bool = false
var currently_running: bool = false

var facing_right: bool = true
var facing_left: bool = false

var num_jump: int = 0
var state_machine
var screen_size
var vector_pos: Vector2 = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	state_machine = _player_animation.get("parameters/playback")
	
	# Start default animation
	state_machine.start("idle")
	
	# connect the signals
	# _state.connect("animation_started", self, "_on_AnimationPlayer_animation_started")
	
func _physics_process(delta: float) -> void:
	# Limit player movement inside the screen
	_limit_frame(delta)
	
	# Logic for movement
	# _movement_logic(delta)
	_read_movement(delta)
	_velocity = move_and_slide(_velocity, UP_DIR)
	
	_conditional_print.text = (
		"ATK: " + str(currently_attacking) + " | " + "IDLE: " + str(currently_idling) + "\n" +
		"JUMP: " + str(currently_jumping) + " | " + "RUN: " + str(currently_running) + "\n" +
		"RIGHT: " + str(facing_right) + " | " + "LEFT: " + str(facing_left) + "\n" +
		"HIT: " + str(currently_hitting) + "\n" +
		"POS_X: " + str(position.x) + "\n" + 
		"POS_Y: " + str(position.y)
	)
	
func _limit_frame(_delta: float) -> void:
	position += vector_pos * _delta
	position.x = clamp(position.x, 20, screen_size.x - 40)
	position.y = clamp(position.y, 20, screen_size.y - 20)

func _read_movement(_delta: float) -> void:
	var attack_seqs: Array = ["attack_1", "attack_2", "attack_3"]
	var movement_control: float = (
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	)
	
	var is_attacking: bool = Input.is_action_pressed("ATTACK")
	var is_idling: bool = is_on_floor() and is_zero_approx(_velocity.x)
	var is_jumping: bool = Input.is_action_just_pressed("JUMP")
	
	var attack_release: bool = Input.is_action_just_released("ATTACK")
	var jumping_release: bool = Input.is_action_just_released("JUMP")
	var movement_release: bool = Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right")
	
	var movement_made: bool = movement_control != 0.0
	var moving_left: bool = Input.is_action_pressed("ui_left")
	var moving_right: bool = Input.is_action_pressed("ui_right")
	
	var player_collision_xpos: float = 21.5 #Taken from position.x attribute at Inspector

	_velocity.y += _delta * GRAVITY
	
	#######
	# Looking at bunch of ifs statement below, I'm not sure if AnimationTree's state machine
	# is even necessary, tbh. Maybe I'm utilize it wrongly, I don't know. But worth trying
	# going with Animation Tree with only general animation control and not a complex one
	# to see how it actually behaves. 
	#######
	
	# Gedenral idling control
	if is_idling:
		currently_idling = true
		state_machine.travel("idle")
	elif not is_idling:
		currently_idling = false
	
	# General jumping control
	if is_jumping:
		num_jump += 1
		if is_on_floor():
			num_jump = 0
		if num_jump < MAX_JUMP:
			currently_jumping = true
			state_machine.travel("jump")
			_velocity.y = -1 * JUMP_STR
		if jumping_release:
			_velocity.y = 0.0
	if not is_jumping and is_on_floor():
		currently_jumping = false
	
	# General movement control
	if movement_made:
		currently_running = true
		if moving_right:
			facing_right = true
			facing_left = false
			state_machine.travel("run")
			$PlayerSprite.scale.x = 1
			$BodyCollision.position.x = player_collision_xpos
		elif moving_left:
			facing_right = false
			facing_left = true
			state_machine.travel("run")
			$PlayerSprite.scale.x = -1
			$BodyCollision.position.x = player_collision_xpos * 2.0
		while _velocity.y < 0:
			state_machine.travel("jump")
			break
	elif is_zero_approx(_velocity.x) or movement_release:
		currently_running = false
		if is_attacking:
			currently_attacking = true
			_velocity.x = 0.0
			state_machine.travel(attack_seqs[randi() % 3])
		if attack_release:
			currently_attacking = false
	
	# Action control while moving and not moving
	if currently_running:
		if is_attacking:
			currently_idling = false
			currently_attacking = true
			state_machine.travel(attack_seqs[randi() % 3])
			_velocity.x = 0.0
		elif attack_release:
			currently_attacking = false
			_velocity.x = 0.0
	elif not currently_running:
		if is_attacking:
			currently_attacking = true
			state_machine.travel(attack_seqs[randi() % 3])
		if attack_release:
			currently_attacking = false
			
	# Speed control relative to attack
	if currently_attacking:
		_velocity.x = 0.0
	if not currently_attacking:
		_velocity.x = movement_control * SPEED
	
	# Additional animation control
	if currently_jumping and currently_running:
		state_machine.travel("jump")
	if currently_jumping and currently_running and currently_attacking:
		state_machine.travel(attack_seqs[randi() % 3])

func _set_health(value: float) -> void:
	var prev_health: float = health
	health = clamp(value, 0.0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			_kill()
			emit_signal("killed")

func _kill() -> void:
	pass

func _damage_taken(dmg: float) -> void:
	if _invulnerability_timer.is_stopped():
		_invulnerability_timer.start()
		_set_health(health - dmg)
		state_machine.travel("hit")

func _on_InvulnerabilityTimer_timeout() -> void:
	state_machine.travel("hit")
	_damage.text = " "

func _on_Area2D_area_entered(area: Area2D) -> void:
	var damage_dealt: int = randi() % 100
	if area.is_in_group("can_get_hit"):
		_invulnerability_timer.start()
		currently_hitting = true
		_damage.text = str(damage_dealt)

func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.is_in_group("can_get_hit"):
		_invulnerability_timer.stop()
		currently_hitting = false
