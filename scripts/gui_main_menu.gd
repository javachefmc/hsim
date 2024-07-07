# Main menu GUI controls

extends Control

signal play_btn_pressed

func _on_btn_play_pressed():
	Global.start_game()

func _on_btn_saves_pressed():
	Global.load_scene("res://gui/gui_saves.tscn")

func _on_btn_exit_pressed():
	Global.try_quit()

func _on_btn_mp_connect_pressed():
	MP.join_debug()
