extends Node2D

onready var title_scr = load("res://StartScreen.tscn")

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
	
	var result_txt = "You won the contest!"
	var sub_result_txt = "You managed to submit your piece on time! As your opponent's piece stank becuase of your exploits, you won the contest. Congratulations!"
	if ratio < target:
		result_txt = "You lost!"
		sub_result_txt = "Your opponent's piece far excelled yours and won the contest. You didn't cheat enough..."
	if chars_left != 0:
		result_txt = "You lost!"
		sub_result_txt = "You failed to finish your masterpiece before the deadline! Nobody was able appreciate your genius..."
	
	$LabelBox/ResultLbl.text = result_txt
	$LabelBox/SubResultLbl.text = sub_result_txt
	$LabelBox/RatioLbl.text = "Ratio of Opponent's document tampered:\n" + str(ratio) + "%"
	$LabelBox/CharsLbl.text = "Characters Left to Type: " + str(chars_left)
	$LabelBox/ScoreLbl.text = "Final Score: " + str(score)




func _on_RetryBtn_pressed():
	get_tree().reload_current_scene()


func _on_QuitBtn_pressed():
	get_tree().paused = false
	get_tree().change_scene_to(title_scr)
