extends CharacterBody3D

@export var DAMAGE: int = 1

func _physics_process(delta):
	move_and_slide()
	pass

func _on_on_screen_notifier_screen_exited():
	queue_free()
	pass

func _on_self_destruct_timer_timeout():
	queue_free()
	pass

func _on_area_body_entered(body):
	print("bullet hit")
	if body.get("health") != null:
		body.health.remove_health(DAMAGE)
	queue_free()
	pass
