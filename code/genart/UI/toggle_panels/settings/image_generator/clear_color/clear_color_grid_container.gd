extends GridContainer

@export var clear_color: OptionButton

var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params

func _ready() -> void:
	
	# Clear color option -------------------------------------------------------
	for option in ClearColorStrategy.Type.keys():
		clear_color.add_item(option)
		
	clear_color.item_selected.connect(
		func(index):
			_params.clear_color_type = index as ClearColorStrategy.Type
	)
	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	clear_color.select(_params.clear_color_type)
