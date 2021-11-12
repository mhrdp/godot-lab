extends StateMachine

func _ready() -> void:
	_add_state("idle")
	call_deferred("_set_state", states.idle)
	
func _get_transition(delta: float):
	return null

func _enter_state(new_state: String, old_state: String):
	pass

func _exit_state(old_state: String, new_state: String):
	pass
