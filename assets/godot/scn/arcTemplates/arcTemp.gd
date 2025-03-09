extends Node2D
class_name ArcTemplate
#------------------------------------------------------------------------------#

var storyDetails: Dictionary = {
	# Arc details.
	"name": "Arc Title",
	"sub-name": "Chapter # | Chapter Title",
	"desc": """
		Hi there developer!
		
		If you are having time creating your own custom story, just remember that
		you can message me. Thanks!
		
		Create stories that can open minds and hearts.
		Happy modding.
""",
	
	# Player info.
	"playerName": "Player",
	"playerEmotions": emotions
}

var emotions = {

}

#------------------------------------------------------------------------------#
# Story details.
func getStoryDetails() -> Dictionary:
	return storyDetails

func getStoryName() -> String:
	return storyDetails["name"]

func getStorySubName() -> String:
	return storyDetails["sub-name"]

func getStoryDesc() -> String:
	return storyDetails["desc"]

#------------------------------------------------------------------------------#
# Emotions
func setEmotions(values: Array) -> void:
	values.pop_front()
	for _emotion in values:
		if emotions.has(_emotion[0]):
			emotions[_emotion[0]] += _emotion[1]

#------------------------------------------------------------------------------#
func editCursorVisibility(showCursor: bool) -> void:
	lib.editCursorVisibility(showCursor)
