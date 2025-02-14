extends VBoxContainer

@export var add_button: Button
@export var shader_option_button: OptionButton
@export var item_container: Control
@export var enabled_check_box: CheckBox

var _params: ShapeColorPostProcessingPipelineParams:
	get:
		return Globals.settings.color_post_processing_pipeline_params

func _ready() -> void:
	
	for item in ShapeColorPostProcessingShader.Type.keys():
		shader_option_button.add_item(item)
		
	add_button.pressed.connect(_add_shader)
	enabled_check_box.toggled.connect(
		func(toggled_on):
			_params.enabled = toggled_on
	)
	Globals.image_generator_params_updated.connect(_update)
	_update()

func _update():
	
	for child in item_container.get_children():
		item_container.remove_child(child)
		child.queue_free()
	
	for i in range(_params.shader_params.size()):
		_create_ui_item(i)
	
	enabled_check_box.button_pressed = _params.enabled

func _add_shader():
	var shader_type = shader_option_button.selected
	var shader_params = ShapeColorPostProcessingShaderParams.new()
	shader_params.type = shader_type
	_params.add_shader_param(shader_params)
	_create_ui_item(_params.shader_params.size() - 1)
	
func _create_ui_item(index):
	var params = _params.shader_params[index]
	var item = _create_ui_item_of_type(params.type)
	item.params = params
	item_container.add_child(item)

func _create_ui_item_of_type(type):
	match type:
		ShapeColorPostProcessingShader.Type.HUE_SHIFT:
			return load("res://UI/toggle_panels/post_processing/shader_items/hue_shift_post_processing_shader_panel_container.tscn").instantiate()
		ShapeColorPostProcessingShader.Type.SATURATION_SHIFT:
			return load("res://UI/toggle_panels/post_processing/shader_items/saturation_shift_post_processing_shader_panel_container.tscn").instantiate()
		ShapeColorPostProcessingShader.Type.VALUE_SHIFT:
			return load("res://UI/toggle_panels/post_processing/shader_items/value_shift_post_processing_shader_panel_container.tscn").instantiate()
		ShapeColorPostProcessingShader.Type.RGB_SHIFT:
			return load("res://UI/toggle_panels/post_processing/shader_items/rgb_shift_post_processing_shader_panel_container.tscn").instantiate()
		ShapeColorPostProcessingShader.Type.CEILab_SHIFT:
			return load("res://UI/toggle_panels/post_processing/shader_items/CEILab_shift_post_processing_shader_panel_container.tscn").instantiate()
		ShapeColorPostProcessingShader.Type.TRANSPARENCY:
			return load("res://UI/toggle_panels/post_processing/shader_items/transparency_post_processing_shader_panel_container.tscn").instantiate()
