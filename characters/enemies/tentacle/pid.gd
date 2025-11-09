class_name Pid extends RefCounted

var Kp: float = 0.0
var Ki: float = 0.0
var Kd: float = 0.0
var max_derivative_effect: float = 0.3

var integral_sum: float = 0.0
var previous_error: float = 0.0

func _init(p_kp: float = 0.0, p_ki: float = 0.0, p_kd: float = 0.0, p_max_d: float = 0.6):
	Kp = p_kp
	Ki = p_ki
	Kd = p_kd
	max_derivative_effect = p_max_d

func step(error: float, delta: float) -> float:
	var proportional_term = Kp * error
	
	integral_sum += error * delta
	var integral_term = Ki * integral_sum
	
	var error_derivative = 0.0
	if delta > 0.0:
		error_derivative = (error - previous_error) / delta
		
	var derivative_term = Kd * error_derivative
	
	# Clamp the derivative term
	derivative_term = clamp(derivative_term, -max_derivative_effect, max_derivative_effect)
	
	previous_error = error
	
	return proportional_term + integral_term + derivative_term

func reset():
	integral_sum = 0.0
	previous_error = 0.0
