extends MarginContainer

@export var image_generation: Node
@export var block_input_panel: Panel

func _ready() -> void:
	
	block_input_panel.visible = false
	
	image_generation.generation_started.connect(
		func():
			block_input_panel.visible = true
	)
	image_generation.generation_finished.connect(
		func():
			block_input_panel.visible = false
	)
