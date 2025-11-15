extends Node3D

class_name ShipSwaing

@export var amount := 0.25
@export var time_scale := 3.0
@export var hit_sway_graviy := 2.0


var noise = FastNoiseLite.new()
var timer := 0.0

var curr_hit_velocity = Vector2.ZERO
var curr_hit_sway = Vector2.ZERO

func _ready():
	# Set the desired noise type to Perlin
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	
	# Optional: Configure other parameters for different looks
	noise.seed = randi() # Change the random pattern
	noise.frequency = 0.05 # Smaller value means smoother, larger features
	noise.fractal_octaves = 5

func hit(hit_dir:Vector2):
	curr_hit_velocity += hit_dir

func get_wave_sway() -> Vector3:
	var rot = Vector3(noise.get_noise_1d(timer+1000.0) * amount*0.4, 0.0, noise.get_noise_1d(timer) * amount)
	return rot
	
# Returns the sway caused being hit 
func get_hit_sway(delta:float) -> Vector3:
	curr_hit_velocity *= 0.99
	curr_hit_velocity -= curr_hit_sway * delta * hit_sway_graviy
	curr_hit_sway += curr_hit_velocity * delta
	return Vector3(curr_hit_sway.x, 0, curr_hit_sway.y)
	
func _physics_process(delta: float) -> void:
	timer += delta * time_scale
	rotation = get_wave_sway()
	rotation += get_hit_sway(delta)

		
