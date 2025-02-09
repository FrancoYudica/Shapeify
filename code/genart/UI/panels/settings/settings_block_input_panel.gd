extends Panel

func _ready() -> void:
	
	Globals.generation_started.connect(show)
	Globals.generation_finished.connect(hide)
