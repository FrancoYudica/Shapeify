class_name AppSettings extends Resource

@export var version: String
@export var version_date: String

@export var image_generator_params := ImageGeneratorParams.new()

@export var render_scale := 1.0

@export var color_post_processing_pipeline_params := ShapeColorPostProcessingPipelineParams.new()

@export var default_target_texture: Texture

## Textures that are automatically loaded
@export var default_texture_group_name: String
@export var shape_texture_groups: Array[ShapeTextureGroup] = []


## Feel free to add yourself here after contributing to the project!
@export var contributors: Array[ContributorData] = []

func setup_signals():
	color_post_processing_pipeline_params.setup_signals()
