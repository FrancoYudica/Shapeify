class_name AppSettings extends Resource

@export var version: String

@export var image_generator_params := ImageGeneratorParams.new()

@export var color_post_processing_pipeline_params := ShapeColorPostProcessingPipelineParams.new()

@export var default_target_texture: Texture

## Textures that are automatically loaded
@export var default_texture_group_name: String
@export var shape_texture_groups: Array[ShapeTextureGroup] = []

## Boolean flag to control if the algorithm should be displaying the output while generating the
## image. Displaying the image takes more time, so it's better to keep this set to false
@export var render_while_generating: bool = true

func setup_signals():
	color_post_processing_pipeline_params.setup_signals()
