# Represents all of the data that a player can contain.
# This is *not* directly tied to Player.

extends Resource
class_name PlayerData

const MAX_PARAM : int = 100 

@export_range(0, MAX_PARAM) var health : int = MAX_PARAM
@export_range(0, MAX_PARAM) var food : int = MAX_PARAM
@export_range(0, MAX_PARAM) var water : int = MAX_PARAM
@export_range(0, MAX_PARAM) var stamina : int = MAX_PARAM

@export var inventory : PlayerInventory
