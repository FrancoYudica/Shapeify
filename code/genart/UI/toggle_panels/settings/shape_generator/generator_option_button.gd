extends OptionButton


var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params

func _ready() -> void:
	for type in ShapeGenerator.Type.keys():
		add_item(type)
		
	Globals.image_generator_params_updated.connect(_update)
	_update()

func _update():
	selected = _params.shape_generator_type

func _on_item_selected(index: int) -> void:
	_params.shape_generator_type = index as ShapeGenerator.Type
