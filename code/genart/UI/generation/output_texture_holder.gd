extends Node


var weight_texture: Texture2DRD

@export var image_generation: Node
func _ready() -> void:
	image_generation.generation_cleared.connect(_generation_cleared)
	image_generation.generation_started.connect(
		func():
			# Connects signal directly to the image generator. This will run in the
			# algorithm thread, slowing it down by the texture copy time. 
			image_generation.image_generator.shape_generated.connect(_shape_generated)
			
	)
	image_generation.generation_finished.connect(
		func():
			image_generation.image_generator.shape_generated.disconnect(_shape_generated)
	)

func _shape_generated(shape):
	_copy_texture_contents()

func _exit_tree() -> void:
	_free_weight_texture()


func _generation_cleared():
	_copy_texture_contents()

func _copy_texture_contents():

	# Copies weight texture
	if image_generation.image_generator.weight_texture != null:
		
		if weight_texture != null:
			_free_weight_texture()
		
		weight_texture = RenderingCommon.create_texture_from_rd_rid(
			image_generation.image_generator.weight_texture.rd_rid)

func _free_weight_texture():
	if weight_texture == null or not weight_texture.texture_rd_rid.is_valid():
		return
	
	var rd = RenderingServer.get_rendering_device()
	var texture_rd_rid = weight_texture.texture_rd_rid
	weight_texture.texture_rd_rid = RID()
	weight_texture = null
	rd.free_rid(texture_rd_rid)
