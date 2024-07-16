# Slots for items in an inventory GUI

extends Panel

@onready var item_display : Sprite2D = $item_display
@onready var item_count : Label = $item_count

func update(slot : InvSlot) -> void:
	if !slot.item:
		# No item in slot
		item_display.visible = false
		item_count.visible = false
	else:
		# Item in slot
		item_display.visible = true
		item_display.texture = slot.item.texture
		
		item_count.text = str(slot.count)
		
		if slot.count > 1:
			item_count.visible = true
		else:
			item_count.visible = false # prevent anticipated bugs!
