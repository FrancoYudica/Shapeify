extends CheckBox

@export var toggle_control: Control

func _ready() -> void:
	
	toggle_control.visible = button_pressed
	
	toggled.connect(
		func(toggled_on):
			toggle_control.visible = toggled_on)
