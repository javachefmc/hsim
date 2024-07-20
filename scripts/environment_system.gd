# Day/night cycle, light intensity, sky color

extends Node3D
class_name EnvironmentSystem

@export var day : int = 0
@export var time : float

@export var day_length : float = 400
@export var start_time : float = 0.5
var time_rate : float = 1 / day_length

@export var sun_color : Gradient

@export var sun_intensity : Curve
@export var moon_intensity : Curve

@export var sun_max_energy : float = 20
@export var moon_max_energy : float = 10

@onready var sun : DirectionalLight3D = %SunLight
@onready var moon : DirectionalLight3D = %MoonLight

func _ready() -> void:
	# Time should be passed to world from save on load
	time = start_time
	#pass

func _process(delta) -> void:
	# TODO: Fix this
	#time = $MultiplayerSynchronizer.time
	
	# TODO: Make this work on multiplayer
	if multiplayer.is_server():
		time += time_rate * delta
		if time > 1:
			time = 0
		
	sun.rotation_degrees.x = time * 360 + 90
	moon.rotation_degrees.x = time * 360 + 90
	
	sun.light_color = sun_color.sample(time)
	sun.light_energy = sun_intensity.sample(time) * sun_max_energy
	
	moon.light_energy = moon_intensity.sample(time) * moon_max_energy
	
	# Disable lights when they are off
	moon.visible = moon.light_energy > 0
	sun.visible = sun.light_energy > 0
	
	# TODO: add system for adjusting ambient light and autoexposure parameters
	
func set_time(time_to_set) -> void:
	time = time_to_set
