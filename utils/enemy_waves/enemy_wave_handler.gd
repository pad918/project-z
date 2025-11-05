extends Node3D

class_name EnemyWaveHandler

func execute_event(event: EnemyWaveEvent):
	event.execute(self)

	
