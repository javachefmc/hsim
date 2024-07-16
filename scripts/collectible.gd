# Extends to any world item that can be picked up

extends Node3D

@onready var label = $Label

@export var item : InvItem
var player : Player = null

func _ready() -> void:
	label.hide()

func _on_area_3d_area_entered(area) -> void:
	if area.name == "PlayerHitbox":
		label.show()
		player = area.get_parent().get_parent() # hitbox > head > player

func _on_area_3d_area_exited(area) -> void:
	if area.name == "PlayerHitbox":
		label.hide()
		player = null # prevent anticipated bugs!

func collect() -> void:
	player.collect(item)
	queue_free()
