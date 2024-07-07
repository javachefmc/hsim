# This script may be attached to any level root.
# Handles creation of initial player, setting start position, and general level start tasks

extends Node

class_name Level

@export var playerScene : PackedScene
@export var start_pos : Vector3

@export var pausable : bool = true
var paused : bool = false

var player : Player

@onready var environment : EnvironmentSystem = $EnvironmentSystem

func _ready():
	# instantiate and create a player
	player = playerScene.instantiate()
	$Players.add_child(player)
	
	# set player position to start pos
	player.position = start_pos
	
	# capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

