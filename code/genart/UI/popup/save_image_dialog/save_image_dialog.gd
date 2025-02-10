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

func _ready() -> void:
	close_button.pressed.connect(
		func():
			visible = false
	)
	
	save_button.pressed.connect(_save)
	file_dialog.file_selected.connect(_on_file_dialog_file_selected)
	scale_spin_box.value_changed.connect(
		func(value):
			final_resolution_label.text = "%sx%s" % [
				int(_processed_details.viewport_size.x * scale_spin_box.value),
				int(_processed_details.viewport_size.y * scale_spin_box.value)]
	)
	
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

func _oppened():

	var gen_details: ImageGenerationDetails = ImageGeneration.details
	visible = true
	
	_processed_details = ShapeColorPostProcessingPipeline.process_details(
		gen_details,
		0.0,
		Globals.settings.color_post_processing_pipeline_params.shader_params)

	resolution_label.text = "%sx%s" % [
		_processed_details.viewport_size.x,
		_processed_details.viewport_size.y]
	
	final_resolution_label.text = "%sx%s" % [
		int(_processed_details.viewport_size.x * scale_spin_box.value),
		int(_processed_details.viewport_size.y * scale_spin_box.value)]

	# Frees previous texture
	if save_texture.texture != null and save_texture.texture is Texture2DRD:
		var rd = RenderingServer.get_rendering_device()
		var texture_rd_rid = save_texture.texture.texture_rd_rid
		save_texture.texture.texture_rd_rid = RID()
		save_texture.texture = null
		rd.free_rid(texture_rd_rid)
	
	# Renders the texture
	ImageGenerationRenderer.render_image_generation(Renderer, _processed_details)
	var rendered = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR).copy()
	save_texture.texture = RenderingCommon.create_texture_from_rd_rid(rendered.rd_rid)

func _save():
	file_dialog.clear_filters()
	file_dialog.add_filter("*%s" % _frame_saver.get_extension())
	file_dialog.visible = true

func _on_file_dialog_file_selected(path: String) -> void:
	
	var success = _frame_saver.save(
		path,
		_processed_details.shapes,
		_processed_details.clear_color,
		_processed_details.viewport_size * scale_spin_box.value
	)
