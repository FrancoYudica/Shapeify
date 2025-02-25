extends TextureRect

## Uses a local renderer so that rendering process doesn't interfere with
## the image generation algorithm
var _local_renderer: LocalRenderer


var _details := ImageGenerationDetails.new()

## If the current output is invalidated, the output texture must be rendered again
var _invalidated = false

func _ready() -> void:
	
	# Creates local renderer
	_local_renderer = LocalRenderer.new()
	_local_renderer.initialize(
		LocalRenderer.Type.SPRITE, 
		RenderingServer.get_rendering_device())
	
	# Connects signals
	ImageGeneration.target_texture_updated.connect(_clear)
	ImageGeneration.generation_cleared.connect(_clear)
	ImageGeneration.shape_generated.connect(_shape_generated)
	Globals.settings.color_post_processing_pipeline_params.changed.connect(_invalidate)
	resized.connect(_invalidate)
	RenderingServer.frame_pre_draw.connect(
		func():
			if _invalidated:
				_render()
				_present()
				_invalidated = false)
	
	
func _exit_tree() -> void:
	_local_renderer.delete()
	_local_renderer = null

func _clear():
	_details.shapes.clear()
	_details.clear_color = ImageGeneration.details.clear_color
	_invalidate()
	texture = null

	
func _shape_generated(shape: Shape):
	_details.shapes.append(shape)
	_invalidate()


func _invalidate():
	_invalidated = true
	

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


var _previous_color_attachment: LocalTexture

func _present():
	# Copies textures contents into TextureRect's texture
	var color_attachment = _local_renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
	
	if not color_attachment.is_valid():
		return
	
	if texture == null:
		texture = Texture2DRD.new()
		
	texture.texture_rd_rid = color_attachment.rd_rid
	
	# Stores a reference to the color attachment. This is necessary since if the renderer
	# resizes, the previous framebuffer color attachment gets removed and the output texture
	# becomes white.
	_previous_color_attachment = color_attachment
