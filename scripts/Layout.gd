extends Node2D


const TAMPER_MIN = 0.5  # Min tamper percentage target to win
var is_tamper
var ratio_tampered
var score
var chars_left

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	ratio_tampered = 0.0
	score = 0
	chars_left = $PageFrame.get_inputs_left()
	is_tamper = true
	$DocSwitch.text = "Switch to Writing Mode"
	$LabelContainer/TamperLbl.text = "Document Tampered:\n" + str(ratio_tampered)
	$LabelContainer/Score.text = "Total Score:\n" + str(score)
	$LabelContainer/QTECounter.text = "Characters To Type:\n" + str(chars_left)
	$GameTimer.start()


func _on_DocSwitch_pressed():
	is_tamper = !is_tamper
	if is_tamper == false:
		$DocSwitch.text = "Switch to Tamper Mode"
		$AIDoc.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$PageFrame.set_process_unhandled_key_input(true)
		$PageFrame.visible = true
	else:
		$DocSwitch.text = "Switch to Writing Mode"
		$AIDoc.mouse_filter = Control.MOUSE_FILTER_STOP
		$PageFrame.set_process_unhandled_key_input(false)
		$PageFrame.visible = false


func _on_PageFrame_qte_complete():
	chars_left -= 1
	$LabelContainer/QTECounter.text = "Characters Left to type:\n" + str(chars_left)


func _on_AIDoc_update_tamper_count(changed, total, is_tamper=true):
	ratio_tampered = (float(changed)/float(total))
	$LabelContainer/TamperLbl.text = "Document Tampered:\n" + str(int(ratio_tampered*100)) + "%"
	if (is_tamper):
		score += int(10 * ratio_tampered)
		$LabelContainer/Score.text = "Total Score: " + str(score)




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
