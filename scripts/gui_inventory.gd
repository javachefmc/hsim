extends Control

class_name GUI_Inventory

var is_open = false

func _ready():
	close()

func _process(delta):
	# Keybind could be handled here but we are using gui_controller
	pass

func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
