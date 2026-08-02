extends Node

var renderer: LocalRenderer
var algorithm_rd: RenderingDevice

func _enter_tree() -> void:
	algorithm_rd = RenderingServer.create_local_rendering_device()

	renderer = LocalRenderer.new()
	renderer.initialize(algorithm_rd)

func _exit_tree() -> void:
	renderer.delete()
	renderer = null
