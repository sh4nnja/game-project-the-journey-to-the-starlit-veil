# Load game arcs and store most important information here that is not common.
# If common, put in lib singleton.
# Save the played arcs and scores in file.
# Probably put here the loading and saving features.

extends Node2D
#------------------------------------------------------------------------------#
@onready var _spaceSector: Node2D = get_node("mindscape/spaceSectorManager")

#------------------------------------------------------------------------------#
func getMindscape() -> Node2D:
	return _spaceSector

#------------------------------------------------------------------------------#
