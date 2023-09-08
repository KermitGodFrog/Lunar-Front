extends TextureRect

var tween

func _ready():
	game_data.hud_effect = self

func show_effect(initial_color: Color, time: float):
	show()
	set_modulate(initial_color)
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "modulate", Color(initial_color.r, initial_color.g, initial_color.b, 0), time).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(self.hide)
	pass
