extends VFlowContainer

#------------------------------------------------------------------------------#
signal choice

# Resource.
var _choiceRes: Resource = load("res://assets/godot/scn/arcTemplates/buttons/choice.tscn")

#------------------------------------------------------------------------------#
# Access.
# Dynamically create buttons for choices and return the one that the player chooses.
func createChoices(choices: Array) -> Array:
	var _output: Array = []
	
	# Remove all choices.
	for _i in get_children():
		_i.queue_free()
	
	# Create buttons.
	for _i in range(choices.size()):
		var _choice: Button = _choiceRes.instantiate()
		
		_choice.set_text(choices[_i][0])
		_choice.pressed.connect(func(): 
			_output.append_array(choices[_i])
			choice.emit()
		)
		
		add_child(_choice)
	
	# Wait for user to pick a choice.
	await choice
	return _output
