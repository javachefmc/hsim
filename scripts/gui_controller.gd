# Handles all in-game player-specific GUIs
# Includes keybinds

extends Control
class_name GUI_Controller

var paused : bool = false
var inUI : bool = false
var inInventory : bool = false

@onready var gui_pause : GUI_Pause = %gui_pause
@onready var gui_inventory : GUI_Inventory = %gui_inventory

func _ready() -> void:
	gui_pause.connect("resume_pressed", resume) # This allows button press to function identically to keybind
	gui_pause.connect("exit_pressed", quitToTitle)

# this does not need to be process
func _physics_process(delta: float) -> void:
	# Handle all GUI-related keybinds
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

# Shows or hides cursor
func updateCursor() -> void:
	# Reduce all possible GUIs to one state
	if inInventory: # or ...
		inUI = true
	else: # Make sure else is "none"
		inUI = false
	
	if paused or inUI:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if not paused and not inUI:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# GUI related functions

func pause() -> void:
	gui_pause.pause()
	paused = true
	updateCursor()
	
func resume() -> void:
	gui_pause.resume()
	paused = false
	updateCursor()

func openInventory() -> void:
	gui_inventory.open()
	inInventory = true
	updateCursor()

func closeInventory() -> void:
	gui_inventory.close()
	inInventory = false
	updateCursor()
	
func quitToTitle() -> void:
	Global.try_quit_to_title()
