extends TextureRect
var no_medal = preload("res://Graphics/Medals/no_medal.png")

var tween

func update_medal():
	var medal = global_data.get_medal_current_map()
	if medal != null:
		set_texture(medal)
	else:
		set_texture(no_medal)
	
	if tween:
		tween.kill()
	
	set_rotation(deg_to_rad(0))
	tween = create_tween()
	tween.tween_property(self, "rotation", deg_to_rad(360), 1).set_trans(Tween.TRANS_CUBIC)
	pass
