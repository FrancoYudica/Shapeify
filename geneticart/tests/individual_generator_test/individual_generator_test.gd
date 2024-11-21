extends Node

@export var individual_generator_params: IndividualGeneratorParams

@export var individual_generator: IndividualGenerator
@export var individual_source_texture_renderer: Node

@onready var output_texture_rect := $CanvasLayer/IndividualSourceTextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var t = Time.get_ticks_usec()
	var individual = await individual_generator.generate_individual(individual_generator_params)
	var elapsed_ms = (Time.get_ticks_usec() - t) / 1000.0
	print("Generated individual! in %sms" % elapsed_ms)
	
	individual_source_texture_renderer.push_individual(individual)
	individual_source_texture_renderer.source_texture = individual_generator_params.source_texture
	individual_source_texture_renderer.individual_src_texture_rendered.connect(
		func (individual, texture):
			output_texture_rect.texture = texture
	)
	individual_source_texture_renderer.begin_rendering()
	await individual_source_texture_renderer.finished_rendering
	var img: Image = output_texture_rect.texture.get_image()
	img.save_png("res://art/output/out.png")
	print(individual.fitness)
	
