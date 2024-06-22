extends FPController

class_name Player

# vars grabbing things from Player scene

@onready var camera : Camera3D = $Head/Camera3D
@onready var anim_player : AnimationPlayer = $Head/Camera3D/AnimationPlayer

@onready var raycast : RayCast3D = $Head/Raycast
@onready var hitbox : Area3D = $Head/PlayerHitbox

## HARDCODED PARAMETERS

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
	# Set head node for FPController
	head = get_node("Head")
	# Set animation controller for FPController
	animation_controller = get_node("Head/Camera3D/AnimationPlayer")
	# Prevents selecting self when doing functions with raycast
	raycast.add_exception(hitbox)


func _process(delta):
	super(delta) # Run the process function for FPController

func _unhandled_input(event):
	super(event) # Run input function for FPController
	
	# Perform use checks
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
