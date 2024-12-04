extends TextureButton

@export var image_generation: Node

@export var metrics_panel: PanelContainer

func _ready() -> void:
	metrics_panel.visible = false
	toggled.connect(_on_pressed)

func _on_pressed(toggled_on) -> void:
	metrics_panel.visible = toggled_on
