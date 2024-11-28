class_name ImageGenerator extends RefCounted

signal source_texture_updated(source_texture: RendererTexture)
signal rendered(renderer_texture: RendererTexture)

var params: ImageGeneratorParams

var individual_generator: IndividualGenerator
var individual_renderer: IndividualRenderer

func initialize(generator_params: ImageGeneratorParams) -> void:
	params = generator_params
	individual_generator.initialize(params.individual_generator_params)
	
func generate_image() -> RendererTexture:
	
	var source_texture = individual_generator.source_texture
	
	var _previous_individual_fitness = 0.0
	
	for i in range(params.individual_count):
		var individual: Individual = individual_generator.generate_individual()
		
		if _previous_individual_fitness > individual.fitness:
			print("Individual fitness: %s worse than previous fitness %s" % [individual.fitness, _previous_individual_fitness])
			continue
		
		_previous_individual_fitness = individual.fitness
		individual_renderer.render_individual(individual)
		var individual_texture = individual_renderer.get_color_attachment_texture().copy()
		individual_generator.source_texture = individual_texture
		source_texture_updated.emit(individual_texture)
		print(individual.fitness)
	
	rendered.emit(individual_generator.source_texture)
	
	return individual_generator.source_texture
