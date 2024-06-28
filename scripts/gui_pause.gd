extends Control

class_name GUI_Pause

var paused = false

func _ready():
	resume()

func _process(delta):
	#if Input.is_action_just_pressed("escape"):
		#if paused:
			#resume()
		#else:
			#pause()
	pass

func pause():
	visible = true
	paused = true
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func resume():
	visible = false
	paused = false
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# check that we are not in an inventory
