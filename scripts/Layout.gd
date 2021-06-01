extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$DocSwitch.text = "Switch to Writing Mode"


func _on_DocSwitch_pressed():
	if $DocSwitch.text == "Switch to Writing Mode":
		$DocSwitch.text = "Switch to Tamper Mode"
	else:
		$DocSwitch.text = "Switch to Writing Mode"
