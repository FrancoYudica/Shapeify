extends ProgressBar


@export var image_generation: Node

@onready var _image_generation_params := Globals.settings.image_generator_params


func _ready() -> void:
	
	visible = false
	
	image_generation.generation_started.connect(
		func():
			value = 0.0
			visible = true
	)
	image_generation.generation_finished.connect(
		func():
			visible = false
	)
	
func _process(delta: float) -> void:
	
	if visible:
		value = image_generation.image_generator.get_progress()
