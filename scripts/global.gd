# Global game functions

extends Node

# type changeable
var current_scene = null

const user_dir : String = "user://"
var res_dir : String = "res://"
const save_dir_name : String = "saves"
var save_dir : String = res_dir + "data/" + save_dir_name
const save_ext : String = ".tres" # THIS HAS TO BE .TRES

var current_save : String = "Save00.tres"

# If/when multiplayer is developed, these variables will be important
var canChangeScenes : bool = true
var canQuit : bool = true

signal game_start

func _ready() -> void:
	var dir := DirAccess.open(user_dir)
	dir.make_dir(save_dir)
	
	var root := get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func load_scene(path : String) -> void:
	call_deferred("_load_scene_manual", path)
	
func _load_scene_manual(path : String) -> void:
	var scene : Node = get_current_scene()
	get_tree().root.add_child(load(path).instantiate())
	scene.queue_free()

func _load_scene_immediate(path : String) -> void:
	# While this works without bugs, it causes a gray flash
	get_tree().change_scene_to_file(path)

func _load_scene_packed(scene : PackedScene) -> void:
	scene.instantiate()
	get_tree().change_scene_to_packed(scene)

# This will be deprecated when save system is implemented
func start_game() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	game_start.emit()
	await get_tree().create_timer(0.3).timeout
	
	load_scene("res://scenes/level_00.tscn")

func try_quit_to_title() -> void:
	if canChangeScenes:
		load_scene("res://gui/main_menu.tscn")

func try_quit() -> void:
	if canQuit:
		get_tree().quit()
		
func get_current_scene() -> Node:
	var root := get_tree().root
	return root.get_child(root.get_child_count() - 1)

func load_save(file_name : String) -> void:
	print("Attempting to load " + file_name)
	current_save = file_name
	
	#TODO: LOAD ALL DATA HERE
	
	# attempt to directly load save
	var save = ResourceLoader.load(Global.save_dir + "/" + current_save) as SaveGame
	# Check that it actually loaded
	if not save == null:
		
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		game_start.emit()
		
		var world = load("res://scenes/level_00.tscn").instantiate()
		
		var scene : Node = get_current_scene()
		
		get_tree().root.remove_child(scene)
		scene.queue_free()
		
		get_tree().root.add_child(world)
		
		# Setters
		
		var env : EnvironmentSystem = world.get_node("EnvironmentSystem")
		var player : Player = world.get_node("Players/Player")
		
		env.time = save.time
		env.day = save.day
		
		player.position = save.player_position
		player.set_rotation_immediate(save.player_rotation)
		player.velocity = save.player_velocity
		
		#player.inventory = PlayerInventory.new()
		
		# We will need to set other player parameters such as health, inventory, etc.
		
	else:
		print("FAILED TO LOAD SAVE")
		show_toast("failed to load save")
	
func save_current_world() -> void:
	print("Saving world...")
	show_toast("saving world")
	
	var player : Player = get_current_scene().get_node("Players").get_child(0)
	var env : EnvironmentSystem = get_current_scene().get_node("EnvironmentSystem")
	
	var current_save_dir = save_dir + "/" + current_save
	
	var save_data := SaveGame.new()
	
	# Load previous save
	var old_save_data := ResourceLoader.load(current_save_dir) as SaveGame
	# Check that it actually loaded.
	# With the current setup, it is necessary that this loads in order to not lose parameters like the save name
	if not old_save_data == null:
		## SAVE PARAMETERS
		save_data.save_name = old_save_data.save_name
		save_data.date_created = old_save_data.date_created
	else:
		## SAVE PARAMETERS
		print("WARNING: Could not load previous save. Save name and date created will be lost.")
		save_data.save_name = "Unknown"
		save_data.date_created = get_datetime()
		
	
	## SAVE PARAMETERS
	
	save_data.date_updated = get_datetime()
	
	## ENVIRONMENT PARAMETERS
	
	save_data.day = env.day
	save_data.time = env.time
	
	## PLAYER PARAMETERS
	
	save_data.player_position = player.position
	save_data.player_rotation = player.rotation_target
	save_data.player_inventory = player.inventory
	
	# TODO: add player inventory, status bars, and hidden parameters (temperature)
	
	verify_save_directory()
	
	print("Saving at " + current_save_dir)
	
	# Tried bundling resources but that also bundles scripts
	ResourceSaver.save(save_data, current_save_dir)

func verify_save_directory() -> void:
	var dir := DirAccess.open("res://data")
	if !dir.dir_exists(save_dir_name):
		dir.make_dir(save_dir_name)
		
func get_datetime() -> String:
	return Time.get_datetime_string_from_system(false, true)

func create_and_load_save(new_world_name : String) -> void:
	create_save(new_world_name)
	load_save(new_world_name + save_ext)
	
func create_save(new_world_name : String) -> void:
	var current_save_dir = save_dir + "/" + new_world_name + save_ext
	
	var save_data = SaveGame.new()
	
	# Try to load a save at this location
	var old_save_data = ResourceLoader.load(current_save_dir) as SaveGame
	# Check if it actually loads (this is bad and we will need to change the filename to save as)
	if not old_save_data == null:
		## SAVE PARAMETERS
		print("WARNING: a save exists at this location. Overwriting...")

	## SAVE PARAMETERS
	
	save_data.save_name = new_world_name
	save_data.date_created = get_datetime()
	save_data.date_updated = get_datetime()
	
	## ENVIRONMENT PARAMETERS
	
	save_data.day = 0
	save_data.time = 0.5 # TODO: this should be the defatul time
	
	## PLAYER PARAMETERS
	
	save_data.player_position = Vector3(0, 3, 0) # TODO: set this to spawn position
	save_data.player_rotation = Vector3(0, 0, 0)
	save_data.player_inventory = PlayerInventory.new()
	
	# TODO: add player inventory, status bars, and hidden parameters (temperature)
	
	verify_save_directory()
	
	print("Saving at " + current_save_dir)
	show_toast("creating save")
	
	# Tried bundling resources but that also bundles scripts
	ResourceSaver.save(save_data, current_save_dir)
	
func show_toast(message : String, duration : float = 3) -> void:
	var toast : Toast = load("res://gui/toast.tscn").instantiate()
	get_current_scene().add_child(toast)
	toast.display(message, duration)
