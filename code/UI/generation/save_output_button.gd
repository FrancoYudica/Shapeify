extends TextureButton

@export var image_generation: Node
@export var output_texture_rect: TextureRect
@export var file_dialog: FileDialog
@export var notification_popup: PopupPanel

func _ready() -> void:
	
	disabled = true
	modulate = Color.DARK_GRAY
	
	image_generation.generation_started.connect(
		func():
			disabled = true
			modulate = Color.DARK_GRAY
	)
	image_generation.generation_finished.connect(
		func():
			disabled = false
			modulate = Color.WHITE
	)


func _on_pressed() -> void:
	file_dialog.visible = true

func _on_file_dialog_file_selected(path: String) -> void:
		# Gets color attachment data
		var color_attachment_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
		var color_attachment_data = Renderer.rd.texture_get_data(color_attachment_texture.rd_rid, 0)
		
		# Creates an image with the same size and format
		var img = Image.new()
		img.set_data(
			output_texture_rect.texture.get_width(),
			output_texture_rect.texture.get_height(),
			false,
			Image.Format.FORMAT_RGBAF,
			color_attachment_data)
		
		notification_popup.visible = true
		if img.save_png(path) == OK:
			notification_popup.text = "Successfully saved image at: %s" % path
		else:
			notification_popup.text = "Error (%s) while saving image at: %s" % path
