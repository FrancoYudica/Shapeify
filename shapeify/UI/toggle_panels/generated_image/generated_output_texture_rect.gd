extends TextureRect

## Uses a local renderer so that rendering process doesn't interfere with
## the image generation algorithm
var _local_renderer: LocalRenderer

## Maps the algorithm RD textures to this renderer device textures
var _shape_textures_map: Dictionary

var _details := ImageGenerationDetails.new()

func _ready() -> void:
	
	# Creates local renderer
	_local_renderer = LocalRenderer.new()
	_local_renderer.initialize(
		LocalRenderer.Type.SPRITE, 
		RenderingServer.create_local_rendering_device())
	
	# Connects signals
	ImageGeneration.target_texture_updated.connect(_clear)
	ImageGeneration.generation_cleared.connect(_clear)
	ImageGeneration.shape_generated.connect(_shape_generated)
	Globals.settings.color_post_processing_pipeline_params.changed.connect(_render)
	resized.connect(_render)

func _clear():
	_shape_textures_map.clear()
	_details.shapes.clear()
	_details.clear_color = ImageGeneration.details.clear_color
	_render()

	
func _shape_generated(shape: Shape):
	
	if not _shape_textures_map.has(shape.texture.rd_rid):
		_shape_textures_map[shape.texture.rd_rid] = shape.texture.copy(_local_renderer.rd)
	
	var local_shape = shape.copy()
	local_shape.texture = _shape_textures_map[shape.texture.rd_rid]
	_details.shapes.append(local_shape)
	
	_render()

func _render():
	
	var target_texture = Globals.settings.image_generator_params.target_texture
	var aspect_ratio = float(target_texture.get_width()) / target_texture.get_height()
	
	var render_viewport_size = Vector2i(size.y * aspect_ratio, size.y)
	
	var master_renderer_params := MasterRendererParams.new()
	master_renderer_params.clear_color = ImageGeneration.master_renderer_params.clear_color
	master_renderer_params.post_processing_pipeline_params = Globals.settings.color_post_processing_pipeline_params
	master_renderer_params.shapes = _details.shapes
	
	MasterRenderer.render(
		_local_renderer,
		render_viewport_size,
		master_renderer_params
	)
	texture = _local_renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR).create_texture_2d_rd()
