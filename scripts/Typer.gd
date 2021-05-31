extends Node2D

signal unwanted_change_found
var tracery_class = load("res://scripts/tracery.gd")
var document

var target_text

# Called when the node enters the scene tree for the first time.
func _ready():
	target_text = make_text_to_write()
	document = get_tree().current_scene.get_node("Document")
	document.write_new_text(target_text)

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



