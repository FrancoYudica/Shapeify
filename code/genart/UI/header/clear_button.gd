extends Button

func _ready() -> void:
	
	Globals.generation_started.connect(
		func():
			disabled = true
	)
	Globals.generation_finished.connect(
		func():
			disabled = false
	)
	
	pressed.connect(ImageGeneration.clear_progress)
