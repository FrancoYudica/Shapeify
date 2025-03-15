extends Button

@export var split_container: SplitContainer

var _was_pressed = false

func _ready() -> void:
	pressed.connect(
		func():
			split_container.vertical = not split_container.vertical
			_was_pressed = true
	)
	
	# Automatic split orientation
	ImageGeneration.target_texture_updated.connect(_update_split_orientation)
	split_container.resized.connect(_update_split_orientation)

func _update_split_orientation():
	
	if _was_pressed:
		return
	
	var target_texture = Globals.settings.image_generator_params.target_texture
	var texture_aspect_ratio = float(target_texture.get_width()) / target_texture.get_height()
	var container_aspect_ratio = float(split_container.size.x) / split_container.size.y
	# Decide orientation based on the aspect ratios to maximize texture viewing space
	split_container.vertical = texture_aspect_ratio > 1 or container_aspect_ratio < texture_aspect_ratio
