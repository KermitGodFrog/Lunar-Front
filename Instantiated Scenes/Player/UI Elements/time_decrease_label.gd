extends Label

var SPAWN_TIME: float = 1.0

func show_new_time(time: float):
	set_text(str("- ", time))
	show()
	
	var timer = get_tree().create_timer(SPAWN_TIME)
	await timer.timeout
	
	hide()
	pass
