class_name ProfilerStrategy extends RefCounted

var _data: Dictionary = {}

func image_generation_began(params: ImageGeneratorParams):
	pass
	
func image_generation_finished(generated_image: RendererTexture):
	pass

func individual_generation_began(params: IndividualGeneratorParams):
	pass

func individual_generation_finished(
	individual: Individual,
	source_texture: RendererTexture):
	pass

func genetic_population_generated(
	population: Array[Individual],
	source_texture: RendererTexture):
	pass

func save():
	pass
