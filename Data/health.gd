extends Resource
class_name Health

signal health_changed

@export var max_health: int
var current_health: int

func reset():
	current_health = max_health
	pass

func remove_health(amount: int):
	current_health = maxi(0, current_health - amount)
	emit_signal("health_changed", current_health)
	pass

func add_health(amount: int):
	current_health = mini(max_health, current_health + amount)
	emit_signal("health_changed", current_health)
	pass
