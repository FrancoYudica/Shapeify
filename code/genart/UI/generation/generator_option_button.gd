extends OptionButton


@export var image_generation: Node

var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params

func _ready() -> void:
	for type in IndividualGenerator.Type.keys():
		add_item(type)
		
	Globals.image_generator_params_updated.connect(_update)
	_update()

func _update():
	selected = _params.individual_generator_type

func _on_item_selected(index: int) -> void:
	_params.individual_generator_type = index as IndividualGenerator.Type
