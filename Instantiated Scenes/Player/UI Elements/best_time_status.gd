extends Label

func _physics_process(_delta):
	set_text(str("PR: ", snapped(global_data.get_best_time_current_map(), 0.01)))
	pass
