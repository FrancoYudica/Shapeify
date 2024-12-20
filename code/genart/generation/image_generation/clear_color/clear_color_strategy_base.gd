class_name ClearColorStrategy extends RefCounted

enum Type {
	AVERAGE,
	ANY,
	BLACK
}

var sample_texture: RendererTexture:
	set(texture):
		sample_texture = texture
		_sample_texture_set()

func get_clear_color() -> Color:
	return Color.BLACK

func set_params(params: ClearColorParams):
	pass

func _sample_texture_set():
	pass

static func factory_create(type: Type) -> ClearColorStrategy:
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
