extends Node


@export var target_texture: RendererTextureLoad
@export var individual_textures: Array[RendererTexture]
@export var individual_count: int = 10

@export var _individual_generator: IndividualGenerator
@export var _individual_renderer: IndividualRenderer

var _image_generator: ImageGenerator

@export var _output_texture_rect: TextureRect
@export var _reference_texture_rect: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	_reference_texture_rect.texture = RenderingCommon.create_texture_from_rd_rid(target_texture.rd_rid)
	
	_image_generator = ImageGenerator.new()
	
	var individual_generator_params = IndividualGeneratorParams.new()

	# Populator params
	var populator_params = PopulatorParams.new()
	populator_params.population_size = 100
	populator_params.position_bound_min = Vector2.ZERO
	populator_params.position_bound_max = target_texture.get_size()
	
	var max_width_height = maxf(
		target_texture.get_width(), 
		target_texture.get_height())
	populator_params.size_bound_max = Vector2(max_width_height, max_width_height)
	populator_params.textures = individual_textures as Array[RendererTexture]
	individual_generator_params.populator_params = populator_params
	
	# Texture
	individual_generator_params.target_texture = target_texture
	
	var image_generator_params := ImageGeneratorParams.new()
	image_generator_params.individual_generator_params = individual_generator_params
	image_generator_params.individual_count = individual_count
	
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
	
