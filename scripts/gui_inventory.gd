# Handles inventory GUI

extends Control

class_name GUI_Inventory

# We will need to load this from a save file
@onready var inv : Inventory = preload("res://inventory/inv_player_2.tres")
@onready var gui_slots : Array = $GridContainer.get_children()

@onready var gui_slot_scene = preload("res://gui/gui_inventory_slot.tscn")

var is_open = false

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	# Clear the inventory gui
	for n in $GridContainer.get_children():
		$GridContainer.remove_child(n)
		n.queue_free()
	
	# Add slots to the inventory gui
	for i in inv.slots.size():
		var slot_scene = gui_slot_scene.instantiate()
		$GridContainer.add_child(slot_scene)
		slot_scene.update(inv.slots[i])
		
func _process(delta):
	# Keybind could be handled here but we are using gui_controller
	pass

func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
