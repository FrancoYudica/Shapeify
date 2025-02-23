extends VBoxContainer

@export var image_processing: Node

@onready var sigma_spin_box = $SigmaSpinBox
@onready var kernel_size_spin_box = $KernelSizeSpinBox
@onready var iterations_spin_box = $IterationsSpinBox

func _process(delta: float) -> void:
	if is_visible_in_tree():
		var image_processor = image_processing.image_processor
		var gaussian_processor := image_processor as GaussianBlurImageProcessor
		gaussian_processor.sigma = sigma_spin_box.value
		gaussian_processor.kernel_size = kernel_size_spin_box.value
		gaussian_processor.iterations = iterations_spin_box.value
