extends PanelContainer

@export var image_generation: Node

func _ready() -> void:
	
	visible = false
	
	image_generation.generation_finished.connect(
		func():
			visible = false
	)
