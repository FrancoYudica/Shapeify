extends Button

@export var panel: Control

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	panel.visible = not panel.visible
