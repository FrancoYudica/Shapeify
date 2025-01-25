extends GridContainer

@export var width_2_columns : int = 500
@export var width_3_columns : int = 1000
@export var width_4_columns : int = 1500

var current_width : int

func _ready():
	_on_window_resized()
	get_tree().root.size_changed.connect(_on_window_resized)

func _on_window_resized():
	current_width = DisplayServer.window_get_size().x

	if current_width < width_2_columns:
		set_columns(1)
	elif current_width >= width_2_columns and current_width < width_3_columns:
		set_columns(2)
	elif current_width >= width_3_columns and current_width < width_4_columns:
		set_columns(3)
	else:
		set_columns(4)
