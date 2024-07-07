# Handles the Inventory class, which is an array of Inventory Slots
# Contains code for adding and removing items from the inventory
# Will eventually have code for moving items around

extends Resource

class_name Inventory

signal update

@export var slots : Array[InvSlot]

# Player > Inventory (array of InvSlot) > InvSlot (type and count of InvItem) > InvItem (item name and texture)
# In the future, player inventories should be instantiated per save

func insert(item: InvItem):
	# item that we are adding exists in inventory
	var item_slots = slots.filter(func(slot) : return slot.item == item)
	if !item_slots.is_empty():
		item_slots[0].count += 1
	else:
		# item that we are adding does not exist in inventory
		var empty_slots = slots.filter(func(slot) : return slot.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = item
			empty_slots[0].count = 1
	update.emit()
