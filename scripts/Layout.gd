extends Node2D


const TAMPER_MIN = 0.5  # Min tamper percentage target to win
var is_tamper
var ratio_tampered
var score
var chars_left

onready var tamper_meter = $HUDContainer/TamperBox/TamperMeter
onready var qte_meter = $HUDContainer/QTEBox/QTEMeter
onready var time_meter = $HUDContainer/TimeBox/TimeMeter
onready var score_lbl = $HUDContainer/ScoreLbl
onready var doc_switch = $HUDContainer/DocSwitch

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	ratio_tampered = 0
	score = 0
	chars_left = $PageFrame.get_inputs_left()
	is_tamper = true
	tamper_meter.value = ratio_tampered
	qte_meter.value = 0
	qte_meter.max_value = chars_left
	time_meter.value = $GameTimer.count
	time_meter.max_value = time_meter.value
	score_lbl.text = "Score:\n" + str(score)
	doc_switch.text = "Switch to Writing Mode"
	$GameTimer.start()
	$Music.play()


func _on_DocSwitch_pressed():
	is_tamper = !is_tamper
	if is_tamper == false:
		doc_switch.text = "Switch to Tamper Mode"
		$AIDoc.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$PageFrame.set_process_unhandled_key_input(true)
		$PageFrame.visible = true
	else:
		doc_switch.text = "Switch to Writing Mode"
		$AIDoc.mouse_filter = Control.MOUSE_FILTER_STOP
		$PageFrame.set_process_unhandled_key_input(false)
		$PageFrame.visible = false


func _on_PageFrame_qte_complete():
	chars_left -= 1
	qte_meter.value += 1
#	$LabelContainer/QTECounter.text = "Characters to Type:\n" + str(chars_left)


func _on_AIDoc_update_tamper_count(changed, total, is_tamper=true):
	ratio_tampered = (float(changed)/float(total))
	tamper_meter.value = int(ratio_tampered*100)
	if (is_tamper):
		score += int(10 * ratio_tampered)
		score_lbl.text = "Score: " + str(score)



func _on_GameTimer_count_complete():
	var data = {
		"ratio_tampered": ratio_tampered,
		"required_ratio": TAMPER_MIN,
		"score": score,
		"chars_left": chars_left,
		"spotted": false
	}
	$GameOver.display_results(data)


func _on_Typer_spotted():
	var data = {
		"ratio_tampered": ratio_tampered,
		"required_ratio": TAMPER_MIN,
		"score": score,
		"chars_left": chars_left,
		"spotted": true
	}
	$GameOver.display_results(data)


func _on_Music_finished():
	$Music.play()
