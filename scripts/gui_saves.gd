# Saves screen GUI

extends Control

var saves : Array
var save_dir = Global.save_dir

@export var save_slot_scene : PackedScene = preload("res://gui/gui_save_slot.tscn")

func _ready():
	update_save_list()

func update_save_list():
	for n in $ScrollContainer/Saves.get_children():
		if not n is Label:
			$ScrollContainer/Saves.remove_child(n)
			n.queue_free()
	
	var dir = DirAccess.open(save_dir)
	if dir:
		print("Loading saves...")
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
				
				# TODO: do extra checks to make sure this is a save. Saves should also be sorted by last played
				
				saves.append(file_name)
				
				# move this somewhere else so it doesn't get called more than once!
				$ScrollContainer/Saves/lbl_no_saves.visible = false
				
				var save_slot = save_slot_scene.instantiate()
				save_slot.world_name = file_name
				save_slot.update()
				
				$ScrollContainer/Saves.add_child(save_slot)
				
			file_name = dir.get_next()


func _on_btn_new_pressed():
	var dir = DirAccess.open(save_dir)
	if dir:
		var name = "World " + str(randi() % 100)
		dir.make_dir(name)
		update_save_list()
	else:
		pass
	# Temporary code for adding another scene 
	
	
	#Global.load_scene("res://gui/gui_new_game.tscn")
	

