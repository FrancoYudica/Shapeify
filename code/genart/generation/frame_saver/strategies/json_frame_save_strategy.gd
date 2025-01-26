extends FrameSaver


func save(
	filepath: String,
	shapes: Array[Shape],
	clear_color: Color,
	viewport_size: Vector2i,
	viewport_scale: float) -> bool:
	
	# Serializes the shapes to dicts
	var data = {"shapes": []}
	for shape in shapes:
		var s = shape.copy()
		s.position *= viewport_scale
		s.size *= viewport_scale
		data["shapes"].append(s.to_dict())
	
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
