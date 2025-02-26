extends Control

@export var close_button: Button
@export var save_button: Button
@export var scale_spin_box: SpinBox
@export var resolution_label: Label
@export var final_resolution_label: Label
@export var file_dialog: FileDialog
@export var format_option_button: OptionButton
@export var output_texture_rect: MasterRendererOutputTextureRect

var _frame_saver: FrameSaver
var _local_renderer: LocalRenderer


var target_texture_size: Vector2:
	get:
		return Globals.settings.image_generator_params.target_texture.get_size()

func _ready() -> void:
	
	_local_renderer = LocalRenderer.new()
	_local_renderer.initialize(RenderingServer.create_local_rendering_device())
	
	close_button.pressed.connect(
		func():
			visible = false
	)
	
	save_button.pressed.connect(_save)
	file_dialog.file_selected.connect(_on_file_dialog_file_selected)
	scale_spin_box.value_changed.connect(_set_final_resolution_scale)
	
	for item in FrameSaver.Type.keys():
		format_option_button.add_item(item)
	
	format_option_button.item_selected.connect(
		func(index):
			_frame_saver = FrameSaver.factory_create(index as FrameSaver.Type)
	)
	
	format_option_button.select(0)
	_frame_saver = FrameSaver.factory_create(FrameSaver.Type.PNG)
	
	visibility_changed.connect(
		func():
			if visible:
				output_texture_rect.master_renderer_params = ImageGeneration.master_renderer_params
				_oppened()
	)

func _set_final_resolution_scale(scale):
	final_resolution_label.text = "%sx%s" % [
		int(target_texture_size.x * scale),
		int(target_texture_size.y * scale)]
	

func _oppened():

	visible = true
	
	resolution_label.text = "%sx%s" % [
		target_texture_size.x,
		target_texture_size.y]
	
	_set_final_resolution_scale(scale_spin_box.value)
	
func _save():
	file_dialog.clear_filters()
	file_dialog.add_filter("*%s" % _frame_saver.get_extension())
	file_dialog.visible = true

func _on_file_dialog_file_selected(path: String) -> void:
	
	var success = _frame_saver.save(
		path,
		_local_renderer,
		ImageGeneration.master_renderer_params,
		target_texture_size * scale_spin_box.value)
	
	if success:
		Notifier.notify_info("Image saved at: %s" % path, path)
	else:
		Notifier.notify_error("Unable to save image at: %s" % path)
