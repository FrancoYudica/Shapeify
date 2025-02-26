extends Control

@export var close_button: Button
@export var save_button: Button
@export var scale_spin_box: SpinBox
@export var resolution_label: Label
@export var final_resolution_label: Label
@export var file_dialog: FileDialog
@export var save_texture: TextureRect
@export var format_option_button: OptionButton

var _processed_details: ImageGenerationDetails
var _frame_saver: FrameSaver
var _local_renderer: LocalRenderer


var target_texture_size: Vector2:
	get:
		return Globals.settings.image_generator_params.target_texture.get_size()

func _ready() -> void:
	
	_local_renderer = LocalRenderer.new()
	_local_renderer.initialize(LocalRenderer.Type.SPRITE, RenderingServer.create_local_rendering_device())
	
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
				_oppened()
	)

func _set_final_resolution_scale(scale):
	final_resolution_label.text = "%sx%s" % [
		int(target_texture_size.x * scale),
		int(target_texture_size.y * scale)]
	

func _oppened():

	var gen_details: ImageGenerationDetails = ImageGeneration.details
	visible = true
	
	_processed_details = ShapeColorPostProcessingPipeline.process_details(
		gen_details,
		0.0,
		Globals.settings.color_post_processing_pipeline_params)

	resolution_label.text = "%sx%s" % [
		target_texture_size.x,
		target_texture_size.y]
	
	_set_final_resolution_scale(scale_spin_box.value)
	
	# Calculates viewport size
	var target_texture = Globals.settings.image_generator_params.target_texture
	var aspect_ratio = float(target_texture.get_width()) / target_texture.get_height()
	var render_viewport_size = Vector2i(size.y * aspect_ratio, size.y)

	# Renders the texture. This causes stall
	MasterRenderer.render(
		_local_renderer,
		render_viewport_size,
		ImageGeneration.master_renderer_params)
	
	var rendered = _local_renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR).copy()
	save_texture.texture = rendered.create_texture_2d_rd()

func _save():
	file_dialog.clear_filters()
	file_dialog.add_filter("*%s" % _frame_saver.get_extension())
	file_dialog.visible = true

func _on_file_dialog_file_selected(path: String) -> void:
	
	var success = _frame_saver.save(
		path,
		_local_renderer,
		ImageGeneration.master_renderer_params,
		_processed_details.viewport_size * scale_spin_box.value)
	
	if success:
		Notifier.notify_info("Image saved at: %s" % path, path)
	else:
		Notifier.notify_error("Unable to save image at: %s" % path)
