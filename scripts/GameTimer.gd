extends Timer

signal count_complete

export var count = 30  # Seconds until game ends
var label  # Label for displaying time left


# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_tree().current_scene.get_node("LabelContainer/TimeLeft")
	label.text = "Time Left:\n" + str(count)



func _on_GameTimer_timeout():
	count -= 1
	label.text = "Time Left:\n" + str(count)
	if (count < 1):
		emit_signal("count_complete")
