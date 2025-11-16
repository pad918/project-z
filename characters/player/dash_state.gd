extends State

@export var next_state : State
@export var dash_time := 0.5
@export var dash_speed := 40.0

var owner_body:CharacterBody3D:
	get():
		return owner_node as CharacterBody3D

var velocity:Vector3 = Vector3.ZERO

var time_since_start:float = 0

func start_dash(direction:Vector3):
	time_since_start = 0
	velocity = direction.normalized() * dash_speed + owner_body.velocity
	velocity = velocity
	

func state_process(delta:float):
	time_since_start += delta
	if(time_since_start > dash_time):
		try_set_state(next_state)
	owner_body.velocity = velocity
	owner_body.move_and_slide()
