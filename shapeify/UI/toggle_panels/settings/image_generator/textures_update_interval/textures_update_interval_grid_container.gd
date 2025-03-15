extends GridContainer

@export var spin_box: SpinBox

func _ready() -> void:
	
	# Render scale -------------------------------------------------------------
	spin_box.value_changed.connect(
		func(value):
			Globals.settings.image_generator_params.textures_update_interval = value
	)
	Globals.image_generator_params_updated.connect(_update)
	_update()

func _update() -> void:
	spin_box.set_value_no_signal(Globals.settings.image_generator_params.textures_update_interval)
