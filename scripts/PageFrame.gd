extends ScrollContainer

signal qte_complete
onready var qte_controller = $VBoxContainer/InputDisplay
onready var page = $VBoxContainer/Page
const TEXT = """and in any extremity inclined to help rather than to reprove. “I incline to Cain’s heresy,” he used to say quaintly: “I let my brother go to the devil in his own way."""
var curr_loc  # Pointer to position in text on page


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	curr_loc = 0
	qte_controller.select_actions(TEXT.length())


func _unhandled_key_input(event):
	if event.is_pressed():
		var is_pass = qte_controller.is_correct_input(event)
		if is_pass:
			page.text += TEXT[curr_loc]
			curr_loc += 1
			emit_signal("qte_complete")

func get_inputs_left():
	return qte_controller.count_remaining_inputs()
