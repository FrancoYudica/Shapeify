extends FileDialog


func _ready() -> void:
	
	# Loads all the valid filters
	for extension in Constants.VALID_INPUT_IMAGE_EXTENSIONS:
		var filter = "*%s" % extension
		add_filter(filter)
