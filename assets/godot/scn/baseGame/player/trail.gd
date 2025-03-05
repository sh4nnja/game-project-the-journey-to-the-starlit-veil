extends CharacterBody2D

@onready var camera: Camera2D = get_node("camera")
#------------------------------------------------------------------------------#
# Movement.
const SPEED: float = 200.0
const DECELERATION: float = 15.0
var _vel: Vector2 = Vector2.ZERO 

#------------------------------------------------------------------------------#
func _physics_process(_delta: float) -> void:
	_manageMovement(_delta)

#------------------------------------------------------------------------------#
# Custom.
func _manageMovement(_delta: float) -> void:
	_vel = Vector2.ZERO
	
	# Take note of the movement.
	# Movement left to right.
	if Input.is_action_pressed("click") and lib.canInteract:
		_vel = get_global_mouse_position() - get_global_position()
	
	# Calculate target velocity based on input
	var targetVelocity = _vel.normalized() * SPEED
	
	# If there's no input, apply deceleration
	if _vel.length() == 0:
		# Smoothly reduce velocity towards zero
		velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * _delta)
	else:
		# When there is input, accelerate towards the target velocity
		velocity = velocity.move_toward(targetVelocity, SPEED * _delta)
	
	move_and_slide()
