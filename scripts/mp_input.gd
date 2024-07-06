extends MultiplayerSynchronizer

@export var input_direction : Vector2 = Vector2(0.0, 0.0)

func _ready():
	# If server, disable process and physics process
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	
func _physics_process(delta):
	# Set the effective keypress inputs
	input_direction = Input.get_vector("left", "right", "forward", "backward")

func _process(delta):
	pass
