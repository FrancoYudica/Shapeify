class_name ShapeTintInitializer extends ShapeAttributeInitializer

enum Type
{
	RANDOM
}

static func factory_create(type: Type) -> ShapeTintInitializer:
	match type:
		Type.RANDOM:
			return load("res://generation/image_generation/shape_generator/shape_spawner/attribute_initializers/tint_initializers/shape_random_tint_initializer.gd").new()
		_:
			push_error("Unimplemented ShapeTintInitializer of type %s" % type)
			return null
