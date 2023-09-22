extends Button

func _on_pressed():
	global_data.reset_player_data()
	global_data.save_player_data()
	pass 
