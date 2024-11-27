extends CanvasLayer

@export var params: IndividualGeneratorParams
@export var individual_textures: Array[RendererTexture] = []
@export var target_texture: RendererTexture

@export var individual_generator: IndividualGenerator
@export var individual_renderer: IndividualRenderer

@export var output_texture: TextureRect

@export var population_size_input: Control

func _ready() -> void:
	individual_generator.target_texture = target_texture
	
	# Adds the IDs of all the individual textures
	params.populator_params.textures = individual_textures
	
	individual_generator.initialize()
	
func setup_params():
	params.populator_params.population_size = population_size_input.get_number()
	params.populator_params.position_bound_min = Vector2.ZERO
	params.populator_params.position_bound_max = target_texture.get_size()
	
	var max_width_height = maxf(
		target_texture.get_width(), 
		target_texture.get_height())
	params.populator_params.size_bound_max = Vector2(max_width_height, max_width_height)
	

# Called when the node enters the scene tree for the first time.
func generate() -> void:
	var clock = Clock.new()
	setup_params()
	output_texture.visible = false
	var individual = await individual_generator.generate_individual(params)
	clock.print_elapsed("Generated individual with fitness: %s" % individual.fitness)
	
	output_texture.visible = true
	individual_renderer.render_individual(individual)
	
	## Stores the output texture
	#var img: Image = output_texture.texture.get_image()
	#img.save_png("res://art/output/out.png")
	

func _on_button_pressed() -> void:
	generate()
