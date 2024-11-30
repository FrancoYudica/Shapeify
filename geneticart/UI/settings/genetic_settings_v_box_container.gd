extends VBoxContainer

@export var generations: SpinBox

@onready var _params = Globals \
						.settings \
						.image_generator_params \
						.individual_generator_params \
						.genetic_params
			
func _ready() -> void:
	generations.value = _params.generation_count
	generations.value_changed.connect(
		func(v):
			_params.generation_count = v
	)

func _process(dt) -> void:
	visible = Globals \
				.settings \
				.image_generator_params \
				.individual_generator_type == ImageGeneratorParams.IndividualGeneratorType.Genetic
