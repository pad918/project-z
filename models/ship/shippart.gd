class_name ShipPart extends Node3D

@export var max_hp := 1.0
@onready var mesh_instance_3d: MeshInstance3D = $PlankType1

var ship: ShipMovement :
	get():
		return get_parent()

var hp: float
var _is_broken : bool :
	get():
		return hp <= 0

func _ready() -> void:
	add_to_group("ship_parts")
	hp = max_hp

func _on_on_break() -> void:
	mesh_instance_3d.visible = false

func repair(amount : float = 100.0) -> void:
	if _is_broken:
		print("repairing broken ship part: ", name)
		mesh_instance_3d.visible = true
		hp = min(max_hp, amount)
	else:
		print("Repairing partially damaged part: ", name)
		hp = min(max_hp, hp + amount)
		
func _take_knockback(vel: Vector3):
	var ship_knockback = Vector2(vel.y, vel.x).rotated(ship.global_rotation.y)
	print("Ship knockback: ", ship_knockback)
	ship.hit(ship_knockback)

func take_damage(source: DamageArea):
	hp -= source.base_damage
	var dir = (source.global_position-ship.global_position).normalized()
	_take_knockback(dir*0.6*source.base_knockback)
	if(_is_broken):
		_on_on_break()

func get_is_damaged():
	return hp != max_hp

func get_is_broken():
	return _is_broken
