extends Node2D

onready var title_scr = load("res://StartScreen.tscn")
onready var crowd_boo = preload("res://crowd-boo.wav")
onready var crowd_clap = preload("res://crowd_clap.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false


# Setup end game screen to inform player of game outcome
func display_results(results):
	get_tree().paused = true
	self.visible = true
	var ratio = results["ratio_tampered"]
	var target = results["required_ratio"]
	var chars_left = results["chars_left"]
	var score = results["score"]
	var spotted = results["spotted"]
	
	var result_txt
	var sub_result_txt
	if chars_left != 0 and not spotted:
		$ResultSound.stream = crowd_boo
		$ResultSound.volume_db = -5
		result_txt = "You lost!"
		sub_result_txt = "You failed to finish before the deadline! Nobody liked what you had written..."
	elif ratio < target and not spotted:
		$ResultSound.stream = crowd_boo
		$ResultSound.volume_db = -5
		result_txt = "You lost!"
		sub_result_txt = "You lost to your rival. You didn't cheat enough..."
	elif spotted:
		$ResultSound.stream = crowd_boo
		$ResultSound.volume_db = -5
		result_txt = "You lost!"
		sub_result_txt = "Your rival spotted you tampering and ratted you out! You weren't sneaky enough..."
	else:
		$ResultSound.stream = crowd_clap
		$ResultSound.volume_db = 0
		result_txt = "You won the contest!"
		sub_result_txt = "You managed to submit your piece on time! \nAs your rival's piece was terrible, you won the contest.\nCongratulations!"
	
	$ResultSound.play()
	$LabelBox/ResultLbl.text = result_txt
	$LabelBox/SubResultLbl.text = sub_result_txt
	$LabelBox/RatioLbl.text = "Ratio of Opponent's Document Tampered: " + str(int(ratio*100)) + "%"
	$LabelBox/CharsLbl.text = "Characters Left to Type: " + str(chars_left)
	$LabelBox/ScoreLbl.text = "Final Score: " + str(score)


func _on_RetryBtn_pressed():
	get_tree().reload_current_scene()


func _on_QuitBtn_pressed():
	get_tree().paused = false
	get_tree().change_scene_to(title_scr)
