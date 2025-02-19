class_name NoiseSettings extends Resource

@export var type := FastNoiseLite.NoiseType.TYPE_PERLIN:
	set(value):
		if value != type:
			type = value
			emit_changed()

@export var resolution := Vector2i(32, 32):
	set(value):
		if value != resolution:
			resolution = value
			emit_changed()

@export var seed: int = 0:
	set(value):
		if value != seed:
			seed = value
			emit_changed()

@export var frequency: float = 0.5:
	set(value):
		if value != frequency:
			frequency = value
			emit_changed()

func equals(other_noise: NoiseSettings) -> bool:
	
	return other_noise != null \
		and type == other_noise.type \
		and resolution == other_noise.resolution \
		and seed == other_noise.seed \
		and frequency == other_noise.frequency

static func create_fast_noise_image(settings: NoiseSettings) -> Image:
	var fast_noise = FastNoiseLite.new()
	fast_noise.noise_type = settings.type
	fast_noise.seed = settings.seed
	fast_noise.frequency = settings.frequency * 0.3
	var noise_image = fast_noise.get_image(
		settings.resolution.x, 
		settings.resolution.y)
	return noise_image
