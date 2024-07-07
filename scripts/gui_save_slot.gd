# Instance of gui element representing game save

extends Button

class_name gui_save_slot

@export var world_name : String = ""
@export var date_last_played : String = ""
@export var date_created : String = ""
@export var day_count : String = "0"

# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update():
	$HBoxContainer/VBoxContainer2/lbl_world_name.text = world_name
	$HBoxContainer/VBoxContainer2/lbl_day_count.text = "day " + day_count
	$HBoxContainer/VBoxContainer3/lbl_date_created.text = "created " + date_created
	$HBoxContainer/VBoxContainer3/lbl_date_updated.text = "last played " + date_last_played
	
