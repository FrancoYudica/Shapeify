extends Node

signal image_generator_params_updated

var settings: AppSettings

func save():
	ResourceSaver.save(settings, "user://genart_settings.tres")

func _init() -> void:
	
	var default_settings: AppSettings = load("res://settings/default_settings.tres")
	default_settings.image_generator_params = load("res://settings/image_generator_params/fast_image_generator_params.tres")
	
	# The first time loads the default settings
	if not ResourceLoader.exists("user://genart_settings.tres"):
		settings = default_settings
	else:
		
		#  Loads settings from user path
		var user_settings = load("user://genart_settings.tres")
		
		# If the versions doesn't match, overrides with default settings
		if user_settings.version != default_settings.version:
			settings = default_settings
		else:
			settings = user_settings
	
	settings.setup_signals()
	
func _enter_tree() -> void:
	
	var textures = settings \
		.image_generator_params \
		.shape_generator_params \
		.shape_spawner_params \
		.textures
	
	var texture_group: ShapeTextureGroup = null
	
	for group in settings.shape_texture_groups:
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
	
	if target_texture == null or not target_texture.is_valid():
		Notifier.notify_error("Unable to load default target texture")
		return
	
	settings.image_generator_params.target_texture = target_texture
	
	Globals.settings.image_generator_params.setup_changed_signals()
	Globals.settings.image_generator_params.changed.connect(_image_generator_params_changed)
	
func _exit_tree() -> void:

	# Clears previous textures
	var textures = settings \
			.image_generator_params \
			.shape_generator_params \
			.shape_spawner_params.textures
	
	textures.clear()
	
	settings \
	.image_generator_params \
	.weight_texture_generator_params \
	.user_weight_texture = null
	
	save()
	

func image_generator_params_set_preset(preset_type: ImageGeneratorParams.Type):
	
	# Loads any of the presets and duplicates
	var preset: ImageGeneratorParams = null
	match preset_type:
		ImageGeneratorParams.Type.SUPER_FAST:
			preset = load("res://settings/image_generator_params/super_fast_image_generator_params.tres").duplicate(true)
		ImageGeneratorParams.Type.FAST:
			preset = load("res://settings/image_generator_params/fast_image_generator_params.tres").duplicate(true)
		ImageGeneratorParams.Type.PERFORMANCE:
			preset = load("res://settings/image_generator_params/performance_image_generator_params.tres").duplicate(true)
		ImageGeneratorParams.Type.QUALITY:
			preset = load("res://settings/image_generator_params/quality_image_generator_params.tres").duplicate(true)
	
	# Copies runtime params
	var previous_params = Globals.settings.image_generator_params
	preset.target_texture = previous_params.target_texture
	preset.shape_generator_params.shape_spawner_params.textures = previous_params.shape_generator_params.shape_spawner_params.textures
	preset.weight_texture_generator_params.user_weight_texture = previous_params.weight_texture_generator_params.user_weight_texture
	# Updates the image generator params
	Globals.settings.image_generator_params = preset
	image_generator_params_updated.emit()
	
	# Connects changed signals
	preset.setup_changed_signals()
	preset.changed.connect(_image_generator_params_changed)

func _image_generator_params_changed():
	Globals.settings.image_generator_params.type = ImageGeneratorParams.Type.CUSTOM
