class_name ShapePositionInitializer extends ShapeAttributeInitializer

enum Type
{
	RANDOM,
	USE_WEIGHT_TEXTURE,
	CUSTOM_WEIGHT_TEXTURE
}

static func factory_create(type: Type) -> ShapePositionInitializer:
	match type:
		Type.RANDOM:
			return load("res://generation/image_generation/shape_generator/shape_spawner/attribute_initializers/position_initializers/shape_random_position_initializer.gd").new()
		Type.USE_WEIGHT_TEXTURE:
			return load("res://generation/image_generation/shape_generator/shape_spawner/attribute_initializers/position_initializers/shape_use_weight_position_initializer.gd").new()
		Type.CUSTOM_WEIGHT_TEXTURE:
			return load("res://generation/image_generation/shape_generator/shape_spawner/attribute_initializers/position_initializers/shape_custom_weight_position_initializer.gd").new()
		_:
			push_error("Unimplemented ShapePositionInitializer of type %s" % type)
			return null
