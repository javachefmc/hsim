# Saves screen GUI

extends Control

var saves : Array
var save_dir = Global.save_dir

@export var save_slot_scene : PackedScene = preload("res://gui/gui_save_slot.tscn")

var selected_save : String

func _ready():
	clear_rightpanel()
	update_save_list()

func update_save_list():
	for n in $saves_panel/Saves.get_children():
		if not n is Label:
			$saves_panel/Saves.remove_child(n)
			n.queue_free()
	
	var dir = DirAccess.open(save_dir)
	if dir:
		print("Loading saves...")
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# Check that this is a file
			if not dir.current_is_dir():
				# Check that the file ends in .tres
				if file_name.ends_with(Global.save_ext):
					# Try to load this file as a SaveGame
					var this_save = ResourceLoader.load(Global.save_dir + "/" + file_name) as SaveGame
					# Check that it actually loaded
					if not this_save == null:
						saves.append(file_name)
						
						var save_slot = save_slot_scene.instantiate()
						
						save_slot.world_name = this_save.save_name
						save_slot.date_created = this_save.date_created
						save_slot.date_updated = this_save.date_updated
						save_slot.day = this_save.day
						save_slot.file_name = file_name
						
						save_slot.update()
					
						$saves_panel/Saves.add_child(save_slot)
						
						save_slot.connect("slot_selected", slot_pressed)
					
			file_name = dir.get_next()
			
		if saves.size() > 0:
			$saves_panel/Saves/lbl_no_saves.visible = false


func _on_btn_new_pressed():
	Global.load_scene("res://gui/gui_new_game.tscn")

func _on_btn_exit_pressed():
	Global.load_scene("res://gui/main_menu.tscn")
	
func slot_pressed(file_name):
	selected_save = file_name
	
	$right_panel.visible = true
	
	var save = ResourceLoader.load(Global.save_dir + "/" + file_name) as SaveGame
	$right_panel/VBoxContainer/txt_save_name.text = save.save_name
	$right_panel/VBoxContainer/lbl_day.text = "Day " + str(save.day)
	$right_panel/VBoxContainer/lbl_save_path.text = file_name
	$right_panel/VBoxContainer/GridContainer/lbl_date_last_played.text = save.date_updated
	$right_panel/VBoxContainer/GridContainer/lbl_date_created.text = save.date_created
	
	$VBoxContainer2/GridContainer/btn_delete.disabled = false
	$VBoxContainer2/btn_load.disabled = false

func _on_btn_load_pressed():
	if not selected_save == null:
		Global.load_save(selected_save)


func clear_rightpanel():
	$right_panel.visible = false
	
func _on_btn_open_saves_pressed():
	OS.shell_show_in_file_manager(ProjectSettings.globalize_path(Global.save_dir))
