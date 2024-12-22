extends TextureButton

@export var image_generation: Node

@export var metrics_panel: PanelContainer

func _ready() -> void:
	metrics_panel.visible = false
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	metrics_panel.visible = not metrics_panel.visible
