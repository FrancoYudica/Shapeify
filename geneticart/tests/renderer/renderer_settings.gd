extends Control

@onready var render_attachment_texture_rect := $"../RendererOutputTextureRect"

@onready var render_scale_label := $PanelContainer/MarginContainer/GridContainer/RenderScaleLabel
@onready var fb_attachment_option := $PanelContainer/MarginContainer/GridContainer/FBAttachmentOptionButton

func _ready() -> void:
	for option in Renderer.FramebufferAttachment.keys():
		fb_attachment_option.add_item(option)

func _on_color_picker_button_color_changed(color: Color) -> void:
	Renderer.clear_color = color

func _on_h_slider_value_changed(value: float) -> void:
	render_scale_label.text = "Render scale: %s " % value
	Renderer.render_scale = value

func _on_fb_attachment_option_button_item_selected(index: int) -> void:
	render_attachment_texture_rect.renderer_fb_attachment_type = index
