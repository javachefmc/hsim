# Main menu GUI controls

extends Control

signal play_btn_pressed

func _on_btn_play_pressed() -> void:
	Global.start_game()
	generic_mouse_click()

func _on_btn_saves_pressed() -> void:
	Global.load_scene("res://gui/gui_saves.tscn")
	generic_mouse_click()

func _on_btn_options_pressed() -> void:
	generic_mouse_click()
	Global.show_options()

func _on_btn_mp_connect_pressed() -> void:
	MP.join_debug()
	generic_mouse_click()

func _on_btn_exit_pressed() -> void:
	Global.try_quit()
	generic_mouse_click()

## GENERIC FUNCS

func generic_mouse_enter() -> void:
	Global.play_sound("ui-hover")

func generic_mouse_click() -> void:
	Global.play_sound("ui-press")

## MOUSE ENTER

func _on_btn_play_mouse_entered() -> void:
	generic_mouse_enter()

func _on_btn_saves_mouse_entered() -> void:
	generic_mouse_enter()

func _on_btn_options_mouse_entered() -> void:
	generic_mouse_enter()

func _on_btn_mp_connect_mouse_entered() -> void:
	generic_mouse_enter()

func _on_btn_exit_mouse_entered() -> void:
	generic_mouse_enter()
