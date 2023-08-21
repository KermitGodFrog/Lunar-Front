extends Area3D
class_name BoostRing

@export var BOOST_TIME_INCREASE: float
@export var COOLDOWN: int
@export_node_path("Timer") var cooldown_timer

func _ready():
	get_node(cooldown_timer).set("wait_time", COOLDOWN)
	pass

func _on_body_entered(body):
	if get_node(cooldown_timer).is_stopped() == true:
		if body is Player:
			body.BOOST_TIME += BOOST_TIME_INCREASE
	pass
