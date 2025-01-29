class_name WeightedRandomSampler extends RefCounted

func sample(normalized_probabilities: Array) -> int:
	if normalized_probabilities.is_empty():
		push_error("WeightedRandomSampler: Empty probability array")
		return -1  # Or another sensible default
	
	var cumulated_probabilities = 0.0
	var random_value = randf()
	
	for i in range(normalized_probabilities.size()):
		cumulated_probabilities += normalized_probabilities[i]
		
		if random_value < cumulated_probabilities or i == normalized_probabilities.size() - 1:
			return i
	
	# Fallback return (should never reach here)
	push_warning("WeightedRandomSampler: Unexpected fallback")
	return normalized_probabilities.size() - 1
