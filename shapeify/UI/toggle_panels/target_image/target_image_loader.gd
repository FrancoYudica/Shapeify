extends Node

func load_target_image_from_filepath(filepath: String) -> void:
	
	if ImageGeneration.is_generating:
		Notifier.notify_warning("Unable to load target image during image generation")
		return
	
	if not ImageUtils.is_input_format_supported(filepath):
		Notifier.notify_warning(
			"Unable to load image: %s\n\
			Unsuported file format: %s" % [filepath, filepath.split(".")[1]])
		return

	var image = Image.load_from_file(filepath)
	if image == null:
		Notifier.notify_error("Dropped image is null. File format not supported")
		return
	
	ImageGeneration.set_target_texture(ImageTexture.create_from_image(image))
