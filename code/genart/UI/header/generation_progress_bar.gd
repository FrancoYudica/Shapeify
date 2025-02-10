extends ProgressBar


@onready var _image_generation_params := Globals.settings.image_generator_params

@onready var elapsed_time_label : Label = %ElapsedTime

var generation_time : float = 0.0
var generated_shape_count := 0

func _ready() -> void:
	
	visible = false
	
	Globals.shape_generated.connect(
		func(shape):
			generated_shape_count += 1
	)
	
	Globals.generation_started.connect(
		func():
			value = 0.0
			generation_time = 0.0
			generated_shape_count = 0
			elapsed_time_label.visible = true
			visible = true
	)
	Globals.generation_finished.connect(
		func():
			visible = false
	)
	
func _process(delta: float) -> void:
	
	if visible:
		generation_time += delta
		value = ImageGeneration.image_generator.get_progress()
		elapsed_time_label.text = "%0.1fs (%s shapes)" % [generation_time, generated_shape_count]
