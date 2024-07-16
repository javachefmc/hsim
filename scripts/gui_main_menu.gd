# Main menu GUI controls

extends Control

signal play_btn_pressed

func _on_btn_play_pressed() -> void:
	Global.start_game()

func _on_btn_saves_pressed() -> void:
	Global.load_scene("res://gui/gui_saves.tscn")

func _on_btn_exit_pressed() -> void:
	Global.try_quit()

func _on_btn_mp_connect_pressed() -> void:
	MP.join_debug()
