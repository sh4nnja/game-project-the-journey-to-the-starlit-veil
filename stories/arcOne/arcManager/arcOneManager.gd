# The story arc script of protagonist's arc.

extends Node2D

static var _story_details: Dictionary = {
	"name": "Through Eyes Unseen",
	"sub-name": "I. Falling Through",
	"desc": """
		Would you open your eyes to face life’s uncertainties, or keep them shut to endure the unknown?
		
		The path ahead is fractured, memories slipping through your grasp like falling stars. You don’t know what awaits, but then again, do we ever?
		
		Step into a realm where regret takes form, choices shape reality, and the past beckons to be remembered… or erased. 
		
		Are you ready to face it?
"""
}

static func getStoryDetails() -> Dictionary:
	return _story_details

static func getStoryName() -> String:
	return _story_details["name"]

static func getStorySubName() -> String:
	return _story_details["sub-name"]

static func getStoryDesc() -> String:
	return _story_details["desc"]

#------------------------------------------------------------------------------#

@onready var _ui_anim: AnimationPlayer = get_node("uiLayer/uiAnim")

func _ready() -> void:
	if get_parent() == get_tree().root:
		startArc()

func editCursorVisibility(showCursor: bool) -> void:
	lib.editCursorVisibility(showCursor)

func startArc() -> void:
	get_node("assets/player/trail/camera").set_enabled(true)
	_ui_anim.play("arcFade")
	await _ui_anim.animation_finished
	lib.gameplayEnabled = true
	get_node("assets/sceneMngr").set_active(true)
