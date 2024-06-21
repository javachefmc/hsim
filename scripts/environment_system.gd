extends Node3D

class_name EnvironmentSystem

var time : float
@export var day_length : float = 20
@export var start_time : float = 0.5
var time_rate : float

@export var sun_color : Gradient

@export var sun_intensity : Curve
@export var moon_intensity : Curve

@export var sun_max_energy : float = 50
@export var moon_max_energy : float = 50

@onready var sun : DirectionalLight3D = $SunLight
@onready var moon : DirectionalLight3D = $SunLight/MoonLight
#@onready var environment : WorldEnvironment = $WorldEnvironment

# Called when the node enters the scene tree for the first time.
func _ready():
	time_rate = 1 / day_length
	time = start_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += time_rate * delta
	if time > 1:
		time = 0
		
	sun.rotation_degrees.x = time * 360 + 90
	sun.light_color = sun_color.sample(time)
	sun.light_energy = sun_intensity.sample(time) * sun_max_energy
	
	moon.light_energy = moon_intensity.sample(time) * moon_max_energy
	
	# Disable lights when they are off
	moon.visible = moon.light_energy > 0
