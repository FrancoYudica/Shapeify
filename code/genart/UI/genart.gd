extends Node


func _ready() -> void:
	
	var test_outputs := CompatibilityTestEvaluator.new().is_system_compatible()
	var is_compatible = test_outputs.size() == 0
	if not is_compatible:
		
		printerr("Compatibility tests failed with following errors: ")
		for output in test_outputs:
			printerr("	-%s" % output)
			
		printerr("Closing program...")
		queue_free()
	
	ImageGeneration.application_ready()
