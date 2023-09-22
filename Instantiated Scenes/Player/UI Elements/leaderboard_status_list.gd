extends ItemList
class_name PlayerCenteredLeaderboard

func _ready():
	await get_tree().physics_frame
	update()
	pass

func update():
	clear()
	add_item("Loading scores...")
	var sw_scores_around = await SilentWolf.Scores.get_scores_around(global_data.get_best_time_current_map(), 6, str(map_data.map_identifier, "_map")).sw_get_scores_around_complete
	render(sw_scores_around.scores_below)
	pass

func render(scores):
	clear()
	#add_item(str(global_data.player_name, ": "))
	#var add_player_score = add_item(str(snapped(global_data.get_best_time_current_map(), 0.001)))
	#set_item_custom_bg_color(add_player_score, Color.DARK_RED)
	
	for score in scores:
		add_item(str(score.player_name, ": "))
		var add_online_player_score = add_item(str(snapped(score.score, 0.001)))
		
		if score.player_name == global_data.player_name:
			set_item_custom_bg_color(add_online_player_score, Color.DARK_RED)
		else:
			set_item_custom_bg_color(add_online_player_score, Color.DARK_GREEN)
	pass
