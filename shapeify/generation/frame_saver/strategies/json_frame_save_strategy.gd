extends FrameSaver


func save(
	filepath: String,
	local_renderer: LocalRenderer,
	master_renderer_params: MasterRendererParams,
	viewport_size: Vector2i) -> bool:
	
	# Serializes the shapes to dicts
	var data = {"shapes": []}
	for shape in master_renderer_params.shapes:
		data["shapes"].append(shape.to_dict())
	
	# opens file
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	
	if file == null:
		Notifier.notify_error("Unable to access filepath: %s" % filepath)
		return false
	
	# Transforms to JSON and writes
	var string = JSON.stringify(data, "	")
	file.store_string(string)

	if not silent:
		Notifier.notify_info("Successfully saved JSON at: %s" % filepath, filepath)
	return true

	
func get_extension() -> String:
	return ".json"
