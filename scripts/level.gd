# This script may be attached to any level root.
# Handles creation of initial player, setting start position, and general level start tasks

extends Node
class_name Level

@export var start_pos : Vector3 = Vector3(-34, 0, -26)
@export var start_rot : Vector3 = Vector3(-0.1*PI, PI, 0)

@export var pausable : bool = true
var paused : bool = false

var player : Player

@onready var environment : EnvironmentSystem = $EnvironmentSystem
var start_time = 0.3

func _ready() -> void:
	# instantiate and create a player
	player = load("res://scenes/player.tscn").instantiate()
	$Players.add_child(player)
	
	# set player position to start pos
	player.position = start_pos
	player.set_rotation_immediate(start_rot)
	
	# capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	environment.set_time(start_time)

