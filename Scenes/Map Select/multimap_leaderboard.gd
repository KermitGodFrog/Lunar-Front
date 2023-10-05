extends ItemList
class_name GlobalLeaderboard

var last_selected_map: String

func update(leaderboard_identifier: String, force_update: bool):
	clear()
	var scores = []
	if force_update == false:
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
		
		if score.player_name.match(global_data.player_name) == true:
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
	update("scrapyard_map", false)
	get_tree().call_group("map_par_times_handler", "update", "scrapyard")
	get_tree().call_group("background_handler", "update", "scrapyard")
	last_selected_map = "scrapyard_map"
	pass

func _on_fleet_button_mouse_entered():
	update("fleet_map", false)
	get_tree().call_group("map_par_times_handler", "update", "fleet")
	get_tree().call_group("background_handler", "update", "fleet")
	last_selected_map = "fleet_map"
	pass

func _on_asteroid_refinery_button_mouse_entered():
	update("asteroid_refinery_map", false)
	get_tree().call_group("map_par_times_handler", "update", "asteroid_refinery")
	get_tree().call_group("background_handler", "update", "asteroid_refinery")
	last_selected_map = "asteroid_refinery_map"
	pass

func _on_trade_route_button_mouse_entered():
	update("trade_route_map", false)
	get_tree().call_group("map_par_times_handler", "update", "trade_route")
	get_tree().call_group("background_handler", "update", "trade_route")
	last_selected_map = "trade_route_map"
	pass 
