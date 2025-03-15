extends Button

func _ready() -> void:
	pressed.connect(ImageGeneration.master_renderer_params.camera_view_params.reset)
