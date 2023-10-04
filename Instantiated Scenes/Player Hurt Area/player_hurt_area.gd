extends Area3D

@export var is_active: bool = true

func _physics_process(delta):
	if is_active == true:
		if $cooldown.is_stopped():
			for body in get_overlapping_bodies():
				if body is Player:
					body.health.remove_health(10)
					game_data.hud_effect.circle_effect(Color.RED, 1)
					$cooldown.start()
	pass
