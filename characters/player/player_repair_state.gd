extends State

@export_category("Repair")
@export var repair_speed := 2.5
@export var repair_range := 5.0

var repair_part : ShipPart = null

var next_state : State

var owner_body:Player:
	get():
		return owner_node as Player

func _ready() -> void:
	enter_state.connect(on_enter_state)
	
func on_enter_state(prev:State):
	assert(prev)
	next_state = prev
	repair_part = _find_repairable_ship_part()
	if(not repair_part):
		try_set_state(next_state)

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_released("repair")):
		try_set_state(next_state)

func state_process(delta:float):
	assert(repair_part)
	repair_part.repair(delta*repair_speed)
	if(not repair_part.get_is_damaged()):
		try_set_state(next_state)

func _find_repairable_ship_part():
	var nearest = null
	var nearest_dist_sq := INF
	for node in get_tree().get_nodes_in_group("ship_parts"):
		if node is ShipPart:
			var sp: ShipPart = node
			if sp.get_is_damaged():
				var d := owner_body.global_transform.origin.distance_squared_to(sp.global_transform.origin)
				if d <= repair_range * repair_range and d < nearest_dist_sq:
					nearest = sp
					nearest_dist_sq = d
	return nearest
