extends Node2D

onready var game_scene = load("res://Layout.tscn")
onready var instructions = load("res://HowtoPlayScreen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_PlayBtn_pressed():
	get_tree().change_scene_to(game_scene)


func _on_QuitBtn_pressed():
	get_tree().quit()


func _on_InstructBtn_pressed():
	get_tree().change_scene_to(instructions)
