extends ProgressBar


@export var image_generation: Node

@onready var _image_generation_params := Globals.settings.image_generator_params

@onready var elapsed_time_label : Label = %ElapsedTime

var generation_time : float = 0.0
var generated_individuals := 0

func _ready() -> void:
	
	visible = false
	
	image_generation.shape_generated.connect(
		func(individual):
			generated_individuals += 1
	)
	
	image_generation.generation_started.connect(
		func():
			value = 0.0
			generation_time = 0.0
			generated_individuals = 0
			elapsed_time_label.visible = true
			visible = true
	)
	image_generation.generation_finished.connect(
		func():
			visible = false
	)
	
func _process(delta: float) -> void:
	
	if visible:
		generation_time += delta
		value = image_generation.image_generator.get_progress()
		elapsed_time_label.text = "%0.1fs (%s individuals)" % [generation_time, generated_individuals]
