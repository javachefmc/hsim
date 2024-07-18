# Extension of Button to allow for sounds.
# Not implemented yet

extends Button
class_name GUIButton

func _on_pressed() -> void:
	Global.play_sound("ui-accept")

func _on_mouse_entered() -> void:
	Global.play_sound("ui-hover")
