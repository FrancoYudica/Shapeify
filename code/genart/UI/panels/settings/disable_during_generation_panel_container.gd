extends PanelContainer

func _ready() -> void:
	hide()
	Globals.generation_started.connect(show)
	Globals.generation_finished.connect(hide)
