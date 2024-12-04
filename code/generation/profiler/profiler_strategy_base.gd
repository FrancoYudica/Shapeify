class_name ProfilerStrategy extends RefCounted


func image_generation_began(
	data: Dictionary, 
	params: ImageGeneratorParams):
	pass
	
func image_generation_finished(
	data: Dictionary, 
	generated_image: RendererTexture):
	pass


func individual_generation_began(
	data: Dictionary,
	params: IndividualGeneratorParams):
	pass

func individual_generation_finished(
	data: Dictionary,
	individual: Individual,
	source_texture: RendererTexture):
	pass
