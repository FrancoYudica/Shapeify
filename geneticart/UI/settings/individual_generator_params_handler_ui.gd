extends PanelContainer

@export var clear_color_average: CheckBox

@onready var individual_generator_params: IndividualGeneratorParams = Globals \
																	.settings \
																	.image_generator_params \
																	.individual_generator_params

func _ready() -> void:
	clear_color_average.button_pressed = individual_generator_params.clear_color_average

func _on_clear_color_average_check_box_toggled(toggled_on: bool) -> void:
	individual_generator_params.clear_color_average = toggled_on
