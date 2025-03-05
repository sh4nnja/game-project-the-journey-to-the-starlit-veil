# Responsible for changing the games environment based on commands from the loaded arc.
# Direct change code for environment and others are located here.
# Responsible for animations of the mindscape.

extends Node2D

#------------------------------------------------------------------------------#
# Accessor to the main game proper's scene changer.
var game: Node2D = get_parent()

#------------------------------------------------------------------------------#

# Check if there's an arc loaded and start it.
func loadArc(arc_scene: String):
	if get_child_count() == 0:
		var _arc: Object = load(arc_scene).instantiate()
		add_child(_arc)
		_arc.startArc()
	
	else:
		print("Critical Error, there's an unusual file currently at the manager. \nIts: " + str(get_child(0)))
