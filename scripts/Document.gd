extends ScrollContainer

var newest_line
var curr_line
onready var linenode = preload("res://Line.tscn")

func _ready():
	newest_line = 1
	curr_line = newest_line

func write_new_text(text):
	var line = get_node("VBoxContainer/Line" + str(newest_line))
	var char_limit = line.get_max_length()
	var text_length = line.get_text().length()
	var current_pos_in_text = 0
	for c in text:
		if text_length >= char_limit:
			print(line.get_target_text())
			newest_line += 1
			var newline = linenode.instance()
			newline.name = "Line" + str(newest_line)
			$VBoxContainer.add_child(newline)
			line = get_node("VBoxContainer/Line" + str(newest_line))
			text_length = 0
		line.add_character(c)
		text_length += 1
		current_pos_in_text += 1
		var pause = rand_range(0.005, 0.1)
		yield(get_tree().create_timer(pause), "timeout")








