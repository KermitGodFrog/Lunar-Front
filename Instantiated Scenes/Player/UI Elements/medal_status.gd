extends TextureRect

func _ready():
	update_medal()
	pass

func update_medal():
	var medal = global_data.get_medal_current_map()
	if medal != null:
		set_texture(medal)
	pass
