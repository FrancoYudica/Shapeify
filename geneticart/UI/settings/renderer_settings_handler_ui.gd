extends PanelContainer

@export var render_while_generating: CheckBox

func _ready() -> void:
	render_while_generating.button_pressed = Globals.settings.render_while_generating
	

func _on_render_while_generating_check_box_toggled(toggled_on: bool) -> void:
	Globals.settings.render_while_generating = toggled_on
