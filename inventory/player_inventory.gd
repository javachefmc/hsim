# Represents player inventory

extends Inventory
class_name PlayerInventory

const num_slots : int = 30

func _init() -> void:
	#print("Initializing player inventory")
	#slots.resize(num_slots)
	#slots.fill(InvSlot.new())
	pass

func _ready() -> void:
	pass
	

func reset() -> void:
	pass
