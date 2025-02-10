extends Button

func _ready() -> void:
	
	Globals.generation_started.connect(
		func():
			visible = false
	)
	Globals.generation_finished.connect(
		func():
			visible = true
	)
	
	pressed.connect(ImageGeneration.generate)
