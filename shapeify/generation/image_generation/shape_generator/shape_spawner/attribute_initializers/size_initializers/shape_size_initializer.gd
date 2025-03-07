class_name ShapeSizeInitializer extends ShapeAttributeInitializer

enum Type
{
	RANDOM,
	PROGRESS_BASED,
	PROGRESS_BASED_CURVE,
	PROGRESS_BASED_RANDOM,
	WEIGHT_BASED_RANDOM
}

static func factory_create(type: Type) -> ShapeSizeInitializer:
	match type:
		Type.RANDOM:
			return load("res://generation/image_generation/shape_generator/shape_spawner/attribute_initializers/size_initializers/shape_random_size_initializer.gd").new()
		Type.PROGRESS_BASED:
			return load("res://generation/image_generation/shape_generator/shape_spawner/attribute_initializers/size_initializers/shape_progress_based_size_initializer.gd").new()
		Type.PROGRESS_BASED_RANDOM:
			return load("res://generation/image_generation/shape_generator/shape_spawner/attribute_initializers/size_initializers/shape_progress_based_random_size_initializer.gd").new()
		Type.WEIGHT_BASED_RANDOM:
			return load("res://generation/image_generation/shape_generator/shape_spawner/attribute_initializers/size_initializers/shape_weight_based_random_size_initializer.gd").new()
		Type.PROGRESS_BASED_CURVE:
			return load("res://generation/image_generation/shape_generator/shape_spawner/attribute_initializers/size_initializers/shape_progress_based_curve_size_initializer.gd").new()
			
		_:
			push_error("Unimplemented ShapeSizeInitializer of type %s" % type)
			return null
