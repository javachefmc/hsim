extends CharacterBody3D

class_name Player

# vars grabbing things from scene

@onready var camera : Camera3D = $Camera3D
@onready var anim_player : AnimationPlayer = $Camera3D/AnimationPlayer

@onready var raycast : RayCast3D = $Camera3D/Raycast
@onready var hitbox : Area3D = $Camera3D/PlayerHitbox

## HARDCODED PARAMETERS

# PLAYER MOVEMENT

# translation
const SPEED = 2.5
const RUN_MULT = 2
const JUMP_VELOCITY = 4.5
const ACCEL = 0.1
const FRICTION = 0.3
const AIR_RESISTANCE = 0.05

# rotation
var rotation_target : Vector3
var rotation_smooth : Vector3
var rotation_speed = 0.004
var rotation_damp = 30

## ATTRIBUTES

const maxHealth : int = 100

## adjustable parameters

@export var health : int = maxHealth
@export var food : int
@export var water : int
@export var energy : int 

## SIGNALS

signal healthChanged

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const paused = false

func _ready():
	# Lock the mouse to the window center
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Prevents selecting self when doing functions with raycast
	raycast.add_exception(hitbox)

func _process(delta):
	
	# Calculate look direction smoothly
	rotation_smooth = rotation_smooth.lerp(rotation_target, delta * rotation_damp)
	# Rotate whole character left-right
	rotation.y = rotation_smooth.y
	# Rotate just camera up-down
	camera.rotation.x = rotation_smooth.x
	
	var movement_speed = SPEED;
	
	# Adjust speed if running
	if Input.is_action_pressed("run"):
		movement_speed = SPEED * RUN_MULT
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Player is inputting movement controls
	if direction:
		velocity.x = lerp(velocity.x, direction.x * movement_speed, ACCEL)
		velocity.z = lerp(velocity.z, direction.z * movement_speed, ACCEL)
		#anim_player.play("view_bobbing")
		# animation player should be calculated when player actually moves rather than input controls
	else:
		#anim_player.stop()
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, FRICTION)
			velocity.z = lerp(velocity.z, 0.0, FRICTION)
		else:
			velocity.x = lerp(velocity.x, 0.0, AIR_RESISTANCE)
			velocity.z = lerp(velocity.z, 0.0, AIR_RESISTANCE)
			
	move_and_slide()

# Calculate camera rotation
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_target.x -= event.relative.y * rotation_speed
		rotation_target.x = clamp(rotation_target.x, -PI/2, PI/2)
		rotation_target.y -= event.relative.x * rotation_speed
	if Input.is_action_just_pressed("use"):
		pick_object()

func pick_object():
	var collider = raycast.get_collider()
	if collider != null and collider is Area3D:
		print("picking object")
		collider.get_parent().collect()
		# Add collector here to determine what to do with collected item

func damage(amount):
	health -= amount
	healthChanged.emit()
