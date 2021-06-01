extends ScrollContainer

var tracery_class = load("res://scripts/tracery.gd")
onready var qte_controller = $VBoxContainer/InputDisplay
onready var page = $VBoxContainer/Page
var text  # Text to write to page per character
var curr_loc  # Pointer to position in text on page
const SIZE = 20  # Number of characters in text to write (i.e. num of QTEs)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	curr_loc = 0
	text = make_text()
	qte_controller.select_actions(text.length())

# Set grammar and randomly generate text to be manipulated
func make_text():
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
	var body = grammar.flatten('#origin#')
	return body.substr(body.length()-SIZE)


func _unhandled_input(event):
	if event is InputEventKey and event.is_pressed():
		var is_pass = qte_controller.is_correct_input(event)
		if is_pass:
			page.text += text[curr_loc]
			curr_loc += 1


func _on_DocSwitch_pressed():
	if self.visible:
		set_process_unhandled_input(false)
	else:
		set_process_unhandled_input(true)
	self.visible = !self.visible
