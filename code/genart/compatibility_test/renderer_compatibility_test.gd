extends CompatibilityTest

func evaluate() -> bool:
	
	if not Renderer.is_valid:
		output = "Unable to initialize renderer pipeline"
	
	return Renderer.is_valid
