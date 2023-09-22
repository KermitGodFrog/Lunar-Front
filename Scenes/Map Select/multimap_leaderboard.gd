extends ItemList
class_name GlobalLeaderboard

func update(leaderboard_identifier: String):
	clear()
	var scores = []
	if leaderboard_identifier in SilentWolf.Scores.leaderboards:
		scores = SilentWolf.Scores.leaderboards[leaderboard_identifier]
	
	get_tree().call_group("leaderboard_origin_label", "update", leaderboard_identifier)
	
	if len(scores) > 0:
		render(scores)
	else:
		add_item("Loading scores...")
		var sw_get_high_scores = await SilentWolf.Scores.get_scores(0, leaderboard_identifier).sw_get_scores_complete
		scores = sw_get_high_scores["scores"]
		render(scores)
	pass

func render(scores):
	clear()
	if len(scores) > 1 and scores[0].score > scores[-1].score:
		scores.reverse()
	
	for i in range(len(scores)):
		var score = scores[i]
		
		var add_player_name = add_item(str(score.player_name, ": "))
		var add_score = add_item(str(snapped(score.score, 0.001)))
		
		if score.player_name == global_data.player_name:
			set_item_custom_bg_color(add_score, Color.GREEN)
		
		match i:
			0:
				set_item_custom_bg_color(add_score, Color.MEDIUM_AQUAMARINE)
			1:
				set_item_custom_bg_color(add_score, Color.GOLD)
			2:
				set_item_custom_bg_color(add_score, Color.WEB_GRAY)
			3:
				set_item_custom_bg_color(add_score, Color.BROWN)
			_:
				pass
	pass

func _on_scrapyard_button_mouse_entered():
	update("scrapyard_map")
	pass

func _on_test_map_button_mouse_entered():
	update("test_map")
	pass 
