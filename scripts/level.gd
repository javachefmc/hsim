extends Node

class_name Level

var player = Player.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
