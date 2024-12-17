extends VBoxContainer

@export var clear_color: ColorPickerButton
@onready var _params := Globals \
						.settings \
						.image_generator_params
						
func _ready() -> void:
	clear_color.color = _params.clear_color_params.color
	clear_color.color_changed.connect(
		func(value):
			_params.clear_color_params.color = value
	)

func _process(delta: float) -> void:
	visible = _params.clear_color_type == ClearColorStrategy.Type.ANY
