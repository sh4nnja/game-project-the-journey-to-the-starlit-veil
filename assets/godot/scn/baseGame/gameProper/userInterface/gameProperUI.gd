# Responsible for pausing and other UI elements.

extends Control
#------------------------------------------------------------------------------#
# Nodes.
@onready var _uiAnim: AnimationPlayer = get_node("uiAnim")

var paused: bool = false

#------------------------------------------------------------------------------#
func _unhandled_input(_event: InputEvent) -> void:
	# Pause mechanic.
	if _event is InputEventKey:
		if _event.keycode == KEY_ESCAPE and _event.pressed and lib.isPlaying:
			if paused:
				paused = false
				_uiAnim.play_backwards("pause")
			else:
				paused = true
				_uiAnim.play("pause")
			get_tree().paused = paused
