class_name ShapeSpawnerParams extends Resource

@export var shape_position_initializer_type := ShapePositionInitializer.Type.RANDOM:
	set(value):
		if value != shape_position_initializer_type:
			shape_position_initializer_type = value
			emit_changed()

@export var shape_size_initializer_type := ShapeSizeInitializer.Type.RANDOM:
	set(value):
		if value != shape_size_initializer_type:
			shape_size_initializer_type = value
			emit_changed()

@export var shape_rotation_initializer_type := ShapeRotationInitializer.Type.RANDOM:
	set(value):
		if value != shape_rotation_initializer_type:
			shape_rotation_initializer_type = value
			emit_changed()

@export var shape_tint_initializer_type := ShapeTintInitializer.Type.RANDOM:
	set(value):
		if value != shape_tint_initializer_type:
			shape_tint_initializer_type = value
			emit_changed()

@export var shape_texture_initializer_type := ShapeTextureInitializer.Type.RANDOM:
	set(value):
		if value != shape_texture_initializer_type:
			shape_texture_initializer_type = value
			emit_changed()

@export var shape_position_initializer_params := ShapePositionInitializerParms.new()
@export var shape_texture_initializer_params := ShapeTextureInitializerParms.new()
@export var shape_size_initializer_params := ShapeSizeInitializerParms.new()

@export var textures: Array[Texture2D]

func _init() -> void:
	shape_position_initializer_params.changed.connect(emit_changed)
	shape_texture_initializer_params.changed.connect(emit_changed)
	shape_size_initializer_params.changed.connect(emit_changed)
