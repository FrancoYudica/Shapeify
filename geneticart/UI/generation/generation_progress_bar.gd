extends ProgressBar


@export var image_generation: Node

@onready var _image_generation_params := Globals.settings.image_generator_params

var _generated_count: float = 0.0

func _ready() -> void:
	
	visible = false
	
	image_generation.generation_started.connect(
		func():
			visible = true
			value = 0.0
			_generated_count = 0.0
	)
	image_generation.generation_finished.connect(
		func():
			visible = false
	)
	
	image_generation.individual_generated.connect(
		func():
			_generated_count += 1.0
			value = _generated_count / _image_generation_params.individual_count
	)
