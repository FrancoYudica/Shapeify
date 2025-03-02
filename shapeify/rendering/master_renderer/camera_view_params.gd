class_name CameraViewParams extends Resource

signal attributes_resetted

@export var normalized_translation := Vector2.ZERO:
	set(value):
		if value != normalized_translation:
			normalized_translation = value
			emit_changed()

@export var zoom := 1.0:
	set(value):
		if value != zoom:
			zoom = value
			emit_changed()

func reset():
	normalized_translation = Vector2.ZERO
	zoom = 1.0
	attributes_resetted.emit()
