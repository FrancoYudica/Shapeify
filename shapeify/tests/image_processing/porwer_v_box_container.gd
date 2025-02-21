extends VBoxContainer

@export var image_processing: Node

func _process(delta: float) -> void:
	if is_visible_in_tree():
		image_processing.image_processor.power_value = $PowerSpinBox.value
