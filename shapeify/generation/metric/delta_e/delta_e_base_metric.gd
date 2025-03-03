class_name DeltaEMetric extends Metric

var mask_texture: LocalTexture:
	set(texture):
		
		if mask_texture != texture:
			mask_texture = texture
			_mask_texture_set()

func _mask_texture_set():
	pass
