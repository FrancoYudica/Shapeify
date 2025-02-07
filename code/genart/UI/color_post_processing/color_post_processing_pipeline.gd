extends PanelContainer

@export var add_button: Button
@export var shader_option_button: OptionButton
@export var item_container: Control
@export var close_button: Button

var _params: ShapeColorPostProcessingPipelineParams:
	get:
		return Globals.settings.color_post_processing_pipeline_params

func _ready() -> void:
	
	for item in ShapeColorPostProcessingShader.Type.keys():
		shader_option_button.add_item(item)
		
	add_button.pressed.connect(_add_shader)
	
	close_button.pressed.connect(hide)
	
	Globals.image_generator_params_updated.connect(_update)
	_update()

func _update():
	
	for child in item_container.get_children():
		item_container.remove_child(child)
		child.queue_free()
	
	for i in range(_params.shader_params.size()):
		_create_ui_item(i)
	

func _add_shader():
	var shader_type = shader_option_button.selected
	var shader_params = ShapeColorPostProcessingShaderParams.new()
	shader_params.type = shader_type
	_params.shader_params.append(shader_params)
	_create_ui_item(_params.shader_params.size() - 1)
	
func _create_ui_item(index):
	var params = _params.shader_params[index]
	var item = _create_ui_item_of_type(params.type)
	item.params = params
	item_container.add_child(item)

func _create_ui_item_of_type(type):
	match type:
		ShapeColorPostProcessingShader.Type.HUE_SHIFT:
			return load("res://UI/color_post_processing/shader_items/hue_shift_post_processing_shader_panel_container.tscn").instantiate()
