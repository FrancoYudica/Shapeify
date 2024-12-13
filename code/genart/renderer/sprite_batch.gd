extends Batch

const _MAX_SUMISSIONS = 1024

var _vertex_buffers: Dictionary
var _vertex_buffers_data: Dictionary
var _index_buffer: RID
var _submissions_count: int = 0
var _index_array_index_count: int = 0
enum VertexComponentType
{
	POSITION,
	UV,
	COLOR,
	TEXTURE,
	ROTATION,
	ID
}

func push_sprite(
	pos: Vector3,
	size: Vector2,
	rotation: float,
	color: Color,
	texture_slot: int,
	id: float
):
	
	if _submissions_count == _MAX_SUMISSIONS - 1:
		flush()
	
	var index = _submissions_count * 4
	
	var rotation_matrix = Transform2D(rotation, Vector2.ZERO)
	
	var local_positions = [
		Vector2(-size.x, -size.y),
 		Vector2(-size.x, size.y),
 		Vector2(size.x, size.y),
 		Vector2(size.x, -size.y)
	]
	for i in range(4):
		var rotated = rotation_matrix * 0.5 * local_positions[i]
		_vertex_buffers_data[VertexComponentType.POSITION][index + i] = pos + Vector3(rotated.x, rotated.y, 0)

	_vertex_buffers_data[VertexComponentType.UV][index + 0] = Vector2(0, 0)
	_vertex_buffers_data[VertexComponentType.UV][index + 1] = Vector2(0, 1)
	_vertex_buffers_data[VertexComponentType.UV][index + 2] = Vector2(1, 1)
	_vertex_buffers_data[VertexComponentType.UV][index + 3] = Vector2(1, 0)
	
	_vertex_buffers_data[VertexComponentType.COLOR][index + 0] = color
	_vertex_buffers_data[VertexComponentType.COLOR][index + 1] = color
	_vertex_buffers_data[VertexComponentType.COLOR][index + 2] = color
	_vertex_buffers_data[VertexComponentType.COLOR][index + 3] = color

	_vertex_buffers_data[VertexComponentType.TEXTURE][index + 0] = texture_slot
	_vertex_buffers_data[VertexComponentType.TEXTURE][index + 1] = texture_slot
	_vertex_buffers_data[VertexComponentType.TEXTURE][index + 2] = texture_slot
	_vertex_buffers_data[VertexComponentType.TEXTURE][index + 3] = texture_slot

	_vertex_buffers_data[VertexComponentType.ROTATION][index + 0] = rotation
	_vertex_buffers_data[VertexComponentType.ROTATION][index + 1] = rotation
	_vertex_buffers_data[VertexComponentType.ROTATION][index + 2] = rotation
	_vertex_buffers_data[VertexComponentType.ROTATION][index + 3] = rotation

	_vertex_buffers_data[VertexComponentType.ID][index + 0] = id
	_vertex_buffers_data[VertexComponentType.ID][index + 1] = id
	_vertex_buffers_data[VertexComponentType.ID][index + 2] = id
	_vertex_buffers_data[VertexComponentType.ID][index + 3] = id

	_submissions_count += 1

func begin_frame():
	pass
	
func end_frame():
	flush()
	
func flush():
	
	if _submissions_count == 0:
		return
		
	for type in _vertex_buffers_data.keys():
		var arr = _vertex_buffers_data[type]
		var arr_bytes = arr.to_byte_array()
		var bytes_per_attrib = arr_bytes.size() / (_MAX_SUMISSIONS)
		var vbo = _vertex_buffers[type]
		rd.buffer_update(
			vbo, 
			0,
			bytes_per_attrib * _submissions_count,
			arr_bytes)
	
	# Updates index array
	if _index_array_index_count != _submissions_count * 6:
		
		if index_array.is_valid():
			rd.free_rid(index_array)

		index_array = rd.index_array_create(_index_buffer, 0, _submissions_count * 6)
		_index_array_index_count = _submissions_count * 6
	
	Renderer.flush()
	_submissions_count = 0

func initialize() -> bool:

	var shader_file = load("res://shaders/renderer/sprite_batch.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	shader = rd.shader_create_from_spirv(shader_spirv)

	# Initializes vertex buffers and allocates space
	_vertex_buffers_data[VertexComponentType.POSITION] = PackedVector3Array()
	_vertex_buffers_data[VertexComponentType.UV] = PackedVector2Array()
	_vertex_buffers_data[VertexComponentType.ROTATION] = PackedFloat32Array()
	_vertex_buffers_data[VertexComponentType.COLOR] = PackedColorArray()
	_vertex_buffers_data[VertexComponentType.TEXTURE] = PackedInt32Array()
	_vertex_buffers_data[VertexComponentType.ID] = PackedFloat32Array()
	
	for arr in _vertex_buffers_data.values():
		arr.resize(4 * _MAX_SUMISSIONS)
	
	# Setup indices, creates index buffer and index array ------------------------------------------
	var indices_data = PackedInt32Array()
	indices_data.resize(6 * _MAX_SUMISSIONS)
	for i in range(_MAX_SUMISSIONS):
		var index = i * 6
		var vertex_index = i * 4
		indices_data[index + 0] = vertex_index + 0
		indices_data[index + 1] = vertex_index + 2
		indices_data[index + 2] = vertex_index + 1
		indices_data[index + 3] = vertex_index + 0
		indices_data[index + 4] = vertex_index + 2
		indices_data[index + 5] = vertex_index + 3
	
	var indices_bytes = indices_data.to_byte_array()
	
	_index_buffer = rd.index_buffer_create(
		indices_data.size(), 
		RenderingDevice.INDEX_BUFFER_FORMAT_UINT32,
		indices_bytes)
	
	# Vertex buffers containing vertex array data --------------------------------------------------
	for type in _vertex_buffers_data.keys():
		var arr = _vertex_buffers_data[type]
		var arr_bytes = arr.to_byte_array()
		var vbo = rd.vertex_buffer_create(arr_bytes.size(), arr_bytes)
		_vertex_buffers[type] = vbo
	
	# Vertex array ---------------------------------------------------------------------------------
	var position_attr = RDVertexAttribute.new()
	position_attr.format = RenderingDevice.DATA_FORMAT_R32G32B32_SFLOAT
	position_attr.location = 0
	position_attr.stride = 4 * 3
	
	var uv_attr = RDVertexAttribute.new()
	uv_attr.format = RenderingDevice.DATA_FORMAT_R32G32_SFLOAT
	uv_attr.location = 1
	uv_attr.stride = 4 * 2

	var rotation_attr = RDVertexAttribute.new()
	rotation_attr.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
	rotation_attr.location = 2
	rotation_attr.stride = 4
	
	var color_attr = RDVertexAttribute.new()
	color_attr.format = RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT
	color_attr.location = 3
	color_attr.stride = 4 * 4

	var texture_slot_attr = RDVertexAttribute.new()
	texture_slot_attr.format = RenderingDevice.DATA_FORMAT_R32_UINT
	texture_slot_attr.location = 4
	texture_slot_attr.stride = 4

	var id_slot_attr = RDVertexAttribute.new()
	id_slot_attr.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
	id_slot_attr.location = 5
	id_slot_attr.stride = 4

	vertex_array_format = rd.vertex_format_create(
		[
			position_attr,
			uv_attr,
			rotation_attr,
			color_attr,
			texture_slot_attr,
			id_slot_attr
		]
	)
	vertex_array = rd.vertex_array_create(
		4,
		vertex_array_format,
		_vertex_buffers.values())
	
	return true
