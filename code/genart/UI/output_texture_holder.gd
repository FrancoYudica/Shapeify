extends Node

var texture: Texture2DRD
var renderer_texture: RendererTexture

@export var image_generation: Node
func _ready() -> void:
	image_generation.target_texture_updated.connect(_create_texture)
	
func _exit_tree() -> void:
	_free_texture()

func _create_texture():
	_free_texture()
	texture = RenderingCommon.create_texture_from_rd_rid(
		image_generation.image_generator.individual_generator.source_texture.rd_rid)
	
	renderer_texture = image_generation.image_generator.individual_generator.source_texture.copy()
	
var _previous_individual_count: int = -1
var _copying_contents: bool = false

func _process(delta: float) -> void:
	
	var details = image_generation.image_generation_details
	
	if details.individuals.size() == _previous_individual_count:
		return
		
	_previous_individual_count = details.individuals.size()

	if not Globals.settings.render_while_generating:
		return
	
	if not _copying_contents:
		# Texture copy is done in another thread to avoild lagging the UI
		WorkerThreadPool.add_task(_copy_texture_contents)

func _copy_texture_contents():
	_copying_contents = true

	if texture == null:
		_create_texture()
	
	renderer_texture.copy_contents(image_generation.image_generator.individual_generator.source_texture)
	image_generation.image_generator.copy_source_texture_contents(texture)
	_copying_contents = false
	
	

func _free_texture():
	
	if texture == null:
		return
	
	var rd = RenderingServer.get_rendering_device()
	var texture_rd_rid = texture.texture_rd_rid
	texture.texture_rd_rid = RID()
	texture = null
	rd.free_rid(texture_rd_rid)
