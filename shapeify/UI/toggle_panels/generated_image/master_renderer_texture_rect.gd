class_name MasterRendererOutput extends PanelContainer

@export var texture_rect: TextureRect
@export var aspect_ratio_conatiner: AspectRatioContainer

## Uses a local renderer so that rendering process doesn't interfere with
## the image generation algorithm
var _local_renderer: LocalRenderer

## If the current output is invalidated, the output texture must be rendered again
var _invalidated = false

var _zoom: float = 1.0
var _translation := Vector2.ZERO
var _mouse_drag_position := Vector2.ZERO
var _is_dragging := false

var _current_zoom: float = 1.0

var master_renderer_params: MasterRendererParams:
	set(value):
		
		if value != master_renderer_params:
			master_renderer_params = value
			master_renderer_params.changed.connect(invalidate)
			invalidate()


func _ready() -> void:
	
	# Creates local renderer
	_local_renderer = LocalRenderer.new()
	
	# Uses the global rendering device. This way the texture update is faster
	_local_renderer.initialize(RenderingServer.get_rendering_device())
	
	# Connects signals
	texture_rect.resized.connect(invalidate)
	visibility_changed.connect(
		func():
			if is_visible_in_tree():
				invalidate())
	RenderingServer.frame_pre_draw.connect(
		func():
			if _invalidated:
				_render()
				_present()
				_invalidated = false)
	
	texture_rect.gui_input.connect(_on_gui_input)
	
# Returns mouse position relative to the top left of the texture rect
func _get_local_mouse_position():
	return texture_rect.get_local_mouse_position()

func _apply_zoom(factor):
	var zoom_delta = factor * 0.1
	_zoom = clampf(_zoom + _zoom * zoom_delta, 0.5, 10.0)

func _exit_tree() -> void:
	_local_renderer.delete()
	_local_renderer = null

func invalidate():
	_invalidated = true

func _process(delta: float) -> void:
	if master_renderer_params == null or not is_visible_in_tree():
		return
	
	# Applies zoom and translation mouse interpolation to MasterRendererParams ---------------------
	var mouse_delta = Vector2.ZERO
	var mouse_local_pos = _get_local_mouse_position()
	if _is_dragging:
		mouse_delta = mouse_local_pos - _mouse_drag_position
		
	# Get mouse position in world coordinates BEFORE zooming
	var mouse_world_before = _translation + mouse_local_pos / _current_zoom
	
	# Smoothly interpolate zoom
	_current_zoom = lerpf(_current_zoom, _zoom, delta * 13.0) 
	
	# Get mouse position in world coordinates AFTER zooming
	var mouse_world_after = _translation + mouse_local_pos / _current_zoom
	
	# Adds the mouse delta to the translation. This is done to ensure that the
	# zoom is always made towards the mouse
	var mouse_translation_delta = mouse_world_before - mouse_world_after
	_translation += mouse_translation_delta
	
	master_renderer_params.camera_translation = _translation - mouse_delta / _current_zoom
	master_renderer_params.camera_zoom = _current_zoom
	
func _render():
	
	if master_renderer_params == null or not is_visible_in_tree():
		return
	
	var target_texture = Globals.settings.image_generator_params.target_texture
	var aspect_ratio = float(target_texture.get_width()) / target_texture.get_height()
	aspect_ratio_conatiner.ratio = aspect_ratio
	MasterRenderer.render(_local_renderer, texture_rect.size, master_renderer_params)


var _previous_color_attachment: LocalTexture

func _present():
	# Copies textures contents into TextureRect's texture
	var color_attachment = _local_renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
	
	if not color_attachment.is_valid():
		return
	
	if texture_rect.texture == null:
		texture_rect.texture = Texture2DRD.new()
		
	texture_rect.texture.texture_rd_rid = color_attachment.rd_rid
	
	# Stores a reference to the color attachment. This is necessary since if the renderer
	# resizes, the previous framebuffer color attachment gets removed and the output texture
	# becomes white.
	_previous_color_attachment = color_attachment


func _on_gui_input(event: InputEvent) -> void:
	if master_renderer_params == null or not is_visible_in_tree():
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_apply_zoom(event.factor)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_apply_zoom(-event.factor)
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				texture_rect.mouse_default_cursor_shape = CursorShape.CURSOR_DRAG
				# Stores the clicked position
				_mouse_drag_position = _get_local_mouse_position()
				_is_dragging = true
				
			elif _is_dragging and not event.pressed:
				texture_rect.mouse_default_cursor_shape = CursorShape.CURSOR_POINTING_HAND
				# When releasing updates the translation
				var mouse_delta = _get_local_mouse_position() - _mouse_drag_position
				_translation -= mouse_delta / _zoom
				_is_dragging = false
