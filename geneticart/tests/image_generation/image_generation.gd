extends Node

@export_category("Data")
@export var target_texture: RendererTextureLoad
@export var individual_textures: Array[RendererTexture]
@export var individual_count: int = 10

@export_category("Scripts")
@export var image_generator_script: GDScript
@export var individual_generator_script: GDScript
@export var individual_renderer_script: GDScript
@export var average_color_sampler_script: GDScript
@export var fitness_calculator_script: GDScript
@export var metric_calculator_script: GDScript
@export var populator_script: GDScript

@export var _output_texture_rect: TextureRect
@export var _reference_texture_rect: TextureRect

var _individual_generator: IndividualGenerator
var _individual_renderer: IndividualRenderer
var _image_generator: ImageGenerator


func _ready() -> void:
	_initialize()

func _initialize():
	
	# Individual params ****************************************************************************
	var ind_p := IndividualGeneratorParams.new()
	# Populator ind_p -----------------------------------------------------------------------------
	ind_p.populator_params = PopulatorParams.new()
	ind_p.populator_params.population_size = 10
	ind_p.populator_params.position_bound_min = Vector2.ZERO
	ind_p.populator_params.position_bound_max = target_texture.get_size()
	var max_width_height = maxf(
		target_texture.get_width(), 
		target_texture.get_height())
	ind_p.populator_params.size_bound_max = Vector2(max_width_height, max_width_height)
	ind_p.populator_params.textures = individual_textures
	
	# Texture
	ind_p.target_texture = target_texture
	
	# Individual generator and references to other systems -----------------------------------------
	_individual_generator = individual_generator_script.new()
	_individual_renderer = individual_renderer_script.new()
	_individual_generator.individual_renderer = _individual_renderer
	_individual_generator.populator = populator_script.new()
	_individual_generator.average_color_sampler = average_color_sampler_script.new()
	_individual_generator.fitness_calculator = fitness_calculator_script.new()
	_individual_generator.fitness_calculator.error_metric = metric_calculator_script.new()

	# Image generator params ***********************************************************************
	var image_generator_params := ImageGeneratorParams.new()
	image_generator_params.individual_generator_params = ind_p
	image_generator_params.individual_count = individual_count
	
	_image_generator = image_generator_script.new()
	_image_generator.individual_generator = _individual_generator
	_image_generator.individual_renderer = _individual_renderer
	_image_generator.initialize(image_generator_params)
	
	_image_generator.source_texture_updated.connect(_source_texture_updated)



func _source_texture_updated(renderer_texture):
	#_output_texture_rect.texture = RenderingCommon.create_texture_from_rd_rid(renderer_texture.rd_rid)
	pass


func _on_generate_button_pressed() -> void:
	var clock = Clock.new()
	var renderer_texture = _image_generator.generate_image()
	_output_texture_rect.texture = RenderingCommon.create_texture_from_rd_rid(renderer_texture.rd_rid)
	clock.print_elapsed("Image generation completed")
	
	## Stores the output texture
	#var img: Image = _output_texture_rect.texture.get_image()
	
	#if img != null:
		#img.save_png("res://art/output/out.png")
	
