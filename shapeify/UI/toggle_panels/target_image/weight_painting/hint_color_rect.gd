extends ColorRect


func _ready() -> void:
	visible = false

var _hovered: bool = false

func _process(delta: float) -> void:
	
	var parent_rect = get_parent().get_global_rect()
	var mouse_local = get_parent().get_global_mouse_position()
	
	var is_hovering = parent_rect.has_point(mouse_local)
	print(is_hovering)
	_hovered = is_hovering
	visible = _hovered
		
	
	if not is_visible_in_tree():
		return
	
	if Input.is_action_just_pressed("paint"):
		material.set_shader_parameter("rotating", 1.0)
		
	if Input.is_action_just_released("paint"):
		material.set_shader_parameter("rotating", 0.0)
		
	var local_pos = get_parent().get_local_mouse_position()
	position = local_pos - size * 0.5
