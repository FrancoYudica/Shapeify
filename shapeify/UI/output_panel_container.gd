extends PanelContainer

@export var texture_rect: MasterRendererOutput

func _ready() -> void:
	texture_rect.master_renderer_params = ImageGeneration.master_renderer_params
