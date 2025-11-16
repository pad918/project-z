extends State

@onready var model: Sprite3D = $RotationOffset/SpineModel/Sprite3D
@onready var camera: Camera3D = $RotationOffset/Camera3D
@onready var attackable_body: AttackableBody = $AttackableBody
@onready var player_animator: AnimationPlayer = $PlayerAnimator

@export_category("Movement")
@export var move_speed: float = 13.0
@export var gravity: float = 40.0

@export_category("Transisionts")
@export var dash_state : State
@export var jump_dash_state : State

var owner_body:Player:
	get():
		return owner_node as Player

func apply_gravity(delta:float):
	if(!owner_body.is_on_floor()):
		owner_body.velocity.y -= delta * gravity

func state_process(delta:float):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	if(Input.is_action_just_pressed("move_dash") && owner_body.is_on_floor()):
		dash_state.start_dash(direction)
		try_set_state(dash_state)
	
	# Reuse the dash state for jumpting
	if(Input.is_action_just_pressed("move_jump") && owner_body.is_on_floor()):
		jump_dash_state.start_dash(Vector3.UP)
		try_set_state(jump_dash_state)
	
	direction = direction.normalized()
	var is_moving = direction != Vector3.ZERO
	owner_body.velocity.x = direction.x * move_speed
	owner_body.velocity.z = direction.z * move_speed
	
	apply_gravity(delta)
	
	owner_body.move_and_slide()
	pass
