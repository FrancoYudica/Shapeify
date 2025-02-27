extends Button

@export var drag_and_drop_handlers: Array[DragAndZoomHandler] = []

func _ready() -> void:
	pressed.connect(
		func():
			var params = ImageGeneration.master_renderer_params
			params.camera_view_params.normalized_translation = Vector2.ZERO
			params.camera_view_params.zoom = 1.0
			
			for handler in drag_and_drop_handlers:
				handler.current_translation = Vector2.ZERO
				handler.current_zoom = 1.0
				handler.target_zoom = 1.0)
