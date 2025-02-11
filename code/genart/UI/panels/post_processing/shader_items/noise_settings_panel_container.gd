extends PanelContainer

@export var toggle_button: CheckBox
@export var type_option_button: OptionButton
@export var frequency_spin: SpinBox
@export var seed_spin: SpinBox
@export var texture_rect: TextureRect
@export var contents_panel: Control

var noise_settings: NoiseSettings:
	set(value):
		noise_settings = value
		_update()
		_update_texture()
		noise_settings.changed.connect(_update_texture)

var disabled: bool:
	set(value):
		disabled = value
		toggle_button.disabled = value
		contents_panel.visible = not disabled
		

var _noise_types = {
	"Perlin": FastNoiseLite.TYPE_PERLIN,
	"Cellular": FastNoiseLite.TYPE_CELLULAR,
	"Simplex": FastNoiseLite.TYPE_SIMPLEX
}

func _ready() -> void:
	
	for item in _noise_types.keys():
		type_option_button.add_item(item)
	
	type_option_button.item_selected.connect(
		func(index):
			noise_settings.type = _noise_types.values()[index]
	)
	
	frequency_spin.value_changed.connect(
		func(value):
			noise_settings.frequency = value
	)
	
	seed_spin.value_changed.connect(
		func(value):
			noise_settings.seed = value
	)

func _update():
	if type_option_button.item_count != 0:
		type_option_button.select(_noise_types.values().find(noise_settings.type))
	frequency_spin.value = noise_settings.frequency
	seed_spin.value = noise_settings.seed
	
func _update_texture():
	texture_rect.texture = ImageTexture.create_from_image(
		NoiseSettings.create_fast_noise_image(noise_settings))
