# Global game functions

extends Node

var current_scene = null

# If/when multiplayer is developed, these variables will be important
var canChangeScenes = true
var canQuit = true

var scene_cache := []

signal game_start

#@onready var main_menu : PackedScene = preload("res://gui/main_menu.tscn")
#@onready var level_main : PackedScene = preload("res://scenes/level_00.tscn")

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func load_scene(path):
	call_deferred("_load_scene_manual", path)
	
func _load_scene_manual(path):
	var scene : Node = get_current_scene()
	get_tree().root.add_child(load(path).instantiate())
	scene.queue_free()

func _load_scene_immediate(path):
	# While this works without bugs, it causes a gray flash
	get_tree().change_scene_to_file(path)

func _load_scene_staged(next_scene):
	var resource_loader = ResourceLoader.load_threaded_request(next_scene)
	
	# check for errors
	if resource_loader == null:
		print("Error occurred while switching scenes")
		return
	
	# WARNING: infinite loop! replace with something that can timeout
	
	while true:
		var error = ResourceLoader.load_threaded_get_status(next_scene)
		#eventually we will get something else
		if error == 1:
			#update progress bar
			pass
		elif error == 3:
			# supposedly this is when loaded
			var scene = ResourceLoader.load_threaded_get(next_scene)
			get_tree().change_scene_to_packed(scene)
			return
		else:
			print("Error occurred during infinite loop")
			return

func _load_scene_packed(scene):
	scene.instantiate()
	get_tree().change_scene_to_packed(scene)

func start_game():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	game_start.emit()
	await get_tree().create_timer(0.3).timeout
	
	load_scene("res://scenes/level_00.tscn")
	#_load_scene_packed(level_main)

func try_quit_to_title():
	if canChangeScenes:
		load_scene("res://gui/main_menu.tscn")
		#_load_scene_packed(main_menu)

func try_quit():
	if canQuit:
		get_tree().quit()
		
func get_current_scene():
	var root = get_tree().root
	return root.get_child(root.get_child_count() - 1)
