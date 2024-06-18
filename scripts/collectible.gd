extends Node3D

@onready var label = $Label

func _ready():
	label.hide()

func _on_area_3d_area_entered(area):
	if area.name == "PlayerHitbox":
		label.show()

func _on_area_3d_area_exited(area):
	if area.name == "PlayerHitbox":
		label.hide()

func collect():
	# Add code for item collection
	# Try doing a return function with custom data type
	queue_free()
