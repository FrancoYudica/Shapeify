extends GridContainer

@export var color_sampler: OptionButton

var _params : ShapeGeneratorParams:
	get:
		return Globals.settings.image_generator_params.shape_generator_params

func _ready() -> void:

	# Color sampler option -----------------------------------------------------
	for option in ColorSamplerStrategy.Type.keys():
		color_sampler.add_item(option)
		
	color_sampler.item_selected.connect(
		func(index):
			_params.color_sampler = index as ColorSamplerStrategy.Type
	)
	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	color_sampler.select(_params.color_sampler)
