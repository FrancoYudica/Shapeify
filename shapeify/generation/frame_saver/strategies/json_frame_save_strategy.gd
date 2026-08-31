extends FrameSaver


func save(
	filepath: String,
	local_renderer: LocalRenderer,
	master_renderer_params: MasterRendererParams,
	viewport_size: Vector2i) -> bool:
	
	# Serializes the shapes to dicts
	var data = {
		"background_color": [
			master_renderer_params.clear_color.r,
			master_renderer_params.clear_color.g,
			master_renderer_params.clear_color.b
		],
		"shapes": []}
	var texture_paths = {}
	for shape in master_renderer_params.shapes:
		var shape_dict = shape.to_dict()
		shape_dict.erase("fitness")
		data["shapes"].append(shape_dict)
		texture_paths[shape.texture.resource_path] = shape.texture
	
	# opens file
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	
	if file == null:
		Notifier.notify_error("Unable to access filepath: %s" % filepath)
		return false
	
	# Transforms to JSON and writes
	var string = JSON.stringify(data, "	")
	file.store_string(string)
	
	# Saves shape textures to same path
	var directory = filepath.get_base_dir()
	for texture_path in texture_paths:
		var texture = load(texture_path)
		var image = texture.get_image()
		image.decompress()
		var texture_name = texture.resource_path.get_file()
		var save_filepath = directory.path_join(texture_name)
		image.save_png(save_filepath)
	
	if not silent:
		Notifier.notify_info("Successfully saved JSON at: %s" % filepath, filepath)
	return true

	
func get_extension() -> String:
	return ".shy.json"
