extends Button

func _ready() -> void:
	
	ImageGeneration.generation_started.connect(
		func():
			visible = false
	)
	ImageGeneration.generation_finished.connect(
		func():
			visible = true
	)
	
	pressed.connect(ImageGeneration.generate)
