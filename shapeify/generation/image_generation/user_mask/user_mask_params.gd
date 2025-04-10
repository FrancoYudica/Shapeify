class_name UserMaskParams extends Resource

signal cleared

@export var points: Array[UserMaskPoint] = []:
	set(value):
		if value != points:
			points = value
			emit_changed()

func add_points(new_points: Array[UserMaskPoint]):
	points.append_array(new_points)
	emit_changed()

func clear():
	points.clear()
	cleared.emit()
