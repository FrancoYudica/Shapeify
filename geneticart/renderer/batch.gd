class_name Batch extends RefCounted

var rd: RenderingDevice
var vertex_array: RID
var vertex_array_format: int
var index_array: RID
var shader: RID

func initialize() -> bool:
	return false

func begin_frame():
	pass
	
func end_frame():
	pass
	
func flush():
	pass
	
