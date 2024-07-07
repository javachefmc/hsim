# All parameters saved in the game save

extends Resource

class_name SaveGame

## SAVE METADATA
@export var save_name : String
@export var date_created : String
@export var date_updated : String

## PLAYER
@export var player_position : Vector3
@export var player_rotation : Vector3
@export var player_velocity : Vector3

# In the future, player data should be moved to its own resource (with unique player id's) and instantiated in the game save resource as an array of player datas

## WORLD
@export var time : float
@export var day : int
