## Synchronizes a set of drag and zoom handlers. It's necessary to 
## make a synchronization because the DragAndZoomHanler rely only on it's
## internal state.
extends Node

@export var drag_and_zooms: Array[DragAndZoomHandler] = []

var camera_view_params: CameraViewParams:
	get:
		return ImageGeneration.master_renderer_params.camera_view_params

var last_used_drag_and_zoom: DragAndZoomHandler

func _ready() -> void:
	
	for drag_and_zoom in drag_and_zooms:
		drag_and_zoom.interaction_started.connect(
			func():
				
				# When using a different drag and zoom handler, the state get copied
				if last_used_drag_and_zoom != null:
					drag_and_zoom.current_translation = last_used_drag_and_zoom.current_translation
					drag_and_zoom.current_zoom = last_used_drag_and_zoom.current_zoom
					drag_and_zoom.target_zoom = last_used_drag_and_zoom.target_zoom
				
				last_used_drag_and_zoom = drag_and_zoom)
