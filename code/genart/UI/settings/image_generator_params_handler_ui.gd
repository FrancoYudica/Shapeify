extends PanelContainer


@export var stop_condition: OptionButton
@export var clear_color: OptionButton

@onready var _params := Globals.settings.image_generator_params

func _ready() -> void:
	
	# Stop condition option ----------------------------------------------------
	for option in StopCondition.Type.keys():
		stop_condition.add_item(option)
		
	stop_condition.select(_params.stop_condition)
	stop_condition.item_selected.connect(
		func(index):
			_params.stop_condition = index as StopCondition.Type
	)

	# Clear color option ----------------------------------------------------
	for option in ClearColorStrategy.Type.keys():
		clear_color.add_item(option)
		
	clear_color.select(_params.clear_color_type)
	clear_color.item_selected.connect(
		func(index):
			_params.clear_color_type = index as ClearColorStrategy.Type
	)
