extends Node

var settings: AppSettings

func save():
	ResourceSaver.save(settings)

func _init() -> void:
	settings = load("res://generation/settings.tres")
	
	# Initializes settings in case these are empty
	if settings.image_generator_params == null:
		settings.image_generator_params = ImageGeneratorParams.new()
	
	
func _enter_tree() -> void:
	
	var textures = settings \
		.image_generator_params \
		.individual_generator_params \
		.populator_params.textures
	
	var texture_group: IndividualsTextureGroup = null
	
	for group in settings.individuals_texture_groups:
		if group.name == settings.default_texture_group_name:
			texture_group = group
			break
			
	if texture_group == null:
		push_error("Unable to find texture group named: %s" % settings.default_texture_group_name)
	
	
	# Loads default textures
	for default_texture in texture_group.textures:
		var renderer_texture = RendererTexture.load_from_texture(default_texture)
		textures.append(renderer_texture)
	
	# Loads default target texture
	var target_texture = RendererTexture.load_from_texture(settings.default_target_texture)
	settings.image_generator_params.individual_generator_params.target_texture = target_texture


func _exit_tree() -> void:

	# Clears previous textures
	var textures = settings \
			.image_generator_params \
			.individual_generator_params \
			.populator_params.textures
	
	textures.clear()

	save()
