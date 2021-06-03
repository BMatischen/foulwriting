extends ScrollContainer

signal typing_done
signal update_tamper_count

var newest_line
var curr_line
var lines_tampered
onready var linenode = preload("res://Line.tscn")

func _ready():
	newest_line = 1
	curr_line = newest_line
	lines_tampered = 0


# Write new text and create lines if more characters than one line is allowed
func write_new_text(text):
	var line = get_node("VBoxContainer/Line" + str(newest_line))
	var char_limit = line.get_max_length()
	var text_length = line.get_text().length()
	var current_pos_in_text = 0
	line.editable = false
	for c in text:
		if text_length >= char_limit:
			line.set_target_text(line.text)
			line.editable = true
			newest_line += 1
			var newline = linenode.instance()
			newline.name = "Line" + str(newest_line)
			$VBoxContainer.add_child(newline)
			line = get_node("VBoxContainer/Line" + str(newest_line))
			text_length = 0
			line.editable = false
			emit_signal("update_tamper_count", lines_tampered, count_lines(), false)
		line.add_character(c)
		text_length += 1
		current_pos_in_text += 1
		var pause = rand_range(0.0005, 0.001)
		yield(get_tree().create_timer(pause), "timeout")
	line.set_target_text(line.text)
	line.editable = true
	get_tree().current_scene.get_node("Typer").scan_document()


#func add_to_line(line, start):
#	var subtext = line.get_target_text().substr(start, line.get_target_text().length())
#	for c in subtext:
#		line.text += c
#		var pause = rand_range(0.005, 0.1)
#		yield(get_tree().create_timer(pause), "timeout")


#func remove_bad_chars(line):
#	#var line = get_line(index)
#	var j = 0
#	var target_txt = line.get_target_text()
#	while j < line.text.length() and j < target_txt.length():
#		if line.text[j] != target_txt[j]:
#			line.text.erase(j, 1)
#			line.text = line.text.insert(j, target_txt[j])
#		j += 1
#	if j < target_txt.length():
#		breakpoint
#		add_to_line(line, j)
#	else:
#		print(line.text.substr(j, line.text.length()))
#
#		line.text.erase(j, line.text.length()-j)


# Rewrite tampered lines
func edit_lines(lines):
	while lines.size() > 0:
		var line = lines.pop_back()
		line.editable = false
		get_tree().current_scene.get_node("Typer").find_player(line)
		var target_txt = line.get_target_text()
		var j = 0
		if line.text.length() != target_txt.length():
			line.text = ""
			for c in target_txt:
				line.text += c
				var pause = 0.0000000005
				yield(get_tree().create_timer(pause), "timeout")
		line.editable = true
		line.tampered = false
		lines_tampered -= 1
		emit_signal("update_tamper_count", lines_tampered, count_lines(), false)
	get_tree().current_scene.get_node("Typer").start_timer()


func get_line(line_num):
	return get_node("VBoxContainer/Line" + str(line_num))


func count_lines():
	return get_node("VBoxContainer").get_child_count()


func count_tampered_lines():
	return lines_tampered


func increment_tampered_lines():
	lines_tampered += 1
	emit_signal("update_tamper_count", lines_tampered, count_lines())


func get_changed_lines():
	var lines = []
	for i in $VBoxContainer.get_child_count():
		var line = get_node("VBoxContainer/Line" + str(i+1))
		if !line.is_not_tampered():
			lines.append(line)
	return lines
