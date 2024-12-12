class_name AppSettings extends Resource

@export var image_generator_params: ImageGeneratorParams

@export var default_target_texture: Texture

## Textures that are automatically loaded
@export var default_texture_group_name: String
@export var individuals_texture_groups: Array[IndividualsTextureGroup] = []

## Boolean flag to control if the algorithm should be displaying the output while generating the
## image. Displaying the image takes more time, so it's better to keep this set to false
@export var render_while_generating: bool = true
