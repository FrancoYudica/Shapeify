extends PanelContainer


@export var stop_condition: OptionButton
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
func _on_individual_count_spin_box_value_changed(value: float) -> void:
	_params.individual_count = value
