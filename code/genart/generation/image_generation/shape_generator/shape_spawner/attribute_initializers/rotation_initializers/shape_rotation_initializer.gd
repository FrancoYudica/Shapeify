class_name ShapeRotationInitializer extends ShapeAttributeInitializer

enum Type
{
	RANDOM
}

static func factory_create(type: Type) -> ShapeRotationInitializer:
	match type:
		Type.RANDOM:
			return load("res://generation/image_generation/shape_generator/shape_spawner/attribute_initializers/rotation_initializers/shape_random_rotation_initializer.gd").new()
		_:
			push_error("Unimplemented ShapeRotationInitializer of type %s" % type)
			return null
