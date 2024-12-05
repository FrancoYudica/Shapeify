extends Label

@export var image_generation: Node

var _clock: Clock

func _ready() -> void:
	
	visible = false
	
	image_generation.generation_started.connect(
		func():
			visible = true
			_clock = Clock.new()
	)
	image_generation.individual_generated.connect(
		func(i):
			text = "- Las intidivual generation took %sms" % _clock.elapsed_ms()
			_clock.restart()
	)
