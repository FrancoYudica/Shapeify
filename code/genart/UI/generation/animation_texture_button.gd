extends TextureButton

@export var image_generation: Node
@export var animator: Control

func _ready() -> void:
	
	disabled = true
	
	pressed.connect(
		func():
			animator.visible = true
	)
	
	image_generation.generation_finished.connect(
		func():
			disabled = false
	)
	
	image_generation.generation_started.connect(
		func():
			disabled = true
	)
