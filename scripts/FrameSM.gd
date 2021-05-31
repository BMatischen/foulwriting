extends StateMachine

func _ready():
	add_state("write")
	add_state("pause")
	add_state("edit")
	call_deferred("set_state", states.write)


func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
