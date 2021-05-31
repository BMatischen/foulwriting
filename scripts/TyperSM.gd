extends StateMachine


func _ready():
	add_state("type")
	add_state("pause")
	add_state("read")
	call_deferred("set_state", states.type)

func _state_logic(delta):
	if state == states.type:
		pass
	if state == states.read:
		pass
	if state == states.pause:
		pass

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
