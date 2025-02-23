extends Control

@export var image_processing_test: Node
@export var processor_type: ImageProcessor.Type

func _process(delta: float) -> void:
	visible = image_processing_test.processor_type == processor_type
