## Generates the initial population of the algorithm
class_name Populator extends RefCounted

enum Type
{
	RANDOM,
	WEIGHTED
}

var weight_texture: RendererTexture:
	set(value):
		weight_texture = value
		_weight_texture_set()

func generate_one(params: PopulatorParams) -> Shape:
	return null

func generate_population(
	size: int,
	params: PopulatorParams) -> Array[Shape]:
	
	var population: Array[Shape] = []

	for i in range(size):
		population.append(generate_one(params))
		
	return population

func _weight_texture_set():
	pass

static func factory_create(type: Type) -> Populator:
	match type:
		Type.RANDOM:
			return load("res://generation/image_generation/shape_generator/populator/random_populator.gd").new()
		Type.WEIGHTED:
			return load("res://generation/image_generation/shape_generator/populator/weighted_populator.gd").new()
		_:
			push_error("Unimplemented factory_create for populator type: %s" % type)
			return null
			
