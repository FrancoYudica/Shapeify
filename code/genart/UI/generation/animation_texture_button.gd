extends TextureButton

@export var image_generation: Node
@export var animator: Control

var _image_generation_details := ImageGenerationDetails.new()

func _ready() -> void:
	
	disabled = true
	
	pressed.connect(
		func():
			animator.image_generation_details = _image_generation_details
			animator.visible = true
	)
	
	image_generation.generation_started.connect(
		func():
			disabled = true
			_image_generation_details.individuals.clear()
			
			_image_generation_details.clear_color = image_generation \
													.image_generator \
													.individual_generator \
													.get_target_average_color()
													
			_image_generation_details.viewport_size = Globals \
													.settings \
													.image_generator_params \
													.individual_generator_params \
													.target_texture \
													.get_size()
	)
	
	image_generation.generation_finished.connect(
		func():
			disabled = false
	)

	image_generation.individual_generated.connect(
		func(individual):
			_image_generation_details.individuals.append(individual)
	)
