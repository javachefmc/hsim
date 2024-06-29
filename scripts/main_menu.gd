extends Node3D

var mouse_pos
var pan_amount = 0.0005
var move_amount = 0.00002
var pan_speed = 0.1

var viewport_height : int = 1080
var viewport_width : int = 1920

@onready var viewport = $Viewport

@export var faderScene : PackedScene
var fader : Fader

# Called when the node enters the scene tree for the first time.
func _ready():
	# instantiate and create a fader
	fader = faderScene.instantiate()
	add_child(fader)
	fader.set_fade_speed(0.01)
	fader.fade_out()
	
	Global.connect("game_start", fadeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	
	var pan_x = ((viewport_height / 2) - mouse_pos.y) 
	var pan_y = ((viewport_height / 2) - mouse_pos.x)
	
	viewport.rotation_degrees.x = lerp(viewport.rotation_degrees.x, pan_x * pan_amount, pan_speed)
	viewport.rotation_degrees.y = lerp(viewport.rotation_degrees.y, pan_y * pan_amount, pan_speed)
	
	viewport.position.x = lerp(viewport.position.x, -pan_y * move_amount, pan_speed)
	viewport.position.y = lerp(viewport.position.y, pan_x * move_amount, pan_speed)

func fadeout():
	fader.set_fade_speed(0.2)
	fader.fade_in()
