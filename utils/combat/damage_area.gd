extends Area3D

#	Currently used as a flag to tell 
#	attackable body that this area
#	can do damage

class_name DamageArea

signal attackble_body_entered(area:AttackableBody)
signal on_cause_damage()

@export var base_damage:float = 1.0
@export var base_knockback:float = 1.0
@export var attackable_groups: Array[String] = []
@export var hit_max_one_per_frame := false

var has_hit_this_frame := false

func _ready() -> void:
	area_entered.connect(
		# Queue free does not happen immidietly, can be delayed multiple physics frames!
		func(_other:Area3D):
			if(is_queued_for_deletion()):
				return
			if(_other is AttackableBody):
				attackble_body_entered.emit(_other)
	)
	
	attackble_body_entered.connect(
		func(area: AttackableBody):
			if(attackable_groups.has(area.body_group)):
				if(hit_max_one_per_frame && has_hit_this_frame):
					return
				has_hit_this_frame = true
				print("MY OBJ ID: ", self)
				print(get_parent().name, " Attacked: ", area.get_parent().name)
				on_cause_damage.emit()
				area.hit(self)
	)
	
func _physics_process(delta: float) -> void:
	has_hit_this_frame = false
	
