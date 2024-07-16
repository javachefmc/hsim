# Server side authority for player movement

extends MultiplayerSynchronizer

@export var input_direction : Vector2 = Vector2(0.0, 0.0)
@export var rotation_target : Vector3

func _ready() -> void:
	# If server, disable process and physics process
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	
func _physics_process(delta : float) -> void:
	# Set the effective keypress inputs
	input_direction = Input.get_vector("left", "right", "forward", "backward")

func _unhandled_input(event : InputEvent) -> void:
	# Calculate camera rotation
	if event is InputEventMouseMotion:
		rotation_target.x -= event.relative.y * FPController.rotation_speed
		rotation_target.x = clamp(rotation_target.x, -PI/2, PI/2)
		rotation_target.y -= event.relative.x * FPController.rotation_speed
