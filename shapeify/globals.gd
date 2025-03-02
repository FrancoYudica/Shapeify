extends Node

signal image_generator_params_updated

var settings: AppSettings
var _version: String

func save():
	ResourceSaver.save(settings, _get_settings_path())


func _get_settings_path():
	return "user://settings_v%s.tres" % _version

func _init() -> void:
	
	var default_settings: AppSettings = load("res://settings/default_settings.tres")
	default_settings.image_generator_params = load("res://settings/image_generator_params/fast_image_generator_params.tres")
	_version = default_settings.version
	
	# The first time loads the default settings
	if not ResourceLoader.exists(_get_settings_path()):
		settings = default_settings
	else:
		
		#  Loads settings from user path
		var user_settings = load(_get_settings_path())
		
		# If the versions doesn't match, overrides with default settings
		if user_settings == null or user_settings.version != default_settings.version:
			settings = default_settings
		else:
			settings = user_settings
	
	settings.setup_signals()
	
func _enter_tree() -> void:
	
	# Finds the default texture group
	var texture_group: ShapeTextureGroup = null
	
	for group in settings.shape_texture_groups:
		if group.name == settings.default_texture_group_name:
			texture_group = group
			break
			
	if texture_group == null:
		push_error("Unable to find texture group named: %s" % settings.default_texture_group_name)
	
	# Loads default textures
	settings \
		.image_generator_params \
		.shape_generator_params \
		.shape_spawner_params.textures = texture_group.textures.duplicate()

	# Loads default target texture
	settings.image_generator_params.target_texture = settings.default_target_texture
	
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
	
	settings \
	.image_generator_params \
	.user_mask_params.points.clear()
	
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
