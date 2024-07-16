# Simple dialog with cancel and ok functions

extends Control
class_name Dialog

var action_cancel = _null_action
var action_ok = _null_action

func display(text : String, text_cancel : String, text_ok : String, callback_cancel : Callable = _null_action, callback_ok : Callable = _null_action) -> void:
	$PanelContainer/VBoxContainer/MarginContainer/text.parse_bbcode(text)
	$PanelContainer/VBoxContainer/HBoxContainer/btn_cancel.text = text_cancel
	$PanelContainer/VBoxContainer/HBoxContainer/btn_ok.text = text_ok
	action_cancel = callback_cancel
	action_ok = callback_ok
	#$".".show()

func _on_btn_cancel_pressed() -> void:
	action_cancel.call()
	_unset_dialog()
	
func _on_btn_ok_pressed() -> void:
	action_ok.call()
	_unset_dialog()

func _null_action() -> void:
	pass

func _unset_dialog() -> void:
	self.queue_free()

func _on_color_rect_gui_input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_unset_dialog()
