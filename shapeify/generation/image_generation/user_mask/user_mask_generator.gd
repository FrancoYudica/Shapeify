## Given a set of points, generates a mask that tells the algorithm which areas of the image
## are included and which are excluded.
class_name UserMaskGenerator extends RefCounted

# Stores a local renderer that uses the same rendering device as the
# algorithm, but it uses ADDITIVE blending mode instead of alpha blending
var _local_renderer: LocalRenderer

func _init() -> void:
	_local_renderer = LocalRenderer.new()
	_local_renderer.initialize(
		GenerationGlobals.renderer.rd,
		LocalRenderer.BlendMode.ADD)
	_local_renderer.clear_color = Color.BLACK

func delete():
	_local_renderer.delete()
	_local_renderer = null

func generate_mask(
	points: Array[UserMaskPoint],
	texture_size: Vector2i,
	camera_view: CameraViewParams = CameraViewParams.new()) -> LocalTexture:
	
	var size = Vector2(texture_size.x, texture_size.y)
	
	_local_renderer.begin_frame(
		texture_size,
		camera_view.zoom,
		camera_view.normalized_translation * size)
	
	if points.size() == 0:
		_local_renderer.render_clear(Color.WHITE)
	else:
		_local_renderer.render_clear(Color.TRANSPARENT)
	
		for point in points:
				
			_local_renderer.render_sprite(
				point.normalized_position * size,
				point.normalized_size * Vector2(size.x, size.x),
				0.0,
				Color.WHITE,
				point.texture)
	
	_local_renderer.end_frame()
	
	return _local_renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR).copy()
