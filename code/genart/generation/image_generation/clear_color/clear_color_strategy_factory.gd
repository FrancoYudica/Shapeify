class_name ClearColorStrategyFactory extends Object

static func create(type: ClearColorStrategy.Type) -> ClearColorStrategy:
	match type:
		ClearColorStrategy.Type.BLACK:
			return load("res://generation/image_generation/clear_color/strategies/clear_color_black_strategy.gd").new()
		ClearColorStrategy.Type.AVERAGE:
			return load("res://generation/image_generation/clear_color/strategies/clear_color_average_strategy.gd").new()
		ClearColorStrategy.Type.ANY:
			return load("res://generation/image_generation/clear_color/strategies/clear_color_any_strategy.gd").new()
		_:
			push_error("Unimplemented ClearColorStrategyType: %s" % ClearColorStrategy.Type.keys()[type])
			return null
