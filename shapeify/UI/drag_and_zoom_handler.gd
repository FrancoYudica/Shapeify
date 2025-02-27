class_name DragAndZoomHandler extends Control

signal interaction_started

var texture_rect: TextureRect:
	get:
		return get_parent().texture_rect

var target_zoom: float = 1.0
var is_dragging := false
var current_translation := Vector2.ZERO
var current_zoom: float = 1.0
var _mouse_over := false

func _ready() -> void:
	texture_rect.gui_input.connect(_on_gui_input)
	texture_rect.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	texture_rect.mouse_entered.connect(func(): _mouse_over = true)
	texture_rect.mouse_exited.connect(
		func(): 
			_mouse_over = false
			target_zoom = current_zoom)


func reset():
	current_translation = Vector2.ZERO
	current_zoom = 1.0

# Returns mouse position relative to the top left of the texture rect
func _get_local_mouse_position():
	return texture_rect.get_local_mouse_position() / texture_rect.size

func _apply_zoom(factor):
	var zoom_delta = factor * 0.1
	target_zoom = clampf(target_zoom + target_zoom * zoom_delta, 0.5, 10.0)

var _previous_mouse := Vector2.ZERO

func _process(delta: float) -> void:
	if not is_visible_in_tree():
		return
	
	# Applies zoom and translation mouse interpolation to MasterRendererParams ---------------------
	var mouse_delta = Vector2.ZERO
	var mouse_local_pos = _get_local_mouse_position()
	if is_dragging:
		mouse_delta = mouse_local_pos - _previous_mouse
	
	_previous_mouse = mouse_local_pos
	
	if _mouse_over:
		# Get mouse position in world coordinates BEFORE zooming
		var mouse_world_before = current_translation + mouse_local_pos / current_zoom
		
		# Smoothly interpolate zoom
		current_zoom = lerpf(current_zoom, target_zoom, delta * 13.0) 
		
		# Get mouse position in world coordinates AFTER zooming
		var mouse_world_after = current_translation + mouse_local_pos / current_zoom
		
		# Adds the mouse delta to the translation. This is done to ensure that the
		# zoom is always made towards the mouse
		var mouse_translation_delta = mouse_world_before - mouse_world_after
		current_translation += mouse_translation_delta
	
		get_parent().camera_zoom = current_zoom
	
	# Adds drag
	current_translation -= mouse_delta / current_zoom
	current_translation = current_translation.clamp(-Vector2.ONE, Vector2.ONE)
	get_parent().camera_normalized_translation = current_translation
	
	
func _on_gui_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	
	if event is InputEventMouseButton:
		if _mouse_over and event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_apply_zoom(event.factor)
			interaction_started.emit()
			
		if _mouse_over and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_apply_zoom(-event.factor)
			interaction_started.emit()
		
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				texture_rect.mouse_default_cursor_shape = CursorShape.CURSOR_DRAG
				is_dragging = true
				interaction_started.emit()
				
			elif is_dragging and not event.pressed:
				texture_rect.mouse_default_cursor_shape = CursorShape.CURSOR_POINTING_HAND
				is_dragging = false
				
