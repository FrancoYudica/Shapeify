extends VBoxContainer

@export var image_processing: Node

@onready var power_spin_box = $PowerSpinBox
@onready var threshold_spin_box = $ThresholdSpinBox

func _process(delta: float) -> void:
	if is_visible_in_tree():
		var image_processor = image_processing.image_processor
		var sobel_operator := image_processor as SobelEdgeDetectionImageProcessor
		sobel_operator.power = power_spin_box.value
		sobel_operator.threshold = threshold_spin_box.value
