extends Node2D
#------------------------------------------------------------------------------#
@onready var _stars: CPUParticles2D = get_node("spacePllxMngr/spaceBgPllx/stars")
@onready var _star_timer: Timer = get_node("spacePllxMngr/spaceBgPllx/stars/timer")

var _spaceBgTexture: NoiseTexture2D 
var _spaceGasTex: NoiseTexture2D
var _spaceGasTex1: NoiseTexture2D
var _spaceGasTex2: NoiseTexture2D

#------------------------------------------------------------------------------#
var _spaceGenThread: Thread

# Initiation of textures.
var _spaceAsstsIdx: int = 1

#------------------------------------------------------------------------------#
# Default space generation on start (Without "spaceSectorManager.tscn", scene manager). 
# Check "lib.gd" -> CONFIGURATION section for default values. 
func _ready() -> void:
	# Change "lockDef" to true when you want to maintain default configuration.
	# "lockDef" will run if you started this scene as standalone (Without "spaceSectorManager.tscn", scene manager).
	var lockDef: bool = false
	if lockDef or get_parent() == get_tree().root:
		loadThread(
			[
				[
					lib.genRand(lib.minSpawnSeed, lib.maxSpawnSeed), 
					lib.genRandColor(),
					lib.genRandColor(),
					lib.genRandColor(),
					lib.genRandColor(),
					lib.genRand(1, 2)
				]
			]
		)
	
	_stars.set_speed_scale(1)
	_star_timer.start(lib.genRand(1, 9))

# Kills the thread when scene exits the tree.
# IMPORTANT CODE: Its a must do to prevent warning and potential crash.
func _exit_tree():
	# Deleting Generation Thread.
	_spaceGenThread = null

#------------------------------------------------------------------------------#
# IMPORTANT CODE: Load a thread for facilitating background loading
func loadThread(spaceArray: Array) -> void:
	# IGNORE: Debug
	print("Creating thread for background texture loading...")
	
	# IMPORTANT CODE: Checking if other "spaceGenerationThreads" are active
	if is_instance_valid(_spaceGenThread) and _spaceGenThread.is_started():
		_spaceGenThread.wait_to_finish()
	
	# Create a new thread.
	_spaceGenThread = Thread.new()
	
	# IGNORE: Debug
	print("Thread ", _spaceGenThread, " has been created!\n")
	
	# Initiation of textures. Loading the texture will be done in the thread.
	_spaceBgTexture = NoiseTexture2D.new()
	_spaceGasTex = NoiseTexture2D.new()
	_spaceGasTex1 = NoiseTexture2D.new()
	_spaceGasTex2 = NoiseTexture2D.new()
	
	get_node("spacePllxMngr/spaceBgPllx/spaceBgTex").texture = _spaceBgTexture
	get_node("spacePllxMngr/spaceGPllx/spaceGasTex").texture = _spaceGasTex
	get_node("spacePllxMngr/spaceG1Pllx/spaceGasTex1").texture = _spaceGasTex1
	get_node("spacePllxMngr/spaceG2Pllx/spaceGasTex2").texture = _spaceGasTex2
	
	get_node("spacePllxMngr/spaceGPllx/spaceGasTex").modulate = spaceArray[0][2]
	get_node("spacePllxMngr/spaceG1Pllx/spaceGasTex1").modulate = spaceArray[0][3]
	get_node("spacePllxMngr/spaceG2Pllx/spaceGasTex2").modulate = spaceArray[0][4]
	
	# Append the textures in an array to be send in the thread.
	spaceArray.append([_spaceBgTexture, _spaceGasTex, _spaceGasTex1, _spaceGasTex2])
	
	# Proceed to the thread function
	_spaceGenThread.start(_genSpace.bind(spaceArray))
	
	# IGNORE: Debug
	print("Printing array contents to be sent in thread ", _spaceGenThread, ": ", spaceArray)
	# IGNORE: Debug
	print("\nLoading space background textures in the thread...")
	
	# Load the stars.
	_star_timer.start(lib.genRand(1, 9))

# IMPORTANT CODE: Thread Function for background space generation. 
func _genSpace(spaceArray: Array) -> void:
	# IGNORE: Debug
	print("\nThread function initiated!\n")
	print("Generating textures now.")
	
	# Loop basic information to the textures.
	for _spaceTextureGenerationIteration in range(4):
		# Creating the default configuration of the textures.
		spaceArray[1][_spaceTextureGenerationIteration].width = lib.sectSize
		spaceArray[1][_spaceTextureGenerationIteration].height = lib.sectSize
		# IGNORE: Debug
		print("    Generated a space texture! ", spaceArray[1][_spaceTextureGenerationIteration])
		
		# Creates a standard color ramp and noise object to assign in the texture.
		var _spaceTexColorRamp: Gradient = Gradient.new()
		spaceArray[1][_spaceTextureGenerationIteration].color_ramp = _spaceTexColorRamp
		_spaceTexColorRamp.offsets = [0.5, 1]
		_spaceTexColorRamp.colors = [Color.TRANSPARENT, Color.WHITE]
		_spaceTexColorRamp.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CUBIC
		# IGNORE: Debug
		print("    Generated color ramp! ", _spaceTexColorRamp)
		
		var _spaceTexNoise: FastNoiseLite = FastNoiseLite.new()
		spaceArray[1][_spaceTextureGenerationIteration].noise = _spaceTexNoise
		_spaceTexNoise.seed = spaceArray[0][0]
		_spaceTexNoise.fractal_octaves = 10
		# IGNORE: Debug
		print("    Generated noise! ", _spaceTexNoise)
		
		# Configure the adjustments per texture.
		# IMPORTANT CODE: Print statements per index is necessary for debugging and MUST NOT be removed.
		# IMPORTANT CODE: It checks for what texture has failed loading as threads don't receive error messages.
		if _spaceAsstsIdx == 1:
			# Space background generation.
			_spaceTexNoise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
			_spaceTexColorRamp.offsets = [0, 5]
			_spaceTexColorRamp.colors = [Color.TRANSPARENT, spaceArray[0][1]]
			# IGNORE: Debug
			print("    Adjusted space background texture! ", spaceArray[1][_spaceTextureGenerationIteration])
		
		elif _spaceAsstsIdx in range(2, 5):  
			# Space gases generation.
			# Decide to show texture or not.
			if spaceArray[0][_spaceAsstsIdx] != "00000000":
				# Adjusts texture based on index.
				if _spaceAsstsIdx == 2:
					_spaceTexNoise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
				elif _spaceAsstsIdx == 3: 
					_spaceTexNoise.noise_type = FastNoiseLite.TYPE_PERLIN
				elif _spaceAsstsIdx == 4:
					_spaceTexNoise.noise_type = FastNoiseLite.TYPE_PERLIN
					_spaceTexColorRamp.offsets = [0.25, 1]
			
			else:
				# Removes the objects in texture if texture is not visible to save memory.
				spaceArray[1][_spaceTextureGenerationIteration].noise = null
				spaceArray[1][_spaceTextureGenerationIteration].color_ramp = null
				# IGNORE: Debug
				print("    Queue Free'd' a texture because modulate is 0. ", spaceArray[1][_spaceTextureGenerationIteration])
			
			print("    Adjusted a space gas texture! ", spaceArray[1][_spaceTextureGenerationIteration], " Index: ", _spaceAsstsIdx, "\n")
		_spaceAsstsIdx += 1
		
		# Removes objects from variable so when set the main texture to null, they will also be changed to null.
		_spaceTexNoise = null
		_spaceTexColorRamp = null
	
	# IGNORE: Debug
	print("Loaded space sector! Visually adjusting now. Thread ", _spaceGenThread, " will be terminated.")
	print("#------------------------------------------------------------------------------#")
	_spaceAsstsIdx = 1

# Reverting textures first in the nodes before generating another.
# IMPORTANT CODE: This is a must do due to space sector generation mechanic on menu.
func revertSpaceTexturesToDefault() -> void:
	# IGNORE: Debug
	print("Texture of space generation nodes has been cleared.")
	
	_spaceBgTexture = null
	_spaceGasTex = null
	_spaceGasTex1 = null
	_spaceGasTex2 = null
	
	get_node("spacePllxMngr/spaceBgPllx/spaceBgTex").texture = null
	get_node("spacePllxMngr/spaceGPllx/spaceGasTex").texture = null
	get_node("spacePllxMngr/spaceG1Pllx/spaceGasTex1").texture = null
	get_node("spacePllxMngr/spaceG2Pllx/spaceGasTex2").texture = null
	get_node("spacePllxMngr/spaceGPllx/spaceGasTex").modulate = Color(1, 1, 1, 1)
	get_node("spacePllxMngr/spaceG1Pllx/spaceGasTex1").modulate = Color(1, 1, 1, 1)
	get_node("spacePllxMngr/spaceG2Pllx/spaceGasTex2").modulate = Color(1, 1, 1, 1)

# Clear Threads.
func clearSpaceGenThreads() -> void:
	# IGNORE: Debug
	print("Cleared and removed space generation thread properly.")
	
	# Dispose thread.
	_spaceGenThread.wait_to_finish()
	
	# Clear textures.
	revertSpaceTexturesToDefault()

#------------------------------------------------------------------------------#
# Edit the gas colors.
func editSpaceGasColor(gas: int = 0, gasColor: Color = Color(1, 1, 1, 1)) -> void:
	var _gases: Array = [
		get_node("spacePllxMngr/spaceGPllx/spaceGasTex"),
		get_node("spacePllxMngr/spaceG1Pllx/spaceGasTex1"),
		get_node("spacePllxMngr/spaceG2Pllx/spaceGasTex2")
	]
	
	var _tween: Tween = create_tween()
	_tween.tween_property(_gases[gas], "modulate", gasColor, 5).set_ease(Tween.EASE_IN_OUT)

# Set the mindscape's opacity to value.
func mindscapeSetOpacity(value: float, includeStars: bool = false, immediate: bool = false) -> void:
	var _tween: Tween = create_tween()
	var _time: float = 0.5
	
	if immediate:
		_time = 0.0
	
	for _tex in [
		get_node("spacePllxMngr/spaceBgPllx/spaceBgTex"),
		get_node("spacePllxMngr/spaceGPllx/spaceGasTex"),
		get_node("spacePllxMngr/spaceG1Pllx/spaceGasTex1"),
		get_node("spacePllxMngr/spaceG2Pllx/spaceGasTex2")
	]:
		_tween.tween_property(_tex, "modulate:a", value, _time)
	
	if includeStars:
		_tween.tween_property(_stars, "modulate:a", value, _time)

func _on_timer_timeout() -> void:
	_stars.set_speed_scale(0)
