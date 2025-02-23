extends Node

@export var _weight_texture_rect: TextureRect
@export var _load_texture_button: Button
@export var _image_file_dialog: FileDialog
@export var _texture_label: Label
@export var weight_texture_generator_picker: WeightTextureGeneratorPicker

var _params: WeightTextureGeneratorParams:
	get:
		return weight_texture_generator_picker.params
						
func _ready() -> void:
	
	_load_texture_button.pressed.connect(
		func():
			_image_file_dialog.visible = true
	)
	
	_image_file_dialog.file_selected.connect(
		func(filepath):
				
			var image = Image.load_from_file(filepath)
			
			if image == null:
				Notifier.notify_error("Unable to load image")
				return
			
			var texture = ImageTexture.create_from_image(image)
			_params.user_weight_texture = texture
			_weight_texture_rect.texture = texture
			_set_texture(texture)
	)
	
	weight_texture_generator_picker.params_updated.connect(_update)
	
func _process(delta: float) -> void:
	_texture_label.visible = _params.user_weight_texture == null

func _update():
	_set_texture(_params.user_weight_texture)

func _set_texture(texture: Texture2D):
	_weight_texture_rect.texture = texture
