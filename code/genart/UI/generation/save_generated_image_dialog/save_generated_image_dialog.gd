extends Control


@export var close_button: Button
@export var save_button: Button
@export var scale_spin_box: SpinBox
@export var resolution_label: Label
@export var final_resolution_label: Label
@export var file_dialog: FileDialog
@export var save_texture: TextureRect

var _src_img_generation_details: ImageGenerationDetails

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
				int(_src_img_generation_details.viewport_size.x * scale_spin_box.value),
				int(_src_img_generation_details.viewport_size.y * scale_spin_box.value)]
	)

func open(gen_details: ImageGenerationDetails):
	visible = true
	_src_img_generation_details = gen_details
	
	resolution_label.text = "%sx%s" % [
		_src_img_generation_details.viewport_size.x,
		_src_img_generation_details.viewport_size.y]
	
	final_resolution_label.text = "%sx%s" % [
		int(_src_img_generation_details.viewport_size.x * scale_spin_box.value),
		int(_src_img_generation_details.viewport_size.y * scale_spin_box.value)]

	# Frees previous texture
	if save_texture.texture != null and save_texture.texture is Texture2DRD:
		var rd = RenderingServer.get_rendering_device()
		var texture_rd_rid = save_texture.texture.texture_rd_rid
		save_texture.texture.texture_rd_rid = RID()
		save_texture.texture = null
		rd.free_rid(texture_rd_rid)

	save_texture.texture = RenderingCommon.create_texture_from_rd_rid(
		_src_img_generation_details.generated_texture.rd_rid)

func _save():
	file_dialog.visible = true

func _on_file_dialog_file_selected(path: String) -> void:
	
	# Creates scaled individuals and ImageGenerationDetails with new data
	var render_details := ImageGenerationDetails.new()
	render_details.clear_color = _src_img_generation_details.clear_color
	render_details.viewport_size = Vector2(
		_src_img_generation_details.viewport_size.x * scale_spin_box.value,
		_src_img_generation_details.viewport_size.y * scale_spin_box.value
	)
	for individual in _src_img_generation_details.individuals:
		var ind = individual.copy()
		ind.position *= scale_spin_box.value
		ind.size *= scale_spin_box.value
		render_details.individuals.append(ind)
	
	# Renders the individuals
	ImageGenerationRenderer.render_image_generation(Renderer, render_details)
	
	# Gets renderer output texture
	var color_attachment_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	var color_attachment_data = Renderer.rd.texture_get_data(color_attachment_texture.rd_rid, 0)
	
	# Transforms to image and saves
	var img = ImageUtils.create_image_from_rgbaf_buffer(
		render_details.viewport_size.x,
		render_details.viewport_size.y,
		color_attachment_data
	)
	
	if img.save_png(path) == OK:
		Notifier.notify_info("Successfully saved image at: %s" % path)
