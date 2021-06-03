extends Timer

signal count_complete

export var count = 30  # Seconds until game ends
var time_meter


# Called when the node enters the scene tree for the first time.
func _ready():
	time_meter = get_tree().current_scene.get_node("HUDContainer/TimeBox/TimeMeter")
	#label.text = "Time Left:\n" + str(count)



func _on_GameTimer_timeout():
	count -= 1
	time_meter.value -= 1
	if (count < 1):
		emit_signal("count_complete")
