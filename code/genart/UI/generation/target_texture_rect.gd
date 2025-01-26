extends TextureRect

@export var image_generation: Node

var _individual_generation_params: ShapeGeneratorParams:
	get:
		return Globals.settings.image_generator_params.shape_generator_params 

func _ready() -> void:
	_update_target_texture()

func _exit_tree() -> void:
	_free_texture()

func _on_image_loader_image_file_dropped(filepath: String) -> void:
	
	if not is_visible_in_tree():
		return
	
	var renderer_texture := RendererTexture.load_from_path(filepath)
	
	if renderer_texture == null:
		Notifier.notify_error("Dropped texture is null. File format not supported")
		return
	
	# If the pixel count is greater than the limit, the texture is downscaled to
	# satisfy the pixel count constraint
	var src_width =  renderer_texture.get_width()
	var src_height = renderer_texture.get_height()
	var pixel_count = src_width * src_height
	if pixel_count > Constants.MAX_PIXEL_COUNT:
		var aspect_ratio = float(src_width) / src_height
		
		var new_height = floori(sqrt(Constants.MAX_PIXEL_COUNT / aspect_ratio))
		var new_width = floori(aspect_ratio * new_height)
		
		Renderer.begin_frame(Vector2i(new_width, new_height))
		Renderer.render_sprite(
			Vector2(new_width, new_height) * 0.5,
			Vector2(new_width, new_height),
			0.0,
			Color.WHITE,
			renderer_texture,
			0)
		Renderer.end_frame()
		
		renderer_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR).copy()

		Notifier.notify_warning(
			"Target texture resolution is %sx%s, which has too many pixels to process.\n\
			Target texture was downscaled to resolution %sx%s. \n\
			Keep in mind that larger textures take longer to compute" % [
			src_width,
			src_height,
			new_width,
			new_height
		])

	if renderer_texture == null or not renderer_texture.is_valid():
		Notifier.notify_error("Unable to load texture")
		return
	
	_individual_generation_params.target_texture = renderer_texture
	image_generation.refresh_target_texture()
	# Frees previous texture and updates
	_free_texture()
	_update_target_texture()
	
func _free_texture():
	var rd = RenderingServer.get_rendering_device()
	var texture_rd_rid = texture.texture_rd_rid
	texture.texture_rd_rid = RID()
	texture = null
	rd.free_rid(texture_rd_rid)


func _update_target_texture():
	
	var target_texture: RendererTexture = _individual_generation_params.target_texture
	if target_texture == null or not target_texture.is_valid():
		Notifier.notify_error("Unable to update_target_texture() if target texture is null")
		return
	
	# Creates texture for the first time
	texture = RenderingCommon.create_texture_from_rd_rid(target_texture.rd_rid)
