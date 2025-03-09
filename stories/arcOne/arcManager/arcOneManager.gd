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
		"Curiosity": 0,
		"Fear": 0,
		"Confusion": 0,
		"Denial": 0,
		"Regret": 0,
		"Nostalgia": 0
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
		["Who... Who are you?", ["Curiosity", 10], ["Fear", 5]],
		["Where... am I?", ["Confusion", 15], ["Fear", 5]],
		["Floating? What do you mean?", ["Denial", 10], ["Curiousity", 5]],
		["What? I don't remember anything...", ["Confusion", 10], ["Regret", 10]],
		["Where am I? I was... somewhere else just now.", ["Nostalgia", 10], ["Confusion", 5]]
	]))
	
	# Set a reply.
	# This is a universal reply so to make it fresh, every response is different.
	text.set_text([
			"Curiosity... That’s a sign of waking.",
			"Questions... That's a good start. It means you're waking up.",
			"A lost mind that questions… is a mind that still seeks.",
			"You’re reaching for something… that means you’re waking up.",
			"Uncertainty is the first step to remembering."
		].pick_random()
	)
	
	sceneAnim.play()
