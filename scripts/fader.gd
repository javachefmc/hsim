# Simple script for fading whole screen to/from black

extends Control

class_name Fader

var faded = false
@export var fade_speed : float = 0.1

var current_color : Color = Color(0,0,0,1)

func _physics_process(delta):
	if faded:
		current_color = lerp(current_color, Color(0,0,0,0), fade_speed)
	else:
		current_color = lerp(current_color, Color(0,0,0,1), fade_speed)
	$".".set_color(current_color)

func fade_in():
	faded = false
	
func fade_out():
	faded = true

func set_fade_speed(speed):
	fade_speed = speed
