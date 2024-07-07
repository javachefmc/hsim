# New game GUI

extends Control


func _on_btn_create_pressed():
	pass # Replace with function body.
	Global.load_scene("res://scenes/level_00.tscn")

func _on_btn_returntomenu_pressed():
	Global.load_scene("res://gui/main_menu.tscn")
