# Handles the Options gui

extends Control

@onready var volume_music: HSlider = %volume_music
@onready var lbl_volume_music: Label = %lbl_volume_music
@onready var volume_ui: HSlider = %volume_ui
@onready var lbl_volume_ui: Label = %lbl_volume_ui
@onready var volume_bkgd: HSlider = %volume_bkgd
@onready var lbl_volume_bkgd: Label = %lbl_volume_bkgd
@onready var opt_window_type: OptionButton = %opt_window_type

@onready var btn_reset: Button = %btn_reset
@onready var btn_exit: Button = %btn_exit

const volume_range = 30

func _ready() -> void:
	print("Opening options...")
	update_values()
	
func update_values() -> void:
	var current_volume_music := Global.sfx_music.volume_db
	var current_volume_ui := Global.sfx_ui.volume_db
	
	lbl_volume_music.text = str(current_volume_music) + " dB"
	lbl_volume_ui.text = str(current_volume_ui) + " dB"
	
	volume_music.value = db_to_linear(current_volume_music) * 100
	volume_ui.value = db_to_linear(current_volume_ui) * 100
	
	var window_mode : int = 0
	match DisplayServer.window_get_mode():
		DisplayServer.WINDOW_MODE_WINDOWED:
			window_mode = 0
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			window_mode = 1
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			window_mode = 2
	opt_window_type.select(window_mode)
	

func range_to_db(value) -> float:
	var db = 0
	db = ( value - 50 ) / 100 * volume_range
	return db

func range_to_linear(value) -> float:
	return value / 100	

func _on_volume_music_value_changed(value: float) -> void:
	var db = linear_to_db(range_to_linear(value))
	Global.sfx_music.volume_db = db
	lbl_volume_music.text = str(round(db * 10) / 10) + " dB"

func _on_volume_ui_value_changed(value: float) -> void:
	var db = linear_to_db(range_to_linear(value))
	Global.sfx_ui.volume_db = db
	lbl_volume_ui.text = str(round(db * 10) / 10) + " dB"
	generic_button_hover()

func _on_volume_bkgd_value_changed(value: float) -> void:
	pass

## Buttons


func _on_btn_reset_pressed() -> void:
	Global.show_toast("This does nothing")
	generic_button_press()

func _on_btn_exit_pressed() -> void:
	generic_button_press()
	$".".queue_free()

func generic_button_hover() -> void:
	Global.play_sound("ui-hover")

func generic_button_press() -> void:
	Global.play_sound("ui-press")


func _on_volume_music_mouse_entered() -> void:
	generic_button_hover()

func _on_volume_ui_mouse_entered() -> void:
	generic_button_hover()

func _on_volume_bkgd_mouse_entered() -> void:
	generic_button_hover()

func _on_btn_reset_mouse_entered() -> void:
	generic_button_hover()

func _on_btn_exit_mouse_entered() -> void:
	generic_button_hover()


func _on_opt_window_type_item_selected(index: int) -> void:
	pass
	# 0: Windowed
	# 1: Borderless Fullscreen
	# 2: Fullscreen
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		_:
			printerr("Options: Window type out of range: " + str(index))

func _on_opt_window_type_mouse_entered() -> void:
	generic_button_hover()
