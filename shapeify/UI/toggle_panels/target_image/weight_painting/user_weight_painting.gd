extends Control

@export var texture_sub_viewport: SubViewport
@export var output_texture_rect: TextureRect

var brush_size: float = 0.1

class Point:
	var normalized_position: Vector2
	var normalized_size: Vector2
	var texture: Texture2D

var _points: Array[Point] = []
var _current_texture: LocalTexture
var _local_renderer: LocalRenderer
var _invalidated: bool = false
var _painting: bool = false

func _ready() -> void:
	gui_input.connect(_gui_input)
	
	_local_renderer = LocalRenderer.new()
	_local_renderer.initialize(
		RenderingServer.get_rendering_device(),
		LocalRenderer.BlendMode.ADD)
		
	RenderingServer.frame_pre_draw.connect(
		func():
			if _invalidated:
				_render()
				_invalidated = false)

var _previous_mouse_pos: Vector2

func _process(delta: float) -> void:

	if _painting:
		var mouse_pos = get_local_mouse_position()
		
		var mouse_delta = mouse_pos - _previous_mouse_pos
		var mouse_delta_length = mouse_delta.length()
		var spawn_step_length = (brush_size * size.x) * 0.15
		if mouse_delta_length < spawn_step_length:
			return
		
		var spawn_count = max(int(mouse_delta_length / spawn_step_length), 1)
		
		for i in range(spawn_count):
			var spawn_position = _previous_mouse_pos + (float(i) / spawn_count) * mouse_delta
			_add_point(spawn_position)
			
		_previous_mouse_pos = mouse_pos
	
	if _invalidated:
		_render()
		_invalidated = false

func _exit_tree() -> void:
	_local_renderer.delete()
	_local_renderer = null

func invalidate():
	_invalidated = true

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_painting = event.pressed
			if _painting:
				_add_point(event.position)
				_previous_mouse_pos = event.position
			
func _add_point(pos: Vector2):
	
	if _current_texture == null:
		_current_texture = LocalTexture.load_from_texture(
			texture_sub_viewport.get_texture(),
			_local_renderer.rd)
			
		_current_texture.create_image().save_png("/tmp/gradient.png")
	
	var point = Point.new()
	point.normalized_position = pos / size
	point.normalized_size = Vector2.ONE * brush_size
	point.texture = _current_texture
	_points.append(point)
	invalidate()

var _previous_color_attachment: LocalTexture

func _render():
	if not is_visible_in_tree():
		return
	
	_local_renderer.begin_frame(
		size,
		1.0,
		Vector2.ZERO)
		
	for point in _points:
		_local_renderer.render_sprite(
			point.normalized_position * size,
			point.normalized_size * size,
			0.0,
			Color.WHITE,
			point.texture)
	
	_local_renderer.end_frame()
	
	
	# Copies textures contents into TextureRect's texture
	var color_attachment = _local_renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
	
	if not color_attachment.is_valid():
		return
	
	if output_texture_rect.texture == null:
		output_texture_rect.texture = Texture2DRD.new()
		
	output_texture_rect.texture.texture_rd_rid = color_attachment.rd_rid
	
	# Stores a reference to the color attachment. This is necessary since if the renderer
	# resizes, the previous framebuffer color attachment gets removed and the output texture
	# becomes white.
	_previous_color_attachment = color_attachment
