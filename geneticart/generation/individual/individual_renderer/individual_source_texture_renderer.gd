extends Node

signal rendered(
	individual: Individual, 
	texture: ViewportTexture)

signal finished_rendering()

@export var source_texture: Texture2D = null:
	set(texture):
		source_texture = texture
		
		if is_node_ready():
			_src_texture_changed()

@export var _sub_viewport: SubViewport
@export var _source_texture_rect: TextureRect
@export var _individual_node: IndividualNode

var _individual_render_queue: Array[Individual] = []
var _rendering_individual: Individual = null
var _rendering: bool = false

## Synchronization is necessary for main and render thread
var _mutex: Mutex = Mutex.new()
var _clock: Clock

func _ready() -> void:
	RenderingServer.frame_post_draw.connect(_frame_post_draw)

## Clears all the connected callables
func clear_signals():
	for s in get_signal_list():
		for conn in get_signal_connection_list(s.name):
			self.disconnect(s.name, conn.callable)

func begin_rendering():
	if _rendering:
		printerr("begin_rendering(): Already rendering")
		return
		
	if source_texture == null:
		printerr("begin_rendering(): Source texture is null")
		return
	_rendering = true
	_clock = Clock.new()
	

func push_individual(individual: Individual):
	_mutex.lock()
	_individual_render_queue.push_back(individual)
	_mutex.unlock()
	
func get_subviewport_texture() -> ViewportTexture:
	return _sub_viewport.get_texture()

func _src_texture_changed():
	_source_texture_rect.texture = source_texture
	_sub_viewport.size = source_texture.get_size()

func _process(delta: float) -> void:
	
	# It's going to apply the genetic attributes to the individual node only
	# if there are individuals remaining and the rendering individual is null
	# This ensures that the pop_front doesn't change the rendering individual
	# if it wasn't rendered yet.
	
	if not _rendering:
		return
	
	_mutex.lock()
	if _individual_render_queue.size() > 0 and _rendering_individual == null:
		_rendering_individual = _individual_render_queue.pop_front()
		IndividualNode.apply_genetic_attributes(_individual_node, _rendering_individual)
	_mutex.unlock()
	

# Post draw is called from render thread
func _frame_post_draw():
	
	if not _rendering:
		return
		
	# Nothing rendered
	_mutex.lock()
	if _rendering_individual == null:
		_mutex.unlock()
		return
	rendered.emit(
		_rendering_individual,
		_sub_viewport.get_texture())
	# Sets rendering individual back to null, allowing a new assignment
	_rendering_individual = null
	
	
	# Rendered all individuals
	if _individual_render_queue.size() == 0:
		_rendering = false
		finished_rendering.emit()
		_clock.print_elapsed("Finished from render thread")
	
	_mutex.unlock()
