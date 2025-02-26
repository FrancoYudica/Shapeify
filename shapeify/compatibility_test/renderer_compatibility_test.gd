extends CompatibilityTest

func evaluate() -> bool:
	
	if not GenerationGlobals.renderer.is_valid:
		output = "Unable to initialize renderer pipeline"
	
	return GenerationGlobals.renderer.is_valid
