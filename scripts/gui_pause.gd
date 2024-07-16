# In-game pause screen GUI

extends Control
class_name GUI_Pause

var paused : bool = false

signal resume_pressed
signal exit_pressed

func _ready() -> void:
	resume()

# Keybind could be handled in process but we are using gui_controller

func _on_btn_resume_pressed() -> void:
	#resume()
	resume_pressed.emit() # WARNING: CAPTURED BY GUICONTROLLER

func _on_btn_exit_pressed() -> void:
	# WARNING: direct global function call
	Global.save_current_world()
	exit_pressed.emit() # WARNING: CAPTURED BY GUICONTROLLER

func _on_btn_mp_host_pressed() -> void:
	# WARNING: direct global function call
	MP.host()
	$VBoxContainer/btn_mp_host.visible = false

func _on_btn_save_pressed() -> void:
	Global.save_current_world()

func pause() -> void:
	visible = true
	paused = true
	
func resume() -> void:
	visible = false
	paused = false
