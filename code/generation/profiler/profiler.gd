extends Node

var _data: Dictionary = {}

var _profiler_stragey: ProfilerStrategy

func start_profiling():
	_profiler_stragey = load("res://generation/profiler/save_profiler_strategy.gd").new()
	
func stop_profiling():
	_profiler_stragey = load("res://generation/profiler/profiler_strategy_base.gd").new()

func save():
	var string = JSON.stringify(_data, "	")
	var file = FileAccess.open("res://profiling/profile.json", FileAccess.WRITE)
	file.store_string(string)

func image_generation_began(params: ImageGeneratorParams):
	_profiler_stragey.image_generation_began(_data, params)
	
func image_generation_finished(generated_image: RendererTexture):
	_profiler_stragey.image_generation_finished(_data, generated_image)

func individual_generation_began(params: IndividualGeneratorParams) -> void:
	_profiler_stragey.individual_generation_began(_data, params)
	
func individual_generation_finished(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	_profiler_stragey.individual_generation_finished(
		_data, 
		individual,
		source_texture)


func _init() -> void:
	# By default it doesn't profile
	stop_profiling()
