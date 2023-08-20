extends TextureRect
var fa_png = preload("res://Instantiated Scenes/Player/fa_png.png")
var dc_png = preload("res://Instantiated Scenes/Player/dc_png.png")

func _physics_process(delta):
	match game_data.player.is_fa_toggle:
		true:
			set_texture(fa_png)
		false:
			set_texture(dc_png)
	pass
