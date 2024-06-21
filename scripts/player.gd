extends FPController

class_name Player

# vars grabbing things from Player scene

@onready var camera : Camera3D = $Camera3D
@onready var anim_player : AnimationPlayer = $Camera3D/AnimationPlayer

@onready var raycast : RayCast3D = $Camera3D/Raycast
@onready var hitbox : Area3D = $Camera3D/PlayerHitbox

## HARDCODED PARAMETERS

# rotation
var rotation_target : Vector3
var rotation_smooth : Vector3
const rotation_speed = 0.004
const rotation_damp = 30

## ATTRIBUTES

#const maxHealth : int = 100

## adjustable parameters

@export var health : int = 100
@export var food : int
@export var water : int
@export var energy : int 

## SIGNALS

signal healthChanged

func _ready():
	# Prevents selecting self when doing functions with raycast
	raycast.add_exception(hitbox)


func _process(delta):
	super(delta) # Run the process function for FPController
	
	# Calculate look direction smoothly
	rotation_smooth = rotation_smooth.lerp(rotation_target, delta * rotation_damp)
	# Rotate character left-right
	rotation.y = rotation_smooth.y
	# Rotate camera up-down
	camera.rotation.x = rotation_smooth.x

func _unhandled_input(event):
	# Calculate camera rotation
	if event is InputEventMouseMotion:
		rotation_target.x -= event.relative.y * rotation_speed
		rotation_target.x = clamp(rotation_target.x, -PI/2, PI/2)
		rotation_target.y -= event.relative.x * rotation_speed
	
	# Perform all use checks
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
