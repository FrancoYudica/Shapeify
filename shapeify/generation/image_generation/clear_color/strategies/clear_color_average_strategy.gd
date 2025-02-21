extends ClearColorStrategy

var _color_sampler: AverageColorSampler

func _init() -> void:
	_color_sampler = load("res://generation/average_color_sampler/subrect/average_subrect_color_sampler.gd").new()

func get_clear_color() -> Color:
	var rect = Rect2i(0, 0, sample_texture.get_width(), sample_texture.get_height())
	return _color_sampler.sample_rect(rect)

func set_params(params: ClearColorParams):
	pass

func _sample_texture_set():
	_color_sampler.sample_texture = sample_texture
