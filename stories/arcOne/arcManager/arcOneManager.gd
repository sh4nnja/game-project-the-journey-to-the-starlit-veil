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

#------------------------------------------------------------------------------#
@onready var _ui_anim: AnimationPlayer = get_node("uiLayer/uiAnim")

# Just code like godot. _ready triggers when arc is started.
func _ready() -> void:
	# These snippet is for the cutscenes and dialogs.
	# You can copy the format and everything, but make sure that you actually
	# have the narrative going.
	_ui_anim.play("arcFade")
	await _ui_anim.animation_finished
	get_node("assets/sceneMngr").set_active(true)
	
	startArc() 

# METHODS
#------------------------------------------------------------------------------#
func startArc() -> void:
	get_parent().player.camera.set_enabled(true)
	lib.isPlaying = true
