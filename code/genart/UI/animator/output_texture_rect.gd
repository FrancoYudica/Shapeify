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
	
	_render_shapes(shapes)
	_update_texture()


func _render_shapes(shapes):
	
	var details: ImageGenerationDetails = animator.image_generation_details
	var viewport_size = details.viewport_size / details.render_scale
	Renderer.begin_frame(viewport_size)
	
	# Renders background
	Renderer.render_clear(animator.image_generation_details.clear_color)
	
	# Renders shapes
	for shape in shapes:
		Renderer.render_sprite(
			shape.position / details.render_scale,
			shape.size / details.render_scale,
			shape.rotation,
			shape.tint,
			shape.texture,
			1.0)
	Renderer.end_frame()
	

func _create_texture():
	_free_texture()

	var attachment: RendererTexture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	var texture_rd: Texture2DRD = RenderingCommon.create_texture_from_rd_rid(attachment.rd_rid)
	
	texture = texture_rd


func _update_texture():
	
	if texture == null:
		_create_texture()

	var color_attachment = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	RenderingCommon.texture_copy(
		color_attachment.rd_rid,
		texture.texture_rd_rid,
		Renderer.rd,
		RenderingServer.get_rendering_device()
	)

func _free_texture():
	
	if texture == null:
		return
	
	var rd = RenderingServer.get_rendering_device()
	var texture_rd_rid = texture.texture_rd_rid
	texture.texture_rd_rid = RID()
	texture = null
	rd.free_rid(texture_rd_rid)
