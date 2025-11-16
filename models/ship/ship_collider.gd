extends StaticBody3D

class_name ShipCollider

var ship:ShipSwaing :
	get():
		return get_parent().get_parent()
		
func push_ship(vel):
	ship.hit(vel)
