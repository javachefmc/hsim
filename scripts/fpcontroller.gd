# Handles player physics

extends CharacterBody3D

class_name FPController

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# HARDCODED PARAMETERS

# translation
const SPEED = 3.0
const RUN_MULT = 1.75
const JUMP_VELOCITY = 4.5
const ACCEL = 0.1
const FRICTION = 0.3
const AIR_RESISTANCE = 0.05

# rotation
var rotation_target : Vector3
var rotation_smooth : Vector3
const rotation_speed = 0.004
const rotation_damp = 30

# NEEDS TO BE SET AT RUNTIME

@onready var head : Node3D
@onready var animation_controller : AnimationPlayer

@export var player_id : int = 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

func _process(delta):
	# apply this on server side only.
	if multiplayer.is_server():
		_apply_movement_from_input(delta)
	
func _unhandled_input(event):
	# Calculate camera rotation
	
	# we need to separate this from client and server
	if multiplayer.is_server():
		if event is InputEventMouseMotion:
			rotation_target.x -= event.relative.y * rotation_speed
			rotation_target.x = clamp(rotation_target.x, -PI/2, PI/2)
			rotation_target.y -= event.relative.x * rotation_speed

func _apply_movement_from_input(delta):
	var movement_speed = SPEED;
	var running = false;
	
	# Adjust speed if running
	if Input.is_action_pressed("run"):
		running = true
		movement_speed = SPEED * RUN_MULT
	
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = %InputSynchronizer.input_direction
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Player is inputting movement controls
	if direction:
		velocity.x = lerp(velocity.x, direction.x * movement_speed, ACCEL)
		velocity.z = lerp(velocity.z, direction.z * movement_speed, ACCEL)
		animation_controller.play("run") if running else animation_controller.play("view_bobbing")
		# animation player should be calculated when player actually moves rather than input controls
	else:
		animation_controller.stop()
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, FRICTION)
			velocity.z = lerp(velocity.z, 0.0, FRICTION)
		else:
			velocity.x = lerp(velocity.x, 0.0, AIR_RESISTANCE)
			velocity.z = lerp(velocity.z, 0.0, AIR_RESISTANCE)
			
	move_and_slide()
	
	# Calculate look direction smoothly
	rotation_smooth = rotation_smooth.lerp(rotation_target, delta * rotation_damp)
	# Rotate character head and body. x: up-down, y: left-right
	head.rotation.x = rotation_smooth.x
	rotation.y = rotation_smooth.y
	
