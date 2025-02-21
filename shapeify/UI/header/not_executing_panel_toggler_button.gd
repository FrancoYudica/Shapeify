extends Button

@export var panel: Control

func _ready() -> void:
	
	disabled = true

	pressed.connect(
		func():
			panel.visible = not panel.visible
	)
	
	ImageGeneration.generation_finished.connect(
		func():
			disabled = false
	)
	
	ImageGeneration.generation_started.connect(
		func():
			disabled = true
	)
