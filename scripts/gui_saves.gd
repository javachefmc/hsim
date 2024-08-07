# Saves screen GUI

extends Control

var saves : Array
var save_dir : String = Global.save_dir

@export var save_slot_scene : PackedScene = preload("res://gui/gui_save_slot.tscn")
#
#@export var dialog_scene := preload("res://gui/dialog.gd")

var selected_save : String

func _ready() -> void:
	clear_rightpanel()
	update_save_list()

func update_save_list() -> void:
	for n in $saves_panel/Saves.get_children():
		if not n is Label:
			$saves_panel/Saves.remove_child(n)
			n.queue_free()
	
	var dir := DirAccess.open(save_dir)
	if dir:
		print("Loading saves...")
		dir.list_dir_begin()
		var file_name : String = dir.get_next()
		while file_name != "":
			# Check that this is a file
			if not dir.current_is_dir():
				# Check that the file ends in .tres
				if file_name.ends_with(Global.save_ext):
					# Try to load this file as a SaveData
					var this_save : SaveData = ResourceLoader.load(Global.save_dir + "/" + file_name) as SaveData
					# Check that it actually loaded
					if not this_save == null:
						saves.append(file_name)
						
						var save_slot : Node = save_slot_scene.instantiate()
						
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


func _on_btn_new_pressed() -> void:
	generic_button_press()
	Global.load_scene("res://gui/gui_new_game.tscn")

func _on_btn_exit_pressed() -> void:
	generic_button_press()
	Global.load_scene("res://gui/main_menu.tscn")
	
func slot_pressed(file_name : String) -> void:
	generic_button_press()
	selected_save = file_name
	
	$right_panel.visible = true
	
	var save := ResourceLoader.load(Global.save_dir + "/" + file_name) as SaveData
	%txt_save_name.text = save.save_name
	%lbl_day.text = "Day " + str(save.day)
	%lbl_save_path.text = file_name
	%lbl_date_last_played.text = save.date_updated
	%lbl_date_created.text = save.date_created
	
	%btn_delete.disabled = false
	%btn_load.disabled = false

func _on_btn_load_pressed() -> void:
	generic_button_press()
	if not selected_save == null:
		Global.load_save(selected_save)


func clear_rightpanel() -> void:
	$right_panel.visible = false
	
#TODO: Debug why this doesn't work with user://
func _on_btn_open_saves_pressed() -> void:
	generic_button_press()
	OS.shell_show_in_file_manager(ProjectSettings.globalize_path(Global.save_dir))
	#OS.shell_show_in_file_manager(ProjectSettings.globalize_path("user://"))
	print(Global.save_dir)

func _on_btn_delete_pressed() -> void:
	generic_button_press()
	Global.show_dialog(
		"Are you sure you want to delete this world?\n[color=#FFCC00]" + selected_save + "[/color]\n\nThis action cannot be undone.",
		"cancel", "delete",
		_nothing, _delete_world.bind(selected_save)
	)

func _delete_world(save) -> void:
	var address : String = Global.save_dir + "/" + save
	print("Deleting world at " + address)
	
	DirAccess.remove_absolute(address)
	
	update_save_list()

func _nothing() -> void:
	pass
	

func generic_button_press() -> void:
	Global.play_sound("ui-press")

func generic_button_hover() -> void:
	Global.play_sound("ui-hover")

func _on_btn_new_mouse_entered() -> void:
	generic_button_hover()

func _on_btn_open_saves_mouse_entered() -> void:
	generic_button_hover()

func _on_btn_exit_mouse_entered() -> void:
	generic_button_hover()

func _on_btn_load_mouse_entered() -> void:
	generic_button_hover()

func _on_btn_delete_mouse_entered() -> void:
	generic_button_hover()
