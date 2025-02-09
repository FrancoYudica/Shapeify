extends Node

@export var panel: Control

func _ready() -> void:
	panel.mouse_entered.connect(
		func():
			get_parent().show())

	panel.mouse_exited.connect(
		func():
			get_parent().hide())
