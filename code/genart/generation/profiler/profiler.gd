## Collects algorithms data and that can be serialized to JSON format.
extends Node

enum Depth
{
	## Just profiles the image generation data
	ImageGeneration,
	
	## Profiles the individual generation time and it's output
	IndividualGeneration,
	
	## Collects specific data about the algorithm that is being used
	IndividualGenerationAlgorithm
}

var _profiler_strategy: ProfilerStrategy
var depth: Depth = Depth.IndividualGeneration

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

func individual_generation_began(params: IndividualGeneratorParams) -> void:
	
	if depth >= Depth.IndividualGeneration:
		_profiler_strategy.individual_generation_began(params)
	
func individual_generation_finished(
	individual: Individual,
	source_texture: RendererTexture) -> void:
		
	if depth >= Depth.IndividualGeneration:
		_profiler_strategy.individual_generation_finished(
			individual,
			source_texture)


func genetic_population_generated(
	population: Array[Individual],
	source_texture: RendererTexture):
	if depth >= Depth.IndividualGenerationAlgorithm:
	
		_profiler_strategy.genetic_population_generated(
			population,
			source_texture)

func _init() -> void:
	# By default it doesn't profile
	stop_profiling()
