extends ScrollContainer


const SIZE = 10  # Number of keyboard QTEs to complete

var inputs  # Array of QTE inputs
var active  # Flag for if keyboard input should be handled (this node is visible)
var font = get_font("ThemeFont")
var actions = {
	"UP": "^",
	"DOWN": "V",
	"LEFT": "<",
	"RIGHT": ">",
}

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	inputs = []
	var j = 1
	while j <= SIZE:
		var action_name = get_random_input()
		var label = Label.new()
		label.text = actions[action_name]
		label.add_font_override("font", font)
		inputs.append(label)
		$HBoxContainer.add_child(label)
		j += 1
	active = true


# Get random input string for random action
func get_random_input():
	return actions.keys()[randi()% actions.keys().size()]


func is_correct_input(event):
	var input_str = OS.get_scancode_string(event.scancode).to_upper()
	if input_str in actions.keys() and inputs.size() > 0:
		if inputs[0].text == actions[input_str]:
			$HBoxContainer.remove_child(inputs.pop_front())
			return true
	return false


func set_active():
	active = !active


func is_active():
	return active


