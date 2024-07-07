# All parameters saved in the game save

extends Resource

class_name SaveGame

## SAVE METADATA
@export var save_name : String = "Unknown"
@export var date_created : String
@export var date_updated : String

## WORLD
@export var time : float = 0.5
@export var day : int = 0

## PLAYER
@export var player_position : Vector3 = Vector3(0.0, 5.0, 0.0)
@export var player_rotation : Vector3 = Vector3(0.0, 0.0, 0.0)
@export var player_velocity : Vector3 = Vector3(0.0, 0.0, 0.0)

@export var player_inventory : Inventory

# Health
# Food
# Water
# Stamina
# Inventory

# In the future, player data should be moved to its own resource (with unique player id's) and instantiated in the game save resource as an array of player datas

