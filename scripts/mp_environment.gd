extends MultiplayerSynchronizer

@export var time : int

# Called when the node enters the scene tree for the first time.
func _ready():
	# If server, disable process and physics process
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
