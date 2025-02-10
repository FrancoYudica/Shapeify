extends Button

@export var stopping_notification: Control

func _ready() -> void:
	
	visible = false
	
	ImageGeneration.generation_started.connect(
		func():
			visible = true
	)
	ImageGeneration.generation_finished.connect(
		func():
			visible = false
	)
	
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	stopping_notification.visible = true
	ImageGeneration.stop()
