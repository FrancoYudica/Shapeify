extends PanelContainer

@export var color_sampler: OptionButton

@onready var _params: IndividualGeneratorParams = Globals \
												.settings \
												.image_generator_params \
												.individual_generator_params

func _ready() -> void:

	# Color sampler option -----------------------------------------------------
	for option in ColorSamplerStrategy.Type.keys():
		color_sampler.add_item(option)
		
	color_sampler.select(_params.color_sampler)
	color_sampler.item_selected.connect(
		func(index):
			_params.color_sampler = index as ColorSamplerStrategy.Type
	)
