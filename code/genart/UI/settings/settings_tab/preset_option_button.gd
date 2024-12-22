extends OptionButton

func _ready() -> void:
	for key_name in ImageGeneratorParams.Type.keys():
		add_item(key_name)
	
	set_item_disabled(0, true)
	
	selected = Globals.settings.image_generator_params.type
	item_selected.connect(
		func(index):
			Globals.image_generator_params_set_preset(
				index as ImageGeneratorParams.Type)
	)

func _process(delta: float) -> void:
	selected = Globals.settings.image_generator_params.type
