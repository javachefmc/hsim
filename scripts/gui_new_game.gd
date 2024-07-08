# New game GUI

extends Control

@export var new_world_name : String = "Unknown"

func _on_btn_returntomenu_pressed():
	Global.load_scene("res://gui/main_menu.tscn")

# We could check this in _process but using signal is better
func _on_txt_worldname_text_changed(text : String):
	var world_name = text.strip_edges()
	if not world_name == "":
		# Name is valid
		new_world_name = world_name
		$btn_create.disabled = false
	else:
		$btn_create.disabled = true

func _on_btn_create_pressed():
	# TODO: Check if a world exists with the name. If it does, append a counter
	Global.create_and_load_save(new_world_name)
