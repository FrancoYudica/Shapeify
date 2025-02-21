## Cumulative Distribution Sampler.  
## This class converts a given probability distribution into a Cumulative Distribution Function (CDF)  
## and allows sampling from it. Useful for generating random values with unequal probabilities.

class_name CDFSampler extends RefCounted

## Samples a random index from the CDF
static func sample_from_cdf(cdf: PackedFloat32Array) -> int:
	if cdf.is_empty():
		push_error("WeightedRandomSampler: Empty probability array")
		return -1
	
	# Samples pixel index using binary search
	var random_value = randf()
	var index = cdf.bsearch(random_value)
	return index

## Transforms the probabilities to a Cumulative Distribution Function, stored as an array
static func probabilities_to_cdf(probabilities: PackedFloat32Array) -> PackedFloat32Array:
	var cdf = PackedFloat32Array()
	cdf.resize(probabilities.size())
	
	# Sets CDF to cumulative probabilities
	var total_probability = 0
	for i in range(probabilities.size()):
		total_probability += probabilities[i]
		cdf[i] = total_probability
	
	# Normalizes CDF
	for i in range(cdf.size()):
		cdf[i] /= total_probability
		
	return cdf
