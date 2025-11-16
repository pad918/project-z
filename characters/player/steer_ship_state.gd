extends State

var prev_state : State

# Avoid that it exits the same frame it enters
var time_since_active := 0.0

var ship: ShipMovement = null

func _ready() -> void:
	enter_state.connect(
		func(prev: State):
			prev_state = prev
			time_since_active = 0.0
	)

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("player_interact") && time_since_active>0):
		try_set_state(prev_state)
		if(ship):
			ship.player_stoped_steering.emit()
			ship = null

func start_steering(_ship: ShipMovement):
	self.ship = _ship
	state_machine.curr_state = self

func state_process(delta:float):
	time_since_active += delta
	var direction := 0.0
	if Input.is_action_pressed("move_left"):
		direction += 1
	if Input.is_action_pressed("move_right"):
		direction -= 1
	ship.turn(direction * delta)
