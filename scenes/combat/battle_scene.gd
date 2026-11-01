extends CanvasLayer

@export var decay := 0.8
@export var max_offset := Vector2(12, 8)
@export var max_roll := 0.03
@export var noise: FastNoiseLite

var trauma := 0.0
var trauma_pwr := 3
var noise_y := 0.0

func _ready() -> void:
	if noise == null:
		noise = FastNoiseLite.new()
		noise.frequency = 0.5
	noise.seed = randi()

func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)

func _process(delta: float) -> void:
	if trauma > 0.0:
		trauma = max(trauma - decay * delta, 0.0)
		var amt := pow(trauma, trauma_pwr)
		noise_y += 1.0
		rotation = max_roll * amt * noise.get_noise_2d(noise.seed, noise_y)
		offset = Vector2(
			max_offset.x * amt * noise.get_noise_2d(noise.seed * 2, noise_y),
			max_offset.y * amt * noise.get_noise_2d(noise.seed * 3, noise_y))
	elif offset != Vector2.ZERO or rotation != 0.0:
		offset = Vector2.ZERO
		rotation = 0.0

# implementation transfered from https://gist.githubusercontent.com/Alkaliii/3d6d920ec3302c0ce26b5ab89b417a4a/raw/c8f3352830c884d7ac95116f4ab7cddaf2ae4b99/ShakeCamera2D.gd
