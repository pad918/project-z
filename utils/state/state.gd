extends Node

class_name State

signal enter_state(source:State)

var state_machine: StateMachine :
	get:
		return get_parent()

var owner_node:
	get():
		return state_machine.owner_node

var is_active_state: bool :
	get:
		return state_machine.curr_state == self
	
func try_set_state(new_state: State):
	state_machine.try_set_state(self, new_state)

func state_process(_delta:float):
	pass
