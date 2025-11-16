extends Viewport

@export var health_entity_path: NodePath
@export var hide_on_full_hp := false
@onready var health_progress_bar: ProgressBar = $Container/HealthProgressBar

var health_entity:Node3D

func _ready() -> void:
	health_entity = get_node(health_entity_path)
	assert(health_entity)
	# Health entites must define hp and max_hp
	assert("hp" in health_entity)
	assert("max_hp" in health_entity)

func _process(_delta: float) -> void:
	health_progress_bar.max_value = health_entity.max_hp
	health_progress_bar.value = health_entity.hp
	if(hide_on_full_hp):
		var new_vis = health_entity.hp < health_entity.max_hp
		var old_vis = get_parent().visible
		get_parent().visible = new_vis
		if(new_vis != old_vis):
			print("Changing vis of ", name, " to: ", new_vis)
