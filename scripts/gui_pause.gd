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
	generic_button_press()
	resume_pressed.emit() # WARNING: CAPTURED BY GUICONTROLLER

func _on_btn_exit_pressed() -> void:
	generic_button_press()
	Global.save_current_world()
	exit_pressed.emit() # WARNING: CAPTURED BY GUICONTROLLER

func _on_btn_mp_host_pressed() -> void:
	generic_button_press()
	MP.host()
	$VBoxContainer/btn_mp_host.visible = false

func _on_btn_save_pressed() -> void:
	generic_button_press()
	Global.save_current_world()

func pause() -> void:
	visible = true
	paused = true
	
func resume() -> void:
	visible = false
	paused = false

func _on_btn_options_pressed() -> void:
	generic_button_press()
	Global.show_options()

func generic_button_press() -> void:
	Global.play_sound("ui-press")
	
func generic_button_hover() -> void:
	Global.play_sound("ui-hover")


func _on_btn_resume_mouse_entered() -> void:
	generic_button_hover()

func _on_btn_options_mouse_entered() -> void:
	generic_button_hover()

func _on_btn_mp_host_mouse_entered() -> void:
	generic_button_hover()

func _on_btn_exit_mouse_entered() -> void:
	generic_button_hover()
