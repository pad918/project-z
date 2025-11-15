extends RigidBody3D

class_name ChainPart

@export var strength := 50.0
@export var target_rotation: float = 0
@export var previous_link: ChainPart
var pid: Pid
var _is_torque_on = true


func _ready() -> void:
	pid = Pid.new(1.0, 0.2, 0.6)
	body_entered.connect(_hit_body)

func _hit_body(body):
	if(body is ShipCollider):
		body.push_ship(Vector2(0.0, -0.03))
	print("TENTACLE HIT: ", body.name)

func step(delta: float):
	var local_rot:float = self.global_rotation.z 
	var error:float = target_rotation - local_rot
	var pid_signal = pid.step(error, delta)
	apply_torque(Vector3(0,0, pid_signal*strength))

func _physics_process(delta: float) -> void:
	if(_is_torque_on):
		step(delta)

func stop_torque():
	_is_torque_on = false
