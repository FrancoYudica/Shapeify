## Synchronizes a set of drag and zoom handlers. It's necessary to 
## make a synchronization because the DragAndZoomHanler rely only on it's
## internal state.
extends Node

@export var drag_and_zooms: Array[DragAndZoomHandler] = []

var last_used_drag_and_zoom: DragAndZoomHandler

func _ready() -> void:
	
	for drag_and_zoom in drag_and_zooms:
		drag_and_zoom.interaction_started.connect(
			func():
				last_used_drag_and_zoom = drag_and_zoom)

func _process(delta: float) -> void:
	
	if last_used_drag_and_zoom == null:
		return
	for drag_and_zoom in drag_and_zooms:
		
		if last_used_drag_and_zoom != drag_and_zoom:
			drag_and_zoom.target_zoom = last_used_drag_and_zoom.target_zoom
