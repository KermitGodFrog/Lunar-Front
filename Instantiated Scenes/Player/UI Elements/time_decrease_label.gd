extends Label

var tween


func show_new_time(time: float):
	set_text(str("- ", snapped(time, 0.001)))
	set_modulate(Color(255, 255, 255, 255))
	show()
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "modulate", Color(255, 255, 255, 0), 5).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(self.hide)
	pass
