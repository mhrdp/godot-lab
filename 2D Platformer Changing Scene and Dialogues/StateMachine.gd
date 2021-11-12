extends Node
class_name StateMachine

var state = null setget _set_state
var previous_state = null

var states: Dictionary = {}

onready var parent: = get_parent()

func _physics_process(delta: float):
	if state != null:
		_state_logic(delta)
		
		var transition = _get_transition(delta)
		if transition != null:
			_set_state(transition)

func _state_logic(delta: float):
	pass
	
func _get_transition(delta: float):
	return null

func _enter_state(new_state: String, old_state: String):
	pass

func _exit_state(old_state: String, new_state: String):
	pass

func _set_state(new_state: String):
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, previous_state)

func _add_state(state_name: String):
	states[state_name] = states.size()
