extends TextureRect

@export var animator: Node

func _ready() -> void:
	animator.shapes_animated.connect(_animated_shapes)
	
func _exit_tree() -> void:
	_free_texture()

func _process(delta: float) -> void:
	if not is_visible_in_tree():
		_free_texture()
		

func _animated_shapes(shapes: Array[Shape]):
	
	var raw_details = animator.image_generation_details.copy()
	
	# Updates the details shapes
	raw_details.shapes = shapes
	
	# Prepares details
	var processed_details := await ShapeColorPostProcessingPipeline.process_details(
		raw_details,
		0,
		Globals.settings.color_post_processing_pipeline_params.shader_params
	)
	
	# Renders the image
	ImageGenerationRenderer.render_image_generation(Renderer, processed_details)
	
	# Creates texture
	if texture == null:
		_create_texture()
	
	# Copies textures contents into TextureRect's texture
	var color_attachment = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	RenderingCommon.texture_copy(
		color_attachment.rd_rid,
		texture.texture_rd_rid,
		Renderer.rd,
		RenderingServer.get_rendering_device()
	)

func _create_texture():
	_free_texture()

	var attachment: RendererTexture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	var texture_rd: Texture2DRD = RenderingCommon.create_texture_from_rd_rid(attachment.rd_rid)
	
	texture = texture_rd


func _free_texture():
	
	if texture == null:
		return
	
	var rd = RenderingServer.get_rendering_device()
	var texture_rd_rid = texture.texture_rd_rid
	texture.texture_rd_rid = RID()
	texture = null
	rd.free_rid(texture_rd_rid)
