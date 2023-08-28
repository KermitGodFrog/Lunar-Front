extends Label
var tween

func tween_new_time(time: float):
	set_text(str("- ", time))
	set_modulate(Color(255, 255, 255, 255))
	
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 3)
	pass
