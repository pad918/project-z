extends Camera3D

#	Sets global rotaion to its inital value
#	Usefull for cameras when you want to ignore parent rotation
#
#
@export var lock_x_rot := true
@export var lock_y_rot := true
@export var lock_z_rot := true

var target_global_rot : Vector3

func _ready() -> void:
	target_global_rot = global_rotation
	
func _process(_delta: float) -> void:
	if(lock_x_rot):
		global_rotation.x = target_global_rot.x
	if(lock_y_rot):
		global_rotation.y = target_global_rot.y
	if(lock_z_rot):
		global_rotation.z = target_global_rot.z
