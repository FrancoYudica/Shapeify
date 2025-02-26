extends PanelContainer

@export var texture_rect: MasterRendererOutputTextureRect

func _ready() -> void:
	texture_rect.master_renderer_params = ImageGeneration.master_renderer_params
