extends Node3D

class_name EnemyWaveHandler

signal last_event_executed

@export var events: Array[EnemyWaveEvent]

var time := 0.0

func _ready() -> void:
	# Sort the events by start time
	events.sort_custom(
	func(a:EnemyWaveEvent, b:EnemyWaveEvent):
		return a.event_time < b.event_time
		)

# Returns true if first event was executed and removed
func try_execute_first_event() -> bool:
	if(events && !events.is_empty() && events.front().event_time <= time):
		events.front().execute(self)
		events.remove_at(0)
		if(events.is_empty()):
			last_event_executed.emit()
		return true
	return false
		

func _physics_process(delta: float) -> void:
	time += delta
	while(try_execute_first_event()):
		pass
	
