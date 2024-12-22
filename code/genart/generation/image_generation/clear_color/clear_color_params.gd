class_name ClearColorParams extends Resource

@export var color: Color:
	set(value):
		if value != color:
			color = value
			emit_changed()
