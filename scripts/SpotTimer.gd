extends Timer

signal count_complete

export var count = 2
var detection_meter
var status_lbl
var time = 0.5


# Called when the node enters the scene tree for the first time.
func _ready():
	detection_meter = get_tree().current_scene.get_node("HUDContainer/DetectionBox/DetectionMeter")
	status_lbl = get_tree().current_scene.get_node("HUDContainer/DetectionBox/StatusLbl")
	detection_meter.value = 0
	detection_meter.max_value = count
	status_lbl.text = "Safe"

func start_countdown():
	status_lbl.text = "Danger!"
	self.start()


func reset_status():
	self.stop()
	status_lbl.text = "Safe"
	detection_meter.value = 0
	count = 2


func _on_SpotTimer_timeout():
	detection_meter.value += 0.5
	count -= 0.5
	if count <= 0:
		emit_signal("count_complete")
