extends ScrollContainer


#var size # Number of keyboard QTEs to complete
var inputs # Array of QTE inputs
var font = get_font("ThemeFont")
var actions = {
	"UP": "^",
	"DOWN": "V",
	"LEFT": "<",
	"RIGHT": ">",
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
		#label.add_font_override("font", font)
		if (inputs == []):
			pass
			#var stylebox = label.get_stylebox("Theme").duplicate()
#			var stylebox = StyleBoxFlat.new()
#			stylebox.set_bg_color(Color(16, 216, 237, 255))
#			#var stylebox = label.get_stylebox("Theme", "Label")
#			print(stylebox)
#			label.add_stylebox_override("new_styleboxflat", stylebox)
#			update()
#			stylebox.border_color = Color(16, 216, 237, 255) 
#			label.set_stylebox(stylebox)
			#stylebox.set_bg_color(Color(16, 216, 237, 255))
			#stylebox.set_bg_color(Color(16, 216, 237, 255))
			#label.add_stylebox_override("new_styleboxflat", stylebox)
			#stylebox.set_bg_color(Color(16, 216, 237, 255))
		#label.add_styles_override("normal/bg_color", Color(16, 216, 237, 255))
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


