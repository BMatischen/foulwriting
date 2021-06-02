extends StateMachine


#func _ready():
#	add_state("type")
#	add_state("check")
#	add_state("idle")
#	call_deferred("set_state", states.type)
#
#
#func _state_logic(delta):
#	if state == states.type:
#		parent.write_subtext()
#	if state == states.check:
#		parent.scan_document()
#	if state == states.idle:
#		pass
#
#func _get_transition(delta):
#	match state:
#		states.type:
#			return states.type
#		states.check:
#			return states.check
#		states.idle:
#			return states.idle
#	return null
#
#func _enter_state(new_state, old_state):
#	pass
#
#func _exit_state(old_state, new_state):
#	pass
