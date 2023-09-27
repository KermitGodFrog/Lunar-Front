extends Button

func _on_pressed():
	global_data.reset_player_data()
	global_data.save_player_data()
	get_tree().change_scene_to_file("res://Scenes/Name Setting/name_setting.tscn")
	pass 
