extends VBoxContainer

@export var individual_count: SpinBox

@onready var _params = Globals \
						.settings \
						.image_generator_params \
						.individual_generator_params \
						.random_params
	
func _ready() -> void:
	
	# Generations spin ---------------------------------------------------------
	individual_count.value = _params.individual_count
	individual_count.value_changed.connect(
		func(v):
			_params.individual_count = v
	)
func _process(dt) -> void:
	visible = Globals \
				.settings \
				.image_generator_params \
				.individual_generator_type == ImageGeneratorParams.IndividualGeneratorType.Random
