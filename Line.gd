extends LineEdit


var _has_player  #Mark if player cursor is on this line
var _target_text setget set_target_text, get_target_text


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


func set_target_text(text):
	_target_text = text


# Check if actual text in line matches expected text
func is_not_tampered():
	return self.text == _target_text
