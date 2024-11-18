extends Button

@export var toggle_control: Control

func _on_toggled(toggled_on: bool) -> void:
	toggle_control.visible = not toggled_on
