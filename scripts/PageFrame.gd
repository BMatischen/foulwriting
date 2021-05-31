extends ScrollContainer

signal text_updated
signal text_created

var tracery_class = load("res://scripts/tracery.gd")
onready var page1 = $VBoxContainer/Page1
onready var page2 = $VBoxContainer/Page2
onready var page3 = $VBoxContainer/Page3
var index
var current_page
var font = get_font("ThemeFont")


# Called when the node enters the scene tree for the first time.
func _ready():
	#var text = make_text_to_sabotage()
	var text = """The treaties can be changed in three different ways. The ordinary revision procedure is essentially the traditional method by which the treaties have been amended and involves holding a full inter-governmental conference. The simplified revision procedure was established by the Treaty of Lisbon and only allows for changes which do not increase the power of the EU. While using the passerelle clause does involve amending the treaties, as such, it does allow for a change of legislative procedure in certain circumstances.

The ordinary revision procedure for amending treaties requires proposals from an institution to be lodged with the European Council. The President of the European Council can then either call a European Convention (composed of national governments, national parliamentarians, MEPs and representatives from the Commission) to draft the changes or draft the proposals in the European Council itself if the change is minor. They then proceed with an Intergovernmental Conference (IGC) which agrees the treaty which is then signed by all the national leaders and ratified by each state.[8]

While this is the procedure that has been used for all treaties prior to the Lisbon Treaty, an actual European Convention (essentially, a constitutional convention) has only been called twice. First in the drafting of the Charter of Fundamental Rights with the European Convention of 1999–2000. Second with the Convention on the Future of Europe which drafted the Constitutional Treaty (which then formed the basis of the Lisbon Treaty). Previously, treaties had been drafted by civil servants.

The simplified revision procedure, which applies only to part three of the Treaty on the Functioning of the European Union and cannot increase the powers of the EU, sees changes simply agreed in the European Council by a decision before being ratified by each state.[8] The amendment to article 136 TFEU makes use of the simplified revision procedure due to the small scope of its change.

Any reform to the legal basis of the EU must be ratified according to the procedures in each member state. All states are required to ratify it and lodge the instruments of ratification with the Government of Italy before the treaty can come into force in any respect. In some states, such as Ireland, this is usually a referendum as any change to that state's constitution requires one. In others, such as Belgium, referendums are constitutionally banned and the ratification must take place in its national parliament.

On some occasions, a state has failed to get a treaty passed by its public in a referendum. In the cases of Ireland and Denmark a second referendum was held after a number of concessions were granted. However, in the case of France and the Netherlands, the treaty was abandoned in favour of a treaty that would not prompt a referendum. In the case of Norway, where the treaty was their accession treaty, the treaty (hence, their membership) was also abandoned.

Treaties are also put before the European Parliament and while its vote is not binding, it is important; both the Belgian and Italian Parliaments said they would veto the Nice Treaty if the European Parliament did not approve it.[9] """
	self.connect("text_created", get_tree().current_scene.get_node("Typer"), "set_target_text")
	self.connect("text_updated", get_tree().current_scene.get_node("Typer"), "track_text")
	emit_signal("text_created", text)
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


# Set current TextEdit to write to
func set_page():
	if index == 1:
		current_page = page1
	elif index == 2:
		current_page = page2
	else:
		current_page = page3


## Write generated text to a page. Go to next page if too many lines
#func write_to_document(text):
#	var words = text.split(" ", true)
#	for w in words:
#		if current_page.rect_size.y > 600:
#			if index != 3:
#				index += 1
#				set_page()
#			else:
#				break
#		current_page.text += (w + " ")

# Write generated text to a page. Go to next page if too many lines
func write_to_document(text):
	var words = text.split(" ", false)
	for w in words:
		for character in w:
			current_page.text += character
			var pause = rand_range(0.005, 0.1)
			yield(get_tree().create_timer(pause), "timeout")
		current_page.text += " "
		emit_signal("text_updated", current_page.text)



