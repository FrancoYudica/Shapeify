extends Node

var texture: Texture2DRD
var renderer_texture: RendererTexture

@export var image_generation: Node
func _ready() -> void:
	image_generation.target_texture_updated.connect(_create_texture)
	image_generation.generation_cleared.connect(_generation_cleared)
	image_generation.generation_started.connect(
		func():
			# Connects signal directly to the image generator. This will run in the
			# algorithm thread, slowing it down by the texture copy time. 
			image_generation.image_generator.individual_generated.connect(_individual_generated)
			
	)
	image_generation.generation_finished.connect(
		func():
			image_generation.image_generator.individual_generated.disconnect(_individual_generated)
	)

func _individual_generated(individual):
	_copy_texture_contents()

func _exit_tree() -> void:
	_free_texture()

func _create_texture():
	_free_texture()
	texture = RenderingCommon.create_texture_from_rd_rid(
		image_generation.image_generator.individual_generator.source_texture.rd_rid)
	
	renderer_texture = image_generation.image_generator.individual_generator.source_texture.copy()
	
func _generation_cleared():
	_copy_texture_contents()

func _copy_texture_contents():
	var src_texture = image_generation.image_generator.individual_generator.source_texture
	
	if src_texture == null:
		return
	if texture == null or texture.get_size() != src_texture.get_size():
		_create_texture()
		
	renderer_texture.copy_contents(src_texture)
	image_generation.image_generator.copy_source_texture_contents(texture)
	
func _free_texture():
	texture = null
