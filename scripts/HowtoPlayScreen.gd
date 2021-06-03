extends Node2D

onready var title_scr = load("res://StartScreen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_TitleBtn_pressed():
	get_tree().change_scene_to(title_scr)
