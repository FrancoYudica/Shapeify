extends Label

@export var image_generation: Node

@onready var _image_generation_params := Globals.settings.image_generator_params

var _is_rendering: bool = false
var _clock: Clock

func _ready() -> void:
	
	visible = false
	
	image_generation.generation_started.connect(
		func():
			visible = true
			_is_rendering = true
			_clock = Clock.new()
	)
	image_generation.generation_finished.connect(
		func():
			_is_rendering = false
			text = "- Image geneartion took: %sms" % _clock.elapsed_ms()
	)

func _process(delta: float) -> void:
	if _is_rendering:
		text = "- Generating image: %sms" % _clock.elapsed_ms()
		
