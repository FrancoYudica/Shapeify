## Evaluates all the compatibility tests
class_name CompatibilityTestEvaluator extends RefCounted


var _tests: Array[CompatibilityTest] = []


func _init() -> void:
	_tests.append(load("res://compatibility_test/renderer_compatibility_test.gd").new())

func is_system_compatible() -> Array[String]:
	
	var outputs: Array[String] = []
	
	for test in _tests:
		if not test.evaluate():
			outputs.append(test.output)
	
	return outputs
