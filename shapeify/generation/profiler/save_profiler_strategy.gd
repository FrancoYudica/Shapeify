extends ProfilerStrategy

const _IMAGE_GENERATIONS_KEY = "image_generations"
const _SHAPE_GENERATIONS_KEY = "shape_generations"

var _delta_e_1994_metric: DeltaEMetric
var _shape_renderer: ShapeRenderer

var _image_generation_params: ImageGeneratorParams
var _shape_generator_params: ShapeGeneratorParams

var _current_image_generation: Dictionary = {}

func save():
	var string = JSON.stringify(_data, "	")
	var file = FileAccess.open("res://out/profile.json", FileAccess.WRITE)
	file.store_string(string)

func image_generation_began(
	params: ImageGeneratorParams):
	_image_generation_params = params

	if _data.keys().count(_IMAGE_GENERATIONS_KEY) == 0:
		_data[_IMAGE_GENERATIONS_KEY] = []

	_current_image_generation = {
		"params": params.to_dict(),
		_SHAPE_GENERATIONS_KEY: [],
		"metric_score": 0.0,
		"time_taken": Time.get_ticks_msec() * 0.001
	}
	
	_data[_IMAGE_GENERATIONS_KEY].append(_current_image_generation)
	
	
func image_generation_finished(
	generated_image: RendererTexture):
	
	var img_gen_data = _get_current_image_generation()
	
	img_gen_data["time_taken"] = Time.get_ticks_msec() * 0.001 - img_gen_data["time_taken"]
	
	# Calculate the final metric
	_delta_e_1994_metric.target_texture = _image_generation_params.shape_generator_params.target_texture
	img_gen_data["metric_score"] = _delta_e_1994_metric.compute(generated_image)
	img_gen_data["shape_count"] = img_gen_data[_SHAPE_GENERATIONS_KEY].size()



func shape_generation_began(
	params: ShapeGeneratorParams):
	_shape_generator_params = params
	_get_current_image_generation()[_SHAPE_GENERATIONS_KEY].append(
		{
			"time_taken": Time.get_ticks_msec() * 0.001,
			"params" : params.to_dict(),
			"genetic_generations" : []
		}
	)


func shape_generation_finished(
	shape: Shape,
	source_texture: RendererTexture):
	var shape_generation = _get_current_shape_generation()
	shape_generation["generated_shape"] = shape.to_dict()
	shape_generation["time_taken"] = Time.get_ticks_msec() * 0.001 - shape_generation["time_taken"]
	
	# Renders shape over source texture
	_shape_renderer.source_texture = source_texture
	_shape_renderer.render_shape(shape)
	
	_delta_e_1994_metric.target_texture = _shape_generator_params.target_texture
	var shape_source_texture := _shape_renderer.get_color_attachment_texture()
	shape_generation["generated_shape"]["metric_score"] = _delta_e_1994_metric.compute(shape_source_texture)

func genetic_population_generated(
	population: Array[Individual],
	source_texture: RendererTexture):
	
	var shape_generation = _get_current_shape_generation()
	
	# Setup components data in order to calculate the metric
	_delta_e_1994_metric.target_texture = _shape_generator_params.target_texture
	_shape_renderer.source_texture = source_texture
	
	var population_data = []
	for individual in population:
		
		var individual_data = individual.to_dict()

		# Renders individual over source texture
		_shape_renderer.render_shape(individual)
		var individual_source_texture := _shape_renderer.get_color_attachment_texture()
		individual_data["metric_score"] = _delta_e_1994_metric.compute(individual_source_texture)
		
		population_data.append(individual_data)
	
	shape_generation["genetic_generations"].append(population_data)


func _get_current_image_generation() -> Dictionary:
	
	if _data.keys().count(_IMAGE_GENERATIONS_KEY) == 0:
		_data[_IMAGE_GENERATIONS_KEY] = [_current_image_generation]
	
	if _current_image_generation.keys().count(_SHAPE_GENERATIONS_KEY) == 0:
		_current_image_generation[_SHAPE_GENERATIONS_KEY] = []
	
	return _current_image_generation


func _get_current_shape_generation():
	return _get_current_image_generation()[_SHAPE_GENERATIONS_KEY].back()


func _init() -> void:
	_delta_e_1994_metric = load("res://generation/metric/delta_e/delta_e_1994_mean.gd").new()
	_shape_renderer = ShapeRenderer.new()
	_data = {}
