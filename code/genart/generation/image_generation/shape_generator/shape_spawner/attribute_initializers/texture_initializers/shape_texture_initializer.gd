class_name ShapeTextureInitializer extends ShapeAttributeInitializer

enum Type
{
	RANDOM
}

static func factory_create(type: Type) -> ShapeTextureInitializer:
	match type:
		Type.RANDOM:
			return load("res://generation/image_generation/shape_generator/shape_spawner/attribute_initializers/texture_initializers/shape_random_texture_initializer.gd").new()
		_:
			push_error("Unimplemented ShapeTextureInitializer of type %s" % type)
			return null
