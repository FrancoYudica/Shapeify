extends CanvasLayer

@export var individual_textures: Array[RendererTexture] = []
@export var target_texture: RendererTexture

@export var individual_generator: IndividualGenerator
@export var individual_renderer: IndividualRenderer
@export var output_texture: TextureRect
@export var population_size_input: Control

func setup_params():
	
	var params := IndividualGeneratorParams.new()
	# Populator params
	params.populator_params = PopulatorParams.new()
	params.populator_params.population_size = population_size_input.get_number()
	params.populator_params.position_bound_min = Vector2.ZERO
	params.populator_params.position_bound_max = target_texture.get_size()
	
	var max_width_height = maxf(
		target_texture.get_width(), 
		target_texture.get_height())
	params.populator_params.size_bound_max = Vector2(max_width_height, max_width_height)
	params.populator_params.textures = individual_textures
	
	# Texture
	params.target_texture = target_texture
	individual_generator.initialize(params)
	
# Called when the node enters the scene tree for the first time.
func generate() -> void:
	var clock = Clock.new()
	setup_params()
	output_texture.visible = false
	var individual = await individual_generator.generate_individual()
	clock.print_elapsed("Generated individual with fitness: %s" % individual.fitness)
	
	output_texture.visible = true
	individual_renderer.render_individual(individual)
	
	## Stores the output texture
	#var img: Image = output_texture.texture.get_image()
	#img.save_png("res://art/output/out.png")
	

func _on_button_pressed() -> void:
	generate()
