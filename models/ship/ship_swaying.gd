extends Node3D

@export var amount := 0.25
@export var time_scale := 3.0

var noise = FastNoiseLite.new()
var timer := 0.0

func _ready():
	# Set the desired noise type to Perlin
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	
	# Optional: Configure other parameters for different looks
	noise.seed = randi() # Change the random pattern
	noise.frequency = 0.05 # Smaller value means smoother, larger features
	noise.fractal_octaves = 5

func _physics_process(delta: float) -> void:
	timer += delta * time_scale
	rotation.z = noise.get_noise_1d(timer) * amount
	rotation.x = noise.get_noise_1d(timer+1000.0) * amount*0.4
