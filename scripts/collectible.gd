extends Node3D

@onready var label = $Label

@export var item : InvItem
var player : Player = null

func _ready():
	label.hide()

func _on_area_3d_area_entered(area):
	if area.name == "PlayerHitbox":
		label.show()
		player = area.get_parent().get_parent() # hitbox > head > player

func _on_area_3d_area_exited(area):
	if area.name == "PlayerHitbox":
		label.hide()
		player = null # prevent anticipated bugs!

func collect():
	player.collect(item)
	queue_free()
