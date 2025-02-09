extends PanelContainer


func _ready() -> void:
	
	visible = false
	
	Globals.generation_finished.connect(
		func():
			visible = false
	)
