extends Label

func _physics_process(delta):
	set_text(str("BEST:", round(global_data.get_best_time_current_map())))
	pass
