extends SubViewport

@export var clear_color: Color
@export var color_rect: ColorRect
@export var shapes_container: Control
@export var shapes: Array[Shape]

var _gd_shape = load("res://godot_shape_renderer/gd_shape_texture_rect.tscn")

## Maps shapes textures RID to godot Texture2D
var _texture_map: Dictionary

func clear():
	shapes.clear()
	color_rect.color = clear_color
	
	for child in shapes_container.get_children():
		shapes_container.remove_child(child)
		child.queue_free()
		
	for texture: Texture2DRD in _texture_map.values():
		var texture_rd_rid = texture.texture_rd_rid
		texture.texture_rd_rid = RID()
		var global_rd = RenderingServer.get_rendering_device()
		global_rd.free_rid(texture_rd_rid)

	_texture_map.clear()


func add_shape(shape: Shape, render_scale: float = 1.0):
	if not _texture_map.has(shape.texture.rd_rid):
		_texture_map[shape.texture.rd_rid] = RenderingCommon.create_texture_from_rd_rid(
				shape.texture.rd_rid
			)
			
	var gd_shape = _gd_shape.instantiate()
	gd_shape.from_shape(shape, _texture_map[shape.texture.rd_rid], render_scale)
	shapes_container.call_deferred("add_child", gd_shape)

func _exit_tree() -> void:
	clear()
