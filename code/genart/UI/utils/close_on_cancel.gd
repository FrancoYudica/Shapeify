extends Control

func _ready() -> void:
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") and get_parent().visible:
		get_parent().visible = false
