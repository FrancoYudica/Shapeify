extends Node

var texture: Texture2DRD
var renderer_texture: RendererTexture

var weight_texture: Texture2DRD

@export var image_generation: Node
func _ready() -> void:
	image_generation.target_texture_updated.connect(_create_texture)
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
	_free_texture()
	_free_weight_texture()

func _create_texture():
	_free_texture()
	texture = RenderingCommon.create_texture_from_rd_rid(
		image_generation.image_generator.shape_generator.source_texture.rd_rid)
	
	renderer_texture = image_generation.image_generator.shape_generator.source_texture.copy()

func _generation_cleared():
	_copy_texture_contents()

func _copy_texture_contents():
	var src_texture = image_generation.image_generator.shape_generator.source_texture
	
	if src_texture == null:
		return
	if texture == null or texture.get_size() != src_texture.get_size():
		_create_texture()
		
	renderer_texture.copy_contents(src_texture)
	image_generation.image_generator.copy_source_texture_contents(texture)
	
	# Copies weight texture
	if image_generation.image_generator.weight_texture != null:
		
		if weight_texture != null:
			_free_weight_texture()
		
		weight_texture = RenderingCommon.create_texture_from_rd_rid(
			image_generation.image_generator.weight_texture.rd_rid)

func _free_texture():
	if texture == null:
		return
	
	var rd = RenderingServer.get_rendering_device()
	var texture_rd_rid = texture.texture_rd_rid
	texture.texture_rd_rid = RID()
	texture = null
	rd.free_rid(texture_rd_rid)

func _free_weight_texture():
	if weight_texture == null:
		return
	
	var rd = RenderingServer.get_rendering_device()
	var texture_rd_rid = weight_texture.texture_rd_rid
	weight_texture.texture_rd_rid = RID()
	weight_texture = null
	rd.free_rid(texture_rd_rid)
