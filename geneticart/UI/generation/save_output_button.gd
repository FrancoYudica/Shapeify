extends Button

@export var image_generation: Node
@export var popup_panel: PopupPanel
@export var output_texture_rect: TextureRect
@export var file_dialog: FileDialog

func _ready() -> void:
	
	disabled = true
	
	image_generation.generation_started.connect(
		func():
			get_parent().visible = false
	)
	image_generation.generation_finished.connect(
		func():
			get_parent().visible = true
			disabled = false
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
		
		img.save_png(path)
		popup_panel.visible = true
		#$"../../PopupPanel/MarginContainer/VBoxContainer/Label".text = "Saved image at: " + path
