extends Node2D

signal lines_tampered
signal state_change

var tracery_class = load("res://scripts/tracery.gd")
var document

var target_text  # Text intended to be written
var curr_pos
var next_pos
var state


enum {
	TYPE,
	CHECK,
	IDLE
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#target_text = make_text_to_write()
	target_text = """ As fast as she could go, Al-ice went down the hole af-ter it, and did not once stop to think how in the world she was to get out.

The hole went straight on for some way and then turned down with a sharp bend, so sharp that Al-ice had no time to think to stop till she found her-self fall-ing in what seemed a deep well.

She must not have moved fast, or the well must have been quite deep, for it took her a long time to go down, and as she went she had time to look at the strange things she passed. First she tried to look down and make out what was there, but it was too dark to see; then she looked at the sides of the well and saw that they were piled with book-shelves; here and there she saw maps hung on pegs. She took down a jar from one of the shelves as she passed. On it was the word Jam, but there was no jam in it, so she put it back on one of the shelves as she fell past it.

"Well," thought Al-ice to her-self, "af-ter such a fall as this, I shall not mind a fall down stairs at all. How brave they'll all think me at home! Why, I wouldn't say a thing if I fell off the top of the house." (Which I dare say was quite true.)

Down, down, down. Would the fall nev-er come to an end? "I should like to know," she said, "how far I have come by this time. Wouldn't it be strange if I should fall right through the earth and come out where the folks walk with their feet up and their heads down?"

Down, down, down. "Di-nah will miss me to-night," Al-ice went on. (Di-nah was the cat.) "I hope they'll think to give her her milk at tea-time. Di-nah, my dear! I wish you were down here with me! There are no mice in the air, but you might catch a bat, and that's much like a mouse, you know. But do cats eat bats?" And here Al-ice must have gone to sleep, for she dreamed that she walked hand in hand with Di-nah, and just as she asked her, "Now, Di-nah, tell me the truth, do you eat bats?" all at once, thump! thump! down she came on a heap of sticks and dry leaves, and the long fall was o-ver. """
	
	curr_pos = 0
	next_pos = 0
	document = get_tree().current_scene.get_node("AIDoc")
	state = TYPE
	write_text_chunk()

func set_target_text(text):
	target_text = text

# Set grammar and randomly generate text to be manipulated
func make_text_to_write():
	randomize()
	var rules = {
		"name": ["Arjun","Yuuma","Darcy","Mia","Chiaki","Izzi","Azra","Lina"],
		"animal": ["unicorn","raven","sparrow","scorpion","coyote","eagle","owl","lizard","zebra","duck","kitten"],
		"occupationBase": ["wizard","witch","detective","ballerina","criminal","pirate","lumberjack","spy","doctor","scientist","captain","priest"],
		"occupationMod": ["occult ","space ","professional ","gentleman ","erotic ","time ","cyber","paleo","techno","super"],
		"strange": ["mysterious","portentous","enchanting","strange","eerie"],
		"tale": ["story","saga","tale","legend"],
		"occupation": ["#occupationMod##occupationBase#"],
		"mood": ["vexed","indignant","impassioned","wistful","astute","courteous"],
		"setPronouns": ["[heroThey:they][heroThem:them][heroTheir:their][heroTheirs:theirs]","[heroThey:she][heroThem:her][heroTheir:her][heroTheirs:hers]","[heroThey:he][heroThem:him][heroTheir:his][heroTheirs:his]"],
		"setSailForAdventure": ["set sail for adventure","left #heroTheir# home","set out for adventure","went to seek #heroTheir# forture"],
		"setCharacter": ["[#setPronouns#][hero:#name#][heroJob:#occupation#]"],
		"openBook": ["An old #occupation# told #hero# a story. 'Listen well' she said to #hero#, 'to this #strange# #tale#. ' #origin#'","#hero# went home.","#hero# found an ancient book and opened it.  As #hero# read, the book told #strange.a# #tale#: #origin#"],
		"story": ["#hero# the #heroJob# #setSailForAdventure#. #openBook#"],
		"origin": ["Once upon a time, #[#setCharacter#]story#"],
	}
	var tracery = tracery_class.new()
	var grammar = tracery.get_grammar(rules)
	return grammar.flatten('#origin#')


func write_text_chunk():
	var i = (target_text.length()-1)/4
	next_pos += i
	var subtext = target_text.substr(curr_pos, next_pos)
	curr_pos = next_pos
	document.write_new_text(subtext)


func scan_document():
	var lines = document.get_changed_lines()
	if lines != []:
		emit_signal("lines_tampered", lines.size(), document.count_lines())
		document.edit_lines(lines)
	else:
		start_timer()


func find_player(line):
	var regex = RegEx.new()
	regex.compile("\\d+")
	var index = int(regex.search(line.name).get_string())
	if document.get_line(index).has_player():
		get_tree().quit()
#	if index-1 > -1:
#		if document.get_line(index-1).has_player():
#			get_tree().quit()
#	if index+1 < document.get_children_count():
#		if document.get_line(index+1).has_player():
#			get_tree().quit()


func start_timer():
	$IdleWait.start()



func _on_IdleWait_timeout():
	if curr_pos != target_text.length():
		write_text_chunk()
	else:
		scan_document()
