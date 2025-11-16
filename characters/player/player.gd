extends CharacterBody3D

class_name Player

@onready var model: Sprite3D = $RotationOffset/SpineModel/Sprite3D
@onready var camera: Camera3D = $RotationOffset/Camera3D
@onready var attackable_body: AttackableBody = $AttackableBody
@onready var player_animator: AnimationPlayer = $PlayerAnimator

@onready var steer_ship_state: State = $MovementStateMachine/SteerShipState


var camera_offset: Vector3 = Vector3.ZERO
var base_camera_offset: Vector3 = Vector3.ZERO

@export_category("health")
@export var max_hp := 10
var hp : float

@export_category("Attack")
@export var attack_scene : PackedScene

# This is not called immidietly after attacking,
# but is used by the animation player to add a 
# slight delay. This is common in many games 
# (heavy weapons in e.g. elden ring)
func spawn_damage_area():
	add_child(attack_scene.instantiate())

func start_steering_ship(ship:ShipMovement):
	steer_ship_state.start_steering(ship)

func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("exit"):
		#get_tree().quit()
	if event.is_action_pressed("exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	model.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	player_animator.play("player_dance")
	hp = max_hp
	
func heal_player():
	hp = max_hp

func take_damage(damage_area: DamageArea):
	hp -= damage_area.base_damage
