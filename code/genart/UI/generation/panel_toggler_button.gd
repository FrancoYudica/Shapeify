extends Button

@export var panel: Control

func _ready() -> void:
	pressed.connect(_on_pressed)
	panel.visibility_changed.connect(
		func():
			button_pressed = panel.visible
	)

func _on_pressed() -> void:
	panel.visible = not panel.visible
