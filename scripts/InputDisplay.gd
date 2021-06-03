extends ScrollContainer

var inputs # Array of QTE inputs
var font = get_font("ThemeFont")
var actions = {
	"A": "A",
	"B": "B",
	"C": "C",
	"D": "D",
	"E": "E",
	"F": "F",
	"G": "G",
	"H": "H",
	"I": "I",
	"J": "J",
	"K": "K",
	"L": "L",
	"M": "M",
	"N": "N",
	"O": "O",
	"P": "P",
	"Q": "Q",
	"R": "R",
	"S": "S",
	"T": "T",
	"U": "U",
	"V": "V",
	"W": "W",
	"X": "X",
	"Y": "Y",
	"Z": "Z",
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func select_actions(size):
	randomize()
	inputs = []
	var j = 1
	while j <= size:
		var action_name = get_random_input()
		var label = Label.new()
		label.text = actions[action_name]
		inputs.append(label)
		$HBoxContainer.add_child(label)
		j += 1


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


func count_remaining_inputs():
	return inputs.size()


