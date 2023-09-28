extends Button

@export var for_map_identifiers: PackedStringArray

func _on_pressed():
	for map in for_map_identifiers:
		if global_data.get_best_time_from_map(map) == 0:
			pass
		else:
			var scores = []
			var sw_player_scores: Dictionary = await SilentWolf.Scores.get_scores_by_player(global_data.player_name, 100, str(map, "_map")).sw_get_player_scores_complete
			scores = sw_player_scores["scores"]
			
			if len(scores) > 1 and scores[0].score > scores[-1].score:
				scores.reverse()
			
			var final_scores = []
			for score in scores:
				final_scores.append(score["score"])
			
			if final_scores.size() > 0:
				print("final scores ", final_scores)
				print("final scores 0 ", final_scores[0])
				print("best time from map ", global_data.get_best_time_from_map(map))
				
				print("final scores 0 rounded ", round(final_scores[0]))
				print("best time from map rounded ", round(global_data.get_best_time_from_map(map)))
				
				if round(final_scores[0]) > round(global_data.get_best_time_from_map(map)):
					
					#THIS IS A REALLY BAD IDEA, IF THE OFFLINE SCORE IS LOWER THAN THE SAVED SCORE BY LIKE 0.1 SECONDS THEN IT WILL FAIL. BUT FLOATING POINT INNACURACY IS A BITCH SO FIGURE SOMETHING OUT LATER.
					
					var sw_save_score: Dictionary = await SilentWolf.Scores.save_score(global_data.player_name, global_data.get_best_time_from_map(map), str(map, "_map")).sw_save_score_complete
					
	pass

#pretty sure this works
