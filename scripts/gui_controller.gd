extends Control

var paused = false
var inUI = false
var inInventory = false

@onready var gui_pause : GUI_Pause = $"../gui_pause"
@onready var gui_inventory : GUI_Inventory = $"../gui_inventory"

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		if paused:
			resume()
		elif not paused and inInventory:
			closeInventory()
		else:
			pause()
	if Input.is_action_just_pressed("inventory"):
		if not paused:
			if inInventory:
				closeInventory()
			else:
				openInventory()

func updateMouse():
	# Reduce all possible GUIs to one state
	if inInventory: # or ...
		inUI = true
	else: # Make sure else is "none"
		inUI = false
	
	if paused or inUI:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if not paused and not inUI:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func pause():
	gui_pause.pause()
	paused = true
	updateMouse()
	
func resume():
	gui_pause.resume()
	paused = false
	updateMouse()

func openInventory():
	gui_inventory.open()
	inInventory = true
	updateMouse()

func closeInventory():
	gui_inventory.close()
	inInventory = false
	updateMouse()
