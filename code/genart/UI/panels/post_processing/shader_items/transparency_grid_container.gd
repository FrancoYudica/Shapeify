extends GridContainer

@export var item: Control
@export var value_spin_box: SpinBox

var _params: TransparencyPostProcessingShaderParams:
	get:
		return item.params.transparency_params
		

func _ready() -> void:
	
	value_spin_box.value_changed.connect(
		func(value):
			_params.transparency = value
	)
	
	value_spin_box.value = _params.transparency
