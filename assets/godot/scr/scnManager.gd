# Responsible for loading the scenes for the main game.
# 2 Main scenes are located.
# -> Game Proper (Main game, space background and stuff, no arc loaded)
# -> Main menu Proper (Loading arcs, game loop from main menu to game to exit)

extends Node
#------------------------------------------------------------------------------#
# Scene paths here.
var _gameProperPath: String = "res://assets/godot/scn/baseGame/gameProper/gameProper.tscn"
var _uiMenuPath: String = "res://assets/godot/scn/baseGame/gameMainMenu/gameMainMenu.tscn"

#------------------------------------------------------------------------------#
# Scene Nodes.
var _uiNode: Node = null
var _gameProper: Node = null

#------------------------------------------------------------------------------#
# Game initiation.
func _ready() -> void:
	# IGNORE: Debug
	print("Initiated PseudoTree ", self, " Initiating scene loading.")
	
	# Load mainmenu and game proper to be added to scene.
	_uiNode = _loadScnRes(_checkResource(_uiMenuPath))
	_gameProper = _loadScnRes(_checkResource(_gameProperPath))
	
	# Find stories available and store their data.
	searchStoryArcs()
	
	# Await to load the scenes.
	await _uiNode.tree_entered
	await _uiNode.ready
	await _gameProper.tree_entered
	await _gameProper.ready
	
	# Load mindscape.
	_gameProper.getMindscape().loadSpaceSector()

#------------------------------------------------------------------------------#
# SCENE LOADERS...
# Check and load resource first then add to pseudotree. Print error if null.
func _loadScnRes(_object: Resource) -> Node:
	var _node: Node = null
	if _object != null:
		_node = _object.instantiate()
		# IGNORE: Debug
		print("Adding object ", _object, " as a child of PseudoTree ", self)
		call_deferred("add_child", _node)
		# IGNORE: Debug
		print("Adding object ", _node, " is successful.")
		print("#------------------------------------------------------------------------------#")
		
	else:
		# IGNORE: Debug
		print("Resource null. Loading failed.")
		print("#------------------------------------------------------------------------------#")
	
	return _node

#------------------------------------------------------------------------------##
# RESOURCE LOADERS (ARC Loaders)...
func searchStoryArcs(path: String = "stories/"):
	var _dir = DirAccess.open(path)
	
	# IGNORE: Debug
	print("\nInitiating story arc searching...")
	
	if _dir:
		_dir.list_dir_begin()
		var _fileName = _dir.get_next()
		var _hasContent = false
		while _fileName != "":
			if _dir.current_is_dir():
				print("    Found directory: " + _fileName)
				
				# TODO: Check folder. 
				var _subdirPath = path + "/" + _fileName + "/arcManager"
				var _subdir = DirAccess.open(_subdirPath)
				
				if _subdir:
					print("        Checking file integrity...")
					
					_subdir.list_dir_begin()
					
					var _subFile = _subdir.get_next()
					
					while _subFile != "":
						if _subFile.ends_with(".tscn"):  # Check if a script file exists
							print("            Checking values...")
							print("            Found content: " + _subFile + " in " + _fileName + "/arcManager")
							break
						
						_subFile = _subdir.get_next()
					
					# Update lib.
					var _scr = load(path + "/" + _fileName + "/" + "arcManager/" + _subFile).instantiate()
					lib.availableArcs[_fileName] = _scr.getStoryDetails()
					lib.availableArcs[_fileName]["file"] = "stories/" + _fileName + "/arcManager/arcManager.tscn"
					_scr = null
					
					lib.arcLoaded = true
					
					_subdir.list_dir_end()
				
				else:
					print("        arcManager folder missing or inaccessible.")
				
				_hasContent = true
				
				print("        Story arc file " + _fileName + " is successfully read...")
			
			_fileName = _dir.get_next()
		
		if not _hasContent:
			print("    Empty folder. No story arcs loaded.")
	
	else:
		print("Error. No stories folder present...")
	
	print("Scan Complete.")
	print("#------------------------------------------------------------------------------#")

#------------------------------------------------------------------------------#
# Tools.
func _checkResource(_scnPath: String) -> Resource:
	# Progress bar in array to track loading progress.
	var _scnProgress: Array[float] = []
	
	# Limiter to stop loader on spamming a lot of 0 on loading.
	var _scnCountPointer: float = -1
	var _scnStatus: int = 1
	var _scnOutput: Resource
	
	# IGNORE: Debug
	print("\nInitiating loading resource via string path: ", _scnPath)
	
	# IMPORTANT CODE: Load the scene files via resource loader to facilitate loading on progress bar.
	ResourceLoader.load_threaded_request(_scnPath)
	
	# IGNORE: Debug
	print("Proceeding to load ", _scnPath)
	
	# IMPORTANT CODE: Function 'match' checks for identifying status for visual output.
	while true:
		match _scnStatus:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				_scnStatus = ResourceLoader.load_threaded_get_status(_scnPath, _scnProgress)
				# Prevents repetitive percent spamming.
				var _currProgress: float = snapped(_scnProgress[0] * 100, 0.01)
				# If pointer is not the same as the progress, it saves and print the value.
				if _currProgress != _scnCountPointer:
					# IGNORE: Debug
					print("    Loading ", _scnPath, " Progress: ", _currProgress, "%")
					_scnCountPointer = _currProgress
			
			ResourceLoader.THREAD_LOAD_LOADED:
				# IGNORE: Debug
				print("Loaded ", _scnPath)
				break
			
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				# IGNORE: Debug
				print("Loading ", _scnPath, " has failed. Invalid Resource.")
				_scnOutput = null
				break
	
	_scnOutput =  ResourceLoader.load_threaded_get(_scnPath)
	return _scnOutput

#------------------------------------------------------------------------------#
# Quit the game.
func quitGame() -> void:
	get_tree().quit()
