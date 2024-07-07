# Instance of gui element representing game save

extends Button

class_name gui_save_slot

@export var world_name : String = ""
@export var date_updated : String = ""
@export var date_created : String = ""
@export var day : int = 0
@export var file_name : String = ""

signal slot_selected

# Called when the node enters the scene tree for the first time.
func _ready():
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update():
	$HBoxContainer/VBoxContainer2/lbl_world_name.text = world_name
	$HBoxContainer/VBoxContainer2/lbl_day_count.text = "day " + str(day)
	#$HBoxContainer/VBoxContainer3/lbl_date_created.text = "created " + date_created
	$HBoxContainer/VBoxContainer3/lbl_date_updated.text = date_updated
	$HBoxContainer/VBoxContainer3/lbl_file_name.text = file_name

func _on_pressed():
	slot_selected.emit(file_name)
