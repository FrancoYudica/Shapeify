extends TextureRect

var _image_generator_params: ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params 

func _ready() -> void:
	_update_target_texture()
	ImageGeneration.target_texture_updated.connect(_update_target_texture)

func _update_target_texture():
	
	if _image_generator_params.target_texture == null:
		Notifier.notify_error("Unable to update_target_texture() if target texture is null")
		return
	
	# Creates texture for the first time
	texture = _image_generator_params.target_texture
