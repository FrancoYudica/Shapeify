class_name ImageGenerator extends RefCounted

signal source_texture_updated(source_texture: RendererTexture)

var params: ImageGeneratorParams

var individual_generator: IndividualGenerator
var individual_renderer: IndividualRenderer

func initialize(generator_params: ImageGeneratorParams) -> void:
	params = generator_params
	individual_generator.initialize(params.individual_generator_params)
	
func generate_image() -> RendererTexture:
	
	var source_texture = individual_generator.source_texture
	
	for i in range(params.individual_count):
		var individual: Individual = individual_generator.generate_individual()
		individual_renderer.render_individual(individual)
		var individual_texture = individual_renderer.get_color_attachment_texture().copy()
		individual_generator.source_texture = individual_texture
		source_texture_updated.emit(individual_texture)
		print(individual.fitness)
	
	return individual_generator.source_texture
