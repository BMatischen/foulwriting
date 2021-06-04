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
#	target_text = """It was the White Rabbit, trotting slowly back again, and looking anxiously about as it went, as if it had lost something; and she heard it muttering to itself “The Duchess! The Duchess! Oh my dear paws! Oh my fur and whiskers! She’ll get me executed, as sure as ferrets are ferrets! Where can I have dropped them, I wonder?” Alice guessed in a moment that it was looking for the fan and the pair of white kid gloves, and she very good-naturedly began hunting about for them, but they were nowhere to be seen—everything seemed to have changed since her swim in the pool, and the great hall, with the glass table and the little door, had vanished completely.
#
#Very soon the Rabbit noticed Alice, as she went hunting about, and called out to her in an angry tone, “Why, Mary Ann, what are you doing out here? Run home this moment, and fetch me a pair of gloves and a fan! Quick, now!” And Alice was so much frightened that she ran off at once in the direction it pointed to, without trying to explain the mistake it had made.
#
#“He took me for his housemaid,” she said to herself as she ran. “How surprised he’ll be when he finds out who I am! But I’d better take him his fan and gloves—that is, if I can find them.” As she said this, she came upon a neat little house, on the door of which was a bright brass plate with the name “W. RABBIT,” engraved upon it. She went in without knocking, and hurried upstairs, in great fear lest she should meet the real Mary Ann, and be turned out of the house before she had found the fan and gloves.
#
#“How queer it seems,” Alice said to herself, “to be going messages for a rabbit! I suppose Dinah’ll be sending me on messages next!” And she began fancying the sort of thing that would happen: “‘Miss Alice! Come here directly, and get ready for your walk!’ ‘Coming in a minute, nurse! But I’ve got to see that the mouse doesn’t get out.’ Only I don’t think,” Alice went on, “that they’d let Dinah stop in the house if it began ordering people about like that!”
#
#By this time she had found her way into a tidy little room with a table in the window, and on it (as she had hoped) a fan and two or three pairs of tiny white kid gloves: she took up the fan and a pair of the gloves, and was just going to leave the room, when her eye fell upon a little bottle that stood near the looking-glass. There was no label this time with the words “DRINK ME,” but nevertheless she uncorked it and put it to her lips. “I know something interesting is sure to happen,” she said to herself, “whenever I eat or drink anything; so I’ll just see what this bottle does. I do hope it’ll make me grow large again, for really I’m quite tired of being such a tiny little thing!”
#
#It did so indeed, and much sooner than she had expected: before she had drunk half the bottle, she found her head pressing against the ceiling, and had to stoop to save her neck from being broken. She hastily put down the bottle, saying to herself “That’s quite enough—I hope I shan’t grow any more—As it is, I can’t get out at the door—I do wish I hadn’t drunk quite so much!”
#
#Alas! it was too late to wish that! She went on growing, and growing, and very soon had to kneel down on the floor: in another minute there was not even room for this, and she tried the effect of lying down with one elbow against the door, and the other arm curled round her head. Still she went on growing, and, as a last resource, she put one arm out of the window, and one foot up the chimney, and said to herself “Now I can do no more, whatever happens. What will become of me?”
#
#Luckily for Alice, the little magic bottle had now had its full effect, and she grew no larger: still it was very uncomfortable, and, as there seemed to be no sort of chance of her ever getting out of the room again, no wonder she felt unhappy.
#
#“It was much pleasanter at home,” thought poor Alice, “when one wasn’t always growing larger and smaller, and being ordered about by mice and rabbits. I almost wish I hadn’t gone down that rabbit-hole—and yet—and yet—it’s rather curious, you know, this sort of life! I do wonder what can have happened to me! When I used to read fairy-tales, I fancied that kind of thing never happened, and now here I am in the middle of one! There ought to be a book written about me, that there ought! And when I grow up, I’ll write one—but I’m grown up now,” she added in a sorrowful tone; “at least there’s no room to grow up any more here.” """

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
	var i = int(float(target_text.length()-1)/4.0)
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
