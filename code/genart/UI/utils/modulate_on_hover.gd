extends Control

const HOVER_COLOR : Color = Color.GRAY

var texture_button : BaseButton

func _ready() -> void:
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	
	texture_button = get_parent()
	if !texture_button:
		printerr("No BaseButton present at " + get_parent().name)
		return
	
	texture_button.mouse_entered.connect(func(): texture_button.self_modulate = HOVER_COLOR)
	texture_button.mouse_exited.connect(func(): texture_button.self_modulate = Color.WHITE)
