extends Label

func _physics_process(delta):
	set_text(str("HI:", round(game_data.player.best_time)))
	pass
