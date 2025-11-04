extends CanvasLayer

@export var attackable_body: AttackableBody

@onready var health_progress_bar: ProgressBar = $SubViewport/Healthbar/HealthProgressBar

# This is how we do it for now,
# We will need a better health
# system later that supports 
# max health and other health
# data

func _process(delta: float) -> void:
	if(attackable_body):
		health_progress_bar.value = attackable_body.health
