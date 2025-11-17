extends Node3D

#	Spawns rocks in chunks so
# 	that the world can be infinitly large

@export var base_spawn_density := 0.1
@export var chunk_size := 32
@export var generation_dist = 4

# The target which determines the loaded chunks
@export var target: Node3D
@export var rock_instance : PackedScene

var rng := RandomNumberGenerator.new()

class Chunk:
	var pos : Vector2i
	var objects: Array[Node3D] = []

var prev_chunk_pos: Vector2i = Vector2i(1000000, 10) # Random large number at first

var chunks : Array[Chunk] = []

func get_chunk_at(pos: Vector2i) -> Chunk:
	var index = chunks.find_custom(
		func(chunk: Chunk):
			return chunk.pos == pos
	)
	return chunks[index] if index>=0 else null

func generate_chunk(pos:Vector2i):
	var chunk : Chunk = get_chunk_at(pos)
	if(chunk != null):
		return
	print("GENERATING CHUNK: ", pos)
	chunk = Chunk.new()
	chunk.pos = pos
	rng.seed = hash(pos)
	var chunk_objects = rng.randi_range(0, int(chunk_size*chunk_size*base_spawn_density*0.001))
	for i in range(chunk_objects):
		var obj : Node3D = rock_instance.instantiate()
		add_child(obj)
		obj.global_position = Vector3(chunk_size * pos.x, 0.0, chunk_size*pos.y) + Vector3(rng.randf_range(0, chunk_size), 0.0, rng.randf_range(0, chunk_size))
		chunk.objects.append(obj)
	chunks.append(chunk)
		
	
func update_loaded_chunks():
	for x in range(prev_chunk_pos.x - generation_dist/2, prev_chunk_pos.x + generation_dist/2):
		for y in range(prev_chunk_pos.y - generation_dist/2, prev_chunk_pos.y + generation_dist/2):
			generate_chunk(Vector2i(x, y))

func _physics_process(_delta: float) -> void:
	var chunk_pos = Vector2i(target.global_position.x/chunk_size, target.global_position.z/chunk_size) 
	if(chunk_pos != prev_chunk_pos):
		prev_chunk_pos = chunk_pos
		update_loaded_chunks()
