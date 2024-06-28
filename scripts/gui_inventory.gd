extends Control

class_name GUI_Inventory

var is_open = false

func _ready():
	close()

func _process(delta):
	#if Input.is_action_just_pressed("inventory"):
		#if is_open:
			#close()
		#else:
			#open()
	pass

func open():
	visible = true
	is_open = true
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func close():
	visible = false
	is_open = false
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
