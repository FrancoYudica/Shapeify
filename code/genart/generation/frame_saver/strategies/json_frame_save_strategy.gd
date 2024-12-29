extends FrameSaver


func save(
	filepath: String,
	individuals: Array[Individual],
	clear_color: Color,
	viewport_size: Vector2i,
	viewport_scale: float) -> bool:
	
	# Serializes the individuals to dicts
	var data = {"individuals": []}
	for individual in individuals:
		var ind = individual.copy()
		ind.position *= viewport_scale
		ind.size *= viewport_scale
		data["individuals"].append(individual.to_dict())
	
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
