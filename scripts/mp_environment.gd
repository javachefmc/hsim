# Attaches to environment system to synchronize time

extends MultiplayerSynchronizer

# Time calculations on server side
@export var time : float
@export var day_length : float = 200
@export var start_time : float = 0.5
var time_rate : float = 1 / day_length

func _ready():
	# If server, disable process and physics process
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		#set_process(false)
		set_physics_process(false)
		print("mp_environment detected server authority")
	
	if multiplayer.is_server():
		time = start_time
		print("mp_environment detected main thread")

func _process(delta):
	if multiplayer.is_server():
		time += time_rate * delta
		if time > 1:
			time = 0
