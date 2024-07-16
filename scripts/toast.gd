extends Control
class_name Toast

@onready var text = $text

func display(message : String = "undefined", duration : float = 5) -> void:
	text.text = message
	text.visible = true
	var timer := get_tree().create_timer(duration, false)
	timer.connect("timeout", delete)

func delete() -> void:
	self.queue_free()
