extends ProfilerStrategy

const _IMAGE_GENERATIONS_KEY = "image_generations"
const _INDIVIDUAL_GENERATIONS_KEY = "individual_generations"

var _delta_e_1994_metric: DeltaEMetric
var _individual_renderer: IndividualRenderer

var _image_generation_params: ImageGeneratorParams

func image_generation_began(
	data: Dictionary, 
	params: ImageGeneratorParams):
	_image_generation_params = params

	if data.keys().count(_IMAGE_GENERATIONS_KEY) == 0:
		data[_IMAGE_GENERATIONS_KEY] = []
	
	data[_IMAGE_GENERATIONS_KEY].append(
		{
			"params": params.to_dict(),
			_INDIVIDUAL_GENERATIONS_KEY: [],
			"metric_score": 0.0,
			"time_taken": Time.get_ticks_msec() * 0.001
		}
	)
	
	
func image_generation_finished(
	data: Dictionary, 
	generated_image: RendererTexture):
	
	var img_gen_data = _get_current_image_generation(data)
	
	img_gen_data["time_taken"] = Time.get_ticks_msec() * 0.001 - img_gen_data["time_taken"]
	
	# Calculate the final metric
	_delta_e_1994_metric.target_texture = _image_generation_params.individual_generator_params.target_texture
	img_gen_data["metric_score"] = _delta_e_1994_metric.compute(generated_image)
	img_gen_data["generated_individual_count"] = img_gen_data[_INDIVIDUAL_GENERATIONS_KEY].size()



func individual_generation_began(
	data: Dictionary,
	params: IndividualGeneratorParams):
	_get_current_image_generation(data)[_INDIVIDUAL_GENERATIONS_KEY].append(
		{
			"fitness": 0.0,
			"metric_score": 0.0,
			"time_taken": Time.get_ticks_msec() * 0.001,
			"params" : params.to_dict()
		}
	)


func individual_generation_finished(
	data: Dictionary,
	individual: Individual,
	source_texture: RendererTexture):
	var ind = _get_current_individual_generation(data)
	ind["fitness"] = individual.fitness
	ind["time_taken"] = Time.get_ticks_msec() * 0.001 - ind["time_taken"]
	
	# Renders individual over source texture
	_individual_renderer.source_texture = source_texture
	_individual_renderer.render_individual(individual)
	
	_delta_e_1994_metric.target_texture = _image_generation_params.individual_generator_params.target_texture
	var individual_source_texture := _individual_renderer.get_color_attachment_texture()
	ind["metric_score"] = _delta_e_1994_metric.compute(individual_source_texture)
	
	ind["size_x"] = individual.size.x
	ind["size_y"] = individual.size.y


func _get_current_image_generation(data) -> Dictionary:
	return data[_IMAGE_GENERATIONS_KEY].back()


func _get_current_individual_generation(data):
	return _get_current_image_generation(data)[_INDIVIDUAL_GENERATIONS_KEY].back()


func _init() -> void:
	_delta_e_1994_metric = load("res://generation/metric/delta_e/delta_e_1994_mean.gd").new()
	_individual_renderer = load("res://generation/individual/individual_renderer.gd").new()
