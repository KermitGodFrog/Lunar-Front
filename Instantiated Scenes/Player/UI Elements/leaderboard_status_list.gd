extends ItemList

func update(scores):
	clear()
	add_item(str(global_data.player_name, ": "))
	var add_player_score = add_item(str(snapped(global_data.get_best_time_current_map(), 0.001)))
	set_item_custom_bg_color(add_player_score, Color.DARK_RED)
	
	for score in scores:
		add_item(str(score.player_name, ": "))
		var add_online_player_score = add_item(str(snapped(score.score, 0.001)))
		set_item_custom_bg_color(add_online_player_score, Color.DARK_GREEN)
	pass
