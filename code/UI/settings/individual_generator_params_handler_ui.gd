extends PanelContainer

@export var clear_color_average: CheckBox
@export var color_sampler: OptionButton

@onready var _params: IndividualGeneratorParams = Globals \
												.settings \
												.image_generator_params \
												.individual_generator_params

func _ready() -> void:
	clear_color_average.button_pressed = _params.clear_color_average

	# Color sampler option -----------------------------------------------------
	for option in ColorSamplerStrategy.Type.keys():
		color_sampler.add_item(option)
		
	color_sampler.select(_params.color_sampler)
	color_sampler.item_selected.connect(
		func(index):
			_params.color_sampler = index as ColorSamplerStrategy.Type
	)

func _on_clear_color_average_check_box_toggled(toggled_on: bool) -> void:
	_params.clear_color_average = toggled_on
