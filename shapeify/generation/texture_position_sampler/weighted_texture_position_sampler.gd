extends TexturePositionSampler

## Array that stores the cumulative distribution function values(CDF)
## This array is cached after the weight texture is updated, speeding up the 
## sampling process
var _cached_cdf: PackedFloat32Array

func sample() -> Vector2i:
	var index = CDFSampler.sample_from_cdf(_cached_cdf)
	# Maps 1D index to 2D pixel position
	return Vector2i(
		index % weight_texture.get_width(), 
		index / weight_texture.get_width())

func _weight_texture_set():
	# Caches the CDF after the texture changed
	_cache_cdf()

func _cache_cdf():
	
	var rd = GenerationGlobals.algorithm_rd
	var rd_rid = weight_texture.rd_rid
	
	# Fetch texture data as raw bytes
	var texture_bytes = rd.texture_get_data(rd_rid, 0)
	
	var width = weight_texture.get_width()
	var height = weight_texture.get_height()
	var pixel_count = width * height
	
	# Build cumulative distribution (CDF) while extracting red channel
	var red_channel = PackedFloat32Array()
	red_channel.resize(pixel_count)
	
	for i in range(pixel_count):
		# Extract normalized red channel
		red_channel[i] = texture_bytes[i * 4] / 255.0
	
	_cached_cdf = CDFSampler.probabilities_to_cdf(red_channel)
