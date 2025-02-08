extends Button


@export var image_generation: Node
@export var stopping_notification: Control

func _ready() -> void:
	
	visible = false
	
	image_generation.generation_started.connect(
		func():
			visible = true
	)
	image_generation.generation_finished.connect(
		func():
			visible = false
	)
	
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	stopping_notification.visible = true
	image_generation.stop()
