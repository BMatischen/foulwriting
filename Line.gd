extends LineEdit


var _has_player  #Mark if player cursor is on this line
var _target_text


# Called when the node enters the scene tree for the first time.
func _ready():
	_has_player = false
	_target_text = ""


func _on_Line_focus_entered():
	_has_player = true


func _on_Line_focus_exited():
	_has_player = false


func has_player():
	return _has_player


func add_character(c):
	_target_text += c
	self.text += c


func get_target_text():
	return _target_text

