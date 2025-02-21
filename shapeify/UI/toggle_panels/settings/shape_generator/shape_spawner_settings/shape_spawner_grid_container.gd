extends GridContainer

@export var position_initializer_option: OptionButton
@export var size_initializer_option: OptionButton
@export var rotation_initializer_option: OptionButton
@export var tint_initializer_option: OptionButton
@export var texture_initializer_option: OptionButton


var _params: ShapeSpawnerParams:
	get:
		return Globals \
			.settings \
			.image_generator_params \
			.shape_generator_params \
			.shape_spawner_params


func _ready() -> void:
	
	# Sets option button types
	for option in ShapePositionInitializer.Type.keys():
		position_initializer_option.add_item(option)

	for option in ShapeSizeInitializer.Type.keys():
		size_initializer_option.add_item(option)

	for option in ShapeRotationInitializer.Type.keys():
		rotation_initializer_option.add_item(option)

	for option in ShapeTintInitializer.Type.keys():
		tint_initializer_option.add_item(option)

	for option in ShapeTextureInitializer.Type.keys():
		texture_initializer_option.add_item(option)

	# Sets selected callbacks
	position_initializer_option.item_selected.connect(
		func(index):
			_params.shape_position_initializer_type = index
	)

	size_initializer_option.item_selected.connect(
		func(index):
			_params.shape_size_initializer_type = index
	)

	rotation_initializer_option.item_selected.connect(
		func(index):
			_params.shape_rotation_initializer_type = index
	)

	tint_initializer_option.item_selected.connect(
		func(index):
			_params.shape_tint_initializer_type = index
	)

	texture_initializer_option.item_selected.connect(
		func(index):
			_params.shape_texture_initializer_type = index
	)

	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	position_initializer_option.select(_params.shape_position_initializer_type)
	size_initializer_option.select(_params.shape_size_initializer_type)
	rotation_initializer_option.select(_params.shape_rotation_initializer_type)
	tint_initializer_option.select(_params.shape_tint_initializer_type)
	texture_initializer_option.select(_params.shape_texture_initializer_type)
