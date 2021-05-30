extends ScrollContainer


var tracery_class = load("res://scripts/tracery.gd")
onready var page1 = $VBoxContainer/Page1
onready var page2 = $VBoxContainer/Page2
onready var page3 = $VBoxContainer/Page3
var index
var current_page


# Called when the node enters the scene tree for the first time.
func _ready():
	var text = make_text_to_sabotage()
	index = 1
	set_page()
	write_to_document(text)


# Set grammar and randomly generate text to be manipulated
func make_text_to_sabotage():
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
	#print(grammar.flatten("#origin#"))  # prints, e.g., "Hello, world!"

#func make_player_text():
#	randomize()
#	var rules = {
#		 'origin': '#hello.capitalize#, #location#!',
#		 'hello': ['hello', 'greetings', 'howdy', 'hey'],
#		 'location': ['world', 'solar system', 'galaxy', 'universe']
#	  }
#	var tracery = tracery_class.new()
#	var grammar = tracery.get_grammar(rules)
#	return grammar.flatten('#origin#')
#	#print(grammar.flatten("#origin#"))  # prints, e.g., "Hello, world!"

# Set current TextEdit to write to
func set_page():
	if index == 1:
		current_page = page1
	elif index == 2:
		current_page = page2
	else:
		current_page = page3


# Write generated text to a page. Go to next page if too many lines
func write_to_document(text):
	var words = text.split(" ", true)
	for w in words:
		if current_page.get_line_count() > 39:
			if index != 3:
				index += 1
				set_page()
			else:
				break
		current_page.text += (w + " ")


