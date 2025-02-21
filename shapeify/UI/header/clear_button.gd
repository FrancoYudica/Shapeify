extends Button

func _ready() -> void:
	
	ImageGeneration.generation_started.connect(
		func():
			disabled = true
	)
	ImageGeneration.generation_finished.connect(
		func():
			disabled = false
	)
	
	pressed.connect(ImageGeneration.clear_progress)
