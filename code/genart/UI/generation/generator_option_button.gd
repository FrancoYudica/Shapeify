extends OptionButton


@export var image_generation: Node

@onready var _params := Globals \
						.settings \
						.image_generator_params

func _ready() -> void:
	for type in IndividualGenerator.Type.keys():
		add_item(type)
		
	selected = IndividualGenerator.Type \
				.values() \
				.find(_params.individual_generator_type)


func _on_item_selected(index: int) -> void:
	_params.individual_generator_type = index as IndividualGenerator.Type
