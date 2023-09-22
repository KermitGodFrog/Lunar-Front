extends AnimationPlayer

func _on_race_start():
	stop()
	play("spaceship_train_movement")
	pass
