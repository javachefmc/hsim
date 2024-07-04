extends Control

class_name GUI_Inventory

# We will need to load this from a save file
@onready var inv : Inventory = preload("res://inventory/inv_player.tres")
@onready var slots : Array = $GridContainer.get_children()

var is_open = false

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	# TODO: for robustness, check if part of array is not an InvSlot. If not, instantiate and save it
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _process(delta):
	# Keybind could be handled here but we are using gui_controller
	pass

func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
