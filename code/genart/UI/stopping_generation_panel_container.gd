extends PanelContainer


func _ready() -> void:
	
	visible = false
	
	ImageGeneration.generation_finished.connect(
		func():
			visible = false
	)
