extends Node

@export var individuals: Array[Individual]
@export var source_texture: Texture2D

@onready var individual_renderer := $IndividualSourceTextureRenderer
@onready var output_texture := $CanvasLayer/TextureRect

var _clock: Clock

func _on_timer_timeout() -> void:
	pass
	
func _process(d):
	# Circular list
	var individual = individuals.pop_front()
	individuals.push_back(individual)
	
	_clock = Clock.new()
	individual_renderer.source_texture = source_texture
	individual_renderer.push_individual(individual)
	individual_renderer.begin_rendering()


func _on_individual_source_texture_renderer_rendered(
	individual: Individual, 
	texture: ViewportTexture) -> void:
	_update_output_texture(texture)

func _update_output_texture(texture: ViewportTexture):
	# Creates a copy just to avoid the reference.
	# This is slow, but it's just for testing 'IndividualSrcTextureRenderer'
	var image: Image = texture.get_image()
	var image_texture = ImageTexture.create_from_image(image)
	output_texture.texture = image_texture
	_clock.print_elapsed("Rendering done. ")
