extends ScrollContainer

onready var qte_controller = $VBoxContainer/InputDisplay


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventKey and event.is_pressed():
		print(qte_controller.is_correct_input(event))
