extends Button

@export var panel: Control

func _ready() -> void:
	pressed.connect(panel.hide)
