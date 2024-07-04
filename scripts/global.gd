extends Node

var current_scene = null

# If/when multiplayer is developed, these variables will be important
var canChangeScenes = true
var canQuit = true

signal game_start

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func load_scene(path):
	# This is deferred as current scene may still be executing something
	#call_deferred("_load_scene_deferred", path)
	
	# this is an immediate loading function
	call_deferred("_load_scene_immediate", path)
	
func _load_scene_deferred(path):
	# This tended to break things like global illumination
	current_scene.free()
	
	var scene = ResourceLoader.load(path)
	
	current_scene = scene.instantiate()
	
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func _load_scene_immediate(path):
	# While this works without bugs, it causes a gray flash
	get_tree().change_scene_to_file(path)

func start_game():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	game_start.emit()
	await get_tree().create_timer(0.3).timeout
	load_scene("res://scenes/level_00.tscn")

func try_quit_to_title():
	if canChangeScenes:
		load_scene("res://gui/main_menu.tscn")

func try_quit():
	if canQuit:
		get_tree().quit()
