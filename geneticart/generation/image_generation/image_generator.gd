class_name ImageGenerator extends RefCounted

signal individual_generated(individual: Individual)

var params: ImageGeneratorParams

var individual_generator: IndividualGenerator
var individual_renderer: IndividualRenderer

var _mutex: Mutex = Mutex.new()
var _stop: bool = false

func update_target_texture(target_texture: RendererTexture):
	individual_generator.update_target_texture(target_texture)

func stop():
	_mutex.lock()
	_stop = true
	_mutex.unlock()

func generate_image() -> RendererTexture:
	_stop = false
	var source_texture = individual_generator.source_texture
	
	for i in range(params.individual_count):
		
		# Checks if the algorithm should stop executing
		_mutex.lock()
		if _stop:
			_mutex.unlock()
			break
		_mutex.unlock()
		
		var individual: Individual = individual_generator.generate_individual()
		
		individual_renderer.render_individual(individual)
		var individual_texture = individual_renderer.get_color_attachment_texture().copy()
		individual_generator.source_texture = individual_texture
		individual_generated.emit(individual)
	
	return individual_generator.source_texture
