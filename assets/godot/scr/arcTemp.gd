extends Node2D
class_name ArcTemplate

var storyDetails: Dictionary = {
	"name": "Arc Title",
	"sub-name": "Chapter # | Chapter Title",
	"desc": """
		Hi there developer!
		
		If you are having time creating your own custom story, just remember that
		you can message me. Thanks!
		
		Create stories that can open minds and hearts.
		Happy modding.
"""
}

func getStoryDetails() -> Dictionary:
	return storyDetails

func getStoryName() -> String:
	return storyDetails["name"]

func getStorySubName() -> String:
	return storyDetails["sub-name"]

func getStoryDesc() -> String:
	return storyDetails["desc"]

func editCursorVisibility(showCursor: bool) -> void:
	lib.editCursorVisibility(showCursor)
