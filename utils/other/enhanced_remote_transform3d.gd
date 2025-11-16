extends Node3D

@export var remote_node : Node3D

@export var copy_x := true
@export var copy_y := true
@export var copy_z := true

func _process(_delta: float) -> void:
	if(!remote_node):
		return
		
	if(copy_x):
		global_position.x = remote_node.global_position.x
		
	if(copy_y):
		global_position.y = remote_node.global_position.y
		
	if(copy_z):
		global_position.z = remote_node.global_position.z
