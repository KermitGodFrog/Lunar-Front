extends Area3D
class_name BoostPickup

@export var BOOST_INCREASE: float
var is_used = false

func _on_body_entered(body):
	if is_used == false:
		if body is Player:
			if game_data.player.current_checkpoint:
				body.BOOST_TIME += BOOST_INCREASE
				is_used = true
	pass
