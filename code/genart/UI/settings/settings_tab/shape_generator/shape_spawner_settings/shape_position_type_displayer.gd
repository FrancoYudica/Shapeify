extends PanelContainer

@export var position_type: ShapePositionInitializer.Type

var _type: ShapePositionInitializer.Type:
	get:
		return Globals \
			.settings \
			.image_generator_params \
			.shape_generator_params \
			.shape_spawner_params \
			.shape_position_initializer_type

func _process(_delta: float) -> void:
	visible = _type == position_type
