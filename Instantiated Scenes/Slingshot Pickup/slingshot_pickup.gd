extends Area3D

@export var BOOST_SPEED: float
var is_used = false

func _on_body_entered(body):
	if is_used == false:
		if body is Player:
			if game_data.player.current_checkpoint:
				body.velocity = body.transform.basis.z * BOOST_SPEED
				is_used = true
				game_data.hud_effect.circle_effect(Color.PURPLE, 3)
	pass
