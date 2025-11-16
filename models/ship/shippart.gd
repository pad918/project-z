class_name ShipPart extends Node3D

@export var max_hp := 1
@onready var mesh_instance_3d: MeshInstance3D = $PlankType1

var hp: float
var _is_broken : bool :
	get():
		return hp <= 0

func _ready() -> void:
	add_to_group("ship_parts")
	hp = max_hp

func _on_on_break() -> void:
	mesh_instance_3d.visible = false

func repair() -> void:
	if _is_broken:
		print("repairing broken ship part: ", name)
		mesh_instance_3d.visible = true
		hp = 1
	else:
		print("Repairing partually damaged part: ", name)
		hp = min(max_hp, hp + 1)
		
func take_damage(source: DamageArea):
	hp -= source.base_damage
	if(_is_broken):
		_on_on_break()

func get_is_damaged():
	return hp != max_hp

func get_is_broken():
	return _is_broken
