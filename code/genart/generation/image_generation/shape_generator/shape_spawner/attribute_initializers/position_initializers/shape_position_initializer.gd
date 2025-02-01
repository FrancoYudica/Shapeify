class_name ShapePositionInitializer extends ShapeAttributeInitializer

enum Type
{
	RANDOM,
	WEIGHTED
}

static func factory_create(type: Type) -> ShapePositionInitializer:
	match type:
		Type.RANDOM:
			return load("res://generation/image_generation/shape_generator/shape_spawner/attribute_initializers/position_initializers/shape_random_position_initializer.gd").new()
		Type.WEIGHTED:
			return load("res://generation/image_generation/shape_generator/shape_spawner/attribute_initializers/position_initializers/shape_weighted_position_initializer.gd").new()
		_:
			push_error("Unimplemented ShapePositionInitializer of type %s" % type)
			return null
