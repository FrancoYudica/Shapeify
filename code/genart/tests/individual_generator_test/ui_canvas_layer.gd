extends CanvasLayer

@export var individual_generator_parms: IndividualGeneratorParams
@export var source_texture: RendererTextureLoad
@export var target_texture: RendererTextureLoad
@export var output_texture: TextureRect
@export var save_button: Button
@export var individual_generator_option: OptionButton

var _individual_generator: IndividualGenerator
var _individual_renderer: IndividualRenderer

func _ready() -> void:
	
	individual_generator_parms.target_texture = target_texture
	
	_individual_renderer = load("res://generation/individual/individual_renderer.gd").new()
	
	for generator in IndividualGenerator.Type.keys():
		individual_generator_option.add_item(generator)
	
	individual_generator_option.select(IndividualGenerator.Type.Genetic)
	
	individual_generator_option.item_selected.connect(
		func(i):
			_set_individual_generator(i as IndividualGenerator.Type)
	)
	
	_set_individual_generator(IndividualGenerator.Type.Genetic)
	
func generate() -> void:
	output_texture.visible = false
	
	var clock = Clock.new()
	var individual = _individual_generator.generate_individual()
	clock.print_elapsed("Generated individual with fitness: %s" % individual.fitness)
	output_texture.visible = true
	
	# Renders the best individual
	_individual_renderer.source_texture = _individual_generator.source_texture
	_individual_renderer.render_individual(individual)


func _on_button_pressed() -> void:
	generate()


func _on_profiling_check_box_toggled(toggled_on: bool) -> void:
	save_button.disabled = not toggled_on
	if toggled_on:
		Profiler.start_profiling()
	else:
		Profiler.stop_profiling()
		
	Profiler.depth = Profiler.Depth.IndividualGenerationAlgorithm

func _on_save_profiling_button_pressed() -> void:
	Profiler.save()
	_save_output()

func _set_individual_generator(type: IndividualGenerator.Type):
	# Setup individual generator -----------------------------------------------
	match type:
		IndividualGenerator.Type.Random:
			_individual_generator = load("res://generation/individual_generator/random/random_individual_generator.gd").new()
		IndividualGenerator.Type.BestOfRandom:
			_individual_generator = load("res://generation/individual_generator/best_of_random/best_of_random_individual_generator.gd").new()
		IndividualGenerator.Type.Genetic:
			_individual_generator = load("res://generation/individual_generator/genetic/genetic_individual_generator.gd").new()

		_:
			push_error("Unimplemented individual generator of type %s" % type)

	_individual_generator.params = individual_generator_parms
	_individual_generator.source_texture = source_texture


func _save_output():
	var color_attachment_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	var color_attachment_data = Renderer.rd.texture_get_data(color_attachment_texture.rd_rid, 0)
	
	# Creates an image with the same size and format
	var img = Image.new()
	img.set_data(
		color_attachment_texture.get_width(),
		color_attachment_texture.get_height(),
		false,
		Image.Format.FORMAT_RGBAF,
		color_attachment_data)
	
	img.save_png("res://out/out.png")
