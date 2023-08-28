extends Label

func _physics_process(delta):
	set_text(str(round(game_data.player.current_time)))
	pass
