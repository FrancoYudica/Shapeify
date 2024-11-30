extends OptionButton


@export var image_generation: Node

@onready var _params := Globals \
						.settings \
						.image_generator_params

func _ready() -> void:
	for type in ImageGeneratorParams.IndividualGeneratorType.keys():
		add_item(type)
		
	selected = ImageGeneratorParams \
				.IndividualGeneratorType \
				.values() \
				.find(_params.individual_generator_type)


func _on_item_selected(index: int) -> void:
	_params.individual_generator_type = index as ImageGeneratorParams.IndividualGeneratorType
	image_generation.set_individual_generator_type(_params.individual_generator_type)
