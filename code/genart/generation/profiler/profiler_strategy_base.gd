class_name ProfilerStrategy extends RefCounted

var _data: Dictionary = {}

func image_generation_began(params: ImageGeneratorParams):
	pass
	
func image_generation_finished(generated_image: RendererTexture):
	pass

func shape_generation_began(params: ShapeGeneratorParams):
	pass

func shape_generation_finished(
	shape: Shape,
	source_texture: RendererTexture):
	pass

func genetic_population_generated(
	population: Array[Individual],
	source_texture: RendererTexture):
	pass

func save():
	pass
