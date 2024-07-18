# Handles in-game HUD gui

extends Control

@onready var bar_hp: ProgressBar = %bar_hp
@onready var bar_food: ProgressBar = %bar_food
@onready var bar_water: ProgressBar = %bar_water
@onready var bar_stamina: ProgressBar = %bar_stamina

@onready var player: Player = $"../.."

func _ready() -> void:
	player.connect("params_changed", change_params)
	
	player.connect("health_changed", change_health)
	player.connect("food_changed", change_food)
	player.connect("water_changed", change_water)
	player.connect("stamina_changed", change_stamina)

func change_params(val : Dictionary):
	change_health(val.health)
	change_food(val.food)
	change_water(val.water)
	change_stamina(val.stamina)

func change_health(val : int):
	bar_hp.value = val

func change_food(val : int):
	bar_food.value = val
	
func change_water(val : int):
	bar_water.value = val
	
func change_stamina(val : int):
	bar_stamina.value = val
