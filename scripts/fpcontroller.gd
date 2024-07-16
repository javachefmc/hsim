# Handles player physics

extends CharacterBody3D
class_name FPController

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# HARDCODED PARAMETERS

# translation
const SPEED : float = 3.0
const RUN_MULT : float = 1.75
const JUMP_VELOCITY : float = 4.5
const ACCEL : float = 0.1
const FRICTION : float = 0.3
const AIR_RESISTANCE : float = 0.05

# rotation
@export var rotation_target : Vector3
var rotation_smooth : Vector3
const rotation_speed : float = 0.004
const rotation_damp : float = 30
var allow_smooth_rotation : bool = true

# NEEDS TO BE SET AT RUNTIME

@onready var head : Node3D
@onready var animation_controller : AnimationPlayer

@export var player_id : int = 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

func _process(delta : float) -> void:
	# apply this on server side only.
	if multiplayer.is_server():
		_apply_movement_from_input(delta)
	
	# HACK. GET RID OF THIS
	if(position.y <= -100):
		position = Vector3(0,5,0)
		velocity = Vector3(0,0,0)
		rotation_target = Vector3(0,0,0)
	
func _unhandled_input(event : InputEvent) -> void:
	# Calculate camera rotation
	
	# we need to separate this from client and server
	if multiplayer.is_server():
		if event is InputEventMouseMotion:
			rotation_target.x -= event.relative.y * rotation_speed
			rotation_target.x = clamp(rotation_target.x, -PI/2, PI/2)
			rotation_target.y -= event.relative.x * rotation_speed

func set_rotation_immediate(rotation_to_set : Vector3) -> void:
	# sets rotation on teleports to avoid camera whipping 
	pause_rotation_smoothing()
	var timer := get_tree().create_timer(0.3, false)
	timer.connect("timeout", resume_rotation_smoothing)
	rotation_target = rotation_to_set

func pause_rotation_smoothing() -> void:
	allow_smooth_rotation = false
	
func resume_rotation_smoothing() -> void:
	allow_smooth_rotation = true

func _apply_movement_from_input(delta) -> void:
	# WARNING: this is unused?
	var movement_speed := SPEED
	var running := false
	
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
	
	var input_dir : Vector2 = %InputSynchronizer.input_direction
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
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
	
	if !multiplayer.is_server():
		rotation_target = %PlayerSynchronizer.rotation_target
	
	# Calculate look direction smoothly
	if allow_smooth_rotation:
		rotation_smooth = rotation_smooth.lerp(rotation_target, delta * rotation_damp)
	else:
		rotation_smooth = rotation_target
	
	# Rotate character head and body. x: up-down, y: left-right
	head.rotation.x = rotation_smooth.x
	rotation.y = rotation_smooth.y
	
