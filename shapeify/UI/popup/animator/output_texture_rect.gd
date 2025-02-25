extends TextureRect

@export var animator: Node

var _local_renderer: LocalRenderer
var _shape_textures_map: Dictionary = {}
var _shapes: Array[Shape]
var _invalidated := false
var _want_to_present := false

func _ready() -> void:
	_local_renderer = LocalRenderer.new()
	_local_renderer.initialize(
		LocalRenderer.Type.SPRITE, 
		RenderingServer.get_rendering_device())
	
	animator.shapes_animated.connect(_animated_shapes)
	
	visibility_changed.connect(func(): _shape_textures_map.clear())
	
	RenderingServer.frame_pre_draw.connect(
		func():
			if _invalidated:
				_render()
				_invalidated = false
				_want_to_present = true)
	
	RenderingServer.frame_post_draw.connect(
		func():
			if _want_to_present:
				_present()
				_want_to_present = false
	)
	
	ImageGeneration.target_texture_updated.connect(
		func():
			texture = null
	)
	
func _exit_tree() -> void:
	_local_renderer.delete()
	_local_renderer = null
	_shape_textures_map.clear()

	
func _animated_shapes(shapes: Array[Shape]):
	_shapes = shapes
	_invalidated = true
	
func _render():
	var local_texture_shapes: Array[Shape] = []
	for shape in _shapes:

		if not _shape_textures_map.has(shape.texture.rd_rid):
			_shape_textures_map[shape.texture.rd_rid] = shape.texture.copy(_local_renderer.rd)
	
		var local_shape = shape.copy()
		local_shape.texture = _shape_textures_map[shape.texture.rd_rid]
		local_texture_shapes.append(local_shape)

	var master_renderer_params = MasterRendererParams.new()
	master_renderer_params.shapes = local_texture_shapes
	master_renderer_params.clear_color = ImageGeneration.master_renderer_params.clear_color
	master_renderer_params.post_processing_pipeline_params = ImageGeneration.master_renderer_params.post_processing_pipeline_params

	var target_texture = Globals.settings.image_generator_params.target_texture
	var aspect_ratio = float(target_texture.get_width()) / target_texture.get_height()
	var render_viewport_size = Vector2i(size.y * aspect_ratio, size.y)

	MasterRenderer.render(
		_local_renderer,
		render_viewport_size,
		master_renderer_params)

func _present():
	# Copies textures contents into TextureRect's texture
	var color_attachment = _local_renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
	
	if not color_attachment.is_valid():
		return
	
	if texture == null:
		texture = Texture2DRD.new()

	texture.texture_rd_rid = color_attachment.rd_rid
