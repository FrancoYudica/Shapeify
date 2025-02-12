extends GridContainer

@export var render_scale_spin_box: SpinBox

func _ready() -> void:
	
	# Render scale -------------------------------------------------------------
	render_scale_spin_box.value_changed.connect(
		func(value):
			Globals.settings.render_scale = value
	)

func _process(delta: float) -> void:
	render_scale_spin_box.set_value_no_signal(Globals.settings.render_scale)
