extends FileDialog


func _ready() -> void:
	
	# Loads all the valid filters
	var filter = ""
	for extension in Constants.VALID_INPUT_IMAGE_EXTENSIONS:
		
		if filter.is_empty():
			filter = "*%s" % extension
			
		else:
			filter = "%s,*%s" % [filter, extension]
	
	filter = "%s; Images" % filter
	add_filter(filter)
