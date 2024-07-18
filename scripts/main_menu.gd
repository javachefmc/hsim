# Final main menu (not main menu controller)
# Main Menu > Panel 3D > Main Menu Controller

extends Node3D

var mouse_pos : Vector2 = Vector2(0,0)
var pan_amount : float = 0.0005
var move_amount : float = 0.00002
var pan_speed : float = 0.1

var viewport_height : int = 1080
var viewport_width : int = 1920

@onready var viewport : Node = $Viewport

@export var faderScene : PackedScene
var fader : Fader

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Play music
	if not Global.sfx_music.playing:
		Global.sfx_music.play()
	
	# instantiate and create a fader
	fader = faderScene.instantiate()
	add_child(fader)
	fader.set_fade_speed(0.1)
	fader.fade_out()
	
	Global.connect("game_start", fadeout)

func _physics_process(delta : float) -> void:
	mouse_pos = get_viewport().get_mouse_position()
	
	var pan_x : float = ((float(viewport_height) / 2) - mouse_pos.y) 
	var pan_y : float = ((float(viewport_height) / 2) - mouse_pos.x)
	
	viewport.rotation_degrees.x = lerp(viewport.rotation_degrees.x, pan_x * pan_amount, pan_speed)
	viewport.rotation_degrees.y = lerp(viewport.rotation_degrees.y, pan_y * pan_amount, pan_speed)
	
	viewport.position.x = lerp(viewport.position.x, -pan_y * move_amount, pan_speed)
	viewport.position.y = lerp(viewport.position.y, pan_x * move_amount, pan_speed)

func fadeout() -> void:
	fader.set_fade_speed(0.2)
	fader.fade_in()
