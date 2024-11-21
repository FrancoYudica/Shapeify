extends Node

@export var individuals: Array[Individual]

@onready var individual_renderer := $IndividualSourceTextureRenderer
@onready var output_texture := $CanvasLayer/TextureRect


func _on_timer_timeout() -> void:
	# Circular list
	var individual = individuals.pop_front()
	individuals.push_back(individual)
	individual_renderer.push_individual(individual)


func _on_individual_source_texture_renderer_individual_src_texture_rendered(
	individual: Individual, 
	texture: ViewportTexture) -> void:
	_update_output_texture(texture)

func _update_output_texture(texture: ViewportTexture):
	# Creates a copy just to avoid the reference.
	# This is slow, but it's just for testing 'IndividualSrcTextureRenderer'
	var image: Image = texture.get_image()
	var image_texture = ImageTexture.create_from_image(image)
	output_texture.texture = image_texture
