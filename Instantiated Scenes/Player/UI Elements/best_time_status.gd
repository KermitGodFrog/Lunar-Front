extends Label

func _physics_process(delta):
	set_text(str("PR: ", snapped(global_data.get_best_time_current_map(), 0.001)))
	pass
