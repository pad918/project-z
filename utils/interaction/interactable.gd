extends Area3D

class_name Interactable

@export var min_interation_delay := 0.5

signal interacted(player:Player)
var time_since_interaction := 0.0

func interact(player:Player):
	if(time_since_interaction>min_interation_delay):
		print("INTERACTED WITH: ", name)
		time_since_interaction = 0.0
		interacted.emit(player)
	
func _physics_process(delta: float) -> void:
	time_since_interaction += delta
