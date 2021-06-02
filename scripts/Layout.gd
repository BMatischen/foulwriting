extends Node2D


const TAMPER_MIN = 0.4  # Min tamper percentage target to win
var is_tamper
var ratio_tampered
var score
var chars_left

# Called when the node enters the scene tree for the first time.
func _ready():
	ratio_tampered = 0.0
	score = 0
	chars_left = $PageFrame.get_inputs_left()
	is_tamper = true
	$DocSwitch.text = "Switch to Writing Mode"
	$LabelContainer/TamperLbl.text = "Document Tampered:\n" + str(ratio_tampered)
	$LabelContainer/Score.text = "Total Score:\n" + str(score)
	$LabelContainer/QTECounter.text = "Characters To Type:\n" + str(chars_left)


func _on_DocSwitch_pressed():
	is_tamper = !is_tamper
	if is_tamper == false:
		$DocSwitch.text = "Switch to Tamper Mode"
		$PageFrame.set_process_unhandled_key_input(true)
		$PageFrame.visible = true
	else:
		$DocSwitch.text = "Switch to Writing Mode"
		$PageFrame.set_process_unhandled_key_input(false)
		$PageFrame.visible = false


func _on_Typer_lines_tampered(changed, total):
	ratio_tampered = (float(changed)/float(total))
	$LabelContainer/TamperLbl.text = "Document Tampered:\n" + str(int(ratio_tampered*100)) + "%"
	score += int(10 * ratio_tampered)
	$LabelContainer/Score.text = "Total Score: " + str(score)


func _on_PageFrame_qte_complete():
	chars_left -= 1
	$LabelContainer/QTECounter.text = "Characters Left to type:\n" + str(chars_left)
