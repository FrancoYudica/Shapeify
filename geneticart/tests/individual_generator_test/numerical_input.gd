extends HBoxContainer

@onready var line_edit := $LineEdit

func get_number():
	if line_edit.text.is_valid_int():
		return int(line_edit.text)
	else:
		return 10
