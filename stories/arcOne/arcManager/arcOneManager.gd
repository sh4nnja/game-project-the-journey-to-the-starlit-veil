# The story arc script of protagonist's arc.

extends ArcTemplate

# DANGER ZONE!
#------------------------------------------------------------------------------#
func _init() -> void:
	# Override your story details here.
	storyDetails["name"] = "Through Eyes Unseen"
	storyDetails["sub-name"] = "Chapter I | Falling Through"
	storyDetails["desc"] = """
		Would you open your eyes to face life’s uncertainties, or keep them shut to endure the unknown?
		
		The path ahead is fractured, memories slipping through your grasp like falling stars. You don’t know what awaits, but then again, do we ever?
		
		Step into a realm where regret takes form, choices shape reality, and the past beckons to be remembered… or erased. 
		
		Are you ready to face it?
	"""
	
	# Override emotions.
	emotions = {
		"Curiosity": 0.3, 
		"Fear": 0.1,        
		"Confusion": 0.5,   
		"Denial": 0.2,     
		"Regret": 0.4,     
		"Nostalgia": 0.3    
	}

# Game Scripting!
#------------------------------------------------------------------------------#
@onready var game: Node2D = get_parent()

@onready var uiAnim: AnimationPlayer = get_node("uiLayer/uiAnim")
@onready var sceneAnim: AnimationPlayer = get_node("assets/scenes")

@onready var choiceManager: VFlowContainer = get_node("uiLayer/uiMenu/uiDialogs/choiceManager")
@onready var text: Label = get_node("uiLayer/uiMenu/uiDialogs/text")

# Just code like in Godot. _ready triggers when arc is started.
func _ready() -> void:
	# These snippet is for the cutscenes and dialogs.
	# You can copy the format and everything, but make sure that you actually
	# have the narrative going.
	uiAnim.play("arcFade")
	await uiAnim.animation_finished
	sceneAnim.play("intro")
	
	# Set the game to play.
	game.player.camera.set_enabled(true) 
	lib.isPlaying = true

# METHODS
# If you don't see a method being called in the script, it means that they are in animation.
#------------------------------------------------------------------------------#
# The game isn't really constrained in this animation, this is just for the introductory area.
func introChoice() -> void:
	# Create the choices and store the output.
	# Influence the emotions based on the choice.
	setEmotions(await choiceManager.createChoices([
		["Who... Who are you?", ["Curiosity", 0.10], ["Fear", 0.05]],
		["Where... am I?", ["Confusion", 0.15], ["Fear", 0.05]],
		["Floating? What do you mean?", ["Denial", 0.10], ["Curiousity", 5]],
		["What? I don't remember anything...", ["Confusion", 0.10], ["Regret", 0.10]],
		["Where am I? I was... somewhere else just now.", ["Nostalgia", 0.10], ["Confusion", 0.05]]
	]),
		game.manager
	)
	
	# Set a reply.
	# This is a universal reply so to make it fresh, every response is different.
	var responses: Array = [
			"Curiosity... That’s a sign of waking.",
			"Questions... That's a good start. It means you're waking up.",
			"A lost mind that questions… is a mind that still seeks.",
			"You’re reaching for something… that means you’re waking up.",
			"Uncertainty is the first step to remembering."
		]
	
	responses.shuffle()
	text.set_text(responses[0])
	
	sceneAnim.play()

func enableMovement() -> void:
	lib.canMove = true
	
	# Prompts player if not moved for a long time.
	var responses: Array = [
		"Take your time… Even the smallest step matters. Just press anywhere.",
		"No need to hurry… A single step is all it takes. Tap anywhere.",
		"There's no rush. Just a gentle push forward, press anywhere.",
		"It’s okay. Just a little movement is enough. Try pressing anywhere.",
		"You're not alone… One step at a time. Tap anywhere when you're ready.",
		"Even the stars started small. Just touch anywhere to begin.",
		"Movement is the start of all things… Try pressing anywhere.",
		"A journey begins with a simple choice. Touch anywhere when you're ready."
	]
	
	responses.shuffle()
	await get_tree().create_timer(15).timeout
	text.set_text(responses[0])
	var playerPos: Vector2 = game.player.position
	while game.player.position == playerPos:
		uiAnim.play("showText")
		await uiAnim.animation_finished
		responses.shuffle()
		text.set_text(responses[0])
		await get_tree().create_timer(10).timeout
		if game.player.position != playerPos: 
			break
	
	await get_tree().create_timer(5).timeout
	sceneAnim.play()
