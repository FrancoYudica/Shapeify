extends PanelContainer

func _ready() -> void:
	hide()
	ImageGeneration.generation_started.connect(show)
	ImageGeneration.generation_finished.connect(hide)
