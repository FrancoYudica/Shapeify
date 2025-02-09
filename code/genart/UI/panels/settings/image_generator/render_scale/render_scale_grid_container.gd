extends GridContainer

@export var render_scale_spin_box: SpinBox

var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params

func _ready() -> void:
	
	# Render scale -------------------------------------------------------------
	render_scale_spin_box.value_changed.connect(
		func(value):
			_params.render_scale = value
	)

	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	render_scale_spin_box.value = _params.render_scale
