extends VBoxContainer

@export var image_processing: Node

func _process(delta: float) -> void:
	if is_visible_in_tree():
		var map_processor: MapToRangeImageProcessor = image_processing.image_processor
		map_processor.min_bound = $MinBoundSpinBox.value
		map_processor.max_bound = $MaxBoundSpinBox.value
