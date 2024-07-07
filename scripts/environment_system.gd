# Day/night cycle, light intensity, sky color

extends Node3D

class_name EnvironmentSystem

@export var time : float
@export var day_length : float = 200
@export var start_time : float = 0.5
var time_rate : float = 1 / day_length

@export var sun_color : Gradient

@export var sun_intensity : Curve
@export var moon_intensity : Curve

@export var sun_max_energy : float = 20
@export var moon_max_energy : float = 10

@onready var sun : DirectionalLight3D = $SunLight
@onready var moon : DirectionalLight3D = $SunLight/MoonLight

func _ready():
	time = start_time

func _process(delta):
	time = $MultiplayerSynchronizer.time
		
	sun.rotation_degrees.x = time * 360 + 90
	sun.light_color = sun_color.sample(time)
	sun.light_energy = sun_intensity.sample(time) * sun_max_energy
	
	moon.light_energy = moon_intensity.sample(time) * moon_max_energy
	
	# Disable lights when they are off
	# moon.visible = moon.light_energy > 0
	
	# TODO: add ambient light system
