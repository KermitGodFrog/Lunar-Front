extends TextureRect

func _physics_process(delta):
	size.x = maxi(0, game_data.player.BOOST_TIME)
	
	if game_data.player.BOOST_TIME <= 300:
		set_modulate(Color.WHITE)
	if game_data.player.BOOST_TIME > 300 and game_data.player.BOOST_TIME <= 600:
		set_modulate(Color.CYAN)
	if game_data.player.BOOST_TIME > 600:
		set_modulate(Color.GOLD)
	pass
