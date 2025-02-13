extends ProgressBar


@onready var _image_generation_params := Globals.settings.image_generator_params

@onready var elapsed_time_label : Label = %ElapsedTime

var generation_time : float = 0.0
var generated_shape_count := 0

var _generation_finished: bool = false

func _ready() -> void:
	
	visible = false
	
	ImageGeneration.shape_generated.connect(
		func(shape):
			generated_shape_count += 1
	)
	
	ImageGeneration.generation_started.connect(
		func():
			value = 0.0
			generation_time = 0.0
			generated_shape_count = 0
			elapsed_time_label.visible = true
			_generation_finished = false
			visible = true
	)
	ImageGeneration.generation_finished.connect(
		func():
			_generation_finished = true
	)

func _process(delta: float) -> void:
	
	if not visible:
		return
	
	generation_time += delta
	value = ImageGeneration.image_generator.get_progress()
	elapsed_time_label.text = "%0.1fs (%s shapes)" % [generation_time, generated_shape_count]
	
	# Sets visibility change here to ensure the previous data gets updated
	visible = not _generation_finished
