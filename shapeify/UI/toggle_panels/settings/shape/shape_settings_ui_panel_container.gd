extends PanelContainer


@export var keep_aspect_ratio: CheckBox
@export var clamp_position: CheckBox
@export var fixed_rotation: CheckBox
@export var fixed_rotation_value: SpinBox
@export var fixed_size: CheckBox
@export var fixed_size_width_ratio: SpinBox


var _shape_generator_params : ShapeGeneratorParams:
	get:
		return Globals \
				.settings \
				.image_generator_params \
				.shape_generator_params

func _ready() -> void:
	
	keep_aspect_ratio.toggled.connect(
		func(toggled_on):
			_shape_generator_params.keep_aspect_ratio = toggled_on
	)
	
	clamp_position.toggled.connect(
		func(toggled_on):
			_shape_generator_params.clamp_position_in_canvas = toggled_on
	)
	
	fixed_rotation.toggled.connect(
		func(toggled_on):
			_shape_generator_params.fixed_rotation = toggled_on
			fixed_rotation_value.editable = toggled_on
	)
	
	fixed_rotation_value.value_changed.connect(
		func(value):
			_shape_generator_params.fixed_rotation_angle = deg_to_rad(value)
	)

	
	fixed_size.toggled.connect(
		func(toggled_on):
			_shape_generator_params.fixed_size = toggled_on
			fixed_size_width_ratio.editable = toggled_on
	)
	
	fixed_size_width_ratio.value_changed.connect(
		func(value):
			_shape_generator_params.fixed_size_width_ratio = value * 0.01
	)
	Globals.image_generator_params_updated.connect(_update)
	_update()

func _update():
	keep_aspect_ratio.button_pressed = _shape_generator_params.keep_aspect_ratio
	clamp_position.button_pressed = _shape_generator_params.clamp_position_in_canvas
	
	fixed_rotation.button_pressed = _shape_generator_params.fixed_rotation
	fixed_rotation_value.editable = _shape_generator_params.fixed_rotation
	fixed_rotation_value.value = rad_to_deg(_shape_generator_params.fixed_rotation_angle)
	
	fixed_size.button_pressed = _shape_generator_params.fixed_size
	fixed_size_width_ratio.editable = _shape_generator_params.fixed_size
	fixed_size_width_ratio.value = _shape_generator_params.fixed_size_width_ratio * 100.0
