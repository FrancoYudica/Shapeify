extends FileDialog


func _ready() -> void:
	
	# Loads all the valid filters
	var filter = ""
	
	# Extensions with lower and upper case are supported
	var all_extensions: Array[String] = Constants.VALID_INPUT_IMAGE_EXTENSIONS.duplicate()
	for extension in Constants.VALID_INPUT_IMAGE_EXTENSIONS:
		all_extensions.append(extension.to_upper())
	
	for extension in all_extensions:
		
		if filter.is_empty():
			filter = "*%s" % extension
			
		else:
			filter = "%s,*%s" % [filter, extension]
	
	filter = "%s; Images" % filter
	add_filter(filter)
