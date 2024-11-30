extends PanelContainer

@export var image_generation: Node
@export var metrics_label: Label
@export var generator_label: Label

func _ready() -> void:
	image_generation.individual_generated.connect(_generated_individual)
	image_generation.source_texture_updated.connect(_update_metrics)
	visibility_changed.connect(_update_metrics)

func _generated_individual(individual: Individual):
	pass

func _update_metrics():
	
	if not is_visible_in_tree():
		return
	
	generator_label.text = ImageGeneratorParams \
							.IndividualGeneratorType \
							.keys()[
								Globals \
								.settings \
								.image_generator_params \
								.individual_generator_type]
	
	metrics_label.text = ""
	for metric: Metric in image_generation.metrics:
		metric.target_texture = Globals.settings.image_generator_params.individual_generator_params.target_texture
		var result = metric.compute(image_generation.individual_generator.source_texture)
		metrics_label.text = "%s%s: %s\n" % [metrics_label.text, metric.metric_name, result]
