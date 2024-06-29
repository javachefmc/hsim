extends Control

class_name GUI_Pause

var paused = false

signal resume_pressed
signal exit_pressed

func _ready():
	resume()

func _process(delta):
	# Keybind could be handled here but we are using gui_controller
	pass

func _on_btn_resume_pressed():
	#resume()
	resume_pressed.emit() # WARNING: CAPTURED BY GUICONTROLLER

func _on_btn_exit_pressed():
	exit_pressed.emit() # WARNING: CAPTURED BY GUICONTROLLER

func pause():
	visible = true
	paused = true
	
func resume():
	visible = false
	paused = false
