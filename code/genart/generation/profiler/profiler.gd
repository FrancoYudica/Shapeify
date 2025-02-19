## Collects algorithms data and that can be serialized to JSON format.
extends Node

enum Depth
{
	## Just profiles the image generation data
	ImageGeneration,
	
	## Profiles the shape generation time and it's output
	ShapeGeneration,
	
	## Collects specific data about the algorithm that is being used
	ShapeGenerationAlgorithm
}

var _profiler_strategy: ProfilerStrategy
var depth: Depth = Depth.ShapeGeneration

func start_profiling():
	_profiler_strategy = load("res://generation/profiler/save_profiler_strategy.gd").new()
	
func stop_profiling():
	_profiler_strategy = load("res://generation/profiler/profiler_strategy_base.gd").new()


func save():
	_profiler_strategy.save()


func image_generation_began(params: ImageGeneratorParams):
	_profiler_strategy.image_generation_began(params)
	
func image_generation_finished(generated_image: RendererTexture):
	_profiler_strategy.image_generation_finished(generated_image)

func shape_generation_began(params: ShapeGeneratorParams) -> void:
	
	if depth >= Depth.ShapeGeneration:
		_profiler_strategy.shape_generation_began(params)
	
func shape_generation_finished(
	shape: Shape,
	source_texture: RendererTexture) -> void:
		
	if depth >= Depth.ShapeGeneration:
		_profiler_strategy.shape_generation_finished(
			shape,
			source_texture)


func genetic_population_generated(
	population: Array[Individual],
	source_texture: RendererTexture):
	if depth >= Depth.ShapeGenerationAlgorithm:
	
		_profiler_strategy.genetic_population_generated(
			population,
			source_texture)

func _init() -> void:
	# By default it doesn't profile
	stop_profiling()
