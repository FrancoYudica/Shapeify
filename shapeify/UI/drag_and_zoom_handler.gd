class_name DragAndZoomHandler extends Control

signal interaction_started

var _texture_rect: TextureRect:
	get:
		return get_parent().texture_rect

var target_zoom: float = 1.0
var is_dragging := false

var camera_view: CameraViewParams
var _mouse_over := false

func _ready() -> void:
	_texture_rect.gui_input.connect(_on_gui_input)
	_texture_rect.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_texture_rect.mouse_entered.connect(func(): _mouse_over = true)
	_texture_rect.mouse_exited.connect(
		func(): 
			_mouse_over = false
			target_zoom = camera_view.zoom)
			
	get_parent().master_renderer_params_set.connect(
		func():
			camera_view = get_parent().master_renderer_params.camera_view_params
			camera_view.attributes_resetted.connect(
				func():
					target_zoom = camera_view.zoom
			)
	)
	
func normalized_local_to_world(pos: Vector2) -> Vector2:
	return camera_view.normalized_translation + pos / camera_view.zoom

func _apply_zoom(factor):
	var zoom_delta = factor * 0.1
	target_zoom = clampf(target_zoom + target_zoom * zoom_delta, 0.5, 10.0)

var _previous_mouse := Vector2.ZERO

func _process(delta: float) -> void:
	if not is_visible_in_tree():
		return
	
	# Applies zoom and translation mouse interpolation to MasterRendererParams ---------------------
	var mouse_normalized_local = _texture_rect.get_local_mouse_position() / _texture_rect.size
	
	if _mouse_over:
		# Get mouse position in world coordinates BEFORE zooming
		var mouse_world_before = normalized_local_to_world(mouse_normalized_local)
		
		# Smoothly interpolate zoom
		camera_view.zoom = lerpf(camera_view.zoom, target_zoom, delta * 14.0) 
		
		# Get mouse position in world coordinates AFTER zooming
		var mouse_world_after = normalized_local_to_world(mouse_normalized_local)
		
		# Adds the mouse delta to the translation. This is done to ensure that the
		# zoom is always made towards the mouse
		var mouse_translation_delta = mouse_world_before - mouse_world_after
		camera_view.normalized_translation += mouse_translation_delta

	# Adds drag ------------------------------------------------------------------------------------
	var mouse_delta = Vector2.ZERO
	if is_dragging:
		mouse_delta = mouse_normalized_local - _previous_mouse
		camera_view.normalized_translation -= mouse_delta / camera_view.zoom
		camera_view.normalized_translation = camera_view.normalized_translation.clamp(-Vector2.ONE, Vector2.ONE)

	_previous_mouse = mouse_normalized_local
	
	
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
				_texture_rect.mouse_default_cursor_shape = CursorShape.CURSOR_DRAG
				is_dragging = true
				interaction_started.emit()
				
			elif is_dragging and not event.pressed:
				_texture_rect.mouse_default_cursor_shape = CursorShape.CURSOR_POINTING_HAND
				is_dragging = false
				
