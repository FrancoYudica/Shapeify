extends Node

var renderer: LocalRenderer
var algorithm_rd: RenderingDevice

func _enter_tree() -> void:
	
	# Creates a local rendering device, used by the image generation thread
	algorithm_rd = RenderingServer.create_local_rendering_device()
	
	renderer = LocalRenderer.new()
	renderer.initialize(LocalRenderer.Type.SPRITE, algorithm_rd)
