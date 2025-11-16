extends Node3D

var parts : Array[ChainPart]

var timer := 0.0
var rng := RandomNumberGenerator.new()
var offsets: Array[float] = []

var attack_rot := 0.0

func _ready() -> void:
	for c in get_children():
		if(c is ChainPart):
			parts.append(c)

func set_targets():
	#print("PART SIZES: ", parts.size())
	for i in range(parts.size()):
		var t: float = 0
		t = sin(timer*3.0 + i*0.3)*0.1
		t += -0.4 + 0.133*i
		t += attack_rot
		parts[i].target_rotation = t
	pass

func _physics_process(delta: float) -> void:
	timer += delta
	set_targets()
	if(timer > 6.0-3):
		attack_rot = min(1.5, attack_rot+delta*2.0)
	if(timer > 7.5-3):
		for p in parts:
			p.stop_torque()
	if(timer > 10-3):
		parts.front().position.y -= delta*5.0
