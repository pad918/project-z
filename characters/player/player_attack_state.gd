extends State

@export var attack_delay := 0.4
@export var player_animator: AnimationPlayer

var time_since_last_attack := 0.0

func _ready() -> void:
	enter_state.connect(on_enter_state)
	
func on_enter_state(prev_state:State):
	if(time_since_last_attack >= attack_delay):
		time_since_last_attack = 0
		player_animator.stop()
		player_animator.play("player_slash")
	try_set_state(prev_state)
	
func _physics_process(delta: float) -> void:
	time_since_last_attack += delta
