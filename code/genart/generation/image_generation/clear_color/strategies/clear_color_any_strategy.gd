extends ClearColorStrategy

var _clear_color: Color

func get_clear_color() -> Color:
	return _clear_color

func set_params(params: ClearColorParams):
	_clear_color = params.color
