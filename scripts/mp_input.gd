extends MultiplayerSynchronizer


var input_direction

func _ready():
	input_direction = Input.get_vector("left", "right", "forward", "backward")


func _physics_process(delta):
	pass
