extends GridContainer

@export var stop_condition: OptionButton

var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params

func _ready() -> void:
	
	# Stop condition option ----------------------------------------------------
	for option in StopCondition.Type.keys():
		stop_condition.add_item(option)
		
	stop_condition.item_selected.connect(
		func(index):
			_params.stop_condition = index as StopCondition.Type
	)

	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	stop_condition.select(_params.stop_condition)
