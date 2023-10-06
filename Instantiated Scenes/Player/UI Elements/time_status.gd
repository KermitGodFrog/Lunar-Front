extends Label

var tween

func _physics_process(_delta):
	set_text(str(snapped(game_data.player.current_time, 0.001)))
	pass

func _on_race_start():
	set_physics_process(false)
	
	race_start_blink()
	await get_tree().create_timer(2).timeout
	
	set_physics_process(true)
	pass

func race_start_blink():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "theme_override_colors/font_color", Color.WEB_GRAY, 0.5)
	tween.tween_property(self, "theme_override_colors/font_color", Color.WHITE, 0.5)
	tween.tween_property(self, "theme_override_colors/font_color", Color.WEB_GRAY, 0.5)
	tween.tween_property(self, "theme_override_colors/font_color", Color.WHITE, 0.5)
	pass
