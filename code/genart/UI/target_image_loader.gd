extends Node

@export var image_generation: Node

var _image_generator_params: ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params 

var _generating = false

func _ready() -> void:
	Globals.generation_started.connect(
		func():
			_generating = true
	)
	Globals.generation_finished.connect(
		func():
			_generating = false
	)

func load_target_image_from_filepath(filepath: String) -> void:
	
	if _generating:
		Notifier.notify_warning("Unable to load target image during image generation")
		return
	
	if not ImageUtils.is_input_format_supported(filepath):
		Notifier.notify_warning(
			"Unable to load image: %s\n\
			Unsuported file format: %s" % [filepath, filepath.split(".")[1]])
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
	var final_texture_size: Vector2 = Vector2(src_width, src_height)
	
	if pixel_count > Constants.MAX_PIXEL_COUNT:
		var aspect_ratio = float(src_width) / src_height
		var new_height = floori(sqrt(Constants.MAX_PIXEL_COUNT / aspect_ratio))
		var new_width = floori(aspect_ratio * new_height)
		final_texture_size = Vector2(new_width, new_height)
		
		Notifier.notify_warning(
			"Target texture resolution is %sx%s, which has too many pixels to process.\n\
			Target texture was downscaled to resolution %sx%s. \n\
			Keep in mind that larger textures take longer to compute" % [
			src_width,
			src_height,
			new_width,
			new_height
		])
		
	Renderer.begin_frame(Vector2i(final_texture_size.x, final_texture_size.y))
	Renderer.render_sprite(
		final_texture_size * 0.5,
		final_texture_size,
		0.0,
		Color.WHITE,
		renderer_texture,
		0)
	Renderer.end_frame()
		
	renderer_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR).copy()

	if renderer_texture == null or not renderer_texture.is_valid():
		Notifier.notify_error("Unable to load texture")
		return
	
	_image_generator_params.target_texture = renderer_texture
	image_generation.refresh_target_texture()
