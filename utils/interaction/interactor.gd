extends Area3D

class_name Interactor 

@export var player: Player

var reachable_interactables : Array[Interactable] = []

func _ready() -> void:
	area_entered.connect(
		func(other:Area3D):
			if(other is Interactable):
				reachable_interactables.append(other as Interactable)
	)
	area_exited.connect(
		func(other:Area3D):
			# Remove any instances of other
			reachable_interactables = reachable_interactables.filter(
				func(area):
					return area != other
			)
	)

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("player_interact")):
		if(!reachable_interactables):
			return
		# Sort
		reachable_interactables.sort_custom(
			func(a : Interactable, b : Interactable):
				var dist_a = global_position.direction_to(a.global_position)
				var dist_b = global_position.direction_to(b.global_position)
				return dist_a < dist_b
		)
		var closest_interactable : Interactable = reachable_interactables.front()
		closest_interactable.interact(player)
