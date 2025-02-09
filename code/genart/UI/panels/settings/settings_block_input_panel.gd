extends Panel

@export var image_generation: Node

func _ready() -> void:
	
	image_generation.generation_started.connect(show)
	image_generation.generation_finished.connect(hide)
