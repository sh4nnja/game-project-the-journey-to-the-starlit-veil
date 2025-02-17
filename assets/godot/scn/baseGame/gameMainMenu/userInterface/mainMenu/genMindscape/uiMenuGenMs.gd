# Randomize mindscapes.

extends Button
#------------------------------------------------------------------------------#

@onready var uiMenuGenMindscapeAnimation: AnimationPlayer = get_node("uiMenuGenMindscapeAnimation")
@onready var uiMenuGenMindscapeSFX: AudioStreamPlayer = get_node("uiMenuGenMindscapeSFX")

#------------------------------------------------------------------------------#
signal discoverMindscape

#------------------------------------------------------------------------------#
# Play hover animation button when mouse entered button.
func _whenMouseEnteredButton() -> void:
	if not disabled:
		uiMenuGenMindscapeAnimation.play("uiMenuGenerateHovered")
		uiMenuGenMindscapeSFX.play()

# Play hover animation button when mouse exits button.
func _whenMouseExitedButton() -> void:
	if not disabled:
		uiMenuGenMindscapeAnimation.play_backwards("uiMenuGenerateHovered")

# Emit signal to main menu manager.
func _whenMousePressed() -> void:
	uiMenuGenMindscapeAnimation.play_backwards("uiMenuGenerateHovered")
	# IGNORE: Debug
	print("\n#------------------------------------------------------------------------------#\nGenerate new sector option selected.")
	discoverMindscape.emit()
	
	# FORMAT: Release focus on the button.
	release_focus()
