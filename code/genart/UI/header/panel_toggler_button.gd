extends Button

@export var panel: Control

func _ready() -> void:
	panel.visibility_changed.connect(
		func():
			set_pressed_no_signal(panel.visible)
	)
	toggled.connect(_on_pressed)
	
func _on_pressed(t) -> void:
	panel.visible = button_pressed
