extends Label

func _physics_process(delta):
	set_text(str("BEST:", round(game_data.player.best_time)))
	pass
