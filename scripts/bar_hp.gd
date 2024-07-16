extends ProgressBar

@export var player : Player

func _ready() -> void:
	#player.healthChanged.connect(update)
	update()

func update() -> void:
	pass
	#value = player.currentHealth * 100 / player.maxHealth
