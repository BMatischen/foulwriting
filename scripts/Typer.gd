extends Node2D

signal lines_tampered
signal spotted

var tracery_class = load("res://scripts/tracery.gd")
var document

var target_text  # Text intended to be written
var curr_txt_pos  # Current furthest position in text, end of substrings
var suspect_line_num  # Index of Line where player was last found on


# Called when the node enters the scene tree for the first time.
func _ready():
	target_text = make_text_to_write().replace("\n","")
	curr_txt_pos = 0
	document = get_tree().current_scene.get_node("AIDoc")
	write_text_chunk()

func set_target_text(text):
	target_text = text

# Set grammar and randomly generate text to be manipulated
func make_text_to_write():
	randomize()
	var rules = {
		"name": ["Tom", "Charlotte", "Sophia", "Olivia", "Lucas", "Megan", "Dr Tommy Thompson", "Alexander", "Isabella", "Luna"],
		"setHeroPronouns": ["[heroThey:they][heroThem:them][heroTheir:their][heroTheirs:theirs]","[heroThey:she][heroThem:her][heroTheir:her][heroTheirs:hers]","[heroThey:he][heroThem:him][heroTheir:his][heroTheirs:his]"],
		"setFirstCompPronouns": ["[firstCompThey:they][firstCompThem:them][firstCompTheir:their][firstCompTheirs:theirs]","[firstCompThey:she][firstCompThem:her][firstCompTheir:her][firstCompTheirs:hers]","[firstCompThey:he][firstCompThem:him][firstCompTheir:his][firstCompTheirs:his]"],
		"setSecondCompPronouns": ["[secondCompThey:they][secondCompThem:them][secondCompTheir:their][secondCompTheirs:theirs]","[secondCompThey:she][secondCompThem:her][secondCompTheir:her][secondCompTheirs:hers]","[secondCompThey:he][secondCompThem:him][secondCompTheir:his][secondCompTheirs:his]"],
		"setVillainPronouns": ["[villainThey:they][villainThem:them][villainTheir:their][villainTheirs:theirs]","[villainThey:she][villainThem:her][villainTheir:her][villainTheirs:hers]","[villainThey:he][villainThem:him][villainTheir:his][villainTheirs:his]"],
		
		"occupationNounHero": ["detective", "spy", "police officer", "guard"],
		"villainTitle": ["genius", "mastermind", "occultist"],
		"villainReason": ["increase my YouTube ad revenue", "become the world's first trillionaire", "have the world bow before me", 
		"get rid of taxes once and for all", "become a universal space entrepreneur", "make lots of cold, hard cash", "be able to watch all my favourite TV shows without being interrupted constantly"],
		"villainPlan": ["convert the planet into a Dyson sphere", "destroy the universe and time itself"],
		
		"baseDesc": ["sleek", "run-down", "cramped", "post-mordernist", "grey"],
		
		"trap": ["band of #moodBad# crocodiles", "floor of lava", "metal cage", "large fishing net", "several #personalityBadMod# professional atheletes"],
		
		"occupationNounMinion": ["ninja", "henchman", "grandma", "monkey"],
		"personalityGoodMod": ["great", "non-corrupt", "diligent", "attentive", "intelligent", "astute", "cold"],
		"personalityBadMod": ["sly", "rude", "suspicious", "paranoid", "sneaky", "meak", "disgusting", "foul"],
		"personalityEvilMod": ["evil", "maniacal", "crazed", "bloodthirsty", "wimpy", "unhinged"],
		"moodBad": ["vexed","indignant","impassioned","wistful", "joyous", "sullen", "unerved", "mad", "anxious", "nervous", "hungry", "murderous"],
		"moodGood": ["joyous", "pleased", "calm", "relaxed", "confident", "eager"],
		"speech": ["shouted", "exclaimed", "said", "whispered", "yelled", "replied", "snapped", "mouthed", "cried"],
		"adverb": ["sullenly", "slowly", "quickly", "quitely", "calmly", "peacefully", "violently", "forecfully", "enthusiastically", "heroically", "triumphantly", "sarcastically", "happily", "suddenly"],
		
		"weaponsMelee": ["hammer", "knife", "katana", "fists", "baton", "cheese grater", "fish", "drumkit"],
		"weaponsRanged": ["laser gun", "death ray", "shruikens"],
		"attack": ["shot", "fatally wounded", "killed", "put to sleep", "pacified", "gave a migraine to", "give a painful back massage to", "dodged", "dispatched several blows to"],
		
		"minion": ["ninja", "guard", "camera", "ghoul", "robot"],
		"minionGroupMod": ["an army of", "a group of", "hundreds of", "dozens of"],
		"minionAttackThrow": ["threw #weaponsRanged.s#", "threw #weaponsMelee.s#", "took aim with #weaponsRanged.s# and #weaponsRanged.s#", "threw #weaponsMelee.s# and #weaponsMelee.s#"],
		"minionCount": ["5", "10", "20", "50", "100", "several", "hordes"],
		
		"setWeapon": ["#weaponsMelee#", "#weaponsRanged#"],
		"setHero": ["[#setHeroPronouns#][hero:#name#][heroJob:#occupationNounHero#][heroWeapon:#setWeapon#]"],
		"setFirstCompanion": ["[#setFirstCompPronouns#][firstComp:#name#][firstCompJob:#occupationNounHero#][firstCompWeapon:#setWeapon#]"],
		"setSecondCompanion": ["[#setSecondCompPronouns#][secondComp:#name#][secondCompJob:#occupationNounHero#][secondCompWeapon:#setWeapon#]"],
		"setVillain": ["[#setVillainPronouns#][villain:#name#][title:#villainTitle#][plan:#villainPlan#][reason:#villainReason#]"],
		"setTrap": ["[chosenTrap:#trap#]"],
		
		"opening": ["""It was midnight when they reached the lair of the #title# #villain#. #hero# the #heroJob# and #heroTheir# companions #firstComp# the #firstCompJob# and 
		#secondComp# the #secondCompJob# had only one plan of action: to burst straight into the lair and make #villain# confess #villainTheir# evil scheme."""],
		
		"intoBase": ["Quitely, the gang sneaked past #minion.s# guarding the perimeter of the lair and infiltrated without getting seen."],
		
		"surpriseTrap": ["""Inside, there was no one to be found. #firstComp# was #moodBad#; \"This seems like a trap\" #firstCompThey# #speech# #adverb#. In an instant, everyone became entrapped by a #chosenTrap#. 
		There was no way out. #personalityEvilMod.capitalize# laughing echoed throughout the lair. #villain#, the #title# behind everything, had arrived."""],
		
		"monologue": ["""Seeing #hero#, #firstComp# and #secondComp# trapped, #villain# could not help but burst out into a monologue. \"So you are the losers who have tampering with my plans!\", 
		#villainThey# #speech# #adverb#. \"Now that I have you in my hands and took a break from messing up my plans, would you like to know what my plans are?\" #secondComp# nodded #adverb#, 
		#moodGood# to finally understand what this #personalityEvilMod# #title# was upto, especially if it was no good. \"My scheme is very simple: I intend to #plan# in order to #reason#.\" 
		I will not be stopped by #personalityBadMod# people from achieving my aims, let alone a mere #heroJob#, a #personalityBadMod# #firstCompJob# or a #personalityBadMod# #secondCompJob#. 
		Not like you lot can do anything since I got you by surprise."""],
		
		"escapeTrap": ["""\"Well that's where you're wrong!\"  #speech# #hero#. And with that, #hero#'s #heroWeapon# allowed everyone to escape the #trap#. 
		#hero#, #firstComp# and #secondComp# were now free and ready for a fight!"""],
		
		"fight": ["""#villain# was #adverb# #moodBad# by this turn of events. \"Minions, attack these intruders!\" #villainThey# #speech#. At these words, #minionGroupMod# #minion.s# appeared and attacked. 
		The #personalityBadMod# minions attacked first and #minionAttackThrow# but #secondComp# managed to protect everyone using #secondCompTheir# #secondCompWeapon# and #attack# #minionCount#. 
		#minionCount# #minion.s# came up behind #hero# who narrowly dodged an incoming #weaponsMelee#. 
		After #heroThey# #adverb# #attack# to #minionCount# enemies, #heroThey# lost #heroTheir# #heroWeapon# and had to make do with a #weaponsMelee# left behind. Unfortunately it broke very quickly and #hero# was at the mercy of #minionCount# #minion.s#. 
		But #firstComp# managed to save the day with #firstCompTheir# #firstCompWeapon#. \"Oh, your're still alive!\", #firstCompThey# #speech#. \"Come on, we need to stick together.\" """],
		
		"story": ["#opening# #intoBase# #surpriseTrap# #monologue#, #escapeTrap#, #fight#"],
		"origin": ["#[#setHero#][#setFirstCompanion#][#setSecondCompanion#][#setVillain#][#setTrap#]story#"],
	}
	var tracery = tracery_class.new()
	var grammar = tracery.get_grammar(rules)
	return grammar.flatten('#origin#').strip_escapes()



func write_text_chunk():
	var i = 450
	var last_txt_pos = curr_txt_pos
	curr_txt_pos += i
	var subtext = target_text.substr(last_txt_pos, i)
	
	# Check if player not on latest line before writing
	if document.get_line(document.newest_line).has_player():
		suspect_line_num = document.newest_line
		$SpotTimer.start()
	document.write_new_text(subtext)


# Get changed lines, start cleaning lines if some tampered else go idle
func scan_document():
	var lines = document.get_changed_lines()
	if lines != []:
		document.edit_lines(lines)
	else:
		start_idle()


# Check for position of player in document using a given line
func find_player(line):
	var regex = RegEx.new()
	regex.compile("\\d+")
	var index = int(regex.search(line.name).get_string())
	if document.get_line(index).has_player():
		suspect_line_num = index
		$SpotTimer.start_countdown()


func start_idle():
	$IdleWait.start()


# After idle state, continue writing or scan document for tampering
func _on_IdleWait_timeout():
	if curr_txt_pos < target_text.length():
		write_text_chunk()
	else:
		scan_document()


func _on_SpotTimer_count_complete():
	if document.get_line(suspect_line_num).has_player():
		emit_signal("spotted")
	else:
		suspect_line_num = null
		$SpotTimer.reset_status()
