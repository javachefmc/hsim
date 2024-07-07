# Global game functions

extends Node

var current_scene = null

const user_dir = "user://"
const res_dir = "res://"
const save_dir_name = "saves"
const save_dir = "res://data/" + save_dir_name
const save_ext = ".tres" # THIS HAS TO BE .TRES

var current_save : String = "Save00.tres"

# If/when multiplayer is developed, these variables will be important
var canChangeScenes = true
var canQuit = true

signal game_start

func _ready():
	var dir = DirAccess.open(user_dir)
	dir.make_dir(save_dir)
	
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

func _load_scene_packed(scene):
	scene.instantiate()
	get_tree().change_scene_to_packed(scene)

# This will be deprecated when save system is implemented
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
		
func get_current_scene():
	var root = get_tree().root
	return root.get_child(root.get_child_count() - 1)

func load_save(filename):
	current_save = filename
	start_game()
	#TODO: LOAD ALL DATA HERE

func create_save(data):
	# Make new save with overwrite protection
	pass
	
func update_save(data):
	# Overwrite existing save or create new save if it somehow doesn't exist
	pass

func save_current_world():
	print("Saving world...")
	var player : Player = get_current_scene().get_node("Players").get_child(0)
	
	var current_save_dir = save_dir + "/" + current_save
	
	var save_data = SaveGame.new()
	save_data.player_position = player.position
	save_data.player_rotation = player.rotation_target
	save_data.date_updated = get_datetime()
	
	verify_save_directory()
	
	if not FileAccess.file_exists(current_save_dir):
		# Game save does not exist yet for some reason
		save_data.date_created = get_datetime()
		print("Save does not exist, creating new one at " + current_save_dir)
	else:
		print("Saving over " + current_save_dir)
	
	ResourceSaver.save(save_data, current_save_dir)
	

func load_data():
	if FileAccess.file_exists(save_dir):
		var file = FileAccess.open(save_dir, FileAccess.READ)
		# var = file.get_var(var)
	else:
		print("File loader: no data saved")
		# var = 0
		
func verify_save_directory():
	var dir = DirAccess.open("res://data")
	if !dir.dir_exists(save_dir_name):
		dir.make_dir(save_dir_name)
		
func get_datetime():
	return Time.get_datetime_string_from_system(false, true)
