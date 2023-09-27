extends AnimationPlayer

func _on_race_start():
	call_deferred("stop")
	call_deferred("play", "spaceship_train_movement")
	pass
