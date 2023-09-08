extends Label

func _physics_process(delta):
	set_text(str(snapped(game_data.player.current_time, 0.001)))
	pass
