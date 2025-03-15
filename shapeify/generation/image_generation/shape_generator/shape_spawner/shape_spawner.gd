class_name ShapeSpawner extends RefCounted

var _shape_position_initializer: ShapePositionInitializer
var _shape_size_initializer: ShapeSizeInitializer
var _shape_rotation_initializer: ShapeRotationInitializer
var _shape_tint_initializer: ShapeTintInitializer
var _shape_texture_initializer: ShapeTextureInitializer

var _shape_attribute_initializers: Array[ShapeAttributeInitializer]

func spawn_one(similarity: float) -> Shape:
	
	# Creates a shape and initializes with all the attribute initializers
	var shape := Shape.new()
	for attr_initializer in _shape_attribute_initializers:
		attr_initializer.similarity = similarity
		attr_initializer.initialize_attribute(shape)
	
	return shape

func update(
	similarity: float,
	target_texture: LocalTexture,
	source_texture: LocalTexture,
	weight_texture: LocalTexture,
	mask_texture: LocalTexture
):
	for attr_initializer in _shape_attribute_initializers:
		attr_initializer.similarity = similarity
		attr_initializer.update(
			target_texture, 
			source_texture, 
			weight_texture,
			mask_texture)

func set_params(params: ShapeSpawnerParams):
	
	# Creates all the attribute initializers
	_shape_position_initializer = ShapePositionInitializer.factory_create(params.shape_position_initializer_type)
	_shape_size_initializer = ShapeSizeInitializer.factory_create(params.shape_size_initializer_type)
	_shape_rotation_initializer = ShapeRotationInitializer.factory_create(params.shape_rotation_initializer_type)
	_shape_tint_initializer = ShapeTintInitializer.factory_create(params.shape_tint_initializer_type)
	_shape_texture_initializer = ShapeTextureInitializer.factory_create(params.shape_texture_initializer_type)
	
	# Adds to the array
	_shape_attribute_initializers.clear()
	_shape_attribute_initializers.append(_shape_position_initializer)
	_shape_attribute_initializers.append(_shape_size_initializer)
	_shape_attribute_initializers.append(_shape_rotation_initializer)
	_shape_attribute_initializers.append(_shape_tint_initializer)
	_shape_attribute_initializers.append(_shape_texture_initializer)
	
	# Sets the params
	for attribute_initializer in _shape_attribute_initializers:
		attribute_initializer.set_params(params)
