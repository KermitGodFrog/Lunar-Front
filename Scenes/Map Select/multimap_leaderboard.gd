extends ItemList
class_name GlobalLeaderboard

func update(leaderboard_identifier: String):
	clear()
	var scores = []
	if leaderboard_identifier in SilentWolf.Scores.leaderboards:
		scores = SilentWolf.Scores.leaderboards[leaderboard_identifier]
	
	if len(scores) > 0:
		render(scores)
	else:
		var sw_get_high_scores = await SilentWolf.Scores.get_scores(0, leaderboard_identifier).sw_get_scores_complete
		scores = sw_get_high_scores["scores"]
		render(scores)
	pass

func render(scores):
	if len(scores) > 1 and scores[0].score > scores[-1].score:
		scores.reverse()
	
	for i in range(len(scores)):
		var score = scores[i]
		add_item(str(score.player_name, ": "))
		add_item(str(snapped(score.score, 0.001)))
	pass

func _on_scrapyard_button_mouse_entered():
	update("scrapyard_map")
	pass

func _on_test_map_button_mouse_entered():
	update("test_map")
	pass 
